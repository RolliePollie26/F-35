dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
--dofile(LockOn_Options.script_path.."sounds.lua")

local gettext = require("i_18n")
_ = gettext.translate

cursor_mode = 
{ 
    CUMODE_CLICKABLE = 0,
    CUMODE_CLICKABLE_AND_CAMERA  = 1,
    CUMODE_CAMERA = 2,
};

clickable_mode_initial_status  = cursor_mode.CUMODE_CLICKABLE
use_pointer_name			   = true

-- class_type = 
-- {
	-- NULL   = 0,
	-- BTN    = 1,
	-- TUMB   = 2,
	-- SNGBTN = 3,
	-- LEV    = 4,
	-- MOVABLE_LEV = 5
-- }

function default_button(hint_,device_,command_,arg_,arg_val_,arg_lim_)

	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}

	return  {	
				class 				= {class_type.BTN},
				hint  				= hint_,
				device 				= device_,
				action 				= {command_},
				stop_action 		= {command_},
				arg 				= {arg_},
				arg_value			= {arg_val_}, 
				arg_lim 			= {arg_lim_},
				use_release_message = {false},
				updatable 	= true, 
			}
end

-- default_1_position_tumb = bouton 2 positions 0 et 1 souris gauche, souris droite inop�rante
function default_1_position_tumb(hint_, device_, command_, arg_, arg_val_, arg_lim_, sound_)
	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}
	return  {	
				class 		= {class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {arg_val_}, 
				arg_lim   	= {arg_lim_},
				updatable 	= true, 
				use_OBB 	= true,
				sound = sound_ and {{sound_,sound_}} or nil
			}
end

-- default_2_position_tumb = bouton 2 positions 0 et 1 souris gauche ou souris droite indiff�remment
function default_2_position_tumb(hint_, device_, command_, arg_, sound_)
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1}, 
				arg_lim   	= {{0,1},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				sound = sound_ and {{sound_,sound_}} or nil
			}
end

-- default_3_position_tumb = bouton 3 positions -1,0,1 souris gauche ou souris droite indiff�remment
function default_3_position_tumb(hint_,device_,command_,arg_,cycled_,inversed_)
	local cycled = true
	local val =  1
	if inversed_ then
	      val = -1
	end
	if cycled_ ~= nil then
	   cycled = cycled_
	end
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {val,-val}, 
				arg_lim   	= {{-1,1},{-1,1}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle       = cycled
			}
end

-- default_axis = bouton rotatif
-- relative_ important
-- de 0 � 1
function default_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

-- default_movable_axis se d�place avec la souris gauche et renvoie la valeur atteinte
-- default_ mieux si �gal � 0
-- de 0 � 1
function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

-- default_axis_limited = bouton rotatif
-- relative_ important
-- arg_lim definissable
--[[function default_axis_limited(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_, arg_lim_)
	
	local relative = false
	local default = default_ or 0
	local updatable = updatable_ or false
	if relative_ ~= nil then
		relative = relative_
	end

	local gain = gain_ or 0.1
	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {arg_lim_},
				updatable 	= updatable, 
				use_OBB 	= false,
				gain		= {gain},
				relative    = {relative},  
			}
end]]

function default_axis_limited(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_, arg_lim_)
	
	
	local default = default_ or 0
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	--[[
	local relative = false
	if relative_ ~= nil then
		relative = relative_
	end
	]]

	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {arg_lim_},
				updatable 	= updatable, 
				use_OBB 	= true,--false,
				gain		= {gain},
				relative    = {relative},
				cycle     	= false,
			}
end
-- multiposition_switch = bouton multi-position
-- count_ = nb positions
-- delta_ = valeur entre deux positions
function multiposition_switch(hint_,device_,command_,arg_,count_,delta_,inversed_, min_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true
			}
end
-- multiposition_switch_limited = bouton multi-position non cycled
function multiposition_switch_limited(hint_,device_,command_,arg_,count_,delta_,inversed_,min_,sound_)
    local min_   = min_ or 0
	local delta_ = delta_ or 0.5
	
	local inversed = 1
	if	inversed_ then
		inversed = -1
	end
	
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_,command_},
				arg 	  	= {arg_,arg_},
				arg_value 	= {-delta_ * inversed,delta_ * inversed}, 
				arg_lim   	= {{min_, min_ + delta_ * (count_ -1)},
							   {min_, min_ + delta_ * (count_ -1)}},
				updatable 	= true, 
				use_OBB 	= true,
				cycle     	= false, 
				sound = sound_ and {{sound_,sound_}} or nil
			}
end
-- default_button_axis = bouton rotatif � deux commandes ???
function default_button_axis(hint_, device_,command_1, command_2, arg_1, arg_2, limit_1, limit_2)
	local limit_1_   = limit_1 or 1.0
	local limit_2_   = limit_2 or 1.0
return {
			class		=	{class_type.BTN, class_type.LEV},
			hint		=	hint_,
			device		=	device_,
			action		=	{command_1, command_2},
			stop_action =   {command_1, 0},
			arg			=	{arg_1, arg_2},
			arg_value	= 	{1, 0.5},
			arg_lim		= 	{{0, limit_1_}, {0,limit_2_}},
			animated        = {false,true},
			animation_speed = {0, 0.4},
			gain = {0, 0.1},
			relative	= 	{false, true},
			updatable 	= 	true, 
			use_OBB 	= 	true,
			use_release_message = {true, false}
	}
end
-- default_animated_lever = levier anim�
-- animation_speed_ 0.5 plus lent que 0.8
-- la valeur n'est retourn�e qu'apr�s l'animation
function default_animated_lever(hint_, device_, command_, arg_, animation_speed_,arg_lim_)
local arg_lim__ = arg_lim_ or {0.0,1.0}
return  {	
	class  = {class_type.TUMB, class_type.TUMB},
	hint   	= hint_, 
	device 	= device_,
	action 	= {command_, command_},
	arg 		= {arg_, arg_},
	arg_value 	= {1, 0},
	arg_lim 	= {arg_lim__, arg_lim__},
	updatable  = true, 
	gain 		= {0.1, 0.1},
	animated 	= {true, true},
	animation_speed = {animation_speed_, 0},
	cycle = true
}
end
-- default_button_tumb = bouton � deux commandes
-- bouton gauche commande 1
-- bouton droit commande 2
-- stop_action = {command1_,0}, => le bouton gauche revient au 0, alors que le bouton droit non/ the left button returns to 0, while the right button does not
-- stop_action = {command1_,command2_}, => le bouton gauche et le bouton droit reviennent au 0/ left button and right button return to 0
function default_button_tumb(hint_, device_, command1_, command2_, arg_,style)
	if style == 1 or style == nil then
		stop_action_ = {command1_,0}
	elseif style == 2 then -- speedbrake
		stop_action_ = {command1_,command2_}
	end
	return  {	
				class 		= {class_type.BTN,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command1_,command2_},
				stop_action = stop_action_,
				arg 	  	= {arg_,arg_},
				arg_value 	= {-1,1},
				arg_lim   	= {{-1,0},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				use_release_message = {true,false}
			}
end

function Switch_Up_Down_Release(hint_, command_, arg_, sound_)
    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = devices.FW135PW100,
		arg 			= {arg_, arg_},
        action          = {command_, command_}, --right click no | left yes up
        stop_action     = {nil, command_},
        arg_value       = {-1,1},
		arg_lim   		= {{-1,0},{0,1}},
        updatable       = true,
		sound = sound_ and {{sound_,sound_}} or nil
    }
end

elements = {}

elements["PNT_LDG_GEAR"] = default_2_position_tumb(_("Landing Gear UP/DOWN"), devices.LANDING_GEAR, 68, 5, TOGGLECLICK)

elements["PNT_IPP"] = Switch_Up_Down_Release(_("IPP OFF/AUTO/START"), device_commands.IPPSwitch, 15, TOGGLECLICK)
elements["PNT_ICC1"] = default_2_position_tumb(_("ICC 1 ON/OFF"), devices.FW135PW100, device_commands.ICC1, 11, TOGGLECLICK)
elements["PNT_ICC2"] = default_2_position_tumb(_("ICC 2 ON/OFF"), devices.FW135PW100, device_commands.ICC2, 10, TOGGLECLICK)
elements["PNT_ENG_IGN"] = default_2_position_tumb(_("Ignition ON/OFF"), devices.FW135PW100, device_commands.ENGIgn, 17, TOGGLECLICK)
elements["PNT_ENG_START"] = default_button(_("Engine START"), devices.FW135PW100, device_commands.ENGStart, 18, TOGGLECLICK)

elements["PNT_BATT_28V"] = default_2_position_tumb(_("BATT 28V"), devices.ELECTRIC_SYSTEM, device_commands.BATT28v, 12, TOGGLECLICK)
elements["PNT_BATT_270V"] = default_2_position_tumb(_("BATT 270V"), devices.ELECTRIC_SYSTEM, device_commands.BATT270v, 13, TOGGLECLICK)
elements["PNT_BATT"] = default_2_position_tumb(_("Battery ON/OFF"), devices.ELECTRIC_SYSTEM, device_commands.BattSwitch, 14, TOGGLECLICK)

elements["PNT_CANOPY"] = default_2_position_tumb(_("Canopy OPEN/CLOSE"), devices.CANOPY, 71, 16, TOGGLECLICK)

elements["PNT_PARK_BRAKE"] = default_2_position_tumb(_("Parking Brake ON/OFF"), devices.LANDING_GEAR, device_commands.ParkingBrake, 19, TOGGLECLICK)

elements["PNT_HMD_PWR"] = default_2_position_tumb(_("HMD Power ON/OFF"), devices.HMD, device_commands.HMDPower, 22, TOGGLECLICK)

for i,o in pairs(elements) do
	if  o.class[1] == class_type.TUMB or 
	   (o.class[2]  and o.class[2] == class_type.TUMB) or
	   (o.class[3]  and o.class[3] == class_type.TUMB)  then
	   o.updatable = true
	   o.use_OBB   = true
	end
end