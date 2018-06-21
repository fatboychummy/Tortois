--Must be loaded as an api, cannot be "required"

local writeLine = function(a,mon)
  local oX,oY = mon.getCursorPos()
  mon.write(a)
  mon.setCursorPos(1,oY+1)
end

info = function(a,mon)
  if mon then
    writeLine("[INFO]: "..tostring(a))
  else
    print("[INFO]: "..tostring(a))
  end
end
connect = function(a,pass,mon)
  a = tostring(a)
  assert(type(pass) == "number" and pass >= 0 and pass <= 2 and pass%1 == 0,"connect:bad argument #2: must be a whole number between 0 and 2")
  if mon then
    if pass == 1 then
      local oldBG = mon.getBackgroundColor()
      mon.write("[")
      mon.setBackgroundColor(colors.green)
      mon.write("CONNECT")
      mon.setBackgroundColor(oldBG)
      mon.writeLine("]: "..a)
    elseif pass == 0 then
      local oldBG = mon.getBackgroundColor()
      mon.write("[")
      mon.setBackgroundColor(colors.red)
      mon.write("CONNECT")
      mon.setBackgroundColor(oldBG)
      mon.writeLine("]: "..a)
    elseif pass == 2 then
      local oldBG = mon.getBackgroundColor()
      mon.write("[")
      mon.setBackgroundColor(colors.blue)
      mon.write("CONNECT")
      mon.setBackgroundColor(oldBG)
      mon.writeLine("]: "..a)
    end
  else
    if pass == 1 then
      print("[CONNECT-APPROVE]: "..a)
    elseif pass == 0 then
      print("[CONNECT-REJECT]: "..a)
    elseif pass == 2 then
      print("[CONNECT]: "..a)
    end
  end
end
