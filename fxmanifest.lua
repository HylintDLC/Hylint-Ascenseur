-----------------Pour obtenir de l'aide, des scripts, etc.----------------
--------------- https://discord.gg/c9ZMqvMUEE  ---------------------------
--------------------------------------------------------------------------


fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description "Hylint Ascenseur ESX/QbCore"

author 'hylint'

version '1.0.2'

client_scripts {
	'client.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

dependencies {
	'ox_lib',
	'ox_target'
}
