/**
This script is responsible for the PANI segments and memristors states processing
*/

boolean MEM_DEBUG = false;

int number_of_memristors_x = 300;
int number_of_memristors_y = 300;

float R_pani[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every PANI segment
float R_mem[][] = new float[number_of_memristors_x][number_of_memristors_y]; // the resistance of every memristor connected to the PANI segment

/**
 Updates states of memristors in 2D matrix.
 */
void UpdateMemristorStates()
{ 
  for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) { 
      if (NumFired[i][j]==1) 
      { 
        R_mem[i][j] = R_mem[i][j] + R_spikes(spikes[i][j], 20, 20, true);
      } 
      if (MEM_DEBUG) println("[Debug] R_mem="+R_mem[i][j]+" Fired=", NumFired[i][j]);
    }
  }
}

/**
 Updates states of PANI segments in 2D matrix.
*/
void InitialisePANISegmentsStates()
{
   for (int i=0; i<number_of_neurons_x; i++) {
    for (int j=0; j<number_of_neurons_y; j++) {
      R_pani[i][j] = 20; // 20 mOhm initialisation
    }
  }
}