PImage img;  // Declare a variable of type PImage

//https://processing.org/reference/loadPixels_.html
//https://processing.org/tutorials/pixels/

void setup() {
  size(776,465);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("R_ph_Memristor.png");
  int halfImage = width*height/2;
  loadPixels();
  for (int i = 0; i < halfImage; i++) {
    pixels[i+halfImage] = pixels[i];
  } 
  updatePixels();
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
  image(img,0,0);
  
}