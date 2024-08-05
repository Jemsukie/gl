package com.dchoc.game.utils.popup
{
   import com.dchoc.toolkit.utils.popup.DCPopupEffect;
   import com.gskinner.motion.GTween;
   
   public class PopupEffectTween extends DCPopupEffect
   {
       
      
      private var mTween:GTween;
      
      private var mCallback:Function;
      
      public function PopupEffectTween(tween:GTween, callback:Function = null)
      {
         this.mTween = tween;
         this.mTween.onComplete = this.endTween;
         this.mCallback = callback;
         super();
      }
      
      public function getTween() : GTween
      {
         return this.mTween;
      }
      
      private function endTween(tween:GTween) : void
      {
         if(this.mCallback != null)
         {
            this.mCallback(tween);
         }
         this.mTween = null;
         setHasEnded(true);
      }
   }
}
