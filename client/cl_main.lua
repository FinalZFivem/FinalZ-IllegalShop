local peds = {}
local nametags = {}
local blips = {}
local Elements = {}
local Sellements = {}

function OpenSellMenu(id)
	for i=1, #Config.Shops[id].items_to_sell, 1 do
		Item = Config.Shops[id].items_to_sell[i]
		Sellements[#Sellements+1] = {
			label = Item.label,
			name = Item.name,
            value = 1,
            type = 'slider',
            min = 1,
            max = 10,
			price = Item.price
		}
	end

      ESX.UI.Menu.Open("default", GetCurrentResourceName(), "sell", {
        title = Config.Locales[Config.Locale].SellMenuTitle,
        align    = Config.menuAlign, 
        elements = Sellements 
      }, function(data,menu) -- OnSelect Function

    
        if data.current.name then
            TriggerServerEvent("ItemManagement",
            data.current.name, 
            data.current.price, 
            data.current.label,
            data.current.value,
            "sell"
            )
        end
      end, function(data, menu) -- Cancel Function
        menu.close() -- close menuű

        local count = #Sellements
        for i=0, count do Sellements[i]=nil end
      end)
    end


    function OpenBuyMenu(id)
        for i=1, #Config.Shops[id].items_for_buy, 1 do
            Item = Config.Shops[id].items_for_buy[i]
            Elements[#Elements+1] = {
                label = Item.label,
                name = Item.name,
                value = 1,
                type = 'slider',
                min = 1,
                max = 10,
                price = Item.price
            }
        end
          ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Sellements", {
            title = Config.Locales[Config.Locale].BuyMenuTitle,
            align    = Config.menuAlign, 
            elements = Elements 
          }, function(data,menu) -- OnSelect Function
    
        
            if data.current.name then
                TriggerServerEvent("ItemManagement",
                data.current.name, 
                data.current.price, 
                data.current.label,
                data.current.value,
                "buy"
                )
            end
          end, function(data, menu) -- Cancel Function
            menu.close() -- close menuű
            local count = #Elements
            for i=0, count do Elements[i]=nil end
          end)
        end

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
            local label = CreateMpGamerTag(peds[k], v.label.label, false, false, "", 0)
            SetMpGamerTagsVisibleDistance(v.label.distance)
            nametags[#nametags + 1] = label
        end

        if Config.Target then
            exports.ox_target:addLocalEntity(peds, {
                {
                    label = Config.Locales[Config.Locale].BuyTarget,
                    name = k .. "buyMenu",
                    icon = "fa-solid fa-fish-fins",
                    distance = 2.5,
                    onSelect = function()
                        OpenBuyMenu(k)
                    end,
                },
            })
            if Config.EnableSell then
                exports.ox_target:addLocalEntity(peds, {
                    {
                        label = Config.Locales[Config.Locale].SellTarget,
                        name = k .. "SellMenu",
                        icon = "fa-solid fa-fish-fins",
                        distance = 2.5,
                        onSelect = function()

                            OpenSellMenu(k)
                        end,
                    },
                })
            end
        else
            for k,v in pairs(Config.Shops) do
                local point = lib.points.new({
                    coords = v.coords,
                    distance = 2,
                })
    
                function point:onEnter()
                    if Config.Textui_enabled then 
                    Config.TextUI(Config.Locales[Config.Locale].textUI,"show")
                end
            end
                 
                function point:onExit()
                    Config.TextUI(Config.Locales[Config.Locale].textUI,"hide")
                end
                 
                function point:nearby()
                    local marker = lib.marker.new({
                        type = v.MarkerSettings.type,
                        coords = v.coords,
                        width = v.MarkerSettings.width,
                        height  = v.MarkerSettings.height,
                        color = { r = v.MarkerSettings.rgba.r, g = v.MarkerSettings.rgba.g, v.MarkerSettings.rgba.b, a = v.MarkerSettings.rgba.a },
                        rotation = v.MarkerSettings.rotate
                    })
                    marker:draw()

                    if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
                        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "choose", {
                            title = Config.Locales[Config.Locale].TypeMenuTitle,
                            align    = Config.menuAlign, 
                            elements = {
                                {label = Config.Locales[Config.Locale].SelectBuy, name = "buy"},
                                {label = Config.Locales[Config.Locale].SelectSell, name = "sell"},
                            } 
                          }, function(data,menu) -- OnSelect Function
                    
                        
                            if data.current.name == "buy" then
                                OpenBuyMenu(k)
                            elseif data.current.name == "sell" then
                                OpenSellMenu(k)
                            end
                          end, function(data, menu) -- Cancel Function
                            menu.close() -- close menuű
                            local count = #Elements
                            for i=0, count do Elements[i]=nil end
                          end)
                        end
                    end
                end
            --text ui - marker - oxpoints
        end
        if v.blip.enabled then
            local blip = AddBlipForCoord(v.coords.xyz)
            blips[#blips + 1] = blip
            SetBlipSprite(blips[k], v.blip.sprite)
            SetBlipColour(blips[k], v.blip.colour)
            SetBlipDisplay(blips[k], 4)
            SetBlipAsShortRange(blips[k], true)
            SetBlipScale(blips[k], v.blip.scale)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blips[k])
        end
    end
end

CreateThread(function()
    initShops()
    while true do
        Wait(500)
        for k, v in pairs(Config.Shops) do
            local distance = #(GetEntityCoords(cache.ped ) - v.coords.xyz)

            if distance > 2.5 then
                ESX.UI.Menu.CloseAll()
            end
        end
    end
end)
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end