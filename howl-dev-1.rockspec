package = "howl"
version = "dev-1"
source = {
  url = "https://codeberg.org/waxlab/howl"
}

description = {
  homepage = "https://codeberg.org/waxlab/howl/readme.md",
  license = "MIT"
}

build = {
  type = "builtin",
  modules = {
    ['howl.parse.md' ] = 'lib/parse/md.lua',
    ['howl.parse.lua'] = 'lib/parse/lua.lua',
    ['howl.format.wiki' ] = 'lib/format/wiki.lua',
  },
  install = {
    bin = {
      howl = 'bin/howl.lua'
    }
  }
}

dependencies = {
  "lua >= 5.2",
  "wax"
}
