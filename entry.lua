self_ID = "F-35A/B/C Lightning II by No-Stop Productions"
declare_plugin(self_ID,
{
image     	 = "F-35.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("F-35"),
developerName = _("No-Stop Productions"),

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
--[[ binaries 	 =
{
'F-35A',
}, ]]
	
})
----------------------------------------------------------------------------------------
mount_vfs_model_path	(current_mod_path.."/Cockpit/Shape")
mount_vfs_texture_path	(current_mod_path.."/Cockpit/Textures/CPT-F-35-TEXTURES.zip")
mount_vfs_liveries_path (current_mod_path.."/Liveries")
mount_vfs_texture_path	(current_mod_path.."/Skins/1/ME")--for simulator loading window

dofile(current_mod_path.."/Views.lua")

--[[ local cfg_path = current_mod_path .."/FM/config.lua"
dofile(cfg_path)
FM[1] 			= self_ID
FM[2] 			= 'F-35A'
FM.config_path 	= cfg_path
FM.old 			= 6 ]]
-------------------------------------------------------------------------------------
make_view_settings('F-35A', ViewSettings, SnapViews)
--make_view_settings('F-35B', ViewSettings, SnapViews)
--make_view_settings('F-35C', ViewSettings, SnapViews)
<<<<<<< Updated upstream
--make_flyable('F-35A',current_mod_path..'/Cockpit/Scripts/',FM, current_mod_path..'/comm.lua')
make_flyable('F-35A',current_mod_path..'/Cockpit/Scripts/',nil, current_mod_path..'/comm.lua')
--make_flyable('F-35B',current_mod_path..'/Cockpit/Scripts/', FM, current_mod_path..'/comm.lua')
--make_flyable('F-35C',current_mod_path..'/Cockpit/Scripts/', FM, current_mod_path..'/comm.lua')
=======
make_flyable('F-35A',current_mod_path..'/Cockpit/Scripts/',nil, current_mod_path..'/comm.lua')
--make_flyable('F-35B',current_mod_path..'/Cockpit/Scripts/',F35B, current_mod_path..'/comm.lua')
--make_flyable('F-35C',current_mod_path..'/Cockpit/Scripts/',F35C, current_mod_path..'/comm.lua')
>>>>>>> Stashed changes
-------------------------------------------------------------------------------------
plugin_done()
