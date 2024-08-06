package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehavior
   {
       
      
      private var mHasPerformed:Boolean = false;
      
      public function EBehavior()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      final public function perform(target:ESprite, params:Object) : void
      {
         this.mHasPerformed = true;
         this.extendedPerform(target,params);
      }
      
      protected function extendedPerform(target:ESprite, params:Object) : void
      {
      }
      
      final public function unperform(target:ESprite, params:Object) : void
      {
         this.extendedUnperform(target,params);
         this.mHasPerformed = false;
      }
      
      protected function extendedUnperform(target:ESprite, params:Object) : void
      {
      }
      
      public function hasPerformed() : Boolean
      {
         return this.mHasPerformed;
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
   }
}
