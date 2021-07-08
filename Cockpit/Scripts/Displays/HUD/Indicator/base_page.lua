dofile(LockOn_Options.script_path.."Displays/HUD/Indicator/definitions.lua")

SetScale(FOV)

DEFAULT_LEVEL = 4
DEFAULT_NOCLIP_LEVEL = DEFAULT_LEVEL - 1

SHOW_MASKS = false

VERT_GEN_INDICES = {0,1,2,0,2,3}
function vert_gen(width, height)
    local default_x = 512
    local default_y = 512
    return {{(0 - width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 - height) / 2 / default_y},
    {(0 - width) / 2 / default_x , (0 - height) / 2 / default_y},}
end

-- BASE CLIP (DO NOT DELETE / CHANGE)
base_clip                           = CreateElement "ceMeshPoly"
base_clip.name                      = "hud_base_clip"
base_clip.primitivetype             = "triangles"
base_clip.vertices                  = vert_gen(2500,2500)
base_clip.indices                   = VERT_GEN_INDICES
base_clip.init_pos                  = {0,0,0}
base_clip.init_rot                  = {0,0,0}
base_clip.material                  = DEFAULT_MAT
base_clip.element_params            =
                                    {
                                    "BATT"
                                    }
base_clip.controllers               =
                                    {
                                    {"opacity_using_parameter",0}
                                    }
base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
base_clip.level                     = DEFAULT_NOCLIP_LEVEL
base_clip.isdraw                    = true
base_clip.change_opacity            = true
base_clip.isvisible                 = SHOW_MASKS
Add(base_clip)

dofile(LockOn_Options.script_path.."Displays/HUD/Indicator/indication_page.lua")
