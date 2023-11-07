local QBCore = exports['qb-core']:GetCoreObject()
local GatherProps = {}
local Targets = {}

local function playanim(animdic, anim)
    local ped = PlayerPedId()
    loadAnimDict(animdic)
    TaskPlayAnim(ped, animdic, anim, 1.0, -1.0,-1,1,0,0, 0,0)
    Citizen.Wait(1500)
    ClearPedTasksImmediately(ped)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('flex-scrap:server:GetConfig', function(cfg)
        Config = cfg
    end)
    Wait(5000)
    TriggerEvent('flex-scrap:client:spawngather')
end)

RegisterNetEvent('flex-scrap:client:spawngather', function()
    for k, v in pairs(Config.GatherLocs) do
        if not v.taken then
            local loc = vec3(v.loc.x, v.loc.y, v.loc.z)
            -- local closestObject, closestDistance = QBCore.Functions.GetClosestObject(loc)
            RequestModel(Config.GatherLocs[k].prop)
            while not HasModelLoaded(Config.GatherLocs[k].prop) do
                Wait(1000)
            end
            local spawnedprop = GetClosestObjectOfType(loc.x, loc.y, loc.z, 5.0, GetHashKey(Config.GatherLocs[k].prop), false, true ,true)
            if spawnedprop ~= GetHashKey(Config.GatherLocs[k].prop) then
                GatherProps['prop'..k] = CreateObjectNoOffset(Config.GatherLocs[k].prop, Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z, 1, 0, 1)
                SetEntityHeading(GatherProps['prop'..k], Config.GatherLocs[k].loc.w)
                FreezeEntityPosition(GatherProps['prop'..k], true)
                PlaceObjectOnGroundProperly(GatherProps['prop'..k])
                local proploc = vector3(Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z)
                Targets["target"..k] = exports['qb-target']:AddBoxZone("target"..k, proploc, 0.5, 0.5, {
                    name = "target"..k,
                    heading = 0.0,
                    debugPoly = Config.Debug,
                    minZ = proploc.z-0.2,
                    maxZ = proploc.z+0.2,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "flex-scrap:client:gather",
                            icon = "fa fa-hand-rock-o",
                            label = Lang:t("text.gather"),
                            action = function()
                                TriggerEvent("flex-scrap:client:gather", k)
                            end,
                            canInteract = function()
                                return not Config.GatherLocs[k].taken
                            end,
                        }
                    },
                    distance = 1.5
                })
                if Config.Debug then
                    print('prop and zones loaded')
                end
            end
        end
    end
end)

RegisterNetEvent('flex-scrap:client:gather', function(k)
    playanim('random@domestic', 'pickup_low')
    -- Targets["target"..k] = nil
    TriggerServerEvent('flex-scrap:server:gather', k, true)
    SetTimeout(1000 * 60 * Config.GatherReset, function()
        TriggerServerEvent('flex-scrap:server:gather', k, false)
    end)
    TriggerServerEvent('flex-scrap:server:reward', Config.GatherLocs[k].reward, false)
end)

RegisterNetEvent('flex-scrap:client:gatherstate', function(k, state)
    QBCore.Functions.FaceToPos(Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z)
    Config.GatherLocs[k].taken = state
    exports['qb-target']:RemoveZone("target"..k)
    if DoesEntityExist(GatherProps['prop'..k]) then
        DeleteEntity(GatherProps['prop'..k])
        GatherProps['prop'..k] = nil
    end
    if state == false then
        if not Config.GatherLocs[k].taken then
            local loc = vec3(Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z)
            -- local closestObject, closestDistance = QBCore.Functions.GetClosestObject(loc)
            RequestModel(Config.GatherLocs[k].prop)
            while not HasModelLoaded(Config.GatherLocs[k].prop) do
                Wait(1000)
            end
            local spawnedprop = GetClosestObjectOfType(loc.x, loc.y, loc.z, 5.0, GetHashKey(Config.GatherLocs[k].prop), false, true ,true)
            if spawnedprop ~= GetHashKey(Config.GatherLocs[k].prop) then
                GatherProps['prop'..k] = CreateObjectNoOffset(Config.GatherLocs[k].prop, Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z, 1, 0, 1)
                SetEntityHeading(GatherProps['prop'..k], Config.GatherLocs[k].loc.w)
                FreezeEntityPosition(GatherProps['prop'..k], true)
                PlaceObjectOnGroundProperly(GatherProps['prop'..k])
                local proploc = vector3(Config.GatherLocs[k].loc.x, Config.GatherLocs[k].loc.y, Config.GatherLocs[k].loc.z)
                Targets["target"..k] = exports['qb-target']:AddBoxZone("target"..k, proploc, 0.5, 0.5, {
                    name = "target"..k,
                    heading = 0.0,
                    debugPoly = Config.Debug,
                    minZ = proploc.z-0.2,
                    maxZ = proploc.z+0.2,
                }, {
                    options = {
                        {
                            type = "client",
                            event = "flex-scrap:client:gather",
                            icon = "fa fa-openid",
                            label = Lang:t("text.gather"),
                            action = function()
                                TriggerEvent("flex-scrap:client:gather", k)
                            end,
                            canInteract = function()
                                return not Config.GatherLocs[k].taken
                            end,
                        }
                    },
                    distance = 1.5
                })
                if Config.Debug then
                    print('prop and zones loaded')
                end
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    for k, v in pairs(GatherProps) do
        if DoesEntityExist(v) then
            DeleteEntity(v)
        end
    end
    for k in pairs(Targets) do exports['qb-target']:RemoveZone(k) end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        QBCore.Functions.TriggerCallback('flex-scrap:server:GetConfig', function(cfg)
            Config = cfg
        end)
        Wait(5000)
        TriggerEvent('flex-scrap:client:spawngather')
    end
end)