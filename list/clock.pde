int sec;
int min;
int hour;
int ms = -1;
int final_sec;
int final_min;
int final_hour;

void clock(){
   if(millis()-ms >= 1000){
  if(sec >=1){
    sec = sec-1;//secが0以上のときは1引く
  }else{
    sec = 59;
    if(min >=1){
      min = min-1;
    }else{
      min = 59;
      if(hour >=1){
        hour = hour-1;
      }
    }
  }
    println(hour+":"+min+"："+sec);
    if(hour ==0 && min ==0 && sec==0){
      heimon_checker = 3;//タイムアップ
       for(int i =0; i<amount;i++){
        cp5.remove("done"+String.valueOf(i));//完了ボタンを消す
      }
      player1.play();
    }
    ms = millis();//時間を進めたらmsもカウント
   }
  }

//やっぱり割り込みをしないときつそう
//millisを使って前時計を動かしてから1秒以上たったらサイド動かすというプログラムにして割り込み問題解決かも
