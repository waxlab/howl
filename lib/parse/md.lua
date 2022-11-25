return function (file)
  local tree, tpos, type = {}, 0, nil
  local fh = io.open(file, 'r')
  local line = fh:read()

  while line do
    local lvl, title = line:match('^(#+)%s+(.*)$')
    if not lvl then
      if type == 'text' then
        tree[tpos][#(tree[tpos])+1] = line
      else
        type, tpos = 'text', tpos+1
        tree[tpos] = { type = type, line }
      end
    else
      type, tpos = 'head', tpos+1
      tree[tpos] = { type = 'head', level = lvl:len(), title }
    end
    line = fh:read()
  end
  fh:close()
  return tree
end
