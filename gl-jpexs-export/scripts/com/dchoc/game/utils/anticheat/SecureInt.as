package com.dchoc.game.utils.anticheat
{
   import com.reygazu.anticheat.managers.CheatManager;
   
   public class SecureInt
   {
       
      
      private var mBaseValue:int;
      
      private var mStoredValue:int;
      
      private var mKey:int;
      
      private var mName:String;
      
      public function SecureInt(name:String = "SecureInt", initialValue:int = 0)
      {
         super();
         this.mName = name;
         this.mBaseValue = initialValue;
         this.mKey = Math.random() * 2147483647 + 1;
         this.mStoredValue = this.mBaseValue ^ this.mKey;
      }
      
      public function set value(data:int) : void
      {
         if((this.mStoredValue ^ this.mKey) != this.mBaseValue)
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         this.mBaseValue = data;
         this.mKey = Math.random() * 2147483647 + 1;
         data ^= this.mKey;
         this.mStoredValue = data;
      }
      
      public function get value() : int
      {
         if((this.mStoredValue ^ this.mKey) != this.mBaseValue)
         {
            CheatManager.getInstance().detectCheat(this.mName,this.mBaseValue,this.mStoredValue);
         }
         return this.mStoredValue ^ this.mKey;
      }
   }
}
