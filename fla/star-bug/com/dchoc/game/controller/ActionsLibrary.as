package com.dchoc.game.controller
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EPopupInventory;
   import com.dchoc.game.eview.widgets.premiumShop.PopupPremiumShop;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class ActionsLibrary extends DCComponent
   {
      
      public static const ACTION_FOLLOW_LINK:String = "followLink";
      
      public static const ACTION_OPEN_FREE_GIFT:String = UserDataMng.KEY_OPEN_FREE_GIFT;
      
      public static const ACTION_OPEN_INVITE_TAB:String = UserDataMng.KEY_OPEN_INVITE_TAB;
      
      public static const ACTION_OPEN_CHIPS_POPUP:String = "openChipsPopup";
      
      public static const ACTION_HIGHLIGHT_ALLIANCES_BUTTON:String = "highlightAlliancesButton";
      
      public static const ACTION_OPEN_INVENTORY:String = "openInventory";
      
      public static const ACTION_USE_ITEM:String = "useItem";
      
      public static const ACTION_OPEN_PREMIUM_SHOP:String = "goToPremiumShop";
      
      public static const ACTION_OPEN_SHOP:String = "goToShop";
      
      public static const ACTION_OPEN_CONTEST:String = "goToContest";
       
      
      public function ActionsLibrary()
      {
         super();
      }
      
      public function launchAction(tag:String, params:Object = null) : void
      {
         var popup:DCIPopup = null;
         var o:Object = null;
         var itemObject:ItemObject = null;
         var from:String = null;
         switch(tag)
         {
            case "followLink":
               if(params.url != null)
               {
                  InstanceMng.getUserDataMng().browserNavigateToUrl(params.url);
               }
               break;
            case ACTION_OPEN_FREE_GIFT:
            case ACTION_OPEN_INVITE_TAB:
               if(params.task != null)
               {
                  InstanceMng.getUserDataMng().requestTask(params.task);
               }
               break;
            case "openChipsPopup":
               InstanceMng.getShopsDrawer().openChipsPopup();
               break;
            case "highlightAlliancesButton":
               InstanceMng.getUIFacade().alliancesAddHighlightButton();
               break;
            case "openInventory":
               popup = InstanceMng.getItemsMng().guiOpenInventoryPopup();
               if(popup != null && params.itemSku != null)
               {
                  if(popup is EPopupInventory)
                  {
                     EPopupInventory(popup).searchItem(params.itemSku);
                  }
               }
               InstanceMng.getGUIControllerPlanet().getToolBar().setStarInventoryVisible();
               break;
            case "useItem":
               if(params != null && params.itemSku != null)
               {
                  if((itemObject = InstanceMng.getItemsMng().getItemObjectBySku(params.itemSku)) != null)
                  {
                     from = "inventory";
                     if(params.from != null)
                     {
                        from = String(params.from);
                     }
                     InstanceMng.getItemsMng().useItemFromInventory(itemObject,null,from);
                  }
               }
               break;
            case "goToPremiumShop":
               popup = InstanceMng.getApplication().shopControllerOpenPopup("premium");
               if(popup != null)
               {
                  if(params.hasOwnProperty("tab"))
                  {
                     PopupPremiumShop(popup).setTabBySku(params.tab);
                  }
                  if(params.hasOwnProperty("item"))
                  {
                     PopupPremiumShop(popup).setPageByItemSku(params.item);
                  }
               }
               break;
            case "goToShop":
               o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_OPENSHOP");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               if(params.hasOwnProperty("tab"))
               {
                  InstanceMng.getGUIControllerPlanet().getShopBar().changeShopBySku(params.tab);
               }
               if(params.hasOwnProperty("item"))
               {
                  InstanceMng.getGUIControllerPlanet().getShopBar().searchItem(params.item);
               }
               break;
            case "goToContest":
         }
      }
   }
}
