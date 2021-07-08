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
