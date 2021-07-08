dofile(LockOn_Options.common_script_path.."elements_defs.lua")

IND_TEX_PATH = LockOn_Options.script_path.."../IndicationTextures/HMD/" -- Texture Directory

SetScale(FOV)

ASPECT_HEIGHT = GetAspect()

DEFAULT_LEVEL = 4
DEFAULT_NOCLIP_LEVEL = DEFAULT_LEVEL - 1

BG_MAT = MakeMaterial(nil, {0,255,0,255})
--TEST_TEX = MakeMaterial(IND_TEX_PATH.."TEST.png", {255,255,255,255})

local FONT = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})

default_x = 512
default_y = 512

function vert_gen(width, height)
    return {{(0 - width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 + height) / 2 / default_y},
    {(0 + width) / 2 / default_x , (0 - height) / 2 / default_y},
    {(0 - width) / 2 / default_x , (0 - height) / 2 / default_y},}
end

function duo_vert_gen(width, total_height, not_include_height)
    return {
        {(0 - width) / 2 / default_x , (0 + total_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 + total_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 + not_include_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 + not_include_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 - not_include_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 - not_include_height) / 2 / default_y},
        {(0 + width) / 2 / default_x , (0 - total_height) / 2 / default_y},
        {(0 - width) / 2 / default_x , (0 - total_height) / 2 / default_y},
    }
end

function tex_coord_gen(x_dis,y_dis,width,height,size_X,size_Y)
    return {{x_dis / size_X , y_dis / size_Y},
			{(x_dis + width) / size_X , y_dis / size_Y},
			{(x_dis + width) / size_X , (y_dis + height) / size_Y},
			{x_dis / size_X , (y_dis + height) / size_Y},}
end

function mirror_tex_coord_gen(x_dis,y_dis,width,height,size_X,size_Y)
    return {{(x_dis + width) / size_X , y_dis / size_Y},
			{x_dis / size_X , y_dis / size_Y},
			{x_dis / size_X , (y_dis + height) / size_Y},
			{(x_dis + width) / size_X , (y_dis + height) / size_Y},}
end

SHOW_MASKS = false

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

local INDICES = {0,1,2,0,2,3}

-- Box made of stroke lines

-- made by four lines
local BOX_INDICES = {0, 1, 1, 2, 2, 3, 3, 0}

function box_verts(sideX, sideY)
	local halfSideX	= sideX / 2
	local halfSideY	= sideY / 2
	return {{-halfSideX, -halfSideY}, {-halfSideX, halfSideY}, {halfSideX, halfSideY}, {halfSideX, -halfSideY}}
end

-- BASE CLIP (DO NOT DELETE / CHANGE)
--[[ base_clip                           = CreateElement "ceMeshPoly"
base_clip.name                      = "base_clip"
base_clip.primitivetype             = "triangles"
base_clip.vertices                  = vert_gen(15000,10000)
base_clip.indices                   = INDICES
base_clip.init_pos                  = {0,0,0}
base_clip.init_rot                  = {0,0,0}
base_clip.material                  = BG_MAT
base_clip.element_params            = {"HMD_DIS_ENABLE"}
base_clip.controllers               = {{"opacity_using_parameter",1}}
base_clip.h_clip_relation           = h_clip_relations.REWRITE_LEVEL
base_clip.level                     = DEFAULT_NOCLIP_LEVEL
base_clip.isdraw                    = true
base_clip.change_opacity            = true
base_clip.isvisible                 = SHOW_MASKS
Add(base_clip) ]]

base_clip                           = CreateElement "ceMeshPoly"
base_clip.name                      = "base_clip"
base_clip.primitivetype             = "triangles"
base_clip.material                  = MakeMaterial(nil,{0,0,0,75})
base_clip.vertices                  = vert_gen(1920,1080)
base_clip.indices                   = INDICES
base_clip.init_pos                  = {0,0,0}
base_clip.screenspace               = ScreenType.SCREENSPACE_TRUE
base_clip.element_params            = {""}
base_clip.controllers               = {{"opacity_using_parameter",1}}
base_clip.isvisible                 = SHOW_MASKS
Add(base_clip)

filter                  = CreateElement "ceTexPoly"
filter.name             = create_guid_string()
filter.material         = MakeMaterial(IND_TEX_PATH.."HMD_FILTER.tga",{255,255,255,255})
filter.vertices         = vert_gen(1920,1080)
filter.indices          = INDICES
filter.tex_coords       = tex_coord_gen(0,0,1920,1080,1920,1080)
filter.init_pos         = {0,0,0}
filter.screenspace      = ScreenType.SCREENSPACE_TRUE
filter.element_params   = {"FILTER_OPACITY"}
filter.controllers      = {{"opacity_using_parameter",0}}
filter.isvisible        = true
Add(filter)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,0,255})
base.init_pos			= {0,-0.8,0}
base.stringdefs			= {0.003,0.002,  0, 0}
base.formats 			= {"%s\n","%s\n","%s\n","%s\n"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID","ID_U_USER","ID_U_BUILD","ID_U_VER"}
base.controllers 		= {{"text_using_parameter",0},{"text_using_parameter",1},{"text_using_parameter",2},{"text_using_parameter",3}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {-1.2,0,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {0,0,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {1.2,0,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {-1.2,0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {0,0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {1.2,0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {-1.2,-0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {0,-0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{255,0,255,25})
base.init_pos			= {1.2,-0.6,0}
base.stringdefs			= {0.009,0.008,  0, 0}
base.formats 			= {"%s"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {"ID_U_UID"}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

base					= CreateElement "ceStringPoly"
base.name				= create_guid_string()
base.alignment 			= "CenterCenter"
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
base.init_pos			= {0,0.9,0}
base.stringdefs			= {0.003,0.002,  0, 0}
base.formats 			= {"[DEVELOPER BUILD]"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {""}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

ctr                           = CreateElement "ceMeshPoly"
ctr.name                      = create_guid_string()
ctr.primitivetype             = "triangles"
ctr.material                  = MakeMaterial(nil,{0,255,0,255})
ctr.vertices                  = vert_gen(12,3)
ctr.indices                   = INDICES
ctr.init_pos                  = {0,0.195,0}
ctr.init_rot                  = {90,0,0}
ctr.screenspace               = ScreenType.SCREENSPACE_TRUE
ctr.element_params            = {"HMD_PWR"}
ctr.controllers               = {{"opacity_using_parameter",0}}
ctr.isvisible                 = true
Add(ctr)

ctr                           = CreateElement "ceMeshPoly"
ctr.name                      = create_guid_string()
ctr.primitivetype             = "triangles"
ctr.material                  = MakeMaterial(nil,{0,255,0,255})
ctr.vertices                  = vert_gen(12,3)
ctr.indices                   = INDICES
ctr.init_pos                  = {0.025,0.17,0}
ctr.init_rot                  = {0,0,0}
ctr.screenspace               = ScreenType.SCREENSPACE_TRUE
ctr.element_params            = {"HMD_PWR"}
ctr.controllers               = {{"opacity_using_parameter",0}}
ctr.isvisible                 = true
Add(ctr)

ctr                           = CreateElement "ceMeshPoly"
ctr.name                      = create_guid_string()
ctr.primitivetype             = "triangles"
ctr.material                  = MakeMaterial(nil,{0,255,0,255})
ctr.vertices                  = vert_gen(12,3)
ctr.indices                   = INDICES
ctr.init_pos                  = {-0.025,0.17,0}
ctr.init_rot                  = {0,0,0}
ctr.screenspace               = ScreenType.SCREENSPACE_TRUE
ctr.element_params            = {"HMD_PWR"}
ctr.controllers               = {{"opacity_using_parameter",0}}
ctr.isvisible                 = true
Add(ctr)

altitude                            = CreateElement "ceStringPoly"
altitude.name                       = create_guid_string()
altitude.alignment                  = "RightCenter"
altitude.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
altitude.init_pos                   = {0.5,0.2,0}
altitude.stringdefs                 = {0.004,0.003,0,0}
altitude.formats                    = {"%.0f"}
altitude.screenspace                = ScreenType.SCREENSPACE_TRUE
altitude.element_params             = {"ALT","HMD_PWR"}
altitude.controllers                = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
altitude.use_mipfilter              = true
altitude.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
Add(altitude)

local box                    = CreateElement "ceSMultiLine"
box.name                     = create_guid_string()
box.isdraw                   = true
box.material                 = BG_MAT
box.use_mipfilter            = true
box.controllers              = {
    {"opacity_using_parameter",0},
}
box.element_params           = {"HMD_PWR"}
box.init_pos                 = {0.51,0.2,0}
box.init_rot                 = {0,0,0}
box.alignment                = "RightCenter"
box.thickness                = 10.0
box.fuzziness                = 1.0
box.vertices                 = box_verts(0.20,0.06)
box.indices                  = BOX_INDICES
box.screenspace              = ScreenType.SCREENSPACE_TRUE
Add(box)

radalt                              = CreateElement "ceStringPoly"
radalt.name                         = create_guid_string()
radalt.alignment                    = "RightCenter"
radalt.material                     = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
radalt.init_pos                     = {0.35,0.14,0}
radalt.stringdefs                   = {0.003,0.002,0,0}
radalt.formats                      = {"R"}
radalt.screenspace                  = ScreenType.SCREENSPACE_TRUE
radalt.element_params               = {"","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
radalt.use_mipfilter                = true
radalt.h_clip_relation              = h_clip_relations.REWRITE_LEVEL
Add(radalt)

radalt                              = CreateElement "ceStringPoly"
radalt.name                         = create_guid_string()
radalt.alignment                    = "RightCenter"
radalt.material                     = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
radalt.init_pos                     = {0.5,0.14,0}
radalt.stringdefs                   = {0.003,0.002,0,0}
radalt.formats                      = {"%.0f"}
radalt.screenspace                  = ScreenType.SCREENSPACE_TRUE
radalt.element_params               = {"RALT","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
radalt.use_mipfilter                = true
radalt.h_clip_relation              = h_clip_relations.REWRITE_LEVEL
Add(radalt)

speed                            = CreateElement "ceStringPoly"
speed.name                       = create_guid_string()
speed.alignment                  = "RightCenter"
speed.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
speed.init_pos                   = {-0.5,0.2,0}
speed.stringdefs                 = {0.004,0.003,0,0}
speed.formats                    = {"%.0f"}
speed.screenspace                = ScreenType.SCREENSPACE_TRUE
speed.element_params             = {"SPEED","HMD_PWR"}
speed.controllers                = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
speed.use_mipfilter              = true
speed.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
Add(speed)

local box                    = CreateElement "ceSMultiLine"
box.name                     = create_guid_string()
box.isdraw                   = true
box.material                 = BG_MAT
box.use_mipfilter            = true
box.controllers              = {
    {"opacity_using_parameter",0},
}
box.element_params           = {"HMD_PWR"}
box.init_pos                 = {-0.49,0.2,0}
box.init_rot                 = {0,0,0}
box.alignment                = "RightCenter"
box.thickness                = 10.0
box.fuzziness                = 1.0
box.vertices                 = box_verts(0.15,0.06)
box.indices                  = BOX_INDICES
box.screenspace              = ScreenType.SCREENSPACE_TRUE
Add(box)

GMDis                            = CreateElement "ceStringPoly"
GMDis.name                       = create_guid_string()
GMDis.alignment                  = "LeftCenter"
GMDis.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
GMDis.init_pos                   = {-0.55,0.1,0}
GMDis.stringdefs                 = {0.003,0.002,0,0}
GMDis.formats                    = {"a\nM\nG"}
GMDis.screenspace                = ScreenType.SCREENSPACE_TRUE
GMDis.element_params             = {"","HMD_PWR"}
GMDis.controllers                = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
GMDis.use_mipfilter              = true
GMDis.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
Add(GMDis)

GMDis                            = CreateElement "ceStringPoly"
GMDis.name                       = create_guid_string()
GMDis.alignment                  = "LeftCenter"
GMDis.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
GMDis.init_pos                   = {-0.5,0.08,0}
GMDis.stringdefs                 = {0.003,0.002,0,0}
GMDis.formats                    = {"%.1f\n","%.1f\n","%.1f"}
GMDis.screenspace                = ScreenType.SCREENSPACE_TRUE
GMDis.element_params             = {"AOA","MACH","ACCEL","HMD_PWR"}
GMDis.controllers                = {{"text_using_parameter",0},{"text_using_parameter",1},{"text_using_parameter",2},{"opacity_using_parameter",3}}
GMDis.use_mipfilter              = true
GMDis.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
Add(GMDis)

ALTWARNING                      = CreateElement "ceStringPoly"
ALTWARNING.name                 = create_guid_string()
ALTWARNING.alignment            = "CenterCenter"
ALTWARNING.material             = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
ALTWARNING.init_pos             = {0,0,0}
ALTWARNING.stringdefs           = {0.006,0.006,0,0}
ALTWARNING.formats              = {"ALTITUDE"}
ALTWARNING.screenspace          = ScreenType.SCREENSPACE_TRUE
ALTWARNING.element_params       = {"","WARNALT"}
ALTWARNING.controllers          = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
ALTWARNING.use_mipfilter        = true
ALTWARNING.h_clip_relation      = h_clip_relations.REWRITE_LEVEL
Add(ALTWARNING)

OVERGWARNING                      = CreateElement "ceStringPoly"
OVERGWARNING.name                 = create_guid_string()
OVERGWARNING.alignment            = "CenterCenter"
OVERGWARNING.material             = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{0,255,0,255})
OVERGWARNING.init_pos             = {0,0,0}
OVERGWARNING.stringdefs           = {0.006,0.006,0,0}
OVERGWARNING.formats              = {"OVER G"}
OVERGWARNING.screenspace          = ScreenType.SCREENSPACE_TRUE
OVERGWARNING.element_params       = {"","WARNOVERG"}
OVERGWARNING.controllers          = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
OVERGWARNING.use_mipfilter        = true
OVERGWARNING.h_clip_relation      = h_clip_relations.REWRITE_LEVEL
Add(OVERGWARNING)

HDG                            = CreateElement "ceStringPoly"
HDG.name                       = create_guid_string()
HDG.alignment                  = "CenterCenter"
HDG.material                   = FONT
HDG.init_pos                   = {0,0.17,0}
HDG.stringdefs                 = {0.003,0.002,0,0}
HDG.formats                    = {"%.0f\n"}
HDG.screenspace                = ScreenType.SCREENSPACE_TRUE
HDG.element_params             = {"HDG_X","HDG_Y","ROLL","HMD_PWR","HDG"}
HDG.controllers                = {
    {"move_left_right_using_parameter",0,1},
    {"move_up_down_using_parameter",1,1},
    {"rotate_using_parameter",2,1},
    {"opacity_using_parameter",3},
    {"text_using_parameter",4}
}
HDG.use_mipfilter              = true
HDG.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
Add(HDG)

local box                    = CreateElement "ceSMultiLine"
box.name                     = create_guid_string()
box.isdraw                   = true
box.material                 = BG_MAT
box.use_mipfilter            = true
box.controllers              = {
    {"move_left_right_using_parameter",0,1},
    {"move_up_down_using_parameter",1,1},
    {"rotate_using_parameter",2,1},
    {"opacity_using_parameter",3},
}
box.element_params           = {"HDG_X","HDG_Y","ROLL","HMD_PWR"}
box.init_pos                 = {0,0.17,0}
box.init_rot                 = {0,0,0}
box.alignment                = "CenterBottom"
box.thickness                = 10.0
box.fuzziness                = 1.0
box.vertices                 = box_verts(0.1,0.03)
box.indices                  = BOX_INDICES
box.screenspace              = ScreenType.SCREENSPACE_TRUE
Add(box)

-- Build heading lines
for i=0,350,10 do
    local line                    = CreateElement "ceMeshPoly"
    line.name                     = create_guid_string()
    line.primitivetype            = "triangles"
    line.material                 = BG_MAT
    line.vertices                 = vert_gen(1, 512 * 0.02)
    line.indices                  = INDICES
    line.init_pos                 = {0,0.17,0}
    line.init_rot                 = {0,0,0}
    line.screenspace              = ScreenType.SCREENSPACE_TRUE
    line.element_params             = {"HL_X_"..i,"HL_Y_"..i,"HL_R_"..i,"HL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"move_up_down_using_parameter",1,1},
        {"rotate_using_parameter",2,1},
        {"opacity_using_parameter",3}
    }
    line.isvisible                = true
    Add(line)

    local text                      = CreateElement "ceStringPoly"
    text.name                       = create_guid_string()
    text.alignment                  = "CenterCenter"
    text.material                   = FONT
    text.init_pos                   = {0,0.17,0}
    text.stringdefs                 = {0.003,0.002,0,0}
    text.formats                    = {tostring(i/10)}
    text.screenspace                = ScreenType.SCREENSPACE_TRUE
    text.element_params             = {
        "HL_TX_"..i,
        "HL_TY_"..i,
        "HL_R_"..i,
        "HL_TO_"..i,
        ""
    }
    text.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"move_up_down_using_parameter",1,1},
        {"rotate_using_parameter",2,1},
        {"opacity_using_parameter",3},
        {"text_using_parameter",4}
    }
    text.use_mipfilter              = true
    text.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
    Add(text)
end

-- Build pitch lines
for i=-90,90,5 do
    local line                    = CreateElement "ceMeshPoly"
    line.name                     = create_guid_string()
    line.primitivetype            = "triangles"
    line.material                 = BG_MAT
    line.vertices                 = vert_gen(512 * 0.35,1)
    line.indices                  = INDICES
    line.init_pos                 = {0,0.17,0}
    line.init_rot                 = {0,0,0}
    line.screenspace              = ScreenType.SCREENSPACE_TRUE
    line.element_params             = {"PL_X_"..i,"PL_Y_"..i,"PL_R_"..i,"PL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"move_up_down_using_parameter",1,1},
        {"rotate_using_parameter",2,1},
        {"opacity_using_parameter",3}
    }
    line.isvisible                = true
    Add(line)

    text_datas = {
        {name = "L", alignment = "RightCenter"},
        {name = "R", alignment = "LeftCenter"}
    }
    for text_i,text_data in ipairs(text_datas) do
        local text                      = CreateElement "ceStringPoly"
        text.name                       = create_guid_string()
        text.alignment                  = text_data.alignment
        text.material                   = FONT
        text.init_pos                   = {text_data.x,0.17,0}
        text.stringdefs                 = {0.003,0.002,0,0}
        text.formats                    = {tostring(i)}
        text.screenspace                = ScreenType.SCREENSPACE_TRUE
        text.element_params             = {
            "PL_"..text_data.name.."X_"..i,
            "PL_"..text_data.name.."Y_"..i,
            "PL_R_"..i,
            "PL_O_"..i,
            ""
        }
        text.controllers                = {
            {"move_left_right_using_parameter",0,1},
            {"move_up_down_using_parameter",1,1},
            {"rotate_using_parameter",2,1},
            {"opacity_using_parameter",3},
            {"text_using_parameter",4}
        }
        text.use_mipfilter              = true
        text.h_clip_relation            = h_clip_relations.REWRITE_LEVEL
        Add(text)
    end
end
