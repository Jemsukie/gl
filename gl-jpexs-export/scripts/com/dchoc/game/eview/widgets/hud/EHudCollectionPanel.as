package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   
   public class EHudCollectionPanel extends ESpriteContainer
   {
      
      private static const AREA_BKG:String = "area_crafting";
      
      private static const AREA_TITLE:String = "text_crafting";
      
      private static const MAX_OPEN_TTL:int = 3000;
      
      private static const OPEN_TWEEN_DURATION:Number = 0.5;
       
      
      private var mItemBoxes:Array;
      
      private var mCollectionTitle:ETextField;
      
      private var mCollectionComplete:ESpriteContainer;
      
      private var mCollectionCompleteShine:EImage;
      
      private var mCollectionCompleteMustShow:Boolean;
      
      private var mCollectionInfo:Array;
      
      private var mOpenTTL:int;
      
      private var mTween:GTween;
      
      private var mStartingPosX:int;
      
      public function EHudCollectionPanel(viewFactory:ViewFactory, numItems:int)
      {
         var i:int = 0;
         super();
         this.mItemBoxes = [];
         for(i = 0; i < numItems; )
         {
            this.mItemBoxes[i] = viewFactory.getContainerItemSmall(null,"box_with_border","0",null,true);
            i++;
         }
         var layoutAreaFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("LayoutHudCollectionContainer");
         var layoutIn:ELayoutArea = viewFactory.createMinimumLayoutArea(this.mItemBoxes,0,1);
         var layoutBkg:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaFactory.getArea("area_crafting"));
         var layoutText:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(layoutAreaFactory.getTextArea("text_crafting"));
         layoutBkg.width = layoutIn.width + 2 * 8;
         layoutBkg.height = layoutIn.height + 2 * 8;
         layoutBkg.x -= layoutIn.width;
         layoutIn.x = layoutBkg.x + 8;
         layoutIn.y = layoutBkg.y + 8;
         layoutIn.x -= layoutBkg.x;
         layoutText.x -= layoutBkg.x;
         layoutBkg.x = 0;
         viewFactory.distributeSpritesInArea(layoutIn,this.mItemBoxes,1,1,-1,1,true);
         var bkg:EImage = viewFactory.getEImage("hud_box",null,false,layoutBkg);
         eAddChild(bkg);
         setContent("area_crafting",bkg);
         for(i = 0; i < this.mItemBoxes.length; )
         {
            eAddChild(this.mItemBoxes[i]);
            setContent("box" + i,this.mItemBoxes[i]);
            i++;
         }
         this.mCollectionTitle = viewFactory.getETextField(null,layoutText,"text_title");
         eAddChild(this.mCollectionTitle);
         setContent("text_crafting",this.mCollectionTitle);
         this.mCollectionComplete = viewFactory.getESpriteContainer();
         this.mCollectionCompleteShine = viewFactory.getEImage("shine",null,false,null,null);
         this.mCollectionCompleteShine.logicX = 0;
         this.mCollectionCompleteShine.logicY = 0;
         this.mCollectionCompleteShine.setPivotLogicXY(0.5,0.5);
         this.mCollectionComplete.eAddChild(this.mCollectionCompleteShine);
         this.mCollectionComplete.setContent("shine",this.mCollectionCompleteShine);
         var text:ETextField;
         (text = viewFactory.getETextField(null,new ELayoutTextArea(layoutText),"text_title")).setText(DCTextMng.getText(363));
         text.logicX = 0;
         text.logicY = 0;
         text.setPivotLogicXY(0.5,0.5);
         this.mCollectionComplete.logicX = this.logicLeft + this.getLogicWidth() / 2;
         this.mCollectionComplete.logicY = this.logicTop + this.getLogicHeight() / 2;
         this.mCollectionComplete.eAddChild(text);
         this.mCollectionComplete.setContent("text",text);
         this.eAddChild(this.mCollectionComplete);
         this.setContent("collectionComplete",this.mCollectionComplete);
         this.mCollectionComplete.alpha = 0;
      }
      
      override public function layoutApplyTransformations(area:ELayoutArea) : void
      {
         super.layoutApplyTransformations(area);
         this.mStartingPosX = area.x;
      }
      
      public function fillData(collectionInfo:Array, mustShowCollectionComplete:Boolean) : void
      {
         var i:int = 0;
         var itemContainer:ESpriteContainer = null;
         this.mCollectionInfo = collectionInfo;
         var collectionNameToDisplay:String = this.mCollectionInfo.splice(0,1);
         this.mCollectionTitle.setText(collectionNameToDisplay);
         for(i = 0; i < this.mCollectionInfo.length; )
         {
            itemContainer = getContentAsESpriteContainer("box" + i);
            InstanceMng.getViewFactory().setTextureToImage(this.mCollectionInfo[i].mDef.getAssetId(),null,itemContainer.getContentAsEImage("icon"));
            itemContainer.getContentAsETextField("text").setText("x" + this.mCollectionInfo[i].quantity);
            i++;
         }
         this.mCollectionCompleteMustShow = mustShowCollectionComplete;
      }
      
      private function launchCollectionCompleteAnimation() : void
      {
         var tween:GTween = new GTween(this.mCollectionComplete,0.5,{"alpha":1});
         tween.delay = 0.5;
         tween.autoPlay = true;
         tween = new GTween(this.mCollectionComplete,0.5,{"alpha":0});
         tween.delay = 3000 / 1000 - 0.5;
         tween.autoPlay = true;
      }
      
      public function resetTimer() : void
      {
         if(this.isOpen())
         {
            this.mOpenTTL = 3000;
         }
      }
      
      public function open(workerCollectibles:Boolean = false) : void
      {
         this.mOpenTTL = 3000;
         if(this.mTween)
         {
            this.mTween.end();
         }
         var logicWidth:Number = workerCollectibles ? 215 : this.getLogicWidth();
         this.mTween = new GTween(this,0.5,{"logicLeft":this.mStartingPosX - logicWidth});
         this.mTween.autoPlay = true;
         if(this.mCollectionCompleteMustShow)
         {
            this.launchCollectionCompleteAnimation();
            this.mCollectionCompleteMustShow = false;
         }
      }
      
      public function close() : void
      {
         this.mOpenTTL = 0;
         if(this.mTween)
         {
            this.mTween.end();
         }
         this.mTween = new GTween(this,0.5,{"logicLeft":this.mStartingPosX + 50});
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mOpenTTL > 0)
         {
            this.mOpenTTL = Math.max(0,this.mOpenTTL - dt);
            if(this.mOpenTTL <= 0)
            {
               this.close();
            }
            this.mCollectionCompleteShine.rotation += 0.5;
         }
      }
      
      public function getCollectableLogicPosition(sku:String) : int
      {
         var result:* = 0;
         var i:int = 0;
         while(this.mCollectionInfo && i < this.mCollectionInfo.length)
         {
            if(this.mCollectionInfo[i].mDef.getSku() == sku)
            {
               result = i;
            }
            i++;
         }
         return result;
      }
      
      public function isOpen() : Boolean
      {
         return this.mOpenTTL > 0;
      }
   }
}
