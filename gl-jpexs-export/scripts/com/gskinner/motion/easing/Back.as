package com.gskinner.motion.easing
{
   public class Back
   {
      
      protected static var s:Number = 1.70158;
       
      
      public function Back()
      {
         super();
      }
      
      public static function easeIn(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return ratio * ratio * ((s + 1) * ratio - s);
      }
      
      public static function easeOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return ratio-- * ratio * ((s + 1) * ratio + s) + 1;
      }
      
      public static function easeInOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return (ratio *= 2) < 1 ? 0.5 * (ratio * ratio * ((s * 1.525 + 1) * ratio - s * 1.525)) : 0.5 * ((ratio -= 2) * ratio * ((s * 1.525 + 1) * ratio + s * 1.525) + 2);
      }
   }
}
