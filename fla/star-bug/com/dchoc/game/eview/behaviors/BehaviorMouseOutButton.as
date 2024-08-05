package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorMouseOutButton extends EBehavior
   {
       
      
      private var mBehaviorMouseUp:EBehavior;
      
      private var mBehaviorChangeSkin:EBehavior;
      
      public function BehaviorMouseOutButton(behaviorMouseUp:EBehavior, behaviorChangeSkin:EBehavior)
      {
         super();
         this.mBehaviorMouseUp = behaviorMouseUp;
         this.mBehaviorChangeSkin = behaviorChangeSkin;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mBehaviorMouseUp = null;
         this.mBehaviorChangeSkin = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(params.buttonDown)
         {
            this.mBehaviorMouseUp.perform(target,params);
         }
         this.mBehaviorChangeSkin.perform(target,params);
      }
   }
}
