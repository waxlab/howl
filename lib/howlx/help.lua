--| # Generator help
--|
--| To see the full help on command line you can:
--|
--|     howlx help

print [[
 usage: howlx <action> [<p>]

 action:

   draft       Create a draft configuration as howl.lua or, if the
               file already exists, at howl.draft.lua

   build <p>   Build documentation using <p> as the Howl config.
               Documentation is saved at ~/.howl/<F>/<N> where
               - <F> the output format generated
               - <N> the project name found on config howl.lua

               If unspecified, <p> defaults to howl.lua at current
               directory.

   remove <p>  Remove any documentation matching the <N> name

   help        Show this help
]]

-- vim: colorcolumn=66
