package esparragon.behaviors
{
   import esparragon.display.ESprite;
   import flash.ui.Mouse;
   
   public class EBehaviorResetCursor extends EBehavior
   {
       
      
      public function EBehaviorResetCursor()
      {
         super();
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         Mouse.cursor = "auto";
      }
   }
}
