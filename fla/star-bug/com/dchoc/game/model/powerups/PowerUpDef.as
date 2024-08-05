package com.dchoc.game.model.powerups
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PowerUpDef extends DCDef
   {
      
      public static const TARGET_ITEMS:String = "items";
       
      
      private var mDuration:SecureNumber;
      
      private var mExtra:SecureNumber;
      
      private var mTarget:SecureString;
      
      private var mSubtarget:SecureString;
      
      private var mType:SecureString;
      
      public function PowerUpDef()
      {
         mDuration = new SecureNumber("PowerUpDef.mDuration");
         mExtra = new SecureNumber("PowerUpDef.mExtra");
         mTarget = new SecureString("PowerUpDef.mTarget");
         mSubtarget = new SecureString("PowerUpDef.mSubtarget");
         mType = new SecureString("PowerUpDef.mType");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "duration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDuration(DCTimerUtil.hourToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setType(EUtils.xmlReadString(info,attribute));
         }
         attribute = "extra";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtra(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "target";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTarget(EUtils.xmlReadString(info,attribute));
         }
         attribute = "subtarget";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSubtarget(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setType(value:String) : void
      {
         this.mType.value = value;
      }
      
      public function getType() : String
      {
         return this.mType.value;
      }
      
      private function setDuration(value:Number) : void
      {
         this.mDuration.value = value;
      }
      
      public function getDuration() : Number
      {
         return this.mDuration.value;
      }
      
      private function setExtra(value:Number) : void
      {
         this.mExtra.value = value;
      }
      
      public function getExtra() : Number
      {
         return this.mExtra.value;
      }
      
      public function getValueWithExtra(value:int) : int
      {
         return value + value * this.mExtra.value / 100;
      }
      
      public function getValueWithExtraAdd(value:Number) : Number
      {
         return value + this.mExtra.value / 100;
      }
      
      private function setTarget(value:String) : void
      {
         this.mTarget.value = value;
      }
      
      public function getTarget() : String
      {
         return this.mTarget.value;
      }
      
      private function setSubtarget(value:String) : void
      {
         this.mSubtarget.value = value;
      }
      
      public function getSubtarget() : String
      {
         return this.mSubtarget.value;
      }
   }
}
