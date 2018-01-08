/**
This script is responsible for the PANI segments and memristors states processing
*/

boolean MEM_DEBUG = false;

int number_of_pani_segments_x = 300;
int number_of_pani_segments_y = 300;

int number_of_memristors_x = 300;
int number_of_memristors_y = 300;

float R_mem_min = 7.0E5;
float R_mem_max = 1.0E8;
//20 megaOm
float R_pani_min = 20E6;
float R_pani_max = 120E6;

float default_segment_resistance = R_pani_min; // 20 mOhm initialisation
float default_memristor_resistance = R_mem_min; // 20 mOhm initialisation

float R_pani[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every PANI segment
float R_mem[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every memristor connected to the PANI segment

/**
 Updates states of memristors in 2D matrix.
 */
void UpdateMemristorsStates()
{ 
  for (int i=0; i<number_of_memristors_x; i++) {
    for (int j=0; j<number_of_memristors_y; j++) { 
      if (NumFired[i][j]==1) 
      { 
        //rectangular spikes with period of 20 milliseconds
        R_mem[i][j] = R_spikes(Spikes[i][j], 20E-3, 20, true);
      } 
      if (MEM_DEBUG) println("[Memristors] R_mem="+R_mem[i][j]+" Fired=", Spikes[i][j]);
    }
  }
}

/**
Initialises states of PANI segments in 2D matrix.
*/
void InitialisePANISegmentsStates()
{
   for (int i=0; i<number_of_pani_segments_x; i++) {
    for (int j=0; j<number_of_pani_segments_y; j++) {
      R_pani[i][j] = default_segment_resistance;
    }
  }
}


/**
Initialises states of memristors segments in 2D matrix.
*/
void InitialiseMemristorsStates()
{
   for (int i=0; i<number_of_memristors_x; i++) {
    for (int j=0; j<number_of_memristors_x; j++) {
      R_mem[i][j] = default_memristor_resistance; 
    }
  }
}

/**
Implements the memristors life cycle updating leakage and potential values
*/
void memristors_life_cycle (){

  UpdateMemristorsStates();

}