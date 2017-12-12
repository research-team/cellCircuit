// Single neuron 
// v = v + dt*(0.004*v*v+5*v+140-u+I)
// u = u + dt*a*(b*v - u)
int n=2;

float  a=0.02; 
float  b=0.2;
float  c=-65; //mV
float  d=4;
float  dt=0.5; //0.25; // time step

float u[] = new float[1000];
float unew[] = new float[1000];
float v[] = new float[1000];
float vnew[] = new float[1000];
float I[] = new float[1000];
float v_thresh=30;

int   t=0;

float dI=4; //current increment controlled manually 


void setup()
{
  size(1500, 500);
  background(255, 255, 255);
  SetInitialCurrentPotential();
}

void SetInitialCurrentPotential()
{
  for (int i=1; i<=n; i++) 
  {
    u[i]=-65*random(1);
    I[i]=4;
  }
}

void UpdateStates()
{
  int[] NumFired = new int[1000];

  for (int i=1; i<=n; i++) NumFired[i]=0;


  for (int i=1; i<=n; i++) 
  { 

    if (v[i] >= v_thresh) 
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

void RewriteStates()
{
  for (int i=1; i<=n; i++) 
  {
    v[i]=vnew[i];
    u[i]=unew[i];
  }
}


void keyPressed()
{
  if (key=='x') {
    save("frame.png"); 
    exit();
  }
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

void DrawStates()
{
  if (t%1500==0) background(255, 255, 255);
  stroke(0, 0, 255);
  point(t%1500*dt, 250-v[1]);
  line((t-1)%1500*dt, 250-v[1], t%1500*dt, 250-vnew[1]);
  stroke(255, 0, 0);
  point(t%1500*dt, 250-v[2]);
  line((t-1)%1500*dt, 250-v[2], t%1500*dt, 250-vnew[2]);
}
void draw()
{
  t++;
  UpdateStates();
  DrawStates();
  RewriteStates();
}