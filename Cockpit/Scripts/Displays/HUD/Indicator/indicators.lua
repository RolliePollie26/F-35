-- Airspeed
local spd                       = hudString(-1.55, -0.3)
spd.alignment                   = "RightCenter"
spd.stringdefs                  = TEXT_SIZE.NORMAL
spd.formats                     = {"%.0f"}
spd.element_params              = {"SPEED","BATT"}
spd.controllers                 = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(spd)

local box                       = hudBox(-1.5, -0.3, 0.4, 0.2)
box.alignment                   = "RightCenter"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

-- Mach number, G-force, and angle of attack
GMDis                            = hudString(-2, -0.5)
GMDis.alignment                  = "RightTop"
GMDis.stringdefs                 = TEXT_SIZE.NORMAL
GMDis.formats                    = {"M\nG\na"}
GMDis.element_params             = {"","BATT"}
GMDis.controllers                = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(GMDis)

GMDis                            = hudString(-1.5, -0.5)
GMDis.alignment                  = "RightTop"
GMDis.stringdefs                 = TEXT_SIZE.NORMAL
GMDis.formats                    = {"%.1f\n","%.1f\n","%.1f"}
GMDis.element_params             = {"MACH","ACCEL","AOA","BATT"}
GMDis.controllers                = {{"text_using_parameter",0},{"text_using_parameter",1},{"text_using_parameter",2},{"opacity_using_parameter",3}}
Add(GMDis)

-- Barometric altitude
local alt                       = hudString(2, -0.3)
alt.alignment                   = "RightCenter"
alt.stringdefs                  = TEXT_SIZE.NORMAL
alt.formats                     = {"%.0f"}
alt.element_params              = {"ALT","BATT"}
alt.controllers                 = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(alt)

local box                       = hudBox(2.05, -0.3, 0.6, 0.2)
box.alignment                   = "RightCenter"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

-- Radar altitude
radalt                              = hudString(1.5, -0.5)
radalt.alignment                    = "RightTop"
radalt.stringdefs                   = TEXT_SIZE.NORMAL
radalt.formats                      = {"R"}
radalt.element_params               = {"","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(radalt)

radalt                              = hudString(2, -0.5)
radalt.alignment                    = "RightTop"
radalt.stringdefs                   = TEXT_SIZE.NORMAL
radalt.formats                      = {"%.0f"}
radalt.element_params               = {"RALT","HMD_PWR"}
radalt.controllers                  = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(radalt)

-- Heading indicator
local hdg                      = hudString(0, 1)
hdg.alignment                  = "CenterCenter"
hdg.stringdefs                 = TEXT_SIZE.NORMAL
hdg.formats                    = {"%.0f\n"}
hdg.element_params             = {"HDG","BATT"}
hdg.controllers                = {
    {"text_using_parameter",0},
    {"opacity_using_parameter",1}
}
Add(hdg)

local box                       = hudBox(0, 0.98, 0.4, 0.2)
box.alignment                   = "CenterBottom"
box.thickness                   = 5.0
box.fuzziness                   = 1.0
box.element_params              = {"BATT"}
box.controllers                 = {{"opacity_using_parameter",0}}
Add(box)

local line                      = hudRect(0.0, 0.88, 0.02, 0.2)
line.element_params             = {"BATT"}
line.controllers                = {{"opacity_using_parameter",0}}
Add(line)

-- Build heading lines
for i=0,350,10 do
    local line                      = hudRect(0.0, 0.9, 0.02, 0.1)
    line.element_params             = {"HL_X_"..i,"HL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"opacity_using_parameter",1}
    }
    Add(line)

    local text                      = hudString(0.0, 1.0)
    text.alignment                  = "CenterBottom"
    text.stringdefs                 = TEXT_SIZE.NORMAL
    text.formats                    = {tostring(i/10)}
    text.element_params             = {"HL_TX_"..i,"HL_TO_"..i,""}
    text.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"opacity_using_parameter",1},
        {"text_using_parameter",2}
    }
    Add(text)
end

-- Crosshair
for i, rect in ipairs({
    {x = 0, y = 0, w = 0.1, h = 0.02},
    {x = 0, y = 0, w = 0.02, h = 0.1},
}) do
    local line                      = hudRect(rect.x, rect.y, rect.w, rect.h)
    line.element_params             = {"BATT"}
    line.controllers                = {{"opacity_using_parameter",0}}
    Add(line)
end

-- Flight path marker
for i, rect in ipairs({
    {x = -0.1, y = 0, w = 0.1, h = 0.02},
    {x = 0.1, y = 0, w = 0.1, h = 0.02},
    {x = 0.0, y = 0.1, w = 0.02, h = 0.1}
}) do
    local line                      = hudRect(rect.x, rect.y, rect.w, rect.h)
    line.element_params             = {"FPM_X","FPM_Y","BATT"}
    line.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"move_up_down_using_parameter",1,1},
        {"opacity_using_parameter",2}
    }
    Add(line)
end

-- Build pitch lines
for i=-90,90,5 do
    local line
    if i == 0 then
        line = hudPitchLineHorizon(0.0, 0.0, 3, 0.02, 0.2)
    elseif i > 0 then
        line = hudPitchLineAscend(0.0, 0.0, 1.2, 0.02, 0.2, 0.06)
    else
        line = hudPitchLineDescend(0.0, 0.0, 1.2, 0.02, 0.2, 0.06)
    end
    line.element_params             = {"PL_X_"..i,"PL_Y_"..i,"PL_R_"..i,"PL_O_"..i}
    line.controllers                = {
        {"move_left_right_using_parameter",0,1},
        {"move_up_down_using_parameter",1,1},
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
            {"move_left_right_using_parameter",0,1},
            {"move_up_down_using_parameter",1,1},
            {"rotate_using_parameter",2,1},
            {"opacity_using_parameter",3},
            {"text_using_parameter",4}
        }
        Add(text)
    end
end
