package com.dchoc.game.eview.behaviors
{
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   
   public class BehaviorUnderline extends EBehavior
   {
       
      
      private var mUnderLine:Boolean;
      
      public function BehaviorUnderline(underline:Boolean)
      {
         super();
         this.mUnderLine = underline;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         var field:ETextField = target as ETextField;
         field.setUnderline(this.mUnderLine);
      }
   }
}
