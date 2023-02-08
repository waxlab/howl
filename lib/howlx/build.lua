local wax = require 'wax'
wax.locals()


local fn = require 'howl.fn'

--| # Building documents
--|
--|     howlx build
local cfgfile = arg[1] or 'howl.lua'

--
-- Aliases
--
local isfile,  isdir = wax.from('wax.fs'
    , 'isfile','isdir')

local chkname,  chkfile,  chktype,  chksub,  extract,  stderr = wax.from('howl.fn'
    ,'chkname','chkfile','chktype','chksub','extract','stderr')

local extract, extractmd, xprint = wax.from('howl.extractor','extract','extractmd','print')

local exit   = os.exit

-- main data
local cfg = {}

-- output formatters
local outfmt = {
  wiki    = "howl.out.wiki",
  vimhelp = "howl.out.vimhelp",
}


--
-- Local Functions
--

local process



function process (item, lvl)
  local name   = chkname(item)
  local file   = chkfile(item)
  local sub    = chksub(item)
  local format = chktype(item)

  item.data = format[1] == 'md'
    and extractmd(file)
    or  extract(file, format)
  xprint(item.data, name)
  if sub
    then
      for i,v in ipairs(sub) do
          sub[i] = process(v,lvl+1)
      end
  end
end

--
-- Validations
--
do
  local error = false

  if not isfile(cfgfile)
    then
      stderr ('config file "'..cfgfile..'" for project was not found')
      stderr 'Run `howlx draft` at the project root directory to start one'
      exit(1)
  end

  local loadfn, loaderr = loadfile(cfgfile,'t',cfg)
  if not loadfn
    then
      stderr (('Error loading %q:\n\t%s'):format(cfgfile, loaderr))
      exit(1)
  end
  loadfn()

  -- Validate the presence of obligatory fields

  if not cfg.name or not cfg.name:match('^[a-zA-Z0-9_-]+$')
    then
      stderr 'name entry missing at config file'
      error = true
  end

  if not cfg.formats or #cfg.formats < 1
    then
      stderr "config.formats entry is not defined"
      error = true
  end
  if error then exit(1) end

  -- Validate the output formats

  for _,fmt in ipairs(cfg.formats) do
    if not outfmt[fmt]
      then
        stderr (("formats contains the unknown format %q"):format(fmt))
        error = true
    end
  end
  if error then exit(1) end
end


--
-- Build Tree
--
for i,v in ipairs(cfg.tree) do cfg.tree[i] = process(v,1) end

-- for i,v in ipairs(cfg.formats) do
--   export(cfg)
-- end
