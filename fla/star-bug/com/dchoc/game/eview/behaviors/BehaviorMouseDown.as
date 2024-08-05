package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorMouseDown extends EBehavior
   {
       
      
      private var mBehaviorMouseDown:EBehavior;
      
      private var mBehaviorMouseUp:EBehavior;
      
      public function BehaviorMouseDown(behaviorMouseDown:EBehavior, behaviorMouseUp:EBehavior)
      {
         super();
         this.mBehaviorMouseDown = behaviorMouseDown;
         this.mBehaviorMouseUp = behaviorMouseUp;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mBehaviorMouseDown = null;
         this.mBehaviorMouseUp = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(!target.getIsMouseDown())
         {
            this.mBehaviorMouseDown.perform(target,params);
            target.setIsMouseDown(true);
         }
      }
   }
}
