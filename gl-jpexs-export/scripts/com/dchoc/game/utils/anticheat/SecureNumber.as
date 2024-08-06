package com.dchoc.game.utils.anticheat
{
   import com.reygazu.anticheat.managers.CheatManager;
   import flash.utils.ByteArray;
   
   public class SecureNumber
   {
      
      private static var mByteArray:ByteArray = new ByteArray();
       
      
      private var mBaseValue:Number;
      
      private var mStoredValue:Number;
      
      private var mKey:int;
      
      private var mName:String;
      
      public function SecureNumber(name:String = "SecureNumber", initialValue:Number = 0)
      {
         super();
         this.mName = name;
         this.internalEncodeNumber(initialValue);
      }
      
      private function internalEncodeNumber(data:Number) : void
      {
         this.mBaseValue = data;
         this.mKey = Math.random() * 2147483647 + 1;
         mByteArray.position = 0;
         mByteArray.writeDouble(this.mBaseValue);
         mByteArray.position = 4;
         var integerHalf:* = mByteArray.readInt();
         integerHalf ^= this.mKey;
         mByteArray.position = 4;
         mByteArray.writeInt(integerHalf);
         mByteArray.position = 0;
         this.mStoredValue = mByteArray.readDouble();
      }
      
      private function internalDecodeNumber() : Number
      {
         mByteArray.position = 0;
         mByteArray.writeDouble(this.mStoredValue);
         mByteArray.position = 4;
         var integerHalf:* = mByteArray.readInt();
         integerHalf ^= this.mKey;
         mByteArray.position = 4;
         mByteArray.writeInt(integerHalf);
         mByteArray.position = 0;
         return mByteArray.readDouble();
      }
      
      private function checkValues() : Boolean
      {
         return this.mBaseValue == this.internalDecodeNumber();
      }
      
      public function set value(data:Number) : void
      {
         if(!this.checkValues())
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         this.internalEncodeNumber(data);
      }
      
      public function get value() : Number
      {
         if(!this.checkValues())
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         return this.internalDecodeNumber();
      }
   }
}
