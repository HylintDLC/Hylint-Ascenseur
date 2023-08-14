-----------------Pour obtenir de l'aide, des scripts, etc.----------------
--------------- https://discord.gg/c9ZMqvMUEE  ---------------------------
--------------------------------------------------------------------------

ESX = nil
QBCore = nil
local framework, PlayerData, target

CreateThread(function()
    if framework then return end

    framework = GetResourceState('es_extended') == 'started' and 'esx' or GetResourceState('qb-core') == 'started' and 'qb' or nil

    if not framework then return end

    if framework == 'esx' then
        ESX = exports.es_extended:getSharedObject()
        PlayerData = ESX.GetPlayerData()
        while not PlayerData or not PlayerData.job do
            Wait(100)
            PlayerData = ESX.GetPlayerData()
        end

        RegisterNetEvent('esx:setJob',  function(job)
            PlayerData.job = job
        end)
    elseif framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
        PlayerData = QBCore.Functions.GetPlayerData()

        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            PlayerData.job = job
        end)
    end
end)

CreateThread(function()
    while not framework do
        Wait(500)
    end
    if framework == 'esx' then
        target = 'qtarget'
    else
        target = 'qb-target'
    end
end)

AddEventHandler('hylint_ascenseur:goToFloor', function(data)
    local elevator, floor = data.elevator, data.floor
    local coords = Config.Elevators[elevator][floor].coords
    local heading = Config.Elevators[elevator][floor].heading
    local ped = cache.ped
	DoScreenFadeOut(1500)
	while not IsScreenFadedOut() do
		Wait(10)
	end
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	while not HasCollisionLoadedAroundEntity(ped) do
		Wait()
	end
	SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
	SetEntityHeading(ped, heading and heading or 0.0)
	Wait(3000)
	DoScreenFadeIn(1500)
end)

AddEventHandler('hylint_ascenseur:noAccess', function()
    lib.notify({
        title = 'Pas d\'accès',
        description = 'Vous n'avez pas accès à cet étage',
        type = 'error'
    })
end)

AddEventHandler('hylint_ascenseur:openMenu', function(data)
    local elevator = data.elevator
    local floor = data.floor
    local elevatorData = Config.Elevators[elevator]
    local Options = {}

    for k,v in pairs(elevatorData) do
        if k == floor then
            table.insert(Options, {
                title = v.title..' (Étage Actuelle)',
                description = v.description,
                event = '',
            })
        elseif v.groups then
            local found
            for i=1, #v.groups do
                if PlayerData.job.name == v.groups[i] then
                    found = true
                end
            end
            if found then
                table.insert(Options, {
                    title = v.title,
                    description = v.description,
                    event = 'hylint_ascenseur:goToFloor',
                    args = { elevator = elevator, floor = k }
                })
            else
                table.insert(Options, {
                    title = v.title,
                    description = v.description,
                    event = 'hylint_ascenseur:noAccess'
                })
            end
        elseif not v.groups then
            table.insert(Options, {
                title = v.title,
                description = v.description,
                event = 'hylint_ascenseur:goToFloor',
                args = { elevator = elevator, floor = k }
            })
        else
            table.insert(Options, {
                title = v.title,
                description = v.description,
                event = 'hylint_ascenseur:noAccess'
            })
        end
    end
    lib.registerContext({
		id = 'elevator_menu',
		title = 'Elevator Menu',
		options = Options
	})

	lib.showContext('elevator_menu')
end)

CreateThread(function()
    for k,v in pairs(Config.Elevators) do
        for a,b in pairs(Config.Elevators[k]) do
            if b.groups then
                exports[target]:AddBoxZone(k..':'..a, b.coords, b.target.width, b.target.length, {
                    name = k..':'..a,
                    heading = b.target.heading,
                    debugPoly = false,
                    minZ = b.coords.z - 1.5,
                    maxZ = b.coords.z + 1.5
                },
                {
                    options = {
                        {
                            event = 'hylint_ascenseur:openMenu',
                            icon = 'fa-solid fa-hand',
                            label = 'Interact',
                            elevator = k,
                            floor = a
                        },
                    },
                    distance = 1.5 
                })
            else
                exports[target]:AddBoxZone(k..':'..a, b.coords, b.target.width, b.target.length, {
                    name = k..':'..a,
                    heading = b.target.heading,
                    debugPoly = false,
                    minZ = b.coords.z - 1.5,
                    maxZ = b.coords.z + 1.5
                },
                {
                    options = {
                        {
                            event = 'hylint_ascenseur:openMenu',
                            icon = 'fa-solid fa-hand',
                            label = 'Interact',
                            elevator = k,
                            floor = a
                        },
                    },
                    distance = 1.5
                })
            end
        end
    end
end)
