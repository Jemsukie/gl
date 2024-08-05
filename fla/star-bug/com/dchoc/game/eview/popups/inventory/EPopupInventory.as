package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.items.CollectablesDef;
   import com.dchoc.game.model.items.CraftingDef;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupInventory extends EGamePopup implements EPaginatorController, INotifyReceiver
   {
      
      protected static const BODY:String = "body";
      
      public static const TAB_CRAFTING:String = "crafting";
      
      public static const TAB_COLLECTION:String = "collectable";
      
      public static const TAB_INVENTORY:String = "inventory";
      
      public static const TAB_ORDER:Array = ["inventory","collectable","crafting"];
      
      private static const TAB_1:String = "tab_1";
      
      private static const TAB_2:String = "tab_2";
      
      private static const TAB_3:String = "tab_3";
      
      private static const TAB_4:String = "tab_4";
      
      protected static const TEXT_WISHLIST:String = "text_title";
      
      protected static const TEXT_WISH_BODY:String = "text_wish";
      
      protected static const IMAGE_STARLING:String = "cbox_img";
      
      protected static const ICON_WISHLIST:String = "icon";
      
      protected static const IMAGE_ARROW:String = "arrow";
      
      protected static const IMAGE_SPEECH_BUBBLE:String = "area_speech";
      
      protected static const AREA_TABS:String = "tabs";
      
      protected static const AREA_TABS_CONTENT:String = "area_tabs_content";
      
      protected static const AREA_SCROLL:String = "area_boxes_items";
      
      protected static const AREA_ITEMS:String = "container_items";
      
      protected static const BODY_CONTAINER:String = "body_container";
      
      protected static const CONTENT_WISHLIST:String = "content_wishlist";
      
      private static const CONTENT:String = "CONTENT";
      
      private static const INVENTORY_ITEMS_PER_ROW:int = 6;
      
      private static const NUM_WISHLIST_ITEMS:int = 3;
       
      
      private var mTabHeaders:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mInventoryRowWidth:int;
      
      private var mInventoryRowHeight:int;
      
      private var mSkinRowWidth:int;
      
      private var mSkinRowHeight:int;
      
      private var mStarIconAmount:Vector.<int>;
      
      private var mNewProgressItemsSkus:Vector.<Vector.<String>>;
      
      private var mScrollArea:ELayoutArea;
      
      protected var mCurrentPage:int = -1;
      
      private var mTabs:Dictionary;
      
      private var mItemsAreLocked:Boolean = false;
      
      public function EPopupInventory()
      {
         var i:int = 0;
         super();
         this.mNewProgressItemsSkus = new Vector.<Vector.<String>>(TAB_ORDER.length);
         for(i = 0; i < this.mNewProgressItemsSkus.length; )
         {
            this.mNewProgressItemsSkus[i] = new Vector.<String>(0);
            i++;
         }
         MessageCenter.getInstance().registerObject(this);
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var imageArea:ELayoutArea = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutInventory");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         var content:ESprite = viewFactory.getESprite(skinId);
         setContent("CONTENT",content);
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = viewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         setTitleText(DCTextMng.getText(615));
         bkg.eAddChild(getTitle());
         var speechBox:ESprite = mViewFactory.getSpeechBubble(popupLayoutFactory.getArea("area_speech"),popupLayoutFactory.getArea("area_speech"),null,mSkinSku,"speech_color",false);
         content.eAddChild(speechBox);
         setContent("area_speech",speechBox);
         var speechArrow:EImage = mViewFactory.getEImage("speech_arrow",mSkinSku,false,popupLayoutFactory.getArea("arrow"),"speech_color");
         content.eAddChild(speechArrow);
         setContent("arrow",speechArrow);
         var speechContent:ESpriteContainer = this.createSpeechContent(popupLayoutFactory);
         content.eAddChild(speechContent);
         setContent("content_wishlist",speechContent);
         imageArea = popupLayoutFactory.getArea("cbox_img");
         var starling:EImage = mViewFactory.getEImage("inventory_normal",mSkinSku,false,imageArea);
         content.eAddChild(starling);
         setContent("cbox_img",starling);
         var bodyContainer:ESprite = mViewFactory.getESprite(mSkinSku);
         content.eAddChild(bodyContainer);
         setContent("body_container",bodyContainer);
         var body:ESprite = mViewFactory.getEImage("tabBody",mSkinSku,false,popupLayoutFactory.getArea("area_tabs_content"));
         bodyContainer.eAddChild(body);
         setContent("area_tabs_content",body);
         area = popupLayoutFactory.getArea("tabs");
         var tabs:Vector.<EButton> = new Vector.<EButton>(0);
         var tab:EButton;
         (tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(616))).name = "tab_1";
         tabs.push(tab);
         bodyContainer.eAddChild(tab);
         setContent("tab_1",tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(617));
         tabs.push(tab);
         tab.name = "tab_2";
         bodyContainer.eAddChild(tab);
         setContent("tab_2",tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(618));
         tabs.push(tab);
         tab.name = "tab_3";
         bodyContainer.eAddChild(tab);
         setContent("tab_3",tab);
         this.mTabHeaders = new TabHeadersView(area,mViewFactory,mSkinSku);
         this.mTabHeaders.setTabHeaders(tabs);
         this.mPaginatorComponent = new EPaginatorComponent();
         this.mPaginatorComponent.init(this.mTabHeaders,this);
         this.mTabHeaders.setPaginatorComponent(this.mPaginatorComponent);
         this.tabsCreateIcons(tabs);
         this.verifyProgressItems();
         area = popupLayoutFactory.getArea("area_boxes_items");
         this.mInventoryRowWidth = area.width;
         this.mInventoryRowHeight = area.height / 2;
         this.mSkinRowWidth = area.width;
         this.mSkinRowHeight = area.height;
         this.mScrollArea = popupLayoutFactory.getArea("area_boxes_items");
         this.setPageByTabSku("inventory");
         bkg.eAddChild(content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",this.notifyPopupMngClose);
         this.fillWishlist();
      }
      
      private function verifyProgressItems() : void
      {
         var unseenItem:ItemObject = null;
         var inventoryItems:Vector.<ItemObject> = InstanceMng.getItemsMng().getMenuList("inventory");
         var collectionItems:Vector.<ItemObject> = InstanceMng.getItemsMng().getMenuList("collectable");
         var craftItems:Vector.<ItemObject> = InstanceMng.getItemsMng().getMenuList("crafting");
         var unseenAmount:int = 0;
         for each(unseenItem in inventoryItems)
         {
            if(unseenItem.mVisualStarIconAmount.value)
            {
               unseenAmount += unseenItem.mVisualStarIconAmount.value;
               if(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("inventory")].indexOf(unseenItem.mDef.getSku()) < 0)
               {
                  this.mNewProgressItemsSkus[TAB_ORDER.indexOf("inventory")].push(unseenItem.mDef.getSku());
               }
            }
         }
         this.tabsSetStarIcon(TAB_ORDER.indexOf("inventory"),unseenAmount > 0,unseenAmount);
         unseenAmount = 0;
         for each(unseenItem in collectionItems)
         {
            if(unseenItem.mVisualStarIconAmount.value)
            {
               unseenAmount += unseenItem.mVisualStarIconAmount.value;
               if(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("collectable")].indexOf(unseenItem.mDef.getSku()) < 0)
               {
                  this.mNewProgressItemsSkus[TAB_ORDER.indexOf("collectable")].push(unseenItem.mDef.getSku());
               }
            }
         }
         this.tabsSetStarIcon(TAB_ORDER.indexOf("collectable"),unseenAmount > 0,unseenAmount);
         unseenAmount = 0;
         for each(unseenItem in craftItems)
         {
            if(unseenItem.mVisualStarIconAmount.value)
            {
               unseenAmount += unseenItem.mVisualStarIconAmount.value;
               if(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("crafting")].indexOf(unseenItem.mDef.getSku()) < 0)
               {
                  this.mNewProgressItemsSkus[TAB_ORDER.indexOf("crafting")].push(unseenItem.mDef.getSku());
               }
            }
         }
         this.tabsSetStarIcon(TAB_ORDER.indexOf("crafting"),unseenAmount > 0,unseenAmount);
      }
      
      private function markItemsAsSeenPerPageId(id:int) : void
      {
         var item:ItemObject = null;
         var listId:String = String(TAB_ORDER[id]);
         var items:Vector.<ItemObject> = InstanceMng.getItemsMng().getMenuList(listId);
         for each(item in items)
         {
            item.mVisualStarIconAmount.value = 0;
         }
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         InstanceMng.getItemsMng().guiCloseInventoryPopup();
      }
      
      override protected function extendedDestroy() : void
      {
         var vec:Vector.<String> = null;
         MessageCenter.getInstance().unregisterObject(this);
         this.destroyTabs();
         this.mTabHeaders = null;
         this.mPaginatorComponent = null;
         this.mScrollArea = null;
         for each(vec in this.mNewProgressItemsSkus)
         {
            vec.length = 0;
         }
         this.mNewProgressItemsSkus.length = 0;
         this.mNewProgressItemsSkus = null;
         super.extendedDestroy();
      }
      
      private function tabsCreateIcons(buttons:Vector.<EButton>) : void
      {
         var i:int = 0;
         var btn:EButton = null;
         var layoutAreaCopy:ELayoutArea = null;
         var notification:ESpriteContainer = null;
         this.mStarIconAmount = new Vector.<int>(0);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("TabHeader");
         for(i = 0; i < buttons.length; )
         {
            btn = buttons[i];
            layoutAreaCopy = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("notification_area"));
            layoutAreaCopy.x = btn.width - (layoutFactory.getArea("base").width - layoutFactory.getArea("notification_area").x);
            notification = mViewFactory.getNotificationArea(mSkinSku,layoutAreaCopy);
            notification.visible = false;
            btn.eAddChild(notification);
            setContent("notification" + i,notification);
            this.mStarIconAmount.push(0);
            i++;
         }
      }
      
      private function incrementStarIconAmountByTabIdx(tab:int, amount:int = 1) : void
      {
         var value:int;
         var visible:* = (value = this.mStarIconAmount[tab] + amount) > 0;
         this.tabsSetStarIcon(tab,visible,value);
      }
      
      public function incrementStarIconAmountByTabName(tab:String, amount:int = 1) : void
      {
         var idx:int = TAB_ORDER.indexOf(tab);
         if(idx > -1)
         {
            this.incrementStarIconAmountByTabIdx(idx,amount);
         }
      }
      
      private function resetStarIconAmountByTabIdx(tab:int) : void
      {
         this.tabsSetStarIcon(tab,false,0);
      }
      
      public function resetStarIconAmountByTabName(tab:int) : void
      {
         var idx:int = TAB_ORDER.indexOf(tab);
         if(idx > -1)
         {
            this.resetStarIconAmountByTabIdx(idx);
         }
      }
      
      public function resetStarCurrentTab() : void
      {
         this.resetStarIconAmountByTabIdx(this.mCurrentPage);
      }
      
      private function tabsSetStarIcon(tab:int, _visible:Boolean, amount:int) : void
      {
         var star:ESpriteContainer;
         if(star = getContent("notification" + tab) as ESpriteContainer)
         {
            star.visible = _visible;
            this.mStarIconAmount[tab] = amount;
            star.getContentAsETextField("text").setText("" + amount);
         }
      }
      
      private function destroyTabs() : void
      {
         var tab:* = null;
         for(tab in this.mTabs)
         {
            this.mTabs[tab].destroy();
            delete this.mTabs[tab];
         }
      }
      
      private function getTabNumScrollableItems(page:String) : int
      {
         var returnValue:int = 0;
         switch(page)
         {
            case "inventory":
               returnValue = Math.ceil(InstanceMng.getItemsMng().getInventoryItems().length / 6);
               break;
            case "crafting":
               returnValue = int(InstanceMng.getItemsMng().getCraftingGroups().length);
               break;
            case "collectable":
               returnValue = int(InstanceMng.getItemsMng().getCollections().length);
         }
         return returnValue;
      }
      
      private function createTabContents(visibleArea:ELayoutArea, page:String) : void
      {
         var numScrollableItems:int = 0;
         var collectionLayoutArea:ELayoutArea;
         (collectionLayoutArea = new ELayoutArea()).width = visibleArea.width;
         collectionLayoutArea.height = visibleArea.height;
         this.destroyTabs();
         this.mTabs = new Dictionary();
         numScrollableItems = this.getTabNumScrollableItems(page);
         switch(page)
         {
            case "inventory":
               this.mTabs["inventory"] = new EScrollArea();
               this.mTabs["inventory"].build(visibleArea,numScrollableItems,ESpriteContainer,this.fillInventoryData);
               setContent("inventory",this.mTabs["inventory"]);
               break;
            case "crafting":
               this.mTabs["crafting"] = new EScrollArea();
               this.mTabs["crafting"].build(visibleArea,numScrollableItems,ESpriteContainer,this.fillCraftingData);
               setContent("crafting",this.mTabs["crafting"]);
               break;
            case "collectable":
               this.mTabs["collectable"] = new EScrollArea();
               this.mTabs["collectable"].build(visibleArea,numScrollableItems,ESpriteContainer,this.fillCollectionData);
               setContent("collectable",this.mTabs["collectable"]);
         }
         var content:ESprite;
         (content = getContent("CONTENT")).eAddChild(this.mTabs[page]);
         mViewFactory.getEScrollBar(this.mTabs[page]);
      }
      
      private function createSpeechContent(popupLayoutFactory:ELayoutAreaFactory) : ESpriteContainer
      {
         var i:int = 0;
         var itemContainer:EWishlistItemView = null;
         var content:ESpriteContainer = mViewFactory.getESpriteContainer();
         var textArea:ELayoutTextArea = popupLayoutFactory.getTextArea("text_title");
         var textField:ETextField;
         (textField = mViewFactory.getETextField(mSkinSku,textArea)).setText(DCTextMng.getText(621));
         textField.applySkinProp(mSkinSku,"text_title_1");
         content.eAddChild(textField);
         content.setContent("text_title",textField);
         var icon:EImage = mViewFactory.getEImage("icon_wishlist",mSkinSku,false,popupLayoutFactory.getArea("icon"));
         content.eAddChild(icon);
         content.setContent("icon",icon);
         textArea = popupLayoutFactory.getTextArea("text_wish");
         (textField = mViewFactory.getETextField(mSkinSku,textArea)).setText(DCTextMng.getText(622));
         textField.applySkinProp(mSkinSku,"text_body");
         content.eAddChild(textField);
         content.setContent("text_wish",textField);
         var boxes:Array = [];
         var auxContent:ESpriteContainer = mViewFactory.getESpriteContainer();
         for(i = 0; i < 3; )
         {
            itemContainer = new EWishlistItemView();
            itemContainer.build();
            auxContent.eAddChild(itemContainer);
            content.setContent("itemContainer" + i,itemContainer);
            boxes.push(itemContainer);
            i++;
         }
         var boxesArea:ELayoutArea = popupLayoutFactory.getArea("container_items");
         mViewFactory.distributeSpritesInArea(boxesArea,boxes,0,0,-1,1,false);
         auxContent.setLayoutArea(boxesArea,true);
         content.eAddChild(auxContent);
         content.setContent("container_items",auxContent);
         return content;
      }
      
      public function searchItem(sku:String) : void
      {
         var itemDef:ItemsDef = null;
         var itemObject:ItemObject = InstanceMng.getItemsMng().getItemObjectBySku(sku);
         var tab:String = "inventory";
         if(itemObject != null)
         {
            itemDef = itemObject.mDef;
            if(itemDef.getMenusList().indexOf("collectable") > -1)
            {
               tab = "collectable";
            }
            else if(itemDef.getMenusList().indexOf("crafting") > -1)
            {
               tab = "crafting";
            }
            this.setPageByTabSku(tab);
            this.reloadView();
         }
      }
      
      private function fillInventoryData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:EInventoryItemView = null;
         var i:int = 0;
         var xOffset:int = 0;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as EInventoryItemView).destroy();
            }
            for(i = 0; i < 6; )
            {
               (itemContainer = new EInventoryItemView()).build();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               i++;
            }
         }
         var items:Vector.<ItemObject> = InstanceMng.getItemsMng().getInventoryItems();
         i = rowOffset * 6;
         while(i < (rowOffset + 1) * 6 && i < items.length)
         {
            (itemContainer = spriteReference.getChildAt(i % 6) as EInventoryItemView).visible = true;
            itemContainer.fillData(items[i]);
            itemContainer.setIsNewItem(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("inventory")].lastIndexOf(items[i].mDef.getSku()) >= 0);
            xOffset = (this.mInventoryRowWidth - 6 * itemContainer.getLogicWidth()) / (6 + 1);
            itemContainer.logicLeft = i % 6 * (itemContainer.getLogicWidth() + xOffset) + xOffset;
            itemContainer.logicTop = (this.mInventoryRowHeight - itemContainer.getLogicHeight()) / 2;
            i++;
         }
         while(i < (rowOffset + 1) * 6)
         {
            (itemContainer = spriteReference.getChildAt(i % 6) as EInventoryItemView).visible = false;
            i++;
         }
      }
      
      private function fillCollectionData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:ECraftingItemView = null;
         var rewardContainer:ERewardItemView = null;
         var i:int = 0;
         var xOffset:int = 0;
         var collections:Vector.<Array>;
         var collection:Array = (collections = InstanceMng.getItemsMng().getCollections())[rowOffset];
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as ECraftingItemView).destroy();
            }
            for(i = 0; i < collection.length - 1; )
            {
               (itemContainer = new ECraftingItemView()).build();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               i++;
            }
            (rewardContainer = new ERewardItemView()).build();
            spriteReference.eAddChild(rewardContainer);
            spriteReference.setContent("itemContainer" + i,rewardContainer);
         }
         var craftingSku:String = collection.splice(0,1);
         var reward:RewardObject;
         if(reward = InstanceMng.getItemsMng().getCollectionReward(craftingSku))
         {
            collection.push(reward.getItem());
         }
         i = 0;
         while(i < collection.length - 1)
         {
            (itemContainer = spriteReference.getChildAt(i) as ECraftingItemView).setGroupSku(craftingSku);
            itemContainer.fillData(collection[i]);
            itemContainer.setIsNewItem(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("collectable")].lastIndexOf(collection[i].mDef.getSku()) >= 0);
            itemContainer.setActionButtonActive(true);
            xOffset = (this.mInventoryRowWidth - collection.length * itemContainer.getLogicWidth()) / (collection.length + 1);
            itemContainer.logicLeft = i * (itemContainer.getLogicWidth() + xOffset) + xOffset;
            itemContainer.logicTop = (this.mInventoryRowHeight - itemContainer.getLogicHeight()) / 2;
            i++;
         }
         (rewardContainer = spriteReference.getChildAt(i) as ERewardItemView).fillData(collection[i]);
         rewardContainer.setActionButtonActive(InstanceMng.getItemsMng().isCollectionRewardApplicable(craftingSku));
         xOffset = (this.mInventoryRowWidth - collection.length * rewardContainer.getLogicWidth()) / (collection.length + 1);
         rewardContainer.logicLeft = i * (rewardContainer.getLogicWidth() + xOffset) + xOffset;
         rewardContainer.logicTop = (this.mInventoryRowHeight - rewardContainer.getLogicHeight()) / 2;
      }
      
      private function fillCraftingData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:ECraftingItemView = null;
         var rewardContainer:ERewardItemView = null;
         var i:int = 0;
         var xOffset:int = 0;
         var craftingGroups:Vector.<Array>;
         var group:Array = (craftingGroups = InstanceMng.getItemsMng().getCraftingGroups())[rowOffset];
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as ECraftingItemView).destroy();
            }
            for(i = 0; i < group.length - 1; )
            {
               (itemContainer = new ECraftingItemView()).build();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               i++;
            }
            (rewardContainer = new ERewardItemView()).build();
            spriteReference.eAddChild(rewardContainer);
            spriteReference.setContent("itemContainer" + i,rewardContainer);
         }
         var craftingSku:String = group.splice(0,1);
         var reward:RewardObject;
         if(reward = InstanceMng.getItemsMng().getCraftingReward(craftingSku))
         {
            group.push(reward.getItem());
         }
         i = 0;
         while(i < group.length - 1)
         {
            (itemContainer = spriteReference.getChildAt(i) as ECraftingItemView).setGroupSku(craftingSku);
            itemContainer.fillData(group[i]);
            itemContainer.setActionButtonActive(true);
            itemContainer.setIsNewItem(this.mNewProgressItemsSkus[TAB_ORDER.indexOf("crafting")].lastIndexOf(group[i].mDef.getSku()) >= 0);
            xOffset = (this.mInventoryRowWidth - group.length * itemContainer.getLogicWidth()) / (group.length + 1);
            itemContainer.logicLeft = i * (itemContainer.getLogicWidth() + xOffset) + xOffset;
            itemContainer.logicTop = (this.mInventoryRowHeight - itemContainer.getLogicHeight()) / 2;
            i++;
         }
         (rewardContainer = spriteReference.getChildAt(i) as ERewardItemView).fillData(group[i]);
         rewardContainer.setActionButtonActive(InstanceMng.getItemsMng().isCraftingRewardApplicable(craftingSku));
         xOffset = (this.mInventoryRowWidth - group.length * rewardContainer.getLogicWidth()) / (group.length + 1);
         rewardContainer.logicLeft = i * (rewardContainer.getLogicWidth() + xOffset) + xOffset;
         rewardContainer.logicTop = (this.mInventoryRowHeight - rewardContainer.getLogicHeight()) / 2;
      }
      
      private function fillWishlist() : void
      {
         var itemContainer:EWishlistItemView = null;
         var i:int = 0;
         var wishlist:Vector.<ItemObject> = InstanceMng.getItemsMng().getWishList();
         i = 0;
         while(i < 3 && i < wishlist.length)
         {
            itemContainer = ESpriteContainer(getContent("content_wishlist")).getContent("itemContainer" + i) as EWishlistItemView;
            itemContainer.fillData(wishlist[i]);
            itemContainer.setContentVisibility(true);
            i++;
         }
         while(i < 3)
         {
            itemContainer = ESpriteContainer(getContent("content_wishlist")).getContent("itemContainer" + i) as EWishlistItemView;
            itemContainer.setContentVisibility(false);
            i++;
         }
      }
      
      public function setPageByTabSku(tabSku:String) : void
      {
         var tabId:int = TAB_ORDER.lastIndexOf(tabSku);
         if(tabId >= 0)
         {
            this.setPageId(null,tabId);
         }
      }
      
      public function getCurrentTabSku() : String
      {
         return TAB_ORDER[this.mCurrentPage];
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         if(this.mCurrentPage != id)
         {
            if(id >= 0 && id < TAB_ORDER.length)
            {
               this.createTabContents(this.mScrollArea,TAB_ORDER[id]);
               this.markItemsAsSeenPerPageId(id);
               MessageCenter.getInstance().sendMessage("updateInventoryNotifications");
               this.resetStarIconAmountByTabIdx(id);
            }
            this.mCurrentPage = id;
            this.mTabHeaders.setPageId(id);
         }
      }
      
      public function reloadView() : void
      {
         var k:* = null;
         var tab:EScrollArea = null;
         var tabSku:String = null;
         this.fillWishlist();
         for(k in this.mTabs)
         {
            tabSku = k as String;
            tab = this.mTabs[tabSku] as EScrollArea;
            tab.reloadView(this.getTabNumScrollableItems(tabSku));
         }
         MessageCenter.getInstance().sendMessage("updateInventoryNotifications");
      }
      
      private function tradeCollection(rewardSku:String, showPopup:Boolean = true, forceAmountText:int = 0) : void
      {
         var collectionName:* = null;
         var collection:CollectablesDef = null;
         var menu:String = null;
         var crafting:CraftingDef = null;
         var craftingSku:String = null;
         var craftingReward:RewardObject = null;
         var collectionSku:String = InstanceMng.getItemsMng().getCollectionIdByCollectableRewardSku(rewardSku);
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(collectionSku)
         {
            InstanceMng.getItemsMng().applyCollectionReward(collectionSku);
            menu = InstanceMng.getItemsMng().getItemMenuByCraftingOrCollection(collectionSku,false);
            if(Config.USE_METRICS)
            {
               if((collection = InstanceMng.getCollectablesDefMng().getDefBySku(collectionSku) as CollectablesDef) != null)
               {
                  collectionName = collection.getCollectionName();
               }
               if(collectionName == "")
               {
                  collectionName = collectionSku;
               }
               DCMetrics.sendMetric("Collection Completed",null,collectionName);
            }
            if(showPopup)
            {
               notificationsMng.guiOpenTradeInPopup("collection",InstanceMng.getItemsMng().getCollectionReward(collectionSku),false,null,false,null,null,forceAmountText);
            }
         }
         else
         {
            craftingSku = InstanceMng.getItemsMng().getCraftingIdByItemRewardSku(rewardSku);
            craftingReward = InstanceMng.getItemsMng().getCraftingReward(craftingSku);
            InstanceMng.getItemsMng().applyCraftingReward(craftingSku);
            menu = InstanceMng.getItemsMng().getItemMenuByCraftingOrCollection(craftingSku);
            if(Config.USE_METRICS)
            {
               if((crafting = InstanceMng.getCraftingDefMng().getDefBySku(craftingSku) as CraftingDef) != null)
               {
                  collectionName = crafting.getCollectionName();
               }
               if(collectionName == "")
               {
                  collectionName = collectionSku;
               }
               DCMetrics.sendMetric("Collection Completed",null,collectionName);
            }
            if(showPopup)
            {
               notificationsMng.guiOpenTradeInPopup("crafting",craftingReward,false,null,false,null,null,forceAmountText);
            }
         }
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
      
      public function getName() : String
      {
         return "PopupInventory";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["reloadInventory","tradeCollection","lockInventoryItems","unlockInventoryItems","mysteryCubeOpened"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var inventoryItemViewsVector:* = undefined;
         var itemView:* = null;
         var showPopup:Boolean = false;
         var forceAmountText:int = 0;
         switch(task)
         {
            case "reloadInventory":
               this.reloadView();
               this.verifyProgressItems();
               if(this.mItemsAreLocked)
               {
                  this.onMessage("lockInventoryItems",null);
               }
               break;
            case "tradeCollection":
               showPopup = true;
               if(params.hasOwnProperty("showPopup"))
               {
                  showPopup = Boolean(params["showPopup"]);
               }
               if(params.hasOwnProperty("forceAmountText"))
               {
                  forceAmountText = int(params["forceAmountText"]);
               }
               this.tradeCollection(params["rewardSku"],showPopup,forceAmountText);
               this.mTabs[TAB_ORDER[this.mCurrentPage]].reloadView();
               break;
            case "lockInventoryItems":
               this.mItemsAreLocked = true;
               inventoryItemViewsVector = this.getInventoryItemViewsVector();
               for each(itemView in inventoryItemViewsVector)
               {
                  itemView.setActionButtonActive(false);
                  itemView.setCloseButtonActive(false);
               }
               break;
            case "unlockInventoryItems":
               this.mItemsAreLocked = false;
               inventoryItemViewsVector = this.getInventoryItemViewsVector();
               for each(itemView in inventoryItemViewsVector)
               {
                  itemView.setActionButtonActive(true);
                  itemView.setCloseButtonActive(true);
               }
               break;
            case "mysteryCubeOpened":
               this.onMessage("unlockInventoryItems",null);
               this.onMessage("reloadInventory",null);
         }
      }
      
      private function getInventoryItemViewsVector() : Vector.<EInventoryItemView>
      {
         var scrollElements:* = undefined;
         var scrollArea:EScrollArea = null;
         var rowContainer:* = null;
         var itemView:EInventoryItemView = null;
         var i:int = 0;
         var returnValue:Vector.<EInventoryItemView> = new Vector.<EInventoryItemView>(0);
         scrollArea = getContent("inventory") as EScrollArea;
         if(scrollArea != null)
         {
            scrollElements = scrollArea.getElements();
         }
         if(TAB_ORDER[this.mCurrentPage] == "inventory" && scrollElements != null)
         {
            for each(rowContainer in scrollElements)
            {
               if(rowContainer != null)
               {
                  i = 0;
                  while(i < rowContainer.numChildren)
                  {
                     if((itemView = EInventoryItemView(rowContainer.getChildAt(i))) != null)
                     {
                        returnValue.push(itemView);
                     }
                     i++;
                  }
               }
            }
         }
         return returnValue;
      }
   }
}
