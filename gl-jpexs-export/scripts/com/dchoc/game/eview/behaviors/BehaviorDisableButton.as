package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorDisableButton extends EBehavior
   {
       
      
      private var mBehaviorDisable:EBehavior;
      
      private var mBehaviorMouseOut:EBehavior;
      
      public function BehaviorDisableButton(behaviorDisable:EBehavior, behaviorMouseOut:EBehavior)
      {
         super();
         this.mBehaviorDisable = behaviorDisable;
         this.mBehaviorMouseOut = behaviorMouseOut;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mBehaviorDisable = null;
         this.mBehaviorMouseOut = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         this.mBehaviorDisable.perform(target,params);
         this.mBehaviorMouseOut.perform(target,params);
      }
   }
}
