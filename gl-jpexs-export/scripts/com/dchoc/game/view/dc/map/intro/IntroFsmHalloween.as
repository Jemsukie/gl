package com.dchoc.game.view.dc.map.intro
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import flash.display.Sprite;
   
   public class IntroFsmHalloween extends IntroFsm
   {
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_MOVE_CAMERA_TO_SKY:int = 0;
      
      private static const STATE_MOVE_CAMERA_TO_COLLISION_SPOT:int = 1;
      
      private static const STATE_PLAY_EXPLOSION:int = 2;
      
      private static const STATE_DELAY:int = 3;
      
      private static const STATE_END:int = 4;
      
      private static const INTRO_1:String = "halloween/halloween_open_anim";
       
      
      private var mAnim:DCDisplayObject;
      
      private var mResourceMng:ResourceMng;
      
      private var mLoadingTime:int = 0;
      
      private var mTimer:int = 0;
      
      private var mBackgroundDO:Sprite;
      
      public function IntroFsmHalloween(backgroundDO:Sprite)
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
         if(this.mAnim != null && this.mBackgroundDO.contains(this.mAnim))
         {
            this.mBackgroundDO.removeChild(this.mAnim);
            this.mAnim = null;
         }
      }
      
      override protected function enterState(state:int) : void
      {
         switch(state)
         {
            case 0:
               this.mResourceMng.catalogAddResource("halloween/halloween_open_anim",DCResourceMng.getFileName("assets/flash/halloween/halloween_open_anim.swf"),".swf",0);
               this.mResourceMng.requestResource("halloween/halloween_open_anim");
               this.mLoadingTime = 2000;
               InstanceMng.getMapControllerPlanet().moveCameraTo(1766,-442,3.4);
               this.mTimer = 5000;
               break;
            case 1:
               InstanceMng.getMapControllerPlanet().moveCameraTo(790,396,1);
               break;
            case 2:
               InstanceMng.getViewMngGame().fadeEnable(16777215,900);
               this.animClear();
               InstanceMng.getMapViewPlanet().happeningsShowHappening("halloween",true);
               break;
            case 3:
               this.mTimer = 6000;
         }
      }
      
      override public function logicUpdate(dt:int) : Boolean
      {
         if(this.mLoadingTime > 0)
         {
            this.mLoadingTime -= dt;
            if(this.mResourceMng.isResourceLoaded("halloween/halloween_open_anim"))
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
                  this.mAnim = this.mResourceMng.getDCDisplayObject("halloween/halloween_open_anim","animatic_halloween_1",true);
                  if(this.mAnim != null)
                  {
                     this.mAnim.x = this.mBackgroundDO.width / 2;
                     this.mAnim.y = this.mBackgroundDO.height / 2;
                     this.mBackgroundDO.addChild(this.mAnim);
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
               if(this.mTimer <= 0 || InstanceMng.getMapControllerPlanet().cameraHasReachedTheTarget() && this.mLoadingTime < 0)
               {
                  setState(1);
               }
               break;
            case 1:
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
               }
         }
         return mState == 4;
      }
   }
}
