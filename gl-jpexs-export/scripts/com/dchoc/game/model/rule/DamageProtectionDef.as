package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class DamageProtectionDef extends DCDef
   {
       
      
      private var mMinimumDamageReceived:SecureInt;
      
      private var mDamageProtection:SecureInt;
      
      private var mAttacksReceived:SecureInt;
      
      private var mFromAllPlayers:SecureBoolean;
      
      private var mPeriodTime:SecureInt;
      
      public function DamageProtectionDef()
      {
         mMinimumDamageReceived = new SecureInt("DamageProtectionDef.mMinimumDamageReceived");
         mDamageProtection = new SecureInt("DamageProtectionDef.mDamageProtection");
         mAttacksReceived = new SecureInt("DamageProtectionDef.mAttacksReceived");
         mFromAllPlayers = new SecureBoolean("DamageProtectionDef.mFromAllPlayers");
         mPeriodTime = new SecureInt("DamageProtectionDef.mPeriodTime");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "minimumDamageReceived";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMinimumDamageReceived.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "damageProtection";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mDamageProtection.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "attacksReceived";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mAttacksReceived.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "fromAllPlayers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mFromAllPlayers.value = EUtils.xmlReadBoolean(info,attribute);
         }
         attribute = "periodTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mPeriodTime.value = EUtils.xmlReadInt(info,attribute);
         }
      }
      
      public function getMinimumDamageReceived() : int
      {
         return this.mMinimumDamageReceived.value;
      }
      
      public function getDamageProtection() : int
      {
         return this.mDamageProtection.value;
      }
      
      public function getAttacksReceived() : int
      {
         return this.mAttacksReceived.value;
      }
      
      public function getReceivedAttacksFromAllPlayers() : Boolean
      {
         return this.mFromAllPlayers.value;
      }
      
      public function getPeriodTime() : int
      {
         return this.mPeriodTime.value;
      }
      
      public function setMinDamageReceived(value:Number) : void
      {
         this.mMinimumDamageReceived.value = value;
      }
      
      public function setDamageProtection(value:Number) : void
      {
         this.mDamageProtection.value = value;
      }
      
      public function setAttacksReceived(value:Number) : void
      {
         this.mAttacksReceived.value = value;
      }
      
      public function setFromAllPlayers(value:Number) : void
      {
         this.mFromAllPlayers.value = DCUtils.stringToBoolean(String(value));
      }
      
      public function setPeriodtime(value:Number) : void
      {
         this.mPeriodTime.value = value;
      }
   }
}
