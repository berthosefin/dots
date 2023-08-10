// common
const WP = `/home/${ags.Utils.USER}/Images/`;

const editScheme = (scheme, edit) => {
  const obj = {};
  Object.keys(scheme).forEach((color) => (obj[color] = edit(scheme[color])));
  return obj;
};

const dark = {
  color_scheme: "dark",
  bg_color: "#171717",
  fg_color: "#eee",
  hover_fg: "#f1f1f1",
};

const light = {
  color_scheme: "light",
  bg_color: "#fffffa",
  fg_color: "#141414",
  hover_fg: "#0a0a0a",
  // ...editScheme(color, (c) => `darken(${c}, 8%)`),
};

const misc = {
  wm_gaps: 5,
  radii: 5,
  spacing: 5,
  shadow: "rgba(0, 0, 0, .6)",
  drop_shadow: true,
  transition: 200,
  screen_corners: true,
  bar_style: "normal",
  layout: "topbar",
  desktop_clock: "center center",
};

const colors = {
  wallpaper_fg: "white",
  hypr_active_border: "rgba(3f3f3fFF)",
  hypr_inactive_border: "rgba(3f3f3fDD)",
  accent: "$blue",
  accent_fg: "#141414",
  widget_bg: "$fg_color",
  widget_opacity: 94,
  active_gradient: "to right, $accent, lighten($accent, 10%)",
  border_color: "$fg_color",
  border_opacity: 97,
  border_width: 2,
};

// themes
/* exported nord dracula gruvbox */
var nord = {
  wallpaper: WP + "Nord/ign_unsplash38.png",
  name: "nord",
  icon: "󰄛",
  ...dark,
  ...misc,
  ...colors,
  red: "#BF616A",
  green: "#A3BE8C",
  yellow: "#EBCB8B",
  blue: "#81A1C1",
  magenta: "#B48EAD",
  teal: "#88C0D0",
  orange: "#BF616A",
  bg_color: "#2E3440",
  fg_color: "#D8DEE9",
  hover_fg: "#ECEFF4",
  hypr_active_border: "rgba(81A1C1ee)",
  hypr_inactive_border: "rgba(4C566Aaa)",
};

var dracula = {
  wallpaper: WP + "Dracula/arch.png",
  name: "dracula",
  icon: "󰄛",
  ...dark,
  ...misc,
  ...colors,
  red: "#FF5555",
  green: "#50FA7B",
  yellow: "#F1FA8C",
  blue: "#BD93F9",
  magenta: "#FF79C6",
  teal: "#8BE9FD",
  orange: "#FF6E6E",
  bg_color: "#282A36",
  fg_color: "#F8F8F2",
  hover_fg: "#FFFFFF",
  hypr_active_border: "rgba(BD93F9ee)",
  hypr_inactive_border: "rgba(6272A4aa)",
};

var gruvbox = {
  wallpaper: WP + "Gruvbox/leaves-3.jpg",
  name: "gruvbox",
  icon: "󰄛",
  ...dark,
  ...misc,
  ...colors,
  red: "#cc241d",
  green: "#98971a",
  yellow: "#d79921",
  blue: "#458588",
  magenta: "#b16286",
  teal: "#689d6a",
  orange: "#fb4934",
  bg_color: "#282828",
  fg_color: "#ebdbb2",
  hover_fg: "#ebdbb2",
  hypr_active_border: "rgba(458588ee)",
  hypr_inactive_border: "rgba(928374aa)",
};
