#include <Servo.h>
#define n 20    

//int switch_pin = 13;
int present_checker = 7;
//int on_off;
//int switch_status = 1;
//int LED_status = 0;//LEDの状態。最初は消灯している
int pin_trigger=12; 
int pin_echo=11;

float distance;
int f[n]={0};                            
float ave = 0; 

int servo_pin=9;
Servo myservo;
void setup()
{
    Serial.begin(9600);
    pinMode(LED_BUILTIN, OUTPUT);
    myservo.attach(servo_pin);
    myservo.write(15);
    pinMode(pin_trigger,OUTPUT);
    pinMode(pin_echo,INPUT);
//    pinMode(switch_pin,INPUT_PULLUP);
    pinMode(present_checker,OUTPUT);
 
}
 
void loop()
{
  servo_set(); 
  supersonic();
}

void servo_set(){
if(Serial.available() > 0){
          char servo_state = Serial.read();
            //押されたとき
            if(servo_state == 'a'){
              myservo.write(15);
              digitalWrite(LED_BUILTIN,HIGH);
              delay(100);
            }
            //押さないとき
            if(servo_state == 'b'){
              myservo.write(90);
              digitalWrite(LED_BUILTIN, LOW);
              delay(100);
            }
          }
}

/*void switch_function(){
   if (digitalRead(switch_pin) != switch_status && digitalRead(switch_pin) == 0){//スイッチの状態が変わった,かつスイッチが押されている状態
      if (LED_status == 0){
      digitalWrite(present_checker,HIGH);
      LED_status = 1;
    }else if (LED_status == 1){
      digitalWrite(present_checker,LOW);
      LED_status = 0;
  }
}
switch_status = digitalRead(switch_pin);//8ピンの状態を変数に保存
delay(100);
}
*/
void supersonic(){
  //超音波センサゾーン
  digitalWrite(pin_trigger,LOW);
 delayMicroseconds(5);
 digitalWrite(pin_trigger,HIGH);
 delayMicroseconds(10);
 digitalWrite(pin_trigger,LOW);  
distance=pulseIn(pin_echo,HIGH);
 distance = distance / 58;
 if(distance >=400){
  distance = 400;
 }
 Serial.print ("Distance = ");
//
 Serial.print (distance);
 Serial.println (" cm");
 
//ここからフィルタリング
 for(int i=n-1;i>0;i--){
 f[i] = f[i-1];                           
}
 f[0] = distance;
 ave = 0;
 //標本数を決める
//データ保管用の配列
//平均値を入れる変数
//9600bpsでシリアルポートを開く
//過去１０回分の値を記録
for(int i=0;i<n;i++) ave += f[i];        
ave = (float)ave/n;                  
//総和を求める
//標本数で割って平均を求める
 //フィルタ前の値
//Serial.print(f[0]);                  
//Serial.print(",");
//フィルタ後の値
Serial.print(ave);                   
Serial.print("\n");

if(ave >= 200){
  Serial.println("離席中");
  digitalWrite(present_checker , LOW);
}else{
 Serial.println("着席中");
  digitalWrite(present_checker , HIGH);
}
}
