package com.dchoc.game.view.dc.facade
{
   import com.dchoc.game.controller.gui.GUIControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.ShipyardBarFacade;
   import com.dchoc.game.eview.facade.ShopBarFacade;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   
   public class DCUIFacade extends UIFacade
   {
       
      
      public function DCUIFacade()
      {
         super();
      }
      
      override public function friendsBarGetDCComponentUI() : DCComponentUI
      {
         return getFriendsBar();
      }
      
      override public function reloadCurrentBottomBar(force:Boolean = false) : void
      {
         var guiController:GUIControllerPlanet = InstanceMng.getGUIControllerPlanet();
         var shopBar:ShopBarFacade = guiController.getShopBar();
         if(shopBar != null && shopBar.isVisible())
         {
            shopBar.reloadResources();
            return;
         }
         var shipyardBar:ShipyardBarFacade;
         if((shipyardBar = guiController.getShipyardBar()) != null && shipyardBar.isVisible())
         {
            shipyardBar.reload();
            return;
         }
         if(getFriendsBar() != null && getFriendsBar().isVisible())
         {
            if(guiController.hasLevelChanged(InstanceMng.getUserInfoMng().getProfileLogin()) || force)
            {
               getFriendsBar().reload();
            }
            return;
         }
         this.warBarReload();
      }
      
      private function warBarReload() : void
      {
         var guiController:GUIControllerPlanet = InstanceMng.getGUIControllerPlanet();
         if(guiController.getWarBar() != null)
         {
            guiController.getWarBar().reload();
         }
         if(guiController.getWarBarSpecial() != null)
         {
            guiController.getWarBarSpecial().reload();
         }
      }
      
      override protected function viewsCreateCommonGUIElementSkus() : void
      {
         viewsAddCommonGUIElementSku("hud");
         viewsAddCommonGUIElementSku("navigationbar");
         viewsAddCommonGUIElementSku("friendsbar");
         viewsAddCommonGUIElementSku("toolbar");
         viewsAddCommonGUIElementSku("cursor");
      }
      
      override public function getNavigationBarFacadeIsBuilt() : Boolean
      {
         return getFriendsBar().isBuilt();
      }
      
      override public function setShowBetIcon() : void
      {
      }
   }
}
