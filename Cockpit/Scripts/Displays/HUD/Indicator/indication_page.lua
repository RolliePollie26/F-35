-- dofile(LockOn_Options.script_path.."Displays/HUD/Indicator/base_page.lua")
dofile(LockOn_Options.common_script_path.."elements_defs.lua")

local alt                       = CreateElement "ceStringPoly"
alt.name                        = create_guid_string()
alt.alignment                   = "RightCenter"
alt.material                    = FONT
alt.init_pos                    = {5,0.2,14}
alt.stringdefs                  = {
                                0.048,
                                0.038,
                                0,
                                0}
alt.formats                     = {"%.0f"}
alt.element_params              = 
                                {
                                    "ALT",
                                    "BATT"
                                }
alt.controllers                 = 
                                {
                                    {"text_using_parameter",0},
                                    {"opacity_using_parameter",1}
                                }
alt.use_mipfilter               = true
alt.h_clip_relation             = h_clip_relations.COMPARE
alt.level                       = DEFAULT_NOCLIP_LEVEL
alt.parent_element              = "hud_base_clip"
Add(alt)

local box                       = CreateElement "ceSMultiLine"
box.name                        = create_guid_string()
box.isdraw                      = true
box.material                    = BG_MAT
box.use_mipfilter               = true
box.controllers                 = 
                                {
                                    {"opacity_using_parameter",0},
                                }
box.element_params              = 
                                {
                                    "BATT"
                                }
box.init_pos                    = {5,0.2,14}
box.init_rot                    = {0,0,0}
box.alignment                   = "RightCenter"
box.thickness                   = 10.0
box.fuzziness                   = 1.0
box.vertices                    = box_verts(2,0.6)
box.indices                     = BOX_INDICES
box.h_clip_relation             = h_clip_relations.COMPARE
box.level                       = DEFAULT_NOCLIP_LEVEL
box.parent_element              = "hud_base_clip"
Add(box)