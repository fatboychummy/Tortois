local funcs = {}

funcs.report = function(mdm,cnl,ignoreDistance)
  local function bdarg(arg,exp,num)
    return "report: Bad Argument #"..num.." expected "..exp..", got "..type(arg)
  end
  assert(type(mdm) == "table",bdarg(mdm,"table",1))
  assert(type(cnl) == "number",bdarg(cnl,"number",2))
  assert(type(ignoreDistance) == "number",bdarg(cnl,"number",3))
  print("Reporting")
  local session = tostring(math.random(1,10000))
  local pass = false
  local timeOut = os.startTimer(30)
  local id = 0
  while true do
    local mTimeOut = os.startTimer(1)
    mdm.transmit(cnl,cnl,"REPORT"..session)
    local recieve = os.pullEvent()
    print(recieve[1],recieve[5])
    if recieve[1] == "modem_message" then
      local a,b = recieve[5]:find("CONNECT"..session)
      if recieve[6] <= ignoreDistance and a then
        pass = true
        id = recieve[5]:sub(b+1)
      end
    elseif recieve[1] == "timer" then
      if recieve[2] == timeOut then
        break
      end
    end
  end
  return id,pass
end
funcs.farm = function(type)

end

return funcs
