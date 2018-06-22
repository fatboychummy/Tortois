local funcs = {}

funcs.report = function(mdm,cnl,max,ignore,monitor)
  TSLog.info("Do nothing fuckers")
end
funcs.allHome = function(mdm)

end
funcs.allGo = function(mdm,cnl)
  for i = 1,30 do
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
