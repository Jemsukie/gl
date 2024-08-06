package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   import flash.events.MouseEvent;
   
   public class BehaviorDisableSimulateMouseOut extends EBehavior
   {
       
      
      public function BehaviorDisableSimulateMouseOut()
      {
         super();
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         var e:MouseEvent = new MouseEvent("rollOut",true,false,0,0,target);
         target.dispatchEvent(e);
      }
   }
}
