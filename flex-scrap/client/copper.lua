local QBCore = exports['qb-core']:GetCoreObject()
local stunned = false
local lastcutloc = nil

if Config.steelCopperTarget then
    exports['qb-target']:AddTargetModel(Config.copperCuttingModels, {
        options = {
            {
                icon = "fas fa-hands",
                label = Lang:t("text.stealcopper"),
                action = function()
                    local ped = PlayerPedId()
                    local pos = GetEntityCoords(ped)
                    if lastcutloc ~= nil then
                        local lastdist = #(lastcutloc - pos)
                        if lastdist < 2 then
                            return QBCore.Functions.Notify(Lang:t("error.cutherealready"), "error", 4500)
                        end
                    end
                    if QBCore.Functions.HasItem(Config.CutItem, 1) then
                        lastcutloc = pos
                        local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
                        QBCore.Functions.RequestAnimDict(animDict)
                        TaskPlayAnim(ped, animDict, "weed_crouch_checkingleaves_idle_01_inspector", 5.0, 5.0, -1, 0, 0.0, false, false, false)
                        QBCore.Functions.Progressbar("cuttingcopper", Lang:t("text.cuttinhcopper"), Config.cutTime * 1000, false, true, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = nil,
                            anim = nil,
                            flags = nil,
                            task = nil,
                        }, {}, {},function()
                            TriggerServerEvent('flex-scrap:server:reward', 'copper', false)
                            if math.random(0,100) < Config.policeAlertChance then
                                policealert()
                            end
                            if math.random(0,100) < Config.shockChance then
                                ClearPedTasks(ped)
                                if not IsEntityPlayingAnim(ped, "stungun@standing", "damage", 3 ) and not stunned then
                                    sleep = 5000
                                    stunned = true
                                    local healt = GetEntityHealth(ped)
                                    loadAnimDict("stungun@standing") 
                                    TaskPlayAnim(ped, "stungun@standing", "damage", 8.0, 1.0, 10000, 1, 0, false, false, false)
                                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
                                    local n = math.floor(healt-Config.stealDamage)
                                    SetEntityHealth(ped,n)
                                    Citizen.SetTimeout(6000, function()
                                        ClearPedTasks(ped)
                                        stunned = false
                                    end)
                                end
                            end
                        end, function()
                            ClearPedTasks(ped)
                            QBCore.Functions.Notify(Lang:t("error.stoppedcutting"), "error", 4500)
                        end)
                    else
                        QBCore.Functions.Notify(Lang:t("error.missingcutitem"), "error", 4500)
                    end
                end,
            },
        },
        distance = 1.3,
    })
end