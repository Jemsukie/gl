package com.dchoc.game.controller.gui
{
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.hangar.HangarController;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.controller.shop.BuildingsShopController;
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.eview.facade.BuildingBufferFacade;
   import com.dchoc.game.eview.facade.ShipyardBarFacade;
   import com.dchoc.game.eview.facade.ShopBarFacade;
   import com.dchoc.game.eview.facade.ToolBarFacade;
   import com.dchoc.game.eview.facade.WarBarFacade;
   import com.dchoc.game.eview.facade.WarBarSpecialFacade;
   import com.dchoc.game.eview.popups.ERefineryPopup;
   import com.dchoc.game.eview.popups.embassy.EPopupEmbassy;
   import com.dchoc.game.eview.popups.hangar.EPopupHangar;
   import com.dchoc.game.eview.popups.hangar.EPopupHangarEmpty;
   import com.dchoc.game.eview.popups.missions.EPopupMissionTargetBox;
   import com.dchoc.game.eview.popups.upgrade.EPopupUpgrade;
   import com.dchoc.game.eview.widgets.hud.EHudMissionDropDownSprite;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.game.view.dc.gui.components.ShipyardQueuedElement;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.facade.CursorFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.component.DCIComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   import esparragon.display.ESprite;
   import esparragon.utils.EUtils;
   import flash.display.Shape;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class GUIControllerPlanet extends GUIController
   {
      
      private static const NAME_CHILDREN_MAP:String = "map";
      
      private static const CHILDS_SKUS_FOCUS_PRIORITIES:Array = ["navigationbar","toolbar","friendsbar","shopbar","bufferbar","shipyardBar","warbar","hud","mapPlanet"];
      
      public static const NOTIFY_SHOP_CLOSE:String = "NOTIFY_CLOSESHOP";
      
      public static const NOTIFY_BUFFER_CLOSE:String = "NOTIFY_CLOSEBUFFER";
      
      public static const NOTIFY_SHOP_OPEN:String = "NOTIFY_OPENSHOP";
      
      public static const NOTIFY_BUILDING_BUFFER_OPEN:String = "NOTIFY_BBOPEN";
      
      public static const NOTIFY_TOOLCHANGE:String = "NOTIFY_TOOLCHANGE";
      
      public static const NOTIFY_STARTROADS:String = "NOTIFY_STARTROADS";
      
      public static const NOTIFY_SHIPYARD_BUY:String = "NOTIFY_SHIPYARD_BUY";
      
      public static const NOTIFY_SHIPYARD_QUEUEADVANCE_ASK:String = "NOTIFY_SHIPYARD_QUEUEADVANCE_ASK";
      
      public static const NOTIFY_SHIPYARD_QUEUEADVANCE:String = "NOTIFY_SHIPYARD_QUEUEADVANCE";
      
      public static const NOTIFY_SHIPYARD_QUEUEUPDATE:String = "NOTIFY_SHIPYARD_QUEUEUPDATE";
      
      public static const NOTIFY_SHIPYARD_STARTPRODUCING:String = "NOTIFY_SHIPYARD_STARTPRODUCING";
      
      public static const NOTIFY_SHIPYARD_INTERACT:String = "NOTIFY_INTERACTSHIPYARD";
      
      public static const NOTIFY_SHIPYARD_CLOSE:String = "NOTIFY_CLOSESHIPYARD";
      
      public static const NOTIFY_HANGAR_INFO:String = "NotifyHangarInfo";
      
      public static const NOTIFY_HANGAR_AVAILABLE:String = "NOTIFY_HANGAR_AVAILABLE";
      
      public static const NOTIFY_HANGAR_NONE_AVAILABLE:String = "NOTIFY_HANGAR_NONE_AVAILABLE";
      
      public static const NOTIFY_OPEN_TOOL:String = "NOTIFY_OPEN_TOOL";
      
      public static const NOTIFY_CANCEL_TOOL:String = "NOTIFY_CANCEL_TOOL";
      
      public static const NOTIFY_MAP_SCROLLEND:String = "NOTIFY_MAP_SCROLLEND";
      
      public static const NOTIFY_ALL_CHILDS_BEGUN:String = "NOTIFY_ALL_CHILDS_BEGUN";
      
      public static const NOTIFY_INSTANT_BUILD:String = "NotifyInstantBuild";
      
      public static const NOTIFY_INSTANT_UPGRADE:String = "NotifyInstantUpgrade";
      
      public static const NOTIFY_RECYCLE:String = "NotifyRecycle";
      
      public static const NOTIFY_UNLOCK_SHIP_SLOT:String = "NotifyUnlockShipSlot";
      
      public static const NOTIFY_CHANGEFOCUS_MAP:String = "NOTIFY_CHANGEFOCUS_MAP";
      
      public static const NOTIFY_MODIFY_CURRENT_DROID_TASK:String = "NOTIFY_MODIFY_CURRENT_DROID_TASK";
      
      public static const NOTIFY_OPEN_START_REPAIRS_POPUP:String = "NOTIFY_OPEN_START_REPAIRS_POPUP";
      
      public static const NOTIFY_POPUP_OPEN_SPEEDITEM:String = "NOTIFY_POPUP_OPEN_SPEEDITEM";
      
      public static const NOTIFY_POPUP_OPEN_SPEEDQUEUE:String = "NOTIFY_POPUP_OPEN_SPEEDQUEUE";
      
      public static const NOTIFY_POPUP_OPEN_BUNKER:String = "NOTIFY_POPUP_OPEN_BUNKER";
      
      public static const NOTIFY_POPUP_OPEN_LABS:String = "NOTIFY_POPUP_OPEN_LABS";
      
      public static const NOTIFY_POPUP_OPEN_REFINERY:String = "NOTIFY_POPUP_OPEN_REFINERY";
      
      public static const NOTIFY_POPUP_OPEN_EMBASSY:String = "NOTIFY_POPUP_OPEN_EMBASSY";
      
      public static const NOTIFY_POPUP_OPEN_PVP_MAP:String = "NOTIFY_POPUP_OPEN_PVP_MAP";
      
      public static const NOTIFY_UNIT_INFO_POPUP:String = "NotifyUnitInfoPopup";
      
      public static const NOTIFY_POPUP_OPEN_AMOUNT_FAIL:String = "NOTIFY_POPUP_OPEN_AMOUNT_FAIL";
      
      public static const NOTIFY_TRANSFER_UNITS_TO_BUNKER:String = "NotifyTransferUnitsToBunker";
      
      public static const NOTIFY_RESOURCES_REFUNDED:String = "NOTIFY_RESOURCES_REFUNDED";
      
      public static const NOTIFY_SHOP_BUY:String = "NOTIFY_SHOP_BUY";
      
      public static const NOTIFY_BUY_DROID_WITH_PREMIUM_CURRENCY:String = "NOTIFY_BUY_DROID_WITH_PREMIUM_CURRENCY";
      
      public static const NOTIFY_MISSION_INFO:String = "NotifyMissionInfo";
      
      public static const NOTIFY_MISSION_PROGRESS:String = "NotifyMissionProgress";
      
      public static const NOTIFY_MISSION_EXPIRED:String = "NotifyMissionExpired";
      
      public static const NOTIFY_SKIP_TARGET_WITH_FB:String = "NOTIFY_SKIP_TARGET_WITH_FB";
      
      public static const NOTIFY_ATTACK_TO_NPC_RESULT:String = "NotifyAttackToNPCResult";
      
      public static const NOTIFY_DROIDS_CREATE_A_DROID_IN_HQ:String = "NotifyDroidsCreateADroidInHQ";
      
      public static const NOTIFY_MERCENARIES_MISSION_COMPLETED:String = "NotifyMercenariesMissionCompleted";
      
      private static const DEPLOY_TIME_ID:int = 0;
      
      private static const DEPLOY_SKU_ID:int = 1;
      
      private static const DEPLOY_Y_ID:int = 2;
      
      private static const DEPLOY_X_ID:int = 3;
       
      
      private var mBuildingName:String;
      
      private var mMissionName:String;
      
      private var mDeploys:Vector.<Array>;
      
      private var mDeploysElapsedTime:Number;
      
      private var mDeployLastUnitSkuDeployed:String;
      
      public function GUIControllerPlanet()
      {
         super();
      }
      
      public function getBuildingName() : String
      {
         return this.mBuildingName;
      }
      
      public function setBuildingName(value:String) : void
      {
         this.mBuildingName = value;
      }
      
      public function getMissionName() : String
      {
         return this.mMissionName;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var currentRole:int = 0;
         super.buildDoSyncStep(step);
         if(step == 0 && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt())
         {
            currentRole = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
            InstanceMng.getHangarControllerMng().changeProfileDependingOnRole(currentRole);
            InstanceMng.getGameUnitMngController().changeProfileDependingOnRole(currentRole);
            if(currentRole == 3)
            {
               this.loadWarBar();
            }
            else if(currentRole != 1)
            {
               if(currentRole == 2)
               {
               }
            }
            mMapViewLimitBottomDO = new Shape();
            buildAdvanceSyncStep();
         }
      }
      
      override public function unbuild(mode:int = 0) : void
      {
         super.unbuild(mode);
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         super.childrenUnbuildMode(mode);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         InstanceMng.getMapView().fadeUpdate(dt);
         this.focusLogicUpdate(dt);
      }
      
      public function openShopBar(shop:String = null) : void
      {
         mCurrentBarState = 1;
         if(!this.getShopBar().isVisible())
         {
            this.hideOpenedBar();
            InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_cursor");
         }
         this.showShopBar(shop);
      }
      
      public function openBuildingBufferBar(shop:String = null) : void
      {
         mCurrentBarState = 1;
         if(!this.getBufferBar().isVisible())
         {
            this.hideOpenedBar();
         }
         this.showBufferBar(shop);
      }
      
      override public function hideOpenedBar() : void
      {
         super.hideOpenedBar();
         if(this.getShipyardBar().isVisible())
         {
            this.hideShipyardBar();
         }
         if(this.getShopBar().isVisible())
         {
            this.hideShopBar();
         }
         if(this.getBufferBar().isVisible())
         {
            this.hideBufferBar();
         }
         getToolBar().hideToolbarExtended();
      }
      
      public function closeShopBar() : void
      {
         mCurrentBarState = 0;
         showFriendsBar();
         this.hideShopBar();
         InstanceMng.getRuleMng().shopRefreshNews();
      }
      
      public function closeBufferBar() : void
      {
         mCurrentBarState = 0;
         showFriendsBar();
         this.hideBufferBar();
         InstanceMng.getRuleMng().shopRefreshNews();
      }
      
      private function showShopBar(shop:String = null) : void
      {
         var shopController:BuildingsShopController = InstanceMng.getBuildingsShopController();
         var shopBar:ShopBarFacade = this.getShopBar();
         if(!shopController.isShopOpen())
         {
            shopController.setShopOpen(true);
            shopBar.moveAppearDownToUp(0.5);
         }
         if(shop == null || shop == "BB")
         {
            shop = InstanceMng.getBuildingsShopController().getShopTab();
         }
         shopBar.changeShop(shop,true);
      }
      
      private function hideShopBar() : void
      {
         this.getShopBar().moveDisappearUpToDown();
         InstanceMng.getBuildingsShopController().setShopOpen(false);
      }
      
      private function showBufferBar(shop:String = null) : void
      {
         InstanceMng.getVisitorMng().friendsBoxesHide();
         InstanceMng.getTrafficMng().mUnitScene.fadeCivils();
         var bufferBarController:BuildingsBufferController = InstanceMng.getBuildingsBufferController();
         var bufferBar:BuildingBufferFacade = this.getBufferBar();
         InstanceMng.getHangarControllerMng().getHangarController().battlePrepareUnitsInHangars();
         InstanceMng.getTopHudFacade().getHudElement("btn_missions").setIsEnabled(false);
         (InstanceMng.getTopHudFacade().getHudElement("area_missions") as EHudMissionDropDownSprite).disable();
         if((InstanceMng.getTopHudFacade().getHudElement("area_missions") as EHudMissionDropDownSprite).isOpen())
         {
            (InstanceMng.getTopHudFacade().getHudElement("area_missions") as EHudMissionDropDownSprite).close(true);
         }
         InstanceMng.getTopHudFacade().getHudElement("notification_area").setIsEnabled(false);
         var contestBtn:ESprite = InstanceMng.getTopHudFacade().getHudElement("btn_contest");
         if(contestBtn)
         {
            contestBtn.setIsEnabled(false);
         }
         if(!bufferBarController.isBufferOpen())
         {
            bufferBarController.setBufferOpen(true);
            bufferBar.moveAppearDownToUp(0.5);
         }
         bufferBar.loadShop();
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_move_buffer");
      }
      
      private function hideBufferBar() : void
      {
         InstanceMng.getVisitorMng().friendsBoxesShow();
         this.getBufferBar().moveDisappearUpToDown();
         InstanceMng.getBuildingsBufferController().setBufferOpen(false);
         InstanceMng.getHangarControllerMng().getHangarController().battleRestoreUnitsInHangarsAfterBattle();
         InstanceMng.getTopHudFacade().getHudElement("btn_missions").setIsEnabled(true);
         (InstanceMng.getTopHudFacade().getHudElement("area_missions") as EHudMissionDropDownSprite).enable();
         InstanceMng.getTopHudFacade().getHudElement("notification_area").setIsEnabled(true);
         var contestBtn:ESprite = InstanceMng.getTopHudFacade().getHudElement("btn_contest");
         if(contestBtn)
         {
            contestBtn.setIsEnabled(true);
         }
         InstanceMng.getMapViewPlanet().resetBorderResolution();
      }
      
      public function openPreviousShipyard() : void
      {
         var sc:ShipyardController = InstanceMng.getShipyardController();
         var currentId:String = sc.getCurrentShipyard().getId();
         var id:String = sc.getPreviousShipyardId();
         while(sc.getShipyard(id).getWorldItemObject().isUpgrading() && id != currentId)
         {
            id = sc.getPreviousShipyardId(id);
         }
         if(id !== currentId)
         {
            this.openShipyard(id);
         }
      }
      
      public function openNextShipyard() : void
      {
         var sc:ShipyardController = InstanceMng.getShipyardController();
         var currentId:String = sc.getCurrentShipyard().getId();
         var id:String = sc.getNextShipyardId();
         while(sc.getShipyard(id).getWorldItemObject().isUpgrading() && id != currentId)
         {
            id = sc.getNextShipyardId(id);
         }
         if(id !== currentId)
         {
            this.openShipyard(id);
         }
      }
      
      public function openShipyard(shipyardId:String) : void
      {
         if(this.getShipyardBar().IsTransitioning && !this.getShipyardBar().isVisible())
         {
            return;
         }
         var shipyardController:ShipyardController;
         var shipyardToOpen:Shipyard = (shipyardController = InstanceMng.getShipyardController()).getShipyard(shipyardId);
         var shipyardOpened:Shipyard = shipyardController.getCurrentShipyard();
         if(shipyardToOpen == shipyardOpened)
         {
            this.closeShipyard();
            return;
         }
         if(shipyardOpened != null)
         {
            shipyardOpened.getWorldItemObject().viewSetSelected(false,0,true,true);
         }
         shipyardController.setCurrentShipyard(shipyardId);
         this.getShipyardBar().openShipyardBar();
         this.getShipyardBar().setVisibleWarningBox(shipyardToOpen.isProductionPaused());
         this.getShipyardBar().moveAppearDownToUp();
         if(mCurrentBarState == 0)
         {
            hideFriendsBar();
         }
         else if(mCurrentBarState == 1)
         {
            this.hideShopBar();
         }
      }
      
      private function hideShipyardBar() : void
      {
         InstanceMng.getShipyardController().removeCurrentShipyard();
         this.getShipyardBar().moveDisappearUpToDown();
      }
      
      public function closeShipyard() : void
      {
         if(this.getShipyardBar().IsTransitioning && this.getShipyardBar().isVisible())
         {
            return;
         }
         this.hideShipyardBar();
         if(mCurrentBarState == 0)
         {
            showFriendsBar();
         }
         else if(mCurrentBarState == 1)
         {
            this.showShopBar();
         }
      }
      
      public function shopBuy(itemSku:String, transactionPack:Transaction = null, isGift:Boolean = false) : void
      {
         var notificationToSend:Object = null;
         var toolBar:ToolBarFacade = getToolBar();
         if(this.getShopBar().isVisible())
         {
            this.closeShopBar();
         }
         toolBar.hideToolbarExtended();
         var keepPlacing:Boolean = true;
         InstanceMng.getToolsMng().setToolPlaceItem(itemSku,transactionPack,keepPlacing);
      }
      
      public function shipyardQueueAdvance(shipyardId:String) : void
      {
         InstanceMng.getShipyardController().queueAdvance(shipyardId);
      }
      
      public function shipyardQueueAddShip(itemSku:String, constructionTime:Number) : int
      {
         return InstanceMng.getShipyardController().queueAddShip(itemSku,constructionTime);
      }
      
      public function endAttack() : void
      {
         InstanceMng.getTopHudFacade().battleLockMenuClockButtons();
         InstanceMng.getUnitScene().deployUnitsReset();
         InstanceMng.getToolsMng().setTool(0);
         this.getWarBar().reset();
         this.getWarBar().lock();
         this.getWarBar().setVisible(false);
         this.getWarBarSpecial().lock();
         this.getWarBarSpecial().setVisible(false);
         InstanceMng.getUnitScene().setReplaySpeed(1);
      }
      
      public function startNPCAttack() : void
      {
         InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(false,true);
         InstanceMng.getToolsMng().getCurrentTool().itemSelectedSetIsAllowed(false,false);
         InstanceMng.getUIFacade().blackStripsShow(true);
         InstanceMng.getTopHudFacade().setWarHUD(true);
         showHud();
         SoundManager.getInstance().stopAll(true);
         var music:String = InstanceMng.getUnitScene().battleGetMusic();
         SoundManager.getInstance().playSound(music,1,0,-1,0);
      }
      
      public function startReplay() : void
      {
         InstanceMng.getUIFacade().blackStripsShow(false);
         SoundManager.getInstance().stopAll(true);
         var music:String = InstanceMng.getUnitScene().battleGetMusic();
         SoundManager.getInstance().playSound(music,1,0,-1,0);
      }
      
      public function endReplay() : void
      {
         InstanceMng.getTrafficMng().droidsGetOutHQ();
         InstanceMng.getUIFacade().blackStripsHide();
         SoundManager.getInstance().stopAll(true);
         SoundManager.getInstance().playSound("music_main.mp3",1,0,-1,0);
         InstanceMng.getUnitScene().setReplaySpeed(1);
      }
      
      public function endNPCAttack() : void
      {
         InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(true,true);
         InstanceMng.getToolsMng().getCurrentTool().itemSelectedSetIsAllowed(true,true);
         InstanceMng.getTrafficMng().droidsGetOutHQ();
         InstanceMng.getUIFacade().blackStripsHide();
         InstanceMng.getTopHudFacade().setNormalHUD();
         SoundManager.getInstance().stopAll(true);
         SoundManager.getInstance().playSound("music_main.mp3",1,0,-1,0);
      }
      
      override protected function getSpecificMapViewSku() : String
      {
         return "mapPlanet";
      }
      
      public function loadWarBar() : void
      {
         this.getWarBar().setVisible(true);
         if(InstanceMng.getApplication().isTutorialCompleted())
         {
            this.getWarBarSpecial().setVisible(true);
         }
      }
      
      public function warbarPerformedAttack(barFullness:int) : void
      {
         var warbar:WarBarFacade = this.getWarBar();
         warbar.addFillBarCurrentAmount(barFullness);
         warbar.updateElements();
      }
      
      override public function getComponentByName(name:String) : DCIComponent
      {
         var returnValue:DCIComponent = super.getComponentByName(name);
         if(returnValue != null)
         {
            return returnValue;
         }
         var _loc3_:* = name;
         if("map" !== _loc3_)
         {
            return InstanceMng.getUIFacade().viewsGetUiElementBySkuAndViewSku(name,this.guiGetViewSku());
         }
         return InstanceMng.getMapViewPlanet();
      }
      
      public function getShipyardBar() : ShipyardBarFacade
      {
         return InstanceMng.getUIFacade().getShipyardBar();
      }
      
      public function getShopBar() : ShopBarFacade
      {
         return InstanceMng.getUIFacade().getBuildingsShopBar();
      }
      
      public function getBufferBar() : BuildingBufferFacade
      {
         return InstanceMng.getUIFacade().getBuildingsBufferBar();
      }
      
      public function getWarBar() : WarBarFacade
      {
         return InstanceMng.getUIFacade().getWarBar();
      }
      
      public function getWarBarSpecial() : WarBarSpecialFacade
      {
         return InstanceMng.getUIFacade().getWarBarSpecial();
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var found:Boolean = false;
         switch(int(e.keyCode) - 113)
         {
            case 0:
               InstanceMng.getTargetDefMng().skipTutorial();
               InstanceMng.getGUIController().unlockGUI(InstanceMng.getMapView());
               InstanceMng.getFlowStatePlanet().finishTutorial();
               InstanceMng.getUIFacade().blackStripsHide();
               InstanceMng.getMissionsMng().showBackMissionsInHud();
         }
         if(found == false)
         {
            super.onKeyDown(e);
         }
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         InstanceMng.getUIFacade().getMapViewPlanet().onMouseUp(e);
      }
      
      override public function setMouseOverChildSku(elementSku:String) : void
      {
         mMouseOverChildSku = elementSku;
      }
      
      override protected function giveFocus(sku:String) : void
      {
         mCurrentFocusSku = null;
         DCComponentUI(mChildrenBySku[sku]).uiEnable();
      }
      
      override protected function changeFocus(sku:String) : void
      {
         var i:int = 0;
         var l:int = 0;
         var child:DCComponentUI = null;
         var idxMouseComponent:String = this.getFocusTestComponentSku();
         if(!DCPopupMng.smIsPopupActive && !InstanceMng.getMapControllerPlanet().hasScrollBegun() && mCurrentFocusSku != sku && !InstanceMng.getApplication().lockUIIsLocked())
         {
            mCurrentFocusSku = sku;
            l = int(mChildren.length);
            for(i = 0; i < l; )
            {
               if((child = mChildren[i] as DCComponentUI).getParentRef() != sku)
               {
                  child.uiDisable();
               }
               i++;
            }
         }
      }
      
      override public function performFocusTest() : void
      {
         if(mFocusTestPerformedOnTick)
         {
            return;
         }
         mFocusTestPerformedOnTick = true;
         var sku:String = this.getFocusTestComponentSku();
         if(sku != null)
         {
            this.giveFocus(sku);
         }
      }
      
      override public function getFocusTestComponentSku() : String
      {
         var mouseX:Number = NaN;
         var mouseY:Number = NaN;
         var child:DCComponent = null;
         var guiComp:GUIComponent = null;
         var sku:String = null;
         var cursor:CursorFacade = InstanceMng.getUIFacade().getCursorFacade();
         if(cursor != null)
         {
            mouseX = cursor.getCursorX();
            mouseY = cursor.getCursorY();
            for each(sku in CHILDS_SKUS_FOCUS_PRIORITIES)
            {
               if((child = mChildrenBySku[sku]) is GUIComponent)
               {
                  if((guiComp = child as GUIComponent).isVisible() && guiComp.performHitTestPoint(mouseX,mouseY) == true)
                  {
                     return sku;
                  }
               }
               else if(child is MapViewPlanet)
               {
                  return sku;
               }
            }
         }
         return null;
      }
      
      override protected function focusLogicUpdate(dt:int) : void
      {
         mFocusTestPerformedOnTick = false;
      }
      
      override protected function notifyWarEvent(e:Object) : Boolean
      {
         var tileX:int = 0;
         var tileY:int = 0;
         var tileRelX:int = 0;
         var tileRelY:int = 0;
         var unitSku:String = null;
         var warBar:WarBarFacade = null;
         var retValue:Boolean = true;
         switch(e.cmd)
         {
            case "NOTIFY_WAR_CLICK_ON_MAP_DEPLOY_UNITS":
               tileX = e.spawnTileX + 2;
               tileY = e.spawnTileY + 2;
               mCoor.x = e.spawnTileX + 2;
               mCoor.y = e.spawnTileY + 2;
               mCoor = InstanceMng.getViewMngPlanet().tileXYToWorldViewPos(mCoor,true);
               tileRelX = InstanceMng.getMapControllerPlanet().getTileToTileRelativeX(tileX);
               tileRelY = InstanceMng.getMapControllerPlanet().getTileToTileRelativeY(tileY);
               unitSku = String(e.unitSku);
               (warBar = InstanceMng.getGUIControllerPlanet().getWarBar()).notifyUnitDropped(unitSku);
               InstanceMng.getUnitScene().startDeployUnits(mCoor.x,mCoor.y,null,0);
               break;
            case "NOTIFY_WAR_TOOL_SETUP":
               InstanceMng.getToolsMng().setToolWarCircle(e.unitSku);
               break;
            case "NOTIFY_WAR_TOOL_UNSETUP":
               InstanceMng.getToolsMng().setTool(0);
               break;
            default:
               retValue = super.notifyWarEvent(e);
         }
         return retValue;
      }
      
      override protected function notifyCanBeProcessed(e:Object) : Boolean
      {
         var bool2:* = false;
         var bool2_1:Boolean = false;
         var bool3:Boolean = false;
         var bool4:* = false;
         var ret:Boolean;
         if((ret = super.notifyCanBeProcessed(e)) == true)
         {
            var _loc7_:* = e.cmd;
            if("NOTIFY_OPEN_START_REPAIRS_POPUP" === _loc7_)
            {
               bool2_1 = (bool2 = !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting()) || bool2 == false && phaseIsIN(e.phase) == false;
               bool3 = InstanceMng.getMapView().isBuilt();
               bool4 = InstanceMng.getApplication().fsmGetCurrentState().isALoadingState() == false;
               ret = bool2_1 && bool3 && bool4;
            }
         }
         return ret;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var i:int = 0;
         var child:DCComponentUI = null;
         var popup:DCIPopup = null;
         var shipyard:Shipyard = null;
         var shipDef:ShipDef = null;
         var hc:HangarController = null;
         var nearestAvailableHangar:Hangar = null;
         var shipyardId:String = null;
         var s:Shipyard = null;
         var noMoreShips:* = false;
         var eventId:String = null;
         var returnValue:Boolean = false;
         if(this.notifyCanBeProcessed(e) == false)
         {
            if(mPendingEvents.indexOf(e) == -1)
            {
               mPendingEvents.push(e);
            }
            return false;
         }
         switch(e.type)
         {
            case 1:
               returnValue = this.notifyWIOEvent(e);
               break;
            case "EventPopup":
               returnValue = this.notifyPopup(e);
               break;
            case 2:
               returnValue = this.notifyShopResourceEvent(e);
               break;
            default:
               switch(e.cmd)
               {
                  case "NOTIFY_CLOSESHOP":
                     this.closeShopBar();
                     returnValue = true;
                     break;
                  case "NOTIFY_CLOSEBUFFER":
                     this.closeBufferBar();
                     returnValue = true;
                     break;
                  case "NOTIFY_OPENSHOP":
                     this.openShopBar(e.shoptype);
                     returnValue = true;
                     break;
                  case "NOTIFY_BBOPEN":
                     InstanceMng.getBuildingsBufferController().saveItemsOldPositions();
                     this.openBuildingBufferBar();
                     InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_TEMPLATES);
                     returnValue = true;
                     break;
                  case "NOTIFY_INTERACTSHIPYARD":
                     this.openShipyard(WorldItemObject(e.item).mSid);
                     returnValue = true;
                     break;
                  case "NOTIFY_CLOSESHIPYARD":
                     this.closeShipyard();
                     returnValue = true;
                     break;
                  case "NOTIFY_SHIPYARD_STARTPRODUCING":
                     e.cmd = "WIOEventShipyardBuildShipStart";
                     e.item = InstanceMng.getShipyardController().getShipyard(e.shipyardId).getWorldItemObject();
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                     returnValue = true;
                     break;
                  case "NOTIFY_SHIPYARD_QUEUEADVANCE_ASK":
                     shipyard = InstanceMng.getShipyardController().getShipyard(e.shipyardId);
                     shipDef = InstanceMng.getShipDefMng().getDefBySku(e.shipSku) as ShipDef;
                     if((hc = InstanceMng.getHangarControllerMng().getHangarController()).canAdd(shipDef.getSize()))
                     {
                        if((nearestAvailableHangar = hc.getHangarForDef(shipDef,shipyard.getShipTimeLeft() == 0)) != null)
                        {
                           e.cmd = "NOTIFY_HANGAR_AVAILABLE";
                           e.nearestAvailableHangar = nearestAvailableHangar;
                           sendBackEvent(e);
                           if(this.getShipyardBar().isVisible())
                           {
                              this.getShipyardBar().setVisibleWarningBox(false);
                           }
                        }
                        else
                        {
                           e.cmd = "NOTIFY_HANGAR_NONE_AVAILABLE";
                           sendBackEvent(e);
                           e.cmd = "WIOEventShipyardLaunchShipPause";
                           e.item = shipyard.getWorldItemObject();
                           InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                           if(this.getShipyardBar().isVisible())
                           {
                              this.getShipyardBar().setVisibleWarningBox(true);
                           }
                        }
                     }
                     else if(!shipyard.isProductionPaused())
                     {
                        e.cmd = "NOTIFY_HANGAR_NONE_AVAILABLE";
                        sendBackEvent(e);
                        e.cmd = "WIOEventShipyardLaunchShipPause";
                        e.item = shipyard.getWorldItemObject();
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                        if(this.getShipyardBar().isVisible())
                        {
                           this.getShipyardBar().setVisibleWarningBox(true);
                        }
                     }
                     returnValue = true;
                     break;
                  case "NOTIFY_SHIPYARD_QUEUEADVANCE":
                  case "NOTIFY_SHIPYARD_QUEUEUPDATE":
                     shipyardId = String(e.shipyardId);
                     this.shipyardQueueAdvance(shipyardId);
                     s = InstanceMng.getShipyardController().getShipyard(shipyardId);
                     if(e.cmd == "NOTIFY_SHIPYARD_QUEUEADVANCE")
                     {
                        e.cmd = "WIOEventShipyardLaunchShipStart";
                        e.item = s.getWorldItemObject();
                        e.shipyardId = shipyardId;
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                        InstanceMng.getUserDataMng().updateShips_shipCompleted(int(shipyardId),e.shipSku,e.nearestAvailableHangar.getWIO().mSid);
                     }
                     else
                     {
                        noMoreShips = InstanceMng.getShipyardController().getProducingElementSku(shipyardId) == null;
                        if(e.wasPaused && this.getShipyardBar().isVisible())
                        {
                           this.getShipyardBar().setVisibleWarningBox(false);
                           eventId = noMoreShips ? "WIOEventShipyardBuildNoShips" : "WIOEventShipyardBuildShipStart";
                           e = createNotifyEvent(null,eventId,null,s.getWorldItemObject());
                           e.shipyardId = shipyardId;
                           InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                        }
                        else if(noMoreShips)
                        {
                           e = createNotifyEvent(null,"WIOEventShipyardBuildNoShips",null,s.getWorldItemObject());
                           e.shipyardId = shipyardId;
                           InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),e,true);
                        }
                     }
                     returnValue = true;
                     break;
                  case "WorldEventPlaceItem":
                     if(e.subcmd != "MoveItem" && e.subcmd != "MoveItems" && e.subcmd != "FlipItem")
                     {
                        if(InstanceMng.getBuildingsShopController().toolChangeAfterPlaceItem(e.item))
                        {
                           InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_cursor");
                        }
                        InstanceMng.getItemsMng().notify(e);
                     }
                     returnValue = true;
                     break;
                  case "NOTIFY_MAP_SCROLLEND":
                     if(mMouseOverChildSku != null)
                     {
                        if((child = mChildrenBySku[mMouseOverChildSku]) != null)
                        {
                           child.uiEnable();
                        }
                     }
                     returnValue = true;
                     break;
                  case "NOTIFY_MAP_OPEN":
                     returnValue = true;
                     break;
                  case "NOTIFY_INVENTORY_OPEN":
                     popup = InstanceMng.getItemsMng().guiOpenInventoryPopup();
                     InstanceMng.getGUIControllerPlanet().getToolBar().setStarInventoryVisible();
                     break;
                  case "NotifyDroidsCreateADroidInHQ":
                     InstanceMng.getTrafficMng().droidsCreateDroid(true);
                     break;
                  default:
                     returnValue = false;
               }
         }
         if(returnValue == false)
         {
            returnValue = super.notify(e);
         }
         return returnValue;
      }
      
      public function notifyShopResourceEvent(e:Object) : Boolean
      {
         var transactionPack:Transaction = null;
         var allOK:Boolean = false;
         var t:Transaction = null;
         var gameUnit:GameUnit = null;
         var shipSlot:int = 0;
         var returnValue:Boolean = true;
         var notification:Notification = null;
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         switch(e.cmd)
         {
            case "NOTIFY_SHOP_BUY":
               transactionPack = InstanceMng.getRuleMng().getTransactionPack(e);
               if(transactionPack.checkIfValidAmount() == true)
               {
                  notification = checkIfOperationIsPossible(e.itemDef as WorldItemDef,transactionPack);
                  if(notification != null)
                  {
                     mPopupMngRef.closePopup(e.cmd);
                     notificationsMng.guiOpenNotificationMessage(notification);
                     return false;
                  }
                  this.shopBuy(e.itemDef.mSku,transactionPack);
               }
               InstanceMng.getTargetMng().updateProgress("clickShopButton",1);
               break;
            case "NOTIFY_SHIPYARD_BUY":
               allOK = false;
               if(e.eventWhenSuccess == true)
               {
                  t = e.transaction as Transaction;
                  allOK = true;
                  e.eventWhenSuccess = null;
               }
               else
               {
                  (t = InstanceMng.getRuleMng().createSingleTransaction(true,0,e.constructionCost,e.constructionMineral,e.xp)).setTransInfoPackage(e);
                  e.transaction = t;
                  if((gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(e.itemSku)) != null)
                  {
                     notification = checkIfOperationIsPossible(gameUnit.mDef,t);
                     if(notification != null)
                     {
                        notificationsMng.guiOpenNotificationMessage(notification);
                     }
                     else if(t.performAllTransactions())
                     {
                        allOK = true;
                     }
                  }
               }
               if(allOK)
               {
                  if((shipSlot = this.shipyardQueueAddShip(e.itemSku,e.constructionTime)) > -1)
                  {
                     InstanceMng.getUserDataMng().updateShips_shipAdded(e.shipyardId,e.itemSku,shipSlot,e.constructionTime,t);
                  }
                  else
                  {
                     InstanceMng.getShipyardController().shipyardQueuedElementShowBuySlotTooltip();
                  }
               }
               break;
            case "mapToolsEventPlaceItem":
               InstanceMng.getToolsMng().getTool(4).notify(e);
         }
         return returnValue;
      }
      
      public function notifyWIOEvent(e:Object, checkRetardedIf:Boolean = true) : Boolean
      {
         var transactionPack:Transaction = null;
         var dcipopup:DCIPopup = null;
         var timeToFinish:Number = NaN;
         var eventItem:WorldItemObject = null;
         var timeLeftMs:Number = NaN;
         var notification:Notification = null;
         var item:WorldItemObject = null;
         var ruleMng:RuleMng = null;
         var def:DCDef = null;
         var gameUnit:GameUnit = null;
         var enoughCash:* = false;
         if(checkIfNeedsToCallServer(checkRetardedIf,e))
         {
            return true;
         }
         var returnValue:Boolean = true;
         var openPopup:Boolean = true;
         var forceComplexBody:Boolean = false;
         var instantBuildThreshold:Number = InstanceMng.getSettingsDefMng().getInstantOpTimeThreshold();
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         var cmd:String;
         switch(cmd = String(e["cmd"]))
         {
            case "WIOEventInstantBuild":
               if(!phaseIsIN(e.phase))
               {
                  e.phase = "";
                  var _loc20_:* = e.button;
                  if("EventYesButtonPressed" === _loc20_)
                  {
                     transactionPack = e.transaction;
                     WorldItemObject(e.item).setTransaction(transactionPack);
                     if(transactionPack.performAllTransactions())
                     {
                        this.eventWhenSuccess(e);
                     }
                  }
                  InstanceMng.getUIFacade().closePopup(e["popup"]);
                  e.item.resume();
                  resetNotifyEvent(e);
               }
               break;
            case "WIOEventDemolitionStart":
               if(phaseIsIN(e.phase))
               {
                  if(WorldItemDef(e.item.mDef).canBeDemolished())
                  {
                     (eventItem = WorldItemObject(e.item)).pause();
                     e.phase = "OUT";
                     transactionPack = InstanceMng.getRuleMng().getTransactionPack(e);
                     e.transaction = transactionPack;
                     if(eventItem.mDef.getTypeId() == 12)
                     {
                        e.button = "EventYesButtonPressed";
                        this.notifyWIOEvent(e,false);
                        return true;
                     }
                     notificationsMng.guiOpenRecycleWIOPopup(eventItem,e);
                  }
               }
               else
               {
                  _loc20_ = e.button;
                  if("EventYesButtonPressed" === _loc20_)
                  {
                     eventItem = e.item as WorldItemObject;
                     (transactionPack = e.transaction as Transaction).setCheckServerResponseEnabled(true);
                     if(transactionPack.performAllTransactions())
                     {
                        this.eventWhenSuccess(e);
                     }
                     else
                     {
                        e.phase = "";
                     }
                  }
                  resetNotifyEvent(e);
                  mPopupMngRef.closePopup(e.popup);
               }
               break;
            case "WIOEventUpgradePremium":
            case "WIOEventUpgradeStart":
               if(!((eventItem = e.item as WorldItemObject) != null && (!eventItem.canBeUpgraded() || !eventItem.canStateBeUpgraded()) && !InstanceMng.getFlowStatePlanet().isTutorialRunning()))
               {
                  returnValue = InstanceMng.getUIFacade().getPopupFactory().eventNotifyWIOUpgradeStart(e);
               }
               break;
            case "WIOEventInstantUpgrade":
               if(!phaseIsIN(e.phase))
               {
                  _loc20_ = e.button;
                  if("EventYesButtonPressed" === _loc20_)
                  {
                     transactionPack = e.transaction;
                     item = WorldItemObject(e.item);
                     item.setTransaction(transactionPack);
                     if(transactionPack.performAllTransactions())
                     {
                        mPopupMngRef.closePopup(e.popup);
                        this.eventWhenSuccess(e);
                     }
                  }
               }
               break;
            case "WIOEventCancelUpgrade":
            case "WIOEventCancelBuild":
               if(phaseIsIN(e.phase))
               {
                  (eventItem = e.item as WorldItemObject).pause();
                  if((transactionPack = (ruleMng = InstanceMng.getRuleMng()).getTransactionPack(e)) != null)
                  {
                     e.transaction = transactionPack;
                  }
                  notificationsMng.guiOpenCancelProcessPopup(e,ruleMng.getCancelBuildingUpgradeProfitPercentage());
                  e.phase = "OUT";
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                     case "EventCancelButtonPressed":
                        mPopupMngRef.closePopup(e.popup);
                        e.item.resume();
                        resetNotifyEvent(e);
                        break;
                     case "EventYesButtonPressed":
                        transactionPack = Transaction(e.transaction);
                        WorldItemObject(e.item).setTransaction(transactionPack);
                        if(transactionPack.performAllTransactions())
                        {
                           mPopupMngRef.closePopup(e.popup);
                           this.eventWhenSuccess(e);
                        }
                  }
               }
               break;
            case "NotifyHangarInfo":
               this.notifyHangarPopup(e);
               break;
            case "NOTIFY_POPUP_OPEN_BUNKER":
               mPopupMngRef.enqueueBunkerPopup(e);
               break;
            case "NOTIFY_POPUP_OPEN_PVP_MAP":
               openPVPMap();
               break;
            case "NOTIFY_POPUP_OPEN_REFINERY":
               this.notifyRefineryPopup(e);
               break;
            case "NOTIFY_POPUP_OPEN_EMBASSY":
               this.notifyEmbassyPopup(e);
               break;
            case "NOTIFY_POPUP_OPEN_LABS":
               if(!phaseIsIN(e.phase))
               {
                  e.phase = "IN";
                  if(e.button != "EventCloseButtonPressed")
                  {
                     def = e.itemDef == null ? (e.item as WorldItemObject).mDef : e.itemDef;
                     if(e.button == "EVENT_BUTTON_RIGHT_PRESSED")
                     {
                        transactionPack = e.transaction as Transaction;
                        if((notification = checkIfOperationIsPossible(def,transactionPack,true)) != null)
                        {
                           notificationsMng.guiOpenNotificationMessage(notification,false);
                           return false;
                        }
                        if(transactionPack.getTransHasBeenPerformed() || transactionPack.performAllTransactions())
                        {
                           EPopupUpgrade(e.popup).notify({
                              "cmd":"NotifyStartUpgrade",
                              "transaction":transactionPack
                           });
                           if(!(mPopupMngRef.getPopupBeingShown() is EPopupUpgrade) && !(mPopupMngRef.getUnderPopup() is EPopupUpgrade))
                           {
                              InstanceMng.getGameUnitMngController().guiOpenLaboratoryPopup(e);
                           }
                           if(this.getShipyardBar().isVisible())
                           {
                              this.getShipyardBar().reload();
                           }
                        }
                     }
                     else if(e.button == "EventYesButtonPressed")
                     {
                        transactionPack = e.transaction;
                        enoughCash = InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= transactionPack.getLogicCashToPay();
                        if((notification = checkIfOperationIsPossible(e.nextDef,transactionPack,true)) != null && enoughCash)
                        {
                           notificationsMng.guiOpenNotificationMessage(notification,false);
                           return false;
                        }
                        if(transactionPack.performAllTransactions())
                        {
                           (gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMng().getGameUnitBySku(e.itemDef.mSku)).upgradeUnit(transactionPack,e.nextDef);
                           if(InstanceMng.getGameUnitMngController().getGameUnitMng().getUpgradingUnit() != null || e.unlocking && e.accelerate)
                           {
                              InstanceMng.getGameUnitMngController().getGameUnitMng().logicUpdate(0);
                           }
                           else
                           {
                              InstanceMng.getGameUnitMngController().getGameUnitMng().setUnitUpgraded(gameUnit,e.unlocking);
                           }
                           if(this.getShipyardBar().isVisible())
                           {
                              this.getShipyardBar().reload();
                           }
                           if(e.hasOwnProperty("isInfo") && e.isInfo)
                           {
                              EPopupUpgrade(e.popup).notify({
                                 "cmd":"NotifyUnitSelected",
                                 "unit":e.unit
                              });
                           }
                           else
                           {
                              EPopupUpgrade(e.popup).notify({"cmd":"NotifyLoadUnitsSelection"});
                           }
                        }
                     }
                  }
                  break;
               }
               e.item = null;
               e.phase = "OUT";
               InstanceMng.getGameUnitMngController().guiOpenLaboratoryPopup(e);
               break;
            case "NOTIFY_MODIFY_CURRENT_DROID_TASK":
               returnValue = InstanceMng.getUIFacade().getPopupFactory().eventNotifyModifyCurrentTaskDroid(e);
               break;
            default:
               sendBackEvent(e);
               resetNotifyEvent(e);
         }
         return returnValue;
      }
      
      private function getArrayDataFromTransactions(itemsTransactions:Vector.<Transaction>) : Array
      {
         var o:Object = null;
         var t:Transaction = null;
         var itemsArr:Array = [];
         var i:int = 0;
         for each(t in itemsTransactions)
         {
            if(t != null)
            {
               (o = {}).sid = WorldItemObject(t.getTransInfoPackage().item).mSid;
               if(t.getTransMinerals() != 0)
               {
                  o.minerals = t.getTransMinerals();
               }
               if(t.getTransCash() != 0)
               {
                  o.cash = t.getTransCash();
               }
               itemsArr[i] = o;
               i++;
            }
         }
         return itemsArr;
      }
      
      private function notifyControllersItemToDestroy(item:WorldItemObject) : void
      {
         var itemType:int = item.mDef.getTypeId();
         if(itemType == 3)
         {
            InstanceMng.getShipyardController().removeShipyardBySid(item.mSid);
         }
         else if(itemType == 7)
         {
            InstanceMng.getHangarControllerMng().getHangarController().removeBySid(item.mSid);
         }
         else if(itemType == 8)
         {
            InstanceMng.getBunkerController().removeBySid(item.mSid);
         }
      }
      
      override public function eventWhenSuccess(e:Object) : void
      {
         var item:WorldItemObject = e.item;
         switch(e.cmd)
         {
            case "WIOEventInstantBuild":
               this.resumeEventOnItemWhenSuccess(e,item);
               break;
            case "WIOEventInstantUpgrade":
               this.resumeEventOnItemWhenSuccess(e,item);
               break;
            case "WIOEventDemolitionStart":
               sendBackEvent(e);
               item.resume();
               this.notifyControllersItemToDestroy(item);
               e.phase = "";
               break;
            case "WIOEventUpgradeStart":
               this.resumeEventOnItemWhenSuccess(e,item);
               e.startUpgrade = null;
               e.transaction = null;
               e.item = null;
               break;
            case "WIOEventUpgradePremium":
               super.eventWhenSuccess(e);
               break;
            case "WIOEventCancelUpgrade":
            case "WIOEventCancelBuild":
               this.resumeEventOnItemWhenSuccess(e,item);
               break;
            default:
               super.eventWhenSuccess(e);
         }
      }
      
      private function resumeEventOnItemWhenSuccess(e:Object, item:WorldItemObject) : void
      {
         sendBackEvent(e);
         resetNotifyEvent(e);
         if(item != null)
         {
            item.resume();
         }
      }
      
      private function notifyMissionPopup(e:Object) : Boolean
      {
         var obj:Object = null;
         var transaction:Transaction = null;
         var target:DCTarget = null;
         var neededAmount:int = 0;
         var popup:DCIPopup = null;
         var playerName:String = null;
         var returnValue:Boolean = true;
         var openPopup:Boolean = true;
         var missionSku:String = String(e["missionSku"]);
         switch(e.cmd)
         {
            case "NOTIFY_SKIP_TARGET_WITH_FB":
               if(phaseIsIN(e.phase) == false && e.button == "EventYesButtonPressed")
               {
                  if((transaction = e.transaction) != null)
                  {
                     if(transaction.performAllTransactions())
                     {
                        target = DCTarget(e.target);
                        neededAmount = int(e.neededAmount);
                        if(e.miniTargetInfo is EPopupMissionTargetBox)
                        {
                           EPopupMissionTargetBox(e.miniTargetInfo).disableBuyButton();
                        }
                        target.addProgress(e.indexTarget,neededAmount);
                        (obj = {}).sku = target.getDef().mSku;
                        obj.index = e.indexTarget;
                        obj.amount = neededAmount;
                        obj.transaction = transaction;
                        InstanceMng.getApplication().updateTargetProgressOnServer(obj);
                     }
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyMissionInfo":
               if(phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getMissionsMng().guiOpenMissionInfoPopup(DCTarget(e.target).getDef().getSku());
                  e.phase = "OUT";
                  if(!InstanceMng.getUIFacade().friendsBarIsVisible())
                  {
                     this.hideOpenedBar();
                     showFriendsBar();
                  }
               }
               break;
            case "NotifyMissionProgress":
               if(missionSku == "mission_000")
               {
                  InstanceMng.getUIFacade().blackStripsShow(true);
                  InstanceMng.getFlowStatePlanet().createTutorialKidnapMng();
                  InstanceMng.getTutorialKidnapMng().setupVars();
               }
               else if(phaseIsIN(e.phase) == true)
               {
                  popup = InstanceMng.getMissionsMng().guiOpenMissionProgressPopup(missionSku);
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                     case "EventCancelButtonPressed":
                        mPopupMngRef.closePopup(e.popup);
                        break;
                     case "EventYesButtonPressed":
                        mPopupMngRef.closePopup(e.popup);
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyMissionCompleted":
               if((e.target as DCTarget).getDef().mSku == "mission_000")
               {
                  InstanceMng.getMissionsMng().enableMissionDrop(true);
               }
               else if(phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getMissionsMng().guiOpenMissionCompletePopup(e);
                  if(Config.USE_SOUNDS)
                  {
                     SoundManager.getInstance().playSound("hurray.mp3",2,0,0,1);
                  }
                  e.phase = "OUT";
                  InstanceMng.getMissionsMng().enableMissionDrop(true);
               }
               else
               {
                  mPopupMngRef.closePopup(e.popup);
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyMercenariesMissionCompleted":
               if(phaseIsIN(e.phase) == true)
               {
                  e.popup = InstanceMng.getMissionsMng().guiOpenMissionMercenariesCompletedPopup(e,missionSku);
                  InstanceMng.getMissionsMng().enableMissionDrop(true);
                  e.phase = "OUT";
               }
               else
               {
                  var _loc11_:* = e.button;
                  if("EventCloseButtonPressed" === _loc11_)
                  {
                     mPopupMngRef.closePopup(e.popup);
                     resetNotifyEvent(e);
                  }
               }
         }
         return returnValue;
      }
      
      private function notifyHangarPopup(e:Object) : Boolean
      {
         var returnValue:Boolean = true;
         this.guiOpenHangarPopup((e.item as WorldItemObject).mSid);
         return returnValue;
      }
      
      private function notifyRefineryPopup(e:Object) : void
      {
         var popup:ERefineryPopup = new ERefineryPopup(e.item as WorldItemObject);
         popup.build("PopupRefinery",InstanceMng.getViewFactory(),null);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function notifyEmbassyPopup(e:Object) : void
      {
         var popup:EPopupEmbassy = new EPopupEmbassy(e.item as WorldItemObject);
         popup.setupBackground("PopupEmbassy",InstanceMng.getViewFactory(),null);
         popup.build();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      override protected function notifyConsoleFrictionlessPayment(e:Object) : void
      {
         var trans:Transaction = e.transaction;
         var cost:String = "";
         var transCoins:Number = trans.getTransCoins();
         var transMinerals:Number = trans.getTransMinerals();
         var transCash:Number = trans.getTransCash();
         DCDebug.trace("\n***FRICTIONLESS PAYMENT***");
         DCDebug.trace("Transaction Event: " + trans.getTransEvent());
         if(e.itemDef != null)
         {
            DCDebug.trace("Transaction Item: " + (e.itemDef as DCDef).mSku);
         }
         DCDebug.trace("Trigger Reason: " + e.cmd);
         if(e.smallestTimeDroid != null)
         {
            DCDebug.trace("Droid released: [TIME LEFT]: " + DCTimerUtil.msToMin(e.frictionSmallestTimeDroid));
         }
         if(transCoins != 0)
         {
            cost += "[" + transCoins + "] " + "coins" + " | ";
         }
         if(transMinerals != 0)
         {
            cost += "[" + transMinerals + "] " + "minerals" + " | ";
         }
         if(transCash != 0)
         {
            cost += "[" + transCash + "] " + "cash";
         }
         DCDebug.trace("Transaction details: " + cost);
         if(e.frictionCash != null)
         {
            DCDebug.trace("Trans. Premium currency paid: " + e.frictionCash);
         }
         DCDebug.trace("***FRICTIONLESS PAYMENT***\n");
      }
      
      override protected function notifyPopup(e:Object, checkRetardedIf:Boolean = true) : Boolean
      {
         var itemDef:WorldItemDef = null;
         var popup:DCIPopup = null;
         var transaction:Transaction = null;
         var objTransaction:Object = null;
         var playerName:String = null;
         var npcName:String = null;
         var currShipyard:Shipyard = null;
         var unitDef:GameUnit = null;
         var feedImg:String = null;
         var swfUrl:String = null;
         var shipyard:Shipyard = null;
         var hqUpgradeId:int = 0;
         var returnValue:Boolean = true;
         var notification:Notification = null;
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(checkIfNeedsToCallServer(checkRetardedIf,e) == true)
         {
            return true;
         }
         switch(e.cmd)
         {
            case "NotifyTransferUnitsToBunker":
               if(e.resumeOperation)
               {
                  MessageCenter.getInstance().sendMessage("bunkerTransactionOK",null);
               }
               else
               {
                  e.resumeOperation = true;
                  if((transaction = InstanceMng.getRuleMng().getTransactionPack(e)) != null)
                  {
                     if(transaction.performAllTransactions() == true)
                     {
                        if((objTransaction = transaction.getTransInfoPackage()) != null)
                        {
                           sendBackEvent(objTransaction);
                        }
                        MessageCenter.getInstance().sendMessage("bunkerTransactionOK",null);
                     }
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyUnlockShipSlot":
               if(phaseIsIN(e.phase) == false && e.button == "EventYesButtonPressed")
               {
                  e.phase = "IN";
                  if((transaction = e.transaction as Transaction) != null)
                  {
                     if(transaction.performAllTransactions() == true)
                     {
                        (e.shipyardQueuedElement as ShipyardQueuedElement).buySlot(e);
                     }
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyAttackToNPCResult":
               if(phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getUnitScene().startBattleResultPopup(e,1);
                  e.phase = "OUT";
               }
               else
               {
                  mPopupMngRef.closePopup(e.popup,null,true);
                  this.endAttack();
                  InstanceMng.getUnitScene().battleResultClose();
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyUnitInfoPopup":
               InstanceMng.getShopsDrawer().openShowUnitInfoPopup(e.sku);
               break;
            case "NotifyMissionExpired":
               if(phaseIsIN(e.phase) == true)
               {
                  notification = notificationsMng.createNotificationMissionExpired();
                  e.msg = notification.getMessageBody();
                  e.title = notification.getMessageTitle();
                  notificationsMng.guiOpenNotificationMessage(notification,false);
                  e.phase = "OUT";
               }
               else
               {
                  switch(e.button)
                  {
                     case "EventCloseButtonPressed":
                     case "EventCancelButtonPressed":
                     case "EventYesButtonPressed":
                        mPopupMngRef.closePopup(e.popup);
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NotifyMissionInfo":
            case "NotifyMissionProgress":
            case "NotifyMissionCompleted":
            case "NOTIFY_SKIP_TARGET_WITH_FB":
            case "NotifyMercenariesMissionCompleted":
               this.notifyMissionPopup(e);
               break;
            case "NOTIFY_DROIDS_BUY":
               if(phaseIsIN(e.phase) == true)
               {
                  InstanceMng.getShopsDrawer().openBuyWorkerPopup();
                  e.phase = "OUT";
               }
               break;
            case "NOTIFY_OPEN_START_REPAIRS_POPUP":
               if(phaseIsIN(e.phase) == true)
               {
                  notificationsMng.guiOpenStartRepairing(e);
                  e.phase = "OUT";
               }
               else
               {
                  SoundManager.getInstance().playSound("repair.mp3",1,0,0,1);
                  InstanceMng.getWorld().userAcceptsRepairingStart();
                  mPopupMngRef.closeCurrentPopup();
               }
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDITEM":
               if(phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  e.transaction = InstanceMng.getRuleMng().getTransactionPack(e);
                  if(!e.unlock)
                  {
                     (currShipyard = InstanceMng.getShipyardController().getCurrentShipyard()).pauseProduction(true);
                  }
                  notificationsMng.guiOpenSpeedUpUnlockingCurrentUnit(e);
               }
               else
               {
                  e.phase = "IN";
                  InstanceMng.getPopupMng().closePopup("NOTIFY_POPUP_OPEN_SPEEDITEM");
                  InstanceMng.getShipyardController().getCurrentShipyard().resumeProduction(true);
                  if(e.button == "EventYesButtonPressed")
                  {
                     if((transaction = e.transaction) == null)
                     {
                        transaction = InstanceMng.getRuleMng().getTransactionPack(e);
                     }
                     if(transaction.performAllTransactions() == true)
                     {
                        sendBackEvent(e);
                     }
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDQUEUE":
               if(phaseIsIN(e.phase) == true)
               {
                  e.phase = "OUT";
                  (shipyard = InstanceMng.getShipyardController().getShipyard(e.shipyardId)).pauseProduction(true);
                  e.item = shipyard;
                  e.transaction = InstanceMng.getRuleMng().getTransactionPack(e);
                  e.popup = notificationsMng.guiOpenSpeedUpUnitsNoStoragePopup(e);
               }
               else
               {
                  e.phase = "IN";
                  if(e.popup != null)
                  {
                     InstanceMng.getPopupMng().closePopup(e.popup);
                  }
                  InstanceMng.getShipyardController().getCurrentShipyard().resumeProduction(true);
                  if(e.buttonLocationEvent == "EVENT_BUTTON_LEFT_PRESSED" || e.button == "EventYesButtonPressed")
                  {
                     if((transaction = InstanceMng.getRuleMng().getTransactionPack(e)).performAllTransactions() == true)
                     {
                        sendBackEvent(e);
                     }
                  }
                  resetNotifyEvent(e);
               }
               break;
            case "NOTIFY_POPUP_OPEN_AMOUNT_FAIL":
               if((notification = e.error) == null)
               {
                  itemDef = e.itemDef;
                  hqUpgradeId = -1;
                  if(itemDef != null)
                  {
                     hqUpgradeId = InstanceMng.getRuleMng().wioGetHQUpgradeIdToBuild(itemDef.mSku);
                  }
                  if(hqUpgradeId > -1)
                  {
                     notification = notificationsMng.createNotificationNotEnoughHQLevel("wonders_headquarters",hqUpgradeId + 1);
                  }
                  else
                  {
                     notification = notificationsMng.createNotificationMaxAmountOfBuildingsOfThisTypeReached();
                  }
                  e.error = notification;
               }
               notificationsMng.guiOpenNotificationMessage(notification);
               break;
            default:
               returnValue = false;
         }
         if(returnValue == false)
         {
            returnValue = super.notifyPopup(e,checkRetardedIf);
         }
         return returnValue;
      }
      
      public function deploysBegin(xml:XML = null) : void
      {
         var deploy:Array = null;
         var sku:String = null;
         var deployXML:XML = null;
         this.mDeploysElapsedTime = 0;
         this.mDeployLastUnitSkuDeployed = null;
         if(xml == null)
         {
            this.mDeploys = null;
         }
         else
         {
            if(this.mDeploys == null)
            {
               this.mDeploys = new Vector.<Array>(0);
            }
            this.mDeploys.length = 0;
            for each(deployXML in EUtils.xmlGetChildrenList(xml,"deploy"))
            {
               deploy = [];
               sku = EUtils.xmlReadString(deployXML,"sku");
               if(sku != "finished")
               {
                  deploy.push(EUtils.xmlReadNumber(deployXML,"time"));
                  deploy.push(sku);
                  deploy.push(EUtils.xmlReadInt(deployXML,"y"));
                  deploy.push(EUtils.xmlReadInt(deployXML,"x"));
                  this.mDeploys.push(deploy);
               }
            }
            if(this.mDeploys.length == 0)
            {
               this.mDeploys = null;
            }
         }
      }
      
      public function createEventWIOCancelProcess(item:WorldItemObject) : Object
      {
         var cmd:String = item.mDroidLabourId == 0 ? "WIOEventCancelBuild" : "WIOEventCancelUpgrade";
         var event:Object = InstanceMng.getGUIController().createNotifyEvent(1,cmd,InstanceMng.getWorldItemObjectController());
         event["item"] = item;
         return event;
      }
      
      public function createEventWIOInstantFinish(item:WorldItemObject) : Object
      {
         var cmd:String = item.mDroidLabourId == 0 ? "WIOEventInstantBuild" : "WIOEventInstantUpgrade";
         var event:Object = InstanceMng.getGUIController().createNotifyEvent(1,cmd,InstanceMng.getWorldItemObjectController());
         event["item"] = item;
         return event;
      }
      
      override protected function guiGetViewSku() : String
      {
         return "viewsPlanet";
      }
      
      private function guiOpenHangarPopup(hangarSid:String) : DCIPopup
      {
         var popup:DCIPopup = null;
         var hangarController:HangarController;
         var unitCount:int = int((hangarController = InstanceMng.getHangarControllerMng().getHangarController()).getUnitsInAllHangars().length);
         var hangar:Hangar = hangarController.getFromSid("" + hangarSid);
         if(unitCount == 0)
         {
            popup = this.guiCreateHangarInfoEmptyPopup(hangar);
         }
         else
         {
            popup = this.guiCreateHangarInfoNonEmptyPopup(hangar);
         }
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      private function guiCreateHangarInfoEmptyPopup(hangar:Hangar) : DCIPopup
      {
         var popup:EPopupHangarEmpty = new EPopupHangarEmpty();
         popup.build("PopupHangarInfoEmpty",InstanceMng.getViewFactory(),null,hangar.getMaxCapacity());
         return popup;
      }
      
      private function guiCreateHangarInfoNonEmptyPopup(hangar:Hangar) : DCIPopup
      {
         var popup:EPopupHangar = new EPopupHangar(hangar);
         popup.build("PopupHangarInfoNonEmpty",InstanceMng.getViewFactory(),null);
         return popup;
      }
   }
}
