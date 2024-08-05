package esparragon.behaviors
{
   import esparragon.display.ESprite;
   
   public class EBehaviorSetColor extends EBehavior
   {
       
      
      private var mColor:uint;
      
      private var mIntensity:Number;
      
      public function EBehaviorSetColor(color:uint, intensity:Number)
      {
         super();
         this.mColor = color;
         this.mIntensity = intensity;
      }
      
      override protected function extendedPerform(target:ESprite, params:Object) : void
      {
         if(target.getIsEnabled())
         {
            target.setColor(this.mColor,this.mIntensity);
         }
      }
   }
}
