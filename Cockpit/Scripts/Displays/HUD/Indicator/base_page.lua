dofile(LockOn_Options.common_script_path.."elements_defs.lua")

IND_TEX_PATH = LockOn_Options.script_path.."../IndicationTextures/HUD/" -- Texture Directory

SetScale(FOV)

ASPECT_HEIGHT = GetAspect()

DEFAULT_LEVEL = 4
DEFAULT_NOCLIP_LEVEL = DEFAULT_LEVEL - 1

BG_MAT = MakeMaterial(nil, {44,255,163,255})
--TEST_TEX = MakeMaterial(IND_TEX_PATH.."TEST.png", {255,255,255,255})

FONT = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"},{44,255,163,255})

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

BOX_INDICES = {0, 1, 1, 2, 2, 3, 3, 0}

function box_verts(sideX, sideY)
	local halfSideX	= sideX / 2
	local halfSideY	= sideY / 2
	return {{-halfSideX, -halfSideY}, {-halfSideX, halfSideY}, {halfSideX, halfSideY}, {halfSideX, -halfSideY}}
end

SHOW_MASKS = false

local half_width = GetScale()
local half_height = GetAspect() * half_width

local aspect = GetAspect()

local INDICES = {0,1,2,0,2,3}

-- BASE CLIP (DO NOT DELETE / CHANGE)
base_clip                           = CreateElement "ceMeshPoly"
base_clip.name                      = "hud_base_clip"
base_clip.primitivetype             = "triangles"
base_clip.vertices                  = vert_gen(2500,2500)
base_clip.indices                   = INDICES
base_clip.init_pos                  = {0,0,0}
base_clip.init_rot                  = {0,0,0}
base_clip.material                  = BG_MAT
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
