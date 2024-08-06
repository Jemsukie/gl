package com.dchoc.game.controller.gui
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.gui.popups.PopupMng;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.tools.ToolsMng;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.ToolBarFacade;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.popups.inventory.EPopupInventory;
   import com.dchoc.game.eview.popups.navigation.EBuyWorkerPopup;
   import com.dchoc.game.model.flow.FlowState;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWave;
   import com.dchoc.game.model.happening.HappeningTypeWaveDef;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.LevelScoreDef;
   import com.dchoc.game.model.rule.NewPayerPromoDef;
   import com.dchoc.game.model.rule.PopupSkinDef;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.PlanetDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.game.view.dc.map.MapView;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.game.view.facade.CursorFacade;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.component.DCIComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class GUIController extends DCComponentUI
   {
      
      public static const BARSTATE_FRIENDSBAR:int = 0;
      
      public static const BARSTATE_SHOPBAR:int = 1;
      
      protected static var smQuality:String;
      
      protected static const CHILDREN_POPUPMNG_ID:int = 0;
      
      protected static const CHILDREN_BASE_COUNT:int = 0;
      
      private static const NAME_POPUP_BEING_SHOWN:String = "popup";
      
      public static const ZOOM_PERCENT_MAX:int = 150;
      
      public static const ZOOM_PERCENT_MIN:int = 50;
      
      public static const EVENT_CANCEL_BUTTON_PRESSED:String = "EventCancelButtonPressed";
      
      public static const EVENT_SHARE_BUTTON_PRESSED:String = "EventShareButtonPressed";
      
      public static const EVENT_CLOSE_BUTTON_PRESSED:String = "EventCloseButtonPressed";
      
      public static const EVENT_YES_BUTTON_PRESSED:String = "EventYesButtonPressed";
      
      public static const EVENT_CENTER_OK_BUTTON_PRESSED:String = "EventCenterOkButtonPressed";
      
      public static const EVENT_BUTTON_LEFT_PRESSED:String = "EVENT_BUTTON_LEFT_PRESSED";
      
      public static const EVENT_BUTTON_CENTER_PRESSED:String = "EVENT_BUTTON_CENTER_PRESSED";
      
      public static const EVENT_BUTTON_RIGHT_PRESSED:String = "EVENT_BUTTON_RIGHT_PRESSED";
      
      public static const EVENT_ARROW_RIGHT_PRESSED:String = "EVENT_ARROW_RIGHT_PRESSED";
      
      public static const EVENT_ARROW_LEFT_PRESSED:String = "EVENT_ARROW_LEFT_PRESSED";
      
      public static const NOTIFY_OPTIONSCLICK:String = "NOTIFY_OPTIONSCLICK";
      
      public static const NOTIFY_OPTIONS_EXPANDED:String = "NOTIFY_OPTIONS_EXPANDED";
      
      public static const EVENT_SERVER_TRANS_OK:String = "EventServerTransOK";
      
      public static const EVENT_SERVER_TRANS_CANCEL:String = "EventServerTransCancel";
      
      public static const EVENT_NOT_ENOUGH_RESOURCES:String = "EventNotEnoughResources";
      
      public static const NOTIFY_SERVER_RESPONSE:String = "NOTIFY_SERVER_RESPONSE";
      
      public static const NOTIFY_CHANGEFOCUS:String = "NOTIFY_CHANGEFOCUS";
      
      public static const NOTIFY_LOSEFOCUS:String = "NOTIFY_LOSEFOCUS";
      
      public static const NOTIFY_CANCELROADS:String = "NOTIFY_CANCELROADS";
      
      public static const NOTIFY_WAR_NUM_UNITS_UPDATE:String = "NOTIFY_WAR_NUM_UNITS_UPDATE";
      
      public static const NOTIFY_WAR_CLICK_ON_MAP_DEPLOY_UNITS:String = "NOTIFY_WAR_CLICK_ON_MAP_DEPLOY_UNITS";
      
      public static const NOTIFY_WAR_TOOL_SETUP:String = "NOTIFY_WAR_TOOL_SETUP";
      
      public static const NOTIFY_WAR_TOOL_UNSETUP:String = "NOTIFY_WAR_TOOL_UNSETUP";
      
      public static const NOTIFY_TUTORIAL_POPUP:String = "NotifyTutorialPopup";
      
      public static const NOTIFY_TUTORIAL_SPEECH_BUBBLE:String = "NotifyTutorialSpeechBubble";
      
      public static const NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY:String = "NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY";
      
      public static const NOTIFY_BUY_GOLD:String = "NotifyBuyGold";
      
      public static const NOTIFY_BUY_MINERALS:String = "NotifyBuyMinerals";
      
      public static const NOTIFY_BUY_COINS:String = "NotifyBuyCoins";
      
      public static const NOTIFY_BUY_CURRENCY_WITH_FB:String = "NotifyBuyCurrencyWithFB";
      
      public static const NOTIFY_HUD_CASH_TO_MINERALS:String = "NotifyHudCashToMinerals";
      
      public static const NOTIFY_HUD_CASH_TO_COINS:String = "NotifyHudCashToCoins";
      
      public static const NOTIFY_RESOURCES_AND_DROID_NEEDED:String = "NotifyResourcesAndDroidNeeded";
      
      public static const NOTIFY_DROID_NEEDED:String = "NotifyDroidNeeded";
      
      public static const NOTIFY_RESOURCES_NEEDED:String = "NotifyResourcesNeeded";
      
      public static const NOTIFY_DAMAGE_PROTECTION_WARNING:String = "NotifyDamageProtectionWarning";
      
      public static const NOTIFY_MISSION_COMPLETED:String = "NotifyMissionCompleted";
      
      public static const NOTIFY_AFK:String = "NotifyAFKPopup";
      
      public static const EVENT_PROFILE_HAS_CHANGED:String = "EventProfileHasChanged";
      
      public static const EVENT_FLOW:String = "EventFlow";
      
      public static const EVENT_POPUP:String = "EventPopup";
      
      public static const NOTIFY_SWITCH_TO_GALAXY_VIEW:String = "NotifySwitchToGalaxyView";
      
      public static const NOTIFY_LEVEL_UP:String = "NotifyLevelUp";
      
      public static const NOTIFY_MAP_OPEN:String = "NOTIFY_MAP_OPEN";
      
      public static const NOTIFY_COLONIES_OPEN:String = "NOTIFY_COLONIES_OPEN";
      
      public static const NOTIFY_INVENTORY_OPEN:String = "NOTIFY_INVENTORY_OPEN";
      
      public static const NOTIFY_OPEN_FIRST_POPUP:String = "NOTIFY_OPEN_FIRST_POPUP";
      
      public static const NOTIFY_CLOSE_LAST_POPUP:String = "NOTIFY_CLOSE_LAST_POPUP";
      
      public static const NOTIFY_DROIDS_BUY:String = "NOTIFY_DROIDS_BUY";
      
      public static const NOTIFY_DROIDS_PLUS1:String = "NOTIFY_DROIDS_PLUS1";
      
      public static const NOTIFY_DROIDS_MINUS1:String = "NOTIFY_DROIDS_MINUS1";
      
      public static const NOTIFY_ERROR_INFO:String = "NotifyErrorInfo";
      
      public static const NOTIFY_ATTACK_DISTANCE:String = "NOTIFY_ATTACK_DISTANCE";
      
      public static const NOTIFY_CRAFTING_PENDING:String = "NotifyCraftingPending";
      
      public static const EVENT_UNLOCK_WIO_POPUP:String = "EVENT_UNLOCK_WIO_POPUP";
      
      public static const NOTIFY_PASS_FRIENDS_LEVELUP_POPUP:String = "NOTIFY_PASS_FRIENDS_LEVELUP_POPUP";
      
      public static const NOTIFY_FLOW_QUICK_ATTACK:String = "NOTIFY_FLOW_QUICK_ATTACK";
      
      public static const TOOLTIP_TOOLBAR_BUTTON:String = "TooltipToolbarButton";
      
      public static const TOOLTIP_SHOP_RESOURCE:String = "TooltipShopResource";
      
      public static const TOOLTIP_WIO:String = "TooltipWIO";
      
      public static const TOOLTIP_UPPER_HUD:String = "TooltipUpperHud";
      
      public static const TOOLTIP_WIO_WAITING_FOR_DROID:String = "TooltipWIOWaitingForDroid";
      
      public static const TOOLTIP_WIO_CONSTRUCTING:String = "TooltipWIOConstructing";
      
      public static const TOOLTIP_WIO_BUILT:String = "TooltipWIOBuilt";
      
      public static const TOOLTIP_WIO_RECOLLECTING:String = "TooltipWIORecollecting";
      
      public static const TOOLTIP_WIO_SILO:String = "TooltipWIOSilo";
      
      public static const TOOLTIP_WIO_REPAIRING:String = "TooltipWIORepairing";
      
      public static const TOOLTIP_ALLIANCE_COUNCIL:String = "TooltipAllianceCouncil";
      
      public static const TOOLTIP_INVESTS:String = "TooltipEmbassy";
      
      public static const TOOLTIP_WIO_SPY_RESOURCE_COINS:String = "TooltipWIOSpyResourceCoins";
      
      public static const TOOLTIP_WIO_SPY_RESOURCE_MINERALS:String = "TooltipWIOSpyResourceMinerals";
      
      public static const TOOLTIP_WIO_SPY_SILO_COINS:String = "TooltipWIOSpySiloCoins";
      
      public static const TOOLTIP_WIO_SPY_SILO_MINERALS:String = "TooltipWIOSpySiloMinerals";
      
      public static const TOOLTIP_WIO_SPY_DEFENSE:String = "TooltipWIOSpyDefense";
      
      public static const TOOLTIP_WIO_SPY_BUNKER:String = "TooltipWIOSpyBunker";
      
      public static const TOOLTIP_WIO_SPY_HQ:String = "TooltipWIOSpyHQ";
      
      public static const TOOLTIP_WIO_SPY_DEFAULT:String = "TooltipWIOSpyDefault";
      
      public static const NOTIFY_STAR_SHOW_OCCUPIED_PLANET_POPUP:String = "PopupPlanetOccupiedOptions";
      
      public static const NOTIFY_STAR_SHOW_EMPTY_PLANET_POPUP:String = "NOTIFY_STAR_SHOW_EMPTY_PLANET_POPUP";
      
      public static const NOTIFY_BOOKMARK_ALREADY_EXISTS:String = "NOTIFY_BOOKMARK_ALREADY_EXISTS";
      
      public static const NOTIFY_BOOKMARK_MAXIMUM_REACHED:String = "NOTIFY_BOOKMARK_MAXIMUM_REACHED";
      
      public static const NOTIFY_UNIT_UPGRADED:String = "NOTIFY_UNIT_UPGRADED";
      
      public static const NOTIFY_CREATE_ALLIANCE:String = "NotifyCreateAlliance";
      
      public static const NOTIFY_EDIT_ALLIANCE:String = "NotifyEditAlliance";
      
      public static const NOTIFY_ALLIANCES_POPUP:String = "NotifyAlliancesPopup";
      
      public static const NOTIFY_ALLIANCE_POPUP_CONFIRM:String = "NotifyLeaveAlliancePopup";
      
      public static const NOTIFY_ALLIANCE_MEMBER_POPUP:String = "NotifyAllianceMemberPopup";
      
      public static const NOTIFY_ALLIANCES_DECLARE_WAR:String = "NOTIFY_ALLIANCES_DECLARE_WAR";
      
      public static const NOTIFY_ALLIANCES_CURRENT_WAR_WIN:String = "NOTIFY_ALLIANCES_CURRENT_WAR_WIN";
      
      public static const NOTIFY_ALLIANCES_CURRENT_WAR_LOSE:String = "NOTIFY_ALLIANCES_CURRENT_WAR_LOSE";
      
      public static const NOTIFY_ALLIANCES_WELCOME_POPUP:String = "NOTIFY_ALLIANCES_WELCOME_POPUP";
      
      public static const NOTIFY_ALLIANCES_NOT_ENOUGH_LEVEL_POPUP:String = "NOTIFY_ALLIANCES_NOT_ENOUGH_LEVEL_POPUP";
      
      public static const NOTIFY_ALLIANCES_HELP:String = "NotifyAlliancesHelp";
      
      public static const NOTIFY_INVEST_REWARD_TUTORIAL_POPUP:String = "NOTIFY_INVEST_REWARD_TUTORIAL_POPUP";
      
      public static const NOTIFY_STAR_BUY_PLANET_POPUP:String = "NOTIFY_STAR_BUY_PLANET_POPUP";
      
      public static const NOTIFY_STAR_COLONY_BOUGHT:String = "NOTIFY_STAR_COLONY_BOUGHT";
      
      public static const NOTIFY_STAR_MOVE_COLONY_POPUP:String = "NOTIFY_STAR_MOVE_COLONY_POPUP";
      
      public static const NOTIFY_STAR_COLONY_MOVED:String = "NOTIFY_STAR_MOVE_COLONY_POPUP";
      
      public static const NOTIFY_SHOW_SPY_CAPSULES_SHOP:String = "NOTIFY_SHOW_SPY_CAPSULES_SHOP";
      
      public static const NOTIFY_SHOW_SERVER_MAINTENANCE_INFO:String = "NOTIFY_SHOW_SERVER_MAINTENANCE_INFO";
      
      public static const NOTIFY_SHOW_BULLDOZER_WARNING:String = "NOTIFY_SHOW_BULLDOZER_WARNING";
      
      public static const NOTIFY_SHOW_PREMIUM_SHOP_WARNING:String = "NOTIFY_SHOW_PREMIUM_SHOP_WARNING";
      
      public static const NOTIFY_BUY_SPY_CAPSULES:String = "NOTIFY_BUY_SPY_CAPSULES";
      
      public static const NOTIFY_BUY_PURCHASE_ITEM:String = "NOTIFY_BUY_PURCHASE_ITEM";
      
      public static const NOTIFY_SHOW_OFFER_POPUP:String = "NOTIFY_SHOW_OFFER";
      
      public static const NOTIFY_OPEN_GENERAL_INFO:String = "NOTIFY_OPEN_GENERAL_INFO";
      
      public static const NOTIFY_OPEN_EPOPUP:String = "NOTIFY_OPEN_EPOPUP";
      
      public static const NOTIFY_HAPPENING_COUNTDOWN:String = "NotifyHappeningCountdown";
      
      public static const NOTIFY_HAPPENING_START_INTRO:String = "NotifyHappeningStartIntro";
      
      public static const NOTIFY_HAPPENING_READY_TO_START:String = "NotifyHappeningReadyToStart";
      
      public static const NOTIFY_HAPPENING_ENTER_RUNNING:String = "NotifyHappeningEnterRunning";
      
      public static const NOTIFY_HAPPENING_EXIT_RUNNING:String = "NotifyHappeningExitRunning";
      
      public static const NOTIFY_HAPPENING_TYPE_WAVE_COUNTDOWN:String = "NotifyHappeningTypeWaveCountdown";
      
      public static const NOTIFY_HAPPENING_TYPE_WAVE_SPEED_UP:String = "NotifyHappeningTypeWaveSpeedUp";
      
      public static const NOTIFY_HAPPENING_TYPE_WAVE_READY_TO_START:String = "NotifyHappeningTypeWaveReadyToStart";
      
      public static const NOTIFY_HAPPENING_TYPE_WAVE_COMPLETED:String = "NotifyHappeningTypeWaveCompleted";
      
      public static const NOTIFY_HAPPENING_SHOW_SKIP_HAPPENING:String = "NotifyHappeningShowSkipHappening";
      
      public static const NOTIFY_HAPPENING_SHOW_FINAL_REWARD:String = "NotifyHappeningShowFinalReward";
      
      public static const NOTIFY_BET_SHOW_MY_RESULTS:String = "NotifyBetShowMyResults";
      
      public static const NOTIFY_BET_ERROR_BATTLE_TIMEOUT:String = "NotifyBetErrorBattleTimeout";
      
      public static const NOTIFY_ATTACK_ALLOWED:String = "NotifyAttackAllowed";
      
      public static const POPUP_AFK_TYPE_IDLE:String = "PopupAfkTypeIdle";
      
      public static const POPUP_AFK_TYPE_TUTORIAL:String = "PopupAfkTypeTutorial";
      
      private static const ZOOM_OFF_NUMBER:Number = 0.05;
      
      private static const ZOOM_OFF_INT:Number = 5;
       
      
      protected var mViewMngrGameRef:ViewMngrGame;
      
      protected var mPopupMngRef:PopupMng;
      
      protected var mCurrentBarState:int;
      
      protected var mStage:DCStage;
      
      protected var mAttackWaitingForServerResponse:Boolean = false;
      
      private var mQualityLoaded:Boolean;
      
      protected var mCoor:DCCoordinate;
      
      private var mFocusEventEnabled:Boolean = false;
      
      protected var mChildrenBySku:Dictionary;
      
      protected var mMapViewLimitBottomY:int;
      
      protected var mMapViewLimitBottomDO:Shape;
      
      private var mCinematicsPreviousTool:int;
      
      private var mSpotlightOn:Boolean;
      
      protected var mCurrentFocusSku:String = null;
      
      protected var mMouseOverChildSku:String = null;
      
      protected var mFocusTestPerformedOnTick:Boolean;
      
      protected var mPendingEvents:Vector.<Object>;
      
      private var mZoomSign:int;
      
      private var mZoomCurrent:int;
      
      private var mZoomTarget:int;
      
      protected var mProfileLastPlayerName:String;
      
      protected var mProfileLastWorldName:String;
      
      protected var mProfileLastCoins:Number;
      
      protected var mProfileLastCash:Number;
      
      protected var mProfileLastMinerals:Number;
      
      protected var mProfileLastMaxMineralAmount:Number;
      
      protected var mProfileLastMaxCoinsAmount:Number;
      
      protected var mProfileLastDroids:Number;
      
      protected var mProfileLastMaxDroidsAmount:Number;
      
      protected var mProfileLastXp:Number;
      
      protected var mProfileLastScore:Number;
      
      protected var mProfileLastLevel:Number;
      
      protected var mFullLocked:Boolean;
      
      public function GUIController()
      {
         super();
         this.mCurrentBarState = 0;
      }
      
      public static function isASpyTooltip(id:String) : Boolean
      {
         return id == "TooltipWIOSpyResourceCoins" || id == "TooltipWIOSpyResourceMinerals" || id == "TooltipWIOSpySiloCoins" || id == "TooltipWIOSpySiloMinerals" || id == "TooltipWIOSpyDefense" || id == "TooltipWIOSpyBunker" || id == "TooltipWIOSpyHQ" || id == "TooltipWIOSpyDefault";
      }
      
      public static function getTooltipWIOSpyByItem(item:WorldItemObject) : String
      {
         var resourceType:int = 0;
         var returnValue:String = null;
         if(item != null && item.mDef.isSpiable())
         {
            if(item.mDef.isHeadQuarters())
            {
               returnValue = "TooltipWIOSpyHQ";
            }
            else
            {
               resourceType = item.mDef.getTypeId();
               switch(resourceType)
               {
                  case 0:
                     returnValue = "TooltipWIOSpyResourceCoins";
                     break;
                  case 1:
                     returnValue = "TooltipWIOSpyResourceMinerals";
                     break;
                  case 2:
                     returnValue = item.mDef.getMineralsStorage() > 0 ? "TooltipWIOSpySiloMinerals" : "TooltipWIOSpySiloCoins";
                     break;
                  case 6:
                     returnValue = "TooltipWIOSpyDefense";
                     break;
                  case 8:
                     returnValue = "TooltipWIOSpyBunker";
                     break;
                  default:
                     returnValue = "TooltipWIOSpyDefault";
               }
            }
         }
         return returnValue;
      }
      
      private static function zoomBarValueToRealValue(value:int) : int
      {
         return value + 50;
      }
      
      private static function zoomRealValueToBarValue(value:int) : int
      {
         return value - 50;
      }
      
      public function setViewMng(viewMng:ViewMngrGame) : void
      {
         this.mViewMngrGameRef = viewMng;
      }
      
      override protected function childrenCreate() : void
      {
         var popupMng:PopupMng = InstanceMng.getPopupMng();
         if(popupMng == null)
         {
            this.mPopupMngRef = new PopupMng();
            this.mPopupMngRef.load();
            InstanceMng.registerPopupMng(this.mPopupMngRef);
            childrenAddChild(this.mPopupMngRef);
         }
         else
         {
            this.mPopupMngRef = popupMng;
            if(!this.mPopupMngRef.isLoaded())
            {
               this.mPopupMngRef.load();
            }
            childrenAddChild(this.mPopupMngRef);
         }
         this.childrenAddUIElements();
      }
      
      protected function childrenAddUIElements() : void
      {
         var element:DCComponentUI = null;
         if(this.mChildrenBySku == null)
         {
            this.mChildrenBySku = new Dictionary(true);
         }
         var uiElements:Vector.<DCComponentUI> = InstanceMng.getUIFacade().viewsGetUiElementsByViewSku(this.guiGetViewSku());
         for each(element in uiElements)
         {
            childrenAddChild(element);
            this.mChildrenBySku[element.getParentRef()] = element;
         }
      }
      
      public function getCurrentBarState() : int
      {
         return this.mCurrentBarState;
      }
      
      override protected function childrenUncreate() : void
      {
         super.childrenUncreate();
         InstanceMng.unregisterPopupMng();
         this.mPopupMngRef = null;
         this.mChildrenBySku = null;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mStage = InstanceMng.getApplication().stageGetStage();
            this.mPendingEvents = new Vector.<Object>(0);
            this.mCoor = new DCCoordinate();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mStage = null;
         this.mPendingEvents.length = 0;
         this.mPendingEvents = null;
         this.mCoor = null;
         smQuality = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      protected function mapViewDrawLimits() : void
      {
         var g:Graphics = this.mMapViewLimitBottomDO.graphics;
         g.clear();
         g.lineStyle(2,10027008,0.75);
         g.moveTo(0,this.mMapViewLimitBottomY);
         g.lineTo(this.mStage.getStageWidth(),this.mMapViewLimitBottomY);
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt())
         {
            this.mMapViewLimitBottomDO = new Shape();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mMapViewLimitBottomDO = null;
         this.mFocusEventEnabled = false;
         this.mFocusTestPerformedOnTick = false;
         this.cinematicsReset();
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         var i:int = 0;
         if(mChildren != null)
         {
            for(i = mChildren.length - 1; i > -1; )
            {
               DCComponentUI(mChildren[i]).unbuild(mode);
               i--;
            }
         }
         this.mProfileLastPlayerName = "";
         this.mProfileLastWorldName = "";
         this.mProfileLastCoins = -1;
         this.mProfileLastCash = -1;
         this.mProfileLastMinerals = -1;
         this.mProfileLastMaxMineralAmount = -1;
         this.mProfileLastMaxCoinsAmount = -1;
         this.mProfileLastDroids = -1;
         this.mProfileLastMaxDroidsAmount = -1;
         this.mProfileLastXp = -1;
         this.mProfileLastScore = -1;
         this.mProfileLastLevel = -1;
         this.mViewMngrGameRef.unbuild(mode);
      }
      
      override protected function beginDo() : void
      {
         this.zoomBegin();
         var stageW:int = InstanceMng.getApplication().stageGetWidth();
         var stageH:int = InstanceMng.getApplication().stageGetHeight();
         if(this.mPopupMngRef != null)
         {
            this.mPopupMngRef.onResize(stageW,stageH);
         }
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.resetProfileLastVars();
         var updateView:Object = this.createNotifyEvent("","EventProfileHasChanged",null,null,null,profile);
         this.notify(updateView);
      }
      
      override protected function endDo() : void
      {
         super.endDo();
         this.mFocusEventEnabled = false;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var profile:Profile = null;
         var quality:String = null;
         if(!this.mQualityLoaded)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(profile.isBuilt())
            {
               quality = profile.getQuality();
               if(quality == null || quality == "")
               {
                  smQuality = "high";
               }
               else
               {
                  smQuality = quality;
               }
               this.mStage.getImplementation().quality = smQuality;
               this.mQualityLoaded = true;
            }
         }
         if(!this.mFocusEventEnabled && !InstanceMng.getApplication().lockUIIsLocked() && InstanceMng.getPopupMng().getPopupBeingShown() == null)
         {
            this.mFocusEventEnabled = true;
            this.mFocusTestPerformedOnTick = false;
            this.lockGUI();
            this.unlockGUI();
            this.performFocusTest();
         }
         super.logicUpdateDo(dt);
         if(this.mZoomSign != 0)
         {
            this.zoomLogicUpdate(dt);
         }
         this.focusLogicUpdate(dt);
         this.notifyLogicUpdate(dt);
      }
      
      public function showFriendsBar() : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         uiFacade.friendsBarShow();
         var toolBar:ToolBarFacade = this.getToolBar();
         if(!toolBar.isVisible())
         {
            toolBar.moveAppearDownToUp();
         }
         var navigationBar:GUIComponent = InstanceMng.getUIFacade().getNavigationBarFacade();
         if(navigationBar)
         {
            navigationBar.moveAppearDownToUp();
         }
      }
      
      public function hideFriendsBar() : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         uiFacade.friendsBarHide();
         var toolBar:ToolBarFacade = this.getToolBar();
         if(toolBar.isVisible())
         {
            toolBar.moveDisappearUpToDown();
         }
         var navigationBar:GUIComponent = InstanceMng.getUIFacade().getNavigationBarFacade();
         if(navigationBar)
         {
            navigationBar.moveDisappearUpToDown();
         }
      }
      
      public function hideHud() : void
      {
         var hud:TopHudFacade = this.getTopHudFacade();
         if(hud != null)
         {
            hud.moveDisappearDownToUp();
         }
      }
      
      public function showHud() : void
      {
         var hud:TopHudFacade = this.getTopHudFacade();
         if(hud != null)
         {
            hud.moveAppearUpToDown();
         }
      }
      
      public function optionClick(optionType:String) : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         switch(optionType)
         {
            case "button_quality":
            case "button_quality_cancel":
               if(smQuality == "high")
               {
                  smQuality = "low";
               }
               else
               {
                  smQuality = "high";
               }
               this.mStage.getImplementation().quality = smQuality;
               profile.setQuality(smQuality);
               break;
            case "button_music":
               profile.setMusic(false);
               break;
            case "button_music_cancel":
               profile.setMusic(true);
               break;
            case "button_full_screen":
            case "button_full_screen_cancel":
               InstanceMng.getApplication().toggleFullScreen();
               break;
            case "button_volume":
               profile.setSound(false);
               break;
            case "button_volume_cancel":
               profile.setSound(true);
               break;
            case "button_zoom_in":
               this.onZoomMove(InstanceMng.getMapView().zoomGetAmount());
               break;
            case "button_zoom_out":
               this.onZoomMove(-InstanceMng.getMapView().zoomGetAmount());
               break;
            case "button_flatbed_view":
               InstanceMng.getUserInfoMng().getProfileLogin().toggleFlatbed();
               break;
            case "button_expand":
               MessageCenter.getInstance().sendMessage("hudOptionsMenuClicked",null);
         }
      }
      
      public function cinematicsReset() : void
      {
         this.mCinematicsPreviousTool = 11;
      }
      
      public function cinematicsStart() : void
      {
         InstanceMng.getUIFacade().blackStripsShow(true);
         this.mCinematicsPreviousTool = InstanceMng.getToolsMng().getCurrentToolId();
         InstanceMng.getToolsMng().setTool(11);
         InstanceMng.getMapControllerPlanet().setIsScrollAllowed(false);
         InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(false,true);
         if(Config.useAlliances())
         {
            InstanceMng.getAlliancesController().setEnabled(false);
         }
      }
      
      public function cinematicsFinish() : void
      {
         InstanceMng.getUIFacade().blackStripsHide();
         InstanceMng.getMapControllerPlanet().setIsScrollAllowed(true);
         InstanceMng.getToolsMng().setTool(this.mCinematicsPreviousTool);
         InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(true,true);
         if(Config.useAlliances())
         {
            InstanceMng.getAlliancesController().setEnabled(true);
         }
      }
      
      public function getComponentByName(name:String) : DCIComponent
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var _loc3_:* = name;
         if("popup" !== _loc3_)
         {
            return uiFacade.viewsGetUiElementBySkuAndViewSku(name,this.guiGetViewSku());
         }
         return this.getPopupBeingShown();
      }
      
      private function getCursorFacade() : CursorFacade
      {
         return InstanceMng.getUIFacade().getCursorFacade();
      }
      
      private function getTopHudFacade() : TopHudFacade
      {
         return InstanceMng.getUIFacade().getTopHudFacade();
      }
      
      public function getToolBar() : ToolBarFacade
      {
         return InstanceMng.getUIFacade().viewsGetUiElementBySkuAndViewSku("toolbar",this.guiGetViewSku()) as ToolBarFacade;
      }
      
      public function getPopupBeingShown() : DCIPopup
      {
         return InstanceMng.getPopupMng().getPopupBeingShown();
      }
      
      public function hideOpenedBar() : void
      {
         this.hideFriendsBar();
         getToolBar().hideToolbarExtended();
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var cashIn:Number = NaN;
         var profileId:int = 0;
         switch(int(e.keyCode) - 116)
         {
            case 0:
               cashIn = 15;
               DCDebug.trace("Adding " + cashIn + " cash to the profile selected");
               InstanceMng.getUserInfoMng().getProfileLogin().addCash(cashIn);
               break;
            case 1:
               profileId = InstanceMng.getUserInfoMng().getCurrentProfileLoadedId();
               DCDebug.trace("Printing current profile loaded: " + profileId);
               InstanceMng.getUserInfoMng().printProfile(profileId);
         }
      }
      
      public function cursorSetId(id:int) : void
      {
         var cursor:CursorFacade = this.getCursorFacade();
         if(cursor != null)
         {
            cursor.setCursorId(id);
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         var child:DCComponentUI = null;
         for each(child in mChildren)
         {
            child.onResize(stageWidth,stageHeight);
         }
         this.mMapViewLimitBottomY = this.mStage.getStageHeight() - 130;
         this.mapViewDrawLimits();
         if(this.mPopupMngRef != null)
         {
            this.mPopupMngRef.onResize(stageWidth,stageHeight);
         }
      }
      
      override public function onMouseDown(e:MouseEvent) : void
      {
         var comp:DCComponentUI = null;
         for each(comp in mChildren)
         {
            comp.onMouseDown(e);
         }
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         DCComponentUI(mChildren[0]).onMouseUp(e);
      }
      
      override public function onMouseWheel(e:MouseEvent) : void
      {
         var sign:Number = NaN;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(!DCPopupMng.smIsPopupActive && !this.mFullLocked && !InstanceMng.getFlowStatePlanet().isTutorialRunning() && profile != null)
         {
            if(!profile.getScrollZoomEnabled())
            {
               return;
            }
            sign = e.delta < 0 ? -1 : 1;
            if(profile.getScrollZoomInverted())
            {
               sign = -sign;
            }
            this.onZoomMove(sign * InstanceMng.getMapView().zoomGetAmount());
         }
      }
      
      override public function onZoomSet(value:Number) : void
      {
         this.mZoomCurrent = this.mZoomTarget = value;
         InstanceMng.getViewMngPlanet().worldOnZoomForce(this.mZoomTarget / 100);
      }
      
      override public function onZoomMove(off:Number) : void
      {
         var profile:Profile = null;
         var originalTarget:int = this.mZoomTarget;
         this.mZoomTarget += off * 100;
         this.mZoomTarget = Math.min(this.mZoomTarget,150);
         this.mZoomTarget = Math.max(this.mZoomTarget,50);
         var finalTarget:int = this.mZoomTarget;
         if(this.mZoomTarget != this.mZoomCurrent)
         {
            this.mZoomSign = this.mZoomTarget > this.mZoomCurrent ? 1 : -1;
            InstanceMng.getMapView().onZoomSet(this.mZoomTarget / 100);
            if(originalTarget != finalTarget)
            {
               profile = InstanceMng.getUserInfoMng().getProfileLogin();
               profile.flagsSetValue("zoom",zoomRealValueToBarValue(this.mZoomTarget));
            }
         }
         MessageCenter.getInstance().sendMessage("cameraMaxZoomOut");
         if(this.mZoomTarget >= zoomBarValueToRealValue(50))
         {
            MessageCenter.getInstance().sendMessage("cameraMaxZoomIn");
         }
         else
         {
            MessageCenter.getInstance().sendMessage("cameraMaxZoomOut");
         }
      }
      
      public function setMouseOverChildSku(elementSku:String) : void
      {
      }
      
      protected function giveFocus(sku:String) : void
      {
      }
      
      protected function changeFocus(sku:String) : void
      {
      }
      
      public function performFocusTest() : void
      {
      }
      
      public function getFocusTestComponentSku() : String
      {
         return null;
      }
      
      protected function focusLogicUpdate(dt:int) : void
      {
      }
      
      protected function notifyCanBeProcessed(e:Object) : Boolean
      {
         var roleOwner:* = false;
         var isExceptionCase:Boolean = false;
         var bool1:Boolean = false;
         var bool2:* = false;
         var bool2_1:Boolean = false;
         var bool3:* = false;
         var bool4:* = false;
         var popup:DCIPopup = null;
         var returnValue:Boolean = false;
         var popupType:String = null;
         var popupOpen:DCIPopup = null;
         if(InstanceMng.getApplication().networkIsBusy() == true)
         {
            return false;
         }
         if(e.type == "EventPopup" && InstanceMng.getWelcomePopupsMng().hasPopupOpened())
         {
            isExceptionCase = false;
            if(e.cmd == "NotifyAFKPopup")
            {
               isExceptionCase = true;
            }
            if(isExceptionCase == false)
            {
               return false;
            }
         }
         var role:int;
         roleOwner = (role = InstanceMng.getFlowStatePlanet().getCurrentRoleId()) == 0;
         var currentPlanetIsCapital:Boolean = false;
         currentPlanetIsCapital = true;
         switch(e.cmd)
         {
            case "NotifyMissionCompleted":
               return roleOwner && InstanceMng.getMapView().isBuilt() && currentPlanetIsCapital;
            case "NotifyLevelUp":
               bool1 = roleOwner && InstanceMng.getMapView().isBuilt();
               bool2_1 = (bool2 = !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting()) || bool2 == false && this.phaseIsIN(e.phase) == false;
               bool3 = InstanceMng.getApplication().fsmGetCurrentState().isALoadingState() == false;
               bool4 = InstanceMng.getUnitScene().battleIsRunning() == false;
               return bool1 && bool2_1 && bool3 && bool4;
            case "NOTIFY_UNIT_UPGRADED":
               return roleOwner && InstanceMng.getMapView().isBuilt();
            case "NotifyHappeningTypeWaveReadyToStart":
            case "NotifyHappeningShowFinalReward":
               break;
            case "NotifyBetShowMyResults":
               bool1 = Config.useBets();
               bool2_1 = (bool2 = !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting()) || bool2 == false && this.phaseIsIN(e.phase) == false;
               bool3 = InstanceMng.getMapView().isBuilt();
               bool4 = InstanceMng.getApplication().fsmGetCurrentState().isALoadingState() == false;
               return bool1 && bool2_1 && bool3 && bool4;
            case "NOTIFY_OPEN_EPOPUP":
               popup = e.popup;
               returnValue = true;
               if(popup != null)
               {
                  popupType = popup.getPopupType();
                  popupOpen = InstanceMng.getPopupMng().getPopupBeingShown();
                  var _loc15_:* = popupType;
                  if("PopupContestResults" === _loc15_)
                  {
                     returnValue = popupOpen == null || popupOpen.getPopupType() == "PopupContest";
                  }
               }
               return returnValue;
            default:
               return true;
         }
         bool1 = InstanceMng.getHappeningMng().isRunning();
         bool2_1 = (bool2 = !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting()) || bool2 == false && this.phaseIsIN(e.phase) == false;
         bool3 = InstanceMng.getMapView().isBuilt();
         return bool1 && bool2_1 && bool3;
      }
      
      private function notifyLogicUpdate(dt:int) : void
      {
         var e:Object = null;
         if(this.mPendingEvents != null && this.mPendingEvents.length > 0)
         {
            e = this.mPendingEvents[0];
            if(this.notify(e) == true)
            {
               this.mPendingEvents.shift();
            }
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var popup:DCIPopup = null;
         var i:int = 0;
         var child:DCComponentUI = null;
         var length:int = 0;
         var hud:TopHudFacade = null;
         var profile:Profile = null;
         var updateShop:Boolean = false;
         var reloadFriendsBar:Boolean = false;
         var optionType:String = null;
         var elementSku:String = null;
         var enableMap:Boolean = false;
         var mapView:MapView = null;
         var mouseOnMap:Boolean = false;
         var mapViewSku:String = null;
         if(this.notifyCanBeProcessed(e) == false)
         {
            if(this.mPendingEvents.indexOf(e) == -1)
            {
               this.mPendingEvents.push(e);
            }
            return false;
         }
         var returnValue:Boolean = false;
         switch(e.type)
         {
            case "EventFlow":
               returnValue = this.notifyFlow(e);
               break;
            case "EventPopup":
               returnValue = this.notifyPopup(e);
               break;
            case "EventNotEnoughResources":
               returnValue = this.notifyNotEnoughResources(e);
               break;
            case 5:
               returnValue = this.notifyWarEvent(e);
               break;
            case "NOTIFY_SERVER_RESPONSE":
               switch(e.cmd)
               {
                  case "EventServerTransOK":
                     e.cmd = e.cmdOrig;
                     e.type = e.typeOrig;
                     this.notify(e);
                     break;
                  case "EventServerTransCancel":
                     this.responseCancelledReceivedFromServer(e);
                     returnValue = true;
               }
               break;
            default:
               length = int(mChildren.length);
               switch(e.cmd)
               {
                  case "EventProfileHasChanged":
                     if(!((hud = this.getTopHudFacade()) == null || !hud.isBuilt()))
                     {
                        profile = e.target as Profile;
                        updateShop = false;
                        reloadFriendsBar = false;
                        if(this.hasPlayerNameChanged(profile))
                        {
                           this.mProfileLastPlayerName = profile.getPlayerName();
                           reloadFriendsBar = true;
                        }
                        if(this.hasCashChanged(profile))
                        {
                           hud.setHudCash(profile.getCash());
                           this.mProfileLastCash = profile.getCash();
                        }
                        if(this.haveCoinsChanged(profile))
                        {
                           this.mProfileLastCoins = profile.getCoins();
                           updateShop = true;
                        }
                        if(this.hasMaxCoinsAmountChanged(profile))
                        {
                           this.mProfileLastMaxCoinsAmount = profile.getCoinsCapacity();
                        }
                        if(this.haveMineralsChanged(profile))
                        {
                           this.mProfileLastMinerals = profile.getMinerals();
                           updateShop = true;
                        }
                        if(this.hasMaxMineralAmountChanged(profile))
                        {
                           this.mProfileLastMaxMineralAmount = profile.getMineralsCapacity();
                        }
                        if(this.haveDroidsChanged(profile))
                        {
                           this.mProfileLastDroids = profile.getDroids();
                        }
                        if(this.hasMaxDroidsAmountChanged(profile))
                        {
                           this.mProfileLastMaxDroidsAmount = profile.getMaxDroidsAmount();
                        }
                        if(this.hasLevelChanged(profile))
                        {
                           this.mProfileLastLevel = profile.getLevel();
                           updateShop = true;
                           reloadFriendsBar = true;
                        }
                        if(this.hasScoreChanged(profile))
                        {
                           this.mProfileLastScore = profile.getScore();
                        }
                        if(updateShop || reloadFriendsBar)
                        {
                           InstanceMng.getUIFacade().reloadCurrentBottomBar(reloadFriendsBar);
                        }
                        returnValue = true;
                     }
                     break;
                  case "NOTIFY_CHANGEFOCUS":
                     if(this.mFocusEventEnabled)
                     {
                        elementSku = String(e["parentIdx"]);
                        this.setMouseOverChildSku(elementSku);
                        this.changeFocus(elementSku);
                        returnValue = true;
                     }
                     break;
                  case "NOTIFY_LOSEFOCUS":
                     if(!DCPopupMng.smIsPopupActive && !this.mFullLocked)
                     {
                        enableMap = true;
                        i = 0;
                        while(i < length && enableMap)
                        {
                           child = mChildren[i] as DCComponentUI;
                           enableMap &&= !child.uiIsEnabled();
                           i++;
                        }
                        mapView = InstanceMng.getMapView();
                        if(enableMap && mapView != null)
                        {
                           mapView.uiEnable();
                        }
                        if(mouseOnMap = mapView != null && mapView.uiIsEnabled() || enableMap)
                        {
                           mapViewSku = this.getSpecificMapViewSku();
                           this.setMouseOverChildSku(mapViewSku);
                        }
                     }
                     returnValue = true;
                     break;
                  case "NOTIFY_OPTIONSCLICK":
                     optionType = String(e.optionType);
                     this.optionClick(optionType);
                     returnValue = true;
                     break;
                  case "NOTIFY_OPTIONS_EXPANDED":
                     popup = InstanceMng.getUIFacade().getPopupFactory().getOptionsPopup();
                     InstanceMng.getUIFacade().enqueuePopup(popup);
                     returnValue = true;
                     break;
                  case "NOTIFY_DROIDS_MINUS1":
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addDroids(-1);
                     returnValue = true;
                     break;
                  case "NOTIFY_DROIDS_PLUS1":
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addDroids(1);
                     returnValue = true;
                     break;
                  default:
                     returnValue = false;
               }
         }
         return returnValue;
      }
      
      protected function getSpecificMapViewSku() : String
      {
         return null;
      }
      
      protected function responseCancelledReceivedFromServer(e:Object) : void
      {
         var obj:Object = null;
         var transaction:Transaction = e.transaction as Transaction;
         if(transaction != null)
         {
            obj = transaction.getTransInfoPackage();
            if(obj != null)
            {
               if(obj.popup != null)
               {
                  this.mPopupMngRef.closePopup(obj.popup);
               }
            }
            transaction.reset();
         }
         if(e.item != null)
         {
            if(e.item is WorldItemObject)
            {
               (e.item as WorldItemObject).resume();
            }
            if(e.item is Shipyard)
            {
               Shipyard(e.item).resumeProduction(true);
            }
         }
         if(e.popup != null)
         {
            this.mPopupMngRef.closePopup(e.popup);
         }
         e.type = e.typeOrig;
         e.cmd = e.cmdOrig;
         this.resetNotifyEvent(e);
      }
      
      protected function notifyNotEnoughResources(e:Object, checkRetardedIf:Boolean = true) : Boolean
      {
         var obj:Object = null;
         var trans:Transaction = null;
         var notification:Notification = null;
         var timeLeft:Number = NaN;
         var infoPackage:Object = null;
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(this.checkIfNeedsToCallServer(checkRetardedIf,e,true) == true)
         {
            return true;
         }
         var closeOpenedPopups:Boolean = e.closeOpenedPopups != null ? Boolean(e.closeOpenedPopups) : false;
         switch(e.cmd)
         {
            case "NotifyDroidNeeded":
            case "NotifyResourcesAndDroidNeeded":
               if(this.phaseIsIN(e.phase))
               {
                  InstanceMng.getTrafficMng().droidsEnableItemsWithDroid(false);
                  e.phase = "OUT";
                  if(e.cmd == "NotifyDroidNeeded")
                  {
                     notification = notificationsMng.createNotificationNotEnoughWorkers(e);
                     notificationsMng.guiOpenNotificationMessage(notification,closeOpenedPopups);
                  }
                  else if(e.cmd == "NotifyResourcesAndDroidNeeded")
                  {
                     notification = notificationsMng.createNotificationNotEnoughResourcesAndWorker(e);
                     notificationsMng.guiOpenNotificationMessage(notification,closeOpenedPopups);
                  }
               }
               else
               {
                  InstanceMng.getTrafficMng().droidsEnableItemsWithDroid(true);
                  e.phase = "";
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                        this.mPopupMngRef.closePopup(e.popup);
                        break;
                     case "EventYesButtonPressed":
                     case "EventCenterOkButtonPressed":
                        if((trans = e.transaction).mDifferenceDroids.value < 0)
                        {
                           timeLeft = InstanceMng.getTrafficMng().droidsGetSmallestTimeForFreeDroid();
                           InstanceMng.getTrafficMng().droidsReleaseSmallestTimeDroid();
                           e.frictionSmallestTimeDroid = timeLeft;
                           e.frictionCash = trans.getTransCashToPay();
                           InstanceMng.getApplication().mTransactionEventComesFrom = e;
                        }
                        if(!trans.getDroidsWillBePayedWithCash())
                        {
                           this.performTransactionWhenServerResponseReceived(e,trans);
                        }
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
                  this.resetNotifyEvent(obj);
               }
               break;
            case "NotifyResourcesNeeded":
               if(this.phaseIsIN(e.phase))
               {
                  notification = notificationsMng.createNotificationNotEnoughResources(e);
                  notificationsMng.guiOpenNotificationMessage(notification,closeOpenedPopups);
                  e.phase = "OUT";
               }
               else
               {
                  e.phase = "";
                  this.mPopupMngRef.closePopup(e.popup);
                  if((trans = e.transaction as Transaction) != null)
                  {
                     if((infoPackage = trans.getTransInfoPackage()) != null && infoPackage.resumeOperation == true && (e.button != null && e.button == "EventYesButtonPressed"))
                     {
                        this.performTransactionWhenServerResponseReceived(e,trans);
                     }
                     if(e.button != null && e.button == "EventYesButtonPressed")
                     {
                        if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3)
                        {
                           InstanceMng.getUIFacade().getWarBarSpecial().popupAccepted = true;
                        }
                     }
                  }
                  this.resetNotifyEvent(e);
                  this.resetNotifyEvent(obj);
               }
         }
         return true;
      }
      
      public function performTransactionWhenServerResponseReceived(e:Object, trans:Transaction) : Boolean
      {
         var obj:Object = null;
         var returnValue:Boolean = false;
         if(trans != null)
         {
            returnValue = trans.performAllTransactions();
            if(returnValue == true)
            {
               this.notifyConsoleFrictionlessPayment(e);
               if((obj = trans.getTransInfoPackage()) != null)
               {
                  obj.transaction = trans;
                  obj.phase = "OUT";
                  this.eventWhenSuccess(obj);
               }
            }
         }
         return returnValue;
      }
      
      public function eventWhenSuccess(e:Object) : void
      {
         e.eventWhenSuccess = true;
         this.sendBackEvent(e);
      }
      
      public function eventWhenCancel(e:Object) : void
      {
         var infoPackage:Object = null;
         var uInfo:UserInfo = null;
         if(e != null)
         {
            e.eventWhenCancel = true;
            var _loc4_:* = e.cmd;
            if("NOTIFY_ATTACK_DISTANCE" === _loc4_)
            {
               infoPackage = Transaction(e.transaction).getTransInfoPackage();
               uInfo = UserInfo(infoPackage.userInfo);
               if(uInfo != null && uInfo.mIsNPC.value == false)
               {
                  InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_FREE_LOCKED_ATTACK,{"userId":uInfo.getAccountId()});
               }
            }
         }
      }
      
      protected function notifyConsoleFrictionlessPayment(e:Object) : void
      {
      }
      
      protected function checkIfNeedsToCallServer(checkRetardedIf:Boolean, e:Object, isNeedMoreResourcesCase:Boolean = false) : Boolean
      {
         var trans:Transaction = null;
         var returnValue:Boolean = false;
         if(checkRetardedIf)
         {
            if((trans = this.selectEventTransaction(e)) != null)
            {
               if(e.phase == "OUT" && trans.getTransactionNeedsServerResponse() && e.button == "EventYesButtonPressed")
               {
                  if((e.cmd == "WIOEventInstantUpgrade" || e.cmd == "WIOEventInstantBuild") && !this.flowCheckIfEnoughMinerals(trans,e))
                  {
                     returnValue = true;
                  }
                  else if(!this.flowCheckIfEnoughCash(trans,e))
                  {
                     returnValue = true;
                  }
                  else
                  {
                     returnValue = InstanceMng.getApplication().transactionWait(trans,this,e);
                  }
               }
            }
         }
         return returnValue;
      }
      
      public function flowCheckIfEnoughCash(trans:Transaction, e:Object, closeCurrentPopup:Boolean = true) : Boolean
      {
         var popup:DCIPopup = null;
         var infoPackage:Object = null;
         var o:Object = null;
         var notificationsMng:NotificationsMng = null;
         var notification:Notification = null;
         var returnValue:*;
         if(!(returnValue = InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= trans.getLogicCashToPay()))
         {
            popup = InstanceMng.getPopupMng().getPopupBeingShown();
            if(closeCurrentPopup)
            {
               InstanceMng.getPopupMng().closeCurrentPopup(null);
            }
            if(e != null)
            {
               e.button = "EventCloseButtonPressed";
               e.buttonLocationEvent = "EventCloseButtonPressed";
               this.notify(e);
            }
            if(trans != null)
            {
               infoPackage = trans.getTransInfoPackage();
               this.eventWhenCancel(infoPackage);
            }
            if(InstanceMng.getPlatformSettingsDefMng().isPaymentsEnabled())
            {
               o = this.createNotifyEvent("EventPopup","NotifyBuyGold",InstanceMng.getGUIController(),null,null,null,null,trans);
               this.notifyPopup(o);
            }
            else
            {
               notification = (notificationsMng = InstanceMng.getNotificationsMng()).createNotificationPaymentsAreDisabled();
               notificationsMng.guiOpenNotificationMessage(notification);
            }
         }
         return returnValue;
      }
      
      public function flowCheckIfEnoughMinerals(trans:Transaction, e:Object, closeCurrentPopup:Boolean = true) : Boolean
      {
         var popup:DCIPopup = null;
         var infoPackage:Object = null;
         var o:Object = null;
         var notificationsMng:NotificationsMng = null;
         var notification:Notification = null;
         var returnValue:*;
         if(!(returnValue = InstanceMng.getUserInfoMng().getProfileLogin().getMinerals() >= -trans.getTransMinerals()))
         {
            popup = InstanceMng.getPopupMng().getPopupBeingShown();
            if(closeCurrentPopup)
            {
               InstanceMng.getPopupMng().closeCurrentPopup(null);
            }
            if(e != null)
            {
               e.button = "EventCloseButtonPressed";
               e.buttonLocationEvent = "EventCloseButtonPressed";
               this.notify(e);
            }
            if(trans != null)
            {
               infoPackage = trans.getTransInfoPackage();
               this.eventWhenCancel(infoPackage);
            }
            if(InstanceMng.getPlatformSettingsDefMng().isPaymentsEnabled())
            {
               o = this.createNotifyEvent("EventPopup","NotifyBuyMinerals",InstanceMng.getGUIController(),null,null,null,null,trans);
               this.notifyPopup(o);
            }
            else
            {
               notification = (notificationsMng = InstanceMng.getNotificationsMng()).createNotificationPaymentsAreDisabled();
               notificationsMng.guiOpenNotificationMessage(notification);
            }
         }
         return returnValue;
      }
      
      private function selectEventTransaction(e:Object) : Transaction
      {
         var returnValue:Transaction = null;
         switch(e.cmd)
         {
            case "WIOEventUpgradePremium":
            case "WIOEventUpgradeStart":
               returnValue = e.premiumUpgrade == null ? e.transaction as Transaction : e.premiumTransaction as Transaction;
               break;
            default:
               returnValue = e.transaction as Transaction;
         }
         return returnValue;
      }
      
      protected function notifyFlow(e:Object) : Boolean
      {
         var t:Transaction = null;
         var goAhead:* = false;
         var returnValue:Boolean = true;
         var _loc5_:* = e.cmd;
         if("NOTIFY_FLOW_QUICK_ATTACK" === _loc5_)
         {
            t = e.transaction;
            if((goAhead = t != null) && !t.getTransHasBeenPerformed())
            {
               goAhead = t.performAllTransactions(false);
            }
            if(goAhead)
            {
               FlowState.mVisitTransaction = t;
               InstanceMng.getApplication().changePlanet(e.starId,e.starName,e.starCoord,true);
            }
         }
         return returnValue;
      }
      
      protected function notifyPopup(e:Object, checkRetardedIf:Boolean = true) : Boolean
      {
         var popup:DCIPopup = null;
         var notification:Notification = null;
         var objPopup:DCIPopup = null;
         var happeningTypeWave:HappeningTypeWave = null;
         var transaction:Transaction = null;
         var closeInstantly:* = false;
         var o:Object = null;
         var playerName:String = null;
         var level:* = null;
         var popupEvent:Object = null;
         var friendsPassed:Vector.<UserInfo> = null;
         var advisorId:String = null;
         var advisorSize:int = 0;
         var title:String = null;
         var buttonText:String = null;
         var sound:String = null;
         var useBubble:Boolean = false;
         var openImmediately:Boolean = false;
         var body:String = null;
         var vAlign:int = 0;
         var itemObject:ItemObject = null;
         var closePopupInstantly:Boolean = false;
         var goToplanet:Boolean = false;
         var errMessage:String = null;
         var continueToPlanetTransactionOK:Boolean = false;
         var lockApplied:Boolean = false;
         var userInfo:UserInfo = null;
         var lockReason:int = 0;
         var sku:String = null;
         var buttonSku:String = null;
         var trans:Transaction = null;
         var happeningDef:HappeningDef = null;
         var happeningTypeWaveDef:HappeningTypeWaveDef = null;
         var popupSkinDef:PopupSkinDef = null;
         var happening:Happening = null;
         var event:Object = null;
         var close:Boolean = false;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var returnValue:Boolean = true;
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(this.checkIfNeedsToCallServer(checkRetardedIf,e) == true)
         {
            return true;
         }
         switch(e.cmd)
         {
            case "NOTIFY_BOOKMARK_ALREADY_EXISTS":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  notification = notificationsMng.createNotificationSolarSystemBookmarkAlreadyExists();
                  e.msg = notification.getMessageBody();
                  e.title = notification.getMessageTitle();
                  notificationsMng.guiOpenNotificationMessage(notification);
               }
               else
               {
                  e.phase = "IN";
                  InstanceMng.getPopupMng().closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_BOOKMARK_MAXIMUM_REACHED":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  notification = notificationsMng.createNotificationSolarSystemBookmarksFull();
                  e.msg = notification.getMessageBody();
                  e.title = notification.getMessageTitle();
                  notificationsMng.guiOpenNotificationMessage(notification);
               }
               else
               {
                  e.phase = "IN";
                  InstanceMng.getPopupMng().closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "PopupPlanetOccupiedOptions":
            case "NOTIFY_STAR_SHOW_EMPTY_PLANET_POPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getMapViewGalaxy().openPopupActionsOnPlanet(e.planet,e.star,e.cmd == "PopupPlanetOccupiedOptions",e.doc);
               }
               break;
            case "NotifyErrorInfo":
               if(this.phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getNotificationsMng().errorFromServerOpenPopup(e);
               }
               break;
            case "NotifyAFKPopup":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getApplication().idleOpenPopup(e);
               }
               break;
            case "NotifyDamageProtectionWarning":
               if(this.phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getNotificationsMng().guiOpenColonyShieldWillBeLost(e);
               }
               else
               {
                  e.phase = "";
                  this.resetNotifyEvent(e);
                  closeInstantly = e.button == "EventYesButtonPressed";
                  InstanceMng.getUIFacade().closePopup(e.popup,null,closeInstantly);
                  if(e.notifyCantAttack)
                  {
                     InstanceMng.getApplication().cantAttackReasonAccepted(e.button == "EventYesButtonPressed");
                  }
                  else
                  {
                     switch(e.button)
                     {
                        case "EventCloseButtonPressed":
                        case "EventCancelButtonPressed":
                           break;
                        case "EventYesButtonPressed":
                           InstanceMng.getApplication().goToResumeRequest(false,false);
                     }
                  }
               }
               break;
            case "NotifyBuyMinerals":
               InstanceMng.getShopsDrawer().resourcesOpenBuyMineralsPopup();
               returnValue = true;
               break;
            case "NotifyBuyCoins":
               InstanceMng.getShopsDrawer().resourcesOpenBuyCoinsPopup();
               returnValue = true;
               break;
            case "NotifyLevelUp":
               if(this.phaseIsIN(e.phase) == true)
               {
                  (popup = InstanceMng.getLevelScoreDefMng().guiOpenLevelUpPopup(e)).setEvent(e);
                  if(Config.USE_SOUNDS)
                  {
                     SoundManager.getInstance().playSound("levelup.mp3",1,0,0,1);
                  }
                  InstanceMng.getBetMng().checkIfCanShowBetIcon();
                  e.phase = "OUT";
                  this.levelUpTransaction(e.level);
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                     case "EventCancelButtonPressed":
                     case "EventYesButtonPressed":
                        this.mPopupMngRef.closePopup(e.popup);
                        this.resetNotifyEvent(e);
                        break;
                     case "EVENT_ARROW_RIGHT_PRESSED":
                        this.mPopupMngRef.closePopup(e.popup,null,true);
                        (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_PASS_FRIENDS_LEVELUP_POPUP")).friendsPassed = e.friendsPassed;
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,false);
                  }
               }
               break;
            case "NOTIFY_PASS_FRIENDS_LEVELUP_POPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  popup = uiFacade.getPopupFactory().getFriendPassedInLevelUpPopup(e);
                  uiFacade.enqueuePopup(popup,false,false);
                  e.phase = "OUT";
               }
               else
               {
                  var _loc43_:* = e.button;
                  if("EventCloseButtonPressed" === _loc43_)
                  {
                     uiFacade.closePopup(e.popup);
                     this.resetNotifyEvent(e);
                  }
               }
               break;
            case "NotifyTutorialPopup":
            case "NotifyTutorialSpeechBubble":
               if(this.phaseIsIN(e.phase) == true)
               {
                  advisorId = String(e.advisorState);
                  advisorSize = int(e.advisorSize);
                  title = DCTextMng.stringTidToText(e.tutoPopupTitle);
                  buttonText = DCTextMng.stringTidToText(e.tutoPopupButtn);
                  sound = String(e.soundAttached);
                  useBubble = Boolean(e.isBubbleSpeech);
                  if(e.hasOwnProperty("openImmediately"))
                  {
                     openImmediately = Boolean(e.openImmediately);
                  }
                  else
                  {
                     openImmediately = true;
                  }
                  if(e.tutoPopupDescParams == null)
                  {
                     body = DCTextMng.stringTidToText(e.tutoPopupDesc);
                  }
                  else
                  {
                     body = DCTextMng.replaceParameters(TextIDs[e.tutoPopupDesc],e.tutoPopupDescParams);
                  }
                  vAlign = 2;
                  if(!useBubble)
                  {
                     vAlign = 0;
                  }
                  InstanceMng.getApplication().speechPopupOpen(advisorId,title,body,buttonText,sound,null,useBubble,false,advisorSize,vAlign,false,openImmediately);
                  e.phase = "OUT";
               }
               else
               {
                  _loc43_ = e.button;
                  if("EventYesButtonPressed" === _loc43_)
                  {
                     this.mPopupMngRef.closeCurrentPopup();
                  }
               }
               break;
            case "NOTIFY_BUY_ITEMS_WITH_PREMIUM_CURRENCY":
               if(e["button"] == "EventYesButtonPressed")
               {
                  if((trans = e["transaction"]) == null)
                  {
                     trans = InstanceMng.getRuleMng().getTransactionPack(e);
                  }
                  if(trans.performAllTransactions())
                  {
                     if((popup = InstanceMng.getPopupMng().getPopupBeingShown()) != null && popup is EBuyWorkerPopup)
                     {
                        EBuyWorkerPopup(popup).setupPopup(e["workerDef"]);
                     }
                     if(popup is EPopupInventory)
                     {
                        EPopupInventory(popup).resetStarCurrentTab();
                     }
                     if((itemObject = InstanceMng.getItemsMng().getItemObjectBySku(e.itemSku)) != null && itemObject.mDef.getUseNow())
                     {
                        InstanceMng.getItemsMng().useItemFromInventory(itemObject);
                     }
                     if(e.onBuy != null)
                     {
                        if(e.onBuyParams != null)
                        {
                           e.onBuy(e.onBuyParams);
                        }
                        else
                        {
                           e.onBuy();
                        }
                     }
                  }
               }
               else
               {
                  InstanceMng.getPopupMng().closeCurrentPopup(null);
               }
               break;
            case "NotifyCreateAlliance":
               if(e.button == "EventYesButtonPressed")
               {
                  if(e.transaction == null)
                  {
                     e.transaction = InstanceMng.getRuleMng().getTransactionPack(e);
                  }
                  e.transaction.performAllTransactions();
               }
               else
               {
                  InstanceMng.getPopupMng().closeCurrentPopup(null);
               }
               break;
            case "NotifyEditAlliance":
               if(e.button == "EventYesButtonPressed")
               {
                  if(e.transaction == null)
                  {
                     e.transaction = InstanceMng.getRuleMng().getTransactionPack(e);
                  }
                  e.transaction.performAllTransactions();
               }
               else
               {
                  InstanceMng.getPopupMng().closeCurrentPopup(null);
               }
               break;
            case "NotifyBuyGold":
               InstanceMng.getShopsDrawer().openChipsPopup();
               break;
            case "NotifyBuyCurrencyWithFB":
               if(e.button == "EventYesButtonPressed")
               {
                  InstanceMng.getShopsDrawer().resourcesNotifyPurchaseAccepted(e.optionId);
               }
               break;
            case "NOTIFY_ATTACK_DISTANCE":
               if(this.phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getUnitScene().preAttackOpenPopup(e);
               }
               else
               {
                  closePopupInstantly = false;
                  goToplanet = Boolean(e.goToPlanet);
                  continueToPlanetTransactionOK = false;
                  if(e.eventWhenSuccess == true)
                  {
                     continueToPlanetTransactionOK = this.goToAttackUniverse(e,false);
                     e.eventWhenSuccess = null;
                  }
                  else
                  {
                     DCDebug.traceChObject("CHRIS",e,"ATT.DISTANCE EV");
                     lockApplied = Boolean(e.lockApplied);
                     userInfo = UserInfo(e.userInfo);
                     if(lockApplied == false && this.mAttackWaitingForServerResponse == false)
                     {
                        if(userInfo.mIsNPC.value == false)
                        {
                           this.mAttackWaitingForServerResponse = true;
                           DCDebug.trace("SETTING mAttackWaitingForServerResponse to TRUE! ** lockApplied == false && mAttackWaitingForServerResponse == false");
                           if(InstanceMng.getApplication().lockUIIsLocked())
                           {
                              if((lockReason = InstanceMng.getApplication().lockUIGetReason()) == 0)
                              {
                                 DCDebug.traceCh("CHRIS","Unlocking UI");
                                 InstanceMng.getApplication().lockUIReset();
                              }
                           }
                           InstanceMng.getApplication().lockUIWaitForAttackAllowed();
                           InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK,{
                              "userId":e.goToRequestUserId,
                              "planetId":e.goToRequestPlanetId,
                              "applyLock":1
                           });
                           return true;
                        }
                        lockApplied = true;
                     }
                     if(goToplanet == false && lockApplied == true)
                     {
                        DCDebug.trace("SETTING mAttackWaitingForServerResponse to false! ** goToplanet == false && lockApplied == true");
                        this.mAttackWaitingForServerResponse = false;
                        continueToPlanetTransactionOK = this.goToAttackUniverse(e);
                     }
                  }
                  this.planetTransactionOK(continueToPlanetTransactionOK,goToplanet,e.goToRequestStarId,e.goToRequestStarName,e.goToRequestStarCoord);
                  e.phase = "";
               }
               break;
            case "NOTIFY_SHOW_SPY_CAPSULES_SHOP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getShopsDrawer().openBuySpyCapsulesPopup();
                  e.phase = "OUT";
               }
               break;
            case "NOTIFY_BUY_SPY_CAPSULES":
               if(e.button == "EventYesButtonPressed")
               {
                  if((transaction = e.transaction as Transaction) != null)
                  {
                     if(transaction.performAllTransactions() == true)
                     {
                        InstanceMng.getPopupMng().closePopup("PopupBuySpyCapsules");
                        sku = String(e.shopSku);
                        InstanceMng.getUserDataMng().updateMisc_spyCapsuleBought(sku,transaction);
                     }
                  }
               }
               break;
            case "NOTIFY_SHOW_SERVER_MAINTENANCE_INFO":
               InstanceMng.getNotificationsMng().guiOpenMessagePopup("NOTIFY_SHOW_SERVER_MAINTENANCE_INFO",DCTextMng.getText(3700),DCTextMng.replaceParameters(3701,[DCTextMng.convertTimeToStringColon(InstanceMng.getUserInfoMng().getProfileLogin().getMaintenanceEnabledTimestamp() - InstanceMng.getUserDataMng().getServerCurrentTimemillis())]),"builder_normal");
               break;
            case "NOTIFY_BUY_PURCHASE_ITEM":
               if(e.button == "EventYesButtonPressed")
               {
                  if((transaction = e.transaction as Transaction) != null)
                  {
                     transaction.performAllTransactions();
                  }
               }
               break;
            case "NotifyCraftingPending":
               if(this.phaseIsIN(e.phase))
               {
                  e.phase = "OUT";
                  popup = InstanceMng.getUIFacade().getPopupFactory().getCraftingPendingPopup(e);
                  InstanceMng.getUIFacade().enqueuePopup(popup);
               }
               else
               {
                  e.phase = "";
                  this.mPopupMngRef.closeCurrentPopup();
                  buttonSku = String(e.button);
                  switch(e.buttonLocationEvent)
                  {
                     case "EVENT_BUTTON_LEFT_PRESSED":
                        buttonSku = "fight_button";
                        break;
                     case "EVENT_BUTTON_RIGHT_PRESSED":
                        buttonSku = "craft_button";
                  }
                  switch(buttonSku)
                  {
                     case "fight_button":
                        if(e.notifyCantAttack)
                        {
                           InstanceMng.getApplication().cantAttackReasonAccepted(true);
                        }
                        else
                        {
                           InstanceMng.getApplication().goToResumeRequest(false,true);
                        }
                        break;
                     case "craft_button":
                        if(e.notifyCantAttack)
                        {
                           InstanceMng.getApplication().cantAttackReasonAccepted(false);
                        }
                        popup = InstanceMng.getItemsMng().guiOpenInventoryPopup("crafting");
                        InstanceMng.getGUIControllerPlanet().getToolBar().setStarInventoryVisible();
                  }
                  this.resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_UNIT_UPGRADED":
               if(e && e.itemDef as ShipDef)
               {
                  popup = InstanceMng.getGameUnitMngController().guiOpenUnitUpgradedPopup(e.itemDef,e.hasUnlocked);
                  if(Config.USE_SOUNDS)
                  {
                     SoundManager.getInstance().playSound("hurray.mp3",2,0,0,1);
                  }
               }
               break;
            case "NOTIFY_ALLIANCES_DECLARE_WAR":
               if(InstanceMng.getAlliancesController().getMyAlliance().isInAWar())
               {
                  e.alreadyAtWar = true;
               }
               AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenAllianceNotification(e);
               break;
            case "NOTIFY_ALLIANCES_CURRENT_WAR_WIN":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).openWarIsWonPopup(e["endByKO"],e["allianceName"]);
               break;
            case "NOTIFY_ALLIANCES_CURRENT_WAR_LOSE":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).openWarIsLostPopup(e["endByKO"]);
               break;
            case "NOTIFY_ALLIANCES_WELCOME_POPUP":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenAllianceNotification(e);
               break;
            case "NOTIFY_STAR_BUY_PLANET_POPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getShopsDrawer().openBuyColonyPopup(e);
               }
               else
               {
                  e.phase = "";
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                        this.mPopupMngRef.closePopup(e.popup);
                        break;
                     case "EventYesButtonPressed":
                        trans = InstanceMng.getRuleMng().getTransactionPack(e);
                        if((notification = InstanceMng.getGUIControllerSolarSystem().checkIfOperationIsPossible(e.planetDef as PlanetDef,trans)) != null)
                        {
                           this.mPopupMngRef.closePopup(e.cmd);
                           notificationsMng.guiOpenNotificationMessage(notification);
                           return false;
                        }
                        e.transaction = trans;
                        if(trans.performAllTransactions())
                        {
                           InstanceMng.getNotifyMng().addEvent(InstanceMng.getMapView(),e);
                        }
                        break;
                     case "EVENT_BUTTON_RIGHT_PRESSED":
                        this.mPopupMngRef.closePopup(e.cmd);
                        (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_STAR_MOVE_COLONY_POPUP")).newPlanetSku = e.newPlanetSku;
                        o.starType = e.starType;
                        o.starId = e.starId;
                        o.starName = e.starName;
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
                  }
               }
               returnValue = true;
               break;
            case "NOTIFY_STAR_COLONY_BOUGHT":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getShopsDrawer().openColonyBoughtPopup(e);
               }
               returnValue = true;
               break;
            case "NOTIFY_STAR_MOVE_COLONY_POPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getShopsDrawer().openSelectColonyPopup(e);
               }
               else
               {
                  e.phase = "";
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                        InstanceMng.getUIFacade().closePopup(e.popup);
                        break;
                     case "EventYesButtonPressed":
                        if((trans = e.transaction).performAllTransactions())
                        {
                           InstanceMng.getNotifyMng().addEvent(InstanceMng.getMapView(),e);
                        }
                  }
               }
               returnValue = true;
               break;
            case "NOTIFY_STAR_MOVE_COLONY_POPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  InstanceMng.getShopsDrawer().openColonyBoughtPopup(e);
               }
               returnValue = true;
               break;
            case "NOTIFY_SHOW_OFFER":
               if(this.phaseIsIN(e.phase))
               {
                  e.phase = "OUT";
                  InstanceMng.getNotificationsMng().guiOpenCreditCardPromoPopup(e);
               }
               else
               {
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_OPEN_GENERAL_INFO":
               if(this.phaseIsIN(e.phase))
               {
                  e.phase = "OUT";
                  InstanceMng.getNotificationsMng().guiOpenGeneralInfoPopup(e);
               }
               else
               {
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_OPEN_EPOPUP":
               if(this.phaseIsIN(e.phase) == true)
               {
                  this.mPopupMngRef.openPopup(e.popup,null,e.showAnim,e.showDarkBackground,e.closeOpenedPopup);
                  e.phase = "OUT";
               }
               else
               {
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningCountdown":
               if(this.phaseIsIN(e.phase) == true)
               {
                  happeningDef = e.happeningDef as HappeningDef;
                  e.happeningSku = happeningDef.mSku;
                  popupSkinDef = InstanceMng.getPopupSkinDefMng().getDefBySku(happeningDef.getPopupSkin()) as PopupSkinDef;
                  e.titles = happeningDef.getArrayCountdownInfoTitle();
                  e.bodies = happeningDef.getArrayCountdownInfoBody();
                  e.button = happeningDef.getTidCountdownInfoButton();
                  e.images = happeningDef.getArrayIllustrationsCountdownInfo();
                  switch(happeningDef.getType())
                  {
                     case "birthday":
                        break;
                     case "winter":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningStartEventPopup(null,e);
                        break;
                     case "waves":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningIntroStoryPopup(e.images[0],e.titles[0],e.bodies[0],e.button);
                  }
                  InstanceMng.getUIFacade().enqueuePopup(popup);
                  e.phase = "OUT";
               }
               else
               {
                  _loc43_ = e.button;
                  if("EventYesButtonPressed" === _loc43_)
                  {
                     this.mPopupMngRef.closePopup(e.popup);
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningStartIntro":
               InstanceMng.getHappeningMng().hudRemoveHappeningIcon();
               happeningDef = e.happeningDef as HappeningDef;
               e.cmd = "NotifyHappeningReadyToStart";
               switch(happeningDef.getType())
               {
                  case "birthday":
                     InstanceMng.getMapViewPlanet().introStart(0,this,e);
                     break;
                  case "winter":
                     InstanceMng.getNotifyMng().addEvent(this,e,true);
                     break;
                  case "waves":
                     InstanceMng.getMapViewPlanet().introStart(0,this,e);
               }
               break;
            case "NotifyHappeningReadyToStart":
               if(this.phaseIsIN(e.phase) == true)
               {
                  happeningDef = e.happeningDef as HappeningDef;
                  popupSkinDef = InstanceMng.getPopupSkinDefMng().getDefBySku(happeningDef.getPopupSkin()) as PopupSkinDef;
                  e.happeningSku = happeningDef.mSku;
                  e.titles = happeningDef.getArrayTextsStoryTitle();
                  e.bodies = happeningDef.getArrayTextsStoryBody();
                  e.images = happeningDef.getArrayIllustrationsStory();
                  switch(happeningDef.getType())
                  {
                     case "birthday":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningStartEventBirthdayPopup(happeningDef,e);
                        break;
                     case "winter":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningStartEventPopup(null,e);
                        break;
                     case "waves":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningStartEventPopup(null,e);
                  }
                  InstanceMng.getUIFacade().enqueuePopup(popup);
                  e.phase = "OUT";
               }
               else
               {
                  _loc43_ = e.button;
                  if("EventCloseButtonPressed" === _loc43_)
                  {
                     happeningDef = e.happeningDef as HappeningDef;
                     if(InstanceMng.getHappeningMng().getHappening(happeningDef.mSku).giveInitialKit())
                     {
                        switch(happeningDef.getType())
                        {
                           case "birthday":
                           case "winter":
                              break;
                           case "waves":
                              InstanceMng.getHappeningMng().guiOpenHappeningInitialKitPopup(happeningDef);
                        }
                     }
                     this.mPopupMngRef.closePopup(e.popup);
                     InstanceMng.getHappeningMng().getHappening(happeningDef.mSku).stateChangeState(2,true);
                  }
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningEnterRunning":
               InstanceMng.getMapViewPlanet().happeningsShowHappening(e.happeningSku,true);
               break;
            case "NotifyHappeningExitRunning":
               InstanceMng.getMapViewPlanet().happeningsShowHappening(e.happeningSku,false);
               break;
            case "NotifyHappeningTypeWaveCountdown":
               if(this.phaseIsIN(e.phase) == true)
               {
                  switch((happeningDef = InstanceMng.getHappeningDefMng().getDefBySku(e.happeningSku) as HappeningDef).getType())
                  {
                     case "birthday":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningStartEventBirthdayPopup(happeningDef,e);
                        InstanceMng.getUIFacade().enqueuePopup(popup);
                        break;
                     case "winter":
                        popup = InstanceMng.getUIFacade().getPopupFactory().getHappeningGiftProgressPopup(happeningDef,e);
                        InstanceMng.getUIFacade().enqueuePopup(popup);
                        break;
                     case "waves":
                        InstanceMng.getHappeningMng().guiOpenHappeningAntiZombieKitPopup(happeningDef);
                  }
                  e.phase = "OUT";
               }
               else
               {
                  _loc43_ = e.button;
                  if("EventCloseButtonPressed" === _loc43_)
                  {
                     this.mPopupMngRef.closePopup(e.popup);
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningTypeWaveSpeedUp":
               if(e.button == "EventYesButtonPressed")
               {
                  if((transaction = e.transaction as Transaction) != null)
                  {
                     if(transaction.performAllTransactions() == true)
                     {
                        this.mPopupMngRef.closePopup("PopupHappeningShop");
                        HappeningTypeWave(InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType()).speedUpWave(e.transaction,e.timeLeft);
                     }
                  }
               }
               break;
            case "NotifyHappeningTypeWaveReadyToStart":
               if(InstanceMng.getBuildingsBufferController().isBufferOpen())
               {
                  InstanceMng.getUIFacade().getBuildingsBufferBar().closeBufferBar();
                  InstanceMng.getTopHudFacade().getHudElement("btn_contest").setIsEnabled(true);
               }
               if(this.phaseIsIN(e.phase) == true)
               {
                  happeningDef = InstanceMng.getHappeningDefMng().getDefBySku(e.happeningSku) as HappeningDef;
                  happening = InstanceMng.getHappeningMng().getHappening(happeningDef.mSku);
                  switch(happeningDef.getType())
                  {
                     case "birthday":
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType().stateChangeState(2,true);
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType().stateChangeState(3,true);
                        break;
                     case "winter":
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType().stateChangeState(2,true);
                        break;
                     case "waves":
                        InstanceMng.getHappeningMng().guiOpenHappeningReadyToStartPopup(happening,e);
                  }
                  e.phase = "OUT";
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventYesButtonPressed":
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType().stateChangeState(2,true);
                        break;
                     case "EventCancelButtonPressed":
                        (InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType() as HappeningTypeWave).delayWave();
                        break;
                     case "EVENT_BUTTON_LEFT_PRESSED":
                        (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningShowSkipHappening")).happeningDef = InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningDef();
                        event.happeningTypeDef = e.happeningTypeDef;
                        event.boxEnemyName = (e.happeningTypeDef as HappeningTypeWaveDef).getBoxEnemyName();
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningTypeWaveCompleted":
               if(this.phaseIsIN(e.phase) == true)
               {
                  switch((happening = InstanceMng.getHappeningMng().getHappening(e.happeningSku)).getHappeningDef().getType())
                  {
                     case "birthday":
                        break;
                     case "winter":
                        e.phase = "OUT";
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),e,true);
                        break;
                     case "waves":
                        InstanceMng.getHappeningMng().guiOpenHappeningWaveResultPopup(happening,e);
                  }
                  e.phase = "OUT";
               }
               else
               {
                  _loc43_ = e.button;
                  if("EventYesButtonPressed" !== _loc43_)
                  {
                  }
                  if((happeningTypeWave = e.happeningTypeWave as HappeningTypeWave).processNextStateAndIsHappeningCompletedOrExpired() == false)
                  {
                     this.notifyWaveCompleted();
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningShowSkipHappening":
               if(this.phaseIsIN(e.phase) == true)
               {
                  happeningDef = e.happeningDef as HappeningDef;
                  e.happeningSku = e.happeningDef.mSku;
                  happening = InstanceMng.getHappeningMng().getHappening(e.happeningSku);
                  InstanceMng.getHappeningMng().guiOpenHappeningSkipHappeningPopup(happening,e);
                  e.phase = "OUT";
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventYesButtonPressed":
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).restart();
                        break;
                     case "EventCancelButtonPressed":
                     case "EventCloseButtonPressed":
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).getHappeningType().stateChangeState(2,true);
                  }
                  this.mPopupMngRef.closePopup(e.popup);
                  this.resetNotifyEvent(e);
               }
               break;
            case "NotifyHappeningShowFinalReward":
               if(this.phaseIsIN(e.phase) == true)
               {
                  happeningDef = e.happeningDef as HappeningDef;
                  e.happeningSku = happeningDef.mSku;
                  switch((happening = InstanceMng.getHappeningMng().getHappening(e.happeningSku)).getHappeningDef().getType())
                  {
                     case "birthday":
                     case "winter":
                        break;
                     case "waves":
                        InstanceMng.getHappeningMng().guiOpenHappeningEndEventPopup(happening,e);
                  }
                  e.phase = "OUT";
               }
               else
               {
                  close = true;
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                        this.mPopupMngRef.closePopup(e.popup);
                        break;
                     case "EventYesButtonPressed":
                        this.mPopupMngRef.closePopup(e.popup);
                        InstanceMng.getHappeningMng().getHappening(e.happeningSku).restart();
                        break;
                     case "EVENT_BUTTON_LEFT_PRESSED":
                        close = false;
                  }
                  if(close)
                  {
                     this.notifyWaveCompleted();
                     this.resetNotifyEvent(e);
                  }
               }
               break;
            case "NotifyBetShowMyResults":
               if(Config.useBets())
               {
                  if(this.phaseIsIN(e.phase) == true)
                  {
                     InstanceMng.getBetMng().confirmMyBattleIsOver();
                  }
               }
               break;
            default:
               returnValue = false;
         }
         return returnValue;
      }
      
      private function goToAttackUniverse(e:Object, performTransaction:Boolean = true) : Boolean
      {
         var notification:Notification = null;
         var mineralCost:Number = NaN;
         var popupMng:PopupMng = null;
         var loadedProfile:Profile = null;
         var uInfo:UserInfo = null;
         var accIdAttacked:String = null;
         var continueToPlanetTransactionOk:Boolean = true;
         var profile:Profile;
         var attackingPlanet:Planet = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj().getPlanetById(profile.getCurrentPlanetId());
         var t:Transaction = null;
         var userInfo:UserInfo;
         var isPayingNPC:Boolean = (userInfo = UserInfo(e.userInfo)) != null && userInfo.mIsNPC.value && userInfo.getAttackCostPercentage() != 0;
         if(userInfo != null && !userInfo.mIsNPC.value || isPayingNPC)
         {
            if(attackingPlanet != null && e.goToRequestPlanetSku != null)
            {
               mineralCost = InstanceMng.getRuleMng().getAttackDistanceMineralCost(attackingPlanet.getSku(),e.goToRequestPlanetSku);
               if(isPayingNPC)
               {
                  mineralCost = InstanceMng.getRuleMng().getAmountDependingOnCapacity(userInfo.getAttackCostPercentage(),false);
               }
               (t = InstanceMng.getRuleMng().createSingleTransaction(true,0,0,mineralCost)).setTransInfoPackage(e);
               e.transaction = t;
               e.sendResponseTo = this;
            }
            if(performTransaction)
            {
               continueToPlanetTransactionOk = false;
               if(t != null)
               {
                  if((notification = InstanceMng.getRuleMng().getNotificationFromTransaction(t)) != null)
                  {
                     popupMng = InstanceMng.getPopupMng();
                     popupMng.closePopup(e.cmd);
                     InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notification);
                  }
                  else if(t.performAllTransactions() == true)
                  {
                     continueToPlanetTransactionOk = true;
                  }
               }
            }
         }
         if(continueToPlanetTransactionOk)
         {
            FlowState.mVisitTransaction = t;
         }
         else if((uInfo = (loadedProfile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()) != null ? loadedProfile.getUserInfoObj() : null) != null)
         {
            InstanceMng.getApplication().goToSetCurrentDestinationInfo(loadedProfile.getCurrentPlanetId(),uInfo);
            accIdAttacked = String(e.goToRequestUserId);
            notification = InstanceMng.getRuleMng().getNotificationFromTransaction(t);
            if(accIdAttacked != null && notification != null && uInfo.mIsNPC.value == false)
            {
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_FREE_LOCKED_ATTACK,{"userId":accIdAttacked});
            }
         }
         return continueToPlanetTransactionOk;
      }
      
      protected function notifyWarEvent(e:Object) : Boolean
      {
         var numUnits:int = 0;
         var toolId:int = 0;
         var toolsMng:ToolsMng = null;
         var currentToolId:int = 0;
         var retValue:Boolean = true;
         var _loc7_:* = e.cmd;
         if("NOTIFY_WAR_NUM_UNITS_UPDATE" !== _loc7_)
         {
            DCDebug.trace("!!!! WAR EVENT " + e.cmd + " NOT FOUND !!!!");
            retValue = false;
         }
         else
         {
            numUnits = int(e.unitAmount);
            currentToolId = (toolsMng = InstanceMng.getToolsMng()).getCurrentToolId();
            if(numUnits > 0)
            {
               toolsMng.setToolWarCircle(e.unitSku);
            }
            else
            {
               toolId = 0;
               if(currentToolId != toolId)
               {
                  InstanceMng.getToolsMng().setTool(toolId);
               }
            }
         }
         return retValue;
      }
      
      protected function sendBackEvent(e:Object) : void
      {
         if(e != null && e.sendResponseTo != null)
         {
            InstanceMng.getNotifyMng().addEvent(e.sendResponseTo,e,true);
         }
      }
      
      public function createNotifyEvent(type:*, cmd:*, sendResponseTo:DCComponent = null, itemObject:WorldItemObject = null, param:Object = null, target:DCComponent = null, itemDef:DCDef = null, transaction:Transaction = null) : Object
      {
         var o:Object;
         (o = {}).type = type;
         o.cmd = cmd;
         o.phase = "";
         if(sendResponseTo != null)
         {
            o.sendResponseTo = sendResponseTo;
         }
         if(itemObject != null)
         {
            o.item = itemObject;
         }
         if(param != null)
         {
            o.param = param;
         }
         if(target != null)
         {
            o.target = target;
         }
         if(itemDef != null)
         {
            o.itemDef = itemDef;
         }
         if(transaction != null)
         {
            o.transaction = transaction;
         }
         return o;
      }
      
      public function resetNotifyEvent(e:Object) : void
      {
         if(e != null)
         {
            e.phase = "";
            if(e.item != null)
            {
               e.item.resume();
            }
         }
      }
      
      public function checkIfOperationIsPossible(def:DCDef, trans:Transaction, isUpgradingOp:Boolean = false, isPremiumOp:Boolean = false, checkSiloCapacity:Boolean = true) : Notification
      {
         var levelRequired:int = 0;
         var shipDef:ShipDef = null;
         var userHasItemNeeded:* = false;
         var previousDef:ShipDef = null;
         var returnValue:Notification = null;
         var hqLevel:Number = InstanceMng.getWorld().itemsGetHeadquarters().mDef.getUpgradeId();
         var labLevel:int = InstanceMng.getWorld().itemsGetLabLevel();
         var planetsAmount:int = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount();
         var profileLogin:Profile;
         var maxCoinsCapacity:Number = (profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()).getCoinsCapacity();
         var maxMineralsCapacity:Number = profileLogin.getMineralsCapacity();
         var needsItem:Boolean = false;
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(def != null)
         {
            if((trans.getTransInfoPackage() != null && trans.getTransInfoPackage().cmd == "NOTIFY_SHIPYARD_BUY") == false)
            {
               if(def is ShipDef)
               {
                  needsItem = (shipDef = def as ShipDef).needsItemForUnlocking();
               }
               userHasItemNeeded = false;
               if(needsItem)
               {
                  if(userHasItemNeeded = InstanceMng.getItemsMng().getItemObjectBySku(shipDef.getUnlockItemSkuRequired()).quantity > 0)
                  {
                     previousDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(shipDef.mSku,shipDef.getUpgradeId() - 1) as ShipDef;
                     levelRequired = this.getLevelRequiredByItemDef(previousDef,isUpgradingOp);
                  }
               }
               else
               {
                  levelRequired = this.getLevelRequiredByItemDef(def,isUpgradingOp);
               }
               if(def is ShipDef && InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(def.mSku).mIsUnlocked == true)
               {
                  if(labLevel < levelRequired)
                  {
                     return notificationsMng.createNotificationNotEnoughLaboratoryLevel("labs_001_001",levelRequired + 1);
                  }
                  if(needsItem && userHasItemNeeded == false)
                  {
                     return notificationsMng.createNotificationAllianceRewardNeeded();
                  }
               }
               else if(def is WorldItemDef && (def as WorldItemDef).isHeadQuarters() == true)
               {
                  if(planetsAmount < levelRequired && !isPremiumOp)
                  {
                     return notificationsMng.createNotificationNumColoniesRequired(levelRequired);
                  }
               }
               else if(hqLevel < levelRequired)
               {
                  return notificationsMng.createNotificationNotEnoughHQLevel("wonders_headquarters",levelRequired + 1);
               }
            }
            if(trans != null && checkSiloCapacity)
            {
               if(maxCoinsCapacity < Math.abs(trans.getTransCoins()))
               {
                  returnValue = notificationsMng.createNotificationNotEnoughRoomInBanks();
               }
               if(maxMineralsCapacity < Math.abs(trans.getTransMinerals()))
               {
                  returnValue = notificationsMng.createNotificationNotEnoughRoomInSilos();
               }
            }
            else
            {
               returnValue = notificationsMng.createNotificationNullTransaction();
               DCDebug.trace(returnValue.getMessageBody(),1);
            }
         }
         else
         {
            returnValue = notificationsMng.createNotificationNullWIO();
            DCDebug.trace(returnValue.getMessageBody(),1);
         }
         return returnValue;
      }
      
      public function getLevelRequiredByItemDef(def:DCDef, isUpgradingOp:Boolean = false) : int
      {
         var returnValue:int = 0;
         var itemDefinition:UnitDef = null;
         var planetsAmount:int = 0;
         if(def is UnitDef)
         {
            if((itemDefinition = def as UnitDef) is ShipDef)
            {
               returnValue = itemDefinition.getUnlockHQUpgradeIdRequired();
            }
            else if(isUpgradingOp == true)
            {
               returnValue = itemDefinition.getUnlockHQUpgradeIdRequired();
            }
            else
            {
               returnValue = itemDefinition.getLevel();
            }
         }
         else if(def is PlanetDef)
         {
            returnValue = int(PlanetDef(def).getBuyRequirement());
            if((planetsAmount = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount()) >= 12)
            {
               returnValue = -1;
            }
         }
         return returnValue;
      }
      
      private function zoomBegin() : void
      {
         this.mZoomSign = 0;
         this.mZoomCurrent = 100;
         this.mZoomTarget = 100;
         InstanceMng.getUserInfoMng().getProfileLogin().getZoom();
      }
      
      private function zoomLogicUpdate(dt:int) : void
      {
         if(this.mZoomTarget != this.mZoomCurrent)
         {
            this.mZoomCurrent += 5 * this.mZoomSign;
            InstanceMng.getMapView().onZoomMove(this.mZoomCurrent / 100);
            if(this.mZoomSign > 0 && this.mZoomCurrent >= this.mZoomTarget || this.mZoomSign < 0 && this.mZoomCurrent <= this.mZoomTarget)
            {
               this.mZoomSign = 0;
               this.mZoomCurrent = this.mZoomTarget;
            }
         }
      }
      
      public function zoomGet() : int
      {
         return this.mZoomCurrent;
      }
      
      protected function zoomSet(value:Number) : void
      {
         this.onZoomMove(value);
         if(this.mZoomTarget != this.mZoomCurrent)
         {
            InstanceMng.getMapView().onZoomMove(value);
            this.mZoomSign = 0;
            this.mZoomCurrent = this.mZoomTarget;
         }
      }
      
      public function setZoomFromBarValue(value:int, doAnimation:Boolean = false) : void
      {
         if(doAnimation)
         {
            this.onZoomMove((zoomBarValueToRealValue(value) - this.mZoomCurrent) / 100);
         }
         else
         {
            this.onZoomSet(zoomBarValueToRealValue(value));
         }
      }
      
      public function getZoomBarValue() : int
      {
         return zoomRealValueToBarValue(this.mZoomCurrent);
      }
      
      private function resetProfileLastVars() : void
      {
         this.mProfileLastPlayerName = "";
         this.mProfileLastWorldName = "";
         this.mProfileLastCoins = -1;
         this.mProfileLastCash = -1;
         this.mProfileLastMinerals = -1;
         this.mProfileLastMaxMineralAmount = -1;
         this.mProfileLastMaxCoinsAmount = -1;
         this.mProfileLastDroids = -1;
         this.mProfileLastMaxDroidsAmount = -1;
         this.mProfileLastXp = -1;
         this.mProfileLastScore = -1;
         this.mProfileLastLevel = -1;
      }
      
      protected function hasPlayerNameChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudPlayerNameProfileIdAllowed() && this.mProfileLastPlayerName != profile.getPlayerName();
      }
      
      protected function haveCoinsChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudCoinsProfileIdAllowed() && this.mProfileLastCoins != profile.getCoins();
      }
      
      protected function hasCashChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudCashProfileIdAllowed() && this.mProfileLastCash != profile.getCash();
      }
      
      protected function haveMineralsChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudMineralsProfileIdAllowed() && this.mProfileLastMinerals != profile.getMinerals();
      }
      
      protected function hasMaxMineralAmountChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudMaxMineralsProfileIdAllowed() && this.mProfileLastMaxMineralAmount != profile.getMineralsCapacity();
      }
      
      protected function hasMaxCoinsAmountChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudMaxCoinsProfileIdAllowed() && this.mProfileLastMaxCoinsAmount != profile.getCoinsCapacity();
      }
      
      protected function haveDroidsChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudDroidsProfileIdAllowed() && this.mProfileLastDroids != profile.getDroids();
      }
      
      protected function hasMaxDroidsAmountChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudMaxDroidsProfileIdAllowed() && this.mProfileLastMaxDroidsAmount != profile.getMaxDroidsAmount();
      }
      
      public function hasLevelChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudLevelProfileIdAllowed() && this.mProfileLastLevel != profile.getLevel();
      }
      
      protected function hasXpChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudXpProfileIdAllowed() && this.mProfileLastXp != profile.getXp();
      }
      
      protected function hasScoreChanged(profile:Profile) : Boolean
      {
         return profile.getId() == InstanceMng.getRole().hudScoreProfileIdAllowed() && this.mProfileLastScore != profile.getScore();
      }
      
      public function lockGUI(element:* = null) : void
      {
         var c:DCComponentUI = null;
         this.mFullLocked = true;
         for each(c in mChildren)
         {
            c.uiDisable(true);
            c.lock();
            c.removeMouseEvents();
         }
         if(element == null)
         {
            return;
         }
         if(element is DCComponentUI)
         {
            DCComponentUI(element).unlock(element);
            DCComponentUI(element).uiEnable();
            return;
         }
      }
      
      public function canUnlockGUI(component:DCComponentUI = null) : Boolean
      {
         var kidnapping:Boolean = InstanceMng.getTutorialKidnapMng() != null && InstanceMng.getTutorialKidnapMng().hasEnded() == false;
         return kidnapping == false;
      }
      
      public function unlockGUI(component:DCComponentUI = null) : void
      {
         var c:DCComponentUI = null;
         var sku:String = null;
         this.mFullLocked = false;
         for each(c in mChildren)
         {
            c.unlock();
            c.addMouseEvents();
         }
         if(component != null)
         {
            sku = component.getParentRef();
         }
         else if(InstanceMng.getPopupMng().getPopupBeingShown() == null && this.mCurrentFocusSku != null)
         {
            sku = this.mCurrentFocusSku;
         }
         if(sku != null)
         {
            this.giveFocus(sku);
         }
      }
      
      public function unlockSingleGUIElem(component:DCComponentUI, exception:Object = null, gainFocus:Boolean = false) : void
      {
         var c:DCComponentUI = null;
         this.mFullLocked = false;
         for each(c in mChildren)
         {
            if(c == component)
            {
               c.unlock(exception);
               c.addMouseEvents();
               if(gainFocus)
               {
                  this.giveFocus(component.getParentRef());
               }
            }
         }
      }
      
      public function isSpotlightOn() : Boolean
      {
         return this.mSpotlightOn;
      }
      
      public function isFullLocked() : Boolean
      {
         return this.mFullLocked;
      }
      
      protected function phaseIsIN(value:String) : Boolean
      {
         return value == "IN" || value == null || value == "";
      }
      
      public function openPVPMap() : void
      {
         var cmd:String = "NOTIFY_MAP_OPEN";
         var o:Object = InstanceMng.getGUIController().createNotifyEvent(null,cmd);
         this.notify(o);
      }
      
      private function levelUpTransaction(levelNum:int) : void
      {
         var rewardCoins:int = 0;
         var rewardMinerals:int = 0;
         var rewardChips:int = 0;
         var amount:int = 0;
         var REWARD_PACK_VALUE:int = 1000;
         var profile:Profile = null;
         var level:String = levelNum.toString();
         var levelScoreDef:LevelScoreDef;
         if((levelScoreDef = InstanceMng.getLevelScoreDefMng().getDefBySku(level) as LevelScoreDef) != null)
         {
            rewardCoins = levelScoreDef.getRewardCoins();
            rewardMinerals = levelScoreDef.getRewardMinerals();
            rewardChips = levelScoreDef.getRewardChips();
         }
         var transaction:Transaction = InstanceMng.getRuleMng().createSingleTransaction(false,rewardChips,rewardCoins,rewardMinerals);
         profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(rewardCoins > 0 && rewardCoins + profile.getCoins() > profile.getCoinsCapacity())
         {
            amount = rewardCoins / REWARD_PACK_VALUE;
            (transaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,0,0,0)).addTransItem("5003",amount,false);
         }
         else if(rewardMinerals > 0 && rewardMinerals + profile.getMinerals() > profile.getMineralsCapacity())
         {
            amount = rewardMinerals / REWARD_PACK_VALUE;
            (transaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,0,0,0)).addTransItem("5004",amount,false);
         }
         if(transaction != null)
         {
            transaction.performAllTransactions();
            InstanceMng.getUserDataMng().updateProfile_levelUp(levelNum,transaction);
         }
      }
      
      public function getGameQuality() : String
      {
         return smQuality;
      }
      
      private function planetTransactionOK(continueToPlanetTransactionOK:Boolean = false, goToPlanet:Boolean = false, starId:Number = -1, starName:String = null, starCoord:DCCoordinate = null) : void
      {
         var closePopupInstantly:Boolean = false;
         if(continueToPlanetTransactionOK == true)
         {
            goToPlanet = true;
            closePopupInstantly = true;
         }
         InstanceMng.getPopupMng().closeCurrentPopup(null,closePopupInstantly);
         if(goToPlanet)
         {
            InstanceMng.getApplication().changePlanet(starId,starName,starCoord);
            InstanceMng.getTargetMng().updateProgress("goingToAttackButtonClicked",1);
         }
         else
         {
            FlowState.mVisitTransaction = null;
         }
      }
      
      public function getIsAttackWaitingForServerResponse() : Boolean
      {
         return this.mAttackWaitingForServerResponse;
      }
      
      public function notifyWaveCompleted() : void
      {
         InstanceMng.getUnitScene().battleFinishNpcAttack();
      }
      
      protected function guiGetViewSku() : String
      {
         return null;
      }
      
      public function guiOpenNewPayerPromoPopupFromPromoParams(sku:String, rewardId:int) : DCIPopup
      {
         var o:Object = null;
         var reward:String = null;
         var entry:Entry = null;
         var rewardSku:String = null;
         var item:ItemsDef = null;
         var returnValue:DCIPopup = null;
         var newPayerPromoDef:NewPayerPromoDef;
         if((newPayerPromoDef = InstanceMng.getNewPayerPromoDefMng().getDefBySku(sku) as NewPayerPromoDef) != null && rewardId >= 0)
         {
            (o = this.createNotifyEvent("EventPopup","NOTIFY_SHOW_OFFER")).offerFromHUD = false;
            o.idxReward = rewardId;
            if(newPayerPromoDef)
            {
               o.newPayerPromoDef = newPayerPromoDef;
               reward = newPayerPromoDef.getReward(o.idxReward);
               entry = EntryFactory.createSingleEntryFromString(reward);
               rewardSku = String(reward.split(":")[0]);
               o.nameItemToGive = DCTextMng.getText(TextIDs[newPayerPromoDef.getTIDReward(o.idxReward)]);
               o.numItemToGive = reward.split(":")[1];
               if(entry.getKey() == "items")
               {
                  item = InstanceMng.getItemsDefMng().getDefBySku(rewardSku) as ItemsDef;
                  o.itemFilename = item.getAssetId();
                  o.entry = item.mSku + ":" + o.numItemToGive;
               }
               else
               {
                  o.entry = rewardSku + ":" + o.numItemToGive;
                  o.itemFilename = EntryFactory.getResourceIdFromEntrySku(rewardSku);
               }
               o.origin = "HQ Upgrade";
               o.numItemToGive = DCTextMng.convertNumberToString(Number(o.numItemToGive),-1,-1);
            }
            InstanceMng.getUserInfoMng().getProfileLogin().setShowOfferNewPayerPromo(false);
            o.phase = "OUT";
            returnValue = InstanceMng.getNotificationsMng().guiOpenCreditCardPromoPopup(o);
         }
         return returnValue;
      }
      
      public function guiOpenNewPayerPromoPopupFromWIODef(nextDef:WorldItemDef) : DCIPopup
      {
         var newPayerPromoDef:NewPayerPromoDef = null;
         var idxReward:int = 0;
         var returnValue:DCIPopup = null;
         if(nextDef != null)
         {
            if(newPayerPromoDef = InstanceMng.getNewPayerPromoDefMng().getCurrPromoDef())
            {
               idxReward = InstanceMng.getNewPayerPromoDefMng().areThereMissingItems(nextDef);
               returnValue = this.guiOpenNewPayerPromoPopupFromPromoParams(newPayerPromoDef.mSku,idxReward);
            }
         }
         return returnValue;
      }
   }
}
