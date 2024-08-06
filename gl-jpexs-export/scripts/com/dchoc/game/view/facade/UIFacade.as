package com.dchoc.game.view.facade
{
   import com.dchoc.game.controller.gui.popups.EPopupFactory;
   import com.dchoc.game.controller.gui.popups.PopupFactory;
   import com.dchoc.game.controller.map.MapControllerSolarSystem;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.TubeCameraEffect;
   import com.dchoc.game.eview.facade.BuildingBufferFacade;
   import com.dchoc.game.eview.facade.FriendsBarFacade;
   import com.dchoc.game.eview.facade.ReplayBarFacade;
   import com.dchoc.game.eview.facade.ShipyardBarFacade;
   import com.dchoc.game.eview.facade.ShopBarFacade;
   import com.dchoc.game.eview.facade.ToolBarFacade;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.facade.WarBarFacade;
   import com.dchoc.game.eview.facade.WarBarSpecialFacade;
   import com.dchoc.game.view.dc.facade.DCCursorFacade;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.game.view.dc.map.MapViewGalaxy;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.map.MapViewSolarSystem;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class UIFacade extends DCComponent
   {
      
      public static const NAVIGATION_PANEL_BUTTON_PLANET_ID:String = "button_planet";
      
      public static const NAVIGATION_PANEL_BUTTON_SOLAR_SYSTEM_ID:String = "button_solar_system";
      
      public static const NAVIGATION_PANEL_BUTTON_GALAXY_ID:String = "button_galaxy";
      
      public static const VIEWS_ELEMENT_UPPER_HUD_SKU:String = "hud";
      
      public static const VIEWS_ELEMENT_HUD_CONTROLLER_SKU:String = "hudController";
      
      public static const VIEWS_ELEMENT_FRIENDS_BAR_SKU:String = "friendsbar";
      
      public static const VIEWS_ELEMENT_TOOLS_BAR_SKU:String = "toolbar";
      
      public static const VIEWS_ELEMENT_NAVIGATION_BAR_SKU:String = "navigationbar";
      
      public static const VIEWS_ELEMENT_CURSOR_SKU:String = "cursor";
      
      public static const VIEWS_ELEMENT_WAR_BAR_SKU:String = "warbar";
      
      public static const VIEWS_ELEMENT_WAR_BAR_SPECIAL_SKU:String = "warbarSpecial";
      
      public static const VIEWS_ELEMENT_BUILDINGS_SHOP_BAR_SPECIAL_SKU:String = "shopbar";
      
      public static const VIEWS_ELEMENT_BUILDING_BUFFER_BAR_SKU:String = "bufferbar";
      
      public static const VIEWS_ELEMENT_SHIPYARD_BAR_SKU:String = "shipyardBar";
      
      public static const VIEWS_ELEMENT_REPLAY_BAR_SKU:String = "replayBar";
      
      public static const VIEWS_ELEMENT_MAP_PLANET_SKU:String = "mapPlanet";
      
      public static const VIEWS_ELEMENT_MAP_SOLAR_SYSTEM_SKU:String = "mapSolarSystem";
      
      public static const VIEWS_ELEMENT_MAP_GALAXY_SKU:String = "mapGalaxy";
      
      public static const VIEWS_PLANET_SKU:String = "viewsPlanet";
      
      public static const VIEWS_SOLAR_SYSTEM_SKU:String = "viewsSolarSystem";
      
      public static const VIEWS_GALAXY_SKU:String = "viewsGalaxy";
       
      
      protected var mPopupFactory:PopupFactory;
      
      private var mEnqueuedPopups:Vector.<String>;
      
      private var mViewsUiElements:Dictionary;
      
      private var mViewsUiElementsVectors:Dictionary;
      
      private var mViewsMouseFocusCurrentSku:String;
      
      private var mViewsCommonGUIElementSkus:Vector.<String>;
      
      private var mIsAllHudElementsHidden:Boolean = false;
      
      public function UIFacade()
      {
         super();
      }
      
      override protected function unbuildDo() : void
      {
         if(this.mPopupFactory != null)
         {
            this.mPopupFactory.destroy();
            this.mPopupFactory = null;
         }
         if(this.mEnqueuedPopups != null)
         {
            this.mEnqueuedPopups = null;
         }
         this.viewsUnbuild();
      }
      
      public function showTextFeedback(text:String, duration:int, delay:int = 0) : void
      {
         var params:Dictionary;
         (params = new Dictionary())["text"] = text;
         params["ttl"] = duration;
         params["delay"] = delay;
         MessageCenter.getInstance().sendMessage("showScreenFeedback",params);
      }
      
      public function battleFeedbackShow(text:String, showLoading:Boolean = false, pLock:Boolean = false, needLock:Boolean = false) : void
      {
         var warbar:WarBarFacade;
         (warbar = InstanceMng.getGUIControllerPlanet().getWarBar()).showMessage(text,showLoading,pLock,needLock);
         warbar.lockArrows(needLock);
         if(pLock)
         {
            this.getWarBarSpecial().lock();
         }
         else
         {
            this.getWarBarSpecial().unlock();
         }
      }
      
      public function battleFeedbackHide(needLock:Boolean = false) : void
      {
         var warbar:WarBarFacade = InstanceMng.getGUIControllerPlanet().getWarBar();
         warbar.hideMessage(needLock);
         warbar.lockArrows(needLock);
         if(needLock)
         {
            this.getWarBarSpecial().lock();
         }
         else
         {
            this.getWarBarSpecial().unlock();
         }
      }
      
      public function getPopupFactory() : PopupFactory
      {
         if(this.mPopupFactory == null)
         {
            this.mPopupFactory = this.createPopupFactory();
         }
         return this.mPopupFactory;
      }
      
      protected function createPopupFactory() : PopupFactory
      {
         return new EPopupFactory();
      }
      
      public function enqueuePopup(popup:DCIPopup, showAnim:Boolean = true, showDarkBackground:Boolean = true, closeOpenedPopup:Boolean = true, openImmediately:Boolean = false) : Boolean
      {
         var event:Object = null;
         var returnValue:Boolean = false;
         if(openImmediately)
         {
            returnValue = InstanceMng.getPopupMng().openPopup(popup,null,showAnim,showDarkBackground,closeOpenedPopup);
         }
         else if(this.addPopup(popup.getPopupType()))
         {
            (event = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_OPEN_EPOPUP")).popup = popup;
            event.showAnim = showAnim;
            event.showDarkBackground = showDarkBackground;
            event.closeOpenedPopup = closeOpenedPopup;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event);
         }
         else
         {
            popup.destroy();
            popup = null;
         }
         return returnValue;
      }
      
      private function addPopup(popupId:String) : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mEnqueuedPopups == null)
         {
            this.mEnqueuedPopups = new Vector.<String>(0);
         }
         if(this.mEnqueuedPopups.indexOf(popupId) == -1)
         {
            returnValue = true;
            this.mEnqueuedPopups.push(popupId);
         }
         return returnValue;
      }
      
      public function removeEnqueuedPopup(popupId:String) : void
      {
         if(this.mEnqueuedPopups != null)
         {
            this.mEnqueuedPopups.splice(this.mEnqueuedPopups.indexOf(popupId),1);
         }
      }
      
      public function closePopup(popup:DCIPopup, viewMng:DCViewMng = null, instant:Boolean = false) : Boolean
      {
         return InstanceMng.getPopupMng().closePopup(popup,viewMng,instant);
      }
      
      public function closePopupById(id:String, viewMng:DCViewMng = null, instant:Boolean = false) : Boolean
      {
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupOpened(id);
         var returnValue:Boolean = false;
         if(popup != null)
         {
            returnValue = this.closePopup(popup,viewMng,instant);
         }
         return returnValue;
      }
      
      public function blackStripsShow(hideHud:Boolean) : void
      {
      }
      
      public function blackStripsHide() : void
      {
      }
      
      public function blackStripsToggle() : void
      {
      }
      
      public function blackStripsAreActive() : Boolean
      {
         return false;
      }
      
      public function friendsBarReload() : void
      {
      }
      
      public function friendsBarShow() : void
      {
         var friendsBar:FriendsBarFacade = this.getFriendsBar();
         if(friendsBar != null)
         {
            friendsBar.moveAppearDownToUp();
         }
      }
      
      public function friendsBarHide(time:Number = 0.5) : void
      {
         var friendsBar:FriendsBarFacade = this.getFriendsBar();
         if(friendsBar != null && friendsBar.isVisible())
         {
            friendsBar.moveDisappearUpToDown(time);
         }
      }
      
      public function friendsBarRemoveSelectedNeighbor() : void
      {
      }
      
      public function friendsBarSetSelectedFriendFromList(accountId:String = "-1", neighborIndex:int = -1) : void
      {
         var friendsBar:FriendsBarFacade = this.getFriendsBar();
         if(friendsBar != null)
         {
            friendsBar.setSelectedFromList(accountId,neighborIndex);
         }
      }
      
      public function friendsBarGetFriendBox(accountId:String) : DisplayObjectContainer
      {
         return null;
      }
      
      public function friendsBarLockVisitButtonOnFriend(accountId:String, mode:Boolean) : void
      {
      }
      
      public function friendsBarGetDCComponentUI() : DCComponentUI
      {
         return null;
      }
      
      public function friendsBarIsVisible() : Boolean
      {
         var returnValue:Boolean = false;
         var friendsBar:FriendsBarFacade = this.getFriendsBar();
         if(friendsBar != null)
         {
            returnValue = friendsBar.isVisible();
         }
         return returnValue;
      }
      
      public function addTubeEffectToScreen(effect:TubeCameraEffect) : void
      {
         var container:DisplayObjectContainer = InstanceMng.getViewMngPlanet().getLayer("LayerCursorWorld").getDisplayObject() as DisplayObjectContainer;
         if(container)
         {
            effect.load();
            container.addChild(effect);
         }
      }
      
      public function hudDisableAttackButton(reason:String) : void
      {
      }
      
      public function getHudBottomLayoutName() : String
      {
         return null;
      }
      
      public function navigationPanelBuild() : void
      {
      }
      
      public function navigationPanelSetSolarSystemData(starName:String, coords:DCCoordinate) : void
      {
      }
      
      public function reloadCurrentBottomBar(force:Boolean = false) : void
      {
      }
      
      public function reloadWarBars() : void
      {
         this.getWarBar().reload();
         this.getWarBarSpecial().reload();
      }
      
      public function updateWarBars() : void
      {
      }
      
      private function viewsBuild() : void
      {
         this.viewsGetUiElementsByViewSku("viewsPlanet");
         this.viewsGetUiElementsByViewSku("viewsSolarSystem");
         this.viewsGetUiElementsByViewSku("viewsGalaxy");
      }
      
      private function viewsUnbuild() : void
      {
         var e:* = null;
         var sku:String = null;
         var element:DCComponentUI = null;
         this.mViewsUiElementsVectors = null;
         if(this.mViewsUiElements != null)
         {
            for(e in this.mViewsUiElements)
            {
               sku = e as String;
               element = this.mViewsUiElements[element];
               if(element != null)
               {
                  element.unload();
               }
            }
            this.mViewsUiElements = null;
         }
         this.mViewsMouseFocusCurrentSku = null;
         this.mViewsCommonGUIElementSkus = null;
      }
      
      protected function viewsGetUiElementBySku(sku:String) : DCComponentUI
      {
         var returnValue:DCComponentUI = null;
         if(this.mViewsUiElements != null)
         {
            returnValue = this.mViewsUiElements[sku];
         }
         return returnValue;
      }
      
      protected function viewsSetUiElement(sku:String, element:DCComponentUI) : void
      {
         if(!element)
         {
            return;
         }
         element.setParentRef(sku);
         if(this.mViewsUiElements == null)
         {
            this.mViewsUiElements = new Dictionary(true);
         }
         var currentElement:DCComponentUI = this.viewsGetUiElementBySku(sku);
         if(currentElement != element)
         {
            if(currentElement != null)
            {
               currentElement.unload();
            }
            this.mViewsUiElements[sku] = element;
         }
      }
      
      protected function viewsAddUiElementToView(elementSku:String, viewSku:String) : void
      {
         var element:DCComponentUI = this.viewsGetUiElementBySku(elementSku);
         if(this.mViewsUiElementsVectors == null)
         {
            this.mViewsUiElementsVectors = new Dictionary(true);
         }
         var view:Vector.<DCComponentUI> = this.mViewsUiElementsVectors[viewSku];
         if(view == null)
         {
            view = new Vector.<DCComponentUI>(0);
            this.mViewsUiElementsVectors[viewSku] = view;
         }
         if(element != null)
         {
            if(view.indexOf(element) == -1)
            {
               view.push(element);
            }
         }
      }
      
      public function viewsGetUiElementBySkuAndViewSku(elementSku:String, viewSku:String) : DCComponentUI
      {
         return this.viewsGetUiElementBySku(elementSku);
      }
      
      public function viewsGetUiElementsByViewSku(viewSku:String) : Vector.<DCComponentUI>
      {
         var returnValue:Vector.<DCComponentUI> = null;
         if(this.mViewsUiElementsVectors != null)
         {
            returnValue = this.mViewsUiElementsVectors[viewSku];
         }
         if(returnValue == null)
         {
            this.viewsStoreUIElements(viewSku);
            if(this.mViewsUiElementsVectors != null)
            {
               returnValue = this.mViewsUiElementsVectors[viewSku];
            }
         }
         return returnValue;
      }
      
      private function viewsCreateElementBySku(elementSku:String) : DCComponentUI
      {
         var element:DCComponentUI = this.viewsGetUiElementBySku(elementSku);
         if(element == null)
         {
            switch(elementSku)
            {
               case "hud":
                  element = new TopHudFacade();
                  break;
               case "navigationbar":
                  element = this.viewsCreateNavigationBarFacade();
                  break;
               case "friendsbar":
                  element = this.viewsCreateFriendsBarFacade();
                  break;
               case "toolbar":
                  element = this.viewsCreateToolBarFacade();
                  break;
               case "cursor":
                  element = new DCCursorFacade();
            }
            this.viewsSetUiElement(elementSku,element);
         }
         return element;
      }
      
      private function viewsGetCommonGUIElementSkus() : Vector.<String>
      {
         if(this.mViewsCommonGUIElementSkus == null)
         {
            this.viewsCreateCommonGUIElementSkus();
         }
         return this.mViewsCommonGUIElementSkus;
      }
      
      protected function viewsCreateCommonGUIElementSkus() : void
      {
         this.viewsAddCommonGUIElementSku("hud");
         this.viewsAddCommonGUIElementSku("navigationbar");
         this.viewsAddCommonGUIElementSku("toolbar");
         this.viewsAddCommonGUIElementSku("friendsbar");
         this.viewsAddCommonGUIElementSku("cursor");
      }
      
      protected function viewsAddCommonGUIElementSku(sku:String) : void
      {
         if(this.mViewsCommonGUIElementSkus == null)
         {
            this.mViewsCommonGUIElementSkus = new Vector.<String>(0);
         }
         this.mViewsCommonGUIElementSkus.push(sku);
      }
      
      protected function viewsStoreUIElements(viewSku:String) : void
      {
         var elementSku:String = null;
         var element:DCComponentUI = null;
         var commonGUIElementSkus:Vector.<String> = this.viewsGetCommonGUIElementSkus();
         for each(elementSku in commonGUIElementSkus)
         {
            this.viewsCreateElementBySku(elementSku);
            this.viewsAddUiElementToView(elementSku,viewSku);
         }
         switch(viewSku)
         {
            case "viewsPlanet":
               if((element = this.viewsGetUiElementBySku("mapPlanet")) == null)
               {
                  element = new MapViewPlanet();
                  this.viewsSetUiElement("mapPlanet",element);
               }
               this.viewsAddUiElementToView("mapPlanet",viewSku);
               if((element = this.viewsGetUiElementBySku("shopbar")) == null)
               {
                  ((element = this.viewsCreateShopBarFacade()) as ShopBarFacade).setVisible(false);
                  this.viewsSetUiElement("shopbar",element);
               }
               this.viewsAddUiElementToView("shopbar",viewSku);
               if((element = this.viewsGetUiElementBySku("bufferbar")) == null)
               {
                  ((element = this.viewsCreateBufferBarFacade()) as BuildingBufferFacade).setVisible(false);
                  this.viewsSetUiElement("bufferbar",element);
               }
               this.viewsAddUiElementToView("bufferbar",viewSku);
               if((element = this.viewsGetUiElementBySku("shipyardBar")) == null)
               {
                  ((element = this.viewsCreateShipyardBarFacade()) as ShipyardBarFacade).setVisible(false);
                  this.viewsSetUiElement("shipyardBar",element);
               }
               this.viewsAddUiElementToView("shipyardBar",viewSku);
               if((element = this.viewsGetUiElementBySku("warbar")) == null)
               {
                  ((element = this.viewsCreateWarBarFacade()) as WarBarFacade).setVisible(false);
                  this.viewsSetUiElement("warbar",element);
               }
               this.viewsAddUiElementToView("warbar",viewSku);
               if((element = this.viewsGetUiElementBySku("replayBar")) == null)
               {
                  element = this.viewsCreateReplayBarFacade();
                  this.viewsSetUiElement("replayBar",element);
               }
               this.viewsAddUiElementToView("replayBar",viewSku);
               if((element = this.viewsGetUiElementBySku("warbarSpecial")) == null)
               {
                  ((element = this.viewsCreateWarBarSpecialFacade()) as WarBarSpecialFacade).setVisible(false);
                  this.viewsSetUiElement("warbarSpecial",element);
               }
               this.viewsAddUiElementToView("warbarSpecial",viewSku);
               break;
            case "viewsSolarSystem":
               this.storeMapSolarSystem(viewSku);
               break;
            case "viewsGalaxy":
               this.storeMapGalaxy(viewSku);
         }
      }
      
      public function viewsChangeMouseFocus(elementSku:String, viewSku:String) : void
      {
         if(viewSku == "viewsPlanet")
         {
            this.viewsChangeMouseFocusPlanet(elementSku);
         }
      }
      
      private function viewsChangeMouseFocusPlanet(elementSku:String) : void
      {
         var elements:Vector.<DCComponentUI> = null;
         var i:int = 0;
         var l:int = 0;
         var child:DCComponentUI = null;
         if(!DCPopupMng.smIsPopupActive && !InstanceMng.getMapControllerPlanet().hasScrollBegun() && this.mViewsMouseFocusCurrentSku != elementSku && !InstanceMng.getApplication().lockUIIsLocked())
         {
            this.mViewsMouseFocusCurrentSku = elementSku;
            elements = this.viewsGetUiElementsByViewSku("viewsPlanet");
            l = int(elements.length);
            for(i = 0; i < l; )
            {
               if((child = elements[i] as DCComponentUI).getParentRef() != elementSku)
               {
                  child.uiDisable();
               }
               i++;
            }
         }
      }
      
      public function battleSetTimeMode(value:int) : void
      {
         this.getTopHudFacade().battleSetMenuClockMode(value);
      }
      
      public function showHappeningIcon() : void
      {
      }
      
      public function hideHappeningIcon() : void
      {
      }
      
      public function showContestIcon() : void
      {
      }
      
      public function hideContestIcon() : void
      {
      }
      
      public function setContestIconTip(str:String) : void
      {
      }
      
      public function optionsSetButtonActive(buttonSku:String, active:Boolean) : void
      {
      }
      
      public function optionsMenuFadeIn() : void
      {
      }
      
      public function alliancesNotifyWarHasBegun() : void
      {
      }
      
      public function alliancesNotifyWasHasEnded() : void
      {
      }
      
      public function alliancesUpdateStarButtons() : Boolean
      {
         return false;
      }
      
      public function alliancesSetDefaultFlag() : void
      {
      }
      
      public function alliancesButtonReplaceByUserFlag(logo:Array, timeLeft:Number) : void
      {
      }
      
      public function alliancesAddHighlightButton() : void
      {
      }
      
      public function alliancesRemoveHighlightButton() : void
      {
      }
      
      public function getCollectionPanelPositionAbsolute() : Point
      {
         return new Point();
      }
      
      public function collectiblesGetCollectablePosition(sku:String) : int
      {
         return 0;
      }
      
      public function getCraftingPanelPositionAbsolute() : Point
      {
         return new Point();
      }
      
      public function craftingGetCollectablePosition(sku:String) : int
      {
         return 0;
      }
      
      public function getWorkerCollectionPanelPositionAbsolute() : Point
      {
         return new Point();
      }
      
      public function workerCollectiblesGetCollectablePosition(sku:String) : int
      {
         return 0;
      }
      
      public function getCashContainerPosition() : Point
      {
         return new Point();
      }
      
      public function getContestToolContainerPositionCentered() : Point
      {
         return new Point();
      }
      
      public function getInventoryContainerPositionCentered() : Point
      {
         return new Point();
      }
      
      public function hideAllHUDElements(time:Number = 0.5) : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         uiFacade.friendsBarHide(time);
         var navigationBar:GUIComponent = InstanceMng.getUIFacade().getNavigationBarFacade();
         if(navigationBar)
         {
            navigationBar.moveDisappearUpToDown(time);
         }
         InstanceMng.getGUIController().getToolBar().moveDisappearUpToDown(time);
         InstanceMng.getTopHudFacade().moveDisappearUpToDown();
         InstanceMng.getMissionsMng().hideTemporarilyMissionsInHud();
         InstanceMng.getPopupMng().closeCurrentPopup(null);
         this.mIsAllHudElementsHidden = true;
      }
      
      public function showAllHUDElements() : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         uiFacade.friendsBarShow();
         var navigationBar:GUIComponent = InstanceMng.getUIFacade().getNavigationBarFacade();
         if(navigationBar)
         {
            navigationBar.moveAppearDownToUp();
         }
         InstanceMng.getGUIController().getToolBar().moveAppearDownToUp();
         InstanceMng.getTopHudFacade().moveAppearDownToUp();
         InstanceMng.getMissionsMng().showBackMissionsInHud();
         this.mIsAllHudElementsHidden = false;
      }
      
      public function getIsAllHudElementsHidden() : Boolean
      {
         return this.mIsAllHudElementsHidden;
      }
      
      protected function viewsCreateTopHudFacade() : TopHudFacade
      {
         return new TopHudFacade();
      }
      
      protected function viewsCreateToolBarFacade() : ToolBarFacade
      {
         return new ToolBarFacade();
      }
      
      protected function viewsCreateNavigationBarFacade() : ENavigationBarFacade
      {
         return new ENavigationBarFacade();
      }
      
      protected function viewsCreateFriendsBarFacade() : FriendsBarFacade
      {
         return new FriendsBarFacade();
      }
      
      protected function viewsCreateShopBarFacade() : ShopBarFacade
      {
         return new ShopBarFacade();
      }
      
      protected function viewsCreateBufferBarFacade() : BuildingBufferFacade
      {
         return new BuildingBufferFacade();
      }
      
      protected function viewsCreateShipyardBarFacade() : ShipyardBarFacade
      {
         return new ShipyardBarFacade();
      }
      
      protected function viewsCreateWarBarFacade() : WarBarFacade
      {
         return new WarBarFacade();
      }
      
      protected function viewsCreateWarBarSpecialFacade() : WarBarSpecialFacade
      {
         return new WarBarSpecialFacade();
      }
      
      protected function viewsCreateReplayBarFacade() : ReplayBarFacade
      {
         return new ReplayBarFacade();
      }
      
      public function getCursorFacade() : CursorFacade
      {
         return this.viewsGetUiElementBySku("cursor") as CursorFacade;
      }
      
      public function getTopHudFacade() : TopHudFacade
      {
         return this.viewsGetUiElementBySku("hud") as TopHudFacade;
      }
      
      public function getNavigationBarFacade() : ENavigationBarFacade
      {
         return this.viewsGetUiElementBySku("navigationbar") as ENavigationBarFacade;
      }
      
      public function getWarBar() : WarBarFacade
      {
         return this.viewsGetUiElementBySku("warbar") as WarBarFacade;
      }
      
      public function getWarBarSpecial() : WarBarSpecialFacade
      {
         return this.viewsGetUiElementBySku("warbarSpecial") as WarBarSpecialFacade;
      }
      
      public function getBuildingsShopBar() : ShopBarFacade
      {
         return this.viewsGetUiElementBySku("shopbar") as ShopBarFacade;
      }
      
      public function getBuildingsBufferBar() : BuildingBufferFacade
      {
         return this.viewsGetUiElementBySku("bufferbar") as BuildingBufferFacade;
      }
      
      public function getShipyardBar() : ShipyardBarFacade
      {
         return this.viewsGetUiElementBySku("shipyardBar") as ShipyardBarFacade;
      }
      
      public function getMapViewPlanet() : MapViewPlanet
      {
         return this.viewsGetUiElementBySku("mapPlanet") as MapViewPlanet;
      }
      
      public function getMapViewSolarSystem() : MapViewSolarSystem
      {
         return this.viewsGetUiElementBySku("mapSolarSystem") as MapViewSolarSystem;
      }
      
      public function getMapViewGalaxy() : MapViewGalaxy
      {
         return this.viewsGetUiElementBySku("mapGalaxy") as MapViewGalaxy;
      }
      
      public function getReplayBar() : ReplayBarFacade
      {
         return this.viewsGetUiElementBySku("replayBar") as ReplayBarFacade;
      }
      
      protected function storeMapSolarSystem(viewSku:String) : void
      {
         var mapController:MapControllerSolarSystem = null;
         var sku:String = "mapSolarSystem";
         var element:MapViewSolarSystem;
         if((element = this.viewsGetUiElementBySku(sku) as MapViewSolarSystem) == null)
         {
            (element = new MapViewSolarSystem()).setViewMng(InstanceMng.getViewMngSpace());
            mapController = InstanceMng.getMapControllerSolarSystem();
            element.setMapController(mapController);
            mapController.setMapView(element);
            this.viewsSetUiElement(sku,element);
         }
         this.viewsAddUiElementToView(sku,viewSku);
      }
      
      protected function storeMapGalaxy(viewSku:String) : void
      {
         var sku:String = "mapGalaxy";
         var element:MapViewGalaxy = this.viewsGetUiElementBySku(sku) as MapViewGalaxy;
         if(element == null)
         {
            element = new MapViewGalaxy();
            this.viewsSetUiElement(sku,element);
         }
         this.viewsAddUiElementToView(sku,viewSku);
      }
      
      public function getNavigationBarFacadeIsBuilt() : Boolean
      {
         return false;
      }
      
      protected function getFriendsBar() : FriendsBarFacade
      {
         return this.viewsGetUiElementBySku("friendsbar") as FriendsBarFacade;
      }
      
      public function notifyTutorialEnd() : void
      {
      }
      
      public function notifySetTutorialOptions() : void
      {
      }
      
      public function notifyUnlockSettingsFromAction() : void
      {
      }
      
      protected function getToolBar() : ToolBarFacade
      {
         return InstanceMng.getGUIController().getToolBar();
      }
      
      public function setShowBetIcon() : void
      {
      }
   }
}
