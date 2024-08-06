package com.dchoc.game.controller.notifications
{
   import com.dchoc.game.controller.gui.popups.PopupFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.EPopupGeneralInfo;
   import com.dchoc.game.eview.popups.messages.EPopupMessage;
   import com.dchoc.game.eview.popups.offers.EPopupOffer;
   import com.dchoc.game.eview.widgets.premiumShop.PopupTradeIn;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.ESprite;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   
   public class NotificationsMng extends DCComponent
   {
      
      private static const NOT_ENOUGH_OBSERVATORY_LEVEL:String = "notEnoughObservatoryLevel";
      
      private static const NOT_ENOUGH_LABORATORY_LEVEL:String = "notEnoughLabooratoryLevel";
      
      private static const NOT_ENOUGH_HQ_LEVEL:String = "notEnoughHQLevel";
      
      private static const NOT_ENOUGH_ROOM_IN_BANKS:String = "notEnoughRoomInBanks";
      
      private static const NOT_ENOUGH_ROOM_IN_SILOS:String = "notEnoughRoomInSilos";
      
      private static const BANKS_FULL:String = "banksFull";
      
      private static const SILOS_FULL:String = "silosFull";
      
      private static const USER_ALREADY_HAS_ALL_COLONIES:String = "userAlreadyHasAllColonies";
      
      private static const NULL_TRANSACTION:String = "nullTransaction";
      
      private static const NULL_WIO:String = "nullWIO";
      
      private static const ALLIANCE_REWARD_NEEDED:String = "allianceRewardNeeded";
      
      private static const NUM_COLONIES_REQUIRED:String = "numColoniesRequired";
      
      private static const SOLAR_SYSTEM_BOOKMARK_ALREADY_EXISTS:String = "solarSystemBookmarkAlreadyExists";
      
      private static const SOLAR_SYSTEM_BOOKMARKS_FULL:String = "solarSystemBookmarksFull";
      
      private static const NOT_ENOUGH_ITEMS:String = "notEnoughItems";
      
      private static const MISSION_EXPIRED:String = "missionExpired";
      
      private static const WIO_CANT_BE_MOVED:String = "wioCantBeMoved";
      
      private static const USER_HAS_LOST_STAR_DUE_INACTIVITY:String = "userHasLostStarDueInactivity";
      
      private static const USER_IS_NOT_ALLOWED_TO_ATTACK_TARGET:String = "userIsNotAllowedToAttackTarget";
      
      private static const UNITS_CANT_BE_SENT_TO_FRIENDS_BUNKER:String = "unitsCantBeSentToFriendsBunker";
      
      private static const MISTERY_GIFT_OPENED_TOO_EARLY:String = "misteryGiftOpenedTooEarly";
      
      private static const ONLY_ONE_UNIT_CAN_BE_ACTIVATED_SIMULTANEOUSLY:String = "onlyOneUnitCanBeActivatedSimultaneously";
      
      private static const UNIT_FACTORY_SPEEDUP_QUEUE_EMPTY:String = "unitFactorySpeedUpQueueEmpty";
      
      private static const UNIT_FACTORY_SPEEDUP_NO_HANGAR:String = "unitFactorySpeedUpNoHangar";
      
      private static const NOT_ENOUGH_WORKERS:String = "notEnoughWorkers";
      
      private static const NOT_ENOUGH_RESOURCES:String = "notEnoughResources";
      
      private static const NOT_ENOUGH_RESOURCES_AND_WORKER:String = "notEnoughResourcesAndWorker";
      
      private static const MAX_AMOUNT_OF_BUILDINGS_OF_THIS_TYPE_REACHED:String = "maxAmountOfBuildingsOfThisTypeReached";
      
      private static const MAX_AMOUNT_OF_WORKERS_REACHED:String = "maxAmountOfWorkersReached";
      
      private static const PAYMENTS_ARE_DISABLED:String = "paymentsAreDisabled";
      
      private static const ERROR_FROM_ALLIANCE_SERVICE:String = "ErrorFromAllianceService";
      
      public static const POPUP_TRADE_IN_SOURCE_CRAFTING:String = "crafting";
      
      public static const POPUP_TRADE_IN_SOURCE_COLLECTION:String = "collection";
      
      public static const POPUP_TRADE_IN_SOURCE_PENDING:String = "pending";
      
      public static const POPUP_TRADE_IN_SOURCE_PURCHASE:String = "purchase";
      
      public static const POPUP_TRADE_IN_SOURCE_MYSTERY_CUBE:String = "mysteryCube";
       
      
      private var mErrorFromServerEvent:Object;
      
      public function NotificationsMng()
      {
         super();
      }
      
      override protected function unloadDo() : void
      {
         this.errorFromServerUnload();
      }
      
      private function getGenericMessageTitle() : String
      {
         return DCTextMng.getText(77);
      }
      
      public function createNotificationNotEnoughRoomInBanks() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(198);
         return new Notification("notEnoughRoomInBanks",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationNotEnoughRoomInSilos() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(199);
         return new Notification("notEnoughRoomInSilos",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationBanksAreFull() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(133);
         return new Notification("banksFull",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationSilosAreFull() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(132);
         return new Notification("silosFull",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationNotEnoughObservatoryLevel(wioSku:String, levelRequired:int, numColoniesUnlocked:String) : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(2762,[levelRequired,numColoniesUnlocked]);
         var returnValue:Notification;
         (returnValue = new Notification("notEnoughObservatoryLevel",titleMessage,bodyMessage,"builder_normal")).setWIOData(wioSku,levelRequired);
         return returnValue;
      }
      
      public function createNotificationNotEnoughLaboratoryLevel(wioSku:String, levelRequired:int) : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(196,[levelRequired]);
         var returnValue:Notification;
         (returnValue = new Notification("notEnoughLabooratoryLevel",titleMessage,bodyMessage,"builder_normal")).setWIOData(wioSku,levelRequired);
         return returnValue;
      }
      
      public function createNotificationNotEnoughHQLevel(wioSku:String, levelRequired:int) : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(195,[levelRequired]);
         var returnValue:Notification;
         (returnValue = new Notification("notEnoughHQLevel",titleMessage,bodyMessage,"builder_normal")).setWIOData(wioSku,levelRequired);
         return returnValue;
      }
      
      public function createNotificationMaxAmountOfBuildingsOfThisTypeReached() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(194);
         return new Notification("maxAmountOfBuildingsOfThisTypeReached",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationMaxAmountOfWorkersReached() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(628,[InstanceMng.getDroidDefMng().getMaxAmountDroids()]);
         return new Notification("maxAmountOfBuildingsOfThisTypeReached",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationUserAlreadyHasAllColonies() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(2759);
         return new Notification("userAlreadyHasAllColonies",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationNullTransaction() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = "We were expecting to receive a non-null transaction.";
         return new Notification("nullTransaction",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationNullWIO() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = "We were expecting to receive a definition, found null instead.";
         return new Notification("nullWIO",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationAllianceRewardNeeded() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(2994);
         return new Notification("allianceRewardNeeded",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationNumColoniesRequired(amount:int) : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(413,[amount]);
         return new Notification("numColoniesRequired",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationSolarSystemBookmarkAlreadyExists() : Notification
      {
         var titleMessage:String = DCTextMng.getText(170);
         var bodyMessage:String = DCTextMng.getText(2752);
         return new Notification("solarSystemBookmarkAlreadyExists",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationSolarSystemBookmarksFull() : Notification
      {
         var titleMessage:String = DCTextMng.getText(170);
         var bodyMessage:String = DCTextMng.getText(2753);
         return new Notification("solarSystemBookmarksFull",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationNotEnoughItems() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(247);
         return new Notification("notEnoughItems",titleMessage,bodyMessage,"builder_normal");
      }
      
      public function createNotificationMissionExpired() : Notification
      {
         var titleMessage:String = DCTextMng.getText(170);
         var bodyMessage:String = DCTextMng.getText(234);
         return new Notification("missionExpired",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationWIOCantBeMoved() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(233);
         return new Notification("wioCantBeMoved",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationUserHasLostStarDueInactivity() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(675);
         return new Notification("userHasLostStarDueInactivity",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationUnitsCantBeSentToFriendsBunkerByReason(reason:int) : Notification
      {
         var bodyMessage:String = null;
         var titleMessage:String = this.getGenericMessageTitle();
         switch(reason - -1)
         {
            case 0:
               bodyMessage = DCTextMng.getText(360);
               break;
            case 1:
               bodyMessage = DCTextMng.getText(357);
         }
         return new Notification("unitsCantBeSentToFriendsBunker",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationUserIsNotAllowedToAttackTarget() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(188);
         return new Notification("userIsNotAllowedToAttackTarget",titleMessage,bodyMessage,"captain_normal");
      }
      
      public function createNotificationMisteryGiftOpenedTooEarly() : Notification
      {
         var titleMessage:String = DCTextMng.getText(372);
         var bodyMessage:String = DCTextMng.getText(373);
         return new Notification("misteryGiftOpenedTooEarly",titleMessage,bodyMessage,"inventory_normal");
      }
      
      public function createNotificationOnlyOneUnitCanBeActivatedSimultaneously() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(197);
         return new Notification("onlyOneUnitCanBeActivatedSimultaneously",titleMessage,bodyMessage,"captain_normal");
      }
      
      public function createNotificationUnitFactorySpeedUpQueueEmpty() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(252);
         return new Notification("unitFactorySpeedUpQueueEmpty",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationUnitFactorySpeedUpNoHangar() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.getText(253);
         return new Notification("unitFactorySpeedUpNoHangar",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationNotEnoughWorkers(e:Object) : Notification
      {
         var returnValue:Notification = new Notification("notEnoughWorkers",null,null,null);
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getNotEnoughWorkersPopup(e);
         returnValue.setPopup(popup);
         return returnValue;
      }
      
      public function createNotificationNotEnoughResources(e:Object) : Notification
      {
         var returnValue:Notification = new Notification("notEnoughResources",null,null,null);
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getNotEnoughResourcesPopup(e);
         returnValue.setPopup(popup);
         return returnValue;
      }
      
      public function createNotificationNotEnoughResourcesAndWorker(e:Object) : Notification
      {
         var returnValue:Notification = new Notification("notEnoughResourcesAndWorker",null,null,null);
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getNotEnoughResourcesAndWorkerPopup(e);
         returnValue.setPopup(popup);
         return returnValue;
      }
      
      public function createNotificationPaymentsAreDisabled() : Notification
      {
         var titleMessage:String = this.getGenericMessageTitle();
         var bodyMessage:String = DCTextMng.replaceParameters(494,[InstanceMng.getPlatformSettingsDefMng().getName()]);
         return new Notification("paymentsAreDisabled",titleMessage,bodyMessage,"orange_normal");
      }
      
      public function createNotificationErrorFromAlliancesService() : Notification
      {
         var titleMessage:String = DCTextMng.getText(2904);
         var bodyMessage:String = AlliancesConstants.getErrorMsg(11);
         return new Notification("ErrorFromAllianceService",titleMessage,bodyMessage,"alliance_council_angry");
      }
      
      public function guiOpenNotificationMessage(notification:Notification, closeOpenedPopup:Boolean = true, openImmediately:Boolean = false) : DCIPopup
      {
         var id:String = "PopupWarnings";
         var titleMessage:String = notification.getMessageTitle();
         var advisorId:String = notification.getAdvisorId();
         var bodyMessage:String = notification.getMessageBody();
         var wioSku:String = notification.getWIOSku();
         var wioLevel:int = notification.getWIOUpgradeLevel();
         var popup:DCIPopup;
         if((popup = notification.getPopup()) != null)
         {
            InstanceMng.getUIFacade().enqueuePopup(popup,true,true,closeOpenedPopup,openImmediately);
         }
         else
         {
            switch(notification.getId())
            {
               case "notEnoughObservatoryLevel":
               case "notEnoughLabooratoryLevel":
               case "notEnoughHQLevel":
                  popup = this.guiOpenNotificationWIORequired(wioSku,wioLevel,bodyMessage,titleMessage,advisorId,closeOpenedPopup);
                  break;
               default:
                  popup = this.guiOpenMessagePopup(id,titleMessage,bodyMessage,advisorId,null,closeOpenedPopup);
            }
         }
         return popup;
      }
      
      private function guiOpenNotificationWIORequired(wioSku:String, upgradeLevel:int, bodyMessage:String, titleMessage:String = null, advisorId:String = null, closeOpenedPopup:Boolean = true) : DCIPopup
      {
         if(titleMessage == null)
         {
            titleMessage = DCTextMng.getText(77);
         }
         if(advisorId == null)
         {
            advisorId = "builder_normal";
         }
         return this.guiOpenMessagePopup("PopupWarnings",DCTextMng.getText(77),bodyMessage,advisorId,null,closeOpenedPopup);
      }
      
      public function guiOpenStartRepairing(e:Object) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popupFactory:PopupFactory;
         var popup:DCIPopup = (popupFactory = uiFacade.getPopupFactory()).getStartRepairingPopup(e);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      private function guiCreateMessagePopup(popupId:String) : EPopupMessage
      {
         var skinSku:String = null;
         var popup:EPopupMessage = new EPopupMessage();
         popup.setup(popupId,InstanceMng.getViewFactory(),skinSku);
         return popup;
      }
      
      public function guiOpenMessageServerPopup() : DCIPopup
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage = this.guiCreateMessagePopup("PopupUnreachableServerMessage");
         var skinSku:String = popup.getSkinSku();
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(3639),"text_body",skinSku);
         popup.setupPopup("builder_worried",DCTextMng.getText(191),content);
         var button:EButton = viewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(9));
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         button.eAddEventListener("click",viewFactory.onRetryLogin);
         popup.addButton("reload_button",button);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,true,true);
         return popup;
      }
      
      public function guiOpenMessageUnderAttackPopup() : DCIPopup
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage = this.guiCreateMessagePopup("PopupUnderAttackMessage");
         var skinSku:String = popup.getSkinSku();
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(189),"text_body",skinSku);
         popup.setupPopup("builder_worried",DCTextMng.getText(191),content);
         var button:EButton = viewFactory.getButtonReload(skinSku);
         popup.addButton("reload_button",button);
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,true,true);
         return popup;
      }
      
      public function guiOpenMessagePopup(popupId:String, title:String, text:String, advisorId:String, onOkCallback:Function = null, closeOpenedPopup:Boolean = true) : EPopupMessage
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.guiCreateMessagePopup(popupId)).getSkinSku();
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",text,"text_body",skinSku);
         popup.setupPopup(advisorId,title,content);
         var button:EButton;
         (button = viewFactory.getButtonConfirm(skinSku,null,DCTextMng.getText(0))).eAddEventListener("click",popup.notifyPopupMngClose);
         if(onOkCallback != null)
         {
            button.eAddEventListener("click",onOkCallback);
         }
         popup.addButton("ok_button",button);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,closeOpenedPopup);
         return popup;
      }
      
      public function guiOpenMessagePopupWithButton(popupId:String, title:String, text:String, button:EButton, advisorId:String, onOkCallback:Function = null, closeOpenedPopup:Boolean = true, closeButton:Boolean = false, closebuttonCallBack:Function = null) : EPopupMessage
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.guiCreateMessagePopup(popupId)).getSkinSku();
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",text,"text_body",skinSku);
         popup.setupPopup(advisorId,title,content);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         if(onOkCallback != null)
         {
            button.eAddEventListener("click",onOkCallback);
         }
         popup.addButton("ok_button",button);
         if(closeButton)
         {
            if((button = popup.getCloseButton()) != null)
            {
               button.visible = true;
               button.eAddEventListener("click",popup.notifyPopupMngClose);
               if(closebuttonCallBack != null)
               {
                  button.eAddEventListener("click",closebuttonCallBack);
               }
            }
         }
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,closeOpenedPopup);
         return popup;
      }
      
      public function guiOpenConfirmPopup(popupId:String, title:String, text:String, advisorId:String, textAcceptButton:String = null, textCancelButton:String = null, onOkCallback:Function = null, onCancelCallback:Function = null, closeOpenedPopup:Boolean = true) : EPopupMessage
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage;
         var skinSku:String = (popup = this.guiCreateMessagePopup(popupId)).getSkinSku();
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",text,"text_body",skinSku);
         popup.setupPopup(advisorId,title,content);
         if(textAcceptButton == null)
         {
            textAcceptButton = DCTextMng.getText(5);
         }
         if(textCancelButton == null)
         {
            textCancelButton = DCTextMng.getText(4);
         }
         var button:EButton = viewFactory.getButtonByTextWidth(textCancelButton,0,"btn_cancel");
         popup.addButton("cancel_button",button);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         if(onCancelCallback != null)
         {
            button.eAddEventListener("click",onCancelCallback);
         }
         button = viewFactory.getButtonByTextWidth(textAcceptButton,0,"btn_accept");
         popup.addButton("ok_button",button);
         button.eAddEventListener("click",popup.notifyPopupMngClose);
         if(onOkCallback != null)
         {
            button.eAddEventListener("click",onOkCallback);
         }
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,closeOpenedPopup);
         return popup;
      }
      
      public function guiOpenStartNowPopup() : DCIPopup
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var popup:EPopupMessage = this.guiCreateMessagePopup("PopupStartNow");
         var content:ESprite = viewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(470),"text_body",null);
         var button:EButton = viewFactory.getButton("btn_accept",popup.getSkinSku(),"L",DCTextMng.getText(1306));
         popup.addButton("unlock",button);
         popup.setupPopup("orange_happy",DCTextMng.getText(469),content);
         button.eAddEventListener("click",this.onCloseWelcomePopup);
         popup.setCloseButtonVisible(true);
         popup.getCloseButton().eAddEventListener("click",this.onCloseWelcomePopup);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      private function onCloseWelcomePopup(evt:EEvent) : void
      {
         if(evt.getTarget().parent != null)
         {
            InstanceMng.getUserDataMng().startNowAskPermissions();
            InstanceMng.getWelcomePopupsMng().guiOnClose();
         }
      }
      
      public function guiOpenTradeInPopup(source:String, reward:RewardObject, useTextFromReward:Boolean = false, acceptFunction:Function = null, useShare:Boolean = false, closeFunction:Function = null, advisor:String = null, forceAmountText:int = 0) : DCIPopup
      {
         var popup:DCIPopup = null;
         var titleTid:int = 0;
         var bodyTid:int = 0;
         var amount:int = 0;
         var itemObject:ItemObject = null;
         var button:EButton = null;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var skinSku:String = null;
         var titleText:String = source == "pending" || source == "mysteryCube" ? DCTextMng.replaceParameters(436,[]) : DCTextMng.replaceParameters(478,[]);
         var descText:String = reward.getText();
         var bubbleTitleText:String = source == "pending" ? reward.getDesc() : DCTextMng.replaceParameters(477,[]);
         if(!useTextFromReward)
         {
            if(source == "crafting")
            {
               titleTid = 479;
               bodyTid = 257;
               titleText = DCTextMng.replaceParameters(titleTid,[reward.getText().toUpperCase()]);
               bubbleTitleText = DCTextMng.replaceParameters(bodyTid,[]);
            }
            else if(source == "collection")
            {
               titleTid = 480;
               bodyTid = 255;
               titleText = DCTextMng.replaceParameters(titleTid,[reward.getText().toUpperCase()]);
               bubbleTitleText = DCTextMng.replaceParameters(bodyTid,[reward.getText()]);
            }
            else if(source == "pending")
            {
               titleText = DCTextMng.replaceParameters(436,[]);
               bubbleTitleText = reward.getDesc();
            }
         }
         if(reward.getItem() == null)
         {
            titleText = DCTextMng.getText(481);
            bubbleTitleText = DCTextMng.getText(482);
         }
         var rewardText:String = "";
         var numberOfItems:* = 1;
         if(source != "crafting")
         {
            if((amount = reward.getAmount()) > 1)
            {
               descText = DCTextMng.convertNumberToString(amount,-1,-1) + " " + descText;
            }
            numberOfItems = reward.getAmount();
         }
         if(forceAmountText != 0)
         {
            numberOfItems = forceAmountText;
         }
         var popupId:String = "PopupTradeIn";
         var popupTradeIn:PopupTradeIn;
         (popupTradeIn = new PopupTradeIn(reward.getAssetId())).setupTradeIn(popupId,viewFactory,skinSku,useShare,advisor);
         popupTradeIn.setTitleText(titleText);
         popupTradeIn.setTitleSpeechBubble(DCTextMng.replaceParameters(3340,[bubbleTitleText]));
         popupTradeIn.setBodySpeechBubble(descText);
         popupTradeIn.setAmountTextField(numberOfItems);
         popupTradeIn.setAmountTextFieldVisible(true);
         popup = popupTradeIn;
         if(acceptFunction != null)
         {
            popupTradeIn.getContentAsEButton("btn_accept").eAddEventListener("click",acceptFunction);
         }
         if(useShare && closeFunction != null)
         {
            if((button = popupTradeIn.getCloseButton()) != null)
            {
               button.visible = true;
               button.eAddEventListener("click",closeFunction);
               button.eAddEventListener("click",popupTradeIn.notifyPopupMngClose);
            }
         }
         InstanceMng.getUIFacade().enqueuePopup(popup,true,true,false);
         return popup;
      }
      
      public function guiOpenCreditCardPromoPopup(event:Object) : DCIPopup
      {
         var origin:String = String(event.origin);
         var entry:String = String(event.entry);
         var numItemToGive:String = String(event.numItemToGive);
         var nameItemToGive:String = String(event.nameItemToGive);
         var itemFilename:String = String(event.itemFilename);
         var ePopup:EPopupOffer;
         (ePopup = this.guiCreateCreditCardPromoPopup(entry,itemFilename,numItemToGive)).setOrigin(origin);
         ePopup.setEntry(entry);
         ePopup.setText(DCTextMng.replaceParameters(656,[numItemToGive,nameItemToGive]));
         InstanceMng.getUIFacade().enqueuePopup(ePopup);
         return ePopup;
      }
      
      public function guiOpenGeneralInfoPopup(event:Object) : DCIPopup
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:EPopupGeneralInfo = new EPopupGeneralInfo();
         popup.setup("PopupGeneralInfo",viewFactory,null);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      private function guiCreateCreditCardPromoPopup(entryStr:String, assetId:String, numItems:String) : EPopupOffer
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var skinSku:String = null;
         var popupId:String = "NOTIFY_SHOW_OFFER";
         var popup:EPopupOffer;
         (popup = new EPopupOffer(entryStr,assetId,numItems)).setup(popupId,viewFactory,skinSku);
         return popup;
      }
      
      public function guiOpenRecycleWIOPopup(wio:WorldItemObject, e:Object) : DCIPopup
      {
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getRecycleWIOPopup(wio,e);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenCancelProcessPopup(e:Object, percentageOff:Number) : DCIPopup
      {
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getCancelProcessPopup(e,percentageOff);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenSpeedUpUnitsNoStoragePopup(e:Object) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popupFactory:PopupFactory;
         var popup:DCIPopup = (popupFactory = uiFacade.getPopupFactory()).getSpeedUpUnitsNoStoragePopup(e);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenSpeedUpUnlockingCurrentUnit(e:Object) : DCIPopup
      {
         var unit:GameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit();
         var popupFactory:PopupFactory;
         var uiFacade:UIFacade;
         var popup:DCIPopup = (popupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory()).getSpeedUpUnlockingUnitPopup(unit,e.transaction as Transaction,e);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenColonyShieldWillBeLost(e:Object) : DCIPopup
      {
         e.phase = "OUT";
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popupFactory:PopupFactory;
         var popup:DCIPopup = (popupFactory = uiFacade.getPopupFactory()).getColonyShieldWillBeLostPopup(this.colonyShieldWillBeLostOnAccept,this.colonyShieldWillBeLostOnCancel);
         e.popup = popup;
         popup.setEvent(e);
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenTemplateError(errorType:int) : void
      {
         var errorMsgTid:int = 0;
         switch(errorType - 1)
         {
            case 0:
               errorMsgTid = 3987;
               break;
            case 1:
               errorMsgTid = 3988;
               break;
            case 2:
               errorMsgTid = 3989;
               break;
            case 3:
               errorMsgTid = 3990;
               break;
            default:
               errorMsgTid = 4110;
         }
         this.guiOpenMessagePopup("PopupBufferTemplatesError",DCTextMng.getText(77),DCTextMng.replaceParameters(3986,[DCTextMng.getText(errorMsgTid)]),"orange_worried");
      }
      
      private function colonyShieldWillBeLostSendEvent(button:String) : void
      {
         var e:Object = null;
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupOpened("colonyShieldWillBeLost");
         if(popup != null)
         {
            e = popup.getEvent();
            if(e != null)
            {
               e.button = button;
               InstanceMng.getGUIController().notify(e);
            }
         }
      }
      
      private function colonyShieldWillBeLostOnCancel(e:EEvent = null) : void
      {
         this.colonyShieldWillBeLostSendEvent("EventCancelButtonPressed");
      }
      
      private function colonyShieldWillBeLostOnAccept(e:EEvent = null) : void
      {
         this.colonyShieldWillBeLostSendEvent("EventYesButtonPressed");
      }
      
      private function errorFromServerUnload() : void
      {
         this.mErrorFromServerEvent = null;
      }
      
      public function errorFromServerAboutAlliances() : void
      {
      }
      
      public function errorFromServerOpenPopup(event:Object) : void
      {
         this.mErrorFromServerEvent = event;
         var titleTid:int = 399;
         var bodyText:String = String(event.msg);
         var buttonTid:int = 9;
         var advisorState:String;
         if((advisorState = String(event.advisor)) == null)
         {
            advisorState = "orange_worried";
         }
         var errorType:String;
         if((errorType = String(event.errorType)) != null && errorType != "")
         {
            if(errorType == "serverUpdated")
            {
               bodyText = DCTextMng.getText(414);
               advisorState = "orange_normal";
            }
            else if(errorType == "connectionLost")
            {
               bodyText = DCTextMng.getText(400);
               advisorState = "builder_worried";
            }
            else if(errorType == "guestUserSessionOver")
            {
               titleTid = 407;
               bodyText = DCTextMng.getText(408);
               advisorState = "orange_normal";
               buttonTid = 409;
            }
            else if(errorType == "NOTIFY_ATTACKED_INGAME")
            {
               titleTid = 402;
               bodyText = DCTextMng.getText(404);
               advisorState = "orange_worried";
            }
            else
            {
               bodyText = DCTextMng.getText(401);
               advisorState = "orange_worried";
            }
         }
         var uiFacade:UIFacade;
         var popup:DCIPopup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getErrorFromServer(advisorState,DCTextMng.getText(titleTid),bodyText,DCTextMng.getText(buttonTid),this.errorFromServerOnAccept);
         event["phase"] = "OUT";
         event["popup"] = popup;
         popup.setEvent(event);
         uiFacade.enqueuePopup(popup,true,true,true,true);
         InstanceMng.getPopupMng().setAllowPopups(false);
      }
      
      private function errorFromServerOnAccept(e:Object) : void
      {
         var popup:DCIPopup = null;
         var errorType:String = null;
         var uiFacade:UIFacade = null;
         if(this.mErrorFromServerEvent != null)
         {
            popup = this.mErrorFromServerEvent["popup"] as DCIPopup;
            if(popup != null)
            {
               errorType = String(this.mErrorFromServerEvent["errorType"]);
               uiFacade = InstanceMng.getUIFacade();
               InstanceMng.getPopupMng().setAllowPopups(true);
               if(errorType == "guestUserSessionOver")
               {
                  uiFacade.closePopup(popup,null,true);
                  this.errorFromServerOpenPopup(this.mErrorFromServerEvent);
                  InstanceMng.getUserDataMng().guestUserRegistration();
               }
               else
               {
                  uiFacade.closePopup(popup);
                  InstanceMng.getApplication().reloadGame(false);
                  this.mErrorFromServerEvent = null;
               }
            }
         }
      }
   }
}
