fx_version 'bodacious'

game 'gta5'

lua54 'true'

server_scripts {
    '@ox_core/imports/server.lua',
    'server/class/player.lua',
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/class/status.lua',
    'client/*.lua',
}

dependencies {
    'sc-utils'
}