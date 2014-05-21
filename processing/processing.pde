import processing.serial.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       waveA, waveB, waveC, waveD;
PFont       data, title;
PShape      herb, hs, sensor;
PImage      uj, krakow, hspng, mol;
Serial      myPort;

int SIZE = 5;
int FACTOR = -5;

boolean DEBUG = false;

int[] a = new int[SIZE];
int[] b = new int[SIZE];
int[] c = new int[SIZE];
int[] d = new int[SIZE];
color red = #FF0000;
color white = #FFFFFF;

float frequencies[] = {261.6, 293.7, 329.2, 350.6};

void put(int array[], int size, int val)
{
  if(val < 500)
  {
   for(int i = size-2; i>=0; i--)
   {
     array[i+1] = array[i];
   }
   array[0] = val;
  }
}

float avg(int array[], int size)
{
  float acc = 0;
  for(int i = 0; i < size; i++)
  {
    acc = acc + array[i];
  }
  return acc/size;
}

void drawColumn(int array[], int size, int index)
{
  colorMode(HSB,100);
  textFont(data);
  float value = avg(array,SIZE);
  color col = color(2*value, 100, 100);
  color prostokat;
  if(value < 60)
  {
    fill(col);
    rect(60*index, height-50, 30, value*(FACTOR));
  }
  else
  {
    fill(col);
    rect(60*index, height-50, 30, 60*FACTOR);
    fill(0,0,0);
    text("N/a", 60*index, height-20);
  }
  fill(0,0,0);
  text(value+" cm", 60*index, height-30);

  

}

float makeAmplitude(int array[], int size)
{
  float value = avg(array,SIZE);
  if(value < 60)
  {
    return (60 - value) / 60;
  }
  else return 0;
}

void drawStuff()
{
   shape(herb, 20, 5, 100,100);
   shape(hs, 880,5,100,100);
   textFont(title);
   text("Elektroniczna harfa ultradźwiękowa.\nFestiwal Nauki 2014", 120, 50);
   
   shape(sensor, 400, height-120, 100, 100);
   text("A", 440, height-20);
   shape(sensor, 550, height-120, 100, 100);
   text("B", 590, height-20);
   shape(sensor, 700, height-120, 100, 100);
   text("C", 740, height-20);
   shape(sensor, 850, height-120, 100, 100);
   text("D", 890, height-20);
}

void setup()
{
  size(1000, 600);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  colorMode(HSB,100);
  minim = new Minim(this);
  out = minim.getLineOut();
  
  waveA = new Oscil( frequencies[0], 0f, Waves.SINE );
  waveB = new Oscil( frequencies[1], 0f, Waves.SINE );
  waveC = new Oscil( frequencies[2], 0f, Waves.SINE );
  waveD = new Oscil( frequencies[3], 0f, Waves.SINE );
  
  waveA.patch( out );
  waveB.patch( out );
  waveC.patch( out );
  waveD.patch( out );
  
  data = createFont("Cantarell-Regular-15", 10);
  title = createFont("Carlito-Italic-25", 25);
  herb = loadShape("herb.svg");
  hs = loadShape("avatar.svg");
  sensor = loadShape("sensor.svg");
  uj = loadImage("logo.png");
  krakow = loadImage("krakow.png");
  hspng = loadImage("avatar.png");
  mol = loadImage("mol.jpg");
  
}

void draw()
{
  if(DEBUG){
  text(mouseX+" x "+mouseY, 20, 20);
  }
  if ( myPort.available() > 0) { // If data is available,
   String myString = myPort.readStringUntil('\n');
   if(myString != null)
   {
    int data [] = int(split(myString, '\t'));
    if (data.length == 5)
    {
      put(a, SIZE, data[0]);
      put(b, SIZE, data[1]);
      put(c, SIZE, data[2]);
      put(d, SIZE, data[3]);
//    println(data[0]+", "+data[1]+", "+data[2]+", "+data[3]);
    }

   background(white);
   drawStuff();

   drawColumn(a,SIZE,1);
   drawColumn(b,SIZE,2);
   drawColumn(c,SIZE,3);
   drawColumn(d,SIZE,4);
   
   waveA.setAmplitude( makeAmplitude(a,SIZE) );
   waveB.setAmplitude( makeAmplitude(b,SIZE) );
   waveC.setAmplitude( makeAmplitude(c,SIZE) );
   waveD.setAmplitude( makeAmplitude(d,SIZE) );
   
   tint(100,0,100,100-100*(avg(a,SIZE)/60));
   image(uj,400,340-(avg(a,SIZE)),100,145.7);
   tint(100,0,100,100-100*(avg(b,SIZE)/60));
   image(krakow,550,330-(avg(b,SIZE)),100,154);
   tint(100,0,100,100-100*(avg(c,SIZE)/60));
   image(hspng,700,330-(avg(c,SIZE)),100,100);
   tint(100,0,100,100-100*(avg(d,SIZE)/60));
   image(mol,850,330-(avg(d,SIZE)),100,138.9);
   
   }
  }
}