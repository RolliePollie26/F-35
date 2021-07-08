
ALTWARNING                      = hmdString(0, 0)
ALTWARNING.alignment            = "CenterCenter"
ALTWARNING.stringdefs           = TEXT_SIZE.HUGE
ALTWARNING.formats              = {"ALTITUDE"}
ALTWARNING.element_params       = {"","WARNALT"}
ALTWARNING.controllers          = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(ALTWARNING)

OVERGWARNING                      = hmdString(0, 0)
OVERGWARNING.alignment            = "CenterCenter"
OVERGWARNING.stringdefs           = TEXT_SIZE.HUGE
OVERGWARNING.formats              = {"OVER G"}
OVERGWARNING.element_params       = {"","WARNOVERG"}
OVERGWARNING.controllers          = {{"text_using_parameter",0},{"opacity_using_parameter",1}}
Add(OVERGWARNING)
