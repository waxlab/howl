local block = {}

local h1 = string.rep('=',60)
local h2 = string.rep('-',60)


local function tokenize(name)
  return name
    :gsub('[^%w]+','.')
    :gsub('^%.','')
    :gsub('%.$','')
end


local function hyphenize(name, pfx)
  return ('%s/%s')
    :format(
      pfx,
      name
        :gsub('[^%w]+','-')
        :gsub('^%-','')
        :gsub('%-$','')
    )
end


function block.sign(sign)
  local t = { '','',h2,'*'..sign.name..'*','' }
  for _,s in ipairs(sign) do t[#t+1] = '`'..s..'`\n' end
  return table.concat(t, '\n')
end


function block.text(text)
  local res, r, code = {}, 1
  for _, t in ipairs(text) do
    if t:match('^```') then
      if code then
        res[r], code = '<', false
      else
        res[r], code = '>', true
      end
    else
      res[r] = code and (' '..t) or t
    end
    r=r+1
  end

  return '\n\n'..table.concat(res,'\n')
end


function block.code(code)
  local t = {'','','>'}
  for _,l in ipairs(code) do t[#t+1] = ' '..l end
  t[#t+1]='<'
  return table.concat(t, '\n')
end


function block.head(head)
  local t
  if head.level == 1 then
    t = {'','',h1,head[1]:upper()}
  else
    t = {'','',h2,head[1]}
  end
  return table.concat(t, '\n')
end


return function(conf, doctree)
  local fh = io.open(('%s/%s.txt'):format(conf.to,conf.pfx),'w+')

  for _, tree in ipairs { 'manual', 'api' } do
    if t == 'api' and #doctree.api > 0 then
      fh:write('\n\n'..h1..'\n\n API\n\n')
    end

    for f, file in ipairs(doctree[tree]) do
      for _, b in ipairs(file) do
        fh:write( block[b.type](b) )
        if b.type == 'head' and b.level == 1 then
          if tree == 'api' then
            fh:write(' *'..tokenize(file.name)..'* ')
          else
            fh:write(' *'..hyphenize(file.name, conf.pfx)..'* ')
          end
        end
      end
    end
  end

  fh:write('vim:wrap:norl:')
  fh:close()
end
