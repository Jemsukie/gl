package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehaviorUnapplySkinProp extends EBehavior
   {
       
      
      private var mSkinProp:String;
      
      public function EBehaviorUnapplySkinProp(skinProp:String)
      {
         super();
         this.mSkinProp = skinProp;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            target.unapplySkinProp(null,this.mSkinProp);
         }
      }
   }
}
