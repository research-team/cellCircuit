/**
This script is responsible for the PANI segments and memristors states processing
*/

boolean MEM_DEBUG = false;

int number_of_memristors_x = 300;
int number_of_memristors_y = 300;

float R_pani[][]; // the resistance of every PANI segment
float R_mem[][]; // the resistance of every memristor connected to the PANI segment