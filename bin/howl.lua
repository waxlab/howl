local USAGE = [[

Usage:

COMMAND [--fmt <format>] --in <inputdir> <outputdir>

  format:  wiki, vim, html

]]


-- DOCTREE[#file] = {
--   name = "string",
--   {
--     type  = "head" or "code" or "sign" or "text",
--     level = 1..6,   -- for type="head"
--     lang  = "lua",  -- for type="code"
--     name  = "",     -- for type="sign"
--     "" -- content
--   },
--   ...
-- }


local waxfs = require 'wax.fs'
local warg = require 'wax.arg'




local parser = {
  md  = require 'howl.parse.md',
  lua = require 'howl.parse.lua'
}

local format = {
  wiki = require 'howl.format.wiki'
}

local -- functions --
  read_dir,
  read_file,
  assert_cli


assert_cli =
  function (test, ...)
    if not test then
      io.stdout:write(table.concat({...},"\n"))
      os.exit(1)
    else
      return test
    end
  end

read_dir =
  function (dir, doctree, refdir)
    for item in waxfs.listex(dir..'/*') do
      if waxfs.isdir(item) then
        read_dir(item, doctree, refdir)
      else
        assert( read_file(item, doctree, refdir) )
      end
    end
  end


read_file =
  function (file, doctree, refdir)
    local _, name, ext, content
    _, name = file:find(refdir)
    name, ext = file:sub(name+2):match('(.*)%.([^.]+)$')

    if ext == 'lua' then
      local filetree = parser.lua(file)
      if not filetree then
        return nil, ('error parseing Lua %s'):format(file)
      end
      filetree.name = name
      doctree.api[#doctree.api + 1] = filetree
      doctree[#doctree.api + 1] = filetree

    elseif ext == 'md' then
      local filetree = parser.md(file)
      if not filetree then
        return nil, ('error parsing MD %s'):format(file)
      end
      filetree.name = name
      doctree.manual[#doctree.manual + 1] = filetree
    end

    return true
  end


-- Main execution --

local cli = warg.parse()

fmt     = assert_cli( cli.opt.fmt,   'Unspecified output format', USAGE)
dir_in  = assert_cli( cli.opt['in'], 'Unspecified source dir',    USAGE)
dir_out = assert_cli( cli.arg[1],    'Unspecified target dir',    USAGE)


if not waxfs.isdir(dir_out) then
  assert(waxfs.mkdirs(dir_out,'0755'))
end
dir_out = waxfs.realpath(dir_out)


local doctree = {manual = {}, api={}}
for _, dir in ipairs(dir_in) do
  assert(waxfs.isdir(dir), dir)
  dir = waxfs.realpath(dir)
  read_dir(dir, doctree, dir)
end

for _,f in ipairs(fmt) do
  format[f](dir_out, doctree)
end

