PImage img;  // Declare a variable of type PImage

color black = color(0, 0, 0);
int r_min = 20;
int r_max = 120;
int pH_min = 2;
int ph_max = 10;

//https://processing.org/reference/loadPixels_.html
//https://processing.org/tutorials/pixels/

void setup() {
  size(610,281);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("R_pH_trunk.png");
  
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
  image(img,0,0);

  int halfImage = width*height/2;
  int image = width*height;
  loadPixels();
  for (int j = 0; j < height; j++) {
    for (int i = 0; i < width; i++) {
      // println (i, " ; " ,j, "is " , pixels[i + j*width]);
      if (pixels[i + j*width] == black){
        println (i, " ; " ,j, "is ", pixels[i + j*width]);
      }
    }
  } 
}