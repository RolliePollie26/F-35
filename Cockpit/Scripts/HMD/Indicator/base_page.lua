dofile(LockOn_Options.common_script_path.."elements_defs.lua")

IND_TEX_PATH = LockOn_Options.script_path.."../IndicationTextures/HMD/" -- Texture Directory

SetScale(FOV)

ASPECT_HEIGHT = GetAspect()

DEFAULT_LEVEL = 4
DEFAULT_NOCLIP_LEVEL = DEFAULT_LEVEL - 1

local BG_MAT = MakeMaterial(nil, {44,255,163,255})
--TEST_TEX = MakeMaterial(IND_TEX_PATH.."TEST.png", {255,255,255,255})

local FONT = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})

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
base.material			= MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
base.init_pos			= {0,0.9,0}
base.stringdefs			= {0.003,0.002,  0, 0}
base.formats 			= {"[DEVELOPER BUILD]"}
base.screenspace 		= ScreenType.SCREENSPACE_TRUE
base.element_params 	= {""}
base.controllers 		= {{"text_using_parameter",0}}
base.use_mipfilter		= true
base.h_clip_relation	= h_clip_relations.REWRITE_LEVEL
Add(base)

radalt                              = CreateElement "ceStringPoly"
radalt.name                         = create_guid_string()
radalt.alignment                    = "RightCenter"
radalt.material                     = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
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
radalt.material                     = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
radalt.init_pos                     = {0.5,0.14,0}
radalt.stringdefs                   = {0.003,0.002,0,0}
radalt.formats                      = {"%.0f"}
radalt.screenspace                  = ScreenType.SCREENSPACE_TRUE
radalt.element_params               = {"RALT","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
radalt.use_mipfilter                = true
radalt.h_clip_relation              = h_clip_relations.REWRITE_LEVEL
Add(radalt)

GMDis                            = CreateElement "ceStringPoly"
GMDis.name                       = create_guid_string()
GMDis.alignment                  = "LeftCenter"
GMDis.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
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
GMDis.material                   = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
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
ALTWARNING.material             = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
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
OVERGWARNING.material             = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})
OVERGWARNING.init_pos             = {0,0,0}
OVERGWARNING.stringdefs           = {0.006,0.006,0,0}
OVERGWARNING.formats              = {"OVER G"}
OVERGWARNING.screenspace          = ScreenType.SCREENSPACE_TRUE
OVERGWARNING.element_params       = {"","WARNOVERG"}
OVERGWARNING.controllers          = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
OVERGWARNING.use_mipfilter        = true
OVERGWARNING.h_clip_relation      = h_clip_relations.REWRITE_LEVEL
Add(OVERGWARNING)
