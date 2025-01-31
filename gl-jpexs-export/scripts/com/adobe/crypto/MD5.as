package com.adobe.crypto
{
   import com.adobe.utils.IntUtil;
   import flash.utils.ByteArray;
   
   public class MD5
   {
      
      public static var digest:ByteArray;
       
      
      public function MD5()
      {
         super();
      }
      
      private static function ff(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
      {
         return transform(f,param1,param2,param3,param4,param5,param6,param7);
      }
      
      private static function f(param1:int, param2:int, param3:int) : int
      {
         return param1 & param2 | ~param1 & param3;
      }
      
      private static function g(param1:int, param2:int, param3:int) : int
      {
         return param1 & param3 | param2 & ~param3;
      }
      
      private static function h(param1:int, param2:int, param3:int) : int
      {
         return param1 ^ param2 ^ param3;
      }
      
      private static function i(param1:int, param2:int, param3:int) : int
      {
         return param2 ^ (param1 | ~param3);
      }
      
      private static function transform(param1:Function, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int) : int
      {
         var _loc9_:int = param2 + param1(param3,param4,param5) + param6 + param8;
         return IntUtil.rol(_loc9_,param7) + param3;
      }
      
      private static function hh(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
      {
         return transform(h,param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function hash(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return hashBinary(_loc2_);
      }
      
      private static function createBlocks(param1:ByteArray) : Array
      {
         var _loc3_:Array = [];
         var _loc5_:int = param1.length * 8;
         var _loc4_:int = 255;
         var _loc2_:int = 0;
         while(_loc2_ < _loc5_)
         {
            _loc3_[_loc2_ >> 5] |= (param1[_loc2_ / 8] & _loc4_) << _loc2_ % 32;
            _loc2_ += 8;
         }
         _loc3_[_loc5_ >> 5] |= 128 << _loc5_ % 32;
         _loc3_[(_loc5_ + 64 >>> 9 << 4) + 14] = _loc5_;
         return _loc3_;
      }
      
      public static function hashBinary(param1:ByteArray) : String
      {
         var _loc3_:* = 0;
         var _loc8_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:* = 0;
         var _loc10_:int = 1732584193;
         var _loc12_:int = -271733879;
         var _loc11_:int = -1732584194;
         var _loc5_:int = 271733878;
         var _loc7_:Array;
         var _loc9_:int = int((_loc7_ = createBlocks(param1)).length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc9_)
         {
            _loc3_ = _loc10_;
            _loc8_ = _loc12_;
            _loc6_ = _loc11_;
            _loc2_ = _loc5_;
            _loc10_ = ff(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 0],7,-680876936);
            _loc5_ = ff(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 1],12,-389564586);
            _loc11_ = ff(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 2],17,606105819);
            _loc12_ = ff(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 3],22,-1044525330);
            _loc10_ = ff(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 4],7,-176418897);
            _loc5_ = ff(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 5],12,1200080426);
            _loc11_ = ff(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 6],17,-1473231341);
            _loc12_ = ff(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 7],22,-45705983);
            _loc10_ = ff(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 8],7,1770035416);
            _loc5_ = ff(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 9],12,-1958414417);
            _loc11_ = ff(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 10],17,-42063);
            _loc12_ = ff(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 11],22,-1990404162);
            _loc10_ = ff(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 12],7,1804603682);
            _loc5_ = ff(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 13],12,-40341101);
            _loc11_ = ff(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 14],17,-1502002290);
            _loc12_ = ff(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 15],22,1236535329);
            _loc10_ = gg(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 1],5,-165796510);
            _loc5_ = gg(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 6],9,-1069501632);
            _loc11_ = gg(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 11],14,643717713);
            _loc12_ = gg(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 0],20,-373897302);
            _loc10_ = gg(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 5],5,-701558691);
            _loc5_ = gg(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 10],9,38016083);
            _loc11_ = gg(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 15],14,-660478335);
            _loc12_ = gg(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 4],20,-405537848);
            _loc10_ = gg(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 9],5,568446438);
            _loc5_ = gg(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 14],9,-1019803690);
            _loc11_ = gg(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 3],14,-187363961);
            _loc12_ = gg(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 8],20,1163531501);
            _loc10_ = gg(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 13],5,-1444681467);
            _loc5_ = gg(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 2],9,-51403784);
            _loc11_ = gg(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 7],14,1735328473);
            _loc12_ = gg(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 12],20,-1926607734);
            _loc10_ = hh(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 5],4,-378558);
            _loc5_ = hh(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 8],11,-2022574463);
            _loc11_ = hh(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 11],16,1839030562);
            _loc12_ = hh(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 14],23,-35309556);
            _loc10_ = hh(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 1],4,-1530992060);
            _loc5_ = hh(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 4],11,1272893353);
            _loc11_ = hh(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 7],16,-155497632);
            _loc12_ = hh(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 10],23,-1094730640);
            _loc10_ = hh(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 13],4,681279174);
            _loc5_ = hh(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 0],11,-358537222);
            _loc11_ = hh(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 3],16,-722521979);
            _loc12_ = hh(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 6],23,76029189);
            _loc10_ = hh(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 9],4,-640364487);
            _loc5_ = hh(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 12],11,-421815835);
            _loc11_ = hh(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 15],16,530742520);
            _loc12_ = hh(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 2],23,-995338651);
            _loc10_ = ii(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 0],6,-198630844);
            _loc5_ = ii(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 7],10,1126891415);
            _loc11_ = ii(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 14],15,-1416354905);
            _loc12_ = ii(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 5],21,-57434055);
            _loc10_ = ii(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 12],6,1700485571);
            _loc5_ = ii(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 3],10,-1894986606);
            _loc11_ = ii(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 10],15,-1051523);
            _loc12_ = ii(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 1],21,-2054922799);
            _loc10_ = ii(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 8],6,1873313359);
            _loc5_ = ii(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 15],10,-30611744);
            _loc11_ = ii(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 6],15,-1560198380);
            _loc12_ = ii(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 13],21,1309151649);
            _loc10_ = ii(_loc10_,_loc12_,_loc11_,_loc5_,_loc7_[_loc4_ + 4],6,-145523070);
            _loc5_ = ii(_loc5_,_loc10_,_loc12_,_loc11_,_loc7_[_loc4_ + 11],10,-1120210379);
            _loc11_ = ii(_loc11_,_loc5_,_loc10_,_loc12_,_loc7_[_loc4_ + 2],15,718787259);
            _loc12_ = ii(_loc12_,_loc11_,_loc5_,_loc10_,_loc7_[_loc4_ + 9],21,-343485551);
            _loc10_ += _loc3_;
            _loc12_ += _loc8_;
            _loc11_ += _loc6_;
            _loc5_ += _loc2_;
            _loc4_ += 16;
         }
         digest = new ByteArray();
         digest.writeInt(_loc10_);
         digest.writeInt(_loc12_);
         digest.writeInt(_loc11_);
         digest.writeInt(_loc5_);
         digest.position = 0;
         return IntUtil.toHex(_loc10_) + IntUtil.toHex(_loc12_) + IntUtil.toHex(_loc11_) + IntUtil.toHex(_loc5_);
      }
      
      private static function gg(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
      {
         return transform(g,param1,param2,param3,param4,param5,param6,param7);
      }
      
      private static function ii(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : int
      {
         return transform(i,param1,param2,param3,param4,param5,param6,param7);
      }
      
      public static function hashBytes(param1:ByteArray) : String
      {
         return hashBinary(param1);
      }
   }
}
