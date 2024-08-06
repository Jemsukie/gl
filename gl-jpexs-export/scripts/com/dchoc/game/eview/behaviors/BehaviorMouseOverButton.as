package com.dchoc.game.eview.behaviors
{
   import com.dchoc.toolkit.core.media.SoundManager;
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorMouseOverButton extends EBehavior
   {
       
      
      private var mBehaviorMouseDown:EBehavior;
      
      private var mBehaviorChangeSkin:EBehavior;
      
      public function BehaviorMouseOverButton(behaviorMouseDown:EBehavior, behaviorChangeSkin:EBehavior)
      {
         super();
         this.mBehaviorMouseDown = behaviorMouseDown;
         this.mBehaviorChangeSkin = behaviorChangeSkin;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mBehaviorMouseDown = null;
         this.mBehaviorChangeSkin = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(params.buttonDown)
         {
            this.mBehaviorMouseDown.perform(target,params);
         }
         if(Config.USE_SOUNDS)
         {
            SoundManager.getInstance().playSound("mouseover.mp3",0.5);
         }
         this.mBehaviorChangeSkin.perform(target,params);
      }
   }
}
