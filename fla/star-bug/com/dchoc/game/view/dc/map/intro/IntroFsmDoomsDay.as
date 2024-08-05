package com.dchoc.game.view.dc.map.intro
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.rule.BackgroundDef;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import flash.display.Sprite;
   
   public class IntroFsmDoomsDay extends IntroFsm
   {
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_MOVE_CAMERA_TO_SUNSET:int = 0;
      
      private static const STATE_SHOW_SUN:int = 1;
      
      private static const STATE_PLAY_EXPLOSION:int = 2;
      
      private static const STATE_DELAY:int = 3;
      
      private static const STATE_END:int = 4;
       
      
      private var mAnim:DCDisplayObject;
      
      private var mResourceMng:ResourceMng;
      
      private var mLoadingTime:int = 0;
      
      private var mTimer:int = 0;
      
      private var mBackgroundDO:Sprite;
      
      public function IntroFsmDoomsDay(backgroundDO:Sprite)
      {
         super();
         this.mResourceMng = InstanceMng.getResourceMng();
         this.mBackgroundDO = backgroundDO;
         setState(0);
      }
      
      public function unload() : void
      {
         this.animClear();
         this.mResourceMng = null;
         setState(4);
         this.mBackgroundDO = null;
      }
      
      private function animClear() : void
      {
         if(this.mAnim != null)
         {
            this.sunRemoveAnimFromStage();
         }
      }
      
      override protected function enterState(state:int) : void
      {
         var viewX:int = 0;
         var viewY:int = 0;
         switch(state)
         {
            case 0:
               this.mLoadingTime = 2000;
               viewX = this.mBackgroundDO.x + this.mBackgroundDO.width / 2;
               viewY = this.mBackgroundDO.y;
               InstanceMng.getMapControllerPlanet().moveCameraTo(viewX,viewY,3.4);
               this.mTimer = 5000;
               break;
            case 1:
               this.mAnim = this.sunGetAnim();
               this.sunAddAnimToStage();
               break;
            case 2:
               InstanceMng.getViewMngGame().fadeEnable(16777215,900);
               this.animClear();
               InstanceMng.getMapViewPlanet().happeningsShowHappening("doomsday",true);
               InstanceMng.getMapControllerPlanet().centerCameraInHQ(0);
               break;
            case 3:
               this.mTimer = 2000;
         }
      }
      
      override protected function exitState(state:int) : void
      {
         switch(state)
         {
            case 0:
            case 1:
               this.sunRemoveAnimFromStage();
               break;
            case 2:
               InstanceMng.getMapControllerPlanet().centerCameraInHQ(0);
         }
      }
      
      override public function logicUpdate(dt:int) : Boolean
      {
         var progress:Number = NaN;
         if(this.mLoadingTime > 0)
         {
            this.mLoadingTime -= dt;
            if(this.mResourceMng.isResourceLoaded(this.sunGetAssetSku()))
            {
               this.mLoadingTime = -1;
            }
         }
         if(this.mTimer > 0)
         {
            this.mTimer -= dt;
         }
         var changeState:* = false;
         switch(mState)
         {
            case 0:
               if(this.mAnim == null)
               {
                  this.mAnim = this.sunsetGetAnim();
                  if(this.mAnim != null)
                  {
                     this.sunAddAnimToStage();
                  }
               }
               if(this.mAnim == null)
               {
                  changeState = this.mLoadingTime < 0;
               }
               else
               {
                  changeState = this.mAnim.isAnimationOver();
               }
               if(changeState)
               {
                  setState(1);
               }
               break;
            case 1:
               if(this.mAnim != null)
               {
                  progress = this.mAnim.currentFrame / this.mAnim.totalFrames;
                  changeState = progress >= 0.65;
               }
               else
               {
                  changeState = true;
               }
               if(changeState)
               {
                  setState(2);
               }
               break;
            case 2:
               setState(3);
               break;
            case 3:
               if(this.mTimer <= 0)
               {
                  setState(4);
                  break;
               }
         }
         return mState == 4;
      }
      
      private function sunsetGetAnim() : DCDisplayObject
      {
         return this.mResourceMng.getDCDisplayObject(this.sunGetAssetSku(),"event_anim_1",true,0);
      }
      
      private function sunAddAnimToStage() : void
      {
         if(this.mAnim != null)
         {
            this.mAnim.x = this.mBackgroundDO.width / 2;
            this.mAnim.y = this.mBackgroundDO.height / 2;
            this.mBackgroundDO.addChild(this.mAnim);
         }
      }
      
      private function sunRemoveAnimFromStage() : void
      {
         if(this.mAnim != null && this.mBackgroundDO.contains(this.mAnim))
         {
            this.mBackgroundDO.removeChild(this.mAnim);
            this.mAnim = null;
         }
      }
      
      private function sunGetAnim() : DCDisplayObject
      {
         return this.mResourceMng.getDCDisplayObject(this.sunGetAssetSku(),"event_anim_2",true,0);
      }
      
      private function sunGetAssetSku() : String
      {
         var returnValue:String = null;
         var backgroundDef:BackgroundDef = InstanceMng.getBackgroundDefMng().getDefBySku("doomsday_winter") as BackgroundDef;
         if(backgroundDef != null)
         {
            returnValue = backgroundDef.getBackgroundAsset();
         }
         return returnValue;
      }
   }
}
