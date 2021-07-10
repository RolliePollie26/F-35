dofile(LockOn_Options.common_script_path.."elements_defs.lua")

DEFAULT_COLOR = {44,255,163,255}
DEFAULT_MAT = MakeMaterial(nil, DEFAULT_COLOR)
DEFAULT_FONT = MakeFont({used_DXUnicodeFontData = "font_cockpit_usa"}, DEFAULT_COLOR)

-- Convert degrees to milliradians HUD scale
HUD_DEGREE = 2000.0 * math.pi / 360.0
-- Use this to scale degree parameters
-- TODO: Figure out why this is not 1.0 / HUD_DEGREE
HUD_PARAM_SCALE = 0.31/HUD_DEGREE

function create_text_size(scale)
    return {scale, scale * 2/3, 0, 0}
end

TEXT_SIZE = {
    NORMAL = create_text_size(0.015),
    LARGE = create_text_size(0.02),
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
    elem.indices             = {
        0, 1,
        1, 2,
        2, 3,
        3, 0
    }
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
    elem.indices                 = {
        0, 1, 2,
        0, 2, 3
    }
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

-- Create a HUD aircraft element
function hudAircraft(x, y, w, h)
    local elem               = CreateElement "ceSMultiLine"
    elem.material            = DEFAULT_MAT
    elem.isdraw              = true
    elem.indices             = {
        0, 1,
        1, 2,
        2, 3,
        3, 4,
        4, 5,
        5, 6,
    }
    elem.vertices            = {
        {-w/2, 0},
        {-w/4, 0},
        {-w/8, -h/2},
        {0, 0},
        {w/8, -h/2},
        {w/4, 0},
        {w/2, 0},
    }
    return setupHudElem(elem, x, y)
end

-- Create a HUD arc element
function hudArc(x, y, r, theta_start, theta_end)
    local elem               = CreateElement "ceSMultiLine"
    elem.material            = DEFAULT_MAT
    elem.isdraw              = true
    local indices             = {}
    local vertices            = {}
    local i = 0
    for i=0,theta_end-theta_start,1 do
        if i > 0 then
            table.insert(indices, i - 1)
            table.insert(indices, i)
        end
        theta=theta_start+i
        table.insert(vertices, {
            r * math.cos(math.rad(theta)),
            r * math.sin(math.rad(theta)),
        })
    end
    print_message_to_user("I: "..tostring(table.getn(indices)))
    print_message_to_user("V: "..tostring(table.getn(vertices)))
    elem.indices = indices
    elem.vertices = vertices
    return setupHudElem(elem, x, y)
end

-- Create a HUD pitch line for horizon
function hudPitchLineHorizon(x, y, w, h, gap)
	local half_w = w / 2
	local half_h = h / 2
    local elem                   = CreateElement "ceMeshPoly"
    elem.material                = DEFAULT_MAT
    elem.isvisible               = true
    elem.primitivetype           = "triangles"
    elem.indices                 = {
        -- Left Line
        0, 1, 2,
        0, 2, 3,
        -- Right Line
        4, 5, 6,
        4, 6, 7,
    }
    elem.vertices                = {
        -- Left Line
        {-half_w, half_h}, {-gap , half_h},
        {-gap , -half_h}, {-half_w , -half_h},
        -- Right Line
        {half_w, half_h}, {gap , half_h},
        {gap , -half_h}, {half_w , -half_h},
    }
    return setupHudElem(elem, x, y)
end

-- Create a HUD pitch line for ascending pitch
function hudPitchLineAscend(x, y, w, h, gap, tick)
	local half_w = w / 2
	local half_h = h / 2
    local elem                   = CreateElement "ceMeshPoly"
    elem.material                = DEFAULT_MAT
    elem.isvisible               = true
    elem.primitivetype           = "triangles"
    elem.indices                 = {
        -- Left Line
        0, 1, 2,
        0, 2, 3,
        -- Right Line
        4, 5, 6,
        4, 6, 7,
        -- Left Tick
        8, 9, 10,
        8, 10, 11,
        -- Right Tick
        12, 13, 14,
        12, 14, 15
    }
    elem.vertices                = {
        -- Left Line
        {-half_w, half_h}, {-gap , half_h},
        {-gap , -half_h}, {-half_w , -half_h},
        -- Right Line
        {half_w, half_h}, {gap , half_h},
        {gap , -half_h}, {half_w , -half_h},
        -- Left Tick
        {-half_w, -half_h}, {-half_w+h, -half_h},
        {-half_w+h, -half_h-tick}, {-half_w, -half_h-tick},
        -- Right Tick
        {half_w-h, -half_h}, {half_w, -half_h},
        {half_w, -half_h-tick}, {half_w-h, -half_h-tick},
    }
    return setupHudElem(elem, x, y)
end

-- Create a HUD pitch line for descending pitch
function hudPitchLineDescend(x, y, w, h, gap, tick)
	local half_w = w / 2
	local half_h = h / 2
    local elem                   = CreateElement "ceMeshPoly"
    elem.material                = DEFAULT_MAT
    elem.isvisible               = true
    elem.primitivetype           = "triangles"
    elem.indices                 = {
        -- Left Line
        0, 1, 2,
        0, 2, 3,
        -- Right Line
        4, 5, 6,
        4, 6, 7,
        -- Left Tick
        8, 9, 10,
        8, 10, 11,
        -- Right Tick
        12, 13, 14,
        12, 14, 15
    }
    elem.vertices                = {
        -- Left Line
        {-half_w, half_h}, {-gap , half_h},
        {-gap , -half_h}, {-half_w , -half_h},
        -- Right Line
        {half_w, half_h}, {gap , half_h},
        {gap , -half_h}, {half_w , -half_h},
        -- Left Tick
        {-gap-h, half_h+tick}, {-gap, half_h+tick},
        {-gap, half_h}, {-gap-h, half_h},
        -- Right Tick
        {gap, half_h+tick}, {gap+h, half_h+tick},
        {gap+h, half_h}, {gap, half_h},
    }
    return setupHudElem(elem, x, y)
end
