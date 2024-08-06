package com.phoenix.crypto
{
   import flash.utils.ByteArray;
   
   public class ARC4
   {
       
      
      private var i:int = 0;
      
      private var j:int = 0;
      
      private var S:ByteArray;
      
      public function ARC4(key:ByteArray = null)
      {
         super();
         S = new ByteArray();
         if(key)
         {
            init(key);
         }
      }
      
      public function init(key:ByteArray) : void
      {
         var i:int = 0;
         var j:* = 0;
         var t:int = 0;
         for(i = 0; i < 256; )
         {
            S[i] = i;
            i++;
         }
         j = 0;
         for(i = 0; i < 256; )
         {
            j = j + S[i] + key[i % key.length] & 255;
            t = int(S[i]);
            S[i] = S[j];
            S[j] = t;
            i++;
         }
         this.i = 0;
         this.j = 0;
      }
      
      public function next() : uint
      {
         var t:int = 0;
         i = i + 1 & 255;
         j = j + S[i] & 255;
         t = int(S[i]);
         S[i] = S[j];
         S[j] = t;
         return S[t + S[i] & 255];
      }
      
      public function encrypt(block:ByteArray) : void
      {
         var i:uint = 0;
         while(i < block.length)
         {
            var _loc3_:* = i++;
            var _loc4_:* = block[_loc3_] ^ next();
            block[_loc3_] = _loc4_;
         }
      }
      
      public function decrypt(block:ByteArray) : void
      {
         encrypt(block);
      }
      
      public function dispose() : void
      {
         var i:uint = 0;
         if(S != null)
         {
            for(i = 0; i < S.length; )
            {
               S[i] = Math.random() * 256;
               i++;
            }
            S.length = 0;
            S = null;
         }
         this.i = 0;
         this.j = 0;
      }
   }
}
