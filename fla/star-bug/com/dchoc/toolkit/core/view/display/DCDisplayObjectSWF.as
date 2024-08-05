package com.dchoc.toolkit.core.view.display
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class DCDisplayObjectSWF extends DCDisplayObject
   {
       
      
      private var mDOContainer:DisplayObject;
      
      private var mLastCurrentFrame:int;
      
      public function DCDisplayObjectSWF(m:DisplayObject)
      {
         super();
         this.mDOContainer = m;
         addChild(this.mDOContainer);
         this.mLastCurrentFrame = -1;
      }
      
      override public function getDisplayObjectContent() : DisplayObject
      {
         return this.mDOContainer;
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mDOContainer;
      }
      
      override public function setBoundingBoxSize() : void
      {
         if(mBoundingBox != null)
         {
            mBoundingBox.setSize(this.mDOContainer.width,this.mDOContainer.height);
         }
      }
      
      override public function get x() : Number
      {
         return this.mDOContainer.x;
      }
      
      override public function set x(x:Number) : void
      {
         this.mDOContainer.x = x;
      }
      
      override public function get y() : Number
      {
         return this.mDOContainer.y;
      }
      
      override public function set y(y:Number) : void
      {
         this.mDOContainer.y = y;
      }
      
      override public function getIndexInParent() : int
      {
         return this.mDOContainer.parent.getChildIndex(this.mDOContainer);
      }
      
      override public function set scaleX(value:Number) : void
      {
         this.mDOContainer.scaleX = value;
      }
      
      override public function set scaleY(value:Number) : void
      {
         this.mDOContainer.scaleY = value;
      }
      
      override public function getCurrentFrameWidth() : int
      {
         return this.mDOContainer.width;
      }
      
      override public function getCurrentFrameHeight() : int
      {
         return this.mDOContainer.height;
      }
      
      override public function set filters(value:Array) : void
      {
         this.mDOContainer.filters = value;
      }
      
      override public function get filters() : Array
      {
         return this.mDOContainer.filters;
      }
      
      override public function get currentFrame() : int
      {
         var newFrame:int = int(this.mDOContainer is MovieClip ? int(MovieClip(this.mDOContainer).currentFrame) : 0);
         if(this.mLastCurrentFrame > -2)
         {
            if(this.mLastCurrentFrame > newFrame)
            {
               this.mLastCurrentFrame = -2;
            }
            else
            {
               this.mLastCurrentFrame = newFrame;
            }
         }
         return newFrame;
      }
      
      override public function set currentFrame(value:int) : void
      {
         if(this.mDOContainer is MovieClip)
         {
            this.mLastCurrentFrame = -1;
            MovieClip(this.mDOContainer).gotoAndStop(value);
         }
      }
      
      override public function get totalFrames() : int
      {
         return this.mDOContainer is MovieClip ? int(MovieClip(this.mDOContainer).totalFrames) : 0;
      }
      
      override public function get currentFrameLabel() : String
      {
         return this.mDOContainer is MovieClip ? MovieClip(this.mDOContainer).currentFrameLabel : null;
      }
      
      override public function get alpha() : Number
      {
         return this.mDOContainer.alpha;
      }
      
      override public function set alpha(value:Number) : void
      {
         this.mDOContainer.alpha = value;
      }
      
      override public function gotoAndStop(frameId:int) : void
      {
         if(this.mDOContainer is MovieClip)
         {
            MovieClip(this.mDOContainer).gotoAndStop(frameId);
            this.mLastCurrentFrame = -1;
         }
      }
      
      override public function gotoAndPlay(frameId:int) : void
      {
         if(this.mDOContainer is MovieClip)
         {
            MovieClip(this.mDOContainer).gotoAndPlay(frameId);
            this.mLastCurrentFrame = -1;
         }
      }
      
      override public function nextFrame() : void
      {
         if(this.mDOContainer is MovieClip)
         {
            MovieClip(this.mDOContainer).nextFrame();
            this.mLastCurrentFrame = -1;
         }
      }
      
      override public function isAnimationOver() : Boolean
      {
         return this.mLastCurrentFrame == -2 || super.isAnimationOver();
      }
   }
}
