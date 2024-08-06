package com.dchoc.game.utils.anticheat
{
   import com.dchoc.toolkit.utils.DCUtils;
   import com.reygazu.anticheat.managers.CheatManager;
   
   public dynamic class SecureString
   {
       
      
      private var mBaseValue:String;
      
      private var mStoredValue:String;
      
      private var mName:String;
      
      public function SecureString(name:String = "SecureString", initialValue:String = null)
      {
         super();
         this.mName = name;
         this.internalEncodeString(initialValue);
      }
      
      private function internalEncodeString(data:String) : void
      {
         this.mBaseValue = data;
         this.mStoredValue = DCUtils.simpleStringEncrypt(this.mBaseValue);
      }
      
      private function internalDecodeString() : String
      {
         return DCUtils.simpleStringDecrypt(this.mStoredValue);
      }
      
      private function checkValues() : Boolean
      {
         return this.mBaseValue == this.internalDecodeString();
      }
      
      public function set value(data:String) : void
      {
         if(!this.checkValues())
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         this.internalEncodeString(data);
      }
      
      public function get value() : String
      {
         if(!this.checkValues())
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         return this.internalDecodeString();
      }
   }
}
