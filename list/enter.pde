void enter() {//ボタンが押されたとき
    input = jt1.getText();
    jt1.setText("");
    element.add(input);
    amount++;
 for(int i=0;i<amount;i++){  //setup drawの外でbuttonNを生成してパブリック変数にした！
  cp5.addBang("button"+String.valueOf(i))
     .setPosition(1600,180+100*i)
     .setSize(80,60)
     .setColorCaptionLabel(#ff0000)
     .setColorActive(color(80,80,80))      // ボタン色
     .setColorForeground(color(0,0,0))   // マウスホバー中
     .setCaptionLabel("削除")
     .getCaptionLabel()
     .align(ControlP5.CENTER, ControlP5.CENTER)
     ;
  }
}
