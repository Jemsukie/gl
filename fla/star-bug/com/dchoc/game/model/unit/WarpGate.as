package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   
   public class WarpGate
   {
      
      public static const STATE_NONE:int = 0;
      
      public static const STATE_OPENING:int = 1;
      
      public static const STATE_FALLING:int = 2;
      
      public static const STATE_CLOSING:int = 3;
       
      
      private var mWarpGate:DCBitmapMovieClip;
      
      private var mWarpSpiral:DCBitmapMovieClip;
      
      public var mState:int;
      
      public var mX:Number;
      
      public var mY:Number;
      
      public function WarpGate()
      {
         super();
         this.mState = 0;
      }
      
      public function unbuild() : void
      {
         this.changeState(0);
      }
      
      public function open(x:Number, y:Number) : void
      {
         this.mX = x;
         this.mY = y;
         this.changeState(1);
      }
      
      public function changeState(newState:int) : void
      {
         if(this.mWarpGate != null)
         {
            InstanceMng.getViewMngPlanet().removeStarGateFromStage(this.mWarpGate);
            this.mWarpGate = null;
         }
         if(this.mWarpSpiral != null)
         {
            InstanceMng.getViewMngPlanet().removeStarGateFromStage(this.mWarpSpiral);
            this.mWarpSpiral = null;
         }
         switch(newState - 1)
         {
            case 0:
               this.mWarpGate = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/common.swf","start_drop_point_open") as DCBitmapMovieClip;
               this.mWarpGate.setLoop(false);
               break;
            case 1:
               this.mWarpGate = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/common.swf","start_drop_point") as DCBitmapMovieClip;
               this.mWarpSpiral = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/common.swf","drop_point_rotatealone") as DCBitmapMovieClip;
               break;
            case 2:
               this.mWarpGate = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/common.swf","start_drop_point_close") as DCBitmapMovieClip;
               this.mWarpGate.setLoop(false);
         }
         if(this.mWarpGate != null)
         {
            InstanceMng.getViewMngPlanet().addStarGateToStage(this.mWarpGate);
            this.mWarpGate.x = this.mX;
            this.mWarpGate.y = this.mY;
         }
         if(this.mWarpSpiral != null)
         {
            InstanceMng.getViewMngPlanet().addStarGateToStage(this.mWarpSpiral);
            this.mWarpSpiral.x = this.mX;
            this.mWarpSpiral.y = this.mY;
         }
         this.mState = newState;
      }
      
      public function logicUpdate() : void
      {
         if(this.mState == 1 || this.mState == 3)
         {
            if(this.mWarpGate.currentFrame == this.mWarpGate.totalFrames)
            {
               if(this.mState == 1)
               {
                  this.changeState(2);
               }
               else if(this.mState == 3)
               {
                  this.changeState(0);
               }
            }
         }
      }
   }
}
