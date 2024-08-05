package com.dchoc.game.eview.popups.levelup
{
   import com.dchoc.game.eview.widgets.contest.PopupRewardObtained;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   
   public class EPopupUnitUpgraded extends PopupRewardObtained
   {
       
      
      private var mUnitDef:ShipDef;
      
      private var mHasUnlocked:Boolean;
      
      public function EPopupUnitUpgraded()
      {
         super();
      }
      
      public function setUnitUpgraded(unitDef:ShipDef, hasUnlocked:Boolean) : void
      {
         var body:ESprite = getContent("body");
         this.mUnitDef = unitDef;
         this.mHasUnlocked = hasUnlocked;
         setIllustration("illus_mission_complete");
         setTopText(this.mUnitDef.getNameToDisplay());
         if(this.mHasUnlocked)
         {
            getTitle().setText(DCTextMng.getText(418));
         }
         else
         {
            getTitle().setText(DCTextMng.getText(420));
         }
         var feedImg:Array;
         var imageName:String = String((feedImg = unitDef.getFeedImg().split(","))[0]);
         if(!hasUnlocked)
         {
            imageName = String(feedImg[1]);
         }
         imageName = unitDef.getIcon();
         var box:EImage = mViewFactory.getEImage("box_with_border",mSkinSku,false,mBoxUnitArea);
         body.eAddChild(box);
         setContent("box_units_unlocked",box);
         mRaysImage = mViewFactory.getEImage("shine",mSkinSku,false);
         mRaysImage.onSetTextureLoaded = centerRays;
         mRaysImage.logicX = box.getLogicWidth() / 2;
         mRaysImage.logicY = box.getLogicHeight() / 2;
         mRaysImage.setPivotLogicXY(0.5,0.5);
         box.eAddChildAt(mRaysImage,1);
         setContent("shine",mRaysImage);
         var unitImage:EImage = mViewFactory.getEImage(imageName,mSkinSku,true,mImageUnitArea);
         body.eAddChild(unitImage);
         setContent("units_unlocked",unitImage);
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         super.notifyPopupMngClose(e);
      }
   }
}
