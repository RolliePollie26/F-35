self_ID = "F-35A/B/C Lightning II by Foxtrot Oscar Simulation Designs"
declare_plugin(self_ID,
{
image     	 = "F-35.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("F-35"),
developerName = _("Foxtrot Oscar Simulation Designs"),

fileMenuName = _("F-35"),
update_id        = "F-35",
version		 = __DCSVERSION__,
state		 = "installed",
info		 = _("F-35A/B/C Lightning II for DCS World."),

Skins	=
	{
		{
		    name	= _("F-35"),
			dir		= "Skins/1"
		},
	},
Missions =
	{
		{
			name		    = _("F-35"),
			dir			    = "Missions",
  		},
	},
LogBook =
	{
		{
			name		= _("F-35A"),
			type		= "F-35A",
		},
	},	
		
InputProfiles =
	{
		["F-35A"] = current_mod_path .. '/Input/F-35A',
	},
binaries 	 =
{
	--'F35Cockpit',
	'F35A',
	--'F35B',
	--'F35C',
},
	
})
----------------------------------------------------------------------------------------
mount_vfs_model_path	(current_mod_path.."/Cockpit/Shape")
mount_vfs_texture_path	(current_mod_path.."/Cockpit/Textures/CPT-F-35-TEXTURES.zip")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path	(current_mod_path.."/Skins/1/ME")--for simulator loading window

dofile(current_mod_path.."/Views.lua")

local cfg_path = current_mod_path .."/FM/config.lua"
dofile(cfg_path)
F35A[1] 			= self_ID
F35A[2] 			= 'F35A'
F35A.config_path 	= cfg_path
F35A.old 			= 6
-------------------------------------------------------------------------------------
--[[ F35B[1] 			= self_ID
F35B[2] 			= 'F35B'
F35B.config_path 	= cfg_path
F35B.old 			= 6
-------------------------------------------------------------------------------------
F35C[1] 			= self_ID
F35C[2] 			= 'F35C'
F35C.config_path 	= cfg_path
F35C.old 			= 6 ]]
-------------------------------------------------------------------------------------
make_view_settings('F-35A', ViewSettings, SnapViews)
--make_view_settings('F-35B', ViewSettings, SnapViews)
--make_view_settings('F-35C', ViewSettings, SnapViews)
make_flyable('F-35A',current_mod_path..'/Cockpit/Scripts/',F35A, current_mod_path..'/comm.lua')
--make_flyable('F-35B',current_mod_path..'/Cockpit/Scripts/',F35B, current_mod_path..'/comm.lua')
--make_flyable('F-35C',current_mod_path..'/Cockpit/Scripts/',F35C, current_mod_path..'/comm.lua')
--make_flyable('F-35A',current_mod_path..'/Cockpit/Scripts/',nil, current_mod_path..'/comm.lua')
--make_flyable('F-35B',current_mod_path..'/Cockpit/Scripts/',cil, current_mod_path..'/comm.lua')
--make_flyable('F-35C',current_mod_path..'/Cockpit/Scripts/',cil, current_mod_path..'/comm.lua')
-------------------------------------------------------------------------------------
plugin_done()
