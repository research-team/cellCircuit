//for the oxidation 
float I0_ox = 74.9E-7;
float A_ox = -86.2E-7;
float t_ox = -342.0;
// for the reduction
float I0_red = -11.7E-9; 
float A_red = -41.0E-7;
float t_red = -45.0;

float T_previous = 0.0;
/**
Calculate I depending on memorized R depending on time of current exposure. 
@param t the time of electrical current in the pulse
@param is_learning the current in the direction of learning
@return the value of I
*/
float i_t(float t, boolean is_learning){
  float res = 0.0;
  float I0 = 0.0;
  float A = 0.0;
  float tau = 0.0;
  if (is_learning) {
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

// electronic pulse parameters

float v_min = 0.4;
float v_max = 0.8;

/**
Calculate the R using the time parameter starting from simulation and pulses setup.
@param t - the current time of a simulation
@param period - a pulse period (currently not used)
@param duty - a duty ratio of pulses in percents
@param is_learning the current in the direction of learning
@returns the resintance value
*/
float R_i(float t, float period, float duty, boolean is_learning){
  float res = 0.0;
   println ("Debug: [", t ,";", period,"]");
  float t_exposure = t * duty / 100;
  res= (v_max-v_min) / i_t(t_exposure, is_learning);
  return res;
}