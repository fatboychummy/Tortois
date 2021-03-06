--[[
0.0


]]

local version = 0
local serverMode = false
local MODEMSIDE = "right"
local storage = "data"
local custom = {}
local serverLoc = "serverUtilities.lua"
local clientLoc = "clientUtilities.lua"
local serverLogLoc = "TSLog.lua"
local mon = false
local mod = false

local function wget(location,fileName)
  local h1 = http.get(location)
  local h2 = fs.open(fileName,"w")
  h2.write(h1.readAll())
  h1.close()
  h2.close()
end
if not fs.exists("w.lua") then
  wget("https://raw.githubusercontent.com/justync7/w.lua/master/w.lua","w.lua")
end
if not fs.exists("r.lua") then
  wget("https://raw.githubusercontent.com/justync7/r.lua/master/r.lua","r.lua")
end
if not fs.exists("json.lua") then
  shell.run("pastebin","get","4nRg9CHU","json.lua")
end
if not fs.exists("jua.lua") then
  wget("https://raw.githubusercontent.com/justync7/Jua/master/jua.lua","jua.lua")
end
if not fs.exists(serverLoc) then
  wget("https://raw.githubusercontent.com/fatboychummy/Tortois/master/serverUtilities.lua",serverLoc)
end
if not fs.exists(clientLoc) then
  wget("https://raw.githubusercontent.com/fatboychummy/Tortois/master/clientUtilities.lua",clientLoc)
end
if not fs.exists(serverLogLoc) then
  wget("https://raw.githubusercontent.com/fatboychummy/Tortois/master/TSLog.lua",serverLogLoc)
end


local function ao(a,b)
  b.writeLine(a)
end
local function writeData(loc)
  local h = fs.open(loc,"w")
  if h then
    local lines = {
      [1] = "local data = {",
      [2] = "-----------ServerMode",
      [3] = "  serverMode = false,",
      [4] = "  monitorName = \"empty\",",
      [5] = "  serverWaitTime = 1000,",
      [6] = "  maxConnections = 5,",
      [7] = "-----------Both",
      [8] = "  modemSide = \"right\",",
      [9] = "  modemIgnoreDistance = 50,",
      [10] = "}",
      [11] = "return data",
    }
    for i = 1,#lines do
      ao(lines[i],h)
    end
    h.close()
  else
    error("Failed to create data file, make sure there is no other file named \"data\".")
  end
end
local function fixData()
  local h = fs.open(storage,"w")
  local function chk(a)
    return type(a) == "table"
  end
  local function tpb(a)
    return type(a) == "boolean"
  end
  ao("local data = {",h)
  ao("-----------ServerMode",h)
  ao(tpb(custom.serverMode) and "  serverMode = "..tostring(custom.serverMode).."," or "  serverMode = false,",h)
  ao(custom.monitorName and "  monitorName = \""..custom.monitorName.."\"," or "  monitorName = \"empty\",",h)
  ao(custom.serverWaitTime and "  serverWaitTime = "..tostring(custom.serverWaitTime).."," or "  serverWaitTime = 1000,",h)
  ao(custom.maxConnections and "  maxConnections = "..custom.maxConnections.."," or "  maxConnections = 5,",h)
  ao("-----------Both",h)
  ao(custom.modemSide and "  modemSide = \""..custom.modemSide.."\"," or "  modemSide = \"right\",",h)
  ao(custom.modemIgnoreDistance and "  modemIgnoreDistance = "..tostring(custom.modemIgnoreDistance).."," or "  modemIgnoreDistance = 50,",h)
  ao("}",h)
  ao("return data",h)
  h.close()
end

if fs.exists(storage) then
  custom = require(storage)
else
  writeData(storage)
  error("No data file was found.  Created a new one.  Please check it over.")
end
if custom.serverMode then
  if peripheral.getType(custom.monitorName) == "monitor" then
    mon = peripheral.wrap(custom.monitorName)
  else
    print("No monitor connected to the network.")
  end
end
if peripheral.getType(custom.modemSide) == "modem" then
  mod = peripheral.wrap(custom.modemSide)
  print("Modem connected.")
else
  error("No modem or the wrong modem name has been supplied.")
end

clientLoc = clientLoc:sub(1,clientLoc:len()-4)
serverLoc = serverLoc:sub(1,serverLoc:len()-4)
-----------------------------------------------
local w = require("w")
local r = require("r")
os.loadAPI("json.lua")
local json = _G.json
_G.json = nil
local jua = require("jua")
w.init(jua)
r.init(jua)


local server = "blank"
local client = "blank"
local mode = "startup"
local startupTimer = os.startTimer(7)
local waitTimer = ""
local connected = false
local cnl = 74

local function juaStuff()

  jua.on("terminate",function()
    printError("Terminated")
    jua.stop()
  end)
  mod.open(cnl)
  if custom.serverMode then
    -----------------------------------SERVERMODE
    mon = peripheral.wrap(custom.monitorName) or false
    local maxC = custom.maxConnections or 1
    if mon then
      mon.setBackgroundColor(colors.black)
      mon.setTextColor(colors.white)
      mon.clear()
      mon.setCursorPos(1,1)
      mon.setTextScale(0.5)
    end

    server = require("/"..serverLoc)
    os.loadAPI(serverLogLoc)
    TSLog.info("Logger Initiated",mon)
    connected = {}


    jua.on("modem_message",function(...)
      local event = {...}
      local a,b = event[5]:find("REPORT")
      if a then
        local rejected = false
        local cID = event[5]:sub(b+1)
        for i = 1,#connected do
          if connected[i] == cID then
            mod.transmit(cnl,cnl,"CONNECT"..cID..tostring(i))
            TSLog.connect("Reconnected "..tostring(i).."("..cID..")",2,mon)
            rejected = true
          end
        end
        if #connected < maxC then
          mod.transmit(cnl,cnl,"REJECT"..cID)
          TSLog.connect("Rejected "..cID,0,mon)
          rejected = true
        end
        if not rejected then
          mod.transmit(cnl,cnl,"CONNECT"..event[5]:sub(b+1)..tostring(#connected+1))
          TSLog.connect("Connected to "..tostring(#connected+1).."("..cID..")",1,mon)
          connected[#connected+1] = event[5]:sub(b+1)
          connecting = false
        end
      end
      TSLog.connect("There are "..#connected.." turtles connected",2,mon)
    end)


  else
    ----------------------------------------CLIENTMODE
    client = require("/"..clientLoc)
    local ID = client.report(mod,cnl,50)
    print("Our ID is:",ID)
  end

  jua.go(function()
    print("Running")
  end)
end


local succ,err = pcall(juaStuff)
if not succ then
  print(err)
end
