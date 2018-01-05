//import processing.video.*; //<>// //<>// //<>// //<>//

//MovieMaker mm;  // Declare MovieMaker object

boolean DEBUG = true;
PrintWriter outputEpsilon, outputActivity;

float 

  Ax=120.0, Ay=235.0, 
  Bx=320.0, By=235.0, 
  J1x=420.0, J1y=70.0, 
  J2x=220.0, J2y=333.0, 
  E1x=121.0, E1y=404.0, 
  E2x=323.0, E2y=404.0, 
  E3x=121.0, E3y=485.0, 
  E4x=323.0, E4y=489.0;


boolean MODULATE=false;

float FixedActivity=0;

int SaveVideo=0;
int TimeLapse=150;
int tt=0;
int SaveMax=0;
int ShowOnlyMaxU=0;
int ExtinguishFlakes=1;
int sd=70;
int ShowGradient=0;
int REVERSE=0;
float distance_divider=4635.; // 3100 is good when REVERSE=0; for REVERSE=1 we use 4635.;

float activity=0, newactivity=0;

PImage b;
String name="black.png"; //"disc_150.png";
int ProcessImage=1;

int CENTRE=400;
int ni=300;
int nj=300;
int reactor_height = 300;
int reactor_width = 300;
int nmax=1000;
int simulation_tim=35000; 
int update_time=100;
int update_trajectory=0;
int offset=0;
float fi=0.0766;
int rad=5; //erase radius

int num_flakes=6;
int ai[], aj[];
int Flake[];
int C[][];

// so far the best A is 0.0011109
float A[][];  // =0.0011109;
float uMax[][];
float AA=0.0011109;

int s=3;
float dt=0.005; // dt=0.001 is original very good time step to dx=0.25
float dx=0.25;
float epsilon=0.024;//0.02;//0.022;  // 0.04 is OK dont change it 0.03 is better value, good value 0.003
float f=1.4;
float q=0.002;
float Du=1.0;
float Dv=0.0;
int writeppm=0;
int modulate=0;
int modulation_period=10;

float u[][], unew[][], v[][], vnew[][];
float lapse[][];

// electrical parameters
float[] R_pH_vec; 

float averageu=0;
int redcol, bluecol, greencol;
int blueSpikes, greenResistance;
float Reaction;

int i, j, z, sum, sumx, sumy, count;
float sign;
int ci, cj;
float  freqx=0, freqy=0;
int theta;
float maxu, maxv, minu, minv;
int bzLifeCycle_t=0;
void setup() 
{ 

  outputEpsilon = createWriter("epsilon.txt"); 
  outputActivity = createWriter("activity.txt");
  // 3 reactor layers 300*300
  size(300, 900);  


  colorMode(RGB, 255);
  //  x = new int[n+4][n+4]; 
  //  pixRGB = new byte[3];

  //  smooth();

  b = loadImage(name);
  if (SaveVideo==1) {
    // mm = new MovieMaker(this, width, height, "BZG"+str(hour())+str(minute())+str(second())+".mov",
    // 90, MovieMaker.H263, MovieMaker.HIGH);
  }

  v=new float[ni+100][nj+100];
  vnew=new float[ni+100][nj+100];
  u=new float[ni+100][nj+100];
  unew=new float[ni+100][nj+100];
  A = new float[ni+100][nj+100];
  lapse = new float[ni+100][nj+100];
  uMax=new float[ni+1][nj+1];

  C=new int[ni+100][nj+100];

  ai=new int[num_flakes+1];
  aj=new int[num_flakes+1];
  Flake = new int[num_flakes+1];

  R_pH_vec = parseFile(R_pH_file_name, x_max);

  frameRate(10);
  stroke(255); 

  // initialisation

  for (i=0; i<ni; i++)
    for (j=0; j<nj; j++)
    {
      //println(i+" "+j);
      u[i][j]=0.0; 
      unew[i][j]=0.0;
      v[i][j]=0.0; 
      vnew[i][j]=0.0;
      lapse[i][j]=0.0;
    }

  // prepare initial concentration

  for (i=0; i<=ni+1; i++)
    for (j=0; j<=nj+1; j++)
    {
      u[i][j]=q*(f+1)/(f-1);
      v[i][j]=q*(f+1)/(f-1);
      unew[i][j]=q*(f+1)/(f-1);
      vnew[i][j]=q*(f+1)/(f-1);
    } 

  //perturb(150,43); //p1
  // perturb(47, 47); // p1
  perturb(120, 10); // p3

  InitialisePANISegmentsStates();
  InitialiseMemristorsStates();

  image(b, 0, 0);
}


void FillC()
{
  color c;
  // image(b,0,0);
  for (i=0; i<=ni-1; i++)
    for (j=0; j<=nj-1; j++)
      //for(i=0;i<=200;i++)
      //for(j=0;j<=200;j++)
    {
      c=get(i, j); 
      if (red(c)<200) C[i][j]=1; 
      else C[i][j]=0;
      //if ((abs(i-100)<5)&&(abs(j-100)<5)) println(red(c)+","+blue(c)+","+green(c));
      //stroke(c); fill(c); 
      //point(i,j);
    }
}

void reset()
{
  // initialisation

  for (i=0; i<=ni+1; i++)
    for (j=0; j<=nj+1; j++)
    {
      u[i][j]=0.0; 
      unew[i][j]=0.0;
      v[i][j]=0.0; 
      vnew[i][j]=0.0;
    }

  // prepare initial concentration

  for (i=0; i<=ni+1; i++)
    for (j=0; j<=nj+1; j++)
    {
      u[i][j]=q*(f+1)/(f-1);
      v[i][j]=q*(f+1)/(f-1);
      unew[i][j]=q*(f+1)/(f-1);
      vnew[i][j]=q*(f+1)/(f-1);
    }
}

void perturb(int pci, int pcj)
{
  int ci, cj;

  if (pci < reactor_width && pcj < reactor_height) {
    ci=pci;
    cj=pcj;

    ci=pci; 
    cj=pcj;
    for (j=ci-10; j<=ci+10; j++)
    {
      u[j][cj]=1.0;
      u[j][cj+1]=1.0;
    }



    // also generate opposite particle

    //ci=ni-15; cj=nj/2+offset;
    //for(j=cj-10;j<=cj+10;j++)
    //  u[ci][j]=1.0;


    // generate big particle

    //  ci=ni-25; cj=nj/2+offset;
    // for(j=cj-5;j<=cj+5;j++)
    //   {u[ci][j]=1.0;ci++;}
  }
}


void perturb1(int pci, int pcj)
{
  int ci, cj;

  ci=pci;
  cj=pcj;


  if (pci < reactor_width && pcj < reactor_height) {
    ci=pci; 
    cj=pcj;
    for (j=ci-10; j<=ci+10; j++)
    {
      u[j][cj]=1.0;
      u[j][cj+1]=1.0;
    }

    ci=pci+1; 
    cj=pcj+1;
    for (j=ci-10; j<=ci+10; j++)
    {
      v[j][cj]=1.0;
      v[j][cj+1]=1.0;
    }
  }



  // also generate opposite particle

  //ci=ni-15; cj=nj/2+offset;
  //for(j=cj-10;j<=cj+10;j++)
  //  u[ci][j]=1.0;


  // generate big particle

  //  ci=ni-25; cj=nj/2+offset;
  // for(j=cj-5;j<=cj+5;j++)
  //   {u[ci][j]=1.0;ci++;}
}

void make_impurity()
{
  for (i=40; i<=45; i++)
    for (j=40; j<=45; j++)
    {
      u[i][j]=q*(f+1)/(f-1);
      v[i][j]=q*(f+1)/(f-1);
    }
}


Boolean LowExc(float cx, float cy, float x, float y, float R)
{
  Boolean vb=false;

  if (dist(cx, cy, x, y)<R) vb=true;
  return(vb);
}



void SaveLapse(int t)
{
  String fname;
  fname="";
  if (t<10) fname=fname+"0";
  if (t<100) fname=fname+"0";
  if (t<1000) fname=fname+"0";
  if (t<10000) fname=fname+"0"; 
  if (t<100000) fname=fname+"0"; 
  if (t<1000000) fname=fname+"0";
  if (t<10000000) fname=fname+"0";
  if (t<100000000) fname=fname+"0";
  fname=fname+str(t);
  save("sequence/"+fname+".png"); 
  //println(t);
}




void map()
{
  float Epsilon;
  averageu=0.0;
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
      if (C[i][j]==1)
      {
        Epsilon=epsilon;
        A[i][j]=AA;
        Reaction=(u[i][j]-u[i][j]*u[i][j]-(f*v[i][j]+fi+sign*A[i][j]/2.)*(u[i][j]-q)/(u[i][j]+q));

        unew[i][j]=u[i][j]+
          Du*(
          (dt/(dx*dx))*(u[i+1][j]-2*u[i][j]+u[i-1][j])+
          (dt/(dx*dx))*(u[i][j+1]-2*u[i][j]+u[i][j-1])
          ) +
          (dt/Epsilon)*Reaction;

        if (unew[i][j]<0.) unew[i][j]=0;

        vnew[i][j]=v[i][j]+dt*(u[i][j]-v[i][j])
          +Dv*(
          (dt/(dx*dx))*(v[i+1][j]-2*v[i][j]+v[i-1][j])+
          (dt/(dx*dx))*(v[i][j+1]-2*v[i][j]+v[i][j-1])
          );

        if (vnew[i][j]<0.) vnew[i][j]=0;

        averageu=averageu+u[i][j];
      }

  averageu=averageu/(1.0*ni*nj);
}

void Modulate()
{
  if (MODULATE)
  {
    if (activity>FixedActivity) epsilon=epsilon+0.0001;
    if (activity<FixedActivity) epsilon=epsilon-0.0001;
  }
  //println(newactivity);
  activity=newactivity;
}

/**
 Recalculates u - actuator and v - inhibitor. 
 */
void rewrite_and_concave()
{
  newactivity=0;
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++) 
    {
      u[i][j]=unew[i][j];
      v[i][j]=vnew[i][j];
      if (u[i][j]>0.1) newactivity=newactivity+u[i][j]; //u[i][j];
    }


  Modulate();
  // println(activity);
  //  for(i=0;i<=ni+1;i++) {u[i][0]=u[i][nj];v[i][0]=v[i][nj];u[i][nj+1]=u[i][1];v[i][nj+1]=v[i][1];}
  //  for(j=0;j<=nj+1;j++) {u[0][j]=u[ni][j];v[0][j]=v[ni][j];u[ni+1][j]=u[1][j];v[ni+1][j]=v[1][j];}
}

/**
 Calculates pH based on u (activation).
 @param u - the float BZ activation parameter
 
 */
float pH(float u) {
  float res = 8 + 2*u;
  return res;
}


/**
 Drawing BZ reaction on the screen.
 */
void drawbz()
{
  //background(b); 
  background(0);
  
  // separator
  stroke(102, 204, 102);
  line(0, 300, 300, 300);
  line(0, 600, 300, 600);

  // image(b,0,0);
  for (i=1; i<=ni; i++)
  {
    for (j=1; j<=nj; j++)
    {
      if (SaveVideo==0)
      { 
        if ((u[i][j]>0.1)||(v[i][j]>0.1))  // 0.1 threshold are good values for both u and v
        {
          redcol=ceil(u[i][j]*255.); 
          if (redcol>255) redcol=255;
          bluecol=ceil(v[i][j]*600.); 
          if (bluecol>255) bluecol=255;
          // PlotDotAt(hDC,i,j,RGB(redcol,0,bluecol));
          //if ((redcol<=40)&&(bluecol<=100)) {redcol=255;greencol=255;bluecol=255;}
          stroke(redcol, greencol, bluecol);
          point(i, j);
          // Resistance of polyaniline matrix segment
          R_pani[i][j] = R_pH(pH(u[i][j]), R_pH_vec);
        
          /*redcol = ceil(R_pani[i][j]/(r_max - r_min)*255);
          stroke(redcol, greencol, 0);
          point(i, j+300);*/
        }
      } else 
      {
        redcol=ceil(u[i][j]*255.); 
        if (redcol>255) redcol=255;
        bluecol=ceil(v[i][j]*600.); 
        if (bluecol>255) bluecol=255;
        // PlotDotAt(hDC,i,j,RGB(redcol,0,bluecol));
        //if ((redcol<=40)&&(bluecol<=100)) {redcol=255;greencol=255;bluecol=255;}
        stroke(redcol, greencol, bluecol);
        point(i, j);
      }

      //TODO add Resistance here
      // Spikes
      blueSpikes = NumFired[i-1][j-1]*255;
      stroke(0, greencol, blueSpikes);
      point(i, j+300);
      // Total resistance
      int resistColor_pani=ceil((R_pani[i-1][j-1])/(R_pani_max - R_pani_min)*255);
      int resistColor_mem= ceil((R_mem[i-1][j-1]-R_mem_min)/(R_mem_max - R_mem_min)*255);
      stroke(0, resistColor_pani, 0);
      point(i, j+600);
      stroke(0,0, resistColor_mem);
      point(i, j+640);
      
      println ("Debug: [", i ,";", j, "] u=", u[i][j], " pH=", pH(u[i][j]) ," R_pani=", R_pani[i-1][j-1], "R_mem=", R_mem[i-1][j-1]);
    }
  }
  // stroke(0,255,0);  strokeWeight(4); noFill(); ellipse(250,236,80,80);
 
}

void develop()
{
  sign=-1.0;
  //if ((fmod(t,modulation_period)==0)&&(modulate==1)) sign=-1.0*sign;
  map();
  rewrite_and_concave();
}



void mousePressed()
{
  int rad=5; 
  int ssi; 
  int ssj; 
  int zi; 
  int zj; 
  color cc;
  if (mousePressed&&(mouseButton == LEFT)) 
  {
    //   stroke(255,0,0);
    // point(mouseX,mouseY);

    //ssi=mouseX; 
    //ssj=mouseY;  
    //cc=get(ssi, ssj);
    //println(red(cc)+","+green(cc)+","+blue(cc)+","+ssi+","+ssj);   
    //  u[ssi][ssj]=1.0;

    perturb1(mouseX, mouseY);
  } 

  if (mousePressed&&(mouseButton == RIGHT))
  {
    perturb(mouseX, mouseY);
  }
} 

void DrawC()
{
  //background(0,0,255);
  for (i=0; i<=ni-1; i++) 
    for (j=0; j<=nj-1; j++)
    {
      if (C[i][j]==1) stroke(255, 0, 0); 
      else stroke(0, 255, 0);
      point(i, j);
    }
}

void keyPressed()
{
  if ((key=='r')||(key=='R')) reset();

  if (key=='1') {
    epsilon=epsilon-0.001; 
    println(epsilon);
  }
  if (key=='2') {
    epsilon=epsilon+0.001;
    println(epsilon);
  }

  if (key == 'q') {
    //if (SaveVideo==1) mm.finish();
  }

  if (key=='c') DrawC(); 

  if (key=='m') {
    MODULATE=true;
    println("MODULATING"); 
    FixedActivity=activity;
  }

  if (key=='w')
  {
    ShowTimeLapse();
    saveFrame("lapse.jpg");
    exit();
  } 

  if (key=='s') 
  {
    saveFrame("f_t_"+str(tt)+"___"+str(hour())+str(minute())+str(second())+".png");
  }

  if (key=='g')
  {
    if (ShowGradient==0) ShowGradient=1; 
    else ShowGradient=0;
  }

  if (key=='x')
  {
    outputEpsilon.flush(); 
    outputEpsilon.close(); 
    outputActivity.flush(); 
    outputActivity.close();
  }
}

void ShowTimeLapse()
{
  //background(b);
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      redcol=ceil(lapse[i][j]*255.); 
      if (redcol>255) redcol=255;
      if (redcol<10) stroke(redcol, 255, 255); 
      else stroke(redcol, 0, 0);  
      if (C[i][j]==0) stroke(255, 255, 255);
      point(i, j);
    } 
  // drawFlakes();
}


void ShowTimeLapseBinary()
{
  //background(b);
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      // redcol=ceil(lapse[i][j]*255.); if (redcol>255) redcol=255;

      if (lapse[i][j]>0.1) redcol=255; 
      else redcol=0;
      stroke(redcol);
      point(i, j);
    } 
  // drawFlakes();
}


void SaveLapse()
{
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
      if (lapse[i][j]==0)
      {
        if (u[i][j]>0.1) lapse[i][j]=u[i][j];
      }
}


void ShowMaxU()
{
  float MaxU=0;
  //background(b); 
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      if (MaxU<u[i][j]) MaxU=u[i][j];
    } 

  stroke(255, 0, 0);
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      if (abs(u[i][j]-MaxU)<0.1) point(i, j);
    }
}


void SaveMaxU()
{
  float mU=0.; 
  float MU=0.;   
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      uMax[i][j]=0.;
      if (u[i][j]>0.1) 
      {
        for (int zi=-1; zi<=1; zi++)
          for (int zj=-1; zj<=1; zj++)
          {
            uMax[i][j]=uMax[i][j]+u[i][j];
          }
        uMax[i][j]=uMax[i][j]/8.;
      }
    }

  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      if (MU<uMax[i][j])MU=uMax[i][j];
    }
}

void ShowMax()
{
  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      redcol=ceil(uMax[i][j]*1000.); 
      if (redcol>255) redcol=255;
      stroke(redcol, 0, 0);
      point(i, j);
      // if (uMax[i][j]>0) println(uMax[i][j]);
    }
}

void UpdateFlakes()
{
  float DD;
  for (z=1; z<=num_flakes; z++)
  {
    if (u[ai[z]][aj[z]]>0.1) {
      Flake[z]=0;
    }
  }  

  int OUT=1;

  for (z=1; z<=num_flakes; z++) {
    if (Flake[z]==1) OUT=0;
  }

  if (OUT==1)
  { 

    ShowTimeLapse();
    saveFrame("lapse"+str(hour())+str(minute())+str(second())+".png");

    ShowTimeLapseBinary();
    saveFrame("lapBin"+str(hour())+str(minute())+str(second())+".png");

    // if (SaveVideo==1) mm.finish();
    exit();
  }

  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {

      // float mindistance=dist(i,j,ai[1],aj[1]);
      float mindistance=320000;  
      for (z=1; z<=num_flakes; z++)

      {
        if (Flake[z]==1) DD=dist(i, j, ai[z], aj[z]); 
        else DD=3200000;    


        if (DD<mindistance)
        { 
          mindistance=  DD;
        }   


        // A[i][j]=0.02-mindistance/2990.;  // 2990. good value when two first flakes are at the same level

        A[i][j]=0.02-mindistance/distance_divider;
      }
    }


  if ((REVERSE==1)&&(Flake[4]==0)) distance_divider=3007.000123;
}

void drawGradient()
{
  float maxD=0.;
  float sD=0.0;

  for (i=5; i<=ni-5; i++)
    for (j=5; j<=nj-5; j++)
    {
      if (A[i][j]>maxD) maxD=1.0000*A[i][j];
    }  

  for (i=1; i<=ni; i++)
    for (j=1; j<=nj; j++)
    {
      stroke(255.-255.*A[i][j]/maxD);
      point(i, j);
    }
}
//main cycle
void draw()
{

  if (ProcessImage==1) {  
    image(b, 0, 0); 

    FillC(); 
    ProcessImage=0;
  }
  if (ProcessImage==2) {
    ProcessImage=2; 
    DrawC();
  } else 
  {
    tt++;
   // t=tt;// /0.45;
    //use  millis from the program start.
    //t=  millis()/1000;
    println("Cycle:"+tt);
    ////////////////////////////
    ///// BZ once a 450
    ////////////////////////////
    
    int globalShift=450;//shift for the Time to reduce frame rate affect and speed up simulation, used to divided IZ neurons and BZ reaction
    
    int bzOffset=450/globalShift;
    if ((SaveMax==0)&&(ShowOnlyMaxU==0)&&(ShowGradient==0)
    && tt%bzOffset==0) 
    {
      println("DrawBZ:"+bzLifeCycle_t);
      drawbz(); //bz reaction 450 ms, matrix inhibition+excausted
      develop(); //calculate matrix develop(); //calculate matrix
      //BZ cycle
      bzLifeCycle_t++;
    }
    // if (ShowGradient==1) drawGradient();
    // if (ShowOnlyMaxU==1) ShowMaxU();
    // drawFlakes();
    
    /////////////////////////////
    ///// Neuronal spikes once a 1 ms
    ////////////////////////////
   
    //1 ms
    for (int nSpike=1; nSpike<=globalShift; nSpike++)
     {
      neuronal_life_cycle();
      memristors_life_cycle();
     }
    ///////////////////////////
    ///// Image processing
    if (tt%10==0) SaveLapse(tt);
    ///////////////////////////
    //outputEpsilon.println(epsilon);
    //outputActivity.println(activity);

    // if (SaveVideo==1) mm.addFrame(); 
    if (tt%TimeLapse==0) SaveLapse();
    if (SaveMax==1) {
      SaveMaxU();
      ShowMax();
    }
    //if (ExtinguishFlakes==1) {UpdateFlakes();}
  }
}