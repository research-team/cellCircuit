/**
This script is responsible for the PANI segments and memristors states processing
*/

boolean MEM_DEBUG = false;

int number_of_memristors_x = 300;
int number_of_memristors_y = 300;
float default_segment_resistance = 20E6; // 20 mOhm initialisation
float default_memristor_resistance = 5E6; // 20 mOhm initialisation

float R_mem_min = 0.107E6;
float R_mem_max = 5E6;
//20 megaOm
float R_pani_min = 20E6;
float R_pani_max = 120E6;

float R_pani[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every PANI segment
float R_mem[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every memristor connected to the PANI segment

/**
 Updates states of memristors in 2D matrix.
 */
void UpdateMemristorsStates()
{ 
  for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) { 
      if (NumFired[i][j]==1) 
      { 
        //rectangular spikes
        R_mem[i][j] = R_spikes(Spikes[i][j], 20, 20, true);
      } 
      if (MEM_DEBUG) println("[Debug] R_mem="+R_mem[i][j]+" Fired=", NumFired[i][j]);
    }
  }
}

/**
Initialises states of PANI segments in 2D matrix.
*/
void InitialisePANISegmentsStates()
{
   for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) {
      R_pani[i][j] = default_segment_resistance;
    }
  }
}


/**
Initialises states of memristors segments in 2D matrix.
*/
void InitialiseMemristorsStates()
{
   for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) {
      R_pani[i][j] = default_memristor_resistance; 
    }
  }
}

/**
Implements the memristors life cycle updating leakage and potential values
*/
void memristors_life_cycle (){

  UpdateMemristorsStates();

}