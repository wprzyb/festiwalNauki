
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int a;
int b;
int c;
int d;

void setup() 
{
  size(1000, 500);
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw()
{
  if ( myPort.available() > 0) {  // If data is available,
   String myString = myPort.readStringUntil('\n');
   if(myString != null)
   {
    int data [] = int(split(myString, '\t'));
    if (data.length == 4) {
    a = data[0];
    b = data[1];
    c = data[2];
    d = data[3];
    
    }
    print(a+","+b+","+c+","+d+"\n");
    //rect(10,10,10,5*a);
   }
  }
}


