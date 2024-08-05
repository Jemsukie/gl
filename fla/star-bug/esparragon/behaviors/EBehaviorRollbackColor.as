package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehaviorRollbackColor extends EBehavior
   {
       
      
      public function EBehaviorRollbackColor()
      {
         super();
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            target.rollbackColor();
         }
      }
   }
}
