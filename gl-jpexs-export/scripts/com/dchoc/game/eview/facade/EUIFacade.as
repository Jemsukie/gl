package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.hud.HudController;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.hud.EHudCollectionPanel;
   import com.dchoc.game.view.facade.ENavigationBarFacade;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.ESprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class EUIFacade extends UIFacade
   {
       
      
      public function EUIFacade()
      {
         super();
      }
      
      override public function blackStripsShow(hideHud:Boolean) : void
      {
         getTopHudFacade().blackStripsShow(hideHud);
         if(hideHud)
         {
            InstanceMng.getMissionsMng().hideTemporarilyMissionsInHud();
            InstanceMng.getGUIController().hideOpenedBar();
         }
      }
      
      override public function blackStripsHide() : void
      {
         getTopHudFacade().blackStripsHide();
         InstanceMng.getMissionsMng().showBackMissionsInHud();
         friendsBarShow();
         getToolBar().moveAppearDownToUp();
         getNavigationBarFacade().moveAppearDownToUp();
      }
      
      override public function blackStripsToggle() : void
      {
         if(getTopHudFacade().blackStripsAreActive())
         {
            this.blackStripsHide();
         }
         else
         {
            this.blackStripsShow(true);
         }
      }
      
      override public function blackStripsAreActive() : Boolean
      {
         return getTopHudFacade().blackStripsAreActive();
      }
      
      override public function reloadCurrentBottomBar(force:Boolean = false) : void
      {
         var shipyardBar:ShipyardBarFacade = null;
         var shopBar:ShopBarFacade = getBuildingsShopBar() as ShopBarFacade;
         var goOn:Boolean = true;
         if(shopBar != null && shopBar.isVisible())
         {
            shopBar.loadShop();
            goOn = false;
         }
         if(goOn)
         {
            shipyardBar = getShipyardBar() as ShipyardBarFacade;
            if(shipyardBar != null && shipyardBar.isVisible())
            {
               shipyardBar.openShipyardBar();
               goOn = false;
            }
            if(goOn)
            {
               if(InstanceMng.getGUIController().hasLevelChanged(InstanceMng.getUserInfoMng().getProfileLogin()) || force)
               {
                  this.friendsBarReload();
               }
            }
            this.updateWarBars();
         }
      }
      
      override public function updateWarBars() : void
      {
         WarBarFacade(getWarBar()).updateUnits();
      }
      
      override public function friendsBarReload() : void
      {
         var friendsBar:FriendsBarFacade = getFriendsBar() as FriendsBarFacade;
         if(friendsBar != null && friendsBar.isVisible())
         {
            friendsBar.reload();
         }
      }
      
      override public function friendsBarRemoveSelectedNeighbor() : void
      {
      }
      
      override public function getHudBottomLayoutName() : String
      {
         var roleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         var viewId:int = InstanceMng.getApplication().viewGetMode();
         if((roleId == 0 || roleId == 5) && viewId == 0)
         {
            return "LayoutHudBottom";
         }
         return "LayoutHudBottomSmall";
      }
      
      override public function alliancesNotifyWarHasBegun() : void
      {
      }
      
      override public function alliancesNotifyWasHasEnded() : void
      {
      }
      
      override public function showHappeningIcon() : void
      {
         getTopHudFacade().showHudElement("btn_contest");
         getTopHudFacade().showHudElement("text_contest");
         getTopHudFacade().setContestToolButtonUsage("happening");
      }
      
      override public function hideHappeningIcon() : void
      {
         getTopHudFacade().hideHudElement("btn_contest");
         getTopHudFacade().hideHudElement("text_contest");
      }
      
      override public function showContestIcon() : void
      {
         getTopHudFacade().showHudElement("btn_contest");
         getTopHudFacade().showHudElement("text_contest");
         getTopHudFacade().setContestToolButtonUsage("contest");
         getTopHudFacade().updateContestToolButtonIcon();
      }
      
      override public function hideContestIcon() : void
      {
         getTopHudFacade().hideHudElement("btn_contest");
         getTopHudFacade().hideHudElement("text_contest");
      }
      
      override public function setContestIconTip(str:String) : void
      {
         if(str)
         {
            getTopHudFacade().setContestToolTip(str);
         }
         else
         {
            getTopHudFacade().setContestToolTip(" ");
         }
      }
      
      override public function navigationPanelBuild() : void
      {
         getNavigationBarFacade().reloadView();
      }
      
      override public function navigationPanelSetSolarSystemData(starName:String, coords:DCCoordinate) : void
      {
         var navigationBar:ENavigationBarFacade = getNavigationBarFacade();
         if(navigationBar != null)
         {
            navigationBar.setButtonTexts(starName,coords);
         }
      }
      
      override public function alliancesUpdateStarButtons() : Boolean
      {
         (getToolBar() as ToolBarFacade).updateAlliancesButton();
         return true;
      }
      
      override public function alliancesAddHighlightButton() : void
      {
         var params:Dictionary = new Dictionary();
         params["elementName"] = "button_alliances";
         MessageCenter.getInstance().sendMessage("putTutorialCircle",params);
      }
      
      override public function alliancesRemoveHighlightButton() : void
      {
         InstanceMng.getViewMngGame().removeAllHighlights();
      }
      
      override public function hudDisableAttackButton(reason:String) : void
      {
         (getToolBar() as ToolBarFacade).disableAttackButton(reason);
      }
      
      override public function getCollectionPanelPositionAbsolute() : Point
      {
         return this.getPanelPositionAbsolute("CollectionCollection");
      }
      
      override public function collectiblesGetCollectablePosition(sku:String) : int
      {
         return this.getCollectableLogicPositionInPanel(sku,"CollectionCollection");
      }
      
      override public function getCraftingPanelPositionAbsolute() : Point
      {
         return this.getPanelPositionAbsolute("CollectionCrafting");
      }
      
      override public function craftingGetCollectablePosition(sku:String) : int
      {
         return this.getCollectableLogicPositionInPanel(sku,"CollectionCrafting");
      }
      
      override public function getWorkerCollectionPanelPositionAbsolute() : Point
      {
         return this.getPanelPositionAbsolute("CollectionWorker");
      }
      
      override public function workerCollectiblesGetCollectablePosition(sku:String) : int
      {
         return this.getCollectableLogicPositionInPanel(sku,"CollectionWorker");
      }
      
      private function getPanelPositionAbsolute(panelSku:String) : Point
      {
         var returnValue:Point = new Point();
         var s:ESprite = getTopHudFacade().getHudElement(panelSku);
         if(!s)
         {
            return returnValue;
         }
         returnValue = s.getBounds(s).topLeft;
         return s.localToGlobal(returnValue);
      }
      
      private function getCollectableLogicPositionInPanel(collectableSku:String, panelSku:String) : int
      {
         var result:int = 0;
         var panel:EHudCollectionPanel;
         if(panel = getTopHudFacade().getHudElement(panelSku) as EHudCollectionPanel)
         {
            result = panel.getCollectableLogicPosition(collectableSku);
         }
         return result;
      }
      
      override public function getCashContainerPosition() : Point
      {
         var returnValue:Point = new Point();
         var s:ESprite = getTopHudFacade().getHudElement("gold");
         if(!s)
         {
            return returnValue;
         }
         return s.localToGlobal(returnValue);
      }
      
      override public function getContestToolContainerPositionCentered() : Point
      {
         var returnValue:Point = new Point();
         var s:ESprite = getTopHudFacade().getHudElement("btn_contest");
         if(!s)
         {
            return returnValue;
         }
         return s.localToGlobal(returnValue);
      }
      
      override public function getInventoryContainerPositionCentered() : Point
      {
         var returnValue:Point = new Point();
         var s:ESprite = getTopHudFacade().getHudElement("button_inventory");
         if(!s)
         {
            return returnValue;
         }
         returnValue = s.localToGlobal(returnValue);
         returnValue.x -= s.getLogicWidth();
         returnValue.y -= s.getLogicHeight();
         return returnValue;
      }
      
      override protected function viewsStoreUIElements(viewSku:String) : void
      {
         super.viewsStoreUIElements(viewSku);
         var sku:String = "hudController";
         var element:DCComponentUI = viewsGetUiElementBySku(sku);
         if(element == null)
         {
            element = new HudController(getTopHudFacade());
            viewsSetUiElement(sku,element);
         }
         viewsAddUiElementToView(sku,viewSku);
      }
      
      override public function getNavigationBarFacadeIsBuilt() : Boolean
      {
         return getNavigationBarFacade().isBuilt();
      }
      
      protected function getHudController() : HudController
      {
         return viewsGetUiElementBySku("hudController") as HudController;
      }
      
      override public function setShowBetIcon() : void
      {
         var toolbar:ToolBarFacade = getToolBar() as ToolBarFacade;
         toolbar.setShowBetIcon();
      }
   }
}
