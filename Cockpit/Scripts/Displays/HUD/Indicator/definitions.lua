dofile(LockOn_Options.common_script_path.."elements_defs.lua")

--local DEFAULT_COLOR = {44,255,163,255}
DEFAULT_COLOR = {0,255,0,255}
DEFAULT_MAT = MakeMaterial(nil, DEFAULT_COLOR)
DEFAULT_FONT = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"}, DEFAULT_COLOR)

TEXT_SIZE = {
    NORMAL = {0.015,0.01,0,0}
}

-- Set common HUD element properties
function setupHudElem(elem, x, y)
    elem.name                    = create_guid_string()
    elem.init_pos                = {x, y, 0}
    elem.h_clip_relation         = h_clip_relations.COMPARE
    elem.level                   = DEFAULT_NOCLIP_LEVEL
    elem.parent_element          = "hud_base_clip"
    elem.use_mipfilter           = true
    return elem
end

-- Create HUD box element (not filled)
function hudBox(x, y, w, h)
	local half_w = w / 2
	local half_h = h / 2
    local elem               = CreateElement "ceSMultiLine"
    elem.material            = DEFAULT_MAT
    elem.isdraw              = true
    elem.indices             = {0, 1, 1, 2, 2, 3, 3, 0}
    elem.vertices            = {
        {-half_w, -half_h}, {-half_w, half_h},
        {half_w, half_h}, {half_w, -half_h}
    }
    return setupHudElem(elem, x, y)
end

-- Create HUD rectangle element (filled)
function hudRect(x, y, w, h)
	local half_w = w / 2
	local half_h = h / 2
    local elem                   = CreateElement "ceMeshPoly"
    elem.material                = DEFAULT_MAT
    elem.isvisible               = true
    elem.primitivetype           = "triangles"
    elem.indices                 = {0, 1, 2, 0, 2, 3}
    elem.vertices                = {
        {-half_w, half_h}, {half_w , half_h},
        {half_w , -half_h}, {-half_w , -half_h}
    }
    return setupHudElem(elem, x, y)
end

-- Create HUD string element
function hudString(x, y)
    local elem                       = CreateElement "ceStringPoly"
    elem.material                    = DEFAULT_FONT
    return setupHudElem(elem, x, y)
end
