Config = {}
Config.Locale = "EN"
Config.CashItemName = "money"
Config.Target = true                      --false : markers
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
        title = "Market",
        description = msg,
        type = type
    })
end)


Config.Shops = {
    [1] = {
        coords = vector4(86.4169, 811.4008, 211.1208, 232.9422),
        ped = "a_m_m_beach_01",
        enableSell = true,
        label = {
            enabled = true,
            label = "Illegal trader",
            distance = 15.0
        },
        items_for_buy = {
            { name = "burger",           label = "Burger", price = 50 },
            { name = "water",           label = "Víz",  price = 222 },
            { name = "weapon_appistol", label = "Pistol", price = 22 }
        },
        items_to_sell = { -- Only if enableSell is true
            { name = "ammo-9", label = "9mm Ammo", price = 110 }
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
    },
    [2] = {
        coords = vector4(698.663757, 617.235168, 129.030762, 70.866142),
        ped = "a_m_m_beach_01",
        enableSell = false,
        label = {
            enabled = true,
            label = "Illegal trader",
            distance = 15.0
        },
        items_for_buy = {
            { name = "lockpick", label = "Lockpick", price = 5 }
        },
        items_to_sell = { -- Only if enableSell is true
            { name = "fishing_rod", label = "Fishing rod", price = 10 }
        },
        blip = {
            enabled = false,
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
    },
}

Config.Locales = {
    ["EN"] = {
        BuyTarget = "Illegal shop",
        textUI = "[E] - Open menu",
        NotEnoughMoney = "Not enough money",
        SuccessBuy = "Success buy",
        SuccessSell = "Success sell",
        CantCarryItem = "You cant carry this much weight",
        HasNoItem = "Item not founded"
    },
    ["HU"] = {
        BuyTarget = "Illegálbolt",
        textUI = "[E] - Nyisd meg a menüt",
        NotEnoughMoney = "Sikertelen vásárlás, nincs elég pénzed",
        SuccessBuy = "Sikeres vásárlás",
        SuccessSell = "Sikeres eladás",
        CantCarryItem = "Nem birsz el ennyi tárgyat",
        HasNoItem = "Nincs ilyen tárgyad"
    }
}

