-- Register all the statuses on character load
local playerLoaded = false

RegisterNetEvent('ox:playerLoaded', function()
    playerLoaded = true
    lib.callback('status:getStatuses', false, function(data)
        if data then
            for k,v in pairs(data) do
                Status.new(k, v)
                StartStatusThread()
                StartUpdateThread()
            end
        end
    end)
end)

AddEventHandler('ox:playerLogout', function()
    playerLoaded = false
    for k,v in pairs(Status.list) do
        local obj = Status(k)
        obj:destroy()
    end
end)

lib.callback.register('status:createNew', function (data)
    for k,v in pairs(Status.list) do
        if v.name == data.name then
            return false
        end
    end

    Status.new(data.name, data.amount)
    return true
end)

StartStatusThread = function()
    CreateThread(function ()
        while playerLoaded do
            local data = {}
            for k,v in pairs(Status.list) do
                local obj = Status(k)
                obj:remove(math.random(1, 20))

                data[#data+1] = {
                    name = k,
                    amount = obj.amount,
                    percent = obj:getPercent()
                }
            end
            
            TriggerEvent('status:tickUpdate', data)
            data = nil
            Wait(Config.TickTime)
        end
    end)
end

StartUpdateThread = function()
    CreateThread(function ()
        while playerLoaded do
            local data = {}
            for k,v in pairs(Status.list) do
                local obj = Status(k)
                data[#data+1] = {
                    name = k,
                    amount = obj.amount
                }
            end

            local update = lib.callback.await('status:updateStatuses', false, data)
            if not update then print('[ERROR] Failed to update statuses') end
            
            data = nil
            Wait(Config.UpdateInterval)
        end
    end)
end

AddToStatus = function(name, amount)
    local obj = Status(name)
    if obj then
        obj:add(amount)
    end
end

RemoveFromStatus = function(name, amount)
    local obj = Status(name)
    if obj then
        obj:remove(amount)
    end
end

exports('AddToStatus', AddToStatus)
exports('RemoveFromStatus', RemoveFromStatus)