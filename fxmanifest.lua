fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'NoLo Store'
description 'Taxi Job'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua' 
}


client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

escrow_ignore {
    'shared/config.lua'
}

