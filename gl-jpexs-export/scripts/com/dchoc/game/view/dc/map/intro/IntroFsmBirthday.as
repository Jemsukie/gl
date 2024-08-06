package com.dchoc.game.view.dc.map.intro
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.unit.FireWorksMng;
   import flash.display.Sprite;
   
   public class IntroFsmBirthday extends IntroFsm
   {
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_MOVE_CAMERA_TO_SKY:int = 0;
      
      private static const STATE_PLAY_FIREWORKS:int = 1;
      
      private static const STATE_DELAY:int = 2;
      
      private static const STATE_END:int = 3;
       
      
      private var mResourceMng:ResourceMng;
      
      private var mTimer:int = 0;
      
      private var mBackgroundDO:Sprite;
      
      public function IntroFsmBirthday(backgroundDO:Sprite)
      {
         super();
         this.mResourceMng = InstanceMng.getResourceMng();
         this.mBackgroundDO = backgroundDO;
         setState(0);
      }
      
      public function unload() : void
      {
         this.mResourceMng = null;
         setState(3);
         this.mBackgroundDO = null;
      }
      
      override protected function enterState(state:int) : void
      {
         switch(state)
         {
            case 0:
               InstanceMng.getMapControllerPlanet().moveCameraTo(1766,-442,3.4);
               this.mTimer = 8000;
               break;
            case 1:
               if(FireWorksMng.getInstance().areFireworksRunning())
               {
                  FireWorksMng.getInstance().reset(5000);
                  break;
               }
               FireWorksMng.getInstance().init(5000);
               break;
         }
      }
      
      override public function logicUpdate(dt:int) : Boolean
      {
         if(this.mTimer > 0)
         {
            this.mTimer -= dt;
         }
         switch(mState)
         {
            case 0:
               if(this.mTimer <= 0 || InstanceMng.getMapControllerPlanet().cameraHasReachedTheTarget())
               {
                  setState(1);
               }
               break;
            case 1:
               setState(2);
               break;
            case 2:
               if(this.mTimer <= 0)
               {
                  setState(3);
                  break;
               }
         }
         return mState == 3;
      }
   }
}
