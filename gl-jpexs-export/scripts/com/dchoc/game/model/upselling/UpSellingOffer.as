package com.dchoc.game.model.upselling
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import esparragon.utils.EUtils;
   
   public class UpSellingOffer
   {
      
      private static const STATE_TO_BE_STARTED:int = 0;
      
      private static const STATE_RUNNING:int = 1;
      
      private static const STATE_FINISHED:int = 10;
       
      
      private var mSku:SecureString;
      
      private var mState:SecureInt;
      
      private var mTimeLeft:SecureNumber;
      
      private var mReward:SecureString;
      
      private var mRewardEntry:Entry;
      
      private var mStartedAt:SecureNumber;
      
      public function UpSellingOffer()
      {
         mSku = new SecureString("UpSellingOffer.mSku");
         mState = new SecureInt("UpSellingOffer.mState");
         mTimeLeft = new SecureNumber("UpSellingOffer.mTimeLeft");
         mReward = new SecureString("UpSellingOffer.mReward");
         mStartedAt = new SecureNumber("UpSellingOffer.mStartedAt");
         super();
      }
      
      public function destroy() : void
      {
         this.mSku.value = null;
         this.mReward.value = null;
      }
      
      public function fromXml(xml:XML) : void
      {
         this.setSku(EUtils.xmlReadString(xml,"sku"));
         var attribute:String = "state";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setState(EUtils.xmlReadInt(xml,attribute));
         }
         attribute = "timeLeft";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setTimeLeft(EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "rewardItem";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setReward(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "startedAt";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setStartedAt(EUtils.xmlReadNumber(xml,attribute));
         }
         this.logicUpdate(0);
      }
      
      public function getSku() : String
      {
         return this.mSku.value;
      }
      
      private function setSku(value:String) : void
      {
         this.mSku.value = value;
      }
      
      private function setState(value:int) : void
      {
         this.mState.value = value;
      }
      
      public function getTimeLeft() : Number
      {
         return this.mTimeLeft.value;
      }
      
      private function setTimeLeft(value:Number) : void
      {
         this.mTimeLeft.value = value;
      }
      
      public function getReward() : String
      {
         return this.mReward.value;
      }
      
      public function getRewardEntry() : Entry
      {
         if(this.mRewardEntry == null)
         {
            this.mRewardEntry = EntryFactory.createSingleEntryFromString(this.mReward.value);
         }
         return this.mRewardEntry;
      }
      
      private function setReward(value:String) : void
      {
         this.mReward.value = value;
      }
      
      private function setStartedAt(value:Number) : void
      {
         this.mStartedAt.value = value;
      }
      
      public function getStartedAt() : Number
      {
         return this.mStartedAt.value;
      }
      
      public function canBeStarted() : Boolean
      {
         return this.mState.value == 0;
      }
      
      public function isRunning() : Boolean
      {
         return this.mState.value == 1;
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mState.value == 1)
         {
            if(this.mTimeLeft.value > 0)
            {
               this.mTimeLeft.value -= dt;
            }
            if(this.mTimeLeft.value <= 0)
            {
               this.setState(10);
            }
         }
      }
      
      public function start() : void
      {
         this.setState(1);
         this.setTimeLeft(InstanceMng.getSettingsDefMng().getUpSellingDuration());
      }
   }
}
