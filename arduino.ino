/* HC-SR04 Sensor
   https://www.dealextreme.com/p/hc-sr04-ultrasonic-sensor-distance-measuring-module-133696
  
   This sketch reads a HC-SR04 ultrasonic rangefinder and returns the
   distance to the closest object in range. To do this, it sends a pulse
   to the sensor to initiate a reading, then listens for a pulse 
   to return.  The length of the returning pulse is proportional to 
   the distance of the object from the sensor.
     
   The circuit:
	* VCC connection of the sensor attached to +5V
	* GND connection of the sensor attached to ground
	* TRIG connection of the sensor attached to digital pin 2
	* ECHO connection of the sensor attached to digital pin 4


   Original code for Ping))) example was created by David A. Mellis
   Adapted for HC-SR04 by Tautvidas Sipavicius

   This example code is in the public domain.
 */

const int echoPin[] = {2,4,6,8} ;
const int trigPin[] = {3,5,7,9};
int i;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
}

void loop()
{
  long duration[4], inches[4], cm[4];

for (i = 0 ; i < 4 ; i++ )
{
  pinMode(trigPin[i], OUTPUT);
  digitalWrite(trigPin[i], LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin[i], HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin[i], LOW);
  pinMode(echoPin[i], INPUT);
  duration[i] = pulseIn(echoPin[i], HIGH);
  inches[i] = microsecondsToInches(duration[i]);
  cm[i] = microsecondsToCentimeters(duration[i]);
//  Serial.print(i+1);
//  Serial.print(": ");
  Serial.print(cm[i]);
  Serial.print("\t");
  delay(10);
}

  Serial.println();
  delay(1);
}

long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
