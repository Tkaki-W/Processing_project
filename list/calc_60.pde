int pass_sec;
int pass_min;
int pass_hour;


void calc_60(){
   pass_hour = (int)hour_slider.getValue()-final_hour;
  //もし分の位で引いた値が0以下になっていたら
   if((int)min_slider.getValue()-final_min<0){
     pass_min = 60+(int)min_slider.getValue()-final_min;
     pass_hour--;
   }else{
     pass_min=(int)min_slider.getValue()-final_min;
   }
  //もし秒の位で引いた値が0以下になっていたら
   if(((int)sec_slider.getValue()-final_sec)<0){
     //秒の位に分の位から切り落としたのを送る
     pass_sec = 60+(int)sec_slider.getValue()-final_sec;
     pass_min--;
   }else{
     pass_sec =(int)sec_slider.getValue()-final_sec;
   }
}
