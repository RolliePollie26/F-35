#ifndef _F35RADAR_H_
#define _F35RADAR_H_

#include "../stdafx.h"
#include "BaseDisplay.h"

class F35Radar : public BaseDisplay
{
public:
	F35Radar() 
		: BaseDisplay()
	{}
	~F35Radar() {}

	void updateFrame(double frametime) {}
};

#endif 
