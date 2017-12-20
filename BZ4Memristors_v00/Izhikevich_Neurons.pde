int number_of_neurons_x = 300;
int number_of_neurons_y = 300;

float  a=0.02; 
float  b_neuron=0.2;
float  c=-65; //mV
float  d=4;
float  dt_neuron=0.5; //0.25; // time step

float u[] = new float[1000];
float unew[] = new float[1000];
float v[] = new float[1000];
float vnew[] = new float[1000];
float I[] = new float[1000];
float v_thresh=30;

int   t=0;

float dI=4; //current increment controlled manually 

/**
Updates states of the neurons in 2D matrix.
*/
void UpdateNeuronStates()
{
  int[] NumFired = new int[1000];

  for (int i=1; i<=n; i++) NumFired[i]=0;


  for (int i=1; i<=number_of_neurons_x; i++) 
  { 

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