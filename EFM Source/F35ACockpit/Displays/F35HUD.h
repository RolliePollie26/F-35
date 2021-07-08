#ifndef _F35HUD_H_
#define _F35HUD_H_

#include "../stdafx.h"
#include "BaseDisplay.h"

class F35HUD : public BaseDisplay
{
public:
	F35HUD() 
		: BaseDisplay()
	{}
	~F35HUD() {}

	void updateFrame(double frametime) {}
};

#endif 
