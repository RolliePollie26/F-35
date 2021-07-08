local alt                       = CreateElement "ceStringPoly"
alt.name                        = create_guid_string()
alt.alignment                   = "RightCenter"
alt.material                    = FONT
alt.init_pos                    = {0.5,0.2,14}
alt.stringdefs                  = {
                                0.04,
                                0.04,
                                0,
                                0}
alt.formats                     = {"%.0f"}
alt.element_params              = {
                                    "ALT"
                                }
alt.controllers                 = {
                                    {"text_using_parameter",0}
                                }
alt.use_mipfilter               = true
alt.h_clip_relation             = h_clip_relations.COMPARE
alt.level                       = DEFAULT_NOCLIP_LEVEL
alt.parent_element              = "hud_base_clip"
Add(alt)