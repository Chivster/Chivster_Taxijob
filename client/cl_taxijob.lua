if GetCurrentResourceName() ~= 'nolo_taxijob' then
    return print("^1[ERROR]^0 This script must be named ^3nolo_taxijob^0 to function properly.")
end

local deliveryCount, taxiVeh, currentPed = 0, nil, nil
local dropCoords, nearMarker = nil, false
local jobActive = false
local activeBlips = {}

RegisterCommand('taxiend', function()
    cancelJob(true)
end)

function cancelJob(showNotify)
    if DoesEntityExist(taxiVeh) then DeleteVehicle(taxiVeh) end
    if DoesEntityExist(currentPed) then DeletePed(currentPed) end
    for _, blip in ipairs(activeBlips) do
        if DoesBlipExist(blip) then RemoveBlip(blip) end
    end
    activeBlips = {}
    jobActive = false

    lib.hideTextUI()

    if showNotify then
        lib.notify({ title = 'Taxi Job', description = 'Taxi job has been ended.', type = 'inform', duration = 7000 })
    end
end

RegisterNetEvent('taxi:openMenu', function()
    local Player = exports['qbx_core']:GetPlayerData()
    local cid = Player.citizenid

    lib.callback('taxi:getDeliveryCount', false, function(deliveries)
        deliveryCount = deliveries or 0
        local level, nextReq = 1, 0

        for lvl, data in ipairs(Config.Levels) do
            if deliveries >= data.required then
                level = lvl
            else
                nextReq = data.required
                break
            end
        end

        local menu = {
            id = 'taxi_job_menu',
            title = 'Taxi Driver Levels',
            options = {
                {
                    title = 'Progress to Next Level',
                    description = nextReq > 0 and (('Deliveries: %d / %d'):format(deliveries, nextReq)) or 'You have reached the max level!',
                    disabled = true
                },
                {
                    title = '📋 About the Job',
                    description = 'Drive passengers across town. The better your rank, the better cars and pay.',
                    disabled = true
                }
            }
        }

        if jobActive then
            table.insert(menu.options, {
                title = '❌ End Current Job',
                description = 'Cancel the ongoing taxi job.',
                onSelect = function()
                    cancelJob(true)
                end
            })
        else
            for lvl, data in ipairs(Config.Levels) do
                local unlocked = deliveries >= data.required
                local payMin, payMax = data.pay[1], data.pay[2]
                local tipMax = data.tip[2]
                table.insert(menu.options, {
                    title = 'Level ' .. lvl,
                    description = ('Earns $%d–$%d plus tips up to $%d'):format(payMin, payMax, tipMax),
                    disabled = not unlocked,
                    onSelect = unlocked and function()
                        jobActive = true
                        TriggerServerEvent('taxi:startLevel', lvl)
                    end or nil
                })
            end
        end

        lib.registerContext(menu)
        lib.showContext(menu.id)
    end, cid)
end)

CreateThread(function()
    local pedModel = Config.TaxiPed.model
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end
    local ped = CreatePed(0, pedModel, Config.TaxiPed.coords.xyz, Config.TaxiPed.coords.w, false, true)
    currentPed = ped
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            icon = 'fa-solid fa-taxi',
            label = 'Start Taxi Job',
            onSelect = function()
                TriggerEvent('taxi:openMenu')
            end
        }
    })
end)

RegisterNetEvent('taxi:startJob', function(level)
    local data = Config.Levels[level]
    local spawn = Config.SpawnPoints[1]
    RequestModel(data.vehicle)
    while not HasModelLoaded(data.vehicle) do Wait(0) end

    local vehicles = GetGamePool('CVehicle')
    for _, veh in pairs(vehicles) do
        if #(GetEntityCoords(veh) - spawn.xyz) < 5.0 then
            lib.notify({ title = 'Taxi Job', description = 'The taxi spawn area is blocked. Please wait or move the vehicles.', type = 'error', duration = 7000 })
            return
        end
    end

    taxiVeh = CreateVehicle(data.vehicle, spawn.xyz, spawn.w, true, false)
    SetVehicleNumberPlateText(taxiVeh, 'TAXI')
    SetEntityAsMissionEntity(taxiVeh, true, true)

    TriggerServerEvent('taxi:giveKeys', VehToNet(taxiVeh))
    TaskWarpPedIntoVehicle(PlayerPedId(), taxiVeh, -1)

    lib.notify({ title = 'Taxi Job', description = 'Please go pick up your customer at the location.', type = 'inform', duration = 7000 })
    beginNextPickup(level)
end)

function beginNextPickup(level)
    local pick = Config.Pickups[math.random(#Config.Pickups)]
    local blip = AddBlipForCoord(pick)
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 5)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pickup Location")
    EndTextCommandSetBlipName(blip)
    table.insert(activeBlips, blip)

    CreateThread(function()
        local pedModel = `a_m_m_business_01`
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do Wait(0) end
        currentPed = CreatePed(0, pedModel, pick.x, pick.y, pick.z, 0.0, false, true)
        SetBlockingOfNonTemporaryEvents(currentPed, true)
        SetEntityInvincible(currentPed, true)
        TaskStartScenarioInPlace(currentPed, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)

        while not IsPedInVehicle(PlayerPedId(), taxiVeh, false)
              or #(GetEntityCoords(PlayerPedId()) - pick) > 8.0
              or GetEntitySpeed(taxiVeh) > 2.0 do
            Wait(500)
        end

        TaskEnterVehicle(currentPed, taxiVeh, -1, 2, 1.0, 1, 0)
        if DoesBlipExist(blip) then RemoveBlip(blip) end

        Wait(1000)

        lib.notify({ title = 'Taxi Job', description = 'Please drop off your customer at the location.', type = 'inform', duration = 7000 })
        beginDropOff(level)
    end)
end

function beginDropOff(level)
    dropCoords = Config.DropOffs[math.random(#Config.DropOffs)]
    local blip = AddBlipForCoord(dropCoords)
    SetBlipSprite(blip, 280)
    SetBlipColour(blip, 3)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Drop-Off Location")
    EndTextCommandSetBlipName(blip)

    CreateThread(function()
        while true do
            Wait(0)
            local coords = GetEntityCoords(PlayerPedId())
            local dist = #(coords - dropCoords)

            if dist < 50.0 then
                DrawMarker(1, dropCoords.x, dropCoords.y, dropCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 255, 255, 0, 200, false, true, 2)
            end

            if dist < 3.0 then
                if IsPedInVehicle(currentPed, taxiVeh, false) then
                    lib.showTextUI('[E] Drop off passenger')
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        TaskLeaveVehicle(currentPed, taxiVeh, 0)
                        Wait(1000)
                        ClearPedTasks(currentPed)
                        SetVehicleDoorsShut(taxiVeh, true)
                        TaskGoStraightToCoord(currentPed, dropCoords.x + 2, dropCoords.y + 2, dropCoords.z, 1.0, -1, 0.0, 0.0)
                        SetPedKeepTask(currentPed, true)
                        SetEntityAsNoLongerNeeded(currentPed)
                        RemoveBlip(blip)
                        TriggerServerEvent('taxi:completeDelivery', level)
                        showJobContinueMenu(level)
                        break
                    end
                else
                    lib.showTextUI('Your passenger must be in the vehicle to drop them off.')
                end
            else
                lib.hideTextUI()
            end
        end
    end)
end

function showJobContinueMenu(level)
    lib.registerContext({
        id = 'taxi_continue',
        title = 'Drop-Off Complete',
        options = {
            {
                title = 'Continue Job',
                description = 'Pick up the next customer.',
                onSelect = function()
                    beginNextPickup(level)
                end
            },
            {
                title = 'End Job',
                description = 'Return the taxi to the depot.',
                onSelect = function()
                    createReturnZone()
                end
            }
        }
    })
    lib.showContext('taxi_continue')
end

RegisterNetEvent('taxi:paymentNotification', function(pay, tip)
    local msg = ('You earned $%d'):format(pay)
    if tip > 0 then msg = msg .. (' and received a tip of $%d!'):format(tip) end
    lib.notify({ title = 'Taxi Payment', description = msg, type = 'success', duration = 7000 })
end)

function createReturnZone()
    lib.notify({ title = 'Taxi Job', description = 'Please return your taxi to the depot to complete the job.', type = 'inform', duration = 7000 })

    CreateThread(function()
        while true do
            Wait(500)
            local coords = GetEntityCoords(PlayerPedId())
            if IsPedInVehicle(PlayerPedId(), taxiVeh, false) and #(coords - Config.EndJobZone.coords) <= Config.EndJobZone.radius then
                DeleteVehicle(taxiVeh)
                lib.hideTextUI()
                lib.notify({ title = 'Taxi Job', description = 'Taxi returned. Job ended.', type = 'inform', duration = 7000 })
                break
            end
        end
    end)
end
