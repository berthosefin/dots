import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { homedir } from "node:os";
import { fileURLToPath } from "node:url";

// Locate `hook.sh` (the thin wrapper that late-binds the Rust binary).
// The bridge now lives in the user's dots repo, far from the tmux plugin
// directory, so we cannot rely on walking up from this file alone. We probe
// every known TPM install location first, then fall back to the walk-up for
// in-repo usage (e.g. the upstream checkout).
const resolveHookScript = () => {
  const candidates = [];
  const pluginRoots = [
    process.env.TMUX_PLUGIN_MANAGER_PATH,
    join(homedir(), ".config", "tmux", "plugins"),
    join(homedir(), ".tmux", "plugins"),
  ].filter(Boolean);
  for (const root of pluginRoots) {
    candidates.push(join(root, "tmux-agent-sidebar", "hook.sh"));
  }

  let dir = dirname(fileURLToPath(import.meta.url));
  for (let i = 0; i < 4; i += 1) {
    candidates.push(resolve(dir, "hook.sh"));
    const parent = dirname(dir);
    if (parent === dir) {
      break;
    }
    dir = parent;
  }

  for (const candidate of candidates) {
    if (existsSync(candidate)) {
      return candidate;
    }
  }
  return null;
};

const HOOK_COMMAND = (() => {
  const hookScript = resolveHookScript();
  return hookScript
    ? { cmd: "bash", prefix: [hookScript, "opencode"] }
    : { cmd: "tmux-agent-sidebar", prefix: ["hook", "opencode"] };
})();

// Fire-and-forget: OpenCode dispatches event hooks without awaiting the
// returned promise, so serializing subprocess exits would only add latency
// without backpressure.
const hook = (eventName, payload) => {
  try {
    const child = spawn(HOOK_COMMAND.cmd, [...HOOK_COMMAND.prefix, eventName], {
      stdio: ["pipe", "ignore", "ignore"],
    });
    child.on("error", () => {});
    child.stdin.on("error", () => {});
    child.stdin.end(JSON.stringify(payload));
  } catch {
    // OpenCode should keep running even if the bridge is missing or
    // the sidebar binary is unavailable.
  }
};

const pickFirstString = (value, keys) => {
  for (const key of keys) {
    const candidate = value?.[key];
    if (typeof candidate === "string" && candidate) {
      return candidate;
    }
  }
  return "";
};

const errorMessage = (err) => {
  if (!err) return "";
  if (typeof err === "string") return err;
  if (typeof err === "object") {
    return pickFirstString(err, ["message", "name"]) || JSON.stringify(err);
  }
  return String(err);
};

// OpenCode V2 plugin entrypoint. The loader reads the default export's `id`
// and `setup()` (plain-object plugin definition, no @opencode/plugin import
// required: the global plugin dir does not resolve that package).
export default {
  id: "tmux-agent-sidebar",

  async setup(ctx) {
    const cwd = typeof ctx.location?.directory === "string" ? ctx.location.directory : "";

    // V1 `chat.message` -> V2 prompt hook. The prompt hook runs on durable
    // admission with the raw prompt text; no parts extraction needed.
    await ctx.session.hook("prompt", (event) => {
      const session_id = pickFirstString(event, ["sessionID", "sessionId", "session_id"]);
      const prompt = typeof event.prompt?.text === "string" ? event.prompt.text : "";
      hook("user-prompt-submit", { cwd, session_id, prompt });
    });

    // V1 `event` -> V2 event stream subscription.
    const controller = new AbortController();
    void (async () => {
      for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
        const props = event.properties ?? {};
        const session_id = pickFirstString(props, ["sessionID", "sessionId", "session_id"]);

        switch (event.type) {
          case "session.created":
            hook("session-start", { cwd, session_id, source: "startup" });
            return;

          case "session.status": {
            // Status is a plain string in V2 ("idle" | "busy" | "error" | ...).
            // `busy` is a secondary status-transition signal; the real prompt
            // text is written via the prompt hook. When both fire, the
            // empty-prompt call here is a no-op for @pane_prompt but still
            // advances status to "running" for delayed/missing prompt hooks.
            const status = props.status ?? props.status?.type;
            if (status === "busy") {
              hook("user-prompt-submit", { cwd, session_id, prompt: "" });
            } else if (status === "idle") {
              hook("stop", { cwd, session_id, last_message: "" });
            } else if (status === "error") {
              hook("stop-failure", {
                cwd,
                session_id,
                error: errorMessage(props.error) || "session.status=error",
              });
            }
            return;
          }

          case "session.idle":
            hook("stop", { cwd, session_id, last_message: "" });
            return;

          case "session.error":
            hook("stop-failure", {
              cwd,
              session_id,
              error: errorMessage(props.error) || "session.error",
            });
            return;

          case "permission.asked":
            hook("notification", { cwd, session_id, wait_reason: "permission" });
            return;
        }
      }
    })().catch(() => {});

    // V1 `tool.execute.after` -> V2 tool hook. The tool context carries
    // { tool, sessionID, agent, messageID, id, input, status, result }.
    await ctx.tool.hook("execute.after", (event) => {
      const result = event.result ?? {};
      hook("activity-log", {
        cwd,
        session_id: pickFirstString(event, ["sessionID", "sessionId", "session_id"]),
        tool_name: event.tool ?? "",
        tool_input: event.input ?? {},
        tool_response: {
          title: result.title ?? "",
          output: result.output ?? "",
          metadata: result.metadata ?? null,
        },
      });
    });

    return () => controller.abort();
  },
};