Config = {}

-- Level Tiers & Rewards
Config.Levels = {
    [1] = {required = 0, pay = {100, 180}, tip = {10, 100}, vehicle = 'taxi'}, --- You can change vehicle model here!
    [2] = {required = 25, pay = {150, 200}, tip = {10, 100}, vehicle = 'taxi'},
    [3] = {required = 150, pay = {200, 350}, tip = {10, 100}, vehicle = 'taxi'},
    [4] = {required = 300, pay = {250, 350}, tip = {10, 100}, vehicle = 'taxi'}
}

-- NPC Ped for job start
Config.TaxiPed = {
    model = 's_m_m_lifeinvad_01',
    coords = vector4(894.86, -179.22, 73.70, 240.0)
}

-- Vehicle Spawn Location
Config.SpawnPoints = {
    vector4(899.40, -180.79, 73.84, 236.0)
}

-- Passenger Pickup Locations
Config.Pickups = {
    vector3(-32.99, -405.08, 39.58), vector3(-171.85, -810.18, 31.40),
    vector3(-225.86, -954.67, 29.29), vector3(-280.29, -1103.80, 23.37),
    vector3(-292.27, -1480.12, 30.81), vector3(-414.02, -1743.05, 19.99),
    vector3(51.25, -1904.24, 21.49), vector3(158.60, -1797.61, 29.01),
    vector3(174.04, -1750.74, 29.15), vector3(355.87, -1907.03, 24.77),
    vector3(937.59, -1750.40, 31.19), vector3(943.62, -1864.49, 31.13),
    vector3(926.81, -2061.17, 30.50), vector3(852.84, -2435.39, 28.01),
    vector3(646.86, -2800.17, 6.04), vector3(578.14, -2736.78, 6.06),
    vector3(-327.13, -2764.79, 5.00), vector3(-512.57, -2200.52, 6.39),
    vector3(-880.26, -2109.05, 8.95), vector3(-1120.84, -1560.50, 4.38),
    vector3(-1063.44, -1511.65, 4.96), vector3(-1126.55, -1419.92, 5.15),
    vector3(-1249.40, -1376.01, 4.06), vector3(-1497.26, -686.52, 27.45),
    vector3(-1874.03, -616.14, 11.67), vector3(-2075.77, -327.01, 13.16),
    vector3(-2099.49, -291.91, 13.20), vector3(-208.16, -1883.76, 28.22),
    vector3(411.39, -990.54, 29.41), vector3(97.92, -1323.30, 29.29),
    vector3(-300.74, -646.18, 33.11), vector3(-130.57, -251.74, 43.96),
    vector3(764.18, -815.65, 26.34), vector3(785.89, -1398.31, 27.17),
    vector3(856.02, -1578.91, 30.86), vector3(850.45, -2086.67, 30.16),
    vector3(1239.83, -1617.71, 52.07), vector3(1147.90, -988.55, 45.79),
    vector3(1284.33, -645.98, 67.85), vector3(1169.73, -636.28, 62.79),
    vector3(1169.78, -486.37, 65.53), vector3(923.15, 49.30, 81.11),
    vector3(535.03, 90.55, 96.26), vector3(232.81, 200.81, 105.39),
    vector3(74.03, 258.82, 109.17), vector3(-72.75, 57.95, 71.91),
    vector3(-561.84, 269.58, 83.02), vector3(-717.28, 97.67, 55.94),
    vector3(-1066.69, -1360.21, 5.17), vector3(-1209.13, -1446.96, 4.38),
    vector3(-1081.55, -1699.73, 4.52), vector3(-1101.62, -1983.61, 13.14),
    vector3(-409.40, 1171.98, 325.79), vector3(-1888.27, 2048.36, 140.98),
    vector3(1851.78, 2585.60, 45.67), vector3(1136.84, 2676.64, 38.20),
    vector3(-3001.44, 112.78, 14.57), vector3(-3088.80, 319.04, 7.61),
    vector3(-2975.25, 433.40, 15.19), vector3(-3235.35, 968.36, 12.99),
    vector3(-3131.82, 1071.59, 20.53), vector3(-1102.38, 2690.14, 19.28),
}

-- Passenger Drop-Off Locations
Config.DropOffs = Config.Pickups -- DO NOT TOUCH THIS!!!

-- Job End Zone
Config.EndJobZone = {
    coords = vector3(908.78, -176.35, 74.19),
    radius = 15.0
}

Config.TaxiBlip = {
    enabled = true, --- true will display the blip!
    label = "Downtown Cab Co"
}
