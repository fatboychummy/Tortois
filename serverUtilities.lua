local funcs = {}

funcs.report = function(mdm,cnl,max,ignore,monitor)
  TSLog.connect("Begin connection",2,monitor)
  local ids = {}
  for i = 1,10 do
    mdm.transmit(cnl,cnl,"REPORT")
  end
  for i = 1,max do
    local timeOut = os.startTimer(30)
    while true do
      mdm.transmit(cnl,cnl,"REPORT")
      local miniTimeOut = os.startTimer(2)
      local event = {os.pullEvent()}
      print(event[1])
      if event[1] == "timer" then
        if event[2] == timeOut then
          break
        end
      elseif event[1] == "modem_message" then
        print(event[5])
        local a,b = event[5]:find("REPORT")
        if a then
          mdm.transmit(cnl,cnl,"CONNECT"..event[5]:sub(b+1)..tostring(#ids))
          TSLog.connect("Connected to "..tostring(#ids))
          ids[i] = event[5]:sub(b+1)
          break
        end
      end
    end
  end
  return ids
end
funcs.allHome = function(mdm)

end
funcs.allGo = function(mdm,cnl)
  for i = 1,10 do
    mdm.transmit(cnl,cnl,"ALLGO")
  end
end
funcs.allStop = function(mdm,cnl)
  for i = 1,30 do
    mdm.transmit(cnl,cnl,"HALT")
  end
end
funcs.tellOneStop = function(mdm,id)

end
funcs.tellOneGo = function(mdm,id)

end
funcs.tellOneHome = function(mdm,id)

end
return funcs
