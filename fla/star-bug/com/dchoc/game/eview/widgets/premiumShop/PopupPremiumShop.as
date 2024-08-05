package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.controller.shop.ShopController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.shop.PurchaseShopDef;
   import com.dchoc.game.model.shop.ShopDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class PopupPremiumShop extends EGamePopup implements EPaginatorController
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const TAB_CONTENT:String = "tab_content";
      
      private static const TAB_CONTENT_CLOCK:String = "tab_content_clock";
      
      private static const TAB_CONTENT_OFFER:String = "tab_content_offer";
      
      private static const TAB_BUTTON:String = "tab_button";
       
      
      private var mShopController:ShopController;
      
      private var mTabHeader:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mCurrentPageName:String = "";
      
      private var mSetPageIdCRMLabel:String;
      
      private var mStarIconAmount:Vector.<int>;
      
      public function PopupPremiumShop()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mTabHeader = null;
         this.mPaginatorComponent = null;
      }
      
      public function extendedSetup(popupId:String, viewFactory:ViewFactory, skinId:String, shopController:ShopController) : void
      {
         this.mShopController = shopController;
         super.setup(popupId,viewFactory,skinId);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter");
         setLayoutArea(layoutFactory.getArea("bg"));
         var bkg:EImage = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(bkg);
         setBackground(bkg);
         var field:ETextField;
         (field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"))).applySkinProp(mSkinSku,"text_title_0");
         bkg.eAddChild(field);
         setTitle(field);
         var purchaseShopDef:PurchaseShopDef = this.mShopController.getPurchaseShopDef();
         setTitleText(DCTextMng.getText(purchaseShopDef.getTitleTID()));
         var areaBody:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("body"));
         var body:ESprite = mViewFactory.getEImage("tabBody",mSkinSku,false,areaBody);
         bkg.eAddChild(body);
         setContent("body",body);
         var button:EButton = mViewFactory.getButtonClose(skinId,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         var page:TabBodyPremiumShop;
         (page = new TabBodyPremiumShop(mViewFactory,mSkinSku,true)).setup();
         setContent("tab_content",page);
         (page = new TabBodyPremiumShopClock(mViewFactory,mSkinSku)).setup();
         setContent("tab_content_clock",page);
         (page = new TabBodyPremiumShopOffer(mViewFactory,mSkinSku)).setup();
         setContent("tab_content_offer",page);
         this.createTabs(layoutFactory.getArea("tab"));
         this.mSetPageIdCRMLabel = "Opened";
         this.setPageId(null,0);
         this.mSetPageIdCRMLabel = "Tab";
         this.setupNotificationsVisible();
      }
      
      private function createTabs(tabArea:ELayoutArea) : void
      {
         var shopDef:ShopDef = null;
         var tabsCount:int = 0;
         var tabButton:EButton = null;
         var bkg:ESprite = null;
         var tabs:Vector.<EButton> = null;
         var i:int = 0;
         var tabsInfo:Vector.<DCDef>;
         if((tabsInfo = this.mShopController.getShopDefs()) != null)
         {
            tabsCount = int(tabsInfo.length);
            bkg = getBackground();
            tabs = new Vector.<EButton>(0);
            for(i = 0; i < tabsCount; )
            {
               if(!((shopDef = tabsInfo[i] as ShopDef).getIsServerProvided() && InstanceMng.getUpSellingMng().getPremiumShopOffer(shopDef.getSku()) == null))
               {
                  tabButton = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(TextIDs[shopDef.getTabTitleTID()]),mSkinSku);
                  setContent("tab_button" + i,tabButton);
                  bkg.eAddChild(tabButton);
                  tabs[i] = tabButton;
               }
               i++;
            }
            this.mTabHeader = new TabHeadersView(tabArea,mViewFactory,mSkinSku);
            this.mTabHeader.setTabHeaders(tabs);
            this.mPaginatorComponent = new EPaginatorComponent();
            this.mPaginatorComponent.init(this.mTabHeader,this);
            this.mTabHeader.setPaginatorComponent(this.mPaginatorComponent);
            this.tabsCreateIcons(tabs);
         }
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
      
      private function setupNotificationsVisible() : void
      {
         var i:int = 0;
         var shopProgressSku:String = null;
         var shopDef:ShopDef = null;
         var found:Boolean = false;
         var itemDef:ItemsDef = null;
         var items:Vector.<String> = this.mShopController.getBlinkingShopProgressSkus();
         var tabInfo:Vector.<DCDef> = this.mShopController.getShopDefs();
         for(i = 0; i < tabInfo.length; )
         {
            this.tabsSetStarIcon(i,false,0);
            i++;
         }
         for each(shopProgressSku in items)
         {
            for(i = 0; i < tabInfo.length; )
            {
               shopDef = tabInfo[i] as ShopDef;
               found = false;
               for each(itemDef in shopDef.getTabContent())
               {
                  if(itemDef.getShopProgressSku() == shopProgressSku)
                  {
                     this.tabsSetStarIcon(i,true,1);
                     break;
                  }
               }
               i++;
            }
         }
      }
      
      private function verifyProgressItems() : void
      {
         var shopProgressSku:String = null;
         var shopDef:ShopDef = null;
         var found:Boolean = false;
         var itemDef:ItemsDef = null;
         var items:Vector.<String> = this.mShopController.getBlinkingShopProgressSkus();
         var tabInfo:Vector.<DCDef> = this.mShopController.getShopDefs();
         this.tabsSetStarIcon(this.mCurrentPage,false,0);
         for each(shopProgressSku in items)
         {
            shopDef = tabInfo[this.mCurrentPage] as ShopDef;
            found = false;
            for each(itemDef in shopDef.getTabContent())
            {
               if(itemDef.getShopProgressSku() == shopProgressSku)
               {
                  this.mShopController.setUserSawBlinkingShopProgress(shopProgressSku);
                  break;
               }
            }
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var tabsInfo:Vector.<DCDef> = null;
         var useClock:Boolean = false;
         var useOffer:Boolean = false;
         var page:TabBodyPremiumShop = null;
         var body:ESprite = null;
         var info:ShopDef = null;
         var purchaseShopDef:PurchaseShopDef = null;
         var product:String = null;
         if(this.mCurrentPage != id)
         {
            tabsInfo = this.mShopController.getShopDefs();
            body = getContent("body");
            if(this.mCurrentPage > -1)
            {
               page = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
               body.eRemoveChild(page);
            }
            this.mCurrentPage = id;
            useClock = (info = tabsInfo[this.mCurrentPage] as ShopDef).needsToShowClock();
            useOffer = info.containsOffer();
            if(useClock)
            {
               this.mCurrentPageName = "tab_content_clock";
            }
            else if(useOffer)
            {
               this.mCurrentPageName = "tab_content_offer";
            }
            else
            {
               this.mCurrentPageName = "tab_content";
            }
            page = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
            body.eAddChild(page);
            page.setShopDef(info);
            page.setupHeader(DCTextMng.getText(TextIDs[info.getTabDescTID()]),"text_body_2");
            this.mTabHeader.setPageId(this.mCurrentPage);
            if(Config.USE_METRICS)
            {
               purchaseShopDef = this.mShopController.getPurchaseShopDef();
               product = String(this.mSetPageIdCRMLabel == "Tab" ? info.getSku() : null);
               DCMetrics.sendMetric(purchaseShopDef.getEventTypeCRM(),this.mSetPageIdCRMLabel,product);
            }
            this.verifyProgressItems();
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var content:ESpriteContainer = getContentAsESpriteContainer("tab_content");
         if(content != null)
         {
            content.logicUpdate(dt);
         }
      }
      
      public function buyWithCreditsPerformed() : void
      {
         var page:TabBodyPremiumShop = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
         page.buyWithCreditsPerformed();
      }
      
      public function setPageByItemOrder(itemOrder:int) : void
      {
         var page:TabBodyPremiumShop = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
         page.setPageByItemOrder(itemOrder);
      }
      
      public function setPageByItemSku(itemSku:String) : void
      {
         var page:TabBodyPremiumShop = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
         page.setPageByItemSku(itemSku);
      }
      
      public function setTabBySku(tabSku:String) : void
      {
         var i:int = 0;
         var tabsInfo:Vector.<DCDef>;
         var tabsCount:int = int((tabsInfo = this.mShopController.getShopDefs()).length);
         var tab:* = 0;
         for(i = 0; i < tabsCount; )
         {
            if(tabsInfo[i].mSku == tabSku)
            {
               tab = i;
               break;
            }
            i++;
         }
         this.setPageId(null,tab);
      }
   }
}
