int number_of_neurons_x = 300;
int number_of_neurons_y = 300;

float  a=0.02; 
float  b_neuron=0.2;
float  c=-65; //mV
float  d=4;
float  dt_neuron=0.5; //0.25; // time step

float leakage[][] = new float[number_of_neurons_y][number_of_neurons_x]; // u
float leakage_new[][] = new float[number_of_neurons_y][number_of_neurons_x];
float potential[][] = new float[number_of_neurons_y][number_of_neurons_x]; // v
float potential_new[][] = new float[number_of_neurons_y][number_of_neurons_x];
float I[][] = new float[number_of_neurons_y][number_of_neurons_x];
float v_thresh=30;

int neuro_time=0;

float dI=4; //current increment controlled manually 

/**
 Updates states of the neurons in 2D matrix.
 */
void UpdateNeuronStates()
{
  int[][] NumFired = new int[number_of_neurons_y][number_of_neurons_x];

  for (int i=1; i<=number_of_neurons_x; i++) {
    for (int j=1; i<=number_of_neurons_y; j++) {
      NumFired[i][j] = 0;
    }
  }


  for (int i=1; i<=number_of_neurons_x; i++) {
    for (int j=1; i<=number_of_neurons_y; j++) { 
      if (v[i][j] >= v_thresh) 
      { 
        vnew[i] = c; 
        unew[i] = u[i] + d;
        if (i==1) NumFired[2]=1;
        if (i==2) NumFired[1]=1;
        I[i]=0;
      } else 
      {
        I[i]=I[i]+4*NumFired[i];
        vnew[i] = v[i] + dt*(0.04*v[i]*v[i] + 5*v[i] + 140 - u[i] + I[i]);
        unew[i] = u[i] + dt*(a * ((b*v[i])-u[i]));
      }
      println("I: "+I[1]+" "+I[2]+" V= "+v[1]+" "+v[2]);
    }
  }
}

/**
 @param n - the number of neurons
 */
void RewriteNeuronStates(int n)
{
  for (int i=1; i<=n; i++) 
  {
    v[i]=vnew[i];
    u[i]=unew[i];
  }
}

/**
 */
void updateCurrent(int x, int y)
{
  if (key == CODED) {
    if (keyCode == UP) 
    {
      I[1]=I[1]+dI; 
      println("I="+I[1]);
    } else if (keyCode == DOWN) 
    {
      I[1]=I[1]-dI; 
      println("I="+I[1]);
    }
  }
}