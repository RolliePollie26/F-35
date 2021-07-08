dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

indicator_type = indicator_types.COLLIMATOR
purpose = {render_purpose.GENERAL,render_purpose.HUD_ONLY_VIEW}

BASE = 1
INDICATION = 2

page_subsets = {
    [BASE] = LockOn_Options.script_path.."Displays/HUD/Indicator/base_page.lua",
    [INDICATION] = LockOn_Options.script_path.."Displays/HUD/Indicator/indication_page.lua",
}

pages = {
    { BASE, },
    { INDICATION, },
}

init_pageID = 1

update_screenspace_diplacement(SelfWidth/SelfHeight,true)

dedicated_viewport_arcade = dedicated_viewport