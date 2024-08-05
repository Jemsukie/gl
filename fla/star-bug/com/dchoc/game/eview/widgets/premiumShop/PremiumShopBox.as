package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class PremiumShopBox extends ESpriteContainer
   {
      
      public static const BUTTON:String = "button";
      
      protected static const BACKGROUND:String = "background";
      
      protected static const SHINE:String = "shine";
      
      protected static const SHINE_SPRITE:String = "shine_sprite";
      
      protected static const SHINE_ROTATE:String = "shine_rotate";
      
      protected static const ICON:String = "icon";
      
      protected static const TEXT:String = "text_info";
      
      protected static const TEXT_PRICE:String = "text_value";
      
      protected static const ICON_WISHLIST:String = "icon_wishlist";
      
      protected static const ICON_OFFER_ARROW:String = "icon_offer_arrow";
      
      protected static const TEXT_OFFER_ARROW:String = "text_offer_arrow";
      
      private static const AMOUNT:String = "amount";
      
      private static const NAME:String = "name";
      
      private static const TIME_COUNTER:String = "time_counter";
      
      private static const TEXT_TITLE:String = "text_title";
      
      private static const FEEDBACK_ANIMATION_TIMER:int = 3000;
       
      
      protected var mViewFactory:ViewFactory;
      
      protected var mSkinSku:String;
      
      protected var mItemDef:ItemsDef;
      
      private var mTitleField:ETextField;
      
      private var mTimerContent:ESprite;
      
      protected var mRaysImage:EImage;
      
      protected var mRaysLayout:ELayoutArea;
      
      private var mUpdateShine:Boolean;
      
      private var mAnimationTimer:int;
      
      protected var mIconImg:EImage;
      
      protected var mIconArea:ELayoutArea;
      
      private var mOfferImage:EImage;
      
      private var mOfferText:ETextField;
      
      private var mScaleInc:Number;
      
      private var mScaleIconInc:Number;
      
      private var mBuyAction:Function;
      
      private var mTimerIsAllowed:Boolean;
      
      public function PremiumShopBox(viewFactory:ViewFactory, skinSku:String, timerIsAllowed:Boolean, buyAction:Function)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
         this.mTimerIsAllowed = timerIsAllowed;
         this.mAnimationTimer = 0;
         this.mBuyAction = buyAction;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mViewFactory = null;
         this.mSkinSku = null;
         this.mItemDef = null;
         this.mTimerContent = null;
         if(this.mTitleField != null)
         {
            this.mTitleField.destroy();
            this.mTitleField = null;
         }
         if(this.mTimerContent != null)
         {
            this.mTimerContent.destroy();
            this.mTimerContent = null;
         }
         if(this.mRaysImage != null)
         {
            this.mRaysImage = null;
         }
         if(this.mRaysLayout != null)
         {
            this.mRaysLayout.destroy();
            this.mRaysLayout = null;
         }
         if(this.mIconImg != null)
         {
            this.mIconImg = null;
         }
         if(this.mIconArea != null)
         {
            this.mIconArea.destroy();
            this.mIconArea = null;
         }
      }
      
      protected function setIconImg(area:ELayoutArea, assetId:String, pos:int = -1) : void
      {
         var tooltipText:String = null;
         this.mIconArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
         this.mIconArea.pivotX = 0.5;
         this.mIconArea.pivotY = 0.5;
         this.mIconImg = this.mViewFactory.getEImage(assetId,this.mSkinSku,true,this.mIconArea);
         this.mIconImg.setPivotLogicXY(0.5,0.5);
         if(pos == -1)
         {
            eAddChild(this.mIconImg);
         }
         else
         {
            eAddChildAt(this.mIconImg,pos);
         }
         setContent("icon",this.mIconImg);
         if(this.mItemDef != null)
         {
            tooltipText = ETooltipMng.getTooltipBodyForItemDef(this.mItemDef);
            ETooltipMng.getInstance().createTooltipInfoFromTexts(this.mItemDef.getNameToDisplay(),tooltipText,this,null,true,false);
         }
      }
      
      public function build() : void
      {
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PremiumShopItemBox");
         this.createBackground(layoutFactory);
         var content:ESprite;
         (content = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS","icon_clock",DCTextMng.convertTimeToStringColon(0),this.mSkinSku,"text_title_1")).setLayoutArea(layoutFactory.getArea("small_structure"),true);
         eAddChild(content);
         setContent("time_counter",content);
         this.mTimerContent = content;
         this.mTimerContent.visible = false;
         var field:ETextField = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_info"));
         setContent("text_info",field);
         eAddChild(field);
         field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title"));
         setContent("text_title",field);
         eAddChild(field);
         field.applySkinProp(this.mSkinSku,"text_title_1");
         this.mTitleField = field;
         field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_value"));
         setContent("text_value",field);
         eAddChild(field);
         field.applySkinProp(this.mSkinSku,"text_money");
         field.setFontSize(10);
         field.visible = false;
         var wishlistButton:EButton = this.mViewFactory.getButtonImage("icon_wish",this.mSkinSku,layoutFactory.getArea("icon_wishlist"));
         wishlistButton.eAddEventListener("click",this.onAddThisToWishlist);
         wishlistButton.visible = false;
         eAddChild(wishlistButton);
         setContent("icon_wishlist",wishlistButton);
         this.setupOfferBanner();
      }
      
      private function setupOfferBanner() : void
      {
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PremiumShopItemBox");
         this.mOfferImage = this.mViewFactory.getEImage("icon_offer_arrow",this.mSkinSku,false,layoutFactory.getArea("icon_offer_arrow"),null);
         eAddChild(this.mOfferImage);
         this.mOfferImage.visible = false;
         this.mOfferText = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_offer_arrow"));
         eAddChild(this.mOfferText);
         this.mOfferText.visible = false;
         this.mOfferText.applySkinProp(this.mSkinSku,"text_offer");
      }
      
      private function itemDefOnOffer() : Boolean
      {
         if(this.mItemDef == null)
         {
            return false;
         }
         return this.mItemDef.isOfferEnabled();
      }
      
      protected function onAddThisToWishlist(evt:EEvent) : void
      {
         var item:ItemObject = null;
         if(this.mItemDef != null)
         {
            item = new ItemObject(this.mItemDef);
            InstanceMng.getItemsMng().addItemToWishList(item);
         }
      }
      
      public function setInfo(entryReward:Entry, entryPay:Entry) : void
      {
         var field:ETextField = null;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PremiumShopItemBox");
         this.setIconImg(layoutFactory.getArea("img"),this.mViewFactory.getResourceIdFromEntry(entryReward),2);
         var button:EButton = this.mViewFactory.getButtonPayment(layoutFactory.getArea("btn"),entryPay,this.mSkinSku);
         button.eAddEventListener("click",this.onBuyButtonClick);
         eAddChild(button);
         setContent("button",button);
         field = getContentAsETextField("text_info");
         this.setAmount(entryReward);
         if(entryPay.getKey() == "credits" && InstanceMng.getPlatformSettingsDefMng().getShowRealMoney())
         {
            (field = getContentAsETextField("text_value")).visible = true;
            field.setText(this.mViewFactory.getStrPrice(entryPay));
         }
      }
      
      protected function onBuyButtonClick(e:EEvent) : void
      {
         if(this.mBuyAction != null)
         {
            this.mBuyAction(this);
         }
      }
      
      public function setInfoFromItemDef(info:ItemsDef) : void
      {
         var entryReward:Entry = null;
         var entryPay:Entry = null;
         var field:ETextField = null;
         var wishlistButton:EButton = null;
         this.mItemDef = info as ItemsDef;
         if(this.mItemDef != null)
         {
            entryReward = this.mItemDef.getEntryReward();
            entryPay = this.mItemDef.getEntryPay();
            this.setInfo(entryReward,entryPay);
            if(this.mTimerIsAllowed && this.mItemDef.hasTimeLeft())
            {
               this.mTimerContent.visible = true;
            }
            field = getContentAsETextField("text_info");
            if(this.mItemDef.getAmount() != null)
            {
               field.setText("x" + this.mItemDef.getAmount());
            }
            this.mTitleField.setText(this.mItemDef.getNameToDisplay());
            (wishlistButton = getContent("icon_wishlist") as EButton).visible = this.mItemDef.isInWishList();
         }
         this.showOfferBanner();
      }
      
      private function showOfferBanner() : void
      {
         var basePrice:Number = NaN;
         var offerPrice:Number = NaN;
         var offerPercentText:* = null;
         if(this.itemDefOnOffer())
         {
            basePrice = this.mItemDef.getOriginalChipsCost();
            offerPrice = this.mItemDef.getOfferChipsCost();
            offerPercentText = Math.round((offerPrice - basePrice) / basePrice * 100) + "%";
            this.mOfferText.setText(offerPercentText);
            this.mOfferImage.visible = true;
            this.mOfferText.visible = true;
         }
         else
         {
            this.mOfferImage.visible = false;
            this.mOfferText.visible = false;
         }
      }
      
      private function setAmount(entry:Entry) : void
      {
         var text:String = null;
         var textProp:String = null;
         var amount:int = 0;
         var field:ETextField = getContentAsETextField("text_info");
         if(field != null)
         {
            text = entry.getAmount();
            if(entry.getKey() == "items")
            {
               text = "x" + text;
            }
            else
            {
               amount = parseInt(text);
               text = DCTextMng.convertNumberToString(amount,-1,-1);
            }
            field.setText(text);
            textProp = entry.getTextProp(false,true);
            field.applySkinProp(this.mSkinSku,textProp);
         }
      }
      
      protected function createBackground(layoutFactory:ELayoutAreaFactory) : void
      {
         var shineLayout:ELayoutArea = layoutFactory.getArea("area");
         var img:EImage = this.mViewFactory.getEImage("box_with_border",this.mSkinSku,false,shineLayout);
         eAddChild(img);
         setContent("background",img);
         img = this.mViewFactory.getEImage("shine_base",this.mSkinSku,false,shineLayout);
         eAddChild(img);
         setContent("shine",img);
         this.mRaysLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(shineLayout);
         this.mRaysLayout.pivotX = 0.5;
         this.mRaysLayout.pivotY = 0.5;
         this.mRaysImage = this.mViewFactory.getEImage("shine",this.mSkinSku,false,this.mRaysLayout);
         this.mRaysImage.setPivotLogicXY(0.5,0.5);
         setContent("shine_rotate",this.mRaysImage);
      }
      
      public function playShineRotation() : void
      {
         this.mUpdateShine = true;
         eAddChildAt(this.mRaysImage,2);
         this.mRaysImage.scaleLogicX = 0;
         this.mRaysImage.scaleLogicY = 0;
         this.mScaleInc = 0.0006666666666666666;
         this.mScaleIconInc = -0.00044444444444444447;
         this.mAnimationTimer = 3000;
      }
      
      public function stopShineRotation() : void
      {
         this.mUpdateShine = false;
         this.mRaysImage.rotation = 0;
         this.mIconImg.scaleLogicX = 1;
         this.mIconImg.scaleLogicY = 1;
         eRemoveChild(this.mRaysImage);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var time:Number = NaN;
         var content:ESpriteContainer = null;
         var field:ETextField = null;
         super.logicUpdate(dt);
         if(this.mTimerIsAllowed && this.mItemDef != null && this.mItemDef.hasTimeLeft())
         {
            time = this.mItemDef.getTimeLeft();
            if(time > 0)
            {
               if(!this.mTimerContent.visible)
               {
                  this.mTimerContent.visible = true;
               }
               if(this.mTitleField.visible)
               {
                  this.mTitleField.visible = false;
               }
               field = (content = getContentAsESpriteContainer("time_counter")).getContent("text") as ETextField;
               field.setText(DCTextMng.convertTimeToStringColon(time));
            }
            else
            {
               if(this.mTimerContent.visible)
               {
                  this.mTimerContent.visible = false;
               }
               if(!this.mTitleField.visible)
               {
                  this.mTitleField.visible = true;
               }
            }
         }
         if(this.mUpdateShine && this.mRaysImage != null)
         {
            this.mRaysImage.rotation += dt / 15;
            if(this.mRaysImage.rotation > 360)
            {
               this.mRaysImage.rotation -= 360;
            }
            this.mRaysImage.scaleLogicX += this.mScaleInc * dt;
            this.mRaysImage.scaleLogicY += this.mScaleInc * dt;
            if(this.mRaysImage.scaleLogicX >= 1)
            {
               this.mRaysImage.scaleLogicX = 1;
               this.mRaysImage.scaleLogicY = 1;
               this.mScaleInc *= -1;
            }
            this.mIconImg.scaleLogicX += this.mScaleIconInc * dt;
            this.mIconImg.scaleLogicY += this.mScaleIconInc * dt;
            if(this.mIconImg.scaleLogicX <= 0.75)
            {
               this.mIconImg.scaleLogicX = 0.75;
               this.mIconImg.scaleLogicY = 0.75;
               this.mScaleIconInc *= -1;
            }
            else if(this.mIconImg.scaleLogicX >= 1)
            {
               this.mIconImg.scaleLogicX = 1;
               this.mIconImg.scaleLogicY = 1;
               this.mScaleIconInc *= -1;
            }
            this.mAnimationTimer -= dt;
            if(this.mAnimationTimer <= 0)
            {
               this.stopShineRotation();
            }
         }
      }
      
      public function onBuyPerformed() : void
      {
      }
      
      public function getItemDef() : ItemsDef
      {
         return this.mItemDef;
      }
   }
}
