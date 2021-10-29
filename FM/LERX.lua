positions = {
    [1] = {x = 3.045, y = -0.5, z = -1.664},
    [2] = {x = -0.167, y = -0.47, z = -2.238},
}

splines_both = {

    --left
    {
        {
            pos = {3.045, -0.5, -1.664},
            vel = {0.0, 0.1, -0.3},
            radius = 0.1,
            opacity = 1.0,
        },
        {
            pos = {-2.954, 0.168, -1.988},
            vel = {0.5, 0.0, -0.3},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {-0.167, -0.47, -2.238},
            vel = {0.0, 0.3, -0.3},
            radius = 0.1,
            opacity = 1.0,
        },
        {
            pos = {-2.672, -0.025, -2.306},
            vel = {1.0, 0.0, -1.0},
            radius = 0.5,
            opacity = 1.0,
        },
    
    },

}

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

splines = {}

for i,v in pairs(splines_both) do
    table.insert(splines, v)
end

for i,v in pairs(splines_both) do

    new_spline = {}

    for j, point in pairs(v) do
        spline = deepcopy(point)

        spline.pos[3] = -spline.pos[3]
        spline.vel[3] = -spline.vel[3]

        table.insert(new_spline, spline)
    end

    table.insert(splines, new_spline)
end
