local from = require 'wax'.from

--
-- EXPORTED
--
local
  fn_chkfile,
  fn_chkname,
  fn_chksub,
  fn_chktype,
  fn_extract,
  fn_showtree,
  fn_stderr

--
-- INTERNALS
--
local
  _extractmd

--
-- LOCAL SHORTCUTS
--
local isfile    = from('wax.fs','isfile')
local langinput = from ('howl.def','langinput')
local exit      = os.exit


--
-- FUNCTIONS
--

function fn_stderr(t,...)
  io.stderr:write(t:format(...)):write('\n')
end

function fn_chkfile(a)
  if isfile(a[2]) then return a[2] end
  fn_stderr('%q is not a file, review your Howl config',a[2])
  exit(1)
end


function fn_chkname(a)
  if a[1] and a[1]:match '^[%w_]+$' then return a[1]:lower() end
  if not a[1]
    then fn_stderr 'you need to specify a name for document'
    else fn_stderr("invalid name: %q", a[1])
  end
  exit(1)
end


function fn_chktype(a)
  a.tp = a.tp or a[2]:match '%.([%l%d]+)$'

  if not a.tp
    then
      fn_stderr('undefined type for %q',a[2])
      os.exit(1)
  end

  if not langinput[a.tp]
    then
      fn_stderr('unrecognized type: %q', a.tp)
      os.exit(1)
  end

  return langinput[a.tp]
end


function fn_chksub(a)
  if not a[3] or #a < 1 then return nil end
  if not type(a[3]) == 'table'
    then
      fn_stderr('wrong type for sub of %q', a[2])
      exit(1)
  end
  return a[3]
end



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
  function fn_showtree(v,k)
    k = k or ('LINE %q'):format(debug.getinfo(2,'l').currentline)
    print(beautify(k,v,0))
  end
end

--
-- END OF DECLARATIONS
--


return {
  chkfile   = fn_chkfile,
  chktype   = fn_chktype,
  chkname   = fn_chkname,
  chksub    = fn_chksub,
  showtree  = fn_showtree,
  stderr    = fn_stderr
}
