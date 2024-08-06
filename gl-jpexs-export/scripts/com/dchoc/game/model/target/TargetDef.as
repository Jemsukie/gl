package com.dchoc.game.model.target
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import esparragon.utils.EUtils;
   
   public class TargetDef extends DCTargetDef
   {
      
      public static const FIELD_REWARD_PC:String = "reward";
       
      
      private var mRewardCoins:SecureNumber;
      
      private var mRewardMinerals:SecureNumber;
      
      private var mRewardXp:SecureNumber;
      
      private var mRewardItemSku:SecureString;
      
      private var mTracking:SecureString;
      
      private var mHiddenInHud:Boolean = false;
      
      private var mRepeatable:Boolean = false;
      
      private var mSkipMissionInfoPopup:Boolean = false;
      
      private var mStoryMissionId:SecureInt;
      
      public function TargetDef()
      {
         mRewardCoins = new SecureNumber("TargetDef.mRewardCoins");
         mRewardMinerals = new SecureNumber("TargetDef.mRewardMinerals");
         mRewardXp = new SecureNumber("TargetDef.mRewardXp");
         mRewardItemSku = new SecureString("TargetDef.mRewardItemSku","");
         mTracking = new SecureString("TargetDef.mTracking","");
         mStoryMissionId = new SecureInt("TargetDef.mStoryMissionId");
         super();
      }
      
      override public function isThisStateUseful(stateId:int) : Boolean
      {
         if(this.getHiddenInHud() == true && stateId == 1)
         {
            return false;
         }
         return true;
      }
      
      public function getRewardCoins() : Number
      {
         return this.mRewardCoins.value;
      }
      
      public function getRewardMinerals() : Number
      {
         return this.mRewardMinerals.value;
      }
      
      public function getRewardCash() : Number
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"reward").mAmount;
      }
      
      public function getRewardXp() : Number
      {
         return this.mRewardXp.value;
      }
      
      public function skipMissionInfoPopup() : Boolean
      {
         return this.mSkipMissionInfoPopup;
      }
      
      public function getRewardItemSku(onlySku:Boolean = true) : String
      {
         var returnValue:String = null;
         var rewardArr:Array = this.mRewardItemSku.value.split(":");
         return String(onlySku ? rewardArr[0] : this.mRewardItemSku.value);
      }
      
      public function getTrackingEvent() : String
      {
         return this.mTracking.value;
      }
      
      public function getHiddenInHud() : Boolean
      {
         return this.mHiddenInHud;
      }
      
      public function getRepeatable() : Boolean
      {
         return this.mRepeatable;
      }
      
      public function isStoryMission() : Boolean
      {
         return this.mStoryMissionId.value != 0;
      }
      
      public function getStoryMission() : int
      {
         return this.mStoryMissionId.value;
      }
      
      private function setRewardCoins(value:Number) : void
      {
         this.mRewardCoins.value = value;
      }
      
      private function setRewardMinerals(value:Number) : void
      {
         this.mRewardMinerals.value = value;
      }
      
      private function setRewardXp(value:Number) : void
      {
         this.mRewardXp.value = value;
      }
      
      private function setSkipMissionInfoPopup(value:Boolean) : void
      {
         this.mSkipMissionInfoPopup = value;
      }
      
      private function setRewardItemSku(value:String) : void
      {
         this.mRewardItemSku.value = value;
      }
      
      private function setTrackingEvent(value:String) : void
      {
         this.mTracking.value = value;
      }
      
      private function setHiddenInHud(value:Boolean) : void
      {
         this.mHiddenInHud = value;
      }
      
      private function setRepeatable(value:Boolean) : void
      {
         this.mRepeatable = value;
      }
      
      private function setStoryMissionId(value:int) : void
      {
         this.mStoryMissionId.value = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "rewardCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "rewardMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardMinerals(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "rewardXp";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardXp(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "rewardItemSkuList";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardItemSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tracking";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTrackingEvent(EUtils.xmlReadString(info,attribute));
         }
         attribute = "storyMissionId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setStoryMissionId(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "achievementTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            InstanceMng.getTargetDefMng().addAchievement(mSku);
         }
         this.setHiddenInHud(EUtils.xmlReadBoolean(info,"hiddenInHud"));
         this.setRepeatable(EUtils.xmlReadBoolean(info,"repeatable"));
         this.setSkipMissionInfoPopup(EUtils.xmlReadBoolean(info,"skipMissionInfoPopup"));
         paidCurrencyRead("reward",info);
         if(getConditionOriginal() == "shipsSelectedForBattle")
         {
            setAmount(1);
         }
      }
   }
}
