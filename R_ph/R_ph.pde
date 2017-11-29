PImage img;  // Declare a variable of type PImage

color black = color(46, 46, 46);
int r_min = 20;
int r_max = 120;
int ph_min = 2;
int ph_max = 10;
int x_max = 610;
double[] dots = new double[x_max];
PrintWriter out;
String R_pH_file_name = "R_pH.csv";

//https://processing.org/reference/loadPixels_.html
//https://processing.org/tutorials/pixels/

double height2R(int h){
  double res = 0;
  res = (281 - h)*(r_max - r_min)/281 + r_min;
  return res;
}

void tests() {
  // tests 
  int x = 0;
  x = (3 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 3 dots ", dots[x]);
  x = (4 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 4 dots ", dots[x]);
  x = (5 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 5 dots ", dots[x]);
  x = (6 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 6 dots ", dots[x]);
  x = (7 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 7 dots ", dots[x]);
  x = (8 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, " 8 dots ", dots[x]);
  x = (9 - ph_min) * x_max/ (ph_max - ph_min);
  println (x, "", 9 ," dots ", dots[x]);

}

void tests_R_pH(float[] R_pH_vec) {
  // tests 
  println (" 3 R_pH ", R_pH(3, R_pH_vec));
  println (" 4 R_pH ", R_pH(4, R_pH_vec));
  println (" 5 R_pH ", R_pH(5, R_pH_vec));
  println (" 6 R_pH ", R_pH(6, R_pH_vec));
  println (" 7 R_pH ", R_pH(7, R_pH_vec));
  println (" 8 R_pH ", R_pH(8, R_pH_vec));
  println (" 8.5 R_pH ", R_pH(8.5, R_pH_vec));
}

void load_R_ph_image(){
  image(img,0,0);
  loadPixels();
  for (int j = 0; j < height; j++) {
    for (int i = 0; i < width; i++) {
      // println (i, " ; " ,j, "is " , pixels[i + j*width]);
      if (pixels[i + j*width] == black){
        //println (i, " ; " ,j, "is ", pixels[i + j*width]);
        dots[i] = height2R(j);
      }
    }
  }
}

void write_image_to_file(){
  // writing the file
  for (int ii =0; ii < 610; ii ++){
    if (ii > 0){ out.print(","); }
    out.print(dots[ii]);
  }
  out.flush(); // Writes the remaining data to the file
  out.close(); // Finishes the file
}

float[] parseFile(String file_name, int number_of_values) {
  // Open the file from the createWriter() example
  BufferedReader reader = createReader(file_name);
  String line = null;
  float[] nums = new float[number_of_values];
  try {
    while ((line = reader.readLine()) != null) {
       nums = float(split(line, ','));
    }
    reader.close();
    return nums;
  } catch (IOException e) {
    e.printStackTrace();
  }
  return nums;
} 

float R_pH(float pH, float[] R_pH_vec) {
  float res = 0.0;
  int index = int((pH - ph_min) * x_max/ (ph_max - ph_min));
  println("pH ", pH ,"index ", index, " length ", R_pH_vec.length);
  res = R_pH_vec[index];
  return res;
}

void setup() {
  size(610,281);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("R_pH_trunk.png");
  // out = createWriter("R_pH.csv");   
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
  //load_R_ph_image();
  //tests();
  //write_image_to_file();
 
  float[] R_pH_vec = parseFile(R_pH_file_name, x_max);
  tests_R_pH(R_pH_vec);
}