fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'ALTRP illegal shop using esx'
author 'goshawk1337'
version '1.0.0'


shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'webhook.lua',
    'server/sv_main.lua',
}
dependencies {
    "ox_lib",
    "ox_inventory"
}