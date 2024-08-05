package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   
   public class BehaviorCheck extends EBehavior
   {
       
      
      public function BehaviorCheck()
      {
         super();
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         var container:ESpriteContainer = target as ESpriteContainer;
         var check:EImage;
         if((check = container.getContentAsEImage("check")) != null)
         {
            check.visible = !check.visible;
         }
      }
   }
}
