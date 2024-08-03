fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Standalone illegal shop'
author 'FinalZ Scripts'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'webhook.lua',
    'server/sv_main.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/app.js'
}

dependencies {
    "ox_lib",
    "ox_inventory"
}
