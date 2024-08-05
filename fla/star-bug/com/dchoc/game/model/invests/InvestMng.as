package com.dchoc.game.model.invests
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.InvestRewardsDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   
   public class InvestMng extends DCComponent
   {
      
      public static const UNLOCKED:int = 0;
      
      public static const LOCKED_BY_MISSION:int = 1;
      
      public static const LOCKED_BY_FRIENDS_LIST:int = 2;
      
      public static const FLAG_INVEST_NEW_INVESTMENTS_USER:Number = -1;
       
      
      private var mSortList:Boolean;
      
      private var mWaitingForResponse:Boolean = false;
      
      private var mRequestTime:int = 0;
      
      private var mSendRequest:Boolean = false;
      
      private var mInvestsUI:Array;
      
      private var mInvests:Array;
      
      private var mInvestsUINeedsToBeUpdated:Boolean;
      
      private var mFriendsToInvest:Array;
      
      private var mFriendsSuccessfulInvests:Array;
      
      private var mSuccesfulInvests:Array;
      
      private var mFriendsNoAllowedToInvestIn:Array;
      
      private var mStatsInvestsStarted:int;
      
      private var mStatsInvestsRewarded:int;
      
      private var mNextRewardSku:String = "1";
      
      private var mGuiInvest:Invest;
      
      private var mGuiPopup:DCIPopup;
      
      private var mGUIInvestorUserInfo:UserInfo;
      
      private var mGUITransaction:Transaction;
      
      public function InvestMng()
      {
         super();
      }
      
      override protected function unloadDo() : void
      {
         this.guiUnload();
      }
      
      public function requestInvests() : void
      {
         var userDataMng:UserDataMng = null;
         if(this.mSendRequest)
         {
            InstanceMng.getApplication().lockUIWaitForInvests();
            userDataMng = InstanceMng.getUserDataMng();
            userDataMng.requestTask(UserDataMng.KEY_INVESTS_LIST);
            this.mWaitingForResponse = true;
            this.mSendRequest = false;
         }
         else
         {
            this.guiOpenInvestPopup();
         }
      }
      
      private function buildInvests(xmlDoc:XML) : void
      {
         this.investsLoad();
         this.friendsLoad();
         this.investsPopulate(xmlDoc);
      }
      
      override public function notify(e:Object) : Boolean
      {
         var xml:XML = null;
         var returnValue:Boolean = false;
         if(e.info != null)
         {
            xml = e.info;
            if(xml != null)
            {
               if(InstanceMng.getApplication().lockUIGetReason() == 10)
               {
                  InstanceMng.getApplication().lockUIReset(false);
               }
               this.buildInvests(xml);
               returnValue = true;
               this.guiOpenInvestPopup();
            }
         }
         return returnValue;
      }
      
      private function investsLoad() : void
      {
         this.mInvests = [];
         this.mInvestsUI = [];
      }
      
      private function investsPopulate(xmlDoc:XML) : void
      {
         var investXML:XML = null;
         var invest:Invest = null;
         this.mInvests.splice(0,this.mInvests.length);
         var attribute:String = "investsStarted";
         if(EUtils.xmlIsAttribute(xmlDoc,attribute))
         {
            this.mStatsInvestsStarted = EUtils.xmlReadInt(xmlDoc,attribute);
         }
         attribute = "nextRewardSku";
         if(EUtils.xmlIsAttribute(xmlDoc,attribute))
         {
            this.mNextRewardSku = EUtils.xmlReadString(xmlDoc,attribute);
         }
         for each(investXML in EUtils.xmlGetChildrenList(xmlDoc,"investment"))
         {
            invest = new Invest();
            invest.fromXml(investXML);
            this.addInvest(invest);
            if(invest.getState() == 4)
            {
               this.friendsAddSuccessfulInvestFriend(invest.getAccountId());
               this.addSuccessfulInvest(invest);
               this.increaseInvestsRewarded();
            }
         }
         this.mInvestsUINeedsToBeUpdated = true;
         this.friendsToInvestPopulate();
      }
      
      public function sendInvestRequestToFriend(friend:UserInfo) : void
      {
         InstanceMng.getUserDataMng().updateInvest_investInFriend(friend.getExtId());
      }
      
      public function sendInvestRequestsToFriends() : void
      {
         InstanceMng.getUserDataMng().updateInvest_investInFriends(this.mFriendsNoAllowedToInvestIn);
      }
      
      public function investInFriends(extIds:Array) : void
      {
         var extId:String = null;
         var friend:UserInfo = null;
         var userInfoMng:UserInfoMng = InstanceMng.getUserInfoMng();
         for each(extId in extIds)
         {
            friend = userInfoMng.getUserInfoObj(extId,1);
            this.investInFriend(friend);
         }
         this.guiRefreshInvestPopup();
      }
      
      public function investInFriend(friend:UserInfo) : void
      {
         var invest:Invest = null;
         var str:* = null;
         var xml:XML = null;
         var friendPos:int;
         if((friendPos = this.mFriendsToInvest.indexOf(friend)) > -1)
         {
            this.mFriendsToInvest.splice(friendPos,1);
            invest = new Invest();
            str = "<investment platformId=\"" + Star.getPlatformId() + "\" extId=\"" + friend.getExtId() + "\" timeLeft=\"" + InstanceMng.getInvestsSettingsDefMng().getGoalTime() + "\" state=\"" + 0 + "\"/>";
            xml = EUtils.stringToXML(str);
            invest.fromXml(xml);
            this.addInvest(invest);
            this.mInvestsUINeedsToBeUpdated = true;
            this.mSortList = true;
         }
      }
      
      public function cancelInvest(invest:Invest) : void
      {
         var extId:String = null;
         var pos:int = this.mInvests.indexOf(invest);
         if(pos > -1 && invest.isCancellable())
         {
            invest.unbuild();
            this.mInvests.splice(pos,1);
            extId = invest.getExtId();
            if(invest.getPlatformId() == Star.getPlatformId())
            {
               pos = this.mFriendsNoAllowedToInvestIn.indexOf(extId);
               if(pos != -1)
               {
                  this.mFriendsNoAllowedToInvestIn.splice(pos,1);
               }
            }
            this.friendsToInvestPopulate();
            if(invest.isAccountIdValid())
            {
               InstanceMng.getUserDataMng().updateInvest_cancelByAccountId(invest.getAccountId());
            }
            else
            {
               InstanceMng.getUserDataMng().updateInvest_cancelByExtId(invest.getExtId(),invest.getPlatformId());
            }
            this.mSortList = true;
         }
         this.mInvestsUINeedsToBeUpdated = true;
      }
      
      public function applyResult(invest:Invest) : void
      {
         var isSuccessfully:Boolean = false;
         var sku:String = null;
         var transaction:Transaction = null;
         var def:InvestRewardsDef = null;
         var pos:int = this.mInvests.indexOf(invest);
         var params:Object;
         (params = {}).p1 = invest.getExtId();
         if(pos > -1 && invest.isDoable())
         {
            isSuccessfully = invest.isSuccessfully();
            sku = "";
            transaction = null;
            if(isSuccessfully)
            {
               this.mStatsInvestsRewarded++;
               def = this.rewardsGetNextInvestRewardDef();
               sku = def.mSku;
               (transaction = this.rewardsGetTransactionFromNextReward()).performAllTransactions(false);
               this.friendsAddSuccessfulInvestFriend(invest.getAccountId());
               this.addSuccessfulInvest(invest);
               this.increaseNextRewardSku();
            }
            invest.setClaimed(true);
            invest.setTransaction(transaction);
            InstanceMng.getUserDataMng().updateInvest_applyResult(invest.getAccountId(),sku,transaction);
         }
         this.mInvestsUINeedsToBeUpdated = true;
      }
      
      private function increaseInvestsRewarded() : void
      {
         this.mStatsInvestsRewarded++;
      }
      
      public function remindInvest(invest:Invest) : void
      {
         if(invest != null)
         {
            invest.remind();
         }
      }
      
      private function addInvest(invest:Invest) : void
      {
         var pos:int = 0;
         this.mInvests.push(invest);
         var extId:String = invest.getExtId();
         if(invest.getPlatformId() == Star.getPlatformId())
         {
            pos = this.mFriendsNoAllowedToInvestIn.indexOf(extId);
            if(pos == -1)
            {
               this.mFriendsNoAllowedToInvestIn.push(extId);
            }
         }
      }
      
      public function getInvestsUI() : Array
      {
         var invest:Invest = null;
         if(this.mInvestsUINeedsToBeUpdated)
         {
            this.mInvestsUI.splice(0,this.mInvestsUI.length);
            for each(invest in this.mInvests)
            {
               if(invest.getState() != 4 && invest.getState() != 6)
               {
                  this.mInvestsUI.push(invest);
               }
            }
            this.mInvestsUI.sort(this.sortInvestsUI);
            this.mInvestsUINeedsToBeUpdated = false;
         }
         return this.mInvestsUI;
      }
      
      public function getStartedInvestsCount() : int
      {
         return this.getInvestsUI().length;
      }
      
      private function sortInvestsUI(a:Invest, b:Invest) : Number
      {
         var uInfoA:UserInfo = null;
         var uInfoB:UserInfo = null;
         var returnValue:int = 0;
         var aState:int = a.getState();
         var bState:int = b.getState();
         if(aState == 2 && bState != 2)
         {
            returnValue = -1;
         }
         else if(bState == 2 && aState != 2)
         {
            returnValue = 1;
         }
         else if(aState == 1 && bState != 1)
         {
            returnValue = -1;
         }
         else if(bState == 1 && aState != 1)
         {
            returnValue = 1;
         }
         else if(aState == 3 && bState != 3)
         {
            returnValue = -1;
         }
         else if(bState == 3 && aState != 3)
         {
            returnValue = 1;
         }
         else if(aState == 4 && bState != 4)
         {
            returnValue = 1;
         }
         else if(bState == 4 && aState != 4)
         {
            returnValue = -1;
         }
         if(returnValue == 0)
         {
            uInfoA = InstanceMng.getUserInfoMng().getUserInfoObj(a.getAccountId(),0);
            uInfoB = InstanceMng.getUserInfoMng().getUserInfoObj(b.getAccountId(),0);
            if(uInfoA != null && uInfoB != null)
            {
               returnValue = this.sortCompareFunctionName(uInfoA,uInfoB);
            }
         }
         return returnValue;
      }
      
      private function friendsLoad() : void
      {
         this.mFriendsToInvest = [];
         this.mFriendsSuccessfulInvests = [];
         this.mSuccesfulInvests = [];
         this.mFriendsNoAllowedToInvestIn = [];
      }
      
      private function friendsToInvestPopulate() : void
      {
         var friendPlatformId:String = null;
         var friend:UserInfo = null;
         var friendId:String = null;
         var found:Boolean = false;
         var i:int = 0;
         var invest:Invest = null;
         this.mFriendsToInvest.splice(0,this.mFriendsToInvest.length);
         var friendsList:Vector.<UserInfo> = InstanceMng.getUserInfoMng().getNoPlayerFriendsList();
         var currentPlatformId:String = Star.getPlatformId();
         for each(friend in friendsList)
         {
            friendId = String(friend.getExtId());
            friendPlatformId = friend.getPlatform();
            if(friendPlatformId == null || friendPlatformId == currentPlatformId)
            {
               found = false;
               i = this.mInvests.length - 1;
               while(i > -1 && !found)
               {
                  invest = this.mInvests[i];
                  if(friendId == invest.getExtId())
                  {
                     found = true;
                  }
                  i--;
               }
               if(!found)
               {
                  this.mFriendsToInvest.push(friend);
               }
            }
         }
         this.mSortList = true;
      }
      
      public function getFriendsToInvest() : Array
      {
         if(this.mSortList)
         {
            this.mSortList = false;
            this.mFriendsToInvest.sort(this.sortCompareFunctionName);
         }
         return this.mFriendsToInvest;
      }
      
      private function sortCompareFunctionName(a:UserInfo, b:UserInfo) : Number
      {
         var aValue:String = a.getPlayerName();
         var bValue:String = b.getPlayerName();
         var returnValue:Number = 0;
         if(aValue > bValue)
         {
            returnValue = 1;
         }
         else if(aValue < bValue)
         {
            returnValue = -1;
         }
         return returnValue;
      }
      
      public function getSuccessfulInvestFriends() : Array
      {
         return this.mFriendsSuccessfulInvests;
      }
      
      public function friendsAddSuccessfulInvestFriend(accountId:String) : void
      {
         var pos:int = 0;
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0);
         if(userInfo != null)
         {
            pos = this.mFriendsSuccessfulInvests.indexOf(userInfo);
            if(pos == -1)
            {
               this.mFriendsSuccessfulInvests.push(userInfo);
            }
         }
      }
      
      public function addSuccessfulInvest(invest:Invest) : void
      {
         var pos:int = this.mSuccesfulInvests.indexOf(invest);
         if(pos == -1)
         {
            this.mSuccesfulInvests.push(invest);
         }
      }
      
      public function statsGetInvestsStartedCount() : int
      {
         return this.mStatsInvestsStarted;
      }
      
      public function statsGetInvestsSuccessfullyCount() : int
      {
         return this.mStatsInvestsRewarded;
      }
      
      public function statsGetInvestsSuccessPercentage() : int
      {
         var returnValue:int = this.statsGetInvestsStartedCount();
         if(returnValue > 0)
         {
            returnValue = 100 * this.statsGetInvestsSuccessfullyCount() / returnValue;
         }
         return returnValue;
      }
      
      public function traceContent() : void
      {
         var invest:Invest = null;
         var investsUI:Array = null;
         var friend:UserInfo = null;
         for each(invest in this.mInvests)
         {
            invest.traceContent();
         }
         investsUI = this.getInvestsUI();
         for each(invest in investsUI)
         {
            invest.traceContent();
         }
         for each(friend in this.mFriendsToInvest)
         {
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var xml:XML = null;
         var invest:Invest = null;
         if(this.mWaitingForResponse)
         {
            if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_INVESTS_LIST))
            {
               this.mWaitingForResponse = false;
               xml = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_INVESTS_LIST);
               if(xml != null)
               {
                  if(InstanceMng.getApplication().lockUIGetReason() == 10)
                  {
                     InstanceMng.getApplication().lockUIReset(false);
                  }
                  this.buildInvests(xml);
                  this.guiOpenInvestPopup();
                  InstanceMng.getUserDataMng().freeFile(UserDataMng.KEY_INVESTS_LIST);
               }
            }
         }
         if(this.mInvests != null)
         {
            for each(invest in this.mInvests)
            {
               invest.logicUpdate(dt);
            }
         }
         if(this.mRequestTime <= 0)
         {
            this.mSendRequest = true;
            this.mRequestTime = InstanceMng.getInvestsSettingsDefMng() != null ? int(InstanceMng.getInvestsSettingsDefMng().getRefreshInfoTime()) : int(DCTimerUtil.minToMs(20));
         }
         else
         {
            this.mRequestTime -= dt;
         }
      }
      
      public function isUnlockMissionAchieved() : Boolean
      {
         return InstanceMng.getMissionsMng().isMissionEnded(InstanceMng.getInvestsSettingsDefMng().getUnlockMissionSku());
      }
      
      public function rewardsGetTransactionFromNextReward() : Transaction
      {
         var def:InvestRewardsDef = this.rewardsGetNextInvestRewardDef();
         return InstanceMng.getRuleMng().createTransactionFromRewardsString(def.getRewardsString());
      }
      
      private function rewardsGetNextInvestRewardDef() : InvestRewardsDef
      {
         var index:int = 0;
         var defs:Vector.<DCDef> = InstanceMng.getInvestRewardsDefMng().getDefs();
         var def:InvestRewardsDef = InvestRewardsDef(InstanceMng.getInvestRewardsDefMng().getDefBySku(this.mNextRewardSku));
         if(def == null)
         {
            index = defs.length - 1;
            def = InvestRewardsDef(defs[index]);
         }
         return def;
      }
      
      private function increaseNextRewardSku() : void
      {
         var defs:Vector.<DCDef> = InstanceMng.getInvestRewardsDefMng().getDefs();
         var def:InvestRewardsDef = InvestRewardsDef(InstanceMng.getInvestRewardsDefMng().getDefBySku(this.mNextRewardSku));
         var index:int;
         var nextDefIndex:int = (index = defs.indexOf(def)) + 1;
         var nextDef:InvestRewardsDef = null;
         if(nextDefIndex < defs.length)
         {
            nextDef = InvestRewardsDef(defs[nextDefIndex]);
         }
         this.mNextRewardSku = nextDef != null ? nextDef.mSku : def.mSku;
      }
      
      public function getInvestsLock() : int
      {
         var returnValue:int = 0;
         if(InstanceMng.getMissionsMng() != null)
         {
            if(!this.isUnlockMissionAchieved())
            {
               return 1;
            }
         }
         if(!InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_FRIENDS_LIST))
         {
            return 2;
         }
         return returnValue;
      }
      
      public function areInvestsLocked() : Boolean
      {
         return this.getInvestsLock() != 0;
      }
      
      public function getInfoPopupTextDependingOnLockType() : String
      {
         var returnValue:String = "";
         switch(this.getInvestsLock())
         {
            case 0:
               returnValue = "";
               break;
            case 1:
               returnValue = DCTextMng.getText(3135);
               break;
            case 2:
               returnValue = "~There are some problems right now at the embassy. Try again later.";
         }
         return returnValue;
      }
      
      public function openInvestsPopupDependingOnSituation(checkLock:Boolean = true) : void
      {
         var profileInvestsWelcomeFlagId:int = 0;
         var title:String = null;
         if(!this.areInvestsLocked() || !checkLock)
         {
            profileInvestsWelcomeFlagId = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetInvestmentsWelcomeId();
            if(profileInvestsWelcomeFlagId == -1)
            {
               InstanceMng.getUserInfoMng().getProfileLogin().flagsSetInvestmentsWelcomeId(1);
            }
            InstanceMng.getMapViewPlanet().setInvestsBubbleSpeechVisibility(false);
            this.requestInvests();
         }
         else
         {
            title = DCTextMng.getText(191);
            InstanceMng.getNotificationsMng().guiOpenMessagePopup("PopupWarnings",title,this.getInfoPopupTextDependingOnLockType(),"orange_normal");
         }
      }
      
      public function updateProfileWelcomeId(id:int) : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().flagsSetInvestmentsWelcomeId(id);
      }
      
      public function hasToShowBubbleSpeech() : Boolean
      {
         var profileInvestsWelcomeFlagId:int = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetInvestmentsWelcomeId();
         var profileLogin:Profile;
         var investNews:Boolean = (profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()).areAnyInvestNews();
         var currProfileLoaded:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         var isOwner:* = profileLogin.getAccountId() == currProfileLoaded.getAccountId();
         return Config.useInvests() && isOwner && !this.areInvestsLocked() && (investNews || profileInvestsWelcomeFlagId == -1);
      }
      
      private function guiUnload() : void
      {
         this.mGuiInvest = null;
         this.mGuiPopup = null;
         this.mGUIInvestorUserInfo = null;
         this.mGUITransaction = null;
      }
      
      public function guiOpenInvestHelpPopup() : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getHelpInvestPopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function guiOpenInvestPopup() : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getInvestPopup();
         popup.setIsStackable(false);
         uiFacade.enqueuePopup(popup,true,true,true,true);
      }
      
      private function guiRefreshInvestPopup() : void
      {
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupOpened("PopupInvest");
         if(popup == null)
         {
            this.guiOpenInvestPopup();
         }
         else
         {
            popup.refresh();
         }
      }
      
      public function guiOpenInvestRewardPopup(invest:Invest) : void
      {
         this.mGuiInvest = invest;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         if(invest.isSuccessfully())
         {
            this.mGuiPopup = uiFacade.getPopupFactory().getInvestRewardSuccessPopup(invest,this.guiOnClose);
         }
         else
         {
            this.mGuiPopup = uiFacade.getPopupFactory().getInvestRewardFailPopup(invest,this.guiOnClose);
         }
         this.mGuiPopup.setIsStackable(true);
         uiFacade.enqueuePopup(this.mGuiPopup,true,true,true,true);
      }
      
      public function guiOpenInvestRewardTutorialPopup(investorAccId:String, trans:Transaction) : void
      {
         if(investorAccId != null)
         {
            this.mGUIInvestorUserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(investorAccId,0);
         }
         else
         {
            this.mGUIInvestorUserInfo = null;
         }
         if(this.mGUIInvestorUserInfo)
         {
            return;
         }
         this.mGUITransaction = trans;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         this.mGuiPopup = uiFacade.getPopupFactory().getInvestRewardTutorialPopup(this.mGUIInvestorUserInfo,trans,this.guiInvestRewardTutorialOnClose);
         this.mGuiPopup.setIsStackable(true);
         uiFacade.enqueuePopup(this.mGuiPopup,true,true,true,true);
      }
      
      private function guiOnClose(e:Object = null) : void
      {
         if(this.mGuiPopup != null)
         {
            InstanceMng.getUIFacade().closePopup(this.mGuiPopup);
            this.mGuiPopup = null;
            this.mGuiInvest = null;
         }
      }
      
      private function guiInvestRewardTutorialOnClose(e:Object = null) : void
      {
         if(this.mGUITransaction != null)
         {
            this.mGUITransaction.performAllTransactions(false);
            this.mGUITransaction = null;
         }
         InstanceMng.getFlowStatePlanet().postFinishTutorial();
         this.mGUIInvestorUserInfo = null;
         this.guiOnClose(e);
      }
   }
}
