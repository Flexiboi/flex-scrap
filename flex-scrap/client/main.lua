local QBCore = exports['qb-core']:GetCoreObject()
local EnterZones = {}
local isInEnterZone, entered, isdoingjob, randomloc = false, false, false, vec3(0,0,0)
local itemid, item, itemprop, pickupprop, hasitem = 1, nil, nil, nil, false
local interorprops = {}
local blips = {}
local enteredlocation = 0

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    for k, loc in pairs(Config.tp.enter) do
        blips[k] = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blips[k], Config.blip.sprite)
        SetBlipColour(blips[k], Config.blip.color)
        SetBlipScale(blips[k], Config.blip.scale)
        SetBlipAsShortRange(blips[k], true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.blip.blipname)
        EndTextCommandSetBlipName(blips[k])
    end
end)

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function enterAnim()
    loadAnimDict("anim@heists@keycard@") 
    TaskPlayAnim( GetPlayerPed(-1), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Citizen.Wait(400)
    ClearPedTasks(GetPlayerPed(-1))
end

function teleport(ped, x, y, z, w)
    CreateThread(function()
        SetEntityCoords(ped, x, y, z, 0, 0, 0, false)
        SetEntityHeading(ped, w)
        Wait(100)
        DoScreenFadeIn(1000)
    end)
end

local function loadInterior()
    for k, loc in pairs(Config.GrabLocations) do
      local model = GetHashKey(Config.WarehouseProps[math.random(1, #Config.WarehouseProps)])
      RequestModel(model)
      while not HasModelLoaded(model) do
        Wait(0)
      end
      interorprops[k] = CreateObject(model, loc.x, loc.y, loc.z-1, false, true, true)
      PlaceObjectOnGroundProperly(interorprops[k])
      FreezeEntityPosition(interorprops[k], true)
    end
end

for k, loc in pairs(Config.tp.enter) do

    EnterZones[k] = BoxZone:Create(loc, 3.0, 3.0, {
        name = 'enterzone'..k,
        useZ = true,
        debugPoly = Config.Debug
    })

    EnterZones[k]:onPlayerInOut(function(isPointInside, point)
        isInEnterZone = isPointInside
        if isPointInside then
            exports['qb-core']:DrawText('[E] - Ga binnen', 'left')
            CreateThread(function()
                while isInEnterZone do
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    if IsControlJustReleased(0, 38) then
                        exports['qb-core']:KeyPressed()
                        exports['qb-core']:HideText()
                        enteredlocation = k
                        enterAnim()
                        teleport(ped, Config.tp.leave.x, Config.tp.leave.y, Config.tp.leave.z+0.5, 0)
                        enter()
                        exports['flex-portablecraftbench']:BenchPlaceState(false)
                        loadInterior()
                        break
                    end
                    Wait(0)
                end
            end)
        else
            exports['qb-core']:HideText()
        end
    end)
end

-- local enetrwait = 1
-- CreateThread(function()
--     while true do
--         Citizen.Wait(enetrwait)
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)
--         for k, loc in pairs(Config.tp.enter) do
--             local enterloc = #(loc - pos)
--             if enterloc < 3 then
--                 enetrwait = 1
--                 QBCore.Functions.DrawText3D(loc.x, loc.y, loc.z, '[~o~E~w~]'..Lang:t("text.enterloc"))
--                 if IsControlJustReleased(0, 38) then
--                     enteredlocation = k
--                     enterAnim()
--                     teleport(ped, Config.tp.leave.x, Config.tp.leave.y, Config.tp.leave.z+0.5, 0)
--                     enter()
--                     exports['flex-portablecraftbench']:BenchPlaceState(false)
--                     loadInterior()
--                 end
--             else
--                 enetrwait = 1000
--             end
--         end
--     end
-- end)

CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local leaveloc = #(Config.tp.leave - pos)
        if leaveloc < 3 then
            QBCore.Functions.DrawText3D(Config.tp.leave.x, Config.tp.leave.y, Config.tp.leave.z, '[~o~E~w~]'..Lang:t("text.leaveloc"))
            if IsControlJustReleased(0, 38) then
                if not isdoingjob then
                    enterAnim()
                    teleport(ped, Config.tp.enter[enteredlocation].x, Config.tp.enter[enteredlocation].y, Config.tp.enter[enteredlocation].z, 0)
                    entered = false
                    for k, ent in pairs(interorprops) do
                        if DoesEntityExist(ent) then
                            SetEntityAsMissionEntity(ent, false, false)
                            DeleteObject(ent)
                        end
                    end
                    exports['flex-portablecraftbench']:BenchPlaceState(true)
                else
                    QBCore.Functions.Notify(Lang:t("error.gooffduty"), "error", 5000)
                end
            end
        end
    end
end)

function enter()
    entered = true
    CreateThread(function()
        while true do
            Citizen.Wait(1)
            if entered then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local jobloc = #(Config.StartJobLocation - pos)
                local takeloc = #(randomloc - pos)
                local dropoffloc = #(Config.DropOffLocation - pos)
                if jobloc < 3 then
                    if not isdoingjob then
                        QBCore.Functions.DrawText3D(Config.StartJobLocation.x, Config.StartJobLocation.y, Config.StartJobLocation.z, '[~o~E~w~]'..Lang:t("text.startjob"))
                    else
                        QBCore.Functions.DrawText3D(Config.StartJobLocation.x, Config.StartJobLocation.y, Config.StartJobLocation.z, '[~o~E~w~]'..Lang:t("text.stopjob"))
                    end
                    if jobloc < 1 then
                        if IsControlJustReleased(0, 38) and not hasitem then
                            isdoingjob = not isdoingjob
                            if isdoingjob then
                                QBCore.Functions.Notify(Lang:t("success.onduty"), "success", 5000)
                                QBCore.Functions.Notify(Lang:t("success.startedjob"), "success", 5000)
                                randomloc = Config.GrabLocations[math.random(1,#Config.GrabLocations)]
                                itemid = math.random(1, #Config.items)
                                item = Config.items[itemid].item
                                itemprop = Config.items[itemid].propname
                                hasitem = false
                                takelock()
                            else
                                QBCore.Functions.Notify(Lang:t("error.offduty"), "error", 5000)
                            end
                        end
                    end
                elseif dropoffloc < 5 and hasitem then
                    -- QBCore.Functions.DrawText3D(Config.DropOffLocation.x, Config.DropOffLocation.y, Config.DropOffLocation.z, '[~o~E~w~]'..Lang:t("text.droploc"))
                    if dropoffloc < 3 then
                        if hasitem then
                            exports['qb-core']:DrawText('[E] '..Lang:t("text.droploc"), 'left')
                        end
                        if IsControlJustReleased(0, 38) then
                            QBCore.Functions.Progressbar('deliver_item', Lang:t("info.deliver"), Config.deliverTime * 1000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            }, {
                                animDict = "mini@repair",
                                anim = "fixing_a_ped",
                                }, {}, {}, function() -- Success
                                if DoesEntityExist(pickupprop) then
                                    SetEntityAsMissionEntity(pickupprop, false, false)
                                    DeleteObject(pickupprop)
                                    ClearPedTasks(ped)
                                    TriggerServerEvent('flex-scrap:server:reward', item, true)
                                    QBCore.Functions.Notify(Lang:t("success.startedjob"), "success", 5000)
                                    randomloc = Config.GrabLocations[math.random(1,#Config.GrabLocations)]
                                    itemid = math.random(1, #Config.items)
                                    item = Config.items[itemid].item
                                    itemprop = Config.items[itemid].propname
                                    hasitem = false
                                    exports['qb-core']:HideText()
                                end
                            end, function() -- Cancel
                                ClearPedTasks(ped)
                                QBCore.Functions.Notify(Lang:t("error.stoped"), 'error', 5000)
                            end)
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

local updown = false
function takelock()
    CreateThread(function()
        while true do
            Citizen.Wait(1)
            if isdoingjob then
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local takeloc = #(randomloc - pos)
                if takeloc < 45 and not hasitem then
                    DrawMarker(0, randomloc.x, randomloc.y, randomloc.z+2.0, 0, 0, 0, 0.0, 0, 0, 1.0, 1.0, 1.0, 0, 150, 0, 120, true, true, 2, false, nil, nil, false)
                    if takeloc < 3 then
                        if not hasitem then
                            exports['qb-core']:DrawText('[E] '..Lang:t("text.pickuploc"), 'left')
                        end
                        if IsControlJustReleased(0, 38) then
                            loadAnimDict('anim@heists@box_carry@')
                            TaskPlayAnim(ped, "anim@heists@box_carry@", "idle" ,2.0, 2.0, -1, 51, 0, false, false, false)
                            pickupprop = CreateObject(joaat(itemprop), pos.x, pos.y, pos.z + 0.2, true, true, true)
                            SetEntityCollision(pickupprop, false, false)
                            AttachEntityToEntity(pickupprop, ped, GetPedBoneIndex(ped, 60309), Config.items[itemid].itempos.xPos, Config.items[itemid].itempos.yPos, Config.items[itemid].itempos.zPos, Config.items[itemid].itempos.xRot, Config.items[itemid].itempos.yRot, Config.items[itemid].itempos.zRot, true, true, false, true, 1, true)
                            hasitem = true
                            exports['qb-core']:HideText()
                        end
                    end
                end
            else
                break
            end
        end
    end)
end

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
    for k, v in pairs(EnterZones) do
        EnterZones[k]:destroy()
    end
    exports['qb-target']:RemoveTargetModel(Config.copperCuttingModels)
    for k, ent in pairs(interorprops) do
        if DoesEntityExist(ent) then
            SetEntityAsMissionEntity(ent, false, false)
            DeleteObject(ent)
        end
    end
end)