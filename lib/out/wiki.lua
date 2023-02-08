local waxfs = require 'wax.fs'


local f_idxurl = '%s- [%s](%s)'
local f_sigurl = '%s- [%s](%s#%s)'

local function tokenize(name)
  return name:gsub('[^%w]+','-'):gsub('^%-',''):gsub('%-$','')
end


local function genindex(doctree)
  local idx, lvl = {}, 1
  for f, file in ipairs(doctree) do
    local sep = false
    local name = tokenize(file.name)
    for _, b in ipairs(file) do
      if b.type == 'head' and b.level == 1 then
        idx[#idx+1] = f_idxurl:format( ('  '):rep(b.level-1), b[1], name )
      end
    end
  end
  return table.concat(idx,'\n')
end


local block = {}
function block.sign(sign)
  local t={'\n\n###### ',sign.name,'\n'}
  for _,b in ipairs(sign) do
    t[#t+1] = '- **`'..b..'`**\n'
  end
  return table.concat(t)..'\n'
end


function block.text(text)
  return '\n'..table.concat(text,'\n')
end


function block.code(code)
  local t = {'\n\n```lua'}
  for _,line in ipairs(code) do t[#t+1] = line:gsub('^(.+)$','  %1') end
  t[#t+1] = '```\n'
  return table.concat(t,'\n')
end


function block.head (head)
  return ('\n\n%s %s\n'):format(('#'):rep(head.level), head[1])
end


return function(conf, doctree)
  assert(waxfs.mkdirs(conf.to,'0755'))

  for _, tree in ipairs { 'manual', 'api' } do
    for f, file in ipairs(doctree[tree]) do
      local fh = io.open(('%s/%s.md'):format(conf.to, tokenize(file.name)), 'w+')
      local doc = { name = file.name }
      for _, b in ipairs(file) do
        b = block[b.type](b)
        fh:write(b)
      end
      fh:close()
    end
  end

  local manual_index = genindex(doctree.manual)
  local api_index = genindex(doctree.api)
  fh = io.open(('%s/%s.md'):format(conf.to, '_Sidebar'), 'w+')
  fh:write('- [Home](Home)\n\n--------\n\n')
  fh:write( api_index )
  fh:close()

  fh = io.open(('%s/%s.md'):format(conf.to, 'Home'), 'w+')
  fh:write( manual_index )
  fh:write( '\n\n# Api\n\n' )
  fh:write( api_index )
  fh:close()
end
