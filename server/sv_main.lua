RegisterNetEvent("ItemManagement")
AddEventHandler("ItemManagement", function(item, price, label, amount, type)
    if type == "buy" then
        if exports.ox_inventory:GetItemCount(source, Config.CashItemName) >= price then
            if exports.ox_inventory:CanCarryItem(source, item, amount) then
                exports.ox_inventory:AddItem(source, item, amount)
                exports.ox_inventory:RemoveItem(source, Config.CashItemName, price * amount)
                TriggerClientEvent("shop:notify", source, "success", Config.Locales[Config.Locale].SuccessBuy)
                SendToDiscord("Player name: "..GetPlayerName(source).." \n Item: "..label.. "\n mennyiség: "..amount, "FinalZ scripts", "buy")
            else
                TriggerClientEvent("shop:notify", source, "error", Config.Locales[Config.Locale].CantCarryItem)
            end
        else
            TriggerClientEvent("shop:notify", source, "error", Config.Locales[Config.Locale].NotEnoughMoney)
        end
    else
        if exports.ox_inventory:GetItemCount(source, item) > 0 then
            exports.ox_inventory:RemoveItem(source, item, amount)
            exports.ox_inventory:AddItem(source, Config.CashItemName, price * amount)
            TriggerClientEvent("shop:notify", source, "success", Config.Locales[Config.Locale].SuccessSell)
            SendToDiscord("Player name: "..GetPlayerName(source).." \n Item: "..label.. "\n mennyiség: "..amount, "FinalZ scripts", "sell")
        else
            TriggerClientEvent("shop:notify", source, "error", Config.Locales[Config.Locale].HasNoItem)
        end
    end
end)


function SendToDiscord(description, footer, type)
    local sendD = {
        {
            ["color"] = 15548997,
            ["title"] = Webhook.settings.title,
            ["description"] = description,
            ["footer"] = {
                ["text"] = footer
            },
        }
    }
    if type == "sell" then
        PerformHttpRequest(Webhook.settings.sell, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ scripts ELADÁS", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    else
        PerformHttpRequest(Webhook.settings.buy, function(err, text, headers)
        end, 'POST', json.encode({ username = "FinalZ scripts VÁSÁRLÁS", embeds = sendD }), { ['Content-Type'] = 'application/json' })
    end
   
  end