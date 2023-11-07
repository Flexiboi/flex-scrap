local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("flex-scrap:server:GetConfig", function(source, cb)
    cb(Config)
end)
RegisterNetEvent('flex-scrap:server:reward', function(item, iscoppercut)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.AddItem(item, Config.rewardAmount) and Player ~= nil then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", Config.rewardAmount)
    end
    if iscoppercut then
        if math.random(0, 100) <= Config.LoseCutItemChance then
            Player.Functions.RemoveItem(Config.CutItem, 1, false)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[Config.CutItem], "remove")
        end
    end
end)

RegisterNetEvent('flex-scrap:server:gather', function(k, state)
    Config.GatherLocs[k].taken = state
    TriggerClientEvent('flex-scrap:client:gatherstate', -1, k, state)
end)