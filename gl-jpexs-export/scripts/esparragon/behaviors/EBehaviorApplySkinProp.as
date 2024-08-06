package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehaviorApplySkinProp extends EBehavior
   {
       
      
      private var mSkinProp:String;
      
      public function EBehaviorApplySkinProp(skinProp:String)
      {
         super();
         this.mSkinProp = skinProp;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            target.applySkinProp(null,this.mSkinProp);
         }
      }
   }
}
