package com.dchoc.toolkit.utils.math
{
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class DCMath
   {
      
      public static const RAD_360:Number = 6.283185307179586;
      
      public static const RAD_90:Number = 1.5707963267948966;
      
      public static const DEGREES_TO_RAD:Number = 0.017453292519943295;
      
      public static const RAD_270:Number = DEGREES_TO_RAD * 270;
      
      public static const RAD_359:Number = DEGREES_TO_RAD * 359;
      
      public static const RAD_TO_DEGREES:Number = 57.29577951308232;
      
      public static const EPSILON:Number = 0.00001;
      
      private static const TRIG_ANGLES_COUNT:int = 360;
      
      private static var smTrigSin:Vector.<Number>;
      
      private static var smTrigCos:Vector.<Number>;
      
      private static const PULSE_VALUES_COUNT:int = 150;
      
      private static var smPulseValues:Vector.<Number>;
      
      private static var smSimpleRandInitialized:Boolean = false;
      
      private static var smSimpleRandCounter:int = 0;
      
      private static const smSimpleRandData:Array = [440777937,1385877358,4084880585,541049956,838251821];
      
      private static const smSimpleRandDataSeed:Array = [440777937,1385877358,4084880585,541049956,838251821];
       
      
      public function DCMath()
      {
         super();
      }
      
      public static function init() : void
      {
         trigInit();
      }
      
      public static function distanceSqr(v1:*, v2:*) : Number
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         if((v1 is Vector3D || v1 is DCCoordinate) && (v2 is Vector3D || v2 is DCCoordinate))
         {
            dx = v1.x - v2.x;
            dy = v1.y - v2.y;
            return dx * dx + dy * dy;
         }
         return 0;
      }
      
      public static function rad2Degree(angleRadians:Number) : Number
      {
         return angleRadians * 57.29577951308232;
      }
      
      public static function degree2Rad(angleDegrees:Number) : Number
      {
         return angleDegrees * 0.017453292519943295;
      }
      
      public static function randomNumber(low:Number = 0, high:Number = 1) : Number
      {
         return Math.floor(Math.random() * (1 + high - low)) + low;
      }
      
      public static function ruleOf3(x:Number, min:Number, max:Number) : Number
      {
         return x == min ? max : x * max / min;
      }
      
      public static function ruleOf3AsPercentage(v:Number, min:Number, max:Number) : Number
      {
         return 100 * (v - min) / (max - min);
      }
      
      private static function trigInit() : void
      {
         var i:int = 0;
         var rad:Number = NaN;
         smTrigSin = new Vector.<Number>(360);
         smTrigCos = new Vector.<Number>(360);
         for(i = 0; i < 360; )
         {
            rad = i * 0.017453292519943295;
            smTrigSin[i] = Math.sin(rad);
            smTrigCos[i] = Math.cos(rad);
            i++;
         }
      }
      
      public static function pulseInit() : void
      {
         var i:int = 0;
         var rad:Number = NaN;
         var cos:Number = NaN;
         smPulseValues = new Vector.<Number>(150);
         var min:* = 1.7976931348623157e+308;
         var d:Number = 0;
         var value:Number = 0;
         for(i = 0; i < 150; )
         {
            rad = i * 0.017453292519943295;
            cos = Math.cos(rad);
            d += cos * 10;
            if((value = Math.sin(d * 0.017453292519943295) * 50 + cos * 30) < min)
            {
               min = value;
            }
            smPulseValues[i] = value;
            i++;
         }
         for(i = 0; i < 150; )
         {
            smPulseValues[i] = Math.min(1,(smPulseValues[i] - min) / 150);
            i++;
         }
      }
      
      public static function pulseGetValue(currentTime:int, totalTime:int, min:Number = 0, inverse:Boolean = false) : Number
      {
         var index:int = 0;
         var timeRef:* = totalTime >> 1;
         var t:int;
         if((index = (t = totalTime - currentTime) * 150 / timeRef) >= 150)
         {
            index = 150 - (index - 150) - 1;
         }
         return smPulseValues[150 - 1 - index];
      }
      
      public static function simplePulseGetValue(currentTime:int, totalTime:int, min:Number = 0, inverse:Boolean = false) : Number
      {
         var t:int;
         var index:int = (t = totalTime - currentTime) * 180 / totalTime;
         if(inverse)
         {
            index += 90;
         }
         var value:Number;
         var returnValue:* = value = smTrigSin[index % 360];
         if(min > 0)
         {
            if(value > min)
            {
               returnValue = value;
            }
            else if(value < min)
            {
               returnValue = min + value % min;
            }
         }
         return returnValue;
      }
      
      public static function linearPulseGetValue(currentTime:int, totalTime:int, min:Number = 0, inverse:Boolean = false) : Number
      {
         var returnValue:Number = NaN;
         var amplitude:Number = 1 - min;
         var semiTotalTime:Number = totalTime / 2;
         if(inverse)
         {
            currentTime += semiTotalTime;
         }
         currentTime %= totalTime;
         if(currentTime > semiTotalTime)
         {
            returnValue = 1 - (currentTime - semiTotalTime) / semiTotalTime * amplitude;
         }
         else
         {
            returnValue = min + currentTime / semiTotalTime * amplitude;
         }
         return returnValue;
      }
      
      public static function getAngle(v1:*, v2:*) : Number
      {
         var angle:Number = 0;
         if((v1 is Vector3D || v1 is DCCoordinate) && (v2 is Vector3D || v2 is DCCoordinate))
         {
            angle = getAnglePositive(Math.atan2(-(v2.y - v1.y),v2.x - v1.x));
         }
         return angle;
      }
      
      public static function getAnglePositive(angle:Number) : Number
      {
         if(angle < 0)
         {
            angle = 6.283185307179586 + angle;
         }
         return angle;
      }
      
      public static function isClockwise(angleA:Number, angleB:Number) : Boolean
      {
         if(angleA > angleB)
         {
            return Math.abs(angleA - angleB) < angleB + (6.283185307179586 - angleA);
         }
         return angleA + (6.283185307179586 - angleB) < Math.abs(angleB - angleA);
      }
      
      public static function randBetween(min:Number, max:Number) : Number
      {
         return Math.random() * (max - min) + min;
      }
      
      public static function clamp(value:Number, min:Number, max:Number) : Number
      {
         return Math.abs(min - value) < Math.abs(max - value) ? min : max;
      }
      
      public static function initSimpleRand(seed:int = 1679835076) : void
      {
         var counter:int = 0;
         for(counter = 0; counter < smSimpleRandData.length; )
         {
            smSimpleRandData[counter] = smSimpleRandDataSeed[counter] ^ (counter + 1) * seed;
            counter++;
         }
         smSimpleRandInitialized = true;
         smSimpleRandCounter = 0;
      }
      
      public static function simpleRand(max:int) : int
      {
         if(!smSimpleRandInitialized)
         {
            initSimpleRand();
         }
         smSimpleRandData[smSimpleRandCounter % 5] ^= smSimpleRandData[++smSimpleRandCounter % 5];
         if(smSimpleRandCounter > 23)
         {
            smSimpleRandCounter = 0;
         }
         return (smSimpleRandData[smSimpleRandCounter % 5] >> smSimpleRandCounter & 255) * max >> 8;
      }
      
      public static function simpleRandomNumber() : Number
      {
         return simpleRand(1000000) / 1000000;
      }
      
      public static function simpleRandBetween(min:Number, max:Number) : Number
      {
         return simpleRand(max) + min;
      }
      
      public static function simpleRandBetweenNumber(min:Number, max:Number) : Number
      {
         return simpleRandomNumber() * (max - min) + min;
      }
      
      public static function intersectCircleRectangle(circleX:Number, circleY:Number, circleRadius:Number, rectTop:Number, rectLeft:Number, rectBottom:Number, rectRight:Number) : Boolean
      {
         var closestX:Number = clamp(circleX,rectLeft,rectRight);
         var closestY:Number = clamp(circleY,rectTop,rectBottom);
         var distanceX:Number = circleX - closestX;
         var distanceY:Number = circleY - closestY;
         var distanceSquared:Number;
         return (distanceSquared = distanceX * distanceX + distanceY * distanceY) < circleRadius * circleRadius;
      }
   }
}
