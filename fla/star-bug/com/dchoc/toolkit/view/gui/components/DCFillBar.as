package com.dchoc.toolkit.view.gui.components
{
   import flash.display.MovieClip;
   
   public class DCFillBar
   {
      
      public static const ANIMATION_TIME:int = 1000;
      
      private static const MIN_VALUE:Number = 0;
       
      
      private var mBarMC:MovieClip;
      
      private var mMinValue:Number;
      
      private var mMaxValue:Number;
      
      private var mValue:Number;
      
      private var mAnimElapsedTime:int;
      
      private var mAnimDuration:int;
      
      private var mAnimStartFrame:int;
      
      public function DCFillBar(barMC:MovieClip, min:Number, max:Number)
      {
         super();
         this.mBarMC = barMC;
         this.setMinValue(min);
         this.setMaxValue(max);
         this.mAnimElapsedTime = 0;
         this.mAnimDuration = 1000;
         this.mAnimStartFrame = 1;
      }
      
      public function logicUpdate(deltaTime:int) : void
      {
         var animDelta:Number = NaN;
         var frame:int = 0;
         if(this.mBarMC != null && this.mAnimElapsedTime > 0 && this.mAnimDuration > 0)
         {
            this.mAnimElapsedTime = Math.min(this.mAnimElapsedTime + deltaTime,this.mAnimDuration);
            animDelta = this.mAnimElapsedTime / this.mAnimDuration;
            frame = this.mAnimStartFrame + (this.getFrameForCurrentValue() - this.mAnimStartFrame) * animDelta;
            this.mBarMC.gotoAndStop(frame);
         }
      }
      
      public function getMinValue() : Number
      {
         return this.mMinValue;
      }
      
      public function getMaxValue() : Number
      {
         return this.mMaxValue;
      }
      
      public function getFrameForCurrentValue() : int
      {
         var currentFrame:int = 0;
         if(this.mBarMC != null)
         {
            currentFrame = this.mBarMC.totalFrames * (this.mValue - this.mMinValue) / (this.mMaxValue - this.mMinValue);
         }
         return currentFrame;
      }
      
      public function getValue() : Number
      {
         return this.mValue;
      }
      
      public function getValueAsPercentage() : Number
      {
         return (this.mValue - this.mMinValue) / (this.mMaxValue - this.mMinValue);
      }
      
      public function getBarMC() : MovieClip
      {
         return this.mBarMC;
      }
      
      public function setMinValue(min:Number) : void
      {
         this.mMinValue = min;
      }
      
      public function setMaxValue(max:Number) : void
      {
         this.mMaxValue = max;
      }
      
      public function setValue(_value:Number, _animDuration:Number = -1) : void
      {
         var newFrame:int = 0;
         if(this.mBarMC != null)
         {
            if(_animDuration < 0)
            {
               this.mAnimDuration = 1000;
            }
            else
            {
               this.mAnimDuration = _animDuration * 1000;
            }
            this.mValue = _value;
            if(this.mAnimDuration == 0)
            {
               newFrame = this.getFrameForCurrentValue();
               this.mBarMC.gotoAndStop(newFrame);
               this.mBarMC.stop();
               this.mAnimElapsedTime = 0;
            }
            else
            {
               this.mAnimElapsedTime = 1;
            }
            this.mAnimStartFrame = this.mBarMC.currentFrame;
         }
      }
      
      public function setValueAsPercentage(_value:Number, _animDuration:Number = -1) : void
      {
         this.setValue(this.mMinValue + _value * (this.mMaxValue - this.mMinValue),_animDuration);
      }
      
      public function setValueWithoutBarAnimation(_value:Number) : void
      {
         this.setValue(_value,0);
      }
      
      public function setValueWithoutBarAnimationAsPercentage(_value:Number) : void
      {
         this.setValue(this.mMinValue + _value * (this.mMaxValue - this.mMinValue),0);
      }
   }
}
