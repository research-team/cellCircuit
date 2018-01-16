/**
This script is responsible for the Izhikevich neurons states processing
*/

boolean IZHI_DEBUG = false;

int number_of_neurons_x =100;
int number_of_neurons_y = 100;

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
int[][] Spikes = new int[number_of_neurons_y][number_of_neurons_x]; // the number of spikse per neuron 2D matrix
int[][] Spikes_pixels = new int[reactor_width][reactor_height];
int offsetX; int offsetY;
int maxDot=2;
int neuro_time=0;
int[][] drawFired= new int[reactor_width][reactor_height];
float dI=4; //current increment controlled manually 
//mapping array.
DotMapping[][][] spikesMapping = new DotMapping[reactor_width][reactor_height][maxDot*maxDot+1];

class DotMapping{
  int x,y;
  boolean set=false;
  DotMapping(int _x, int _y){
   x=_x;
   y=_y;
   set=true;
  }
}


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
  for (int i=0; i<reactor_width; i++) {
    for (int j=0; j<reactor_height; j++) {
      drawFired[i][j] = 0;
    }
  }
  offsetX=0;
  offsetY=0;
  for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) { 
      if (potential[i][j] >= v_thresh) 
      { 
        potential_new[i][j] = resting_potential; 
        leakage_new[i][j] = leakage[i][j] + d;
        I[i][j]=0;
        NumFired[i][j]=1;
        Spikes[i][j] ++; 
        _updateSpikesMapping(i,j);
      } else 
      {
        I[i][j]=I[i][j]+4*NumFired[i][j];
        potential_new[i][j] = potential[i][j] + dt*(0.04*potential[i][j]*potential[i][j] + 5*potential[i][j] + 140 - leakage[i][j] + I[i][j]);
        leakage_new[i][j] = leakage[i][j] + dt*(a * ((b_neuron*potential[i][j])-leakage[i][j]));
      }
      if (IZHI_DEBUG) println("[Debug] I="+I[i][j]+" V="+ potential[i][j], " Fired=", NumFired[i][j], " spikes=", Spikes[i][j]);
    }
  }
}

/**
Updates the graphical representation of spikes.
*/

void _updateSpikesPixels(int indexX, int indexY){
 int availableReactorX=reactor_width;
 int availableReactorY=reactor_height;
 
  //to decrease neuronal size one spike affect n_pixels.
 //offsetX=0;
 //offsetY=0;
 //if (indexX==number_of_neurons_x/2-1) offsetX=reactor_width-number_of_neurons_x;
 //if (indexY==number_of_neurons_y/2-1) offsetY=reactor_width-number_of_neurons_y;
 float realDistributionX=(float)reactor_width/ (float)number_of_neurons_x;
 float realDistributionY=(float)reactor_height/ (float)number_of_neurons_y;
 int maxX = ceil(realDistributionX);
 int maxY = ceil(realDistributionY);
  
 if (indexX+maxX+offsetX>reactor_width) offsetX=reactor_width-maxX-indexX;
 if (indexY+maxY+offsetY>reactor_height) offsetY=reactor_height-maxY-indexY;
 
 
 for (int iFillX=indexX+offsetX; iFillX<indexX+maxX+offsetX;iFillX++)
 {
   for (int iFillY=indexY+offsetY; iFillY<indexY+maxY+offsetY;iFillY++)
   {
      Spikes_pixels[iFillX][iFillY]++;
      drawFired[iFillX][iFillY]=1;
   } 
 }
 offsetX=indexX+maxX;
 offsetY=indexY+maxY;
}


/***
Update the spikes mapping 
*/
void _updateSpikesMapping(int indexX, int indexY){
  DotMapping[] map=spikesMapping[indexX][indexY];
  for  (int i=0; i < maxDot*maxDot; i++){
    if (map[i]!=null)
    {
      println("[Debug] "+map[i].x+" "+map[i].y);
      Spikes_pixels[map[i].x][map[i].y]++;
      drawFired[map[i].x][map[i].y]=1;
    }
    else {
      break;
    }
  }
}

void setupIzhikevichN(){
  //setup mapping to pixels
  float realDistributionX=(float)reactor_width/ (float)number_of_neurons_x;
  float realDistributionY=(float)reactor_height/ (float)number_of_neurons_y;
  int maxX =maxDot;//ceil(realDistributionX);
  int maxY =maxDot;//ceil(realDistributionY);
  int minX =1;// floor(realDistributionX);
  int minY =1;// floor(realDistributionY);
  int offsetX=0, offsetY=0;
  //finalDot when we out of array and everything distributed already.
  DotMapping finalDot=new DotMapping(reactor_width-1,reactor_height-1);
  for (int i=0; i < number_of_neurons_x; i++)
  {
    
    for (int j=0; j < number_of_neurons_y; j++){
      //<>//
      int rndX=int(random(minX,maxX));
      int rndY=int(random(minY,maxY));
      int maxFillX=i+offsetX+rndX;
      int maxFillY= j+offsetY+rndY;
      if (i+offsetX+rndX>=(reactor_width-1)) maxFillX=reactor_width;
      if (j+offsetY+rndY>=(reactor_height-1)) maxFillY=reactor_height;
      int dot=0;
      int iFillX=0,iFillY=0;
      for (iFillX=i+offsetX; iFillX<maxFillX;iFillX++)
        {
         for (iFillY=j+offsetY; iFillY<maxFillY;iFillY++)
         {
            if (spikesMapping[i][j][dot]==null || !spikesMapping[i][j][dot].set)
            {
               spikesMapping[i][j][dot] = new DotMapping(iFillX,iFillY);
                  println("[Debug] "+(iFillX)+" "+(iFillY));
               dot++;
            }
           
         } 
        }
       if (offsetX>299) 
       {
         println("[i Cycle] "+i); //<>//
       }
      offsetX=iFillX;
      offsetY=iFillY;
        
     
  }
  }
  
 
  
  
} //<>//



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
  float excitation_inclination = 0.8;
  float excitation_rnd = random(-dI*excitation_inclination, dI);
  I[x][y] = I[x][y] + excitation_rnd;
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
Intialises the Spikes array with random history of spikes 
*/
void Initialise_Neurons(){
  for (int i=0; i<number_of_neurons_x; i++) 
  {
    for (int j=0; j<number_of_neurons_y; j++){
      Spikes[i][j] = ceil(random(0, 1)*1000);      
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