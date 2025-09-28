if not Config.TaxiBlip.enabled then return end

CreateThread(function()
    local coords = Config.TaxiPed.coords.xyz
    local blip = AddBlipForCoord(coords)

    SetBlipSprite(blip, 198)
    SetBlipScale(blip, 0.85)
    SetBlipColour(blip, 5)
    SetBlipDisplay(blip, 4)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.TaxiBlip.label or 'Taxi Job')
    EndTextCommandSetBlipName(blip)
end)
