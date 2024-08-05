package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class PremiumShopOffer extends ESpriteContainer
   {
      
      public static const BUTTON:String = "button";
      
      private static const BACKGROUND:String = "background";
      
      private static const OFFER_BKG:String = "OfferBkg";
      
      private static const TITLE:String = "test_title";
      
      private static const IMG:String = "img";
      
      private static const REWARD:String = "Reward";
      
      private static const TEXT_INFO:String = "text_info";
      
      protected static const SHOPBOX:String = "shopbox";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mShopDef:ItemsDef;
      
      private var mContents:Array;
      
      private var mItemsDef:Vector.<ItemsDef>;
      
      private var mBuyAction:Function;
      
      private var mTimerOnBoxesIsAllowed:Boolean;
      
      public function PremiumShopOffer(viewFactory:ViewFactory, skinSku:String, timerOnBoxesIsAllowed:Boolean, buyAction:Function)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
         this.mBuyAction = buyAction;
         this.mTimerOnBoxesIsAllowed = timerOnBoxesIsAllowed;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mContents = null;
         this.mItemsDef = null;
         setContent("shopbox",null);
      }
      
      public function setup(info:ItemsDef) : void
      {
         var i:int = 0;
         var itemDef:ItemsDef = null;
         var sku:String = null;
         var amount:String = null;
         var split:Array = null;
         var content:ESpriteContainer = null;
         this.mShopDef = info;
         var layoutFactory:ELayoutAreaFactory;
         var baseArea:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("PremiumShopOffersBox")).getArea("container_offers");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = this.mViewFactory.getEImage("box_with_border",this.mSkinSku,false,baseArea,"special_offer");
         setContent("background",img);
         eAddChild(img);
         var field:ETextField;
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("test_title"))).applySkinProp(this.mSkinSku,"text_title_1");
         setContent("test_title",field);
         eAddChild(field);
         field.setText(info.getOfferTitle());
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_info"))).applySkinProp(this.mSkinSku,"text_body");
         setContent("text_info",field);
         eAddChild(field);
         field.setText(info.getOfferDesc());
         var itemContainer:PremiumShopBox = new PremiumShopBox(this.mViewFactory,this.mSkinSku,this.mTimerOnBoxesIsAllowed,this.mBuyAction);
         itemContainer.build();
         itemContainer.layoutApplyTransformations(layoutFactory.getArea("shopbox"));
         itemContainer.setInfoFromItemDef(this.mShopDef);
         eAddChild(itemContainer);
         setContent("shopbox",itemContainer);
         var items:Array;
         var itemsCount:int = int((items = info.getOfferParams()).length);
         this.mContents = [];
         this.mItemsDef = new Vector.<ItemsDef>(itemsCount,true);
         for(i = 0; i < itemsCount; )
         {
            sku = String((split = items[i].split(":"))[0]);
            amount = String(split[1]);
            itemDef = InstanceMng.getItemsDefMng().getDefBySku(sku) as ItemsDef;
            this.mItemsDef[i] = itemDef;
            if(amount != null)
            {
               amount = "x" + amount;
            }
            content = this.mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalM",itemDef.getAssetId(),amount,this.mSkinSku,"text_title_1",true);
            eAddChild(content);
            setContent("Reward" + i,content);
            this.mContents.push(content);
            content.mouseChildren = false;
            ETooltipMng.getInstance().createTooltipInfoFromDef(itemDef,content,null,true,false);
            i++;
         }
         var area:ELayoutArea = layoutFactory.getArea("container_img");
         this.mViewFactory.distributeSpritesInArea(area,this.mContents,1,1,-1,1,true);
      }
      
      public function setOfferTitle(title:String) : void
      {
         var field:ETextField = getContent("test_title") as ETextField;
         if(field != null)
         {
            field.setText(title);
         }
      }
      
      public function getItemBought() : ItemsDef
      {
         return this.mShopDef;
      }
   }
}
