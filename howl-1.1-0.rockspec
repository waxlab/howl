rockspec_format = "3.0"
package = "howl"
version = "1.1-0"
source = {
  url = "git+https://codeberg.org/waxlab/howl",
  branch = 'v1.1'
}

description = {
  homepage = "https://codeberg.org/waxlab/howl/readme.md",
  license = "MIT"
}

build = {
  type = "builtin",
  modules = {
    --[[
    -- formatters
    ['howl.out.wiki']    = 'lib/out/wiki.lua',
    ['howl.out.vimhelp'] = 'lib/out/vimhelp.lua',

    -- parsers
    ['howl.in.md']     = 'lib/in/md.lua',
    ['howl.in.lua']    = 'lib/in/lua.lua',
    --]]
    ['howl.fn']  = 'lib/fn.lua',
    ['howl.def'] = 'lib/def.lua',
    ['howl.extractor'] = 'lib/extractor.lua',
    -- bin actions
    ['howl.howlx.draft'] = 'lib/howlx/draft.lua',
    ['howl.howlx.build'] = 'lib/howlx/build.lua',
    ['howl.howlx.help']  = 'lib/howlx/help.lua',
  },
  install = {
    bin = {
      howl  = 'bin/howl.lua',
      howlx = 'bin/howlx.lua'
    }
  }
}

dependencies = {
  "lua >= 5.2, < 5.5",
  "wax"
}
