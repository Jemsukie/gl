package com.adobe.utils
{
   public class ArrayUtil
   {
       
      
      public function ArrayUtil()
      {
         super();
      }
      
      public static function arrayContainsValue(arr:Array, value:Object) : Boolean
      {
         return arr.indexOf(value) != -1;
      }
      
      public static function removeValueFromArray(arr:Array, value:Object) : void
      {
         var i:Number = NaN;
         var len:uint = arr.length;
         for(i = len; i > -1; )
         {
            if(arr[i] === value)
            {
               arr.splice(i,1);
            }
            i--;
         }
      }
      
      public static function createUniqueCopy(a:Array) : Array
      {
         var i:* = 0;
         var item:Object = null;
         var newArray:Array = [];
         var len:Number = a.length;
         for(i = 0; i < len; )
         {
            item = a[i];
            if(!ArrayUtil.arrayContainsValue(newArray,item))
            {
               newArray.push(item);
            }
            i++;
         }
         return newArray;
      }
      
      public static function copyArray(arr:Array) : Array
      {
         return arr.slice();
      }
      
      public static function arraysAreEqual(arr1:Array, arr2:Array) : Boolean
      {
         var i:Number = NaN;
         if(arr1.length != arr2.length)
         {
            return false;
         }
         var len:Number = arr1.length;
         for(i = 0; i < len; )
         {
            if(arr1[i] !== arr2[i])
            {
               return false;
            }
            i++;
         }
         return true;
      }
   }
}
