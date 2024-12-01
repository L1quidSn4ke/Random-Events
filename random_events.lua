local QBCore = exports['qb-core']:GetCoreObject()

-- Define the events and their rewards
local events = {
    {
        name = "Money Drop",
        time = "09:00",
        reward = { type = "money", amount = 5000 }
    },
    {
        name = "Weapon Drop",
        time = "13:00",
        reward = { type = "weapon", weapon = "WEAPON_PISTOL" }
    },
    {
        name = "Item Drop",
        time = "17:00",
        reward = { type = "item", item = "lockpick" }
    }
}

-- Function to get the current time in the game
function GetGameTime()
    local hours = GetClockHours()
    local minutes = GetClockMinutes()
    return string.format("%02d:%02d", hours, minutes)
end

-- Function to check if it's time for an event
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute
        local currentTime = GetGameTime()

        for _, event in ipairs(events) do
            if currentTime == event.time then
                TriggerEvent('woodlandrp:startEvent', event)
            end
        end
    end
end)

-- Event to start the random event
RegisterNetEvent('randomevents:startEvent')
AddEventHandler('randomevents:startEvent', function(event)
    local players = GetPlayers()

    for _, player in ipairs(players) do
        local xPlayer = QBCore.Functions.GetPlayer(player)
        if xPlayer then
            if event.reward.type == "money" then
                xPlayer.Functions.AddMoney('cash', event.reward.amount)
                TriggerClientEvent('QBCore:Notify', player, "You received $"
.. event.reward.amount .. " from the " .. event.name .. "!")
            elseif event.reward.type == "weapon" then
                xPlayer.Functions.AddItem(event.reward.weapon, 1)
                TriggerClientEvent('QBCore:Notify', player, "You received a
" .. event.reward.weapon .. " from the " .. event.name .. "!")
            elseif event.reward.type == "item" then
                xPlayer.Functions.AddItem(event.reward.item, 1)
                TriggerClientEvent('QBCore:Notify', player, "You received a
" .. event.reward.item .. " from the " .. event.name .. "!")
            end
        end
    end
end)

-- Function to get all players
function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, player)
    end
    return players
end
