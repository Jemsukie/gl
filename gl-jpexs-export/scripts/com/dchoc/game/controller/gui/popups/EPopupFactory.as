package com.dchoc.game.controller.gui.popups
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.shop.ShopsDrawer;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.EPopupDailyReward;
   import com.dchoc.game.eview.popups.EPopupGetItem;
   import com.dchoc.game.eview.popups.EPopupIdleInvite;
   import com.dchoc.game.eview.popups.alliances.EPopupAllianceMembers;
   import com.dchoc.game.eview.popups.alliances.EPopupAlliances;
   import com.dchoc.game.eview.popups.alliances.EPopupCreateAlliance;
   import com.dchoc.game.eview.popups.alliances.EPopupEditAlliance;
   import com.dchoc.game.eview.popups.alliances.EPopupJoinAllianceRequests;
   import com.dchoc.game.eview.popups.alliances.EPopupNotificationAlliances;
   import com.dchoc.game.eview.popups.buffer.EPopupBufferTemplates;
   import com.dchoc.game.eview.popups.chips.EPopupChips;
   import com.dchoc.game.eview.popups.hangar.EPopupBunker;
   import com.dchoc.game.eview.popups.hangar.EPopupBunkerFriends;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningAntiZombieKit;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningBirthdayInfoList;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningEnd;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningGiftProgress;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningInitialKit;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningReadyToStart;
   import com.dchoc.game.eview.popups.happenings.EPopupHappeningWaveResult;
   import com.dchoc.game.eview.popups.help.EPopupHelp;
   import com.dchoc.game.eview.popups.help.EPopupHelpInvest;
   import com.dchoc.game.eview.popups.inventory.EPopupInventory;
   import com.dchoc.game.eview.popups.inventory.EPopupUseResources;
   import com.dchoc.game.eview.popups.inventory.EPopupWishlistError;
   import com.dchoc.game.eview.popups.levelup.EPopupLevelUp;
   import com.dchoc.game.eview.popups.levelup.EPopupUnitUpgraded;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImageAndText;
   import com.dchoc.game.eview.popups.messages.EPopupMessage;
   import com.dchoc.game.eview.popups.messages.EPopupMessageIcons;
   import com.dchoc.game.eview.popups.messages.EPopupSpeech;
   import com.dchoc.game.eview.popups.missions.EPopupMissionComplete;
   import com.dchoc.game.eview.popups.navigation.EBuyWorkerPopup;
   import com.dchoc.game.eview.popups.navigation.EPopupBattleResult;
   import com.dchoc.game.eview.popups.navigation.EPopupBuyColony;
   import com.dchoc.game.eview.popups.navigation.EPopupColonyBought;
   import com.dchoc.game.eview.popups.navigation.EPopupFriendPassedLeaderboard;
   import com.dchoc.game.eview.popups.navigation.EPopupFriendPassedLevelUp;
   import com.dchoc.game.eview.popups.navigation.EPopupPlanetAction;
   import com.dchoc.game.eview.popups.navigation.EPopupPreAttack;
   import com.dchoc.game.eview.popups.navigation.EPopupSelectColony;
   import com.dchoc.game.eview.popups.navigation.ESolarSystemPanel;
   import com.dchoc.game.eview.popups.options.EPopupOptions;
   import com.dchoc.game.eview.popups.unitsinfo.EPopupUnitsInfo;
   import com.dchoc.game.eview.popups.upgrade.EPopupUpgrade;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.hud.EHudProfileBasicView;
   import com.dchoc.game.eview.widgets.premiumShop.PremiumShopBox;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.invests.Invest;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.NPCDef;
   import com.dchoc.game.model.rule.SpyCapsulesShopDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.target.TargetDef;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.customizer.DCCustomizerButtonDef;
   import com.dchoc.toolkit.core.customizer.DCCustomizerPopupDef;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.Bitmap;
   
   public class EPopupFactory extends PopupFactory
   {
      
      private static const BLACK_HOLE_INTRO_TITLE_TIDS:Vector.<int> = new <int>[2713,2714];
      
      private static const BLACK_HOLE_INTRO_BODY_TIDS:Vector.<int> = new <int>[2707,2708];
      
      private static const BLACK_HOLE_COMPLETE_TITLE_TIDS:Vector.<int> = new <int>[2715,2716,2717,2718];
      
      private static const BLACK_HOLE_COMPLETE_BODY_TIDS:Vector.<int> = new <int>[2709,2710,2711,2712];
       
      
      private var mViewFactory:ViewFactory;
      
      public function EPopupFactory()
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function returnPopup(value:DCIPopup) : void
      {
         if(value != null && value is EGamePopup)
         {
            value.destroy();
            value = null;
         }
      }
      
      override public function getBunkerPopup(bunker:Bunker, visitor:Boolean) : DCIPopup
      {
         var popup:EPopupBunker = new EPopupBunker(bunker,visitor);
         popup.build("PopupBunker",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getUpdateUnitPopup(e:Object) : DCIPopup
      {
         var popup:EPopupUpgrade = new EPopupUpgrade();
         popup.setEvent(e);
         popup.setupUpgrade("PopupUpgrade",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getShowUnitInfoPopup(unitSku:String) : DCIPopup
      {
         var popup:EPopupUnitsInfo = new EPopupUnitsInfo();
         popup.setup("PopupShowUnitInfo",this.mViewFactory,this.getSkin());
         popup.setupPopup(unitSku);
         return popup;
      }
      
      override public function getUpgradeBuildingPopup(e:Object) : DCIPopup
      {
         var popup:EPopupUpgrade = new EPopupUpgrade();
         popup.setEvent(e);
         popup.setupUpgrade("PopupUpgradeBuildings",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getHelpAlliancesPopup() : DCIPopup
      {
         var popup:EPopupHelp = new EPopupHelp("alliances");
         popup.setup("PopupHelpAlliances",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getAllianceJoinRequestsPopup() : DCIPopup
      {
         var popup:EPopupJoinAllianceRequests = new EPopupJoinAllianceRequests();
         popup.setup("PopupJoinAllianceRequests",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getInvestPopup() : DCIPopup
      {
         return this.getComingSoonPopup();
      }
      
      override public function getHelpInvestPopup() : DCIPopup
      {
         var popup:EPopupHelp = new EPopupHelpInvest();
         popup.setup("PopupHelpInvest",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getHelpEmbassyPopup() : DCIPopup
      {
         var popup:EPopupHelp = new EPopupHelp("embassy");
         popup.setup("PopupHelpEmbassy",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      private function getInvestCommonRewardPopup(popupId:String, bodyMessage:String, transaction:Transaction, onClose:Function) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons()).setup(popupId,this.mViewFactory,skinSku);
         var title:String = DCTextMng.getText(3106);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("ambassador",title,content);
         var entry:Entry;
         var entryStr:String = (entry = transaction.getEntry()).getEntryRaw();
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(entryStr,"ContainerItemVerticalL",skinSku,false);
         popup.setupIcons(containers);
         var button:EButton;
         (button = popup.getCloseButton()).eAddEventListener("click",onClose);
         popup.setCloseButtonVisible(true);
         (button = this.mViewFactory.getButtonSocial(skinSku,null,DCTextMng.getText(0))).eAddEventListener("click",onClose);
         popup.addButton("EventShareButtonPressed",button);
         return popup;
      }
      
      override public function getInvestRewardSuccessPopup(invest:Invest, onClose:Function) : DCIPopup
      {
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(invest.getAccountId(),0);
         var nameText:String = uInfo != null ? uInfo.getPlayerName() : "UNKNOWN";
         var bodyMessage:String = DCTextMng.replaceParameters(3130,[nameText]);
         return this.getInvestCommonRewardPopup("PopupInvestRewardSuccess",bodyMessage,invest.getTransaction(),onClose);
      }
      
      override public function getInvestRewardFailPopup(invest:Invest, onClose:Function) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessage;
         (popup = new EPopupMessage()).setup("PopupInvestRewardFail",this.mViewFactory,skinSku);
         var goalLevel:Number = InstanceMng.getInvestsSettingsDefMng().getLevelGoal();
         var bodyMessage:String = DCTextMng.replaceParameters(3129,[goalLevel]);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("alliance_council_angry",DCTextMng.getText(3106),content);
         var button:EButton;
         (button = this.mViewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0))).eAddEventListener("click",onClose);
         popup.addButton("accept_button",button);
         return popup;
      }
      
      override public function getInvestRewardTutorialPopup(investorUserInfo:UserInfo, trans:Transaction, onClose:Function) : DCIPopup
      {
         var bodyMessage:String = null;
         var neededLevel:int = InstanceMng.getInvestsSettingsDefMng().getLevelGoal();
         var timeInDays:int = DCTimerUtil.msToDays(InstanceMng.getInvestsSettingsDefMng().getGoalTime());
         if(investorUserInfo == null)
         {
            bodyMessage = DCTextMng.replaceParameters(3127,["",neededLevel,timeInDays]);
         }
         else
         {
            bodyMessage = DCTextMng.replaceParameters(3126,[investorUserInfo.getPlayerName(),neededLevel,timeInDays]);
         }
         return this.getInvestCommonRewardPopup("PopupInvestRewardTutorial",bodyMessage,trans,onClose);
      }
      
      override public function getBunkerFriendsPopup(bunker:Bunker) : DCIPopup
      {
         var popup:EPopupBunkerFriends = new EPopupBunkerFriends(bunker);
         popup.build("PopupBunkerFriends",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getChipsPopup() : DCIPopup
      {
         var popup:EPopupChips = new EPopupChips();
         popup.setup("PopupChipsShop",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getNotEnoughWorkersPopup(event:Object) : DCIPopup
      {
         var price:* = NaN;
         var button:EButton = null;
         var popup:EPopupMessage = null;
         var entryStr:String = null;
         var containers:Array = null;
         var skinSku:String = null;
         var trans:Transaction;
         var needsPC:Boolean = (trans = event.transaction as Transaction).getDroidsWillBePayedWithCash();
         var priceReleaseDroid:Number = -InstanceMng.getRuleMng().getDroidReleasePrice();
         var instantOpCurrency:int = InstanceMng.getRuleMng().getInstantOperationsCurrency();
         var titleMessage:String = DCTextMng.getText(223);
         var bodyMessage:String = DCTextMng.getText(224);
         if(needsPC)
         {
            (popup = new EPopupMessage()).setup("PopupNotEnoughWorkers",this.mViewFactory,skinSku);
            price = trans.getLogicCashToPay();
            button = this.mViewFactory.getButtonChips(price + "",null,skinSku);
            popup.addButton("buy_fb_big_button",button);
         }
         else
         {
            price = priceReleaseDroid;
            (popup = new EPopupMessageIcons()).setup("PopupNotEnoughWorkers",this.mViewFactory,skinSku);
            entryStr = EntryFactory.createMineralsSingleEntry(price).getEntryRaw();
            containers = this.mViewFactory.getMultipleEntryContainers(entryStr,"ContainerItemVerticalL",skinSku,false);
            EPopupMessageIcons(popup).setupIcons(containers);
            button = this.mViewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0));
            popup.addButton("ok_button",button);
         }
         button.eAddEventListener("click",popup.notifyAccept);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("builder_normal",titleMessage,content);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(event);
         return popup;
      }
      
      override public function getNotEnoughResourcesPopup(e:Object) : DCIPopup
      {
         return this.getNotEnoughResourcesCommonPopup(e,"PopupNotEnoughResources",DCTextMng.getText(228),DCTextMng.getText(229),"orange_normal");
      }
      
      override public function getNotEnoughResourcesAndWorkerPopup(e:Object) : DCIPopup
      {
         return this.getNotEnoughResourcesCommonPopup(e,"PopupNotEnoughResourcesAndWorker",DCTextMng.getText(226),DCTextMng.getText(227),"builder_normal");
      }
      
      override public function getAddItemToWishlistErrorPopup(tid:int) : DCIPopup
      {
         var popup:EPopupWishlistError = new EPopupWishlistError();
         popup.setup("PopupWishlistError",this.mViewFactory,this.getSkin());
         popup.build(tid);
         popup.setIsStackable(true);
         return popup;
      }
      
      private function getNotEnoughResourcesCommonPopup(e:Object, popupId:String, titleMessage:String, bodyMessage:String, advisorId:String) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons()).setup(popupId,this.mViewFactory,skinSku);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup(advisorId,titleMessage,content);
         var entry:Entry;
         var trans:Transaction;
         var entryStr:String = (entry = (trans = e.transaction as Transaction).getNotEnoughResourcesEntry()).getEntryRaw();
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(entryStr,"ContainerItemVerticalL",skinSku,false);
         popup.setupIcons(containers);
         var price:int = trans.getLogicCashToPay();
         var priceText:String = DCTextMng.replaceParameters(281,[price]);
         var button:EButton = this.mViewFactory.getButtonChips(priceText,null,skinSku);
         popup.addButton("buy_fb_big_button",button);
         button.eAddEventListener("click",popup.notifyAccept);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(e);
         return popup;
      }
      
      override public function getInventoryPopup(tab:String) : DCIPopup
      {
         var popup:EPopupInventory = new EPopupInventory();
         popup.build("PopupInventory",InstanceMng.getViewFactory(),InstanceMng.getSkinsMng().getCurrentSkinSku());
         popup.setPageByTabSku(tab);
         return popup;
      }
      
      override public function getStartRepairingPopup(e:Object) : DCIPopup
      {
         var titleTid:int = 0;
         var bodyTid:int = 0;
         var popup:EPopupMessage = this.createMessagePopup("PopupStartRepairing");
         var skinSku:String = popup.getSkinSku();
         if(InstanceMng.getUserInfoMng().getProfileLogin().getProtectionTimeLeft() > 0)
         {
            titleTid = 151;
            bodyTid = 152;
         }
         else
         {
            titleTid = 149;
            bodyTid = 150;
         }
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(bodyTid),"text_body",skinSku);
         popup.setupPopup("builder_worried",DCTextMng.getText(titleTid),content);
         var button:EButton = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.getText(153));
         button.eAddEventListener("click",popup.notifyAccept);
         popup.addButton("ok_button",button);
         popup.setEvent(e);
         popup.setIsStackable(true);
         return popup;
      }
      
      override public function getMissionCompletePopup(e:Object) : DCIPopup
      {
         var popup:EPopupMissionComplete = new EPopupMissionComplete();
         popup.setup("PopupMissionComplete",this.mViewFactory,this.getSkin());
         var target:TargetDef = DCTarget(e.target).getDef() as TargetDef;
         e.missionTitle = DCTextMng.stringTidToText(target.getTutorialTitle()).toUpperCase();
         popup.setReward(target);
         return popup;
      }
      
      override public function getLevelUpPopup(e:Object) : DCIPopup
      {
         var popup:EPopupLevelUp = new EPopupLevelUp();
         popup.setup("NotifyLevelUp",this.mViewFactory,this.getSkin());
         popup.setLevelUp(e.level,e.friendsPassed);
         return popup;
      }
      
      override public function getUnitUpgradedPopup(unitDef:ShipDef, hasUnlocked:Boolean) : DCIPopup
      {
         var popup:EPopupUnitUpgraded = new EPopupUnitUpgraded();
         popup.setup("PopupUnitUpgraded",this.mViewFactory,this.getSkin());
         popup.setUnitUpgraded(unitDef,hasUnlocked);
         popup.setIsStackable(true);
         return popup;
      }
      
      override public function getRecycleWIOPopup(wio:WorldItemObject, e:Object) : DCIPopup
      {
         var skinSku:String = null;
         var transactionReward:Transaction = InstanceMng.getRuleMng().getTransactionDemolishEnd(wio.mDef,null);
         var titleMessage:String = DCTextMng.getText(126);
         var popup:EPopupMessage = this.getRefundPopup("PopupRecycleWIO",titleMessage,transactionReward,InstanceMng.getRuleMng().getDestroyItemProfitPercentage(),skinSku);
         var button:EButton = this.mViewFactory.getButtonCancel(skinSku);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         popup.addButton("cancel_button",button);
         button = this.mViewFactory.getButtonRecycle(skinSku);
         button.eAddEventListener("click",popup.notifyAccept);
         popup.addButton("ok_button",button);
         popup.setEvent(e);
         return popup;
      }
      
      override public function getCancelProcessPopup(e:Object, percentageOff:Number) : DCIPopup
      {
         var skinSku:String = null;
         var transactionReward:Transaction = e.transaction as Transaction;
         var titleMessage:String = DCTextMng.getText(112);
         var popup:EPopupMessage = this.getRefundPopup("PopupCancelProcess",titleMessage,transactionReward,percentageOff,skinSku);
         var button:EButton = this.mViewFactory.getButtonConfirm(skinSku);
         button.eAddEventListener("click",popup.notifyAccept);
         popup.addButton("ok_button",button);
         popup.setCloseButtonVisible(true);
         button = popup.getCloseButton();
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(e);
         return popup;
      }
      
      private function getRefundPopup(popupId:String, titlePopup:String, refundTransaction:Transaction, percentageOff:Number, skinSku:String = null) : EPopupMessage
      {
         var bodyMessage:String = null;
         var containers:Array = null;
         var transCoins:Number = refundTransaction.getTransCoins();
         var diffCoins:Number = refundTransaction.mDifferenceCoins.value;
         var transMinerals:Number = refundTransaction.getTransMinerals();
         var diffMinerals:Number = refundTransaction.mDifferenceMinerals.value;
         var entryStr:String;
         var entry:Entry;
         var isNone:Boolean = (entryStr = (entry = refundTransaction.getEntry()).getEntryRaw()) == null || entryStr == "";
         if(diffCoins == 0 && diffMinerals == 0)
         {
            if(transCoins == 0 && transMinerals == 0)
            {
               bodyMessage = DCTextMng.getText(687);
            }
            else
            {
               bodyMessage = DCTextMng.replaceParameters(128,[percentageOff]);
            }
         }
         else if(isNone)
         {
            bodyMessage = DCTextMng.getText(130);
         }
         else
         {
            bodyMessage = DCTextMng.replaceParameters(129,[percentageOff]);
         }
         if(!isNone)
         {
            bodyMessage += "\n" + DCTextMng.getText(131);
         }
         var popup:EPopupMessage;
         var isEntryValid:Boolean;
         (popup = (isEntryValid = entryStr != null && entryStr != "") ? new EPopupMessageIcons() : new EPopupMessage()).setup(popupId,this.mViewFactory,skinSku);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("builder_normal",titlePopup,content);
         if(isEntryValid)
         {
            containers = this.mViewFactory.getMultipleEntryContainers(entryStr,"ContainerItemVerticalL",skinSku,false);
            (popup as EPopupMessageIcons).setupIcons(containers);
         }
         return popup;
      }
      
      override public function getSpeedUpUnitsNoStoragePopup(e:Object) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessage = new EPopupMessage();
         popup.setup("PopupSpeedUpUnitsNoStorage",this.mViewFactory,skinSku);
         var bodyMessage:String = DCTextMng.replaceParameters(280,["\n" + e.popupText]);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("captain_normal",DCTextMng.getText(279),content);
         var transaction:Transaction;
         var price:int = (transaction = e.transaction as Transaction).getTransCashToPay();
         var priceText:String = DCTextMng.replaceParameters(281,[price]);
         var button:EButton = this.mViewFactory.getButtonChips(priceText,null,skinSku);
         button.eAddEventListener("click",popup.notifyAccept);
         popup.addButton("ok_button",button);
         popup.setCloseButtonVisible(true);
         button = popup.getCloseButton();
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(e);
         return popup;
      }
      
      override public function getWelcomeVisitingPopup(entry:Entry) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessageIcons = new EPopupMessageIcons();
         popup.setup("PopupWelcomeVisiting",this.mViewFactory,skinSku);
         var titleMessage:String = DCTextMng.getText(237);
         var bodyMessage:String = DCTextMng.getText(238);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("orange_normal",titleMessage,content);
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(entry.getEntryRaw(),"ContainerItemVerticalL",skinSku,false);
         popup.setupIcons(containers);
         var button:EButton = this.mViewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0));
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         popup.addButton("ok_button",button);
         return popup;
      }
      
      override public function getAllHelpsDoneWhenVisitingPopup(entry:Entry, onCallback:Function, buttonText:String) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons()).setup("PopupAllHelpsDoneWhenVisiting",this.mViewFactory,skinSku);
         var titleMessage:String = DCTextMng.getText(240);
         var bodyMessage:String = DCTextMng.getText(241);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("orange_normal",titleMessage,content);
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(entry.getEntryRaw(),"ContainerItemVerticalL",skinSku,false);
         popup.setupIcons(containers);
         popup.setCloseButtonVisible(true);
         var button:EButton;
         (button = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         button = this.mViewFactory.getButtonSocial(skinSku,null,buttonText);
         if(onCallback != null)
         {
            button.eAddEventListener("click",onCallback);
         }
         popup.addButton("ok_button",button);
         return popup;
      }
      
      override public function getSpeedUpUnlockingUnitPopup(unit:GameUnit, transaction:Transaction, event:Object) : DCIPopup
      {
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.createMessagePopup("NOTIFY_POPUP_OPEN_SPEEDITEM")).getSkinSku();
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(178),"text_body",skinSku);
         var title:String;
         (title = DCTextMng.getText(173)).toUpperCase();
         popup.setupPopup("captain_normal",title,content);
         var price:int = transaction.getTransCashToPay();
         var priceText:String = DCTextMng.replaceParameters(281,[price]);
         var button:EButton;
         (button = this.mViewFactory.getButtonChips(priceText,null,skinSku)).eAddEventListener("click",popup.notifyAccept);
         popup.addButton("ok_button",button);
         popup.setCloseButtonVisible(true);
         (button = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(event);
         return popup;
      }
      
      override public function getBuyColonyPopup(e:Object) : DCIPopup
      {
         var popup:EPopupBuyColony = new EPopupBuyColony();
         popup.setup("PopupBuyColony",this.mViewFactory,this.getSkin());
         popup.setEvent(e);
         popup.setupPopup();
         return popup;
      }
      
      override public function getColonyBoughtPopup(e:Object) : DCIPopup
      {
         var popup:EPopupColonyBought = new EPopupColonyBought();
         popup.setup("PopupBuyColony",this.mViewFactory,this.getSkin());
         popup.setEvent(e);
         popup.setupPopup();
         return popup;
      }
      
      override public function getSelectColonyPopup(e:Object) : DCIPopup
      {
         var popup:EPopupSelectColony = new EPopupSelectColony();
         popup.setEvent(e);
         popup.setup("PopupSelectColony",this.mViewFactory,this.getSkin());
         popup.setupPopup(e.newPlanetSku);
         return popup;
      }
      
      override public function getSolarSystemPlanetsPopup(filledPlanets:Vector.<Planet>, emptyPlanets:Vector.<Planet>, star:SolarSystem, isBookmarked:Boolean) : DCIPopup
      {
         var popup:ESolarSystemPanel;
         (popup = new ESolarSystemPanel()).setup("PanelSolarSystemPlanets",this.mViewFactory,this.getSkin());
         popup.setStar(star);
         if(filledPlanets != null && emptyPlanets != null)
         {
            popup.setupPopup(filledPlanets,emptyPlanets,isBookmarked);
         }
         return popup;
      }
      
      override public function getActionsOnPlanetPopup(planet:Planet, star:SolarSystem, isOccupied:Boolean) : DCIPopup
      {
         var popup:EPopupPlanetAction;
         (popup = new EPopupPlanetAction()).setup("PopupPlanetOccupiedOptions",this.mViewFactory,this.getSkin());
         popup.setupContent(planet,star,isOccupied);
         return popup;
      }
      
      override public function getBattleVersusUserResults(lootedCoins:Number, lootedMineral:Number, scoreGained:Number, allianceScore:Number, showAllianceScore:Boolean) : DCIPopup
      {
         var popup:EPopupBattleResult;
         (popup = new EPopupBattleResult()).setup("PopupBattleVersusUserResults",this.mViewFactory,this.getSkin());
         popup.setupPopup(lootedCoins,lootedMineral,scoreGained,allianceScore,showAllianceScore);
         return popup;
      }
      
      override public function getBattleVersusNpcResults(npcName:String, npcImageUrl:String, hqDestroyed:Boolean) : DCIPopup
      {
         var title:String = null;
         var advisor:String = null;
         var bodyText:String = null;
         var popup:EPopupMessage;
         (popup = new EPopupMessage()).setup("PopupBattleVersusNpcResults",this.mViewFactory,this.getSkin());
         var button:EButton = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(583),0,"btn_accept");
         popup.addButton("goHomeButton",button);
         button.eAddEventListener("click",this.battleVersusNpcResultsOnClose);
         if(hqDestroyed)
         {
            advisor = "captain_happy";
            title = DCTextMng.getText(181);
            bodyText = DCTextMng.getText(182);
         }
         else
         {
            advisor = "captain_worried";
            title = DCTextMng.getText(179);
            bodyText = DCTextMng.getText(180);
         }
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("ContainerTextIcons");
         var container:ESpriteContainer = new ESpriteContainer();
         var field:ETextField;
         (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body")).setText(bodyText);
         container.eAddChild(field);
         container.setContent("textfield",field);
         var img:EHudProfileBasicView = this.mViewFactory.getProfileInfoBasic(null);
         var parts:Array = npcImageUrl.split("/");
         img.setBasicUserInfo(npcName,parts[parts.length - 1],null);
         container.eAddChild(img);
         container.setContent("profile",img);
         img.layoutApplyTransformations(layoutFactory.getArea("profile_extended"));
         popup.setupPopup(advisor,title,container);
         return popup;
      }
      
      private function battleVersusNpcResultsOnClose(e:EEvent) : void
      {
         InstanceMng.getUnitScene().closeBattleVersusNpcResultPopup();
      }
      
      override public function getCraftingPendingPopup(e:Object) : DCIPopup
      {
         var button:EButton = null;
         var popup:EPopupMessage = this.createMessagePopup("PopupCraftingPending");
         var skinSku:String = popup.getSkinSku();
         var titleTid:int = 283;
         var bodyTid:int = 284;
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(bodyTid),"text_body",skinSku);
         popup.setupPopup("inventory_normal",DCTextMng.getText(titleTid),content);
         button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.getText(286));
         button.eAddEventListener("click",this.craftingPendingPopupOnCraft);
         popup.addButton("craft_button",button);
         button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.getText(285));
         button.eAddEventListener("click",this.craftingPendingPopupOnFight);
         popup.addButton("fight_button",button);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         popup.setEvent(e);
         return popup;
      }
      
      private function craftingPendingPopupOnButton(buttonSku:String) : void
      {
         var event:Object = null;
         var popup:EGamePopup = InstanceMng.getPopupMng().getPopupOpened("PopupCraftingPending") as EGamePopup;
         if(popup != null)
         {
            event = popup.getEvent();
            if(event != null)
            {
               popup.sendEventBack(buttonSku);
            }
         }
      }
      
      private function craftingPendingPopupOnCraft(e:Object) : void
      {
         this.craftingPendingPopupOnButton("craft_button");
      }
      
      private function craftingPendingPopupOnFight(e:Object) : void
      {
         this.craftingPendingPopupOnButton("fight_button");
      }
      
      override public function getSpyCapsulesDailyRewardPopup(entry:Entry) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMessageIcons = new EPopupMessageIcons();
         popup.setup("PopupSpyCapsulesDailyReward",this.mViewFactory,skinSku);
         var titleMessage:String = DCTextMng.getText(450);
         var bodyMessage:String = DCTextMng.getText(451);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyMessage,"text_body",skinSku);
         popup.setupPopup("advisor_spy_normal",titleMessage,content);
         var containers:Array = this.mViewFactory.getMultipleEntryContainers(entry.getEntryRaw(),"ContainerItemVerticalL",skinSku,false);
         popup.setupIcons(containers);
         var button:EButton = this.mViewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0));
         button.eAddEventListener("click",this.spyCapsulesDailyRewardOnAccept);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         popup.addButton("ok_button",button);
         return popup;
      }
      
      public function getBuyResourcesPopup(popupId:String, title:String, body:String) : DCIPopup
      {
         var i:int = 0;
         var container:PremiumShopBox = null;
         var entryGive:Entry = null;
         var entryPay:Entry = null;
         var resourceIdsIndex:int = 0;
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons("PopupShopResources")).setup(popupId,this.mViewFactory,skinSku);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",body,"text_body",skinSku);
         popup.setupPopup("orange_happy",title,content);
         var containers:Array = [];
         var shopDrawer:ShopsDrawer;
         var entriesAmount:int = (shopDrawer = InstanceMng.getShopsDrawer()).resourcesGetEntriesAmount();
         var resourceIdsLength:int;
         var resourceIds:Vector.<String>;
         var resourceIdsStartIndex:int = (resourceIdsLength = int((resourceIds = popupId == "PopupBuyCoins" ? ResourceIDs.BUY_COINS_RESOURCE_IDS : ResourceIDs.BUY_MINERALS_RESOURCE_IDS).length)) - entriesAmount;
         for(i = 0; i < entriesAmount; )
         {
            entryGive = shopDrawer.resourcesGetEntryToGiveById(i);
            if((resourceIdsIndex = resourceIdsStartIndex + i) >= resourceIdsLength)
            {
               resourceIdsIndex = resourceIdsLength - 1;
            }
            entryGive.setResourceId(resourceIds[resourceIdsIndex]);
            entryPay = shopDrawer.resourcesGetEntryToPayById(i);
            (container = new PremiumShopBox(this.mViewFactory,skinSku,false,this.resourcesBuyAction)).build();
            container.setInfo(entryGive,entryPay);
            container.name = "button_" + i;
            containers.push(container);
            i++;
         }
         popup.setupIcons(containers);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",this.onResourcesPopupClose);
         return popup;
      }
      
      override public function getShowIncomingAttackPopup(wave:String, npcSku:String) : DCIPopup
      {
         var advisorId:String = null;
         var title:String = DCTextMng.getText(299);
         var body:String = DCTextMng.getText(300);
         var npcDef:NPCDef;
         if((npcDef = InstanceMng.getNPCDefMng().getDefBySku(npcSku) as NPCDef) != null)
         {
            advisorId = npcDef.getMoodNormalResourceId();
         }
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons("PopupShopResources")).setup("PopupShowIncomingAttack",this.mViewFactory,skinSku);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",body,"text_body",skinSku);
         popup.setupPopup(advisorId,title,content);
         var units:Array = this.getESpritesFromWave(wave);
         popup.setupIcons(units,4);
         var button:EButton = this.mViewFactory.getButtonCancel(skinSku,null,DCTextMng.getText(302));
         popup.addButton("cancel_button",button);
         button.eAddEventListener("click",this.showIncomingAttackOnCancel);
         button = this.mViewFactory.getButton("btn_accept",null,"XL",DCTextMng.getText(301));
         popup.addButton("ok_button",button);
         button.eAddEventListener("click",this.showIncomingAttackOnAccept);
         return popup;
      }
      
      private function getESpriteForUnit(unitDef:UnitDef, amount:int) : ESprite
      {
         var returnValue:EUnitItemView = new EUnitItemView();
         returnValue.build(false,false);
         returnValue.fillDataFromParams(unitDef.getSku(),unitDef as ShipDef,amount);
         returnValue.setupMouseEventsForUnitDescription();
         return returnValue;
      }
      
      private function getESpriteForItem(itemsDef:ItemsDef, amount:int) : ESprite
      {
         var returnValue:EUnitItemView = new EUnitItemView();
         returnValue.build(false,false);
         returnValue.fillDataFromItemParams(itemsDef.getSku(),itemsDef,amount);
         returnValue.setupMouseEventsForUnitDescription();
         return returnValue;
      }
      
      private function getESpritesFromWave(wave:String) : Array
      {
         var i:int = 0;
         var unitDef:UnitDef = null;
         var defsListLength:int = 0;
         var unitsAmount:int = 0;
         var returnValue:Array = [];
         var defsList:Vector.<UnitDef> = new Vector.<UnitDef>(0);
         var amounts:Vector.<int> = new Vector.<int>(0);
         if(wave != "")
         {
            InstanceMng.getUnitScene().wavesGetUnitDefsFromString(wave,false,defsList,amounts);
            defsListLength = int(defsList.length);
            unitsAmount = Math.min(defsListLength,8);
            for(i = 0; i < unitsAmount; )
            {
               unitDef = defsList[i];
               returnValue.push(this.getESpriteForUnit(unitDef,amounts[i]));
               i++;
            }
         }
         return returnValue;
      }
      
      private function getESpritesFromReward(reward:Array) : Array
      {
         var posunitDef:DCDef = null;
         var itemSku:String = null;
         var amount:int = 0;
         var item:Object = null;
         var itemDef:ItemsDef = null;
         var unitDef:UnitDef = null;
         var returnValue:Array = [];
         for each(item in reward)
         {
            if(item is Array)
            {
               itemSku = String(item[0]);
               amount = parseInt(item[1]);
            }
            else
            {
               itemSku = String(String(item).split(":")[0]);
               amount = parseInt(String(item).split(":")[1]);
            }
            itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
            if((posunitDef = InstanceMng.getShipDefMng().getDefBySku(itemDef.getActionParams()[0])) is UnitDef)
            {
               returnValue.push(this.getESpriteForUnit(unitDef as UnitDef,amount));
            }
            else
            {
               returnValue.push(this.getESpriteForItem(itemDef,amount));
            }
         }
         return returnValue;
      }
      
      private function showIncomingAttackOnAccept(e:EEvent) : void
      {
         InstanceMng.getUnitScene().showIncomingAttackOnAccept();
      }
      
      private function showIncomingAttackOnCancel(e:EEvent) : void
      {
         InstanceMng.getUnitScene().showIncomingAttackOnCancel();
      }
      
      override public function getBuyWorkerPopup(workerDef:DroidDef) : DCIPopup
      {
         var popup:EBuyWorkerPopup = new EBuyWorkerPopup();
         popup.setup("PopupBuyWorker",this.mViewFactory,this.getSkin());
         popup.setupPopup(workerDef);
         return popup;
      }
      
      override public function getBuyCoinsPopup() : DCIPopup
      {
         var title:String = DCTextMng.getText(306);
         var body:String = DCTextMng.getText(308);
         return this.getBuyResourcesPopup("PopupBuyCoins",title,body);
      }
      
      override public function getBuyMineralsPopup() : DCIPopup
      {
         var title:String = DCTextMng.getText(307);
         var body:String = DCTextMng.getText(309);
         return this.getBuyResourcesPopup("PopupBuyMinerals",title,body);
      }
      
      override public function getBuySpyCapsulesPopup() : DCIPopup
      {
         var container:PremiumShopBox = null;
         var def:SpyCapsulesShopDef = null;
         var i:int = 0;
         var entryGive:Entry = null;
         var entryPay:Entry = null;
         var popupId:String = "PopupBuySpyCapsules";
         var title:String = DCTextMng.getText(452);
         var body:String = DCTextMng.getText(453);
         var skinSku:String = null;
         var popup:EPopupMessageIcons;
         (popup = new EPopupMessageIcons("PopupShopResources")).setup(popupId,this.mViewFactory,skinSku);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",body,"text_body",skinSku);
         popup.setupPopup("advisor_spy_normal",title,content);
         var containers:Array = [];
         var defs:Vector.<DCDef> = InstanceMng.getSpyCapsulesShopDefMng().getDefs();
         var length:int = int(defs.length);
         for(i = 0; i < length; )
         {
            def = defs[i] as SpyCapsulesShopDef;
            container = new PremiumShopBox(this.mViewFactory,skinSku,false,this.spyCapsulesBuyAction);
            entryGive = def.getEntryReward();
            entryPay = def.getEntryPay();
            container = new PremiumShopBox(this.mViewFactory,skinSku,false,this.spyCapsulesBuyAction);
            container.build();
            container.setInfo(entryGive,entryPay);
            container.name = "button_" + i;
            containers.push(container);
            i++;
         }
         popup.setupIcons(containers);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",popup.notifyPopupMngClose);
         return popup;
      }
      
      private function spyCapsulesBuyAction(psb:PremiumShopBox) : void
      {
         var id:int = 0;
         var name:String = psb.name;
         var tokens:Array = name.split("_");
         if(tokens.length == 2)
         {
            id = parseInt(tokens[1]);
            InstanceMng.getShopsDrawer().spyCapsulesNotifyPurchaseAccepted(id);
         }
      }
      
      private function onResourcesPopupClose(e:EEvent) : void
      {
         InstanceMng.getShopsDrawer().resourcesClosePopup();
      }
      
      private function resourcesBuyAction(psb:PremiumShopBox) : void
      {
         var id:int = 0;
         var name:String = psb.name;
         var tokens:Array = name.split("_");
         if(tokens.length == 2)
         {
            id = parseInt(tokens[1]);
            InstanceMng.getShopsDrawer().resourcesNotifyPurchaseAccepted(id);
         }
      }
      
      private function spyCapsulesDailyRewardOnAccept(e:EEvent) : void
      {
         InstanceMng.getVisitorMng().giveSpyCapsulesDailyReward();
      }
      
      override public function getNpcAttackIsOverPopup() : DCIPopup
      {
         var popup:EPopupMessage = this.createMessagePopup("PopupNpcAttackIsOver");
         var skinSku:String = popup.getSkinSku();
         var titleTid:int = 303;
         var bodyText:String = DCTextMng.getText(304) + "\n" + DCTextMng.replaceParameters(4088,[InstanceMng.getWorld().getSurvivalPercentage()]);
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyText,"text_body",skinSku);
         popup.setupPopup("captain_normal",DCTextMng.getText(titleTid),content);
         var button:EButton = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.getText(153));
         button.eAddEventListener("click",this.onNpcAttackIsOverPopupClick);
         popup.addButton("ok_button",button);
         return popup;
      }
      
      private function onNpcAttackIsOverPopupClick(e:EEvent) : void
      {
         InstanceMng.getUnitScene().guiCloseNpcAttackIsOverPopup();
      }
      
      private function getNotificationImageAndTextSinglePopup(popupId:String, imageId:String, title:String, body:String, onClose:Function = null) : ENotificationWithImageAndText
      {
         var imageIds:Vector.<String>;
         (imageIds = new Vector.<String>(0)).push(imageId);
         var titles:Vector.<String>;
         (titles = new Vector.<String>(0)).push(title);
         var bodies:Vector.<String>;
         (bodies = new Vector.<String>(0)).push(body);
         return this.getNotificationImageAndTextPopup(popupId,imageIds,titles,bodies,onClose);
      }
      
      private function getNotificationImageAndTextPopup(popupId:String, imageIds:Vector.<String>, titles:Vector.<String>, bodies:Vector.<String>, onClose:Function = null) : ENotificationWithImageAndText
      {
         var button:EButton = null;
         var skinSku:String = null;
         var popup:ENotificationWithImageAndText;
         (popup = new ENotificationWithImageAndText()).setup(popupId,this.mViewFactory,skinSku);
         popup.setContents(imageIds,titles,bodies);
         if(onClose != null)
         {
            (button = popup.getCloseButton()).eAddEventListener("click",onClose);
         }
         return popup;
      }
      
      override public function getMissionMercenariesInfo(titleTid:String, bodyTid:String, buttonTid:String, onAccept:Function) : DCIPopup
      {
         var bodyMessage:String = DCTextMng.replaceParameters(TextIDs[bodyTid],[InstanceMng.getUserInfoMng().getProfileLogin().getPlayerFirstName()]);
         var popup:ENotificationWithImageAndText;
         var skinSku:String = (popup = this.getNotificationImageAndTextSinglePopup("PopupMissionMercenariesInfo","mission_mercenaries_info",DCTextMng.stringTidToText(titleTid),bodyMessage)).getSkinSku();
         var button:EButton;
         (button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.stringTidToText(buttonTid))).eAddEventListener("click",onAccept);
         popup.addButton("ok_button",button);
         popup.setCloseButtonVisible(false);
         return popup;
      }
      
      override public function getMissionMercenariesCompleted(titleTid:String, bodyTid:String, onClose:Function) : DCIPopup
      {
         var button:EButton = null;
         var popup:ENotificationWithImageAndText;
         var skinSku:String = (popup = this.getNotificationImageAndTextSinglePopup("PopupMissionMercenariesCompleted","mission_mercenaries_completed",DCTextMng.stringTidToText(titleTid),DCTextMng.stringTidToText(bodyTid),onClose)).getSkinSku();
         (button = this.mViewFactory.getButton("btn_social",skinSku,"XL",DCTextMng.getText(5))).eAddEventListener("click",onClose);
         popup.addButton("ok_button",button);
         if(onClose != null)
         {
            (button = popup.getCloseButton()).eAddEventListener("click",onClose);
         }
         return popup;
      }
      
      override public function getBlackHoleIntroPopup(onClose:Function) : DCIPopup
      {
         return this.getNotificationImageAndTextPopup("PopupBlackHoleIntro",ResourceIDs.ILLUS_BLACK_HOLE_INFO_SEQUENCE,DCTextMng.tidsToTexts(BLACK_HOLE_INTRO_TITLE_TIDS),DCTextMng.tidsToTexts(BLACK_HOLE_INTRO_BODY_TIDS),onClose);
      }
      
      override public function getBlackHoleShowRewardPopup(onClose:Function) : DCIPopup
      {
         return this.getNotificationImageAndTextPopup("PopupBlackHoleShowReward",ResourceIDs.ILLUS_BLACK_HOLE_COMPLETED_SEQUENCE,DCTextMng.tidsToTexts(BLACK_HOLE_COMPLETE_TITLE_TIDS),DCTextMng.tidsToTexts(BLACK_HOLE_COMPLETE_BODY_TIDS),onClose);
      }
      
      override public function getIdlePopup(type:String, onClose:Function) : DCIPopup
      {
         var popup:EPopupIdleInvite = new EPopupIdleInvite(type);
         popup.setup("NotifyAFKPopup",InstanceMng.getViewFactory(),null);
         popup.build();
         popup.setOnCloseFunction(onClose);
         return popup;
      }
      
      override public function getColonyShieldWillBeLostPopup(onAccept:Function, onCancel:Function) : DCIPopup
      {
         var button:EButton = null;
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.createMessagePopup("colonyShieldWillBeLost")).getSkinSku();
         var titleTid:int = 191;
         var bodyTid:int = 192;
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(bodyTid),"text_body",skinSku);
         popup.setupPopup("orange_normal",DCTextMng.getText(titleTid),content);
         button = this.mViewFactory.getButtonCancel(skinSku,null,DCTextMng.getText(4));
         button.eAddEventListener("click",onCancel);
         popup.addButton("cancel_button",button);
         button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",DCTextMng.getText(285));
         button.eAddEventListener("click",onAccept);
         popup.addButton("fight_button",button);
         return popup;
      }
      
      override public function getErrorFromServer(advisorId:String, title:String, bodyText:String, buttonText:String, onAccept:Function) : DCIPopup
      {
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.createMessagePopup("PopupErrorFromServer")).getSkinSku();
         var titleTid:int = 191;
         var bodyTid:int = 192;
         var content:ESprite = this.mViewFactory.getContentOneText("ContainerTextField",bodyText,"text_body",skinSku);
         popup.setupPopup(advisorId,title,content);
         var button:EButton;
         (button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",buttonText)).eAddEventListener("click",onAccept);
         popup.addButton("fight_button",button);
         return popup;
      }
      
      private function getTidString(tid:String) : String
      {
         var str:String = String(TextIDs[tid]);
         return str == null ? tid : DCTextMng.getText(str);
      }
      
      override public function getInformationPopup(title:String, image:EImage, text:String, skinSku:String = null) : EGamePopup
      {
         var areaName:String = null;
         var popup:EGamePopup;
         (popup = new EGamePopup()).setup("info",this.mViewFactory,skinSku);
         var eBody:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var bodyLayoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("ContainerImgText");
         if(image != null)
         {
            areaName = "img";
            image.setLayoutArea(bodyLayoutFactory.getArea(areaName),true);
            eBody.eAddChild(image);
            eBody.setContent(areaName,image);
         }
         areaName = "text";
         var eText:ETextField;
         (eText = this.mViewFactory.getETextField(skinSku,bodyLayoutFactory.getTextArea(areaName),"text_body")).setText(text);
         eBody.eAddChild(eText);
         eBody.setContent(areaName,eText);
         popup.setupStructure("PopS","pop_s",title,eBody);
         return popup;
      }
      
      override public function getWelcomePopup(def:DCCustomizerPopupDef, onAccept:Function, onClose:Function) : DCIPopup
      {
         var image:EImage = null;
         var skinSku:String = null;
         var title:String = def.getTitle();
         var bodyText:String = def.getText().replace(/(\\n |\\n)/g,"\n");
         title = this.getTidString(title);
         bodyText = this.getTidString(bodyText);
         var imageUrl:String = def.getImageUrl();
         var imageBitmap:Bitmap = def.getImage();
         if(imageUrl != null && imageBitmap != null)
         {
            image = this.mViewFactory.getEImageFromBitmapData(imageUrl,imageBitmap.bitmapData);
         }
         var buttonDef:DCCustomizerButtonDef = def.getButton();
         var buttonText:String = this.getTidString(buttonDef.getLabel());
         var popup:EGamePopup = this.getInformationPopup(title,image,bodyText);
         var button:EButton;
         (button = this.mViewFactory.getButton("btn_accept",skinSku,"XL",buttonText)).eAddEventListener("click",onAccept);
         popup.addButton("accept_button",button);
         popup.setCloseButtonVisible(true);
         var buttonClose:EButton;
         (buttonClose = popup.getCloseButton()).eAddEventListener("click",onClose);
         return popup;
      }
      
      public function getSkin(popupId:String = null) : String
      {
         return null;
      }
      
      private function createMessagePopup(popupId:String) : EPopupMessage
      {
         var skinSku:String = null;
         var popup:EPopupMessage = new EPopupMessage();
         popup.setup(popupId,this.mViewFactory,skinSku);
         return popup;
      }
      
      override public function getCreateAlliancePopup() : DCIPopup
      {
         var popup:EPopupCreateAlliance = new EPopupCreateAlliance();
         popup.setIsStackable(true);
         popup.setup("PopupCreateAlliances",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getEditAlliancePopup() : DCIPopup
      {
         var popup:EPopupEditAlliance = new EPopupEditAlliance();
         popup.setIsStackable(true);
         popup.setup("PopupEditAlliance",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getAlliancePopup() : DCIPopup
      {
         var popup:EPopupAlliances = new EPopupAlliances();
         popup.setup("PopupAlliances",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getAllianceMembersPopup(alliance:Alliance, stripe:ESprite) : DCIPopup
      {
         var popup:EPopupAllianceMembers = new EPopupAllianceMembers();
         popup.setup("PopupAllianceMembers",this.mViewFactory,this.getSkin());
         popup.setInfo(alliance,stripe);
         popup.setIsStackable(true);
         return popup;
      }
      
      override public function getAlliancesNotification(e:Object) : DCIPopup
      {
         var popup:EPopupNotificationAlliances = new EPopupNotificationAlliances();
         popup.setup("PopupAlliancesNotification",this.mViewFactory,this.getSkin());
         popup.setIsStackable(true);
         popup.setupPopup(e);
         return popup;
      }
      
      override public function getFriendPassedInLevelUpPopup(event:Object) : DCIPopup
      {
         var popup:EPopupFriendPassedLevelUp = new EPopupFriendPassedLevelUp();
         popup.setEvent(event);
         popup.setup("PopupFriendPassedInLevelUp",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getFriendPassedInRankingPopup() : DCIPopup
      {
         var popup:EPopupFriendPassedLeaderboard = new EPopupFriendPassedLeaderboard();
         popup.setup("PopupFriendPassedInRanking",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getSpeechPopup(e:Object, advisorId:String, title:String, body:String, buttonText:String, sound:String, onAccept:Function, useSmall:Boolean, advisorSize:int, vAlign:int, advisorOnRightSide:Boolean) : DCIPopup
      {
         if(advisorId.indexOf("npc_B") > -1)
         {
            advisorOnRightSide = true;
         }
         var skinSku:String = null;
         var popup:EPopupSpeech;
         (popup = new EPopupSpeech()).setIsStackable(true);
         popup.setup("PopupSpeech",this.mViewFactory,skinSku);
         var button:EButton = null;
         if(buttonText != null)
         {
            button = this.mViewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0));
            if(onAccept != null)
            {
               button.eAddEventListener("click",onAccept);
               button.setText(buttonText);
            }
         }
         popup.setupTextSpeech(title,body,advisorOnRightSide);
         popup.setupCommon(advisorId,button,useSmall,vAlign);
         if(sound != null)
         {
            popup.setSoundAttached(sound);
         }
         return popup;
      }
      
      override public function getPreAttackPopup(targetAccountId:String, targetPlanetId:String, targetPlanetSku:String, onAccept:Function, onClose:Function) : DCIPopup
      {
         var popup:EPopupPreAttack;
         (popup = new EPopupPreAttack()).setup("PopupPreAttack",this.mViewFactory,this.getSkin());
         popup.setupPopup(targetAccountId,targetPlanetId,targetPlanetSku,onAccept,onClose);
         return popup;
      }
      
      override public function getHappeningIntroStoryPopup(imageId:String, title:String, body:String, buttonTid:String) : DCIPopup
      {
         var popup:ENotificationWithImageAndText = this.getNotificationImageAndTextSinglePopup("PopupHappeningStory",imageId,title,body);
         var button:EButton;
         (button = this.mViewFactory.getButton("btn_accept",null,"XL",DCTextMng.stringTidToText(buttonTid))).eAddEventListener("click",popup.notifyPopupMngClose);
         popup.addButton("ok_button",button);
         return popup;
      }
      
      override public function getHappeningStartEventPopup(buttonTid:String, event:Object) : DCIPopup
      {
         var popup:ENotificationWithImageAndText = this.getNotificationImageAndTextPopup("PopupHappeningStart",event.images,event.titles,event.bodies);
         popup.setEvent(event);
         return popup;
      }
      
      override public function getHappeningStartEventBirthdayPopup(happeningDef:HappeningDef, event:Object) : DCIPopup
      {
         var popup:EPopupHappeningBirthdayInfoList = new EPopupHappeningBirthdayInfoList();
         popup.setup("PopupHappeningBirthdayInitial",this.mViewFactory,null);
         popup.setupHappening(happeningDef);
         popup.setEvent(event);
         return popup;
      }
      
      override public function getHappeningGiftProgressPopup(happeningDef:HappeningDef, event:Object) : DCIPopup
      {
         var popup:EPopupHappeningGiftProgress = new EPopupHappeningGiftProgress();
         popup.setup("PopupHappeningWinter",this.mViewFactory,null);
         popup.setupHappening(happeningDef);
         popup.setEvent(event);
         return popup;
      }
      
      override public function getHappeningInitialKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         var popup:EPopupHappeningInitialKit = new EPopupHappeningInitialKit();
         popup.setup("PopupHappeningInitialKit",this.mViewFactory,null);
         popup.setupHappening(happeningDef);
         return popup;
      }
      
      override public function getHappeningAntiZombieKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         var popup:EPopupHappeningAntiZombieKit = new EPopupHappeningAntiZombieKit();
         popup.setup("PopupHappeningAntizombieKit",this.mViewFactory,null);
         popup.setupHappening(happeningDef);
         return popup;
      }
      
      override public function getHappeningReadyToStartPopup(happening:Happening, waves:String, canSkip:Boolean) : DCIPopup
      {
         var popup:EPopupHappeningReadyToStart;
         (popup = new EPopupHappeningReadyToStart()).setup("PopupHappeningReadyToStart",this.mViewFactory,null);
         popup.setupHappening(happening,this.getESpritesFromWave(waves),canSkip);
         return popup;
      }
      
      override public function getHappeningWaveResultPopup(happening:Happening) : DCIPopup
      {
         var popup:EPopupHappeningWaveResult = new EPopupHappeningWaveResult();
         popup.setup("PopupHappeningWaveResult",this.mViewFactory,null);
         popup.setupHappening(happening);
         return popup;
      }
      
      override public function getHappeningSkipEventPopup(happening:Happening) : DCIPopup
      {
         var popup:EPopupHappeningEnd = new EPopupHappeningEnd();
         popup.setup("PopupHappeningEndEvent",InstanceMng.getViewFactory(),null);
         popup.build(happening,this.getESpritesFromReward(happening.getHappeningDef().getReward().split(",")),0,false);
         return popup;
      }
      
      override public function getHappeningEndEventPopup(happening:Happening, canShare:Boolean) : DCIPopup
      {
         var popup:EPopupHappeningEnd = new EPopupHappeningEnd();
         popup.setup("PopupHappeningEndEvent",InstanceMng.getViewFactory(),null);
         popup.build(happening,this.getESpritesFromReward(happening.getHappeningDef().getReward().split(",")),1,canShare);
         return popup;
      }
      
      override public function getDailyRewardPopup(cubeSku:String, cubeRewards:Array, pos:int, claimed:Boolean) : DCIPopup
      {
         var popup:EPopupDailyReward;
         (popup = new EPopupDailyReward()).setup("PopupDailyReward",this.mViewFactory,this.getSkin());
         popup.build(cubeSku,cubeRewards,pos,claimed);
         popup.setIsStackable(true);
         return popup;
      }
      
      override public function getComingSoonPopup() : DCIPopup
      {
         var popup:EGamePopup = new EGamePopup();
         popup.setup("PopupComingSoon",this.mViewFactory,null);
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PopM");
         popup.setLayoutArea(layoutFactory.getArea("bg"),true);
         var bkg:EImage = this.mViewFactory.getEImage("pop_m",null,false,layoutFactory.getArea("bg"));
         popup.eAddChild(bkg);
         popup.setContent("background",bkg);
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         bkg.eAddChild(field);
         popup.setContent("title",field);
         field.setText(DCTextMng.getText(72));
         var button:EButton = this.mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(button);
         popup.setContent("closeButton",button);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         var bodyArea:ELayoutArea = layoutFactory.getArea("body");
         var img:EImage = this.mViewFactory.getEImage("illus_reward_offer",null,false);
         popup.eAddChild(img);
         img.setLayoutArea(bodyArea,true);
         bodyArea.centerContent(img);
         return popup;
      }
      
      override public function getOptionsPopup() : DCIPopup
      {
         var popup:EPopupOptions = new EPopupOptions();
         popup.setup("PopupOptions",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getBufferTemplatesPopup() : DCIPopup
      {
         var popup:EPopupBufferTemplates = new EPopupBufferTemplates();
         popup.setup("PopupBufferTemplates",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getPopupGetItem() : DCIPopup
      {
         var popup:EPopupGetItem = new EPopupGetItem();
         popup.setup("PopupGetItem",this.mViewFactory,this.getSkin());
         return popup;
      }
      
      override public function getPopupUseResources(itemObject:ItemObject) : DCIPopup
      {
         var popup:EPopupUseResources = new EPopupUseResources();
         popup.setItemObject(itemObject);
         popup.setup("PopupUseResources",this.mViewFactory,this.getSkin());
         popup.setIsStackable(true);
         return popup;
      }
      
      override public function translateLogicTypeToCurrentType(popupType:String) : String
      {
         switch(popupType)
         {
            case "NotifyInstantBuild":
               popupType = "PopupUpgradeBuildings";
               break;
            case "NOTIFY_ATTACK_DISTANCE":
               popupType = "PopupPreAttack";
         }
         return popupType;
      }
   }
}
