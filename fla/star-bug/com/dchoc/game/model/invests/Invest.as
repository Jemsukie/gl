package com.dchoc.game.model.invests
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Transaction;
   import esparragon.utils.EUtils;
   
   public class Invest
   {
      
      public static const STATE_WAITING:int = 0;
      
      public static const STATE_RUNNING:int = 1;
      
      public static const STATE_DONE:int = 2;
      
      public static const STATE_DONE_CLAIMED:int = 4;
      
      public static const STATE_EXPIRED:int = 3;
      
      public static const STATE_DONE_FAILED:int = 6;
       
      
      private var mPlatformId:String = "";
      
      private var mExtId:String = "";
      
      private var mAccountId:String = "-1";
      
      private var mLevel:int = 0;
      
      private var mGoalTimeLeft:int = 0;
      
      private var mState:int = 0;
      
      private var mTransaction:Transaction;
      
      private var mRemindTimeLeft:int = 0;
      
      public function Invest(state:int = 0)
      {
         super();
         this.mState = state;
         this.changeState(this.mState);
      }
      
      public function unbuild() : void
      {
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      public function getPlatformId() : String
      {
         return this.mPlatformId;
      }
      
      private function setPlatformId(value:String) : void
      {
         this.mPlatformId = value;
      }
      
      public function getExtId() : String
      {
         return this.mExtId;
      }
      
      private function setExtId(value:String) : void
      {
         this.mExtId = value;
      }
      
      public function getAccountId() : String
      {
         return this.mAccountId;
      }
      
      private function setAccountId(value:String) : void
      {
         this.mAccountId = value;
      }
      
      public function isAccountIdValid() : Boolean
      {
         return this.mAccountId != "-1";
      }
      
      public function getLevel() : int
      {
         return this.mLevel;
      }
      
      private function setLevel(value:int) : void
      {
         this.mLevel = value;
      }
      
      public function getGoalTimeLeft() : int
      {
         return this.mGoalTimeLeft;
      }
      
      private function setGoalTimeLeft(value:int) : void
      {
         this.mGoalTimeLeft = value;
      }
      
      public function getRemindTimeLeft() : int
      {
         return this.mRemindTimeLeft;
      }
      
      private function setRemindTimeLeft(value:int) : void
      {
         this.mRemindTimeLeft = value;
      }
      
      public function setTransaction(trans:Transaction) : void
      {
         this.mTransaction = trans;
      }
      
      public function getTransaction() : Transaction
      {
         return this.mTransaction;
      }
      
      public function fromXml(investXML:XML) : void
      {
         var attribute:String = "platformId";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setPlatformId(EUtils.xmlReadString(investXML,attribute));
         }
         attribute = "extId";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setExtId(EUtils.xmlReadString(investXML,attribute));
         }
         attribute = "accountId";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setAccountId(EUtils.xmlReadString(investXML,attribute));
         }
         attribute = "level";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setLevel(EUtils.xmlReadInt(investXML,attribute));
         }
         attribute = "timeLeft";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setGoalTimeLeft(EUtils.xmlReadInt(investXML,attribute));
         }
         attribute = "remindTime";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setRemindTimeLeft(EUtils.xmlReadInt(investXML,attribute));
         }
         attribute = "state";
         if(EUtils.xmlIsAttribute(investXML,attribute))
         {
            this.setStatePersistence(EUtils.xmlReadInt(investXML,attribute));
         }
      }
      
      public function remind() : void
      {
         if(this.mState == 0)
         {
            this.mRemindTimeLeft = InstanceMng.getInvestsSettingsDefMng().getRemindTime();
            InstanceMng.getUserDataMng().updateInvest_remind(this.getExtId(),this.getPlatformId());
         }
         else
         {
            this.mRemindTimeLeft = InstanceMng.getInvestsSettingsDefMng().getHurryUpTime();
            InstanceMng.getUserDataMng().updateInvest_hurryUp(this.getAccountId(),this.getExtId());
         }
      }
      
      private function needsToUpdateRemindTimeLeft() : Boolean
      {
         return this.mRemindTimeLeft > 0 && (this.mState == 0 || this.mState == 1);
      }
      
      private function setStatePersistence(statePersistence:int) : void
      {
         var state:int = 0;
         if(statePersistence == -1)
         {
            state = 3;
         }
         else if(statePersistence == 1)
         {
            state = 0;
         }
         else if(statePersistence == 2)
         {
            state = 1;
         }
         else if(statePersistence == 3)
         {
            state = 2;
         }
         else if(statePersistence == 10)
         {
            state = 4;
         }
         else if(statePersistence == 11)
         {
            state = 6;
         }
         this.changeState(state);
      }
      
      private function changeState(newState:int) : void
      {
         this.mState = newState;
      }
      
      public function isDoable() : Boolean
      {
         return this.mState == 2;
      }
      
      public function setClaimed(value:Boolean) : void
      {
         if(value)
         {
            this.changeState(4);
         }
      }
      
      public function isClaimed() : Boolean
      {
         return this.mState == 4;
      }
      
      public function isSuccessfully() : Boolean
      {
         return this.mLevel >= InstanceMng.getInvestsSettingsDefMng().getLevelGoal();
      }
      
      public function isCancellable() : Boolean
      {
         return this.mState == 0 || this.mState == 1 || this.mState == 3;
      }
      
      public function traceContent() : void
      {
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.needsToUpdateRemindTimeLeft())
         {
            this.mRemindTimeLeft -= dt;
            if(this.mRemindTimeLeft < 0)
            {
               this.mRemindTimeLeft = 0;
            }
         }
      }
   }
}
