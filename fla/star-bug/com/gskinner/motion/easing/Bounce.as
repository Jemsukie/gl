package com.gskinner.motion.easing
{
   public class Bounce
   {
       
      
      public function Bounce()
      {
         super();
      }
      
      public static function easeIn(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return 1 - easeOut(1 - ratio,0,0,0);
      }
      
      public static function easeOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         if(ratio < 0.36363636363636365)
         {
            return 7.5625 * ratio * ratio;
         }
         if(ratio < 0.7272727272727273)
         {
            return 7.5625 * (ratio -= 0.5454545454545454) * ratio + 0.75;
         }
         if(ratio < 0.9090909090909091)
         {
            return 7.5625 * (ratio -= 0.8181818181818182) * ratio + 0.9375;
         }
         return 7.5625 * (ratio -= 0.9545454545454546) * ratio + 0.984375;
      }
      
      public static function easeInOut(ratio:Number, unused1:Number, unused2:Number, unused3:Number) : Number
      {
         return (ratio *= 2) < 1 ? 0.5 * easeIn(ratio,0,0,0) : 0.5 * easeOut(ratio - 1,0,0,0) + 0.5;
      }
   }
}
