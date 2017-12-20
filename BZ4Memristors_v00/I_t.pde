//for the oxidation 
float I0_ox = 74.9E-7;
float A_ox = -86.2E-7;
float t_ox = -342.0;
// for the reduction
float I0_red = -11.7E-9; 
float A_red = -41.0E-7;
float t_red = -45.0;

// electric pulse parameters

float u_red = -0.1;
float u_ox = 0.8;

float I_max = 7.5E-6;
float I_0 = 0.166666667E-6;
float I_min = -7.5E-6;

/**
Returns max value of resistance based on minimal current and U=0.8V in case of reduction
*/
float R_mem_red_max() {
  return abs(u_red / I_0);
}
/**
Returns min value of resistance based on maximum current and U=0.8V in case of reduction
*/
float R_mem_red_min() {
  return abs(u_red / I_max);
}

/**
Returns max value of resistance based on minimal current and U=0.8V in case of reduction
*/
float R_mem_ox_max() {
  return abs(u_ox / I_min);
}
/**
Returns min value of resistance based on maximum current and U=0.8V in case of reduction
*/
float R_mem_ox_min() {
  return abs(u_ox / I_0);
}

float T_previous = 0.0;
/**
Calculates I depending on memorized R depending on time of current exposure. 
@param t the time of electrical current in the pulse
@param is_learning the current in the direction of learning
@return the value of I
*/
float i_t(float t, boolean is_oxidation){
  float res = 0.0;
  float I0 = 0.0;
  float A = 0.0;
  float tau = 0.0;
  if (is_oxidation) {
    //oxidation
    I0  = I0_ox;
    A = A_ox;
    tau = t_ox;
  } else {
    //reduction
    I0  = I0_red;
    A = A_red;
    tau = t_red;
  }
  
  res = I0 + A * exp((t)/tau);
  return res;
}

/**
Calculate the R using the time parameter starting from simulation and pulses setup.
@param t - the current time of a simulation
@param period - a pulse period (currently not used)
@param duty - a duty ratio of pulses in percents
@param is_learning the current in the direction of learning
@returns the resintance value
*/
float R_i(float t, float period, float duty, boolean is_oxidation){
  float res = 0.0;
   println ("Debug: [", t ,";", period,"]");
  float t_exposure = t * duty / 100;
  if (is_oxidation){
    res= abs((u_ox) / i_t(t_exposure, is_oxidation));
  } else {
    res= abs((u_red) / i_t(t_exposure, is_oxidation));
  }
  
  return res;
}