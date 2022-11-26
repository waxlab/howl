return function (file)
  local tree, tpos = {}, 1
  local fh  = io.open(file, 'r')
  local line = fh:read()
  local part, content, block, type

  while line do

    if type == 'code' then
      if line:match '^%-%-}'
        then type = nil
        else block[#block+1] = line
      end
      goto nextline
    end

    -- HEAD --
    part, content = line:match '^%-%-|%s+(#+)%s+(.*)'
    if content then
      type, block = 'head' ,{content, level = part:len()}
      goto include_block
    end

    -- TEXT --
    content = line:match '^%-%-|' and (line:match '^%-%-|%s(.*)' or '')
    if content then
      if type ~= 'text' then
        type, block = 'text', { content }
        goto include_block
      else
        block[#block+1] = content
        goto nextline
      end
    end

    -- SIGN --
    content, part = line:match '^%-%-$%s+(([%w%.]+).*)'
    if content then
      if type ~= 'sign' then
        type, block = 'sign', {content, name = part}
        goto include_block
      else
        block[#block+1] = content
        goto nextline
      end
    end

    -- CODE --
    if line:match '^%-%-{' and type ~= 'code' then
      type, block = 'code', {}
      goto include_block
    end

    goto nextline

    :: include_block ::
      block.type = type
      tree[#tree+1] = block
    :: nextline      ::
      line = fh:read()
  end
  fh:close()
  return  tree
end
