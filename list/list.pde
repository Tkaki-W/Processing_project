import javax.swing.*;
import java.awt.*;
import controlP5.*;
import java.util.ArrayList;
import ddf.minim.*;
import processing.serial.*;
 
Serial port;
Minim minim;
AudioPlayer player;
AudioPlayer player1;
AudioPlayer player2;
ControlP5 cp5;
JLayeredPane pane;
JTextField jt1;
String input = "";
ArrayList<String> element = new ArrayList<>();
ArrayList<String> button = new ArrayList<>();
ArrayList<Integer> sumi = new ArrayList<>();//墨の横幅のイメージ
int amount = 0;
int sumi_number = -1;
int heimon_checker =0;// 開門時0 閉門時1 完了時2 タイムアップ時3 
int page_width = 2200;
int page_height = 1400;
int sumi_count=0;
int image_count = 0;//写真の表示回数
int sumi_width=0;
int serial=0;//受け取った値を入れる
float x, y;//長方形の座標
float done_persent;
String done_persent_amend ;

PImage bg;//バックグラウンドイメージのインスタンスを作成
PImage bg1;
PImage bg2;//無量空処
PImage bg3;//舞台の壁紙
PImage  img;//墨の全容
PImage  img1;//墨の一部を表示
PImage  img2;//閉門
PImage  img3;//なんて奴
PImage  img4;//タスク　完
PImage  img5;
PImage  img6;
Slider hour_slider;//sliderのインスタンス作成
Slider min_slider;
Slider sec_slider;

void setup() {
  //シリアル通信の設定
  //  port = new Serial(this, "COM4", 9600);
  //processingの表示側の設定
  PFont font = createFont("HGP行書体", 40);
  textFont(font);
  size(2200,1400);
  surface.setLocation(-10,0);
  /*PFont font = createFont("arial",12);
  textFont(font);*/
  cp5 = new ControlP5(this);//インスタンスの生成
  minim = new Minim(this);//インスタンスの生成
  ControlFont cf1 = new ControlFont(font,30);//controlp5による文字の設定
  cp5.setFont(cf1);
  
  java.awt.Canvas canvas =
            (java.awt.Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();

  jt1 = new JTextField();
  jt1.setBounds(900, 60, 400, 60);//テキストフィールドを設定
  jt1.setFont(new Font("ＭＳ ゴシック", Font.BOLD, 30));//テキストフィールド内の文字の設定
  jt1.setForeground(Color.yellow);//テキストフィールドの文字の色
  jt1.setBackground(Color.black);//テキストフィールドの背景色
  jt1.setCaretColor(Color.yellow);//キャレット(ちかちかするやつ)の色
  pane.add(jt1);
    
  cp5.addBang("enter",1350,70,80,40)//ボタンを押されるとenter関数が実行
     .setCaptionLabel("入力")
     .getCaptionLabel()
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  cp5.addBang("OK")
     .setPosition(900,1200)
     .setSize(402,142)
     .setColorCaptionLabel(#ff0000)
     .setColorActive(color(80,80,80,127))      // マウスホバー中
     .setColorForeground(color(255,255,255,130))   // 背景色
     .setCaptionLabel("")
     .getCaptionLabel()
     .setSize(70)
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  rectMode(CENTER);   
  hour_slider= cp5.addSlider("hour")
              .setRange(0, 12)//どのくらいスライドできるか
              .setValue(6)
              .setPosition(10, 50)
              .setSize(60, 600)
              .setDecimalPrecision(0)
              .setNumberOfTickMarks(13)
              ;
             cp5.getController("hour")
               .getValueLabel()
               .setVisible(false)//値非表示
                ;
  min_slider = cp5.addSlider("min")
              .setRange(0, 59)
              .setValue(30)
              .setPosition(150, 50)
              .setSize(60, 600)
              .setDecimalPrecision(0)
              .setNumberOfTickMarks(60)
              ; 
                cp5.getController("min")
               .getValueLabel()
               .setVisible(false)//値非表示
                ;         
  sec_slider = cp5.addSlider("sec")
              .setRange(0, 59)
              .setValue(30)
              .setPosition(290, 50)
              .setSize(60, 600)
              .setDecimalPrecision(0)
              .setNumberOfTickMarks(60)
              ; 
                 cp5.getController("sec")
               .getValueLabel()
               .setVisible(false)//値非表示
                ;
     
  player = minim.loadFile("../audio_list/heimon.mp3");
  player1 = minim.loadFile("../audio_list/huuinnkannryou.mp3");
  player2 = minim.loadFile("../audio_list/ostukare.mp3");
  
  bg = loadImage("../picture/jujustu(1).jpg");//背景写真
  bg.resize( page_width, page_height);//拡大縮小で写真をwindowに合わせる
  bg1 = loadImage("../picture/gokumon_inside(amend).png");
  bg1.resize(page_width,page_height);
  bg2 = loadImage("../picture/muryoukuusho.jpg");
  bg2.resize(page_width,page_height);
  bg3 = loadImage("../picture/jujustu_timeup.jpg");
  bg3.resize(page_width,page_height);
  img = loadImage("sumi_negate.png");//墨のイメージをインポート
  img2 = loadImage("heimon.png");
  img3 = loadImage("nannteyastu.jpg");
  img4 = loadImage("tasuku_kan_white.png");
  img5 = loadImage("sumi.png");
  img5.resize(1500,100);
  img6 = loadImage("huuinnkannryou.jpg");
  //長方形の初期位置
   x = -2200;
   y = 0;
}

void draw() {
  //background(80);
  if(heimon_checker == 0){
  background(bg);
  }
  if(heimon_checker == 1){
    background(bg1);
  }
  if(heimon_checker==1 || heimon_checker==0){
  fill(255);
  for(int i=0;i<amount;i++){
    text(String.valueOf(i+1),500,200+100*i);
    text(element.get(i) ,700,200+100*i);//受け取ったテキストの表示
  }
  }
  if(heimon_checker == 0){
     // port.write('b');//開けておく
    image(img2 ,900,1200);
    fill(0, 0, 0);
    text("設定時間",40,800);
     fill(255, 255, 0);
    text((int)hour_slider.getValue(),40,900);
    text(":",100,900);
    text((int)min_slider.getValue(),155,900);
    text(":",210,900);    
    text((int)sec_slider.getValue(),265,900);
  }

  if(heimon_checker == 1){
       //port.write('a');//閉めておく
       //墨ですべて完了になったらheimon_checkerを2
    if(sumi_count == amount){
      //墨を引き終わるまで待つ
     if(sumi.get(sumi_number)==600){
       heimon_checker = 2;
       //残った時間を記録
       final_sec = sec;
       final_min = min;
       final_hour = hour;
       calc_60();
       player2.play();
     }
      for(int i =0; i<amount;i++){
        cp5.remove("done"+String.valueOf(i));//完了ボタンを消す
      }
      
    }
    sumi_maker();//墨を引く関数 
    clock();
    fill(255,255,255);
    text("封印完了迄",100,50);
    fill(255,255,0);
    text(hour+":"+min+"："+sec,100,100);

  }
  if(heimon_checker == 2){
    if(width<x){
      port.write('b');//開けておく
      background(bg2);
      fill(0,0,0);
      textSize(50);
      text("経過時間",100,50);
      text(pass_hour+":"+pass_min+"："+pass_sec,100,100);//所要時間を表示
      //画面遷移後に写真表示
      img3.resize(375,206);
      image(img3,950,900);
      //image(img4,500,500);
      textSize(200);
      text("タスク完了",600,700);
      image( img5, 500,800);//イメージを別の場所に配置
    } 
     x += 50;
    fill(10,10,10);
    rect(x, y, 2200, 4000);
  }
  if(heimon_checker == 3){
    if(width<x){
      background(bg3);
      fill(200,0,150);
      textSize(50);
      text("タスク遂行割合",100,50);
      done_persent = (float)sumi_count/amount*100;
      //小数点1位以下切り捨て
      done_persent_amend = String.format("%.1f", done_persent);
      text(done_persent_amend,100,100);//タスクの遂行割合を表示
      //画面遷移後に写真表示
      img6.resize(254,216);
      image(img6,950,900);
      //image(img4,500,500);
      fill(200,0,150);
      text("5分後に解放",100,200);
      textSize(200);
      fill(200,0,150);
      text("封印完了",600,700);
      img.resize(1500,100);
      image( img, 500,800);//イメージを別の場所に配置
     if(4*width<x){
      delay(300000);
      port.write('b');//開けておく
     }
    }

     x += 50;
    fill(10,10,10);
    rect(x, y, 2200, 4000);    
    }
}


 void controlEvent(ControlEvent theEvent) {//削除ボタンに反応
  for(int i=0;i<amount;i++){
  if (theEvent.isController()) {
    if (theEvent.getController().getName().equals("button"+String.valueOf(i))) {
      println(String.valueOf(i));
      element.remove(i);
      amount=amount-1;
      cp5.remove("button"+String.valueOf(amount));//deleteボタンを消す
      }
   }
  if (theEvent.isController()) {
    if (theEvent.getController().getName().equals("done"+String.valueOf(i))) {
      sumi_number = i;//draw関数に値を返す
      println("sumi_number is"+String.valueOf(sumi_number));
      background(0,0,100);
      sumi_count++;
      cp5.remove("done"+String.valueOf(i));//doneボタンを消す
      println(sumi_count);
    }
  }
}
}
