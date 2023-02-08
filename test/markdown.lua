
local fn_print
do
  local topen = '%s[%q] = {'
  local tclose = '%s}'
  local tab = '    '
  local kv = '%s[%q] = ·%s·'
  local beautify

  function beautify(k,v,l)
    if type(v) == 'table'
      then
        local t = {}
        t[#t+1] = topen:format(tab:rep(l),k or '')
        for kk,vv in pairs(v) do
          t[#t+1] = beautify(kk,vv,l+1)
        end
        t[#t+1] = tclose:format(tab:rep(l))
        return table.concat(t,'\n')
      else
        return k and kv:format(tab:rep(l),k,v) or v
    end
  end
  function fn_print(v,k)
    k = k or ('LINE %q'):format(debug.getinfo(2,'l').currentline)
    print(beautify(k,v,0))
  end
end


local x = assert(loadfile('./lib/extractor.lua'))()
local fs= require 'wax.fs'

local file_md = '/tmp/howl_test_example.md'
local file_lua = '/tmp/howl_test_example.md'


do local fh <close> = io.open(file_md,'w+')
--[=[
fh:write[[
1. first item
  2. subitem
2. second item
containing multiple lines
  of content
3. third item
also with more lines
]]
--]=]
fh:write[[

# Head no 1

 Paragraph
continued
no 2

Paragraph
    block 3

    Pre
    block 4.1

    Pre block 4.2

    Pre block 4.3
      Continuation
    of three lines

1. List block 5
  1. With subitem
    1. And sub subitem
  2. > Sub 2 of Block 5
     > Quote continuation
  3. Sub 3 of Block 5

  4. Sub 4 of Block 5

2. Item 2 Block 5


Paragraph
block 6

```lua
Fenced code


block 7
```

Paragraph
block 8


> Quotation
> block 9.1
>
> block 9.2
> multiline


Paragraph
block 10

1. OL list block 11
1st item
2. OL list block 11 2nd item
  1. Ol sub of block 11 1st item
  2. OL sub of block 11 2nd item
          with continuation
  3. OL sub of block 11 3rd item
3. OL list block 11 3rd item

Paragraph
    block 12

1. list item
with continuation on enxt line
2. other list item
  1. with subitem
3. 3rd list item

  sdadsdsadasdsad
  adssadsadsadasdsadsa

]]
--]=]
end

do
  local fh <close> = io.open(file_md,'r')
  local md = x.parse(fh)
  print('LEN:',#md)
  fn_print(md)
end




return 1
