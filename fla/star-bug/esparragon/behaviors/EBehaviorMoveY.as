package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehaviorMoveY extends EBehavior
   {
       
      
      private var mOffset:Number;
      
      public function EBehaviorMoveY(offset:Number)
      {
         super();
         this.mOffset = offset;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            target.logicY += this.mOffset;
         }
      }
   }
}
