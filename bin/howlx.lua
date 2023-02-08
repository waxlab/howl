-------------------------------------------------------------------
--| # howlx
--| Annotation extractor and documentation generator.
--|
--| Howlx detects annotations on your code and
--| generate a draft configuration. Then you can edit that
--| configuration reordering, changing nesting and values
--| that will be used in the process of document generation.
--|
--| There are different actions that can be performed:
-------------------------------------------------------------------

local fs   = require 'wax.fs'
local args = require 'wax.args'


-- Main execution --

local actions = {
  build = 'howl.howlx.build',
  draft = 'howl.howlx.draft',
  help  = 'howl.howlx.help',
  rm    = 'howl.howlx.remove',
}

local action = table.remove(arg,1)

require( action and actions[action] or action.help )
