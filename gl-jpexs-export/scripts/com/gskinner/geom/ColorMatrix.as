package com.gskinner.geom
{
   public dynamic class ColorMatrix extends Array
   {
      
      private static const DELTA_INDEX:Array = [0,0.01,0.02,0.04,0.05,0.06,0.07,0.08,0.1,0.11,0.12,0.14,0.15,0.16,0.17,0.18,0.2,0.21,0.22,0.24,0.25,0.27,0.28,0.3,0.32,0.34,0.36,0.38,0.4,0.42,0.44,0.46,0.48,0.5,0.53,0.56,0.59,0.62,0.65,0.68,0.71,0.74,0.77,0.8,0.83,0.86,0.89,0.92,0.95,0.98,1,1.06,1.12,1.18,1.24,1.3,1.36,1.42,1.48,1.54,1.6,1.66,1.72,1.78,1.84,1.9,1.96,2,2.12,2.25,2.37,2.5,2.62,2.75,2.87,3,3.2,3.4,3.6,3.8,4,4.3,4.7,4.9,5,5.5,6,6.5,6.8,7,7.3,7.5,7.8,8,8.4,8.7,9,9.4,9.6,9.8,10];
      
      private static const IDENTITY_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1];
      
      private static const LENGTH:Number = IDENTITY_MATRIX.length;
       
      
      public function ColorMatrix(matrix:Array = null)
      {
         super();
         matrix = this.fixMatrix(matrix);
         this.copyMatrix(matrix.length == LENGTH ? matrix : IDENTITY_MATRIX);
      }
      
      public function reset() : void
      {
         var i:* = 0;
         for(i = 0; i < LENGTH; )
         {
            this[i] = IDENTITY_MATRIX[i];
            i++;
         }
      }
      
      public function adjustColor(brightness:Number, contrast:Number, saturation:Number, hue:Number) : void
      {
         this.adjustHue(hue);
         this.adjustContrast(contrast);
         this.adjustBrightness(brightness);
         this.adjustSaturation(saturation);
      }
      
      public function adjustBrightness(value:Number) : void
      {
         value = this.cleanValue(value,255);
         if(value == 0 || isNaN(value))
         {
            return;
         }
         this.multiplyMatrix([1,0,0,0,value,0,1,0,0,value,0,0,1,0,value,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustContrast(value:Number) : void
      {
         var x:Number = NaN;
         value = this.cleanValue(value,100);
         if(value == 0 || isNaN(value))
         {
            return;
         }
         if(value < 0)
         {
            x = 127 + value / 100 * 127;
         }
         else
         {
            x = value % 1;
            if(x == 0)
            {
               x = Number(DELTA_INDEX[value]);
            }
            else
            {
               x = DELTA_INDEX[value << 0] * (1 - x) + DELTA_INDEX[(value << 0) + 1] * x;
            }
            x = x * 127 + 127;
         }
         this.multiplyMatrix([x / 127,0,0,0,0.5 * (127 - x),0,x / 127,0,0,0.5 * (127 - x),0,0,x / 127,0,0.5 * (127 - x),0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustSaturation(value:Number) : void
      {
         value = this.cleanValue(value,100);
         if(value == 0 || isNaN(value))
         {
            return;
         }
         var x:Number = 1 + (value > 0 ? 3 * value / 100 : value / 100);
         var lumR:Number = 0.3086;
         var lumG:Number = 0.6094;
         var lumB:Number = 0.082;
         this.multiplyMatrix([lumR * (1 - x) + x,lumG * (1 - x),lumB * (1 - x),0,0,lumR * (1 - x),lumG * (1 - x) + x,lumB * (1 - x),0,0,lumR * (1 - x),lumG * (1 - x),lumB * (1 - x) + x,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function adjustHue(value:Number) : void
      {
         value = this.cleanValue(value,180) / 180 * 3.141592653589793;
         if(value == 0 || isNaN(value))
         {
            return;
         }
         var cosVal:Number = Math.cos(value);
         var sinVal:Number = Math.sin(value);
         var lumR:Number = 0.213;
         var lumG:Number = 0.715;
         var lumB:Number = 0.072;
         this.multiplyMatrix([lumR + cosVal * (1 - lumR) + sinVal * -lumR,lumG + cosVal * -lumG + sinVal * -lumG,lumB + cosVal * -lumB + sinVal * (1 - lumB),0,0,lumR + cosVal * -lumR + sinVal * 0.143,lumG + cosVal * (1 - lumG) + sinVal * 0.14,lumB + cosVal * -lumB + sinVal * -0.283,0,0,lumR + cosVal * -lumR + sinVal * -(1 - lumR),lumG + cosVal * -lumG + sinVal * lumG,lumB + cosVal * (1 - lumB) + sinVal * lumB,0,0,0,0,0,1,0,0,0,0,0,1]);
      }
      
      public function concat(matrix:Array) : void
      {
         matrix = this.fixMatrix(matrix);
         if(matrix.length != LENGTH)
         {
            return;
         }
         this.multiplyMatrix(matrix);
      }
      
      public function clone() : ColorMatrix
      {
         return new ColorMatrix(this);
      }
      
      public function toString() : String
      {
         return "ColorMatrix [ " + this.join(" , ") + " ]";
      }
      
      public function toArray() : Array
      {
         return slice(0,20);
      }
      
      protected function copyMatrix(matrix:Array) : void
      {
         var i:* = 0;
         var l:Number = LENGTH;
         for(i = 0; i < l; )
         {
            this[i] = matrix[i];
            i++;
         }
      }
      
      protected function multiplyMatrix(matrix:Array) : void
      {
         var i:* = 0;
         var j:uint = 0;
         var val:Number = NaN;
         var k:Number = NaN;
         var col:Array = [];
         for(i = 0; i < 5; )
         {
            for(j = 0; j < 5; )
            {
               col[j] = this[j + i * 5];
               j++;
            }
            for(j = 0; j < 5; )
            {
               val = 0;
               for(k = 0; k < 5; )
               {
                  val += matrix[j + k * 5] * col[k];
                  k++;
               }
               this[j + i * 5] = val;
               j++;
            }
            i++;
         }
      }
      
      protected function cleanValue(value:Number, limit:Number) : Number
      {
         return Math.min(limit,Math.max(-limit,value));
      }
      
      protected function fixMatrix(matrix:Array = null) : Array
      {
         if(matrix == null)
         {
            return IDENTITY_MATRIX;
         }
         if(matrix is ColorMatrix)
         {
            matrix = matrix.slice(0);
         }
         if(matrix.length < LENGTH)
         {
            matrix = matrix.slice(0,matrix.length).concat(IDENTITY_MATRIX.slice(matrix.length,LENGTH));
         }
         else if(matrix.length > LENGTH)
         {
            matrix = matrix.slice(0,LENGTH);
         }
         return matrix;
      }
   }
}
