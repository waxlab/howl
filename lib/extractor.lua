local function ltrim(s) return s:gsub('^%s+','') or '' end
local function rtrim(s) return s:gsub('%s+$','') or '' end
local function trim(s)  return ltrim(rtrim(s))         end
local function isempty(s) return trim(s):len() == 0 end
local function
  topen(t)
    if not t or type(t) ~= 'table' then return nil end
    local i = 0
    local f = function(self)
      i = i+1
      return self[i] or nil, 'end content'
    end
    setmetatable(t, { __index = { read = f }})
    return t
end
local unpack = unpack or table.unpack


local pub_parse
    , parse
    , root_blocks
    , child_blocks
    , md_head
    , md_pre
    , md_code
    , md_quote
    , md_ol
    , md_para
    --, md_table
    --, md_ul


function
  md_ol(fh, ln)
    if not ln then return end

    local shift, content = ln:match '^(%s?%s?%s?)%d+%.%s+(.*)'
    if not content then return nil, ln end
    shift = '^'..shift
    local mblock = ''
    local item, ipos = {content}, 2
    local list, lpos = {type='ol', item}, 2
    ln = fh:read()

    while ln and mblock do
      repeat
        content = ln:match (shift..'%d+%.%s+(.*)')
        if content then
          item, ipos = {content}, 2
          list[lpos], lpos = item, lpos+1
          ln = fh:read()
          mblock = ''
          break
        end

        content = ln:match(shift..'%s+%d+%.%s+')
        if content then
          mblock = '%s+'
          item[ipos],ipos = '', ipos+1
        end

        if isempty(ln)
          then content, mblock = '', '%s+'
          else content = ln:match(shift..'('..mblock..'.*)')
        end

        if content then
          item[ipos], ipos, ln = content, ipos+1, fh:read()
          break
        end
        mblock = false
      until not mblock
    end

    for i,v in ipairs(list) do
      list[i] = { type='ol', unpack(parse(topen(v), child_blocks)) }
      if #(list[i]) == 1 and list[i][1].type == 'para' then
        list[i] = { unpack(list[i][1]) }
      end
    end
    return list, ln
end


function
  md_head(fh, ln)
    local lvl, txt

    if not ln then return end
    lvl, txt = ln:match '^(#+)%s(.*)'
    if not lvl then
      return nil, ln
    end
    return {type='head', level=lvl:len(), trim(txt)}, fh:read()
end


function
  md_pre(fh, ln)
    local pos, wait, res, b, content = 1, false
    while 1 do repeat -- :: begin ::
      if not ln then return res end
      b, content = ln:match('^(    )(.*)')
      if not b then
        if not res then return nil, ln end
        if isempty(ln) then
          wait = wait and wait+1 or 1
          ln = fh:read()
          break
        else
          return res, ln
        end
      end
      res = res or { type='pre' }
      if wait then
        for i=pos, pos+wait-1, 1 do res[i] = '' end
        pos, wait = pos + wait , nil
      end
      res[pos], pos, ln = content, pos+1, fh:read()
    until nil end
end


function
  md_code(fh, ln)
    local pos, res, b, l = 1

    repeat -- :: begin ::
      if not ln then return res end
      b,l = ln:match '^(```)%s*(%w*)$'
      if b then
        if res then return res, fh:read() end -- ``` final
        ln, pos = fh:read(), 1                -- ``` initial
        res = { type='code', lang=l:len() > 0 and l or nil }
      elseif not res then
        return res, ln
      else
        res[pos], ln, pos = ln, fh:read(), pos+1 -- pending delimiter
      end
    until nil
end


function
  md_quote(fh, ln)
    local pos, res, b, content = 1

    repeat -- :: begin ::
      if ln then
        b, content = ln:match '^(%s*)>(.*)'
      end

      if not ln or not b or b:len() > 3 then
        if not res or #res < 1 then
          return {}, ln
        end
        return { type = 'quote', unpack(parse(topen(res), child_blocks)) }, ln
      end

      res = res or {} -- no type, it will be used as pseudofile
      res[pos] = content
      ln, pos = fh:read(), pos+1
    until nil -- goto begin
end


function
  md_para(fh, ln)
    local pos, res = 1

    repeat
      if not ln then return res end
      ln = trim(ln)
      if ln:len() == 0 then
        return res, fh:read()
      end
      res = res or {type='para'}
      res[pos], pos, ln = ln, pos+1, fh:read()
    until nil
end


-- Enforce sequence and priority for correct block type detection
child_blocks =
  { md_code
  , md_quote
  , md_ol
  , md_para
  --, md_table
  --, md_ul
  }
root_blocks =
  { md_head
  , md_pre
  , unpack(child_blocks)
  }

-- Goto not works on Lua < 5.2, while recursive tail call yes.
-- We use the repeat+break to emulate goto on 5.1
function
  pub_parse(fh)
    return parse(fh, root_blocks)
end


function
  parse(fh, blocks)
    local ln, tree, pos = fh:read(), {}, 1

    repeat -- :: begin ::
      if not ln then return tree end
      for _, f in ipairs(blocks) do
        local res
        res, ln = f(fh,ln)
        if res and #res > 0 then
          tree[pos] = res
          if ln then
            pos=pos+1
            break -- goto begin
          end
          return tree
        end
      end
    until nil -- goto begin
end



return {
  parse = pub_parse
}
