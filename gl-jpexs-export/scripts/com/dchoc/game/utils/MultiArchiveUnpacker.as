package com.dchoc.game.utils
{
   import flash.utils.ByteArray;
   
   public class MultiArchiveUnpacker
   {
       
      
      private var contentsMap:Object;
      
      public function MultiArchiveUnpacker(input:ByteArray, isCompressed:Boolean)
      {
         var f:int = 0;
         var keySize:* = 0;
         var key:String = null;
         var k:int = 0;
         var size:* = 0;
         var data:ByteArray = null;
         var i:int = 0;
         super();
         this.contentsMap = {};
         if(isCompressed)
         {
            input.uncompress("zlib");
         }
         var index:int = 0;
         var numOfFiles:* = (input[index++] & 255) << 24 | (input[index++] & 255) << 16 | (input[index++] & 255) << 8 | input[index++] & 255;
         for(f = 0; f < numOfFiles; )
         {
            keySize = input[index++] & 255;
            key = "";
            for(k = 0; k < keySize; )
            {
               key += String.fromCharCode(input[index++] & 255);
               k++;
            }
            size = (input[index++] & 255) << 24 | (input[index++] & 255) << 16 | (input[index++] & 255) << 8 | input[index++] & 255;
            data = new ByteArray();
            for(i = 0; i < size; )
            {
               data[i] = input[index++];
               i++;
            }
            this.contentsMap[key] = data;
            f++;
         }
      }
      
      public function getArchive(key:String) : String
      {
         if(this.contentsMap.hasOwnProperty(key))
         {
            return new String(this.contentsMap[key]);
         }
         return null;
      }
      
      public function getBinary(key:String) : ByteArray
      {
         if(this.contentsMap.hasOwnProperty(key))
         {
            return this.contentsMap[key];
         }
         return null;
      }
   }
}
