Config = {}
Config.Locale = "HU"
Config.CashItemName = "money"
Config.EnableSell = true                  -- false : sell is not available
Config.Target = true                      --false : markers
Config.menuAlign = "top-left"             ---- top-left | top-right | bottom-left | bottom-right | center |
Config.Textui_enabled = not Config.Target --Dont bother

Config.TextUI = function(msg, type)
    if type == "show" then
        --switch it to your preferred text ui functions
        lib.showTextUI(msg)
    else
        --switch it to your preferred text ui functions
        lib.hideTextUI()
    end
end
RegisterNetEvent("shop:notify")
AddEventHandler("shop:notify", function(type, msg)
    if type == "info" then
        type = "info"
    elseif type == "success" then
        type = "success"
    elseif type == "error" then
        type = "error"
    end

    lib.notify({
        title = "market",
        description = msg,
        type = type
    })
end)


Config.Shops = {
    [1] = {
        coords = vector4(86.4169, 811.4008, 211.1208, 232.9422),
        ped = "a_m_m_beach_01",
        label = {
            enabled = true,
            label = "Illegal trader",
            distance = 15.0
        },
        items_for_buy = {
            { name = "bread",           label = "kenyer", price = 50 },
            { name = "water",           label = "water",  price = 222 },
            { name = "weapon_appistol", label = "pistol", price = 22 }

        },
        items_to_sell = {
            { name = "bread", label = "kenyer", price = 110 }
        },
        blip = {
            enabled = true,
            label = "Illegal shop",
            sprite = 123,
            scale = 1.0,
            colour = 22
        },
        MarkerSettings = {
            type = 2,
            size = { x = 1.0, y = 1.0, z = 1.0 },
            rgba = { r = 13, g = 3, b = 7, a =33 },
            rotate = false,
            width = 1.0,
            height = 1.0
        }

    }
}

Config.Locales = {
    ["EN"] = {
        BuyTarget = "Item buy",
        SellTarget = "Item sell",
        textUI = "[E] - Open menu",
        SelectSell = "Tárgy eladás",
        SelectBuy = "Item buy",
        BuyMenuTitle = "Item sell",
        SellMenuTitle = "Sell item",
        NotEnoughMoney = "Not enough money",
        SuccessBuy = "Success buy",
        SuccessSell = "Success sell",
        CantCarryItem = "You cant carry this much weight",
        HasNoItem = "Item not founded"
    },
    ["HU"] = {
        BuyTarget = "tárgy vétel",
        SellTarget = "tárgy eladás",
        textUI = "[E] - nyisd meg a menüt",
        SelectSell = "Tárgy eladás",
        SelectBuy = "Tárgy Vásárlása",
        BuyMenuTitle = "Tárgy Vásárlása",
        SellMenuTitle = "Tárgy Eladása",
        NotEnoughMoney = "Sikertelen vásárlás, nincs elég pénzed",
        SuccessBuy = "Sikeres vásárlás",
        SuccessSell = "Sikeres eladás",
        CantCarryItem = "Nem birsz el ennyi tárgyat",
        HasNoItem = "Nincs ilyen tárgyad"
    }
}

