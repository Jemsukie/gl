package com.dchoc.game.model.bet
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.core.flow.RequestTargetBet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.messages.EPopupSpeech;
   import com.dchoc.game.eview.widgets.bet.PopupBetResult;
   import com.dchoc.game.eview.widgets.bet.PopupBetSelection;
   import com.dchoc.game.model.rule.BetsSettingsDefMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class BetMng extends DCComponent
   {
      
      public static const HUD_CBOX_BETS:String = "cbox_betting";
      
      private static const GUI_SKIN_ID:String = null;
       
      
      private var mRequestTarget:RequestTargetBet;
      
      private var mRequestBetSku:String;
      
      private var mRequestBetDef:BetDef;
      
      private var mRequestBetBet:String;
      
      private var mRequestBetUserId:String;
      
      private var mRequestBetPlanetId:String;
      
      private var mBattleIsRunning:Boolean = false;
      
      private var mResultHasBeenRequested:Boolean = false;
      
      private var mCurrentBet:Bet;
      
      private var mPopupBetResult:PopupBetResult;
      
      private var mPopupWaitingForRival:DCIPopup;
      
      private var mWaitingDateStart:Number;
      
      private var mSentEventMyBattleEnded:Boolean;
      
      private var mSentEventHisBattleEnded:Boolean;
      
      private var mBetsCount:int;
      
      private var mPrefs:Dictionary;
      
      private var mGuiLookingRivalTextClock:ETextField;
      
      public function BetMng()
      {
         super();
         this.mCurrentBet = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         this.mPopupBetResult = null;
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
         this.mSentEventMyBattleEnded = false;
         this.mSentEventHisBattleEnded = false;
      }
      
      override protected function loadDoStep(step:int) : void
      {
      }
      
      override protected function unloadDo() : void
      {
         this.destroyRequestBet();
         this.destroyCurrentBet();
         this.mPopupBetResult = null;
         this.mPopupWaitingForRival = null;
         this.prefsUnload();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var betsCount:int = 0;
         var attribute:String = null;
         var currentBetXML:XML = null;
         var prefsXML:XML = null;
         if(step == 0)
         {
            if(mPersistenceData != null)
            {
               this.mBattleIsRunning = false;
               this.mResultHasBeenRequested = false;
               betsCount = 0;
               attribute = "betsCount";
               if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
               {
                  betsCount = EUtils.xmlReadInt(mPersistenceData,attribute);
               }
               currentBetXML = EUtils.xmlGetChildrenListAsXML(mPersistenceData,"Bet");
               if(this.createCurrentBetFromProfileXML(currentBetXML))
               {
                  betsCount++;
               }
               this.setBetsCount(betsCount);
               prefsXML = EUtils.xmlGetChildrenListAsXML(mPersistenceData,"Prefs");
               this.prefsBuild(prefsXML);
               this.checkIfCanShowBetIcon();
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         if(this.mCurrentBet != null)
         {
            this.mCurrentBet.unbuild();
            this.mCurrentBet = null;
         }
         if(this.mPopupBetResult != null)
         {
            this.mPopupBetResult = null;
         }
         this.guiUnbuild();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var event:Object = null;
         if(this.mCurrentBet != null)
         {
            if(this.mCurrentBet.isMyBattleEnded() && this.mSentEventMyBattleEnded == false)
            {
               event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyBetShowMyResults");
               event.currentBet = this.mCurrentBet;
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
               this.mSentEventMyBattleEnded = true;
            }
            if(this.mCurrentBet.areBothBattlesFinished() && this.mPopupBetResult != null && !this.mResultHasBeenRequested)
            {
               this.mResultHasBeenRequested = true;
               if(this.mBattleIsRunning)
               {
                  InstanceMng.getUserDataMng().updateBets_requestResult(this.mCurrentBet.getBetDef().getSku());
               }
               else
               {
                  this.notifyBattleResult(null);
               }
            }
         }
         this.guiLogicUpdate();
      }
      
      private function createCurrentBet(betXML:XML) : void
      {
         if(this.mCurrentBet == null)
         {
            this.mCurrentBet = new Bet();
            this.mCurrentBet.load();
         }
         else
         {
            this.mCurrentBet.unbuild();
         }
         this.mCurrentBet.build(betXML);
      }
      
      private function createCurrentBetFromProfileXML(xml:XML) : Boolean
      {
         var returnValue:Boolean = xml != null && EUtils.xmlIsAttribute(xml,"id");
         if(returnValue)
         {
            this.createCurrentBet(xml);
            this.mCurrentBet.setMyBattleEnded(true);
            this.mCurrentBet.setHisBattleEnded(true);
         }
         return returnValue;
      }
      
      private function destroyCurrentBet() : void
      {
         if(this.mCurrentBet != null)
         {
            this.mCurrentBet.unload();
            this.mCurrentBet = null;
         }
      }
      
      public function canShowBetIconInHud() : Boolean
      {
         var profile:Profile = null;
         var betsSettingsDefMng:BetsSettingsDefMng = null;
         if(this.useBets() && !InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            betsSettingsDefMng = InstanceMng.getBetsSettingsDefMng();
            if(profile.getLevel() >= betsSettingsDefMng.getMinimumPlayerLevel() && profile.getMaxHqLevelInAllPlanets() >= betsSettingsDefMng.getMinimumHQLevel())
            {
               return true;
            }
         }
         return false;
      }
      
      public function checkIfCanShowBetIcon() : void
      {
         if(this.canShowBetIconInHud())
         {
            InstanceMng.getUIFacade().setShowBetIcon();
         }
      }
      
      public function notifyClickBetIcon() : void
      {
         this.guiOpenBetSelectionPopup();
      }
      
      public function requestBet(betSku:String) : void
      {
         this.mRequestBetSku = betSku;
         var transaction:Transaction = this.getTransactionBetFromSku(betSku);
         var guiController:GUIController = InstanceMng.getGUIController();
         if(transaction == null || guiController.flowCheckIfEnoughCash(transaction,null,false))
         {
            InstanceMng.getApplication().cantAttackCheckOwner(this,true,null,null,2);
         }
      }
      
      private function requestActualBet(betSku:String) : void
      {
         this.mRequestBetDef = InstanceMng.getBetDefMng().getDefBySku(betSku) as BetDef;
         if(this.mRequestBetDef != null)
         {
            this.mRequestBetBet = this.getBetFromSku(betSku);
            this.mRequestBetSku = betSku;
            this.mRequestBetUserId = null;
            this.mRequestBetPlanetId = null;
            if(this.mRequestTarget == null)
            {
               this.mRequestTarget = new RequestTargetBet(2,"bets");
            }
            this.mRequestTarget.requestTarget({"sku":this.mRequestBetSku});
            this.mPopupWaitingForRival = this.guiOpenLookingRivalPopup();
            this.mWaitingDateStart = DCTimerUtil.currentTimeMillis();
         }
         else
         {
            DCDebug.traceCh("bets","BetMng.requestActualBet() sku <" + betSku + "> not found.");
         }
      }
      
      public function cancelRequestBet(dontSend:Boolean = false) : void
      {
         if(!dontSend)
         {
            InstanceMng.getUserDataMng().updateBets_cancelRequestBet();
         }
         this.destroyRequestBet();
         this.closePopupWaitingForMatch();
      }
      
      private function closePopupWaitingForMatch() : void
      {
         if(this.mPopupWaitingForRival != null)
         {
            InstanceMng.getPopupMng().closePopup(this.mPopupWaitingForRival);
            this.mPopupWaitingForRival = null;
         }
      }
      
      private function destroyRequestBet() : void
      {
         if(this.mRequestTarget != null)
         {
            this.mRequestTarget.unload();
            this.mRequestTarget = null;
         }
         this.mRequestBetSku = null;
         this.mRequestBetDef = null;
         this.mRequestBetUserId = null;
         this.mRequestBetPlanetId = null;
      }
      
      public function betRequestMatched(obj:XML) : void
      {
         var betTransaction:Transaction = null;
         if(this.mRequestBetSku != null)
         {
            betTransaction = this.getTransactionBetFromSku(this.mRequestBetSku);
            if(betTransaction == null || betTransaction.performAllTransactions(false))
            {
               this.mRequestTarget.setTargetInfo(obj);
               this.mRequestBetUserId = this.mRequestTarget.getUserId();
               this.mRequestBetPlanetId = this.mRequestTarget.getPlanetId();
               this.closePopupWaitingForMatch();
               this.mRequestTarget.attackTarget(false,false);
            }
            else
            {
               DCDebug.traceCh("bets","BetMng.betRequestMatched() : not enough resources for paying the bet.",0,true);
            }
         }
         else
         {
            DCDebug.traceCh("bets","BetMng.startActualBattle() : bet sku is null.",0,true);
         }
      }
      
      private function setHisBattleMaxDateOver() : void
      {
         if(this.mCurrentBet != null)
         {
            this.mCurrentBet.setHisBattleMaxDateOver(DCTimerUtil.currentTimeMillis() + InstanceMng.getSettingsDefMng().getBattleTime());
         }
      }
      
      public function notifyMyBattleLoad() : void
      {
         this.mWaitingDateStart = DCTimerUtil.currentTimeMillis();
      }
      
      public function notifyMyBattleStart() : Transaction
      {
         var betStr:String = null;
         var hisName:String = null;
         var hisUrl:String = null;
         var str:* = null;
         var betXML:XML = null;
         this.mBattleIsRunning = true;
         betStr = this.getBetFromSku(this.mRequestBetSku);
         if(betStr == "free")
         {
            betStr = "";
         }
         hisName = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getPlayerName();
         hisUrl = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().mThumbnailURL;
         str = "<Bet sku=\"" + this.mRequestBetSku + "\" bet=\"" + betStr + "\" accountId=\"" + this.mRequestBetUserId + "\" planetId=\"" + this.mRequestBetPlanetId + "\" state=\"" + 0 + "\" hisName=\"" + hisName + "\" hisUrl=\"" + hisUrl + "\"/>";
         betXML = EUtils.stringToXML(str);
         this.createCurrentBet(betXML);
         this.setHisBattleMaxDateOver();
         return this.getTransactionBetFromSku(this.mRequestBetSku);
      }
      
      public function notifyBattleTimeout() : void
      {
         this.mRequestTarget.notifyRequestForTargetError("battleTimeout");
      }
      
      public function notifyBattleTimeoutAccepted() : void
      {
         InstanceMng.getUnitScene().battleFinish();
      }
      
      public function notifyMyBattleIsOver(myCoins:Number, myCoinsTotal:Number, myMinerals:Number, myMineralsTotal:Number, myScore:Number, myScoreTotal:Number, myScorePercent:Number, myTime:Number) : void
      {
         this.mCurrentBet.setMyBattleEnded(true);
         this.mCurrentBet.setMyWholeProgress(this.createProgressXML(true,myCoins,myMinerals,myScore,myScorePercent,myTime,myCoinsTotal,myMineralsTotal,myScoreTotal));
         if(!this.mCurrentBet.isHisBattleEnded())
         {
            this.mWaitingDateStart = DCTimerUtil.currentTimeMillis();
         }
      }
      
      public function confirmMyBattleIsOver() : void
      {
         this.mPopupBetResult = this.guiOpenBetResultPopup() as PopupBetResult;
         this.mPopupBetResult.stateChangeState(0);
         this.mPopupBetResult.setCurrentBet(this.mCurrentBet);
      }
      
      public function notifyHisBattleStart() : void
      {
         this.setHisBattleMaxDateOver();
      }
      
      public function notifyHisBattleIsOver() : void
      {
         this.mCurrentBet.setHisBattleEnded(true);
      }
      
      public function notifyBattleResult(result:XML = null) : void
      {
         if(result != null)
         {
            this.createCurrentBetFromProfileXML(result);
         }
         this.confirmHisBattleIsOver();
      }
      
      public function confirmHisBattleIsOver() : void
      {
         this.mPopupBetResult.stateChangeState(1);
      }
      
      public function notifyHisBattleProgress(hisCoins:Number, hisMinerals:Number, hisScore:Number, hisScorePercent:Number) : void
      {
         if(this.mCurrentBet != null)
         {
            this.mCurrentBet.setHisWholeProgress(this.createProgressXML(false,hisCoins,hisMinerals,hisScore,hisScorePercent));
         }
      }
      
      public function closeBet() : void
      {
         var entryStr:String = null;
         var transaction:Transaction = null;
         var entry:Entry = null;
         if(this.mCurrentBet != null && this.mCurrentBet.areBothBattlesFinished())
         {
            entryStr = null;
            if(this.mCurrentBet.isADraw())
            {
               entryStr = this.mCurrentBet.getRefund();
            }
            else if(this.mCurrentBet.amITheWinner())
            {
               entryStr = this.mCurrentBet.getReward();
            }
            transaction = null;
            if(entryStr != null)
            {
               entry = EntryFactory.createSingleEntryFromString(entryStr);
               transaction = entry.toTransaction();
               transaction.performAllTransactions(false);
            }
            InstanceMng.getUserDataMng().updateBets_closeBet(transaction);
            if(this.mBattleIsRunning)
            {
               this.mBattleIsRunning = false;
               InstanceMng.getUnitScene().betIsOver();
               unbuild();
            }
            this.mPopupBetResult = null;
            this.mResultHasBeenRequested = false;
            this.mSentEventMyBattleEnded = false;
            this.mSentEventHisBattleEnded = false;
            this.destroyCurrentBet();
         }
         else
         {
            DCDebug.traceCh("bets","BetMng.closeBet(). This method shouldn\'t be called with the current bet still running.");
         }
      }
      
      public function createProgressXML(isMy:Boolean, coins:Number, minerals:Number, score:Number, scorePercent:Number, time:Number = 0, coinsTotal:Number = 0, mineralsTotal:Number = 0, scoreTotal:Number = 0) : XML
      {
         var str:* = null;
         if(isMy)
         {
            str = "<Bet myCoins=\"" + coins + "\" myCoinsTotal=\"" + coinsTotal + "\" myMinerals=\"" + minerals + "\" myMineralsTotal=\"" + mineralsTotal + "\" myScore=\"" + score + "\" myScoreTotal=\"" + scoreTotal + "\" myScorePercent=\"" + scorePercent + "\" myTime=\"" + time + "\"/>";
         }
         else
         {
            str = "<Bet hisCoins=\"" + coins + "\" hisCoinsTotal=\"" + coinsTotal + "\" hisMinerals=\"" + minerals + "\" hisMineralsTotal=\"" + mineralsTotal + "\" hisScore=\"" + score + "\" hisScoreTotal=\"" + scoreTotal + "\" hisScorePercent=\"" + scorePercent + "\" hisTime=\"" + time + "\"/>";
         }
         return EUtils.stringToXML(str);
      }
      
      override public function notify(e:Object) : Boolean
      {
         var _loc2_:* = e.cmd;
         if("NotifyAttackAllowed" === _loc2_)
         {
            this.requestActualBet(this.mRequestBetSku);
         }
         return true;
      }
      
      public function getWaitingForRivalTime() : Number
      {
         return this.getWaitingTime();
      }
      
      private function getWaitingTime() : Number
      {
         return DCTimerUtil.currentTimeMillis() - this.mWaitingDateStart;
      }
      
      private function getWaitingTimeInSeconds() : int
      {
         return (DCTimerUtil.currentTimeMillis() - this.mWaitingDateStart) / 1000;
      }
      
      public function getBetsCount() : int
      {
         return this.mBetsCount;
      }
      
      private function setBetsCount(value:int) : void
      {
         this.mBetsCount = value;
      }
      
      private function getBetDefFromSku(betSku:String, throwException:Boolean = false) : BetDef
      {
         var returnValue:BetDef = InstanceMng.getBetDefMng().getDefBySku(betSku) as BetDef;
         if(returnValue == null)
         {
            DCDebug.traceCh("bets","BetMng:getBetDefFromSku() not definition found for sku <" + betSku + ">.",0,throwException);
         }
         return returnValue;
      }
      
      public function getBetFromSku(betSku:String) : String
      {
         var returnValue:String = null;
         var def:BetDef = null;
         if(this.prefsIsBetSkuForFree(betSku))
         {
            returnValue = "free";
         }
         else
         {
            def = this.getBetDefFromSku(betSku,true);
            if(def != null)
            {
               returnValue = def.getBet();
            }
         }
         return returnValue;
      }
      
      public function getTransactionBetFromSku(betSku:String) : Transaction
      {
         var entry:Entry = null;
         var returnValue:Transaction = null;
         var betEntryString:String;
         if((betEntryString = this.getBetFromSku(betSku)) != "free")
         {
            entry = EntryFactory.createSingleEntryFromString(betEntryString,true);
            if(entry != null)
            {
               returnValue = entry.toTransaction();
            }
         }
         return returnValue;
      }
      
      public function getRewardFromSku(betSku:String) : String
      {
         var returnValue:String = null;
         var def:BetDef = this.getBetDefFromSku(betSku,true);
         if(def != null)
         {
            returnValue = def.getReward();
         }
         return returnValue;
      }
      
      public function getRewardEntryOfBetRequested() : Entry
      {
         var entryString:String = null;
         var returnValue:Entry = null;
         if(this.mRequestBetSku != null)
         {
            entryString = this.getRewardFromSku(this.mRequestBetSku);
            if(entryString != null)
            {
               returnValue = EntryFactory.createSingleEntryFromString(entryString);
            }
         }
         return returnValue;
      }
      
      public function getTransactionRewardFromSku(betSku:String) : Transaction
      {
         var entryString:String = this.getRewardFromSku(betSku);
         var entry:Entry = EntryFactory.createSingleEntryFromString(entryString);
         return entry.toTransaction();
      }
      
      private function prefsUnload() : void
      {
         this.prefsUnbuild();
         this.mPrefs = null;
      }
      
      private function prefsBuild(xml:XML) : void
      {
         var prefXML:XML = null;
         var sku:String = null;
         var freeUses:int = 0;
         var attribute:String = null;
         this.prefsUnbuild();
         if(xml != null)
         {
            if(this.mPrefs == null)
            {
               this.mPrefs = new Dictionary();
            }
            for each(prefXML in EUtils.xmlGetChildrenList(xml,"Pref"))
            {
               sku = EUtils.xmlReadString(prefXML,"sku");
               attribute = "freeUsesDone";
               this.mPrefs[sku] = EUtils.xmlIsAttribute(prefXML,attribute) ? EUtils.xmlReadInt(prefXML,attribute) : 0;
            }
         }
      }
      
      private function prefsUnbuild() : void
      {
         var k:* = null;
         if(this.mPrefs != null)
         {
            for(k in this.mPrefs)
            {
               delete this.mPrefs[k];
            }
         }
      }
      
      private function prefsIsBetSkuForFree(betSku:String) : Boolean
      {
         var returnValue:* = false;
         var amount:int = 0;
         if(this.mPrefs != null && this.mPrefs[betSku] != null)
         {
            amount = int(this.mPrefs[betSku]);
         }
         var def:BetDef;
         if((def = this.getBetDefFromSku(betSku)) != null)
         {
            returnValue = amount < def.getUsesForFree();
         }
         return returnValue;
      }
      
      public function useBets() : Boolean
      {
         return Config.useBets() && InstanceMng.getBetsSettingsDefMng().getUseBets();
      }
      
      private function guiUnbuild() : void
      {
         this.mGuiLookingRivalTextClock = null;
      }
      
      public function guiOpenBetSelectionPopup() : DCIPopup
      {
         var popup:PopupBetSelection = new PopupBetSelection();
         var popupId:String = "PopupBetSelection";
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         popup.setup(popupId,viewFactory,null);
         popup.setupPopup(viewFactory);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenBetResultPopup() : DCIPopup
      {
         var popupId:String = "PopupBetResult";
         var popup:PopupBetResult = new PopupBetResult();
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         popup.setup(popupId,viewFactory,null);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenLookingRivalPopup() : DCIPopup
      {
         var amount:String = null;
         var text:String = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerTextFieldIcon3");
         var container:ESpriteContainer = viewFactory.getESpriteContainer();
         var textInfo:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_info"));
         container.setContent("textTitle",textInfo);
         textInfo.applySkinProp(null,"text_body");
         var entry:Entry;
         if((entry = InstanceMng.getBetMng().getRewardEntryOfBetRequested()) != null)
         {
            amount = entry.getAmount();
            text = DCTextMng.replaceParameters(339,[amount]);
            textInfo.setText(text);
            container.eAddChild(textInfo);
         }
         var buttonCancel:EButton;
         (buttonCancel = viewFactory.getButton("btn_cancel",null,"L")).eAddEventListener("click",this.guiLookingRivalOnCancelBet);
         buttonCancel.setText(DCTextMng.getText(4));
         var textSearching:ETextField;
         (textSearching = viewFactory.getETextField(null,layoutFactory.getTextArea("text_looking_for"))).setText(DCTextMng.getText(340));
         container.setContent("textSearching",textSearching);
         container.eAddChild(textSearching);
         textSearching.applySkinProp(null,"text_title");
         var clockCont:ESprite = viewFactory.getESprite(null);
         container.setContent("clockCont",clockCont);
         var clockLayout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("IconTextMLarge");
         var textClock:ETextField = viewFactory.getETextField(null,clockLayout.getTextArea("text"));
         container.setContent("textClock",textClock);
         textClock.setText("0");
         clockCont.eAddChild(textClock);
         textClock.applySkinProp(null,"text_title_1");
         this.mGuiLookingRivalTextClock = textClock;
         var clockIcon:EImage = viewFactory.getEImage("icon_clock",null,true,clockLayout.getArea("icon"));
         container.setContent("iconClock",clockIcon);
         clockCont.eAddChild(clockIcon);
         clockCont.setLayoutArea(layoutFactory.getArea("area_clock"),true);
         container.eAddChild(clockCont);
         var popupId:String = "PopupLookingRival";
         var popup:EPopupSpeech;
         (popup = new EPopupSpeech()).setup(popupId,viewFactory,null);
         popup.setupESpriteSpeech(container);
         popup.setupCommon("looker",buttonCancel);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      private function guiLogicUpdate() : void
      {
         if(this.mGuiLookingRivalTextClock != null)
         {
            this.mGuiLookingRivalTextClock.setText(DCTextMng.convertTimeToStringColon(this.getWaitingForRivalTime()));
         }
      }
      
      private function guiLookingRivalOnCancelBet(e:EEvent = null) : void
      {
         this.cancelRequestBet();
      }
   }
}
