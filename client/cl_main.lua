local peds = {}
local nametags = {}
local blips = {}
local Elements = {}
local Sellements = {}

function SetNuiState(state)
    SetNuiFocus(state, state)

    if state then
        TriggerScreenblurFadeIn(0)
      else
        TriggerScreenblurFadeOut(0)
      end

    SendNUIMessage({
        type = "show",
        enable = state
    })
end

AddEventHandler("onResourceStop", function(resname)
    if (resname ~= GetCurrentResourceName()) then return end

    SetNuiState(false)
    TriggerScreenblurFadeOut(0)
  end)

function OpenMenu(id, menuType)
    local items_for_buy = {}
    local items_to_sell = {}

    for i=1, #Config.Shops[id].items_for_buy, 1 do
        local Item = Config.Shops[id].items_for_buy[i]
        table.insert(items_for_buy, {
            label = Item.label,
            name = Item.name,
            value = 1,
            price = Item.price
        })
    end

    if Config.Shops[id].enableSell then
    for i=1, #Config.Shops[id].items_to_sell, 1 do
        local Item = Config.Shops[id].items_to_sell[i]
        table.insert(items_to_sell, {
            label = Item.label,
            name = Item.name,
            value = 1,
                price = Item.price
            })
        end
    end

    SendNUIMessage({
        type = 'show',
        items_for_buy = items_for_buy,
        items_to_sell = items_to_sell,
        enableSell = Config.Shops[id].enableSell,
        enable = true,
        menuType = menuType,
        locale = Config.Locale
    })
    SetNuiState(true)
end

RegisterNUICallback('ItemManagement', function(data, cb)
    TriggerServerEvent("ItemManagement", data.name, data.price, data.label, data.value, data.type)
    cb('ok')
end)

RegisterNUICallback('exit', function(data, cb)
    SetNuiState(false)
    cb('ok')
end)

function initShops()
    for k, v in pairs(Config.Shops) do
        lib.requestModel(v.ped)
        local ped = CreatePed(v.pedType, v.ped, v.coords.x, v.coords.y, v.coords.z - 1, v.coords.w, false, false)
        peds[#peds + 1] = ped

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", -1, false)
        if v.label.enabled then
            local label = CreateMpGamerTag(peds[#peds], v.label.label, false, false, "", 0)
            SetMpGamerTagsVisibleDistance(v.label.distance)
            nametags[#nametags + 1] = label
        end

        if Config.Target then
            exports.ox_target:addLocalEntity(ped, {
                {
                    label = Config.Locales[Config.Locale].BuyTarget,
                    name = k .. "buyMenu",
                    icon = "fa-solid fa-gun",
                    distance = 2.5,
                    onSelect = function()
                        OpenMenu(k, "buy")
                    end,
                },
            })
        else
            local point = lib.points.new({
                coords = v.coords,
                distance = 2,
            })

            function point:onEnter()
                if Config.Textui_enabled then
                    Config.TextUI(Config.Locales[Config.Locale].textUI, "show")
                end
            end

            function point:onExit()
                Config.TextUI(Config.Locales[Config.Locale].textUI, "hide")
            end

            function point:nearby()
                local marker = lib.marker.new({
                    type = v.MarkerSettings.type,
                    coords = v.coords,
                    width = v.MarkerSettings.width,
                    height = v.MarkerSettings.height,
                    color = { r = v.MarkerSettings.rgba.r, g = v.MarkerSettings.rgba.g, b = v.MarkerSettings.rgba.b, a = v.MarkerSettings.rgba.a },
                    rotation = v.MarkerSettings.rotate
                })
                marker:draw()

                if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
                    OpenMenu(k, "choose")
                end
            end
        end

        if v.blip.enabled then
            local blip = AddBlipForCoord(v.coords.xyz)
            blips[#blips + 1] = blip
            SetBlipSprite(blips[#blips], v.blip.sprite)
            SetBlipColour(blips[#blips], v.blip.colour)
            SetBlipDisplay(blips[#blips], 4)
            SetBlipAsShortRange(blips[#blips], true)
            SetBlipScale(blips[#blips], v.blip.scale)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blips[#blips])
        end
    end
end

CreateThread(function()
    initShops()
end)

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
