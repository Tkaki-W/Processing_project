void OK(){
  println("実行されました");
  println("OK set "+heimon_checker);
      for(int i = 0;i<amount;i++){//amountの分だけsumiの横幅を生成
       sumi.add(0);
      }
      for(int i =0;i<amount;i++){
       img1 = img.get( 0,0,sumi.get(i), 200 );//どのくらいスライドするか定義
       image( img1, 0, 200*i);//イメージを別の場所に配置
  }
  println("sumi_size"+sumi.size());
  player.play();
  cp5.remove("OK");//閉門を消す
  
  for(int i =0; i<amount;i++){
  cp5.remove("button"+String.valueOf(i));//削除ボタンをいったん消す
  }
  for(int i=0;i<amount;i++){  //削除ボタンの代わりに完了ボタン
  cp5.addBang("done"+String.valueOf(i))
     .setPosition(1600,180+100*i)
     .setSize(80,60)
     .setColorCaptionLabel(#ff0000)
     .setColorActive(color(80,80,80))      // ボタン色
     .setColorForeground(color(0,0,0))   // マウスホバー中
     .setCaptionLabel("完了")
     .getCaptionLabel()
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
     
  }
  cp5.remove("enter");
  jt1.setBounds(900, 60, 0, 0);
  sec = (int)sec_slider.getValue();
  min = (int)min_slider.getValue();
  hour = (int)hour_slider.getValue();
  cp5.remove("sec");
  cp5.remove("min");
  cp5.remove("hour"); 
  
  //画面遷移後に写真表示
  background(bg1);
  int image_timer = millis();
  while(millis() - image_timer < 5000){ 
  image(img2,900,600);
  }
  heimon_checker = 1;//閉門開門の間のとき
}
