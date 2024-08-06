package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.shop.ShopDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import esparragon.display.EScrollArea;
   import esparragon.display.EScrollBar;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   
   public class TabBodyPremiumShop extends ESpriteContainer
   {
      
      private static const BOX_CONTENT:String = "box_";
      
      private static const PAGINATOR:String = "paginator";
      
      private static const HEADER:String = "header";
      
      public static const TIME_TO_WAIT:int = 1000;
      
      private static const topArrow:int = 0;
      
      private static const bottomArrow:int = 1;
      
      private static const barBg:int = 2;
      
      private static const bar:int = 3;
       
      
      private const NUM_ITEMS_PER_ROW:int = 3;
      
      private const NUM_ITEMS_PER_COL:int = 2;
      
      protected var MAX_BOXES:int = 6;
      
      protected var mViewFactory:ViewFactory;
      
      protected var mSkinSku:String;
      
      protected var mInfo:Vector.<ItemsDef>;
      
      protected var mBoxes:Array;
      
      protected var mBodyArea:ELayoutArea;
      
      protected var mBody:ESprite;
      
      protected var mBodyRows:int;
      
      protected var mBodyCols:int;
      
      private var mHeaderArea:ELayoutArea;
      
      private var mHeaderContent:ESprite;
      
      protected var mBoxBought:PremiumShopBox;
      
      protected var mItemBought:ItemsDef;
      
      private var mTimerToChangeHeader:int;
      
      protected var mTimerOnBoxesIsAllowed:Boolean;
      
      protected var mShopDef:ShopDef;
      
      protected var mCheckBoxesSpace:Boolean;
      
      private var mListenerRemoved:Boolean;
      
      private var mScrollBarImagesArray:Array;
      
      private var mScrollArea:EScrollArea;
      
      protected var mItemsAreaRowWidth:Number;
      
      protected var mItemsAreaRowHeight:Number;
      
      private var mDefsList:Vector.<ItemsDef>;
      
      public function TabBodyPremiumShop(viewFactory:ViewFactory, skinSku:String, timerOnBoxesIsAllowed:Boolean)
      {
         super();
         this.mViewFactory = viewFactory;
         skinSku = this.mSkinSku;
         this.mTimerOnBoxesIsAllowed = timerOnBoxesIsAllowed;
         this.mTimerToChangeHeader = 0;
         this.mCheckBoxesSpace = true;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         eRemoveAllEventsListeners();
         this.removeBoxes();
         this.mBodyArea = null;
         this.mShopDef = null;
         this.destroyScrollArea();
      }
      
      public function setup() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("PremiumShopPage");
         this.mBodyArea = layoutFactory.getArea("container_boxes");
         this.mBodyCols = 3;
         this.mBodyRows = 2;
         this.mHeaderArea = layoutFactory.getArea("header");
         this.mBody = this.mViewFactory.getESprite(this.mSkinSku,this.mBodyArea);
         eAddChild(this.mBody);
         this.mItemsAreaRowHeight = this.mBodyArea.height / 2;
         this.mItemsAreaRowWidth = this.mBodyArea.width;
      }
      
      public function setupHeader(text:String, textProp:String, buttonType:String = null, buttonText:String = null, callBack:Function = null) : void
      {
         if(this.mHeaderContent != null)
         {
            eRemoveChild(this.mHeaderContent);
            this.mHeaderContent.destroy();
            this.mHeaderContent = null;
         }
         if(textProp == null)
         {
            textProp = "text_body_2";
         }
         if(buttonType == null)
         {
            this.mHeaderContent = this.mViewFactory.getContentOneText("PremiumShopHeaderText",text,textProp,this.mSkinSku);
         }
         else
         {
            this.mHeaderContent = this.mViewFactory.getContentTextAndButton(this.mSkinSku,"PremiumShopHeaderTextBtn",text,textProp,buttonType,"L",buttonText,callBack);
         }
         this.mHeaderContent.setLayoutArea(this.mHeaderArea,true);
         eAddChild(this.mHeaderContent);
         setContent("header",this.mHeaderContent);
      }
      
      public function setShopDef(shopDef:ShopDef) : void
      {
         this.mShopDef = shopDef;
         this.setInfo(this.mShopDef.getTabContent());
      }
      
      protected function setInfo(info:Vector.<ItemsDef>) : void
      {
         var infoCount:int = 0;
         var totalPages:int = 0;
         this.mInfo = info;
         if(this.mInfo != null)
         {
            infoCount = int(this.mInfo.length);
            totalPages = Math.ceil(infoCount / this.MAX_BOXES);
            this.setPageId(null,0);
         }
      }
      
      private function createBoxes() : void
      {
         var i:int = 0;
         var itemDef:ItemsDef = null;
         var numScrollableItems:int = 0;
         var itemsCount:int = int(this.mInfo.length);
         if(this.mDefsList == null)
         {
            this.mDefsList = new Vector.<ItemsDef>(0);
         }
         this.mDefsList.length = 0;
         for(i = 0; i < itemsCount; )
         {
            itemDef = this.mInfo[i];
            if(this.hasToShowItem(itemDef))
            {
               this.mDefsList.push(itemDef);
            }
            i++;
         }
         itemsCount = int(this.mDefsList.length);
         var containerArea:ELayoutArea = this.getBodyArea();
         var container:ESprite = this.getBodyContainer();
         var max:Number;
         if((max = itemsCount) % 3 > 0 && max > this.MAX_BOXES)
         {
            max += 3 - max % 3;
         }
         if(containerArea != null)
         {
            if(itemsCount > this.MAX_BOXES)
            {
               this.mScrollArea = new EScrollArea();
               numScrollableItems = Math.ceil(max / 3);
               this.mScrollArea.build(containerArea,numScrollableItems,ESpriteContainer,this.addBoxesToScrollArea);
               this.mScrollArea.logicTop = 0;
               this.mScrollArea.logicLeft = 0;
               this.buildScrollBar(this.mScrollArea);
               container.eAddChild(this.mScrollArea);
               setContent("scrollArea",this.mScrollArea);
            }
            else
            {
               this.getItemsBoxes(this.MAX_BOXES,0);
            }
         }
      }
      
      private function getItemsBoxes(max:int, from:int) : void
      {
         var i:int = 0;
         var itemDef:ItemsDef = null;
         var box:PremiumShopBox = null;
         var itemsCount:int = int(this.mDefsList.length);
         var boxes:Array = [];
         var container:ESprite = this.getBodyContainer();
         for(i = 0; i < max; )
         {
            itemDef = null;
            if(i < itemsCount)
            {
               itemDef = this.mDefsList[from + i];
            }
            if(itemDef != null)
            {
               if(this.hasToShowItem(itemDef))
               {
                  (box = this.getPremiumBox(itemDef)).build();
                  box.setInfoFromItemDef(itemDef);
                  boxes.push(box);
                  container.eAddChild(box);
                  setContent("box_" + i,box);
               }
            }
            else
            {
               (box = this.getPremiumBox(itemDef)).build();
               box.setInfoFromItemDef(itemDef);
               box.applySkinProp(this.mSkinSku,"disabled");
               box.mouseEnabled = false;
               boxes.push(box);
               container.eAddChild(box);
               setContent("box_" + i,box);
            }
            i++;
         }
         var containerArea:ELayoutArea = this.getBodyArea();
         this.mViewFactory.distributeSpritesInArea(containerArea,boxes,1,1,this.mBodyCols,this.mBodyRows);
      }
      
      private function buildScrollBar(area:EScrollArea) : void
      {
         this.mScrollBarImagesArray = [];
         this.mScrollBarImagesArray[0] = this.mViewFactory.getEImage("scrollbar_arrow",this.mSkinSku,false);
         this.mScrollBarImagesArray[1] = this.mViewFactory.getEImage("scrollbar_arrow",this.mSkinSku,false);
         this.mScrollBarImagesArray[2] = this.mViewFactory.getEImage("scrollbar",this.mSkinSku,false);
         this.mScrollBarImagesArray[3] = this.mViewFactory.getEImage("btn_scrollbar",this.mSkinSku,false);
         this.mScrollBarImagesArray[1].scaleY *= -1;
         var scrollBar:EScrollBar = new EScrollBar(0,this.mScrollBarImagesArray[0],this.mScrollBarImagesArray[1],this.mScrollBarImagesArray[2],this.mScrollBarImagesArray[3],area);
      }
      
      private function destroyScrollArea() : void
      {
         if(this.mScrollArea != null)
         {
            if(this.mScrollBarImagesArray != null)
            {
               this.mScrollBarImagesArray[0].destroy();
               this.mScrollBarImagesArray[0] = null;
               this.mScrollBarImagesArray[1].destroy();
               this.mScrollBarImagesArray[1] = null;
               this.mScrollBarImagesArray[2].destroy();
               this.mScrollBarImagesArray[2] = null;
               this.mScrollBarImagesArray[3].destroy();
               this.mScrollBarImagesArray[3] = null;
            }
            this.mScrollArea.destroy();
            this.mScrollArea = null;
         }
      }
      
      private function addBoxesToScrollArea(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:PremiumShopBox = null;
         var xOffset:Number = NaN;
         var itemDef:ItemsDef = null;
         var index:int = 0;
         var scale:Number = NaN;
         var count:int = 0;
         var i:int = 0;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as PremiumShopBox).destroy();
            }
            for(i = 0; i < 3; )
            {
               (itemContainer = new PremiumShopBox(this.mViewFactory,this.mSkinSku,this.mTimerOnBoxesIsAllowed,this.buyAction)).build();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               scale = this.mItemsAreaRowHeight / itemContainer.height;
               itemContainer.scaleLogicX = scale;
               itemContainer.scaleLogicY = scale;
               i++;
            }
         }
         count = int(this.mDefsList.length);
         i = rowOffset * 3;
         while(i < (rowOffset + 1) * 3 && i < count)
         {
            itemDef = this.mDefsList[i];
            (itemContainer = spriteReference.getChildAt(i % 3) as PremiumShopBox).visible = true;
            itemContainer.setInfoFromItemDef(itemDef);
            xOffset = (this.mItemsAreaRowWidth - itemContainer.width * 3) / (3 + 1);
            itemContainer.logicLeft = (itemContainer.width + xOffset) * (i % 3) + xOffset;
            itemContainer.logicTop = (this.mItemsAreaRowHeight - itemContainer.height) / 2;
            i++;
         }
         while(i < (rowOffset + 1) * 3)
         {
            (itemContainer = spriteReference.getChildAt(i % 3) as PremiumShopBox).visible = false;
            i++;
         }
      }
      
      private function hasToShowItem(def:ItemsDef) : Boolean
      {
         var fitInInventory:Boolean = false;
         var allowedByEvent:Boolean = false;
         var itemObject:ItemObject;
         if((itemObject = InstanceMng.getItemsMng().getItemObjectBySku(def.mSku)) != null)
         {
            fitInInventory = !def.hasMaxAmountInventory() || itemObject != null && itemObject.quantity < def.getMaxAmountInventory();
            allowedByEvent = InstanceMng.getHappeningDefMng().getDefsByTypeSku(def.getItemType()).length == 0 || InstanceMng.getHappeningMng().getHappeningInHudDef() && def.getItemType() == InstanceMng.getHappeningMng().getHappeningInHudDef().getTypeSku();
            return fitInInventory && allowedByEvent;
         }
         return false;
      }
      
      private function removeBoxes() : void
      {
         var i:int = 0;
         var container:ESprite = this.getBodyContainer();
         this.destroyScrollArea();
         for(i = 0; i < this.MAX_BOXES; )
         {
            container = getContent("box_" + i);
            if(container != null)
            {
               container.destroy();
            }
            i++;
         }
      }
      
      public function getPremiumBox(itemDef:ItemsDef) : PremiumShopBox
      {
         var premiumBoxClass:Class = null;
         if(this.isShield(itemDef))
         {
            premiumBoxClass = PremiumShopBoxShield;
         }
         else
         {
            premiumBoxClass = PremiumShopBox;
         }
         return new premiumBoxClass(this.mViewFactory,this.mSkinSku,this.mTimerOnBoxesIsAllowed,this.buyAction);
      }
      
      protected function getBodyContainer() : ESprite
      {
         return this.mBody;
      }
      
      protected function getBodyArea() : ELayoutArea
      {
         return this.mBodyArea;
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.removeBoxes();
         this.createBoxes();
      }
      
      public function buyAction(psb:PremiumShopBox) : void
      {
         var shopDef:ItemsDef = null;
         var entry:Entry = null;
         this.mBoxBought = psb;
         if(this.mBoxBought != null)
         {
            shopDef = this.mBoxBought.getItemDef();
            this.mItemBought = shopDef;
            this.buyItem();
            entry = shopDef.getEntryPay();
            if(entry.getKey() == "chips" || entry.getKey() == "cash")
            {
               this.buyPerformed();
            }
         }
      }
      
      protected function buyItem() : void
      {
         InstanceMng.getItemsMng().buyItem(this.mItemBought.mSku);
         if(Config.USE_METRICS)
         {
            DCMetrics.sendMetric("Purchase Item","Started",this.mItemBought.mSku);
         }
      }
      
      public function buyPerformed() : void
      {
         var btn:EButton = null;
         var itemDef:ItemsDef = null;
         var amount:String = null;
         var itemObject:ItemObject = null;
         var chips:int = parseInt(this.mItemBought.getEntryPay().getAmount(0,true));
         if(InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= chips)
         {
            itemDef = this.mBoxBought.getItemDef();
            amount = this.mItemBought.getAmount();
            if(amount == null)
            {
               amount = "1";
            }
            InstanceMng.getPopupMng().launchOverPopupText(this.mBoxBought,"+" + amount,2000,null,true,this.mBoxBought.getLogicWidth() / 2,this.mBoxBought.getLogicHeight() / 2);
            this.mTimerToChangeHeader = 1000;
            if((itemObject = InstanceMng.getItemsMng().getItemObjectBySku(this.mItemBought.mSku)) != null)
            {
               if(itemObject.quantity + 1 >= this.mItemBought.getMaxAmountInventory() && itemObject.mDef.hasMaxAmountInventory())
               {
                  (btn = this.mBoxBought.getContent("button") as EButton).setIsEnabled(false);
                  btn.applySkinProp(mSkinSku,"disabled");
               }
            }
            this.mBoxBought.playShineRotation();
            this.mBoxBought.onBuyPerformed();
         }
      }
      
      public function buyWithCreditsPerformed() : void
      {
         var action:String = null;
         var text:String = null;
         var textButton:String = null;
         if(this.mItemBought != null)
         {
            action = this.mItemBought.getPosBuyAction();
            if(action != null && action != "")
            {
               text = DCTextMng.replaceParameters(1062,[this.mItemBought.getNameToDisplay()]);
               textButton = DCTextMng.getText(1065);
               if(action == "useItem")
               {
                  text = DCTextMng.replaceParameters(1063,[this.mItemBought.getNameToDisplay()]);
                  textButton = DCTextMng.getText(1064);
               }
               this.setupHeader(text,"text_body_2","btn_accept",textButton,this.doAction);
            }
            else
            {
               this.setupHeader(DCTextMng.getText(TextIDs[this.mShopDef.getTabDescTID()]),"text_body_2");
            }
         }
      }
      
      public function doAction(e:EEvent) : void
      {
         if(this.mItemBought != null && this.mItemBought.getPosBuyAction() != null)
         {
            InstanceMng.getActionsLibrary().launchAction(this.mItemBought.getPosBuyAction(),{
               "itemSku":this.mItemBought.mSku,
               "from":"shop"
            });
         }
         this.setupHeader(DCTextMng.getText(TextIDs[this.mShopDef.getTabDescTID()]),"text_body_2");
      }
      
      public function setTimerVisible(value:Boolean) : void
      {
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var box:PremiumShopBox = null;
         super.logicUpdate(dt);
         for each(box in this.mBoxes)
         {
            box.logicUpdate(dt);
         }
         if(this.mTimerToChangeHeader > 0)
         {
            this.mTimerToChangeHeader -= dt;
            if(this.mTimerToChangeHeader <= 0)
            {
               this.buyWithCreditsPerformed();
            }
         }
      }
      
      private function isShield(def:ItemsDef) : Boolean
      {
         if(def != null)
         {
            return def.getActionType() == "shield";
         }
         return false;
      }
      
      public function setPageByItemOrder(itemOrder:int) : void
      {
         var page:int = itemOrder / this.MAX_BOXES;
         this.setPageId(null,page);
      }
      
      public function setPageByItemSku(itemSku:String) : void
      {
         var i:int = 0;
         var itemsCount:int = int(this.mInfo.length);
         var found:Boolean = false;
         for(i = 0; i < itemsCount; )
         {
            if(this.mInfo[i].mSku == itemSku)
            {
               found = true;
               break;
            }
            i++;
         }
         if(found)
         {
            this.setPageByItemOrder(i);
         }
      }
   }
}
