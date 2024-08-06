package esparragon.behaviors
{
   import esparragon.display.ESprite;
   import flash.ui.Mouse;
   
   public class EBehaviorSetCursorFinguer extends EBehavior
   {
       
      
      public function EBehaviorSetCursorFinguer()
      {
         super();
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            Mouse.cursor = "button";
         }
      }
   }
}
