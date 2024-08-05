package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class AlliancesSettingsDef extends DCDef
   {
       
      
      private var mCreateAlliancePrice:int = 0;
      
      private var mCreateAllianceCurrency:int = 0;
      
      private var mEditAlliancePrice:int = 0;
      
      private var mEditAllianceCurrency:int = 0;
      
      private var mWarDuration:Number = 0;
      
      private var mMaxMembers:int = 0;
      
      private var mWelcomeId:int = 0;
      
      private var mRemindJoinTime:Number = 0;
      
      private var mHQFactorExponent:Number = 0;
      
      private var mWPBonusFactor:Number = 0;
      
      private var mWPPenaltyFactor:Number = 0;
      
      private var mWPBonusAdjustment:Number = 0;
      
      private var mWPPenaltyAdjustment:Number = 0;
      
      private var mMinimumPlayerLevel:int = 0;
      
      private var mMinimumHQLevel:int = 0;
      
      private var mLooserShieldTime:Number;
      
      private var mWinnerShieldTime:Number;
      
      private var mRefreshInfoTime:Number;
      
      public function AlliancesSettingsDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "createPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCreateAlliancePrice(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "createResource";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCreateAllianceCurrency(EUtils.xmlReadString(info,attribute));
         }
         attribute = "modifyPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEditAlliancePrice(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "modifyResource";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEditAllianceCurrency(EUtils.xmlReadString(info,attribute));
         }
         attribute = "warDuration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWarDuration(DCTimerUtil.hourToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "allianceSize";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxMembers(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "alliancesWelcomeId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAllianceWelcomeId(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "remindJoinTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRemindJoinTime(DCTimerUtil.hourToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "hqFactorExponent";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHQFactorExponent(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "wpBonusFactor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWPBonusFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "wpPenaltyFactor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWPPenaltyFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "wpBonusAdjustment";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWPBonusAdjustment(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "wpPenaltyAdjustment";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWPPenaltyAdjustment(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minimumPlayerLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinimumPlayerLevel(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "minimumHQLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinimumHQLevel(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "looserShieldTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLooserShieldTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "winnerShieldTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWinnerShieldTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "timeRefreshInfo";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRefreshInfoTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
      }
      
      public function getRefreshInfoTime() : int
      {
         return this.mRefreshInfoTime;
      }
      
      private function setRefreshInfoTime(value:int) : void
      {
         this.mRefreshInfoTime = value;
      }
      
      public function getLooserShieldTime() : Number
      {
         return this.mLooserShieldTime;
      }
      
      private function setLooserShieldTime(value:Number) : void
      {
         this.mLooserShieldTime = value;
      }
      
      public function getWinnerShieldTime() : Number
      {
         return this.mWinnerShieldTime;
      }
      
      private function setWinnerShieldTime(value:Number) : void
      {
         this.mWinnerShieldTime = value;
      }
      
      private function setRemindJoinTime(value:Number) : void
      {
         this.mRemindJoinTime = value;
      }
      
      public function getRemindJoinTime() : Number
      {
         return this.mRemindJoinTime;
      }
      
      public function getRemindInvitationTime() : Number
      {
         return this.mRemindJoinTime;
      }
      
      private function setCreateAlliancePrice(value:int) : void
      {
         this.mCreateAlliancePrice = value;
      }
      
      public function getCreateAlliancePrice() : int
      {
         return this.mCreateAlliancePrice;
      }
      
      private function setCreateAllianceCurrency(currency:String) : void
      {
         this.mCreateAllianceCurrency = GameConstants.currencyGetIdFromKey(currency);
      }
      
      public function getCreateAllianceCurrency() : int
      {
         return this.mCreateAllianceCurrency;
      }
      
      private function setEditAlliancePrice(value:int) : void
      {
         this.mEditAlliancePrice = value;
      }
      
      public function getEditAlliancePrice() : int
      {
         return this.mEditAlliancePrice;
      }
      
      private function setEditAllianceCurrency(currency:String) : void
      {
         this.mEditAllianceCurrency = GameConstants.currencyGetIdFromKey(currency);
      }
      
      public function getEditAllianceCurrency() : int
      {
         return this.mEditAllianceCurrency;
      }
      
      private function setWarDuration(value:Number) : void
      {
         this.mWarDuration = value;
      }
      
      public function getWarDuration() : Number
      {
         return this.mWarDuration;
      }
      
      private function setMaxMembers(value:int) : void
      {
         this.mMaxMembers = value;
      }
      
      public function getMaxMembers() : int
      {
         return this.mMaxMembers;
      }
      
      private function setAllianceWelcomeId(value:int) : void
      {
         this.mWelcomeId = value;
      }
      
      public function getWelcomeId() : int
      {
         return this.mWelcomeId;
      }
      
      private function setMinimumPlayerLevel(value:int) : void
      {
         this.mMinimumPlayerLevel = value;
      }
      
      public function getMinimumPlayerLevel() : int
      {
         return this.mMinimumPlayerLevel;
      }
      
      private function setMinimumHQLevel(value:int) : void
      {
         this.mMinimumHQLevel = value;
      }
      
      public function getMinimumHQLevel() : int
      {
         return this.mMinimumHQLevel;
      }
      
      private function setHQFactorExponent(value:Number) : void
      {
         this.mHQFactorExponent = value;
      }
      
      public function getHQFactorExponent() : Number
      {
         return this.mHQFactorExponent;
      }
      
      private function setWPBonusFactor(value:Number) : void
      {
         this.mWPBonusFactor = value;
      }
      
      public function getWPBonusFactor() : Number
      {
         return this.mWPBonusFactor;
      }
      
      private function setWPPenaltyFactor(value:Number) : void
      {
         this.mWPPenaltyFactor = value;
      }
      
      public function getWPPenaltyFactor() : Number
      {
         return this.mWPPenaltyFactor;
      }
      
      private function setWPBonusAdjustment(value:Number) : void
      {
         this.mWPBonusAdjustment = value;
      }
      
      public function getWPBonusAdjustment() : Number
      {
         return this.mWPBonusAdjustment;
      }
      
      private function setWPPenaltyAdjustment(value:Number) : void
      {
         this.mWPPenaltyAdjustment = value;
      }
      
      public function getWPPenaltyAdjustment() : Number
      {
         return this.mWPPenaltyAdjustment;
      }
   }
}
