AddEventHandler('ox:playerLoaded', function(source, userid, charid)
    local result = MySQL.single.await('SELECT status FROM characters WHERE charid = ?', {charid})

    if not result or not result.status then
        pStatus.new(source, nil, charid)
        -- Since we are creating the new status let's save it to the database
        local obj = pStatus(source)
        obj:saveStatuses()
    else
        pStatus.new(source, json.decode(result.status), charid)
    end
end)

AddEventHandler('ox:playerLogout', function(source, userid, charid)
    local Player = Ox.GetPlayer(source)
    if not Player then print('[ERROR] Player not found in ox_core?') end

    local obj = pStatus(source)
    obj:saveStatuses()
    obj = nil
end)

lib.callback.register('status:updateStatuses', function(source, data)
    local Player = Ox.GetPlayer(source)
    local obj = pStatus(source)

    if data then
        obj:updateValues(data)
        return true
    else
        return false
    end
end)

lib.callback.register('status:getStatuses', function(source)
    local obj = pStatus(source)
    return obj:getStatuses()
end)

---Create New Status Export
---@param source integer Player Source
---@param data table @{name, amount}
NewStatus = function (source, data)
    local obj = pStatus(source)
    return obj:newStatus(data.name, data.amount)
end

exports('NewStatus', function (source, data)
    return NewStatus(source, data)
end)