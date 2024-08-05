package com.dchoc.game.eview.widgets.happenings
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EFillBarSegmented;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.items.ItemsDef;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Back;
   import esparragon.display.EImage;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EProgressBarHappening extends EFillBarSegmented
   {
      
      private static const AREA_UNITS:String = "icon_units_reward";
      
      private static const AREA_SHINE:String = "shine";
      
      private static const REWARD_PREFIX:String = "reward_";
      
      private static const SHINE_PREFIX:String = "shine_";
      
      private static const TWEEN_DURATION:Number = 0.6;
      
      private static const TOTAL_SHINE_DURATION:Number = 3;
       
      
      private var mNumBars:int;
      
      private var mHappening:Happening;
      
      private var mRewardSkus:Array;
      
      private var mLastKnownProgressUpdate:int;
      
      public function EProgressBarHappening()
      {
         super();
      }
      
      public function setup(layoutArea:ELayoutArea, happening:Happening, animated:Boolean) : void
      {
         var i:int = 0;
         var rewardImg:EImage = null;
         var shineImg:EImage = null;
         var viewFactory:ViewFactory = null;
         var xOffset:Number = NaN;
         var rewardSku:String = null;
         var item:ItemsDef = null;
         this.mHappening = happening;
         this.mRewardSkus = this.mHappening.getHappeningDef().getReward().split(",");
         this.mNumBars = this.mRewardSkus.length;
         build(layoutArea,this.mHappening.getTarget(),"color_capacity",this.mRewardSkus.length);
         if(animated)
         {
            this.mLastKnownProgressUpdate = this.mHappening.getCurrentProgress() - this.mHappening.getHappeningType().getCurrentWaveProgress();
            setValue(this.mLastKnownProgressUpdate);
            setValueAnimated(this.mHappening.getCurrentProgress(),10000);
         }
         else
         {
            this.mLastKnownProgressUpdate = this.mHappening.getCurrentProgress();
            setValue(this.mLastKnownProgressUpdate);
         }
         viewFactory = InstanceMng.getViewFactory();
         var numRewardsToPaint:int = this.getNumBarsFullVisual();
         var imageLayout:ELayoutArea = viewFactory.getLayoutAreaFactory("LayoutHappeningsIconUnit").getArea("icon_units_reward");
         var shineLayout:ELayoutArea = viewFactory.getLayoutAreaFactory("LayoutHappeningsIconUnit").getArea("shine");
         for(i = 0; i < this.mNumBars - 1; )
         {
            xOffset = getContentAsESpriteContainer("segments").getContent("segment" + i).logicLeft;
            layoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(shineLayout);
            layoutArea.x += getContentAsESpriteContainer("segments").getContent("segment" + i).logicLeft;
            (shineImg = viewFactory.getEImage("shine",null,false,layoutArea)).alpha = 0;
            eAddChild(shineImg);
            setContent("shine_" + i,shineImg);
            layoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(imageLayout);
            layoutArea.x += getContentAsESpriteContainer("segments").getContent("segment" + i).logicLeft;
            if(i < numRewardsToPaint)
            {
               rewardSku = String(this.mRewardSkus[i].split(":")[0]);
               item = InstanceMng.getItemsMng().getItemObjectBySku(rewardSku).mDef;
               rewardImg = viewFactory.getEImage(item.getAssetId(),null,false,layoutArea);
            }
            else
            {
               rewardImg = viewFactory.getEImage("question_mark",null,false,layoutArea);
            }
            eAddChild(rewardImg);
            setContent("reward_" + i,rewardImg);
            i++;
         }
      }
      
      public function getNumBarsFullLogic() : int
      {
         return Math.floor(this.mNumBars * this.mHappening.getCurrentProgress() / this.mHappening.getTarget());
      }
      
      public function getNumBarsFullVisual() : int
      {
         return Math.floor(this.mNumBars * getCurrentValue() / this.mHappening.getTarget());
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var rewardImg:EImage = null;
         var rewardSku:String = null;
         var item:ItemsDef = null;
         var easeBack:Object = null;
         var values:Object = null;
         var t:GTween = null;
         var shineImg:EImage = null;
         super.logicUpdate(dt);
         var barsFull:int = this.getNumBarsFullVisual();
         var currentRewardIdx:int = barsFull - 1;
         if(Math.floor(this.mNumBars * this.mLastKnownProgressUpdate / this.mHappening.getTarget()) < barsFull && barsFull < this.mRewardSkus.length)
         {
            rewardImg = getContentAsEImage("reward_" + currentRewardIdx);
            rewardSku = String(this.mRewardSkus[currentRewardIdx].split(":")[0]);
            item = InstanceMng.getItemsMng().getItemObjectBySku(rewardSku).mDef;
            InstanceMng.getViewFactory().setTextureToImage(item.getAssetId(),null,rewardImg);
            easeBack = {"ease":Back.easeOut};
            values = {
               "scaleLogicX":rewardImg.scaleLogicX,
               "scaleLogicY":rewardImg.scaleLogicY
            };
            rewardImg.scaleLogicX = rewardImg.scaleLogicY = 0;
            (t = new GTween(rewardImg,0.6,values,easeBack)).autoPlay = true;
            shineImg = getContentAsEImage("shine_" + currentRewardIdx);
            values = {"alpha":1};
            (t = new GTween(shineImg,0.6,values)).autoPlay = true;
            values = {"rotation":shineImg.rotation + 90};
            (t = new GTween(shineImg,3,values)).autoPlay = true;
            values = {"alpha":0};
            (t = new GTween(shineImg,0.6,values)).delay = 3 - 0.6;
            t.autoPlay = true;
         }
         this.mLastKnownProgressUpdate = getCurrentValue();
      }
   }
}
