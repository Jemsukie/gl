package com.gskinner.motion.easing
{
   public class Sine
   {
       
      
      public function Sine()
      {
         super();
      }
      
      public static function easeIn(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return 1 - Math.cos(ratio * (3.141592653589793 / 2));
      }
      
      public static function easeOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return Math.sin(ratio * (3.141592653589793 / 2));
      }
      
      public static function easeInOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return -0.5 * (Math.cos(ratio * 3.141592653589793) - 1);
      }
   }
}
