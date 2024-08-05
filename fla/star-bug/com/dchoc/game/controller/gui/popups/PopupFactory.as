package com.dchoc.game.controller.gui.popups
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.invests.Invest;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.customizer.DCCustomizerPopupDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   
   public class PopupFactory
   {
      
      public static const POPUP_BET_SELECTION:String = "PopupBetSelection";
      
      public static const POPUP_BET_RESULT:String = "PopupBetResult";
      
      public static const POPUP_LOOKING_RIVAL:String = "PopupLookingRival";
      
      public static const POPUP_SIMPLE_MESSAGE:String = "PopupSimpleMessage";
      
      public static const POPUP_MISSION_PROGRESS:String = "NotifyMissionProgress";
      
      public static const POPUP_MISSION_COMPLETE:String = "PopupMissionComplete";
      
      public static const POPUP_INVENTORY_CANT_USE_ITEM:String = "PopupInventoryCantUseItem";
      
      public static const POPUP_INVENTORY_SHIELD_BOUGHT:String = "PopupInventoryShieldBought";
      
      public static const POPUP_UNDER_ATTACK_MESSAGE:String = "PopupUnderAttackMessage";
      
      public static const POPUP_WISHLIST_ITEM:String = "PopupWishListItem";
      
      public static const POPUP_UNREACHABLE_SERVER_MESSAGE:String = "PopupUnreachableServerMessage";
      
      public static const POPUP_COLONY_SHIELD_EXCEEDS_MAX_TIME:String = "PopupUnderAttackMessage";
      
      public static const POPUP_CONTEST:String = "PopupContest";
      
      public static const POPUP_CONTEST_RESULTS:String = "PopupContestResults";
      
      public static const POPUP_PURCHASE_SHOP:String = "PopupPurchaseShop";
      
      public static const POPUP_TRADE_IN:String = "PopupTradeIn";
      
      public static const POPUP_INSTANT_BUILD:String = "PopupInstantBuild";
      
      public static const POPUP_START_NOW:String = "PopupStartNow";
      
      public static const POPUP_UPSELLING_OFFER_PRESENTATION:String = "PopupUpsellingOfferPresentation";
      
      public static const POPUP_PROMO_CREDIT_CARD_PRESENTATION:String = "NOTIFY_SHOW_OFFER";
      
      public static const POPUP_WARNINGS:String = "PopupWarnings";
      
      public static const POPUP_NOT_ENOUGH_WORKERS:String = "PopupNotEnoughWorkers";
      
      public static const POPUP_NOT_ENOUGH_RESOURCES:String = "PopupNotEnoughResources";
      
      public static const POPUP_NOT_ENOUGH_RESOURCES_AND_WORKER:String = "PopupNotEnoughResourcesAndWorker";
      
      public static const POPUP_WISHLIST_ERROR:String = "PopupWishlistError";
      
      public static const POPUP_START_REPAIRING:String = "PopupStartRepairing";
      
      public static const POPUP_LEVEL_UP:String = "PopupLevelUp";
      
      public static const POPUP_UNIT_UPGRADED:String = "PopupUnitUpgraded";
      
      public static const POPUP_HANGAR_EMPTY:String = "PopupHangarInfoEmpty";
      
      public static const POPUP_HANGAR_NON_EMPTY:String = "PopupHangarInfoNonEmpty";
      
      public static const POPUP_REFINERY:String = "PopupRefinery";
      
      public static const POPUP_BUNKER:String = "PopupBunker";
      
      public static const POPUP_BUNKER_FRIENDS:String = "PopupBunkerFriends";
      
      public static const POPUP_INVENTORY:String = "PopupInventory";
      
      public static const POPUP_LABORATORY:String = "PopupUpgrade";
      
      public static const POPUP_UPGRADE_BUILDINGS:String = "PopupUpgradeBuildings";
      
      public static const POPUP_RECYCLE_WIO:String = "PopupRecycleWIO";
      
      public static const POPUP_CANCEL_PROCESS:String = "PopupCancelProcess";
      
      public static const POPUP_CANCEL_BUFFER:String = "PopupCancelBuffer";
      
      public static const POPUP_CLEAR_BUFFER:String = "PopupClearBuffer";
      
      public static const POPUP_SPEED_UP_UNITS_NO_STORAGE:String = "PopupSpeedUpUnitsNoStorage";
      
      public static const POPUP_WELCOME_VISITING:String = "PopupWelcomeVisiting";
      
      public static const POPUP_ALL_HELPS_DONE_WHEN_VISITING:String = "PopupAllHelpsDoneWhenVisiting";
      
      public static const POPUP_SPEED_UP_UNLOCKING_UNIT:String = "NOTIFY_POPUP_OPEN_SPEEDITEM";
      
      public static const POPUP_SPY_CAPSULES_DAILY_REWARD:String = "PopupSpyCapsulesDailyReward";
      
      public static const POPUP_BUY_SPY_CAPSULES:String = "PopupBuySpyCapsules";
      
      public static const POPUP_BUY_COINS:String = "PopupBuyCoins";
      
      public static const POPUP_BUY_MINERALS:String = "PopupBuyMinerals";
      
      public static const POPUP_CHIPS_SHOP:String = "PopupChipsShop";
      
      public static const POPUP_BUY_COLONY:String = "PopupBuyColony";
      
      public static const POPUP_COLONY_BOUGHT:String = "PopupColonyBought";
      
      public static const POPUP_SELECT_COLONY:String = "PopupSelectColony";
      
      public static const POPUP_SOLAR_SYSTEM_PLANETS:String = "PanelSolarSystemPlanets";
      
      public static const POPUP_ACTIONS_ON_PLANET:String = "PopupPlanetOccupiedOptions";
      
      public static const POPUP_CRAFTING_PENDING:String = "PopupCraftingPending";
      
      public static const POPUP_NPC_ATTACK_IS_OVER:String = "PopupNpcAttackIsOver";
      
      public static const POPUP_SHOW_INCOMING_ATTACK:String = "PopupShowIncomingAttack";
      
      public static const POPUP_BUY_WORKER:String = "PopupBuyWorker";
      
      public static const POPUP_BATTLE_VERSUS_USER_RESULTS:String = "PopupBattleVersusUserResults";
      
      public static const POPUP_BATTLE_VERSUS_NPC_RESULTS:String = "PopupBattleVersusNpcResults";
      
      public static const POPUP_FRIEND_PASSED_IN_RANKING:String = "PopupFriendPassedInRanking";
      
      public static const POPUP_FRIEND_PASSED_IN_LEVEL_UP:String = "PopupFriendPassedInLevelUp";
      
      public static const POPUP_HELP_ALLIANCES:String = "PopupHelpAlliances";
      
      public static const POPUP_JOIN_ALLIANCE_REQUESTS:String = "PopupJoinAllianceRequests";
      
      public static const POPUP_CREATE_ALLIANCES:String = "PopupCreateAlliances";
      
      public static const POPUP_EDIT_ALLIANCE:String = "PopupEditAlliance";
      
      public static const POPUP_ALLIANCE_MEMBERS:String = "PopupAllianceMembers";
      
      public static const POPUP_ALLIANCES:String = "PopupAlliances";
      
      public static const POPUP_ALLIANCES_NOTIFICATION:String = "PopupAlliancesNotification";
      
      public static const POPUP_MISSION_MERCENARIES_INFO:String = "PopupMissionMercenariesInfo";
      
      public static const POPUP_MISSION_MERCENARIES_COMPLETED:String = "PopupMissionMercenariesCompleted";
      
      public static const POPUP_SHOW_UNIT_INFO:String = "PopupShowUnitInfo";
      
      public static const POPUP_BLACK_HOLE_INTRO:String = "PopupBlackHoleIntro";
      
      public static const POPUP_BLACK_HOLE_SHOW_REWARD:String = "PopupBlackHoleShowReward";
      
      public static const POPUP_PRE_ATTACK:String = "PopupPreAttack";
      
      public static const POPUP_HAPPENING_STORY:String = "PopupHappeningStory";
      
      public static const POPUP_HAPPENING_START:String = "PopupHappeningStart";
      
      public static const POPUP_HAPPENING_INITIAL_KIT:String = "PopupHappeningInitialKit";
      
      public static const POPUP_HAPPENING_BIRTHDAY_INITIAL:String = "PopupHappeningBirthdayInitial";
      
      public static const POPUP_HAPPENING_WINTER:String = "PopupHappeningWinter";
      
      public static const POPUP_HAPPENING_ANTIZOMBIE_KIT:String = "PopupHappeningAntizombieKit";
      
      public static const POPUP_HAPPENING_READY_TO_START:String = "PopupHappeningReadyToStart";
      
      public static const POPUP_HAPPENING_WAVE_RESULT:String = "PopupHappeningWaveResult";
      
      public static const POPUP_HAPPENING_END_EVENT:String = "PopupHappeningEndEvent";
      
      public static const POPUP_IDLE:String = "NotifyAFKPopup";
      
      public static const POPUP_SPEECH:String = "PopupSpeech";
      
      public static const POPUP_COLONY_SHIELD_WILL_BE_LOST:String = "colonyShieldWillBeLost";
      
      public static const POPUP_ERROR_FROM_SERVER:String = "PopupErrorFromServer";
      
      public static const POPUP_WELCOME:String = "PopupWelcome";
      
      public static const POPUP_INVEST:String = "PopupInvest";
      
      public static const POPUP_HELP_INVEST:String = "PopupHelpInvest";
      
      public static const POPUP_INVEST_REWARD_SUCCESS:String = "PopupInvestRewardSuccess";
      
      public static const POPUP_INVEST_REWARD_FAIL:String = "PopupInvestRewardFail";
      
      public static const POPUP_INVEST_REWARD_TUTORIAL:String = "PopupInvestRewardTutorial";
      
      public static const POPUP_EMBASSY:String = "PopupEmbassy";
      
      public static const POPUP_HELP_EMBASSY:String = "PopupHelpEmbassy";
      
      public static const POPUP_GET_ITEM:String = "PopupGetItem";
      
      public static const POPUP_USE_RESOURCES:String = "PopupUseResources";
      
      public static const POPUP_DAILY_REWARD:String = "PopupDailyReward";
      
      public static const POPUP_CONFIRM_INVENTORY_USE:String = "PopupConfirmInventoryUse";
      
      public static const POPUP_CONFIRM_INVENTORY_DELETE:String = "PopupConfirmInventoryDelete";
      
      public static const POPUP_CONFIRM_INVENTORY_USE_ALL:String = "PopupConfirmInventoryUseAll";
      
      public static const POPUP_CONFIRM_EMBASSY_BUY:String = "PopupConfirmEmbassyBuy";
      
      public static const POPUP_CONFIRM_ACCEPT_HELP:String = "PopupConfirmAcceptHelp";
      
      public static const POPUP_CONFIRM_END_BATTLE:String = "PopupConfirmEndBattle";
      
      public static const POPUP_CONFIRM_TEMPLATE_DELETE:String = "PopupConfirmTemplateDelete";
      
      public static const POPUP_GENERAL_INFO:String = "PopupGeneralInfo";
      
      public static const POPUP_COMING_SOON:String = "PopupComingSoon";
      
      public static const POPUP_OPTIONS:String = "PopupOptions";
      
      public static const POPUP_CHOOSE_COLOR:String = "PopupChooseColor";
      
      public static const POPUP_CHOOSE_RESOLUTION:String = "PopupChooseResolution";
      
      public static const POPUP_CHOOSE_HOTKEYS:String = "PopupChooseHotkeys";
      
      public static const POPUP_TEXT_OPTIONS:String = "PopupTextOptions";
      
      public static const POPUP_BUFFER_TEMPLATES:String = "PopupBufferTemplates";
      
      public static const POPUP_BUFFER_TEMPLATES_ERROR:String = "PopupBufferTemplatesError";
      
      public static const POPUP_BUFFER_TEMPLATES_IMPORT:String = "PopupBufferTemplatesImport";
      
      public static const POPUP_TOO_MANY_GIFTS_OPENED:String = "PopupTooManyGiftsOpened";
      
      public static const BUTTON_ACCEPT:String = "accept_button";
      
      public static const BUTTON_OK:String = "ok_button";
      
      public static const BUTTON_RELOAD:String = "reload_button";
      
      public static const BUTTON_BUY_FBC_BIG:String = "buy_fb_big_button";
      
      public static const BUTTON_CLOSE:String = "close_button";
      
      public static const BUTTON_CANCEL:String = "cancel_button";
      
      public static const BUTTON_ADDGOLD:String = "add_gold_button";
      
      public static const BUTTON_BUY_FB_CREDITS:String = "buy_fb_button";
      
      public static const BUTTON_INSTANT:String = "instant_button";
      
      public static const BUTTON_SPEED_UP:String = "speed_button";
      
      public static const BUTTON_CANCEL_SPEED_UP:String = "cancel_speed_button";
      
      public static const BUTTON_FIGHT:String = "fight_button";
      
      public static const BUTTON_CRAFT:String = "craft_button";
      
      public static const BUTTON_SHARE:String = "EventShareButtonPressed";
      
      public static const EVENT_MODIFY_DROID_TASK_CANCEL:String = "cancel_speed_button";
      
      public static const EVENT_MODIFY_DROID_TASK_SPEED:String = "speed_button";
       
      
      private var mEventNotifyPopupRef:DCIPopup;
      
      public function PopupFactory()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.mEventNotifyPopupRef = null;
      }
      
      public function returnPopup(value:DCIPopup) : void
      {
      }
      
      public function getBunkerPopup(bunker:Bunker, visitor:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getBunkerFriendsPopup(bunker:Bunker) : DCIPopup
      {
         return null;
      }
      
      public function getInventoryPopup(tab:String) : DCIPopup
      {
         return null;
      }
      
      public function getMissionCompletePopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getUpdateUnitPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getUpgradeBuildingPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getNotEnoughWorkersPopup(event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getNotEnoughResourcesPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getNotEnoughResourcesAndWorkerPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getAddItemToWishlistErrorPopup(tid:int) : DCIPopup
      {
         return null;
      }
      
      public function getStartRepairingPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getLevelUpPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getUnitUpgradedPopup(unitDef:ShipDef, hasUnlocked:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getRecycleWIOPopup(wio:WorldItemObject, e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getCancelProcessPopup(e:Object, percentageOff:Number) : DCIPopup
      {
         return null;
      }
      
      public function getSpeedUpUnitsNoStoragePopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getWelcomeVisitingPopup(entry:Entry) : DCIPopup
      {
         return null;
      }
      
      public function getAllHelpsDoneWhenVisitingPopup(entry:Entry, onCallback:Function, buttonText:String) : DCIPopup
      {
         return null;
      }
      
      public function getSpeedUpUnlockingUnitPopup(unit:GameUnit, transaction:Transaction, event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getSpyCapsulesDailyRewardPopup(entry:Entry) : DCIPopup
      {
         return null;
      }
      
      public function getBuySpyCapsulesPopup() : DCIPopup
      {
         return null;
      }
      
      public function getChipsPopup() : DCIPopup
      {
         return null;
      }
      
      public function getHelpAlliancesPopup() : DCIPopup
      {
         return null;
      }
      
      public function getAllianceJoinRequestsPopup() : DCIPopup
      {
         return null;
      }
      
      public function getBuyColonyPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getColonyBoughtPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getSelectColonyPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getSolarSystemPlanetsPopup(filledPlanets:Vector.<Planet>, emptyPlanets:Vector.<Planet>, star:SolarSystem, isBookmarked:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getActionsOnPlanetPopup(planet:Planet, star:SolarSystem, isOccupied:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getCraftingPendingPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getBuyCoinsPopup() : DCIPopup
      {
         return null;
      }
      
      public function getBuyMineralsPopup() : DCIPopup
      {
         return null;
      }
      
      public function getNpcAttackIsOverPopup() : DCIPopup
      {
         return null;
      }
      
      public function getShowIncomingAttackPopup(wave:String, npcSku:String) : DCIPopup
      {
         return null;
      }
      
      public function getBuyWorkerPopup(workerDef:DroidDef) : DCIPopup
      {
         return null;
      }
      
      public function getBattleVersusUserResults(lootedCoins:Number, lootedMineral:Number, scoreGained:Number, allianceScore:Number, showAllianceScore:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getBattleVersusNpcResults(npcName:String, npcImageId:String, hqDestroyed:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getFriendPassedInRankingPopup() : DCIPopup
      {
         return null;
      }
      
      public function getFriendPassedInLevelUpPopup(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getMissionMercenariesInfo(titleTid:String, bodyTid:String, buttonTid:String, onAccept:Function) : DCIPopup
      {
         return null;
      }
      
      public function getMissionMercenariesCompleted(titleTid:String, bodyTid:String, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getShowUnitInfoPopup(unitSku:String) : DCIPopup
      {
         return null;
      }
      
      public function getBlackHoleIntroPopup(onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getBlackHoleShowRewardPopup(onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getPreAttackPopup(targetAccountId:String, targetPlanetId:String, targetPlanetSku:String, onAccept:Function, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningIntroStoryPopup(imageId:String, titleTid:String, bodyTid:String, buttonTid:String) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningStartEventPopup(buttonTid:String, event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningStartEventBirthdayPopup(happeningDef:HappeningDef, event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningEventWinterPopup(happeningDef:HappeningDef, event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningInitialKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningAntiZombieKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningGiftProgressPopup(happeningDef:HappeningDef, event:Object) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningReadyToStartPopup(happening:Happening, waves:String, canSkip:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningWaveResultPopup(happening:Happening) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningSkipEventPopup(happening:Happening) : DCIPopup
      {
         return null;
      }
      
      public function getHappeningEndEventPopup(happening:Happening, canShare:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getIdlePopup(type:String, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getSpeechPopup(e:Object, advisorId:String, title:String, body:String, buttonText:String, sound:String, onAccept:Function, useSmall:Boolean, advisorSize:int, vAlign:int, advisorOnRightSide:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getColonyShieldWillBeLostPopup(onAccept:Function, onCancel:Function) : DCIPopup
      {
         return null;
      }
      
      public function getErrorFromServer(advisorId:String, title:String, bodyText:String, buttonText:String, onAccept:Function) : DCIPopup
      {
         return null;
      }
      
      public function getWelcomePopup(def:DCCustomizerPopupDef, onAccept:Function, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getInformationPopup(title:String, image:EImage, text:String, skinSku:String = null) : EGamePopup
      {
         return null;
      }
      
      public function getInvestPopup() : DCIPopup
      {
         return null;
      }
      
      public function getHelpInvestPopup() : DCIPopup
      {
         return null;
      }
      
      public function getHelpEmbassyPopup() : DCIPopup
      {
         return null;
      }
      
      public function getInvestRewardSuccessPopup(invest:Invest, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getInvestRewardFailPopup(invest:Invest, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getInvestRewardTutorialPopup(investorUserInfo:UserInfo, trans:Transaction, onClose:Function) : DCIPopup
      {
         return null;
      }
      
      public function getCreateAlliancePopup() : DCIPopup
      {
         return null;
      }
      
      public function getEditAlliancePopup() : DCIPopup
      {
         return null;
      }
      
      public function getAlliancePopup() : DCIPopup
      {
         return null;
      }
      
      public function getAllianceMembersPopup(alliance:Alliance, stripe:ESprite) : DCIPopup
      {
         return null;
      }
      
      public function getAlliancesNotification(e:Object) : DCIPopup
      {
         return null;
      }
      
      public function getDailyRewardPopup(cubeSku:String, cubeRewards:Array, pos:int, claimed:Boolean) : DCIPopup
      {
         return null;
      }
      
      public function getComingSoonPopup() : DCIPopup
      {
         return null;
      }
      
      public function getOptionsPopup() : DCIPopup
      {
         return null;
      }
      
      public function getBufferTemplatesPopup() : DCIPopup
      {
         return null;
      }
      
      public function getPopupGetItem() : DCIPopup
      {
         return null;
      }
      
      public function getPopupUseResources(itemObject:ItemObject) : DCIPopup
      {
         return null;
      }
      
      public function eventNotifyModifyCurrentTaskDroid(e:Object) : Boolean
      {
         var newEvent:Object = null;
         var newEventCmd:String = null;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var eventItem:WorldItemObject = WorldItemObject(e.item);
         if(this.phaseIsIN(e.phase) == true)
         {
            e.phase = "OUT";
            if(eventItem != null && this.wioUpgradePopupNeedsToBePaused())
            {
               eventItem.pause();
            }
            this.mEventNotifyPopupRef = this.getModifyCurrentTaskDroidPopup(e);
            uiFacade.enqueuePopup(this.mEventNotifyPopupRef);
         }
         else
         {
            e.phase = "IN";
            if(this.wioUpgradePopupNeedsToBeClosed())
            {
               uiFacade.closePopup(this.mEventNotifyPopupRef);
            }
            eventItem = e.item;
            switch(e.button)
            {
               case "cancel_speed_button":
                  newEvent = InstanceMng.getGUIControllerPlanet().createEventWIOCancelProcess(eventItem);
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),newEvent);
                  break;
               case "speed_button":
                  this.continueDroidTask(e);
                  break;
               default:
                  if(eventItem != null && this.wioUpgradePopupNeedsToBePaused())
                  {
                     eventItem.resume();
                  }
                  InstanceMng.getGUIControllerPlanet().resetNotifyEvent(e);
            }
         }
         return true;
      }
      
      public function eventNotifyWIOUpgradeStart(e:Object) : Boolean
      {
         var thisPopup:DCIPopup = null;
         var itemDef:WorldItemDef = null;
         var nextDef:WorldItemDef = null;
         var premiumTransaction:Transaction = null;
         var transactionPack:Transaction = null;
         var items:Vector.<WorldItemObject> = null;
         var itemUpgradedDef:WorldItemDef = null;
         var checkSiloCapacity:Boolean = false;
         var isPremiumUpgrade:* = false;
         var enoughCash:* = false;
         var notification:Notification = null;
         var continueTransaction:Boolean = false;
         var startLevel:int = 0;
         var levelsToUpgrade:int = 0;
         var endLevel:int = 0;
         var lev:* = 0;
         var eventItem:WorldItemObject = e.item as WorldItemObject;
         if(this.phaseIsIN(e.phase) == true)
         {
            e.phase = "OUT";
            if(e["isLocked"] == null)
            {
               if(this.wioUpgradePopupNeedsToBePaused())
               {
                  eventItem.pause();
               }
               itemDef = eventItem.mDef;
               nextDef = eventItem.getUpgradeDef();
               e.itemDef = itemDef;
               e.nextDef = nextDef;
               if(e.items)
               {
                  items = e.items;
                  premiumTransaction = InstanceMng.getRuleMng().getTransactionPremiumUpgrade(nextDef,e.item,items.length);
               }
               else
               {
                  premiumTransaction = InstanceMng.getRuleMng().getTransactionPremiumUpgrade(nextDef,e.item);
               }
               e.premiumTransaction = premiumTransaction;
               e.cmd = "WIOEventUpgradeStart";
               transactionPack = InstanceMng.getRuleMng().getTransactionPack(e);
               e.transaction = transactionPack;
            }
            thisPopup = this.getUpgradeBuildingPopup(e);
            InstanceMng.getUIFacade().enqueuePopup(thisPopup);
         }
         else
         {
            e.phase = "";
            if(eventItem == null)
            {
               return true;
            }
            itemUpgradedDef = eventItem.getUpgradeDef();
            checkSiloCapacity = true;
            if(e.premiumUpgrade != null)
            {
               transactionPack = e.premiumTransaction;
               checkSiloCapacity = false;
            }
            else
            {
               transactionPack = e.transaction;
            }
            isPremiumUpgrade = e["premiumUpgrade"] != null;
            enoughCash = InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= transactionPack.getLogicCashToPay();
            if((notification = InstanceMng.getGUIControllerPlanet().checkIfOperationIsPossible(itemUpgradedDef,transactionPack,true,isPremiumUpgrade)) == null)
            {
               startLevel = itemUpgradedDef.getUpgradeId();
               levelsToUpgrade = int(e["levelsToUpgrade"]);
               endLevel = startLevel + levelsToUpgrade;
               for(lev = startLevel; lev < endLevel; )
               {
                  itemUpgradedDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(itemUpgradedDef.mSku,lev);
                  if((notification = InstanceMng.getGUIControllerPlanet().checkIfOperationIsPossible(itemUpgradedDef,transactionPack,true,isPremiumUpgrade)) != null)
                  {
                     break;
                  }
                  lev++;
               }
            }
            if(notification != null && e.startUpgrade == true && enoughCash == true)
            {
               InstanceMng.getUIFacade().closePopup(e.popup);
               InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notification);
               return false;
            }
            if(this.wioUpgradePopupNeedsToBeClosed())
            {
               InstanceMng.getUIFacade().closePopup(e.popup);
            }
            if(eventItem != null && this.wioUpgradePopupNeedsToBePaused())
            {
               eventItem.resume();
            }
            continueTransaction = true;
            if(e.startUpgrade == true)
            {
               if(isPremiumUpgrade)
               {
                  continueTransaction = enoughCash;
               }
               if(continueTransaction && transactionPack.performAllTransactions() == true)
               {
                  if(isPremiumUpgrade)
                  {
                     e.cmd = "WIOEventUpgradePremium";
                     e.button = null;
                  }
                  InstanceMng.getGUIControllerPlanet().eventWhenSuccess(e);
                  e.cmd = "WIOEventUpgradeStart";
               }
            }
            e.premiumUpgrade = null;
            e.premiumTransaction = null;
         }
         return true;
      }
      
      protected function getModifyCurrentTaskDroidPopup(e:Object) : DCIPopup
      {
         return InstanceMng.getUIFacade().getPopupFactory().getUpgradeBuildingPopup(e);
      }
      
      private function continueDroidTask(e:Object) : void
      {
         var newEventCmd:String = null;
         var eventItem:WorldItemObject = e.item;
         newEventCmd = "WIOEventUpgradePremium";
         var newEvent:Object = InstanceMng.getGUIController().createNotifyEvent(e.type,newEventCmd,e.sendResponseTo);
         newEvent.item = eventItem;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),newEvent);
      }
      
      protected function wioUpgradePopupNeedsToBePaused() : Boolean
      {
         return false;
      }
      
      protected function wioUpgradePopupNeedsToBeClosed() : Boolean
      {
         return true;
      }
      
      protected function phaseIsIN(value:String) : Boolean
      {
         return value == "IN" || value == null || value == "";
      }
      
      public function translateLogicTypeToCurrentType(popupType:String) : String
      {
         return popupType;
      }
   }
}
