package com.dchoc.game.model.animation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class AnimationLogicUfo extends AnimationLogic
   {
      
      private static const STATE_UFO_GOING:int = 0;
      
      private static const STATE_UFO_KIDNAPPING:int = 1;
      
      private static const STATE_UFO_COMING:int = 2;
      
      private static const STATE_UFO_END:int = 3;
      
      private static const UFO_STATE:int = 0;
      
      private static const UFO_MINION_ASSOCIATED:int = 1;
      
      private static const UFO_COORDS_FROM:int = 2;
      
      private static const UFO_COORDS_TO:int = 3;
      
      private static const UFO_TIME_TOTAL:int = 4;
      
      private static const NOTIFY_END_OBJECT:Object = {"cmd":"NOTIFY_STATE_END"};
       
      
      private var mMinionAssociated:DCBitmapMovieClip;
      
      private var mCoordsFrom:DCCoordinate;
      
      private var mCoordsTo:DCCoordinate;
      
      private var mTimeTotal:Number;
      
      private var mTimeCurrent:Number;
      
      public function AnimationLogicUfo()
      {
         super();
      }
      
      override public function setParams(... params) : void
      {
         mState = params[0];
         this.mMinionAssociated = params[1];
         this.mCoordsFrom = params[2];
         this.mCoordsTo = params[3];
         this.mTimeTotal = params[4];
         this.mTimeCurrent = 0;
      }
      
      override protected function requestAnimByState() : void
      {
         var anim:Object = null;
         var classStr:String = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(mState)
         {
            case 0:
               if(resourceMng.isResourceLoaded("ovni"))
               {
                  anim = resourceMng.getAnimation("ovni","still");
               }
               else
               {
                  resourceMng.requestResource("ovni");
               }
               break;
            case 1:
            case 2:
               if(resourceMng.isResourceLoaded("assets/flash/tutorial/abduction_assets.swf"))
               {
                  classStr = mState == 1 ? "abduction" : "abducted_left";
                  anim = resourceMng.getAnimation("assets/flash/tutorial/abduction_assets.swf",classStr);
                  break;
               }
               resourceMng.requestResource("assets/flash/tutorial/abduction_assets.swf");
               break;
         }
         if(anim != null)
         {
            setAnimation(anim);
            play();
         }
         else
         {
            stop();
         }
      }
      
      private function requestMinionAnim() : void
      {
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         if(resourceMng.isResourceLoaded("citizen_001") == false)
         {
            resourceMng.requestResource("citizen_001");
            return;
         }
         var anim:Object = resourceMng.getAnimation("citizen_001","still");
         this.mMinionAssociated.setAnimation(anim);
         this.mMinionAssociated.play();
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mMinionAssociated != null && this.mMinionAssociated.getAnimation() == null)
         {
            this.requestMinionAnim();
         }
         switch(mState)
         {
            case 0:
               this.updateGoing(dt);
               break;
            case 1:
               this.updateKidnapping();
               break;
            case 2:
               this.updateGoing(dt,true);
         }
      }
      
      private function updateGoing(dt:int, inversePath:Boolean = false) : void
      {
         var ended:Boolean = false;
         this.mTimeCurrent += dt;
         if(this.mTimeCurrent > this.mTimeTotal)
         {
            this.mTimeCurrent = this.mTimeTotal;
            ended = true;
         }
         var coordFrom:DCCoordinate = inversePath ? this.mCoordsTo : this.mCoordsFrom;
         var coordTo:DCCoordinate = inversePath ? this.mCoordsFrom : this.mCoordsTo;
         var timeCurrent:Number = this.mTimeCurrent / this.mTimeTotal;
         var x:Number = coordFrom.x * (1 - timeCurrent) + coordTo.x * timeCurrent;
         var y:Number = coordFrom.y * (1 - timeCurrent) + coordTo.y * timeCurrent;
         setXY(x,y);
         if(ended)
         {
            this.setNextStep();
         }
      }
      
      private function updateKidnapping() : void
      {
         if(currentFrame == totalFrames)
         {
            this.setNextStep();
         }
      }
      
      private function setNextStep() : void
      {
         var o:Object = null;
         mState++;
         this.mTimeCurrent = 0;
         this.requestAnimByState();
         if(mState > 0 && this.mMinionAssociated != null)
         {
            InstanceMng.getViewMngPlanet().removeParticle(this.mMinionAssociated);
         }
         if(mState == 3 && mNotifyComponent != null)
         {
            o = NOTIFY_END_OBJECT;
            o.ufoInstance = this;
            mNotifyComponent.notify(o);
         }
      }
   }
}
