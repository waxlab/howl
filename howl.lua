-- docname specifies an unique identifier for documentation
name = "howl"
formats = {"wiki", "vimhelp"}

-- The following list has pairs `doc name` and `file name`.
-- Reorder and nest its elements adequating to your documentation
-- structure needs.
tree = {
--  { "howlx", "bin/howlx.lua", {
--    { "howlx_draft",  "lib/howlx/draft.lua" },
--    { "howlx_build",  "lib/howlx/build.lua" },
--    { "howlx_help",   "lib/howlx/help.lua"  },
--    -- { "howlx_remove", "lib/x/remove.lua" },
--  }},
  { "howlx",   "bin/howlx.lua" },
  { "_readme", "readme.md" },
}

-- You can alternatively specify a tree with subdocs:
-- tree = {
--   { "intro", "doc/intro.md", {
--     { "usage", "doc/usage.md" },
--     { "about", "doc/about.md" },
--   },
--   { "recipes", "doc/recipes.md", {
--     { "funcs", "test/funcs.lua" },
--     { "math",  "test/math.lua" },
--   }
-- }
