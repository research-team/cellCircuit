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
int maxDot=6;
int neuro_time=0;
int[][] drawFired= new int[reactor_width][reactor_height];
float dI=4; //current increment controlled manually 
//mapping array.
DotMapping[][][] spikesMapping = new DotMapping[reactor_width][reactor_height][reactor_width*4];

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
  for  (int i=0; i < reactor_width*4; i++){
    if (map[i]!=null)
    {
      Spikes_pixels[map[i].x][map[i].y]++;
      drawFired[map[i].x][map[i].y]=1;
    }
    else {
      break;
    }
  }
}
int allocatedCount=0;
DotMapping[] allocation=new DotMapping[reactor_width*reactor_height];
 int theMaxAllocation=reactor_width*reactor_height-1;
void setupIzhikevichN(){
  //setup mapping to pixels
  int x=0,y=0;
 
  for (int i=0; i<reactor_width*reactor_height; i++)
  {
      allocation[i]=new DotMapping(x,y);
      if (x==(reactor_width-1))
        {
          x=0;
          y++;
         
        }
        else
        {
          x++;
         
        }
  }
  int totalNeurons=number_of_neurons_x*number_of_neurons_y; //<>//
  int totalReactorCapacity=reactor_width*reactor_height;
  float capacity=totalReactorCapacity/totalNeurons;
  int maxDot=floor(capacity);
  
  for (int i=0; i < number_of_neurons_x; i++)
  {
    
    for (int j=0; j < number_of_neurons_y; j++){
      if (totalNeurons>0) capacity=totalReactorCapacity/totalNeurons;
      totalNeurons--;
      int maxDot2=floor(capacity);
      int rndUpDot=int(random(floor(maxDot/2),max(maxDot,maxDot2)));
      
      //if (iFillX>=(reactor_width-1)) iFillX=reactor_width;
      //if (iFillY>=(reactor_height-1)) iFillY=reactor_height;
      int dot=0;
      println("[Debug] Cap:"+rndUpDot+" React:"
      +totalReactorCapacity+" Neuron:"+totalNeurons+" i,j:"+i+","+j);
      for (int dti=0; dti<rndUpDot; dti++)
      {
        totalReactorCapacity--;
        spikesMapping[i][j][dot]=_getNextDot();//new DotMapping(iFillX,iFillY);
        println("[Debug] X:"+( spikesMapping[i][j][dot].x)+" Y:"+( spikesMapping[i][j][dot].y)+" Z:"+dot);
        dot++;
      }
      
        
     
  }
  }
   
} //<>//
//Fisher Yates alg . https://stackoverflow.com/questions/196017/unique-non-repeating-random-numbers-in-o1
DotMapping _getNextDot(){
    int alloc= (int)(random(0,theMaxAllocation));
    DotMapping res=allocation[alloc]; //<>//
    DotMapping swap = new DotMapping(res.x,res.y);
    allocation[alloc]=allocation[theMaxAllocation];
    allocation[theMaxAllocation]=swap;
    theMaxAllocation--;
    return res;
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
      Spikes[i][j] = ceil(random(0, 1000));      
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