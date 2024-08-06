package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class ContestRewardsStripes extends ESpriteContainer
   {
      
      private static const BACKGROUND:String = "background";
      
      private static const RANK:String = "amount";
      
      private static const REWARD:String = "reward";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mContainersCount:int;
      
      private var mRewardRaw:String;
      
      public function ContestRewardsStripes(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
      }
      
      public function setup(rewardRaw:String, rank:String, textureName:String = null) : void
      {
         var i:int = 0;
         var container:ESpriteContainer = null;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("StripeContestRewards");
         if(textureName == null)
         {
            textureName = "stripe";
         }
         this.mRewardRaw = rewardRaw;
         var img:EImage = this.mViewFactory.getEImage(textureName,this.mSkinSku,false,layoutFactory.getArea("stripe"));
         eAddChild(img);
         setContent("background",img);
         setLayoutArea(layoutFactory.getArea("stripe"));
         var field:ETextField = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_number"));
         eAddChild(field);
         setContent("amount",field);
         field.setText(rank);
         field.applySkinProp(this.mSkinSku,"text_title_2");
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(rewardRaw,"IconTextS",this.mSkinSku);
         this.mContainersCount = containers.length;
         for(i = 0; i < this.mContainersCount; )
         {
            container = containers[i];
            eAddChild(container);
            setContent("reward" + i,container);
            i++;
         }
         var area:ELayoutArea = layoutFactory.getArea("container_icon_text_all");
         this.mViewFactory.distributeSpritesInArea(area,containers,2,1,this.mContainersCount);
         for(i = 0; i < this.mContainersCount; )
         {
            container = containers[i];
            container.logicLeft += area.x;
            container.logicTop += area.y;
            i++;
         }
      }
      
      public function setTextProps(props:String, apply:Boolean = true) : void
      {
         var field:ETextField = getContent("amount") as ETextField;
         if(apply)
         {
            field.applySkinProp(this.mSkinSku,props);
         }
         else
         {
            field.unapplySkinProp(this.mSkinSku,props);
         }
      }
   }
}
