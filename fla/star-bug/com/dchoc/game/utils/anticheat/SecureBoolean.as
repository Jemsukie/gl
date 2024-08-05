package com.dchoc.game.utils.anticheat
{
   import com.reygazu.anticheat.managers.CheatManager;
   
   public class SecureBoolean
   {
       
      
      private var mBaseValue:int;
      
      private var mStoredValue:int;
      
      private var mKey:int;
      
      private var mName:String;
      
      public function SecureBoolean(name:String = "SecureBoolean", initialValue:Boolean = false)
      {
         super();
         this.mName = name;
         this.mBaseValue = int(initialValue) << 10;
         this.mKey = Math.random() * 2147483647 + 1;
         this.mStoredValue = this.mBaseValue ^ this.mKey;
      }
      
      public function set value(data:Boolean) : void
      {
         if((this.mStoredValue ^ this.mKey) != this.mBaseValue)
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         this.mBaseValue = int(data) << 10;
         this.mKey = Math.random() * 2147483647 + 1;
         this.mStoredValue = this.mBaseValue ^ this.mKey;
      }
      
      public function get value() : Boolean
      {
         if((this.mStoredValue ^ this.mKey) != this.mBaseValue)
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         return Boolean(this.mStoredValue ^ this.mKey);
      }
   }
}
