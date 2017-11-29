PImage img;  // Declare a variable of type PImage

color black = color(46, 46, 46);
int r_min = 20;
int r_max = 120;
int ph_min = 2;
int ph_max = 10;
int y_max = 610;
double[] dots = new double[y_max];

//https://processing.org/reference/loadPixels_.html
//https://processing.org/tutorials/pixels/

void setup() {
  size(610,281);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("R_pH_trunk.png");
  
}

double height2R(int h){
  double res = 0;
  res = (281 - h)*(r_max - r_min)/281 + r_min;
  return res;
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
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

  // tests 
  int x = 0;
  x = (3 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 3 dots ", dots[x]);
  x = (4 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 4 dots ", dots[x]);
  x = (5 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 5 dots ", dots[x]);
  x = (6 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 6 dots ", dots[x]);
  x = (7 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 7 dots ", dots[x]);
  x = (8 - ph_min) * 610/ (ph_max - ph_min);
  println (x, " 8 dots ", dots[x]);
  x = (9 - ph_min) * 610/ (ph_max - ph_min);
  println (x, "", 9 ," dots ", dots[x]);
  
  /*for (int ii =0; ii < 610; ii ++){
    println("dots[", ii ,"]", dots[ii]);
  }*/
}