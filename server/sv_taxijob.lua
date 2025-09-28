RegisterNetEvent('taxi:startLevel', function(level)
    local src = source
    local Player = exports['qbx_core']:GetPlayer(src)
    if not Player then return end

    local cid = Player.PlayerData.citizenid
    MySQL.scalar('SELECT deliveries FROM taxi_deliveries WHERE cid = ?', {cid}, function(deliveries)
        if not deliveries then
            MySQL.insert('INSERT INTO taxi_deliveries (cid, deliveries) VALUES (?, ?)', {cid, 0})
            deliveries = 0
        end

        if deliveries >= Config.Levels[level].required then
            TriggerClientEvent('taxi:startJob', src, level)
        end
    end)
end)

RegisterNetEvent('taxi:completeDelivery', function(level)
    local src = source
    local Player = exports['qbx_core']:GetPlayer(src)
    if not Player then return end
    local cid = Player.PlayerData.citizenid

    MySQL.update('UPDATE taxi_deliveries SET deliveries = deliveries + 1 WHERE cid = ?', {cid})

    local data = Config.Levels[level]
    local pay = math.random(data.pay[1], data.pay[2])
    local tip = (math.random(100) > 40) and math.random(data.tip[1], data.tip[2]) or 0
    local total = pay + tip

    Player.Functions.AddMoney('bank', total, 'Taxi fare and tip')
    TriggerClientEvent('taxi:paymentNotification', src, pay, tip)
end)

lib.callback.register('taxi:getDeliveryCount', function(source, cid)
    local result = MySQL.single.await('SELECT deliveries FROM taxi_deliveries WHERE cid = ?', {cid})
    return result and result.deliveries or 0
end)


RegisterNetEvent('taxi:giveKeys', function(netVeh)
    local src = source
    local veh = NetworkGetEntityFromNetworkId(netVeh)
    if veh and DoesEntityExist(veh) then
        exports.qbx_vehiclekeys:GiveKeys(src, veh, false)
    end
end)
