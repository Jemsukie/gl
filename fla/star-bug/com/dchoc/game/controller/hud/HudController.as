package com.dchoc.game.controller.hud
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.model.flow.FlowStatePlanet;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.target.TargetDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.advertising.DCAdsManager;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.utils.Dictionary;
   
   public class HudController extends DCComponentUI implements INotifyReceiver
   {
       
      
      private var mCurrentRoleId:int;
      
      private var mShowVideoAd:Boolean;
      
      private var mCanUpdateHappeningIcon:Boolean = false;
      
      public function HudController(hudRef:TopHudFacade)
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         MessageCenter.getInstance().registerObject(this);
         buildAdvanceSyncStep();
         this.mCurrentRoleId = InstanceMng.getFlowState().getCurrentRoleId();
      }
      
      override protected function unbuildDo() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         var roleId:int = InstanceMng.getRole().mId;
         var viewId:int = InstanceMng.getApplication().viewGetMode();
         if(viewId == 2)
         {
            InstanceMng.getTopHudFacade().setGalaxyMapHUD();
            InstanceMng.getUIFacade().getNavigationBarFacade().setNavigationButtonVisibility("button_solar_system",false);
            InstanceMng.getUIFacade().getNavigationBarFacade().setNavigationButtonVisibility("button_planet",false);
         }
         else if(viewId == 1)
         {
            InstanceMng.getTopHudFacade().setStarHUD();
            InstanceMng.getUIFacade().getNavigationBarFacade().setNavigationButtonVisibility("button_planet",false);
         }
         else if(viewId == 0 && roleId == 1)
         {
            InstanceMng.getTopHudFacade().setVisitingHUD(true);
         }
         else if(viewId == 0 && roleId == 2)
         {
            InstanceMng.getTopHudFacade().setSpyingHUD();
         }
         else if(viewId == 0 && roleId == 3)
         {
            InstanceMng.getTopHudFacade().setAttackingHUD();
         }
         else if(viewId == 0 && roleId == 7)
         {
            InstanceMng.getTopHudFacade().setReplayHUD();
         }
         else
         {
            InstanceMng.getTopHudFacade().setNormalHUD();
         }
         if(InstanceMng.getFlowState() is FlowStatePlanet)
         {
            if(InstanceMng.getRole().hasToShowMissions())
            {
               InstanceMng.getMissionsMng().showBackMissionsInHud();
            }
         }
         this.mCanUpdateHappeningIcon = this.mCurrentRoleId == 0 && InstanceMng.getApplication().isTutorialCompleted();
         this.missionsBegin();
         MessageCenter.getInstance().sendMessage("queryShopProgressBlink");
         InstanceMng.getUIFacade().alliancesUpdateStarButtons();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var showIcon:Boolean = false;
         if(this.mShowVideoAd)
         {
            showIcon = DCAdsManager.getInstance().isTheGameReadyForAnAd();
            InstanceMng.getTopHudFacade().setVideoAdButtonVisible(showIcon);
         }
         var showFreeOffers:Boolean = InstanceMng.getSettingsDefMng().mSettingsDef.getShowFreeOffers();
         var useOffers:Boolean = Config.useOfferInHUD();
         var newPayerPromo:Boolean = InstanceMng.getUserInfoMng().getProfileLogin().getShowOfferNewPayerPromo();
         var tutoEnd:Boolean = InstanceMng.getApplication().isTutorialCompleted();
         var battleRunning:Boolean = InstanceMng.getUnitScene().battleIsRunning();
         InstanceMng.getTopHudFacade().setOfferWallButtonVisible(tutoEnd && battleRunning == false && (showFreeOffers || useOffers && newPayerPromo));
         InstanceMng.getTopHudFacade().setChipsOfferTimerVisible(InstanceMng.getCustomizerMng().needsOfferToShowTimer());
         InstanceMng.getTopHudFacade().setServerMaintenanceTimerVisible(InstanceMng.getUserInfoMng().getProfileLogin().getMaintenanceEnabledTimestamp() > InstanceMng.getUserDataMng().getServerCurrentTimemillis());
         if(InstanceMng.getContestMng().needsToShowIcon())
         {
            InstanceMng.getUIFacade().showContestIcon();
         }
         if(InstanceMng.getHappeningMng().getHappeningInHudSku() && this.mCanUpdateHappeningIcon)
         {
            InstanceMng.getUIFacade().showHappeningIcon();
         }
         InstanceMng.getUIFacade().updateWarBars();
      }
      
      public function getName() : String
      {
         return "HudController";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["openCoinsShop","openMineralsShop","openDroidsShop","openPremiumShop","openChipsShop","openContestToolPopup","openHappeningPopup","videoRemoveIcon","hideShopbar","hideShipbar","hideBufferbar","hudMissionClicked","videoAdsClicked","offerWallClicked","videoReady","hudBuildButtonClicked","hudBuildingBufferClicked","hudToolButtonClicked","hudSettingButtonClicked","hudAlliancesClicked","hudQuickAttackClicked","hudBettingClicked","hudBuyCapsulesClicked","hudServerMaintenanceCountdownClicked","hudSpyClicked","hudAttackClicked","hudRetireButtonClicked","hudShopBarInfoClicked","hudShopBarButtonClicked","hudShipyardBarButtonClicked","hudShipyardBarUnlockClicked","hudShipyardBarSpeedupClicked","hudShipyardBarInfoClicked","hudShipyardBarCloseClicked","hudShipyardBarTrainingSpeedupClicked","hudShipyardBarTrainingBuySlotClicked","warBarUnitClicked","warBarUnitSelectedUpdate","replaySpeedChanged","friendBoxClicked","friendBoxAttackClicked","friendBoxWishlistClicked","buyTimeButtonClicked","deleteBookmarkedStar","gotoBookmarkedStar","openDailyReward","openSocialMedia","hudOptionsMenuClicked"];
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         var o:Object = null;
         var userInfo:UserInfo = null;
         var planetId:String = null;
         var planetSku:String = null;
         var shipDef:ShipDef = null;
         var gameUnit:GameUnit = null;
         var notifyCashToCoinsObj:Object = null;
         var notifyCashToMineralsObj:Object = null;
         var notificationToSend:Object = null;
         var starId:Number = NaN;
         var starName:String = null;
         var starCoord:DCCoordinate = null;
         var accountId:String = null;
         var accountIdAttack:String = null;
         var item:ItemObject = null;
         var def:WorldItemDef = null;
         var eventCmd:String = null;
         var isLocked:Boolean = false;
         var shipyard:Shipyard = null;
         var planet:Planet = null;
         var capital:Planet = null;
         var planetIdAttack:String = null;
         var planetSkuAttack:String = null;
         var planetAttack:Planet = null;
         var capitalAttack:Planet = null;
         var obj:Object = null;
         var notificationsMng:NotificationsMng = null;
         var notification:Notification = null;
         var soundMng:SoundManager = null;
         var profile:Profile = null;
         switch(cmd)
         {
            case "openPremiumShop":
               InstanceMng.getApplication().shopControllerOpenPopup("premium",!!params ? params["tab"] : null,false);
               break;
            case "openCoinsShop":
               notifyCashToCoinsObj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyBuyCoins",this,null);
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),notifyCashToCoinsObj);
               break;
            case "openMineralsShop":
               notifyCashToMineralsObj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyBuyMinerals",this,null);
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),notifyCashToMineralsObj);
               break;
            case "openDroidsShop":
               notificationToSend = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_DROIDS_BUY",this,null);
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),notificationToSend);
               break;
            case "openChipsShop":
               InstanceMng.getShopsDrawer().openChipsPopup();
               break;
            case "openContestToolPopup":
               InstanceMng.getContestMng().hudOnClickContestIcon(null);
               break;
            case "openHappeningPopup":
               InstanceMng.getHappeningMng().guiOpenHalloweenPopup();
               break;
            case "hudMissionClicked":
               this.onMissionClicked(params["sku"]);
               break;
            case "hideShopbar":
               o = {};
               o.cmd = "NOTIFY_CLOSESHOP";
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
               break;
            case "hideBufferbar":
               InstanceMng.getWorld().toggleAllRangePreviews(true);
               o = {};
               o.cmd = "NOTIFY_CLOSEBUFFER";
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
               break;
            case "hideShipbar":
               o = {};
               o.cmd = "NOTIFY_CLOSESHIPYARD";
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
               break;
            case "hudSpyClicked":
            case "hudAttackClicked":
               userInfo = InstanceMng.getUserInfoMng().getUserToVisit();
               planetId = InstanceMng.getApplication().goToGetCurrentPlanetId();
               planetSku = InstanceMng.getApplication().goToGetRequestPlanetSku();
               starId = InstanceMng.getApplication().goToGetCurrentStarId();
               starName = InstanceMng.getApplication().goToGetCurrentStarName();
               starCoord = InstanceMng.getApplication().goToGetCurrentStarCoors();
               planet = userInfo.getPlanetById(planetId);
               if(cmd == "hudSpyClicked")
               {
                  InstanceMng.getApplication().requestPlanet(userInfo.mAccountId,planetId,2,planetSku,true,true,true,starId,starName,starCoord,planet);
               }
               else
               {
                  InstanceMng.getApplication().attackRequest(userInfo.mAccountId,planetId,0,true,true,planetSku,starId,starName,starCoord,planet);
               }
               break;
            case "hudQuickAttackClicked":
               InstanceMng.getApplication().quickAttack();
               break;
            case "hudBettingClicked":
               InstanceMng.getBetMng().notifyClickBetIcon();
               break;
            case "hudAlliancesClicked":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).openPopupDependingOnSituation();
               InstanceMng.getUIFacade().alliancesUpdateStarButtons();
               break;
            case "hudBuildButtonClicked":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_OPENSHOP");
               o.toolType = "button_shop";
               o.shoptype = !!params ? params["tab"] + "_button" : null;
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudBuildingBufferClicked":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_BBOPEN");
               o.toolType = "button_move";
               o.shoptype = "BB";
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudSettingButtonClicked":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_OPTIONSCLICK");
               o.optionType = params["name"];
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudOptionsMenuClicked":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_OPTIONS_EXPANDED");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudToolButtonClicked":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_TOOLCHANGE");
               o.toolType = params["name"];
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudBuyCapsulesClicked":
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_SHOW_SPY_CAPSULES_SHOP");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
               break;
            case "hudServerMaintenanceCountdownClicked":
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_SHOW_SERVER_MAINTENANCE_INFO");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
               break;
            case "hudRetireButtonClicked":
               profile = InstanceMng.getUserInfoMng().getProfileLogin();
               if(profile.getConfirmEndBattle() && InstanceMng.getFlowState().getCurrentRoleId() != 7)
               {
                  InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmEndBattle",DCTextMng.getText(3063),DCTextMng.getText(3978),"captain_normal",DCTextMng.getText(1),null,function():void
                  {
                     InstanceMng.getUnitScene().battleFinish();
                  },null);
               }
               else
               {
                  InstanceMng.getUnitScene().battleFinish();
               }
               break;
            case "friendBoxClicked":
               accountId = String(params["accountId"]);
               if(accountId == InstanceMng.getUserInfoMng().getProfileLogin().getAccountId())
               {
                  if(InstanceMng.getFlowState().getCurrentRoleId() != 0 || InstanceMng.getApplication().viewGetMode() != 0)
                  {
                     InstanceMng.getApplication().goToHomePlanet();
                  }
               }
               else
               {
                  userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(params["accountId"],0);
                  if(userInfo.mIsNPC.value)
                  {
                     planet = userInfo.getCapital();
                     planetId = String(planet != null ? planet.getPlanetId() : null);
                     planetSku = String(planet != null ? planet.getSku() : null);
                     InstanceMng.getApplication().requestPlanet(userInfo.mAccountId,planetId,1,planetSku);
                  }
                  else
                  {
                     capital = InstanceMng.getUserInfoMng().getCapitalByAccountId(userInfo.mAccountId);
                     InstanceMng.getApplication().requestPlanet(userInfo.mAccountId,capital.getPlanetId(),1,capital.getSku());
                  }
               }
               break;
            case "friendBoxAttackClicked":
               accountIdAttack = String(params["accountId"]);
               if(accountIdAttack == InstanceMng.getUserInfoMng().getProfileLogin().getAccountId())
               {
                  InstanceMng.getApplication().goToHomePlanet();
               }
               else
               {
                  userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(params["accountId"],0);
                  planetIdAttack = null;
                  planetSkuAttack = null;
                  if(userInfo.mIsNPC.value)
                  {
                     planetAttack = userInfo.getCapital();
                     if(planetAttack != null)
                     {
                        planetIdAttack = planetAttack.getPlanetId();
                        planetSkuAttack = planetAttack.getSku();
                     }
                  }
                  else
                  {
                     capitalAttack = InstanceMng.getUserInfoMng().getCapitalByAccountId(userInfo.mAccountId);
                     planetIdAttack = capitalAttack.getPlanetId();
                     planetSkuAttack = capitalAttack.getSku();
                  }
                  InstanceMng.getApplication().attackRequest(userInfo.mAccountId,planetIdAttack,0,true,true,planetSkuAttack);
               }
               break;
            case "friendBoxWishlistClicked":
               userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(params["friendAccountId"],0);
               item = InstanceMng.getItemsMng().getItemObjectBySku(params["itemSku"]);
               InstanceMng.getApplication().setSendingWishlistItem(userInfo.mAccountId + item.mDef.mSku,true);
               InstanceMng.getItemsMng().sendItemToNeighbor(item.mDef.mSku,userInfo.mAccountId);
               break;
            case "buyTimeButtonClicked":
               InstanceMng.getGUIControllerPlanet().getWarBar().nextBuyBattleTimePack();
               InstanceMng.getUnitScene().attacksPaySpecialAttack(params["sku"],0,0,true,false);
               break;
            case "hudShipyardBarInfoClicked":
            case "hudShopBarInfoClicked":
               if(InstanceMng.getFlowStatePlanet().isTutorialRunning() == false)
               {
                  obj = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyUnitInfoPopup");
                  obj.sku = params["sku"];
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),obj);
               }
               break;
            case "hudShopBarButtonClicked":
               def = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(params["sku"],0);
               isLocked = InstanceMng.getWorldItemDefMng().checkIsLocked(def);
               if(isLocked)
               {
                  eventCmd = "WIOEventUpgradeStart";
                  o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(1,eventCmd,InstanceMng.getGUIControllerPlanet());
                  o["isLocked"] = true;
                  o["itemDef"] = def as WorldItemDef;
               }
               else
               {
                  eventCmd = "NOTIFY_SHOP_BUY";
                  o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(2,eventCmd,InstanceMng.getWorldItemObjectController(),null,null,null,def);
               }
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
               break;
            case "hudShipyardBarButtonClicked":
               gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(params["sku"]);
               shipDef = gameUnit.mDef;
               shipyard = InstanceMng.getShipyardController().getCurrentShipyard();
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(2,"NOTIFY_SHIPYARD_BUY",InstanceMng.getGUIController());
               o.constructionCost = shipDef.getConstructionCoins();
               o.constructionMineral = shipDef.getConstructionMineral();
               o.xp = shipDef.getExperience();
               o.itemSku = params["sku"];
               o.constructionTime = shipDef.getConstructionTime();
               o.iconInfo = (shipDef as ShipDef).getIcon();
               o.shipyardId = InstanceMng.getShipyardController().getCurrentShipyard().getId();
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "hudShipyardBarUnlockClicked":
               shipDef = InstanceMng.getShipyardController().getShipInfoByUnitSku(params["sku"]) as ShipDef;
               if(InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit() == null)
               {
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),ShipyardController.createUnlockObject(shipDef,InstanceMng.getShipyardController().getCurrentShipyard()));
               }
               else
               {
                  notificationsMng = InstanceMng.getNotificationsMng();
                  notification = notificationsMng.createNotificationOnlyOneUnitCanBeActivatedSimultaneously();
                  notificationsMng.guiOpenNotificationMessage(notification);
               }
               break;
            case "hudShipyardBarSpeedupClicked":
               shipDef = InstanceMng.getShipyardController().getShipInfoByUnitSku(params["sku"]) as ShipDef;
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),ShipyardController.createUnlockingObject(shipDef,InstanceMng.getShipyardController().getCurrentShipyard()));
               break;
            case "hudShipyardBarCloseClicked":
               gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(params["sku"]);
               InstanceMng.getGameUnitMngController().getGameUnitMngOwner().cancelCurrentAction(gameUnit);
               break;
            case "hudShipyardBarTrainingSpeedupClicked":
               this.onTrainingSpeedUpClick();
               break;
            case "hudShipyardBarTrainingBuySlotClicked":
               InstanceMng.getShipyardController().shipyardQueuedElementUnlock(params["slotId"]);
               break;
            case "replaySpeedChanged":
               InstanceMng.getUnitScene().setReplaySpeed(params["newAmount"]);
               break;
            case "warBarUnitSelectedUpdate":
            case "warBarUnitClicked":
               if(params["selected"])
               {
                  o = InstanceMng.getGUIController().createNotifyEvent(5,"NOTIFY_WAR_TOOL_SETUP");
                  InstanceMng.getTargetMng().updateProgress("shipsSelectedForBattle",1);
               }
               else
               {
                  o = InstanceMng.getGUIController().createNotifyEvent(5,"NOTIFY_WAR_TOOL_UNSETUP");
               }
               o.unitSku = params["unitSku"];
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "videoReady":
            case "videoRemoveIcon":
               if("enable" in params)
               {
                  this.mShowVideoAd = true;
               }
               break;
            case "deleteBookmarkedStar":
               InstanceMng.getMapView().deleteBookmark(params["coords"]);
               break;
            case "gotoBookmarkedStar":
               InstanceMng.getMapViewGalaxy().centerCameraByStarCoords(params["coords"],true);
               break;
            case "openDailyReward":
               InstanceMng.getDailyRewardMng().openDailyRewardPopup();
               break;
            case "openSocialMedia":
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_OPEN_GENERAL_INFO");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,false);
               break;
            case "videoAdsClicked":
               if(Config.USE_SOUNDS)
               {
                  soundMng = SoundManager.getInstance();
                  profile = InstanceMng.getUserInfoMng().getProfileLogin();
                  if(profile.getMusic())
                  {
                     soundMng.setMusicOn(false,true);
                  }
                  if(profile.getSound())
                  {
                     soundMng.setSfxOn(false,true);
                  }
               }
               this.mShowVideoAd = false;
               DCAdsManager.getInstance().callVideoAd(null);
               break;
            case "offerWallClicked":
               if(!(Config.useOfferInHUD() && InstanceMng.getUserInfoMng().getProfileLogin().getShowOfferNewPayerPromo()))
               {
                  if(InstanceMng.getSettingsDefMng().mSettingsDef.getShowFreeOffers())
                  {
                     InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OFFER_CREDITS);
                  }
               }
         }
      }
      
      private function missionsBegin() : void
      {
         var missionSkus:Array = null;
         var missionState:int = 0;
         var missionSku:String = null;
         var targetDef:TargetDef = null;
         var missionStates:Array = [1,2];
         for each(missionState in missionStates)
         {
            missionSkus = InstanceMng.getMissionsMng().getMissionsByState(missionState);
            for each(missionSku in missionSkus)
            {
               targetDef = InstanceMng.getTargetDefMng().getDefBySku(missionSku) as TargetDef;
               if(!targetDef.getHiddenInHud())
               {
                  InstanceMng.getTopHudFacade().missionsChangeState(missionSku,missionState,false);
               }
            }
         }
      }
      
      private function onMissionClicked(sku:String) : void
      {
         if(!sku || sku == "")
         {
            return;
         }
         var missionTarget:DCTarget = InstanceMng.getTargetMng().getTargetById(sku);
         var state:int = InstanceMng.getTargetMng().getTargetStateById(sku);
         var showMissionPopupEvent:Object = {};
         InstanceMng.getApplication().lastClickSetLabel("clickMission");
         showMissionPopupEvent.item = missionTarget;
         var introMovie:String = missionTarget.getDef().getIntroMovie();
         if(state == 1 && introMovie != null)
         {
            showMissionPopupEvent.type = "EVENT_SHOW_ANIM";
         }
         else
         {
            showMissionPopupEvent.type = "EVENT_SHOW_POPUP";
         }
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getMissionsMng(),showMissionPopupEvent,true);
         if(state == 1)
         {
            missionTarget.changeState(state + 1);
         }
      }
      
      private function onTrainingSpeedUpClick() : void
      {
         var notificationMng:NotificationsMng = null;
         var notification:Notification = null;
         var transaction:Transaction = null;
         var shipyardController:ShipyardController = InstanceMng.getShipyardController();
         var o:Object = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_POPUP_OPEN_SPEEDQUEUE");
         shipyardController.getCurrentShipyard().getSpeedUpQueueObject(o);
         if(o.elementsSkus == "")
         {
            notificationMng = InstanceMng.getNotificationsMng();
            if(o.failMotive == "inactiveState")
            {
               notification = notificationMng.createNotificationUnitFactorySpeedUpQueueEmpty();
            }
            else if(o.failMotive == "noHangar")
            {
               notification = notificationMng.createNotificationUnitFactorySpeedUpNoHangar();
            }
            if(notification != null)
            {
               notificationMng.guiOpenNotificationMessage(notification);
            }
            return;
         }
         o.elementsSkus = o.elementsSkus.slice(0,o.elementsSkus.length - 1);
         o.shipyardId = shipyardController.getCurrentShipyard().getId();
         o.sendResponseTo = shipyardController;
         o.item = shipyardController.getCurrentShipyard();
         if(o.failMotive != "noHangar")
         {
            o.phase = "OUT";
            o.buttonLocationEvent = "EVENT_BUTTON_LEFT_PRESSED";
            o.button = "EventYesButtonPressed";
            transaction = InstanceMng.getRuleMng().getTransactionSpeedUpQueue(o);
            o.transaction = transaction;
         }
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
      }
   }
}
