void sumi_maker(){   
    for(int i =0;i<amount;i++){
       img1 = img.get( 0,0,sumi.get(i), 200 );//どのくらいスライドするか定義をsumi(i)を参考にしまくる
       image( img1, 700, 150+100*i);//イメージを別の場所に配置
    }
    for(int i = 0;i<amount;i++){
    if(sumi_number == i){
      if(sumi.get(i) <= 600 ){
        sumi.set(i,sumi.get(i)+20);//sumiを動かす//クリックしたら指定したのが動く
      } 
      }
    }
}    
