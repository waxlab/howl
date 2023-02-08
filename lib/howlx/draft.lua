--| # Draft generation
--|
--| You can start your project and annotate your files freely,
--| then, when it is ready, just head to the project root
--| directory and run:
--|
--|     howlx draft
--|
--| It will recursively descend through your directory tree
--| looking for file formats supported with the howl marks.
--|
--| The files found in the process are stored in the file `howl.lua`
--| stored at the root folder of your project.
--|
--| You can, then, open the generated file, reorder the files
--| or adjust the document nesting.


local fs = require 'wax.fs'

local pat = [[{ %q, %q }]]
local outname
local discover
local howly
local writer
local cat = table.concat

local enabled = {
  lua = '%-%-',
  c   = '//',
  h   = '//',
  md  = true
}



function writer(file)
  local fh = assert(io.open(file,'w'))
  return function(t) fh:write(t) fh:write '\n' end
       , function()  fh:close()  end
end


function howly(p)
  local ext = (p:match('%.(%w+)$') or ''):lower()
  local mark = enabled[ext]

  if not mark     then return false end
  if mark == true then return true  end

  local pat = ([=[^%s[${}|]]=]):format(mark)
  local fh = io.open(p)
  local line
  repeat
    line = fh:read()
    if line and line:match(pat) then
      return true
    end
  until not line
  return false
end



function outname(p)
  return ([[%s_%s]]):format(
    fs.basename(fs.dirname(p)):gsub('%W',''),
    fs.basename(p):gsub('%.[^.]+$',''):gsub('%W','')
  )
end



function discover(path, restable, i)
  for p in fs.glob((path or '')..'*') do
    if fs.isdir(p) then
      i = discover(p..'/', restable, i)
    else
      if (howly(p)) then
        i = i + 1
        restable[i]= pat:format(outname(p),p)
      end
    end
  end
  return i
end


local res = {}
assert(discover(false, res, #res) > 0,
      'No files documented found, add documentation marks and try again')

local file = fs.isfile 'howl.lua' and 'howl.draft.lua' or 'howl.lua'

local w,c = writer(file)
w '-- docname specifies an unique identifier for documentation'
w 'name = ""\n'
w '-- The following list has pairs `doc name` and `file name`.'
w '-- Reorder and nest its elements adequating to your documentation'
w '-- structure needs.'
w 'tree = {'
for _,entry in ipairs(res) do
  w ("\t"..entry..",")
end
w '}\n'
w '-- You can alternatively specify a tree with subdocs:'
w '-- tree = {'
w '--   { "intro", "doc/intro.md", {'
w '--     { "usage", "doc/usage.md" },'
w '--     { "about", "doc/about.md" },'
w '--   },'
w '--   { "recipes", "doc/recipes.md", {'
w '--     { "funcs", "test/funcs.lua" },'
w '--     { "math",  "test/math.lua" },'
w '--   }'
w '-- }'
c()
