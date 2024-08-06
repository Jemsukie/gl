package com.dchoc.toolkit.core.view.display
{
   import com.dchoc.toolkit.utils.DCUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class DCBitmapMovieClip extends DCDisplayObject
   {
       
      
      private var mAnims:Object;
      
      private var mFrame:int;
      
      private var mCurrentFrame:int;
      
      private var mTotalFrames:int;
      
      private var mIsPlaying:Boolean;
      
      private var mBitmap:Bitmap;
      
      private var mX:Number;
      
      private var mY:Number;
      
      private var mMaxWidth:int;
      
      private var mMaxHeight:int;
      
      private var mFrameDelay:int;
      
      private var mFrameDelayCount:int;
      
      private var mLoop:Boolean;
      
      private var smRectangle0:Rectangle;
      
      private var mIsAnimationOver:Boolean;
      
      public function DCBitmapMovieClip()
      {
         super();
         this.mBitmap = new Bitmap();
         addChild(this.mBitmap);
         this.mIsPlaying = true;
         this.mFrameDelay = 40;
         this.mFrameDelayCount = 0;
         this.mLoop = true;
         this.mIsAnimationOver = false;
         if(this.smRectangle0 == null)
         {
            this.smRectangle0 = new Rectangle();
         }
      }
      
      override public function getDisplayObjectContent() : DisplayObject
      {
         return this.mBitmap;
      }
      
      override public function get scaleX() : Number
      {
         return this.mBitmap == null ? 1 : this.mBitmap.scaleX;
      }
      
      override public function set scaleX(value:Number) : void
      {
         if(this.mBitmap != null)
         {
            this.mBitmap.scaleX = value;
         }
      }
      
      override public function get scaleY() : Number
      {
         return this.mBitmap == null ? 1 : this.mBitmap.scaleY;
      }
      
      override public function set scaleY(value:Number) : void
      {
         if(this.mBitmap != null)
         {
            this.mBitmap.scaleY = value;
         }
      }
      
      public function setAnimation(anims:Object) : void
      {
         var i:int = 0;
         this.mAnims = anims;
         this.mFrame = 1;
         this.mCurrentFrame = 0;
         this.mTotalFrames = anims.bmps.length;
         this.mBitmap.bitmapData = anims.bmps[this.mCurrentFrame];
         var bmp:BitmapData = anims.bmps[0];
         this.mMaxWidth = bmp.width;
         this.mMaxHeight = bmp.height;
         var length:int = int(anims.bmps.length);
         for(i = 1; i < length; )
         {
            bmp = anims.bmps[i];
            if(this.mMaxWidth < bmp.width)
            {
               this.mMaxWidth = bmp.width;
            }
            if(this.mMaxHeight < bmp.height)
            {
               this.mMaxHeight = bmp.height;
            }
            i++;
         }
         this.mIsAnimationOver = false;
      }
      
      public function getAnimation() : Object
      {
         return this.mAnims;
      }
      
      override public function gotoAndStop(frame:int) : void
      {
         this.mFrame = frame;
         if(this.mFrame >= this.mTotalFrames + 1)
         {
            this.mFrame = this.mTotalFrames;
         }
         this.setFrame(this.mFrame);
         this.mIsPlaying = false;
         this.mIsAnimationOver = false;
      }
      
      override public function gotoAndPlay(frame:int) : void
      {
         this.mFrame = frame;
         if(this.mFrame >= this.mTotalFrames + 1)
         {
            this.mFrame = this.mTotalFrames;
         }
         this.setFrame(this.mFrame);
         this.mIsPlaying = true;
         this.mIsAnimationOver = false;
      }
      
      override public function nextFrame() : void
      {
         this.gotoAndPlay(this.mFrame + 1);
      }
      
      public function play() : void
      {
         this.mIsPlaying = true;
         this.mIsAnimationOver = false;
      }
      
      public function stop() : void
      {
         this.mIsPlaying = false;
      }
      
      public function update(dt:int) : void
      {
         if(this.mIsPlaying)
         {
            this.mFrameDelayCount += dt;
            if(this.mFrameDelayCount >= this.mFrameDelay)
            {
               this.mFrame++;
               if(this.mFrame >= this.mTotalFrames + 1)
               {
                  if(this.mLoop)
                  {
                     this.mFrame = 1;
                  }
                  else
                  {
                     this.mFrame = this.mTotalFrames;
                     this.mIsPlaying = false;
                  }
                  this.mIsAnimationOver = true;
               }
               this.setFrame(this.mFrame);
               this.mFrameDelayCount = 0;
            }
         }
      }
      
      private function setFrame(frame:int) : void
      {
         if(frame == this.mCurrentFrame + 1)
         {
            return;
         }
         if(frame > 0)
         {
            frame--;
         }
         if(this.mCurrentFrame != frame)
         {
            this.mCurrentFrame = frame;
            this.mBitmap.bitmapData = this.mAnims.bmps[frame];
            this.mBitmap.x = this.mX + this.mAnims.bounds[frame].x * this.mBitmap.scaleX;
            this.mBitmap.y = this.mY + this.mAnims.bounds[frame].y * this.mBitmap.scaleY;
         }
         this.mFrameDelayCount = this.mFrameDelay;
      }
      
      public function get isPlaying() : Boolean
      {
         return this.mIsPlaying;
      }
      
      override public function get x() : Number
      {
         return this.mX;
      }
      
      override public function set x(value:Number) : void
      {
         this.mX = value;
         if(this.mAnims != null)
         {
            this.mBitmap.x = this.mX + this.mAnims.bounds[this.mCurrentFrame].x * this.mBitmap.scaleX;
         }
      }
      
      override public function get y() : Number
      {
         return this.mY;
      }
      
      override public function set y(value:Number) : void
      {
         this.mY = value;
         if(this.mAnims != null)
         {
            this.mBitmap.y = value + this.mAnims.bounds[this.mCurrentFrame].y * this.mBitmap.scaleY;
         }
      }
      
      public function getOriginalBounds() : Rectangle
      {
         if(this.mAnims != null)
         {
            return this.mAnims.bounds[this.mCurrentFrame] as Rectangle;
         }
         return this.smRectangle0;
      }
      
      override public function get alpha() : Number
      {
         return this.mBitmap.alpha;
      }
      
      override public function set alpha(value:Number) : void
      {
         this.mBitmap.alpha = value;
      }
      
      override public function set visible(value:Boolean) : void
      {
         this.mBitmap.visible = value;
      }
      
      override public function get visible() : Boolean
      {
         return this.mBitmap.visible;
      }
      
      override public function get totalFrames() : int
      {
         return this.mTotalFrames;
      }
      
      override public function get currentFrame() : int
      {
         return this.mFrame;
      }
      
      override public function getCurrentFrameWidth() : int
      {
         return this.mBitmap.width;
      }
      
      override public function getCurrentFrameHeight() : int
      {
         return this.mBitmap.height;
      }
      
      override public function getMaxWidth() : int
      {
         return this.mMaxWidth;
      }
      
      override public function getMaxHeight() : int
      {
         return this.mMaxHeight;
      }
      
      public function getCollBoxX(index:int = 0) : Number
      {
         if(this.mAnims.hasOwnProperty("collbox"))
         {
            index = this.checkCollIndex(index);
            if(index > -1)
            {
               return this.mAnims.collbox[this.mCurrentFrame][index].x;
            }
         }
         return 0;
      }
      
      public function getCollBoxY(index:int = 0) : Number
      {
         if(this.mAnims.hasOwnProperty("collbox"))
         {
            index = this.checkCollIndex(index);
            if(index > -1)
            {
               return this.mAnims.collbox[this.mCurrentFrame][index].y;
            }
         }
         return 0;
      }
      
      override public function get currentFrameLabel() : String
      {
         return this.mAnims != null ? this.mAnims.labels[this.mCurrentFrame] : null;
      }
      
      private function checkCollIndex(index:int) : int
      {
         if(this.mAnims.collbox == null || this.mAnims.collbox[this.mCurrentFrame] == null)
         {
            return -1;
         }
         var length:int = int(this.mAnims.collbox[this.mCurrentFrame].length);
         if(index >= length)
         {
            index = length - 1;
         }
         return index;
      }
      
      public function getCurrentLabel() : String
      {
         return this.mAnims.labels[this.mCurrentFrame];
      }
      
      override public function setInk(color:uint, magnitude:Number) : void
      {
         this.mBitmap.transform.colorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,color,magnitude);
      }
      
      override public function resetFilters() : void
      {
         this.mBitmap.transform.colorTransform = DCUtils.smColorTransformInit;
      }
      
      public function setLoop(value:Boolean) : void
      {
         this.mLoop = value;
      }
      
      override public function isAnimationOver() : Boolean
      {
         return this.mIsAnimationOver;
      }
   }
}
