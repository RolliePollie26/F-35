#ifndef _F35AERORESULTS_H_
#define _F35AERORESULTS_H_

class F35CoeffRes
{
public:
	double r_Cx = 0.0;
	double r_Cz = 0.0;
	double r_Cm = 0.0;
	double r_Cy = 0.0;
	double r_Cn = 0.0;
	double r_Cl = 0.0;

public:
	F35CoeffRes() {}
	~F35CoeffRes() {}
};

class F35CoeffRes3
{
public:
	double r_Cy = 0.0;
	double r_Cn = 0.0;
	double r_Cl = 0.0;

public:
	F35CoeffRes3() {}
	~F35CoeffRes3() {}
};

// just container for results:
// keep in one place and reduce some repeated things
class F35AeroResults
{
public:

	// with elevator
	F35CoeffRes elev;

	// testing, differential elevator support
	F35CoeffRes eleLeft;
	F35CoeffRes eleRight;

	// elevator at zero
	F35CoeffRes elevZero;

	// leading edge flaps
	F35CoeffRes lef;

	double r_CXq = 0.0;
	double r_CZq = 0.0;
	double r_CMq = 0.0;
	double r_CYp = 0.0;
	double r_CYr = 0.0;
	double r_CNr = 0.0;
	double r_CNp = 0.0;
	double r_CLp = 0.0;
	double r_CLr = 0.0;
	double r_delta_CXq_lef = 0.0;
	double r_delta_CZq_lef = 0.0;
	double r_delta_CMq_lef = 0.0;
	double r_delta_CYp_lef = 0.0;
	double r_delta_CYr_lef = 0.0;
	double r_delta_CNr_lef = 0.0;
	double r_delta_CNp_lef = 0.0;
	double r_delta_CLp_lef = 0.0;
	double r_delta_CLr_lef = 0.0;

	F35CoeffRes3 rudder30;
	F35CoeffRes3 ail20;
	F35CoeffRes3 ailLef20;

	double r_delta_CNbeta = 0.0;
	double r_delta_CLbeta = 0.0;
	double r_delta_Cm = 0.0;
	//double r_eta_el = 0.0;

	// testing, differential elevator support
	double r_eta_elLeft = 0.0;
	double r_eta_elRight = 0.0;

public:
	F35AeroResults() {}
	~F35AeroResults() {}
};


#endif // _F35AERORESULTS_H_

