PlatFormID = 102
WorldGhost = {"tsibd","roavn","pahvz","tvcuy","mmeef","geigerbetas","jaswhy","mghostlists1"}
local bot = getBot() 
bot:setInterval(Action.move,0.075)
bot:setInterval(Action.collect,0.025)
bot:setInterval(Action.hit,0.100)
bot:setInterval(Action.place,0.100)
local function warp(world,door)
    bot:warp(world,door)
    sleep(math.random(3,6)*1000)
    while bot.status ~= 1 do
        sleep(50)
    end
end
local function place(id,x,y)
    bot:place(bot.x+x,bot.y+y,id)
end
local function findItem(item)
    return bot:getInventory():findItem(item)
end 
local function punch(x,y)
    bot:hit(x, y)
end
local Timer = {}

function Timer.new()
return setmetatable({
    running = false,
    start_time = 0,
    accumulated = 0
}, {__index = Timer})
end

function Timer:start()
if self.running then return end
self.running = true
self.start_time = os.time()
end

function Timer:pause()
if not self.running then return end
self.accumulated = self.accumulated + (os.time() - self.start_time)
self.running = false
end

function Timer:stop()
self:pause()
self.accumulated = 0  -- Reset on stop, remove this line if you want to preserve
end

function Timer:get_elapsed()
return self.running and (self.accumulated + (os.time() - self.start_time)) 
                    or self.accumulated
end

function Timer:get_components()
local total = self:get_elapsed()
return {
    hours = math.floor(total / 3600),
    minutes = math.floor((total % 3600) / 60),
    seconds = total % 60
}
end

-- Example usage:
local timer = Timer.new()
local function AmountGhost()
local amount = 0
    for _, npc in pairs(getNPCs()) do
        if npc.type == 12  then
            for _, tile in pairs(getTiles()) do
                if tile.fg == PlatFormID  and bot:getWorld():getTile(tile.x,tile.y+1).fg == 0   and bot:getWorld():getTile(tile.x,tile.y+2).fg > 0  then
                    if math.abs(getNPC(npc.id).x // 32 - tile.x) <= 3 and math.abs(getNPC(npc.id).y // 32 - tile.y) <= 3 then
                        amount = amount + 1
                    end
                end
            end
        end
    end
return amount
end
local function CatchGhost()
    for _, npc in pairs(getNPCs()) do
        bot.auto_collect = true
        if npc.type == 12  then
            for _, tile in pairs(getTiles()) do
                if tile.fg == PlatFormID and bot:getWorld():getTile(tile.x,tile.y+1).fg == 0  and bot:getWorld():getTile(tile.x,tile.y+2).fg > 0 then
                    ::back::
                    if getNPC(npc.id) ~= nil then
                        if math.abs(getNPC(npc.id).x // 32 - tile.x) <= 3 and math.abs(getNPC(npc.id).y // 32 - tile.y) <= 3 then
                            if bot:findPath(tile.x, tile.y-1    ) then
                                bot:findPath(tile.x, tile.y-1)
                                sleep(300)
                                local OldAmountGIJ = findItem(6080)
                                local FirstPlace = true 
                                if findItem(3720) == 0 then
                                    print("Ghost Jar Amount is 0 Stoppig script")
                                    return
                                elseif findItem(6080) == 200 then
                                    print("Ghost in a Jar Amount is 200 Stoppig script")
                                    return
                                end
                                timer:start()
                                while findItem(6080 )== OldAmountGIJ and getNPC(npc.id) ~= nil  do
                                    if FirstPlace then 
                                    punch(getNPC(npc.id).destx // 32, getNPC(npc.id).desty // 32)
                                    sleep(200)
                                    else 
                                        punch(getNPC(npc.id).x//32,getNPC(npc.id).y//32)
                                        sleep(200)
                                    end
                                        if getNPC(npc.id) ~=  nil then
                                            if math.abs(getNPC(npc.id).destx // 32 - bot.x) > 3 or math.abs(getNPC(npc.id).desty // 32 - bot.y) > 3 then
                                                print("Out OF Range")
                                                goto back
                                            end
                                            if (bot:isInTile(getNPC(npc.id).x // 32, getNPC(npc.id).y // 32) and FirstPlace) then
                                                place(3720,0,2)
                                                sleep(300)
                                                FirstPlace = false
                                            end
                                        end
                                        if timer:get_components().seconds >= 5 then
                                            timer:stop()
                                            place(3720,0,2)
                                            sleep(300)
                                        end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
for i = 1,#WorldGhost do 
    while bot:getWorld().name ~= WorldGhost[i]:upper() do
    warp(WorldGhost[i],"IdDoorNew")
    end
    sleep(1000)
    while AmountGhost() > 0 and findItem(3720) > 0 and findItem(6080) < 200 do 
    CatchGhost()
    end
end
print("All done")