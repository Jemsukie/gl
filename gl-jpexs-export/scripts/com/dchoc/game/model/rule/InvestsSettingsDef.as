package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class InvestsSettingsDef extends DCDef
   {
       
      
      private var mLevelGoal:SecureInt;
      
      private var mGoalTime:SecureNumber;
      
      private var mRemindTime:SecureNumber;
      
      private var mHurryUpTime:SecureNumber;
      
      private var mExtraCash:SecureInt;
      
      private var mUnlockMissionSku:String = "";
      
      private var mRefreshInfoTime:SecureNumber;
      
      public function InvestsSettingsDef()
      {
         mLevelGoal = new SecureInt("InvestsSettingsDef.mLevelGoal",1);
         mGoalTime = new SecureNumber("InvestsSettingsDef.mGoalTime");
         mRemindTime = new SecureNumber("InvestsSettingsDef.mRemindTime");
         mHurryUpTime = new SecureNumber("InvestsSettingsDef.mHurryUpTime");
         mExtraCash = new SecureInt("InvestsSettingsDef.mExtraCash");
         mRefreshInfoTime = new SecureNumber("InvestsSettingsDef.mRefreshInfoTime");
         super();
      }
      
      public function getLevelGoal() : int
      {
         return this.mLevelGoal.value;
      }
      
      private function setLevelGoal(value:int) : void
      {
         this.mLevelGoal.value = value;
      }
      
      public function getGoalTime() : Number
      {
         return this.mGoalTime.value;
      }
      
      private function setGoalTime(value:int) : void
      {
         this.mGoalTime.value = value;
      }
      
      public function getRemindTime() : Number
      {
         return this.mRemindTime.value;
      }
      
      private function setRemindTime(value:Number) : void
      {
         this.mRemindTime.value = value;
      }
      
      public function getHurryUpTime() : Number
      {
         return this.mHurryUpTime.value;
      }
      
      private function setHurryUpTime(value:Number) : void
      {
         this.mHurryUpTime.value = value;
      }
      
      public function getExtraCash() : int
      {
         return this.mExtraCash.value;
      }
      
      private function setExtraCash(value:int) : void
      {
         this.mExtraCash.value = value;
      }
      
      public function getUnlockMissionSku() : String
      {
         return this.mUnlockMissionSku;
      }
      
      private function setUnlockMissionSku(value:String) : void
      {
         this.mUnlockMissionSku = value;
      }
      
      public function getRefreshInfoTime() : int
      {
         return this.mRefreshInfoTime.value;
      }
      
      private function setRefreshInfoTime(value:int) : void
      {
         this.mRefreshInfoTime.value = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "levelGoal";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLevelGoal(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "goalTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setGoalTime(DCTimerUtil.hourToMs(EUtils.xmlReadInt(info,attribute)));
         }
         attribute = "remindTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRemindTime(DCTimerUtil.hourToMs(EUtils.xmlReadInt(info,attribute)));
         }
         attribute = "hurryUpTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHurryUpTime(DCTimerUtil.hourToMs(EUtils.xmlReadInt(info,attribute)));
         }
         attribute = "extraCash";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraCash(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "unlockMissionSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUnlockMissionSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "timeRefreshInfo";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRefreshInfoTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
      }
   }
}
