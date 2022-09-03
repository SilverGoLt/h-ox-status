RegisterNetEvent('ox:selectCharacter', function(data)
    local _source = source

    local Player = Ox.GetPlayer(_source)

    if type(data) == 'number' and data < 10 then
        character = Player.charid
    end

    local result = MySQL.single.await('SELECT status FROM characters WHERE charid = ?', {
        character
    })

    if not result.status then
        pStatus.new(_source, nil, character)
        -- Since we are creating the new status let's save it to the database
        local obj = pStatus(_source)
        obj:saveStatuses()
    else
        pStatus.new(_source, json.decode(result.status), character)
    end
end)

RegisterNetEvent('ox:playerLogout', function(source)
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