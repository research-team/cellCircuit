boolean IZHI_DEBUG = true;


int number_of_neurons_x = 300;
int number_of_neurons_y = 300;

float  a=0.02; 
float  b_neuron=0.2;
float  resting_potential=-65.0; //mV
float  d=4;
float  dt_neuron=0.5; //0.25; // time step

float leakage[][] = new float[number_of_neurons_y][number_of_neurons_x]; // u
float leakage_new[][] = new float[number_of_neurons_y][number_of_neurons_x];
float potential[][] = new float[number_of_neurons_y][number_of_neurons_x]; // v
float potential_new[][] = new float[number_of_neurons_y][number_of_neurons_x];
float I[][] = new float[number_of_neurons_y][number_of_neurons_x];
float v_thresh=-55.0;
int[][] NumFired = new int[number_of_neurons_y][number_of_neurons_x]; // the fired neurons 2D matrix
int neuro_time=0;

float dI=4; //current increment controlled manually 

/**
 Updates states of the neurons in 2D matrix.
 */
void UpdateNeuronStates()
{
  for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) {
      NumFired[i][j] = 0;
    }
  }
  
  for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) { 
      if (potential[i][j] >= v_thresh) 
      { 
        potential_new[i][j] = resting_potential; 
        leakage_new[i][j] = leakage[i][j] + d;
        I[i][j]=0;
        //TODO update NumFired
        NumFired[i][j]=1;
        //if (i==2) NumFired[1]=1;
      } else 
      {
        I[i][j]=I[i][j]+4*NumFired[i][j];
        potential_new[i][j] = potential[i][j] + dt*(0.04*potential[i][j]*potential[i][j] + 5*potential[i][j] + 140 - leakage[i][j] + I[i][j]);
        leakage_new[i][j] = leakage[i][j] + dt*(a * ((b_neuron*potential[i][j])-leakage[i][j]));
      }
      if (IZHI_DEBUG) println("[Debug] I="+I[i][j]+" V="+ potential[i][j], " Fired=", NumFired[i][j]);
    }
  }
}

/**
 Updates the state of neurons in the 2D array rewriting the potential and leakage values
 */
void RewriteNeuronStates()
{
  for (int i=0; i<number_of_neurons_x; i++) 
  {
    for (int j=0; j<number_of_neurons_y; j++){
      potential[i][j]=potential_new[i][j];
      leakage[i][j]=leakage_new[i][j];
    }
  }
}

/**
Updates the current value in the point in 2D space identified by x and y.
@param x the abscissa of the point to process
@param y the ordinate of the point to process
 */
void UpdateCurrent(int x, int y)
{
  float excitation_rnd = noise(x, y);
  float inhibition_rnd = noise(x, y);

  if (excitation_rnd > inhibition_rnd) 
  {
    I[x][y]=I[x][y]+dI;
  } else 
  {
    I[x][y]=I[x][y]-dI; 
  }
  if (IZHI_DEBUG) println("[Debug] I: "+I[x][y]);
}

/**
Updates the value of the current in every point of the 2D space
*/
void UpdateCurrent() {
  for (int i=0; i<number_of_neurons_x; i++) 
  {
    for (int j=0; j<number_of_neurons_y; j++){
      UpdateCurrent(i,j);      
    }
  }
}

/**
Implements the neuronal life cycle updating leakage and potential values
*/
void neuronal_life_cycle (){

  UpdateCurrent();
  UpdateNeuronStates();
  RewriteNeuronStates();

}