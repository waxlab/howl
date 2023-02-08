-- SETTINGS MODULE
-- Here are the things that can be easily extended to
-- add support for new formats.

-- input format definitions
local langinput = {
  -- fmt = { fenced,   marker  }
  c      = {'c',       cmt='//'},
  erl    = {'erlang',  cmt= '%'},
  go     = {'go',      cmt='//'},
  hs     = {'haskell', cmt='--'},
  js     = {'js',      cmt='//'},
  lua    = {'lua',     cmt='--'},
  nim    = {'nim',     cmt= '#'},
  php    = {'php',     cmt='//'},
  pl     = {'perl',    cmt= '#'},
  py     = {'python',  cmt= '#'},
  rb     = {'ruby',    cmt= '#'},
  r      = {'r',       cmt= '#'},
  rs     = {'rust',    cmt='//'},
  sh     = {'sh',      cmt= '#'},
}

do
  local f = langinput
  f.md = {'md', cmt=nil}
  f.mkd, f.mkd, f.mkdn, f.mdown, f.mdtxt, f.mdtext, f.markdown, f.text =
  f.md,  f.md,  f.md,   f.md,    f.md,    f.md,     f.md,       f.md
  -----
  f.h, f.cpp, f.hpp = f.c, f.c,   f.c
  -----
  f.zsh, f.bash, f.bsh = f.sh, f.sh, f.sh
  -----
  f.hrl = f.erl
end


return {
  langinput = langinput
}
