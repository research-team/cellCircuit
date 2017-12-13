//for the oxidation 
float I0_ox = 74.9E-7;
float A_ox = -86.2E-7;
float t_ox = -342.0;
// for the reduction
float I0_red = -11.7E-9; 
float A_red = -41.0E-7;
float t_red = -45;

float T_previous = 0.0;
/**
Calculate I depending on memorized R depending on time of current exposure. 
@param t the time of electrical current in the pulse
@return the value of I
*/
float i_t(float t, float i_current){
  float res = 0.0;
  float I0 = 0.0;
  float A = 0.0;
  float tau = 0.0;
  if (i_current >0) {
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
  
  res = I0 + A * exp(t/tau);
  return res;
}