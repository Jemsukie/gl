package com.dchoc.game.model.contest
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.contest.PopupContest;
   import com.dchoc.game.eview.widgets.contest.PopupContestResults;
   import com.dchoc.game.model.userdata.PendingTransaction;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.core.Esparragon;
   import flash.utils.Dictionary;
   
   public class ContestMng extends DCComponent
   {
      
      private static const TIME_INCREMENT_ASK_FOR_CONTEST:Number = DCTimerUtil.daysToMs(1);
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_IDLE:int = 0;
      
      private static const STATE_RUNNING:int = 1;
      
      private static const STATE_SHOW_RESULTS:int = 2;
      
      public static const NOTIFICATIONS_REQUEST_CONTEST:String = "requestContest";
      
      public static const NOTIFICATIONS_REQUEST_PROGRESS:String = "requestProgress";
      
      public static const NOTIFICATIONS_REQUEST_LEADERBOARD:String = "requestLeaderboard";
      
      public static const NOTIFICATIONS_PROGRESS_NEEDS_UPDATE:String = "progressNeedsUpdate";
      
      public static const NOTIFICATIONS_COMMANDS_FLUSHED:String = "commandsFlushed";
      
      private static const REWARD_STATE_INVALID:int = -1;
      
      private static const REWARD_STATE_WAITING_FOR_BEING_SHOWN:int = 0;
      
      private static const REWARD_STATE_BEING_SHOWN:int = 1;
      
      private static const USER_TEST_FINISH_LOST:Boolean = false;
      
      private static const USER_TEST_FINISH:Boolean = false;
      
      private static const GUI_SKIN_ID:String = null;
       
      
      private var mCurrContestInHud:SecureString;
      
      private var mCurrHudElement:SecureBoolean;
      
      private var mContestType:SecureString;
      
      private var mContestDef:ContestDef;
      
      private var mStartTime:SecureNumber;
      
      private var mEndTime:SecureNumber;
      
      private var mExpiryTime:SecureNumber;
      
      private var mAskForContestTime:SecureNumber;
      
      private var mOldState:SecureInt;
      
      private var mState:SecureInt;
      
      private var mNotificationsSuccess:Dictionary;
      
      private var mNotificationsFailed:Dictionary;
      
      private var mHudWaitingForCommandsToBeFlushed:SecureBoolean;
      
      private var mHudNeedsToOpenContestPopup:SecureBoolean;
      
      private var mRewardsAsEntryString:Dictionary;
      
      private var mRewardsToGive:Dictionary;
      
      private var mRewardsForView:Vector.<ContestReward>;
      
      private var mRewardsToGiveHasChanged:SecureBoolean;
      
      private var mUser:ContestUser;
      
      private var mUserShowLostPopup:SecureBoolean;
      
      private var mUserShowClickMeOnIcon:SecureBoolean;
      
      private var mUserShowClickMeOnIconIsAllowed:SecureBoolean;
      
      private var mUserRequestIsAllowed:SecureBoolean;
      
      private var mUserProgressLastTime:SecureNumber;
      
      private var mLeaderboardUsers:Vector.<ContestUser>;
      
      private var mLeaderboardLastTime:SecureNumber;
      
      public function ContestMng()
      {
         mCurrContestInHud = new SecureString("ContestMng.mCurrContestInHud");
         mCurrHudElement = new SecureBoolean("ContestMng.mCurrHudElement");
         mContestType = new SecureString("ContestMng.mContestType");
         mStartTime = new SecureNumber("ContestMng.mStartTime");
         mEndTime = new SecureNumber("ContestMng.mEndTime");
         mExpiryTime = new SecureNumber("ContestMng.mExpiryTime");
         mAskForContestTime = new SecureNumber("ContestMng.mAskForContestTime");
         mOldState = new SecureInt("ContestMng.mOldState",-1);
         mState = new SecureInt("ContestMng.mState",-1);
         mHudWaitingForCommandsToBeFlushed = new SecureBoolean("ContestMng.mHudWaitingForCommandsToBeFlushed");
         mHudNeedsToOpenContestPopup = new SecureBoolean("ContestMng.mHudNeedsToOpenContestPopup");
         mRewardsToGiveHasChanged = new SecureBoolean("ContestMng.mRewardsToGiveHasChanged");
         mUserShowLostPopup = new SecureBoolean("ContestMng.mUserShowLostPopup");
         mUserShowClickMeOnIcon = new SecureBoolean("ContestMng.mUserShowClickMeOnIcon");
         mUserShowClickMeOnIconIsAllowed = new SecureBoolean("ContestMng.mUserShowClickMeOnIconIsAllowed",true);
         mUserRequestIsAllowed = new SecureBoolean("ContestMng.mUserRequestIsAllowed",true);
         mUserProgressLastTime = new SecureNumber("ContestMng.mUserProgressLastTime");
         mLeaderboardLastTime = new SecureNumber("ContestMng.mLeaderboardLastTime");
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
         this.mAskForContestTime.value = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mNotificationsSuccess = new Dictionary();
            this.mNotificationsFailed = new Dictionary();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mNotificationsSuccess = null;
         this.mNotificationsFailed = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
      }
      
      override public function isRunning() : Boolean
      {
         return Config.useContests() && InstanceMng.getApplication().isTutorialCompleted() && InstanceMng.getFlowState().getCurrentRoleId() == 0 && InstanceMng.getApplication().viewGetMode() == 0 && !InstanceMng.getUnitScene().battleIsRunning() && !InstanceMng.getApplication().fsmGetCurrentState().isALoadingState();
      }
      
      public function getCurrentContestSku() : String
      {
         if(this.mContestDef == null)
         {
            return null;
         }
         return this.mContestDef.mSku;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var currentMS:Number = NaN;
         var timeLeft:Number = NaN;
         var timeLeftStr:String = null;
         var k:* = null;
         var state:int = 0;
         var contestIdToShow:* = null;
         var rewardToShowAllowed:Boolean = false;
         var contestId:String = null;
         if(this.isRunning())
         {
            currentMS = this.getNowTime();
            switch(this.mState.value - -1)
            {
               case 0:
                  if(currentMS >= this.mAskForContestTime.value)
                  {
                     this.incrementAskForContestTime();
                     this.requestContest(this.onRequestContest,this.onRequestContestFailed);
                  }
                  break;
               case 1:
                  if(currentMS >= this.mStartTime.value)
                  {
                     this.stateChangeState(1);
                  }
                  break;
               case 2:
                  if(currentMS >= this.mEndTime.value)
                  {
                     this.contestSetFinished(true);
                  }
                  else if(!this.mUserShowClickMeOnIcon.value)
                  {
                     timeLeft = this.getRunningTimeLeft();
                     timeLeftStr = DCTextMng.getCountdownTime(timeLeft);
                     InstanceMng.getUIFacade().setContestIconTip(timeLeftStr);
                  }
                  break;
               case 3:
                  if(currentMS >= this.mExpiryTime.value)
                  {
                     this.stateChangeState(-1);
                     break;
                  }
            }
            if(this.mRewardsToGiveHasChanged.value)
            {
               contestIdToShow = null;
               rewardToShowAllowed = true;
               for(k in this.mRewardsToGive)
               {
                  contestId = k;
                  if((state = this.rewardsToGiveGetState(contestId)) == 1)
                  {
                     rewardToShowAllowed = false;
                  }
                  else if(contestIdToShow == null && state == 0)
                  {
                     contestIdToShow = contestId;
                  }
               }
               DCDebug.traceCh("CONTEST","contestIdToShow = " + contestIdToShow);
               if(contestIdToShow != null && contestIdToShow != "null" && rewardToShowAllowed)
               {
                  this.hudOpenUserHasWonPopup(contestIdToShow);
               }
               this.mRewardsToGiveHasChanged.value = false;
            }
         }
      }
      
      private function stateChangeState(newState:int) : void
      {
         var contestSku:String = this.mContestDef != null ? this.mContestDef.mSku : "undefined";
         if(this.mState.value == newState)
         {
            DCDebug.traceCh("CONTEST","[" + contestSku + "] WARN Change state to same state: " + newState);
            return;
         }
         this.stateExitState(this.mState.value);
         DCDebug.traceCh("CONTEST","[" + contestSku + "] Change state " + this.mState.value + " to " + newState);
         this.mOldState.value = this.mState.value;
         this.mState.value = newState;
         this.stateEnterState(this.mState.value);
      }
      
      private function stateEnterState(state:int) : void
      {
         switch(state - -1)
         {
            case 0:
               this.mAskForContestTime.value = 0;
               this.userReset();
               InstanceMng.getPopupMng().closePopup("PopupContest");
               break;
            case 1:
               break;
            case 2:
               this.userRequestProgress();
               break;
            case 3:
               this.leaderboardResetLastTime();
               this.userProgressResetLastTime();
               this.userRequestProgress();
         }
         this.hudUpdateIcon();
      }
      
      private function stateExitState(state:int) : void
      {
         switch(state - -1)
         {
            case 0:
            case 1:
            case 2:
         }
      }
      
      private function requestContest(successCallback:Function = null, failedCallback:Function = null) : void
      {
         this.notificationsStoreNotification("requestContest",successCallback,failedCallback);
         this.traceRequest(" requestContest");
         InstanceMng.getUserDataMng().updateContest_requestContest();
      }
      
      private function onRequestContest(event:ContestEvent) : void
      {
         var currentMS:Number = this.getNowTime();
         DCDebug.traceCh("CONTEST","onRequestContest: currentMS = " + currentMS + ", startDate = " + this.mStartTime.value + ", endDate = " + this.mEndTime.value + ", expireDate = " + this.mExpiryTime.value);
         if(this.mContestDef != null)
         {
            if(currentMS < this.mStartTime.value)
            {
               this.stateChangeState(0);
            }
            else if(currentMS >= this.mStartTime.value && currentMS < this.mEndTime.value)
            {
               this.stateChangeState(1);
            }
            else if(currentMS >= this.mEndTime.value && currentMS < this.mExpiryTime.value)
            {
               this.stateChangeState(2);
            }
            else
            {
               DCDebug.traceCh("CONTEST","onRequestContest: Contest dates?");
            }
         }
      }
      
      private function onRequestContestFailed(event:ContestEvent) : void
      {
         DCDebug.traceCh("CONTEST","onRequestContestFailed!!!");
      }
      
      private function notificationsStoreNotification(key:String, success:Function, failed:Function) : void
      {
         this.mNotificationsSuccess[key] = success;
         this.mNotificationsFailed[key] = failed;
      }
      
      public function notificationsNotify(cmd:String, ok:Boolean, data:Object, requestParams:Object = null) : void
      {
         var application:Application = null;
         var lockUIReason:int = 0;
         var event:ContestEvent = null;
         var callback:Function = null;
         var contestJSON:* = null;
         if(Config.useContests() && mIsBegun)
         {
            DCDebug.traceCh("CONTEST","");
            DCDebug.traceCh("CONTEST"," +++++++++++++++++++++++++++++++++++++++");
            DCDebug.traceCh("CONTEST"," responseContest: " + cmd + " ok = " + ok);
            if(data == null)
            {
               DCDebug.traceCh("CONTEST","data: null");
            }
            else
            {
               DCDebug.traceChObject("CONTEST",data);
            }
            DCDebug.traceCh("CONTEST"," +++++++++++++++++++++++++++++++++++++++");
            DCDebug.traceCh("CONTEST","");
            lockUIReason = (application = InstanceMng.getApplication()).lockUIGetReason();
            if(data == null)
            {
               ok = false;
            }
            if(!ok)
            {
               if((callback = this.mNotificationsFailed[cmd]) != null)
               {
                  event = new ContestEvent("contest_error",requestParams);
                  callback(event);
               }
            }
            else
            {
               callback = this.mNotificationsSuccess[cmd];
               switch(cmd)
               {
                  case "commandsFlushed":
                     if(lockUIReason == 16)
                     {
                        application.lockUIReset(false);
                     }
                     this.hudActualOnClickContestIcon();
                     break;
                  case "progressNeedsUpdate":
                     if(true)
                     {
                        this.userNotifyDeltaScore(Number(data["delta"]));
                     }
                     break;
                  case "requestContest":
                     contestJSON = data;
                     this.contestDefFromJSON(contestJSON);
                     if(callback != null)
                     {
                        event = new ContestEvent("contest_success",requestParams);
                        callback(event);
                     }
                     break;
                  case "requestProgress":
                     this.userFromJSON(data);
                     if(callback != null)
                     {
                        event = new ContestEvent("contest_success",requestParams);
                        callback(event);
                     }
                     break;
                  case "requestLeaderboard":
                     this.leaderboardFromJSON(data);
                     if(callback != null)
                     {
                        event = new ContestEvent("contest_success",requestParams);
                        callback(event);
                     }
               }
            }
            if(lockUIReason == 15)
            {
               application.lockUIReset(false);
            }
         }
      }
      
      private function contestDefFromJSON(json:Object) : void
      {
         if(json.contestType != null)
         {
            this.mContestType.value = json.contestType;
         }
         if(json.contestSku != null)
         {
            this.setContestDef(json.contestSku);
         }
         if(json.startTime != null)
         {
            this.setStartTime(Number(json.startTime));
         }
         if(json.endTime != null)
         {
            this.setEndTime(Number(json.endTime));
         }
         if(json.expiryTime != null)
         {
            this.setExpiryTime(Number(json.expiryTime));
         }
         this.rewardsFromJSON(json);
      }
      
      private function hudUpdateIcon() : void
      {
         var needsToShowIcon:Boolean = this.needsToShowIcon();
         if(needsToShowIcon && !this.mCurrHudElement.value)
         {
            this.mCurrHudElement.value = true;
         }
         else if(this.mCurrHudElement.value && !needsToShowIcon)
         {
            this.hudRemoveContestIcon();
         }
         if(needsToShowIcon && this.mUserProgressLastTime.value > -1)
         {
            InstanceMng.getUIFacade().showContestIcon();
            InstanceMng.getTopHudFacade().updateContestToolButtonIcon();
         }
         if(this.mOldState.value != this.mState.value)
         {
            switch(this.mOldState.value - 1)
            {
               case 0:
                  this.hudHideClickMe();
                  break;
               case 1:
                  this.hudHideDone();
            }
            switch(this.mState.value - 2)
            {
               case 0:
                  this.hudShowDone();
            }
         }
      }
      
      public function needsToShowIcon() : Boolean
      {
         return this.isRunning() && (this.mState.value == 1 || this.mState.value == 2);
      }
      
      private function hudRemoveContestIcon() : void
      {
         this.mCurrHudElement.value = false;
         InstanceMng.getUIFacade().hideContestIcon();
         InstanceMng.getUIFacade().setContestIconTip(null);
      }
      
      private function hudShowClickMe() : void
      {
         if(this.mCurrHudElement.value && !this.contestIsFinished())
         {
            InstanceMng.getUIFacade().setContestIconTip(DCTextMng.getText(1673));
         }
      }
      
      private function hudHideClickMe() : void
      {
      }
      
      private function hudShowDone() : void
      {
         if(this.mCurrHudElement.value)
         {
            InstanceMng.getUIFacade().setContestIconTip(DCTextMng.getText(3324));
         }
      }
      
      private function hudHideDone() : void
      {
         InstanceMng.getUIFacade().setContestIconTip(null);
      }
      
      private function hudOpenUserHasLostPopup() : void
      {
         var contestSku:String = String(this.mContestDef != null ? this.mContestDef.getSku() : null);
         this.guiOpenResultsUserHasLostPopup(contestSku);
      }
      
      private function hudOpenUserHasWonPopup(contestId:String) : void
      {
         var reward:Object = null;
         if(this.mRewardsToGive != null)
         {
            reward = this.mRewardsToGive[contestId];
            if(reward != null)
            {
               this.rewardsToGiveSetState(contestId,1);
               this.guiOpenResultsUserHasWonPopup(this.rewardsToGiveGetContestSku(contestId),this.rewardsToGiveGetEntryString(contestId),this.rewardsToGiveGetRank(contestId));
            }
         }
      }
      
      public function hudOnClickContestIcon(e:Object) : void
      {
         this.mHudWaitingForCommandsToBeFlushed.value = true;
         InstanceMng.getUserDataMng().updateContest_flushCommands();
         InstanceMng.getApplication().lockUIWaitForCommandsToBeFlushedForTheContest();
      }
      
      private function hudActualOnClickContestIcon() : void
      {
         if(this.mHudWaitingForCommandsToBeFlushed.value)
         {
            this.mHudWaitingForCommandsToBeFlushed.value = false;
            this.mHudNeedsToOpenContestPopup.value = true;
            this.userRequestProgress(true);
            if(!this.contestIsFinished())
            {
               if(this.mUserShowClickMeOnIcon.value)
               {
                  this.userSetShowClickMeOnIcon(false);
                  InstanceMng.getUserDataMng().updateContest_clickMePressed(this.mContestType.value);
               }
               this.userSetShowClickMeOnIconIsAllowed(false);
            }
         }
      }
      
      public function hudOnClosePopupUserHasLost() : void
      {
         if(Config.useContests() && this.mUserShowLostPopup.value)
         {
            this.userSetShowLostPopup(false);
            InstanceMng.getUserDataMng().updateContest_lostPopupShown(this.mContestType.value);
         }
      }
      
      public function hudOnClosePopupUserHasWon() : void
      {
         var k:* = null;
         var state:int = 0;
         var contestId:String = null;
         var contestIdToBeRemoved:* = null;
         var pendingTransactions:Vector.<PendingTransaction> = null;
         var t:PendingTransaction = null;
         if(Config.useContests())
         {
            DCDebug.traceCh("CONTEST","hudOnClosePopupUserHasWon()");
            DCDebug.traceCh("CONTEST","this.mRewardsToGive = " + this.mRewardsToGive);
            contestIdToBeRemoved = null;
            for(k in this.mRewardsToGive)
            {
               DCDebug.traceCh("CONTEST","mRewardsToGive item = " + k);
               contestId = k;
               if((state = this.rewardsToGiveGetState(contestId)) == 1)
               {
                  DCDebug.traceCh("CONTEST","is REWARD_STATE_BEING_SHOWN");
                  contestIdToBeRemoved = contestId;
               }
            }
            DCDebug.traceCh("CONTEST","contestIdToBeRemoved = " + contestIdToBeRemoved);
            if(contestIdToBeRemoved != null && contestIdToBeRemoved != "null")
            {
               pendingTransactions = this.rewardsToGiveGetPendingTransactions(contestIdToBeRemoved);
               if(pendingTransactions != null)
               {
                  for each(t in pendingTransactions)
                  {
                     DCDebug.traceCh("CONTEST","processing pendingTransaction");
                     t.process();
                  }
               }
               DCDebug.traceCh("CONTEST","deleting this.mRewardsToGive[contestIdToBeRemoved]");
               delete this.mRewardsToGive[contestIdToBeRemoved];
               this.mRewardsToGiveHasChanged.value = true;
            }
         }
      }
      
      private function setContestDef(sku:String) : void
      {
         this.mContestDef = InstanceMng.getContestDefMng().getDefBySku(sku) as ContestDef;
         if(this.mContestDef == null)
         {
            DCDebug.traceCh("CONTEST","<" + sku + "> sku not found in contestDefinitions.xml");
         }
         else
         {
            DCDebug.traceCh("CONTEST","mContestDef.sku = " + this.mContestDef.mSku);
         }
      }
      
      private function getNowTime() : Number
      {
         return InstanceMng.getApplication().getCurrentServerTimeMillis();
      }
      
      private function contestIsFinished() : Boolean
      {
         return this.getRunningTimeLeft() <= 0;
      }
      
      private function setStartTime(value:Number) : void
      {
         this.mStartTime.value = value;
      }
      
      private function getEndTime() : Number
      {
         return this.mEndTime.value;
      }
      
      private function setEndTime(value:Number) : void
      {
         this.mEndTime.value = value;
      }
      
      private function setExpiryTime(value:Number) : void
      {
         this.mExpiryTime.value = value;
      }
      
      private function incrementAskForContestTime() : void
      {
         this.mAskForContestTime.value = this.getNowTime() + TIME_INCREMENT_ASK_FOR_CONTEST;
         DCDebug.traceCh("CONTEST","incrementAskForContestTime: mAskForContestTime = " + this.mAskForContestTime.value);
      }
      
      private function contestSetFinished(value:Boolean) : void
      {
         if(value)
         {
            this.stateChangeState(2);
         }
      }
      
      public function getNumConditions() : int
      {
         if(this.mContestDef == null)
         {
            return 0;
         }
         return this.mContestDef.getNumConditions();
      }
      
      public function getConditionTid(idx:int = 0) : String
      {
         if(this.mContestDef == null)
         {
            return null;
         }
         return this.mContestDef.getConditionTid(idx);
      }
      
      public function getConditionIcon(idx:int = 0) : String
      {
         if(this.mContestDef == null)
         {
            return null;
         }
         return this.mContestDef.getConditionIcon(idx);
      }
      
      public function getHudIcon() : String
      {
         if(this.mContestDef == null)
         {
            return null;
         }
         return this.mContestDef.getIcon();
      }
      
      public function getProgressIcon() : String
      {
         return this.mContestDef.getProgressIcon();
      }
      
      public function getProgressText() : String
      {
         return this.mContestDef.getProgressText();
      }
      
      public function getAdvisor() : String
      {
         return this.mContestDef.getAdvisor();
      }
      
      public function getTitle() : String
      {
         return this.mContestDef.getTitle();
      }
      
      public function getMissionText() : String
      {
         return this.mContestDef.getMissionText();
      }
      
      public function getRunningTimeLeft() : Number
      {
         var returnValue:Number = this.getEndTime() - this.getNowTime();
         if(returnValue < 0)
         {
            returnValue = 0;
         }
         return returnValue;
      }
      
      private function rewardsReset() : void
      {
         var k:* = null;
         if(this.mRewardsToGive != null)
         {
            for(k in this.mRewardsToGive)
            {
               delete this.mRewardsToGive[k];
            }
         }
      }
      
      private function rewardsFromJSON(json:Object) : void
      {
         var k:* = null;
         var length:int = 0;
         var j:* = 0;
         var i:int = 0;
         var r:Object = null;
         var amount:int = 0;
         var fromPlace:int = 0;
         var toPlace:int = 0;
         var itemSku:String = null;
         var currency:String = null;
         var entryAsString:String = null;
         if(this.mRewardsAsEntryString == null)
         {
            this.mRewardsAsEntryString = new Dictionary(true);
         }
         else
         {
            for(k in this.mRewardsAsEntryString)
            {
               delete this.mRewardsAsEntryString[k];
            }
         }
         if(json.rewards != null)
         {
            length = int(json.rewards.length);
            for(i = 0; i < length; )
            {
               r = json.rewards[i];
               amount = int(r.amount);
               fromPlace = int(r.from);
               toPlace = int(r.to);
               itemSku = String(r.itemSku);
               currency = String(r.currency);
               if((entryAsString = EntryFactory.getEntryStringFromServer(currency,amount,itemSku)) == null || entryAsString == "")
               {
                  Esparragon.traceMsg("Class [EContestMng].rewardsFromJSON type of reward not supported <" + entryAsString + "> .","CONTEST");
               }
               else if(toPlace == -1)
               {
                  this.rewardsAddEntryToPos(entryAsString,-1);
               }
               else
               {
                  for(j = fromPlace; j <= toPlace; )
                  {
                     this.rewardsAddEntryToPos(entryAsString,j);
                     j++;
                  }
               }
               i++;
            }
         }
         this.rewardsCalculateRewardsForView();
      }
      
      private function rewardsAddEntryToPos(entryAsString:String, pos:int) : void
      {
         if(this.mRewardsAsEntryString[pos] != null)
         {
            this.mRewardsAsEntryString[pos] += ", " + entryAsString;
         }
         else
         {
            this.mRewardsAsEntryString[pos] = entryAsString;
         }
      }
      
      public function rewardsGetEntryStringByPos(pos:int) : String
      {
         var returnValue:String = null;
         if(this.mRewardsAsEntryString != null)
         {
            returnValue = String(this.mRewardsAsEntryString[pos] == undefined ? null : this.mRewardsAsEntryString[pos]);
            if(returnValue == null && this.mRewardsAsEntryString[-1] != undefined)
            {
               returnValue = String(this.mRewardsAsEntryString[-1]);
            }
         }
         return returnValue;
      }
      
      public function rewardsGivePendingTransaction(rewardAsString:String, t:PendingTransaction) : void
      {
         var pendingTransactions:Vector.<PendingTransaction> = null;
         var contestId:String = t.getParamFromKey("id");
         DCDebug.traceCh("CONTEST","rewardsGivePendingTransaction contestId = " + contestId);
         if(this.mRewardsToGive == null)
         {
            this.mRewardsToGive = new Dictionary(true);
         }
         if(this.mRewardsToGive[contestId] == null)
         {
            this.mRewardsToGive[contestId] = {};
            this.rewardsToGiveSetState(contestId,0);
            this.rewardsToGiveSetContestSku(contestId,t.getParamFromKey("sku"));
         }
         this.rewardsToGiveAddEntryString(contestId,rewardAsString);
         this.rewardsToGiveAddPendingTransaction(contestId,t);
         this.mRewardsToGiveHasChanged.value = true;
      }
      
      private function rewardsToGiveGetReward(contestId:String) : Object
      {
         return this.mRewardsToGive != null && this.mRewardsToGive[contestId] != undefined ? this.mRewardsToGive[contestId] : null;
      }
      
      private function rewardsToGiveGetEntryString(contestId:String) : String
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         return reward != null ? reward.entryString : null;
      }
      
      private function rewardsToGiveSetEntryString(contestId:String, value:String) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            reward.entryString = value;
         }
      }
      
      private function rewardsToGiveAddEntryString(contestId:String, value:String) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            if(reward.entryString == null)
            {
               reward.entryString = value;
            }
            else
            {
               reward.entryString += "," + value;
            }
         }
      }
      
      private function rewardsToGiveGetState(contestId:String) : int
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         return reward != null ? int(reward.state) : -1;
      }
      
      private function rewardsToGiveSetState(contestId:String, value:int) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            reward.state = value;
         }
      }
      
      private function rewardsToGiveGetContestSku(contestId:String) : String
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         return reward != null ? reward.contestSku : null;
      }
      
      private function rewardsToGiveSetContestSku(contestId:String, value:String) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            reward.contestSku = value;
         }
      }
      
      private function rewardsToGiveGetPendingTransactions(contestId:String) : Vector.<PendingTransaction>
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         return reward != null ? reward.pendingTransactions as Vector.<PendingTransaction> : null;
      }
      
      private function rewardsToGiveSetPendingTransactions(contestId:String, value:Vector.<PendingTransaction>) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            reward.pendingTransactions = value;
         }
      }
      
      private function rewardsToGiveAddPendingTransaction(contestId:String, value:PendingTransaction) : void
      {
         var reward:Object = this.rewardsToGiveGetReward(contestId);
         if(reward != null)
         {
            if(reward.pendingTransactions == null)
            {
               reward.pendingTransactions = new Vector.<PendingTransaction>(0);
            }
            Vector.<PendingTransaction>(reward.pendingTransactions).push(value);
         }
      }
      
      private function rewardsToGiveGetRank(contestId:String) : String
      {
         var t:PendingTransaction = null;
         var returnValue:String = null;
         var pendingTransactions:Vector.<PendingTransaction>;
         if((pendingTransactions = this.rewardsToGiveGetPendingTransactions(contestId)) != null)
         {
            t = pendingTransactions[0];
            if(t != null)
            {
               returnValue = t.getParamFromKey("rank");
            }
         }
         return returnValue;
      }
      
      private function rewardsCalculateRewardsForView() : void
      {
         var contestReward:ContestReward = null;
         var j:int = 0;
         var k:* = null;
         var pos:int = 0;
         var entryString:String = null;
         var losersEntry:String = null;
         var fromPos:int = 0;
         var losersReward:ContestReward = null;
         if(this.mRewardsForView == null)
         {
            this.mRewardsForView = new Vector.<ContestReward>(0);
         }
         else
         {
            while(this.mRewardsForView.length > 0)
            {
               (contestReward = this.mRewardsForView.shift()).destroy();
            }
         }
         for(k in this.mRewardsAsEntryString)
         {
            pos = k;
            entryString = String(this.mRewardsAsEntryString[pos]);
            if(pos != -1)
            {
               if((contestReward = this.rewardsGetContestReward(pos,entryString)) == null)
               {
                  (contestReward = new ContestReward()).setup(pos,pos,entryString);
                  this.mRewardsForView.push(contestReward);
               }
            }
         }
         losersEntry = String(this.mRewardsAsEntryString[-1]);
         if(losersEntry != null)
         {
            contestReward = this.mRewardsForView[this.mRewardsForView.length - 1];
            fromPos = ContestReward(this.mRewardsForView[this.mRewardsForView.length - 1]).getToPos() + 1;
            if((contestReward = this.rewardsGetContestReward(fromPos,losersEntry)) == null)
            {
               (losersReward = new ContestReward()).setup(fromPos,-1,losersEntry);
               this.mRewardsForView.push(losersReward);
            }
            else
            {
               contestReward.setToPos(-1);
            }
         }
      }
      
      private function rewardsGetContestReward(pos:int, entryString:String) : ContestReward
      {
         var j:int = 0;
         var contestReward:ContestReward = null;
         j = this.mRewardsForView.length - 1;
         while(j > -1 && contestReward == null)
         {
            if((contestReward = this.mRewardsForView[j]).isAllowedToJoin(pos,entryString))
            {
               contestReward.joinPos(pos);
            }
            else
            {
               contestReward = null;
            }
            j--;
         }
         return contestReward;
      }
      
      public function rewardsGetRewardsForView() : Vector.<ContestReward>
      {
         return this.mRewardsForView;
      }
      
      private function userReset() : void
      {
         this.userSetScore(0);
         this.userSetRank(0);
         this.userSetShowClickMeOnIcon(false);
         this.userSetShowLostPopup(false);
         this.userSetRequestIsAllowed(true);
         this.userSetShowClickMeOnIconIsAllowed(true);
         this.mHudNeedsToOpenContestPopup.value = false;
         this.mHudWaitingForCommandsToBeFlushed.value = false;
         this.userProgressResetLastTime();
         this.leaderboardResetLastTime();
      }
      
      private function userGetUser() : ContestUser
      {
         if(this.mUser == null)
         {
            this.mUser = new ContestUser(InstanceMng.getUserDataMng().mUserAccountId);
            this.mUser.setIsMe(true);
         }
         return this.mUser;
      }
      
      private function userFromJSON(json:Object) : void
      {
         var score:Number = 0;
         if(json.score != null)
         {
            score = Number(json.score);
         }
         var lastScore:Number = this.userGetScore();
         var lastRank:Number = this.userGetRank();
         if(score >= lastScore)
         {
            this.userSetScore(Number(json.score));
            if(json.rank != null)
            {
               this.userSetRank(Number(json.rank));
            }
            else
            {
               this.userSetRank(0);
            }
            if(json.showClickMe != null)
            {
               this.userSetShowClickMeOnIcon(json.showClickMe == "1");
            }
            if(json.showLost != null)
            {
               this.userSetShowLostPopup(json.showLost == "1");
            }
            if(this.contestIsFinished())
            {
               this.userSetRequestIsAllowed(false);
               this.contestSetFinished(true);
               if(this.mUserShowLostPopup.value && !this.mUserShowClickMeOnIcon.value)
               {
                  this.hudOpenUserHasLostPopup();
               }
               else
               {
                  InstanceMng.getUserDataMng().queryVerifyCreditsPurchase(true);
               }
            }
         }
         if(this.userGetRank() != lastRank)
         {
            this.leaderboardResetLastTime();
         }
      }
      
      public function userGetScore() : Number
      {
         return this.userGetUser().getScore();
      }
      
      private function userSetScore(value:Number) : void
      {
         this.userGetUser().setScore(value);
      }
      
      public function userGetRank() : Number
      {
         return this.userGetUser().getRank();
      }
      
      private function userSetRank(value:Number) : void
      {
         this.userGetUser().setRank(value);
      }
      
      private function userSetShowLostPopup(value:Boolean) : void
      {
         this.mUserShowLostPopup.value = value;
      }
      
      private function userSetShowClickMeOnIcon(value:Boolean) : void
      {
         if(this.mUserShowClickMeOnIcon.value != value)
         {
            if(this.mUserShowClickMeOnIconIsAllowed.value)
            {
               this.mUserShowClickMeOnIcon.value = value;
               if(value)
               {
                  this.hudShowClickMe();
               }
               else
               {
                  this.hudHideClickMe();
               }
            }
            else if(value)
            {
               InstanceMng.getUserDataMng().updateContest_clickMePressed(this.mContestType.value);
            }
         }
      }
      
      private function userSetShowClickMeOnIconIsAllowed(value:Boolean) : void
      {
         this.mUserShowClickMeOnIconIsAllowed.value = value;
      }
      
      private function userSetRequestIsAllowed(value:Boolean) : void
      {
         this.mUserRequestIsAllowed.value = value;
      }
      
      private function traceRequest(str:String) : void
      {
         DCDebug.traceCh("CONTEST","");
         DCDebug.traceCh("CONTEST"," -------------------------------------------------------");
         DCDebug.traceCh("CONTEST",str);
         DCDebug.traceCh("CONTEST"," -------------------------------------------------------");
         DCDebug.traceCh("CONTEST","");
      }
      
      private function userRequestProgress(lockUI:Boolean = false) : void
      {
         this.traceRequest(" userRequestProgress allowed = " + this.mUserRequestIsAllowed.value);
         var timeSinceLastUpdate:Number = InstanceMng.getUserDataMng().getServerCurrentTimemillis() - this.mUserProgressLastTime.value;
         if(this.mUserRequestIsAllowed.value && timeSinceLastUpdate > ContestConstants.TIME_BETWEEN_PROGRESS_UPDATES_MS)
         {
            if(lockUI)
            {
               InstanceMng.getApplication().lockUIWaitForContestRequest();
            }
            this.userProgressResetLastTime();
            this.notificationsStoreNotification("requestProgress",this.userOnRequestProgressSuccess,this.userOnRequestProgressFailed);
            InstanceMng.getUserDataMng().updateContest_requestProgress(this.mContestType.value);
         }
         else
         {
            this.userOnRequestProgressSuccess(null);
         }
      }
      
      private function userOnRequestProgressSuccess(event:ContestEvent, updateDate:Boolean = true) : void
      {
         if(this.mHudNeedsToOpenContestPopup.value)
         {
            this.guiOpenInfoPopup();
         }
         if(updateDate)
         {
            if(this.mUserProgressLastTime.value == -1)
            {
               this.mUserProgressLastTime.value = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
               this.hudUpdateIcon();
            }
         }
      }
      
      private function userOnRequestProgressFailed(event:ContestEvent) : void
      {
         DCDebug.traceCh("CONTEST","onRequestProgressFailed!!!");
         if(this.mHudNeedsToOpenContestPopup.value)
         {
            this.userOnRequestProgressSuccess(event,false);
         }
      }
      
      private function userProgressResetLastTime() : void
      {
         this.mUserProgressLastTime.value = -1;
      }
      
      private function userNotifyDeltaScore(deltaScore:int) : void
      {
         var userScore:Number = this.userGetScore();
         this.userSetScore(userScore + deltaScore);
         this.leaderboardResetLastTime();
      }
      
      public function leaderboardRequest(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var callSuccess:Boolean = false;
         var timeSinceLastUpdate:Number = NaN;
         if(Config.useContests())
         {
            callSuccess = true;
            if(this.mUserRequestIsAllowed.value || this.mLeaderboardLastTime.value == -1)
            {
               if((timeSinceLastUpdate = InstanceMng.getUserDataMng().getServerCurrentTimemillis() - this.mLeaderboardLastTime.value) > ContestConstants.TIME_BETWEEN_LEADERBOARD_UPDATES_MS)
               {
                  this.mLeaderboardLastTime.value = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
                  this.notificationsStoreNotification("requestLeaderboard",successCallback,failedCallback);
                  this.traceRequest(" requestLeaderboard");
                  InstanceMng.getUserDataMng().updateContest_requestLeaderboard(this.mContestType.value);
                  if(lockUI)
                  {
                     InstanceMng.getApplication().lockUIWaitForContestRequest();
                  }
                  callSuccess = false;
               }
            }
            if(callSuccess)
            {
               successCallback(null);
            }
         }
      }
      
      private function leaderboardFromJSON(json:Object) : void
      {
         var user:ContestUser = null;
         var u:Object = null;
         var i:int = 0;
         var isMyUser:* = false;
         if(this.mLeaderboardUsers == null)
         {
            this.mLeaderboardUsers = new Vector.<ContestUser>(0);
         }
         else
         {
            while(this.mLeaderboardUsers.length > 0)
            {
               if(!(user = this.mLeaderboardUsers.shift()).getIsMe())
               {
                  user.destroy();
               }
            }
         }
         var length:int = int(json == null || json.leaderboard == null ? 0 : int(json.leaderboard.length));
         var myUserId:String = InstanceMng.getUserDataMng().mUserAccountId;
         for(i = 0; i < length; )
         {
            u = json.leaderboard[i];
            if(isMyUser = u.id == myUserId)
            {
               user = this.mUser;
            }
            else
            {
               user = new ContestUser();
            }
            this.mLeaderboardUsers.push(user);
            user.fromJSON(u);
            user.setIsMe(isMyUser);
            i++;
         }
      }
      
      private function leaderboardResetLastTime() : void
      {
         this.mLeaderboardLastTime.value = -1;
      }
      
      public function leaderboardGetUsers() : Vector.<ContestUser>
      {
         return this.mLeaderboardUsers;
      }
      
      public function guiOpenInfoPopup() : DCIPopup
      {
         var popupId:String = "PopupContest";
         var popup:PopupContest = new PopupContest();
         popup.setup(popupId,InstanceMng.getViewFactory(),null);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         this.mHudNeedsToOpenContestPopup.value = false;
         return popup;
      }
      
      public function guiOpenResultsUserHasLostPopup(contestSku:String) : void
      {
         var popup:PopupContestResults = this.guiGetResultsPopup();
         var reward:String = this.rewardsGetEntryStringByPos(1);
         var rankPosition:String = this.userGetRank().toString();
         popup.setReward(contestSku,reward,rankPosition,false);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenResultsUserHasWonPopup(contestSku:String, rewardAsString:String, rankPosition:String) : void
      {
         var popup:DCIPopup = this.guiGetResultsPopup();
         PopupContestResults(popup).setReward(contestSku,rewardAsString,rankPosition,true);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function guiGetResultsPopup() : PopupContestResults
      {
         var popupId:String = "PopupContestResults";
         var popup:PopupContestResults = new PopupContestResults();
         popup.setup(popupId,InstanceMng.getViewFactory(),null);
         return popup;
      }
      
      public function guiUnlockUI(reason:int) : void
      {
         switch(reason - 16)
         {
            case 0:
               this.hudActualOnClickContestIcon();
         }
      }
   }
}
