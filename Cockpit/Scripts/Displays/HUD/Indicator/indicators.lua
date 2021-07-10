-- Airspeed
local spd                       = hudString(-8 * HUD_DEGREE, -2 * HUD_DEGREE)
spd.alignment                   = "RightTop"
spd.stringdefs                  = TEXT_SIZE.LARGE
spd.formats                     = {"%.0f"}
spd.element_params              = {"SPEED","BATT"}
spd.controllers                 = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(spd)

local box                       = hudBox(-8 * HUD_DEGREE + 4, -2 * HUD_DEGREE, 3.4 * HUD_DEGREE, 1.3 * HUD_DEGREE)
box.alignment                   = "RightTop"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

-- Mach number, G-force, and angle of attack
local GMDis                      = hudString(-10.5 * HUD_DEGREE, -4 * HUD_DEGREE)
GMDis.alignment                  = "RightTop"
GMDis.stringdefs                 = TEXT_SIZE.NORMAL
GMDis.formats                    = {"M\nG\na"}
GMDis.element_params             = {"","BATT"}
GMDis.controllers                = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(GMDis)

GMDis                            = hudString(-8 * HUD_DEGREE, -4 * HUD_DEGREE)
GMDis.alignment                  = "RightTop"
GMDis.stringdefs                 = TEXT_SIZE.NORMAL
GMDis.formats                    = {"%.1f\n","%.1f\n","%.1f"}
GMDis.element_params             = {"MACH","ACCEL","AOA","BATT"}
GMDis.controllers                = {{"text_using_parameter",0},{"text_using_parameter",1},{"text_using_parameter",2},{"opacity_using_parameter",3}}
Add(GMDis)

-- Barometric altitude
local alt                       = hudString(10 * HUD_DEGREE, -2 * HUD_DEGREE)
alt.alignment                   = "RightTop"
alt.stringdefs                  = TEXT_SIZE.LARGE
alt.formats                     = {"%.0f"}
alt.element_params              = {"ALT","BATT"}
alt.controllers                 = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(alt)

local box                       = hudBox(10 * HUD_DEGREE + 4, -2 * HUD_DEGREE, 4.2 * HUD_DEGREE, 1.3 * HUD_DEGREE)
box.alignment                   = "RightTop"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

-- Radar altitude
radalt                              = hudString(7.5 * HUD_DEGREE, -4 * HUD_DEGREE)
radalt.alignment                    = "RightTop"
radalt.stringdefs                   = TEXT_SIZE.NORMAL
radalt.formats                      = {"R"}
radalt.element_params               = {"","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(radalt)

radalt                              = hudString(10 * HUD_DEGREE, -4 * HUD_DEGREE)
radalt.alignment                    = "RightTop"
radalt.stringdefs                   = TEXT_SIZE.NORMAL
radalt.formats                      = {"%.0f"}
radalt.element_params               = {"RALT","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(radalt)

-- Heading indicator
local hdg                      = hudString(0, 10 * HUD_DEGREE)
hdg.alignment                  = "CenterCenter"
hdg.stringdefs                 = TEXT_SIZE.NORMAL
hdg.formats                    = {"%.0f\n"}
hdg.element_params             = {"HDG","BATT"}
hdg.controllers                = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(hdg)

local box                       = hudBox(0, 10 * HUD_DEGREE - 2, 2 * HUD_DEGREE, 1 * HUD_DEGREE)
box.alignment                   = "CenterBottom"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

local line                      = hudRect(0.0, 9.35 * HUD_DEGREE, 2, HUD_DEGREE)
line.element_params             = {"BATT"}
line.controllers                = {{"opacity_using_parameter",0}}
Add(line)

-- Build heading lines
for i=0,350,10 do
    local line                      = hudRect(0.0, 9.6 * HUD_DEGREE, 2, HUD_DEGREE / 2)
    line.element_params             = {"HL_X_"..i,"HL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,HUD_PARAM_SCALE/3},
        {"opacity_using_parameter",1}
    }
    Add(line)

    local text                      = hudString(0.0, 10 * HUD_DEGREE)
    text.alignment                  = "CenterBottom"
    text.stringdefs                 = TEXT_SIZE.NORMAL
    text.formats                    = {tostring(i/10)}
    text.element_params             = {"HL_TX_"..i,"HL_TO_"..i,""}
    text.controllers                = {
        {"move_left_right_using_parameter",0,HUD_PARAM_SCALE/3},
        {"opacity_using_parameter",1},
        {"text_using_parameter",2}
    }
    Add(text)
end

-- Aircraft marker
local aircraft = hudAircraft(0, 0, 2 * HUD_DEGREE, HUD_DEGREE)
aircraft.alignment             = "CenterCenter"
aircraft.thickness             = 3.0
aircraft.fuzziness             = 1.0
aircraft.element_params        = {"BATT"}
aircraft.controllers           = {{"opacity_using_parameter",0}}
Add(aircraft)

-- Flight path marker
for i, rect in ipairs({
    {x = -HUD_DEGREE * 2/3, y = 0, w = HUD_DEGREE * 2/3, h = 2},
    {x = HUD_DEGREE * 2/3, y = 0, w = HUD_DEGREE * 2/3, h = 2},
    {x = 0.0, y = HUD_DEGREE/2, w = 2, h = HUD_DEGREE/3}
}) do
    local line                      = hudRect(rect.x, rect.y, rect.w, rect.h)
    line.element_params             = {"FPM_X","FPM_Y","BATT"}
    line.controllers                = {
        {"move_left_right_using_parameter",0,HUD_PARAM_SCALE},
        {"move_up_down_using_parameter",1,HUD_PARAM_SCALE},
        {"opacity_using_parameter",2}
    }
    Add(line)
end

local arc                      = hudArc(0, 0, HUD_DEGREE/3, -45, 225)
arc.alignment                  = "CenterCenter"
arc.thickness                  = 3.0
arc.fuzziness                  = 1.0
arc.element_params             = {"FPM_X","FPM_Y","BATT"}
arc.controllers                = {
    {"move_left_right_using_parameter",0,HUD_PARAM_SCALE},
    {"move_up_down_using_parameter",1,HUD_PARAM_SCALE},
    {"opacity_using_parameter",2}
}
Add(arc)

-- Target box
local box                      = hudBox(0.0, 0.0, HUD_DEGREE, HUD_DEGREE)
box.alignment                  = "CenterCenter"
box.thickness                  = 5.0
box.fuzziness                  = 1.0
box.element_params             = {"TGT_X","TGT_Y","TGT_O"}
box.controllers                = {
    {"move_left_right_using_parameter",0,HUD_PARAM_SCALE},
    {"move_up_down_using_parameter",1,HUD_PARAM_SCALE},
    {"opacity_using_parameter",2}
}
Add(box)

-- Build pitch lines
for i=-90,90,5 do
    local line
    if i == 0 then
        line = hudPitchLineHorizon(0.0, 0.0, 24 * HUD_DEGREE, 2, HUD_DEGREE)
    elseif i > 0 then
        line = hudPitchLineAscend(0.0, 0.0, 8 * HUD_DEGREE, 2, HUD_DEGREE, HUD_DEGREE / 3)
    else
        line = hudPitchLineDescend(0.0, 0.0, 8 * HUD_DEGREE, 2, HUD_DEGREE, HUD_DEGREE / 3)
    end
    line.element_params             = {"PL_X_"..i,"PL_Y_"..i,"PL_R_"..i,"PL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,HUD_PARAM_SCALE},
        {"move_up_down_using_parameter",1,HUD_PARAM_SCALE},
        {"rotate_using_parameter",2,1},
        {"opacity_using_parameter",3}
    }
    Add(line)

    if i ~= 0 then
        local text                      = hudString(0.0, 0.0)
        if i > 0 then
            text.alignment                  = "LeftTop"
        else
            text.alignment                  = "RightBottom"
        end
        text.stringdefs                 = TEXT_SIZE.NORMAL
        text.formats                    = {tostring(i)}
        text.element_params             = {
            "PL_TX_"..i,
            "PL_TY_"..i,
            "PL_R_"..i,
            "PL_O_"..i,
            ""
        }
        text.controllers                = {
            {"move_left_right_using_parameter",0,HUD_PARAM_SCALE},
            {"move_up_down_using_parameter",1,HUD_PARAM_SCALE},
            {"rotate_using_parameter",2,1},
            {"opacity_using_parameter",3},
            {"text_using_parameter",4}
        }
        Add(text)
    end
end

-- Test grid
TEST_GRID=false
TEST_GRID_TEXT=false
if TEST_GRID then
    for x=-12,12,1 do
        for y=-12,12,1 do
            line = hudRect(x * HUD_DEGREE, y * HUD_DEGREE, 1, 1)
            Add(line)

            if TEST_GRID_TEXT then
                local text = hudString(x * HUD_DEGREE, y * HUD_DEGREE)
                text.alignment = "CenterCenter"
                text.stringdefs = {0.0025, 0.00125, 0, 0}
                text.formats = {tostring(x)..","..tostring(y)}
                text.element_params = {""}
                text.controllers = {{"text_using_parameter",0}}
                Add(text)
            end
        end
    end
end
