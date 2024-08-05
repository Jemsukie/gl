package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorFadeTo extends EBehavior
   {
       
      
      private var mTTL:int;
      
      private var mFadeTo:Number;
      
      private var mTarget:ESprite;
      
      private var mDestroyWhenFinished:Boolean;
      
      public function BehaviorFadeTo(fadeTo:Number, timeInMilliseconds:int, destroyWhenFinished:Boolean = true)
      {
         super();
         this.mTTL = timeInMilliseconds;
         this.mFadeTo = fadeTo;
         this.mDestroyWhenFinished = destroyWhenFinished;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         this.mTarget = target;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var diffAlpha:Number = NaN;
         if(hasPerformed())
         {
            if(this.mTTL <= 0)
            {
               diffAlpha = this.mFadeTo - this.mTarget.alpha;
            }
            else
            {
               diffAlpha = (this.mFadeTo - this.mTarget.alpha) * dt / this.mTTL;
            }
            this.mTarget.alpha += diffAlpha;
            this.mTTL -= dt;
            if(this.mTTL <= 0)
            {
               unperform(this.mTarget,{});
            }
         }
      }
   }
}
