-- BEGIN -- this part of the file is not intended for an end-user editing, but forget about that :) 
--[[ --------------------------------------------------------------- ]]--

-- damage_omega = 30.0, -- (deg?) speed threshold of jamming during impact of rotation limiter
-- state_angle_0 = 6.131341662, -- (deg?) designed angle of retracted gear with horizontal axis of plane
-- state_angle_1 = -2.995164152, -- (deg?) designed angle of released gear with vertical axis of plane
-- mount_pivot_x = -0.274, -- (m) X-coordinate of attachment to fuselage in body-axis system
-- mount_post_radius = 0.657, -- (m) distance from strut-axis to attachment point of piston to gear stand
-- mount_length = 0.604555117, -- (m) What is the difference between this and the post_radius? length of angle brace in retracted configuration
-- mount_angle_1 = -3.138548523, -- (deg?) length of Position (vector) from attachment point
-- post_length = 1.748, -- (m) distance from rotation-axis of strut to wheel-axis
-- wheel_axle_offset = 0.05, -- (m) displacement wheel axis relative to strut
-- self_attitude = false, -- true if gear is self-oriented (Alba or Yak-52 example)

-- amortizer_min_length = 0.0, -- (m) rate of (minimum spring lenght / minimum length of damper)
-- amortizer_max_length = 0.397, -- (m) same as previous but max length
-- amortizer_basic_length = 0.397, -- (m) rate of (spring length in free (without load) condition / damper length in free (without load) condition)
-- amortizer_spring_force_factor = 1.6e+13, -- (???) spring tension factor
-- amortizer_spring_force_factor_rate = 20.0, -- (???)
-- amortizer_static_force = 80000.0, -- (N?) static reaction force of damper
-- amortizer_reduce_length = 0.377, -- (m) total suspension compression distance in non-load condition
-- amortizer_direct_damper_force_factor = 45000.0, -- (???) damper of positive movement
-- amortizer_back_damper_force_factor = 15000.0, -- (???) damper of negative (reversed) movement

-- wheel_radius = 0.308, -- (m) Tire radius
-- wheel_static_friction_factor = 0.65 , -- (unitless) Static friction factor when wheel not moves
-- wheel_roll_friction_factor = 0.025, -- (unitless) Rolling friction factor when wheel not moves
-- wheel_damage_force_factor = 250.0, --wheel cover (tire) strength force (not sure)
-- wheel_brake_moment_max = 15000, -- (N-m) Max braking moment torque 

-- BEGIN -- this part of the file is not intended for an end-user editing
--[[ --------------------------------------------------------------- ]]--

-- BEGIN -- this part of the file is not intended for an end-user editing
--[[ --------------------------------------------------------------- ]]--

F35A = {
    center_of_mass		= {0,0,0}, -- {0.175, -0.437, 0},--x,y,z
         moment_of_inertia 	= {12874.0, 85552.1, 75673.6},--Ix,Iy,Iz,Ixy
         suspension_data = 
         {
             {
                 mass  			  = 200,
                 pos   			  = {3.133,	-1.6,	0},
                 moment_of_inertia = {1000,1000,1000},
                 
                 
                 damage_element	    = 83,
                 -- (deg?) Speed threshold of jamming during impact of rotation limiter
                 damage_omega	    = 30.0, 
                 -- (deg?) Designed angle of retracted gear with horizontal axis
                 state_angle_0	    =  6.131341662, 
                 -- (deg?) Designed angle of extended gear with verrtical axis
                 state_angle_1	    = -2.995164152, 
                 -- (m) attachment point to fuselage along x-axis
                 mount_pivot_x	    = -0.274, 
                 -- (m) attachment point to fuselage along y axis
                 mount_pivot_y	    = -0.118, 
                 -- (m) distance from strut-axis to attachment point of piston to gear stand
                 mount_post_radius   = 0.657, 
                 -- (m) length of angle brace in retracted position
                 mount_length	   	= 0.604555117,
                 -- (deg?) length of position vector from attachment point
                 mount_angle_1	   	= -3.138548523,
                 -- (m) distance from rotation-axis of strut to wheel-axis
                 post_length	   		= 1.748,
                 -- (m) displacement of wheel relative to strut
                 wheel_axle_offset 	= 0.05,
                 -- Gear is self oriented
                 self_attitude	    = true,
                 yaw_limit		    = math.rad(89.0),
                 damper_coeff	    = 30.0,
                 
         
                 amortizer_min_length					= 0.0,
                 amortizer_max_length					= 0.397,
                 amortizer_basic_length					= 0.397,
                 amortizer_spring_force_factor			= 1.6e+13,
                 amortizer_spring_force_factor_rate		= 20.0,
                 amortizer_static_force					= 80000.0,
                 amortizer_reduce_length					= 0.377,
                 amortizer_direct_damper_force_factor	= 45000.0,
                 amortizer_back_damper_force_factor		= 15000.0,
         
         
                 wheel_radius				   = 0.479,
                 wheel_static_friction_factor  = 0.65 , --Static friction when wheel is not moving (fully braked)
                 wheel_side_friction_factor    = 0.65 ,
                 wheel_roll_friction_factor    = 0.025, --Rolling friction factor when wheel moving
                 wheel_glide_friction_factor   = 0.28 , --Sliding aircraft
                 wheel_damage_force_factor     = 250.0, -- Tire is explosing due to hard landing
                 wheel_damage_speed			   = 150.0, -- Tire burst due to excessive speed
         
         
                  wheel_moment_of_inertia   = 3.6, --wheel moi as rotation body
         
                  wheel_brake_moment_max = 15000.0, -- maximum value of braking moment  , N*m 
                 
                 --[[
                 args_post	  = {0,3,5};
                 args_amortizer = {1,4,6};
                 args_wheel	  = {76,77,77};
                 args_wheel_yaw = {2,-1,-1};
                 --]]
         
                 arg_post			  = 0,
                 arg_amortizer		  = 1,
                 arg_wheel_rotation    = 101,
                 arg_wheel_yaw		  = 2,
                 collision_shell_name  = "WHEEL_F",
             },
             {
                 mass  			  = 200,
                 pos   			  = {-1.185,	-1.603,	-1.185},
                 moment_of_inertia = {1000,1000,1000},
                 
                 
                 damage_element	    = 83,
                 damage_omega	    = 30.0,
                 state_angle_0	    =  6.131341662,
                 state_angle_1	    = -2.995164152,
                 mount_pivot_x	    = -0.274,
                 mount_pivot_y	    = -0.118,
                 mount_post_radius   = 0.657,
                 mount_length	   	= 0.604555117,
                 mount_angle_1	   	= -3.138548523,
                 post_length	   		= 1.748,
                 wheel_axle_offset 	= 0.05,
                 self_attitude	    = false,
                 yaw_limit		    = math.rad(89.0),
                 damper_coeff	    = 30.0,
                 
         
                 amortizer_min_length					= 0.0,
                 amortizer_max_length					= 0.397,
                 amortizer_basic_length					= 0.397,
                 amortizer_spring_force_factor			= 1.6e+13,
                 amortizer_spring_force_factor_rate		= 17.0,
                 amortizer_static_force					= 25000.0,
                 amortizer_reduce_length					= 0.377,
                 amortizer_direct_damper_force_factor	= 55000.0,
                 amortizer_back_damper_force_factor		= 10000.0,
         
         
                 wheel_radius				   = 0.68,
                 wheel_static_friction_factor  = 0.65 ,
                 wheel_side_friction_factor    = 0.65 ,
                 wheel_roll_friction_factor    = 0.025,
                 wheel_glide_friction_factor   = 0.28 ,
                 wheel_damage_force_factor     = 650.0,
                 wheel_damage_speed			   = 150.0,
                  wheel_moment_of_inertia   = 3.6, --wheel moi as rotation body
         
                  wheel_brake_moment_max = 15000.0, -- maximum value of braking moment  , N*m 
                 
                 --[[
                 args_post	  = {0,3,5};
                 args_amortizer = {1,4,6};
                 args_wheel	  = {76,77,77};
                 args_wheel_yaw = {2,-1,-1};
                 --]]
         
                 arg_post			  = 3,
                 arg_amortizer		  = 4,
                 arg_wheel_rotation    = 102,
                 arg_wheel_yaw		  = -1,
                 collision_shell_name  = "WHEEL_L",
             },
             {
                 mass  			  = 200,
                 pos   			  = {-1.185,	-1.603,	1.185},
                 moment_of_inertia = {1000,1000,1000},
                 
                 
                 damage_element	    = 83,
                 damage_omega	    = 30.0,
                 state_angle_0	    =  6.131341662,
                 state_angle_1	    = -2.995164152,
                 mount_pivot_x	    = -0.274,
                 mount_pivot_y	    = -0.118,
                 mount_post_radius   = 0.657,
                 mount_length	   	= 0.604555117,
                 mount_angle_1	   	= -3.138548523,
                 post_length	   		= 1.748,
                 wheel_axle_offset 	= 0.05,
                 self_attitude	    = false,
                 yaw_limit		    = math.rad(89.0),
                 damper_coeff	    = 30.0,
                 
         
                 amortizer_min_length					= 0.0,
                 amortizer_max_length					= 0.397,
                 amortizer_basic_length					= 0.397,
                 amortizer_spring_force_factor			= 1.6e+13,
                 amortizer_spring_force_factor_rate		= 17.0,
                 amortizer_static_force					= 25000.0,
                 amortizer_reduce_length					= 0.377,
                 amortizer_direct_damper_force_factor	= 55000.0,
                 amortizer_back_damper_force_factor		= 10000.0,
         
         
                 wheel_radius				   = 0.68,
                 wheel_static_friction_factor  = 0.65 ,
                 wheel_side_friction_factor    = 0.65 ,
                 wheel_roll_friction_factor    = 0.025,
                 wheel_glide_friction_factor   = 0.28 ,
                 wheel_damage_force_factor     = 650.0,
                 wheel_damage_speed			   = 150.0,
                  wheel_moment_of_inertia   = 3.6, --wheel moi as rotation body
         
                  wheel_brake_moment_max = 15000.0, -- maximum value of braking moment  , N*m 
                 
                 --[[
                 args_post	  = {0,3,5};
                 args_amortizer = {1,4,6};
                 args_wheel	  = {101,102,103};
                 args_wheel_yaw = {2,-1,-1};
                 --]]
         
                 arg_post			  = 5,
                 arg_amortizer		  = 6,
                 arg_wheel_rotation    = 103,
                 arg_wheel_yaw		  = -1,
                 collision_shell_name  = "WHEEL_R",
             },
        },
            
        disable_built_in_oxygen_system	= true,
        --[[ ------------------------------------------------------------- ]]--
        -- END -- this part of the file is not intended for an end-user editing
    
        -- view shake amplitude
        minor_shake_ampl = 0.21,
        major_shake_ampl = 0.5,
    
        -- debug
        debugLine = "{M}:%1.3f {IAS}:%4.1f {AoA}:%2.1f {ny}:%2.1f {nx}:%1.2f {AoS}:%2.1f {mass}:%2.1f {Fy}:%2.1f {Fx}:%2.1f {wx}:%.1f {wy}:%.1f {wz}:%.1f {Vy}:%2.1f {dPsi}:%2.1f",
        record_enabled = false,
    }