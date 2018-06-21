local funcs = {}

funcs.report = function(mdm)

end
funcs.allHome = function(mdm)

end
funcs.allGo = function(mdm)
  for i = 1,10 do
    mdm.transmit(74,74,"ALLGO")
  end
end
funcs.allStop = function(mdm)
  for i = 1,30 do
    mdm.transmit(74,74,"HALT")
  end
end
funcs.tellOneStop = function(mdm,id)

end
funcs.tellOneGo = function(mdm,id)

end
funcs.tellOneHome = function(mdm,id)

end
return funcs
