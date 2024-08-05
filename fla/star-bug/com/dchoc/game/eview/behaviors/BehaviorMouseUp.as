package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   
   public class BehaviorMouseUp extends EBehavior
   {
       
      
      private var mBehaviorMouseUp:EBehavior;
      
      public function BehaviorMouseUp(behaviorMouseUp:EBehavior)
      {
         super();
         this.mBehaviorMouseUp = behaviorMouseUp;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.mBehaviorMouseUp = null;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         target.eRemoveEventBehavior("mouseOut",this);
         if(target.getIsMouseDown())
         {
            this.mBehaviorMouseUp.perform(target,params);
            target.setIsMouseDown(false);
         }
      }
   }
}
