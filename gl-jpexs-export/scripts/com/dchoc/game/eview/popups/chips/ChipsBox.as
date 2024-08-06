package com.dchoc.game.eview.popups.chips
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.CreditsDef;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.ui.Mouse;
   
   public class ChipsBox extends ESpriteContainer
   {
      
      private static const BACKGROUND:String = "Background";
      
      private static const CHIPS_IMAGE:String = "ChipsImage";
      
      private static const BUY_BUTTON:String = "BuyButton";
      
      private static const MONEY_FIELD:String = "MoneyField";
      
      private static const TEXT_CHIPS:String = "textChips";
      
      private static const SHINE:String = "shine";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mCreditsDef:CreditsDef;
      
      private var mMobileCredits:Object;
      
      private var mUpsellingContent:ESpriteContainer;
      
      private var mItems:Array;
      
      private var mPopupChips:DCIPopup;
      
      private var mBestValue:EImage;
      
      public function ChipsBox(viewFactory:ViewFactory)
      {
         super();
         this.mViewFactory = viewFactory;
      }
      
      override protected function extendedDestroy() : void
      {
         this.mViewFactory.removeButtonBehaviors(this);
         super.extendedDestroy();
         this.mUpsellingContent = null;
      }
      
      public function setup(info:Object, chipsImage:String, popupChips:DCIPopup = null) : void
      {
         var currencyName:String = null;
         var isBestValue:* = false;
         var chips:int = 0;
         var chipsStr:String = null;
         var currencyIconName:String = null;
         var conversion:Number = NaN;
         var moneyContainer:ESpriteContainer = null;
         var money:Number = NaN;
         var newMoney:Number = NaN;
         var area:ELayoutArea = null;
         var text:ESprite = null;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("BoxChips");
         this.mPopupChips = popupChips;
         var bkg:EImage = this.mViewFactory.getEImage("box_with_border",null,false,layoutFactory.getArea("box"));
         setContent("Background",bkg);
         eAddChild(bkg);
         setLayoutArea(layoutFactory.getArea("box"));
         var img:EImage = this.mViewFactory.getEImage("shine_base",null,false,layoutFactory.getArea("box"));
         setContent("shine",img);
         bkg.addChild(img);
         img = this.mViewFactory.getEImage(chipsImage,null,true,layoutFactory.getArea("img"));
         setContent("ChipsImage",img);
         bkg.eAddChild(img);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn");
         var button:EButton = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(13),buttonArea.width,"btn_accept");
         buttonArea.centerContent(button);
         setContent("BuyButton",button);
         this.mViewFactory.removeButtonBehaviors(button);
         bkg.eAddChild(button);
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_price"),"text_subheader");
         setContent("textChips",field);
         bkg.eAddChild(field);
         var platformSettingsDefMng:PlatformSettingsDefMng = InstanceMng.getPlatformSettingsDefMng();
         var moneyArea:ELayoutArea = layoutFactory.getArea("container_price_offer");
         if(info != null)
         {
            if(info is CreditsDef)
            {
               this.mCreditsDef = info as CreditsDef;
               chips = this.mCreditsDef.getPremiumCurrency() + this.mCreditsDef.getFreePremiumCurrency();
               chipsStr = DCTextMng.convertNumberToString(chips,1,6);
               field.setText(chipsStr);
               currencyIconName = platformSettingsDefMng.getCurrencyIcon();
               conversion = platformSettingsDefMng.getCurrencyConversion();
               currencyName = platformSettingsDefMng.getCurrencyName();
               if(InstanceMng.getRuleMng().hasUserCurrency())
               {
                  conversion = InstanceMng.getRuleMng().getCurrencyExchangeValue();
                  currencyName = InstanceMng.getRuleMng().getUserCurrency();
               }
               if(this.mCreditsDef.getOldPrice() > 0)
               {
                  money = conversion * this.mCreditsDef.getOldPrice();
                  newMoney = conversion * this.mCreditsDef.getCredits();
                  moneyContainer = this.getOfferContent(money,newMoney,currencyName,currencyIconName);
               }
               else if(this.mCreditsDef.getFreePremiumCurrency() > 0)
               {
                  moneyContainer = this.getContentSaved(conversion,currencyIconName,currencyName);
               }
               else
               {
                  money = conversion * this.mCreditsDef.getCredits();
                  moneyContainer = this.mViewFactory.getContentIconWithTextHorizontal("TextPrice",currencyIconName,this.getMoneyStr(money,currencyName),null,"text_money");
               }
               isBestValue = !this.setupItemsFromCreditDef();
            }
            else
            {
               this.mMobileCredits = info;
               chips = int(this.mMobileCredits.credits);
               field.setText(DCTextMng.convertNumberToString(chips,1,6));
               currencyName = String(this.mMobileCredits.local_currency);
               money = Number(this.mMobileCredits.user_price);
               moneyContainer = this.mViewFactory.getContentIconWithTextHorizontal("TextPrice",currencyIconName,this.getMoneyStr(money,currencyName),null,"text_money");
            }
            moneyArea.centerContent(moneyContainer);
            bkg.eAddChild(moneyContainer);
         }
         this.mViewFactory.setButtonBehaviors(this);
         eAddEventListener("click",this.onClickBuy);
         isBestValue = isBestValue && this.mCreditsDef != null && this.mCreditsDef.getIsBestValue();
         if(this.mMobileCredits)
         {
            isBestValue = this.mMobileCredits.isBestValue != null && this.mMobileCredits.isBestValue == true;
         }
         if(isBestValue)
         {
            area = layoutFactory.getArea("cbox_circle");
            this.mBestValue = this.mViewFactory.getEImage("icon_new",null,false,area);
            this.mBestValue.onSetTextureLoaded = this.setBestValuePivot;
            bkg.eAddChild(this.mBestValue);
            setContent("bestValue",this.mBestValue);
            text = this.mViewFactory.getContentOneText("NotificationAreaHud",DCTextMng.getText(73),"text_title_3",null,"text");
            setContent("bestValueText",text);
            bkg.eAddChild(text);
            area.centerContent(text);
         }
      }
      
      private function setBestValuePivot(img:EImage) : void
      {
         var px:Number = img.width * 0.5;
         var py:Number = img.height * 0.5;
         img.setPivotLogicXY(px,py);
      }
      
      private function getOfferContent(oldPrice:Number, newPrice:Number, currencyName:String, currencyIcon:String) : ESpriteContainer
      {
         var img:EImage = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var iconArea:ELayoutArea;
         var layoutFactory:ELayoutAreaFactory;
         var offset:Number = (iconArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("TextPriceOfferDiscount")).getArea("icon")).width;
         if(currencyIcon != null)
         {
            img = this.mViewFactory.getEImage(currencyIcon,null,true,iconArea);
            container.setContent("icon",img);
            container.eAddChild(img);
            offset = 0;
         }
         var moneyStr:String = this.getMoneyStr(oldPrice,currencyName);
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("discount"),"text_money_old");
         container.setContent("text_old",field);
         container.eAddChild(field);
         field.setText(moneyStr);
         field.logicLeft -= offset;
         img = this.mViewFactory.getEImage("scratch",null,false,layoutFactory.getArea("scratch"));
         container.setContent("dash",img);
         container.eAddChild(img);
         var area:ELayoutArea;
         if((area = img.getLayoutArea()) != null)
         {
            area = new ELayoutArea(area);
            area.x -= offset;
            img.setLayoutArea(area,true);
         }
         field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_money");
         container.setContent("newPrice",field);
         container.eAddChild(field);
         moneyStr = this.getMoneyStr(newPrice,currencyName);
         field.setText(moneyStr);
         field.logicLeft -= offset;
         var percent:* = "-" + this.getDiscountPercentage() + "%";
         field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("offer"),"text_money_bold");
         container.setContent("percent",field);
         container.eAddChild(field);
         field.setText(percent);
         field.logicLeft -= offset;
         return container;
      }
      
      private function getContentSaved(conversion:Number, currencyIcon:String, currencyName:String) : ESpriteContainer
      {
         var img:EImage = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var iconArea:ELayoutArea;
         var layoutFactory:ELayoutAreaFactory;
         var offset:Number = (iconArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("TextPriceOffer")).getArea("icon")).width;
         if(currencyIcon != null)
         {
            img = this.mViewFactory.getEImage(currencyIcon,null,true,iconArea);
            container.setContent("icon",img);
            container.eAddChild(img);
            offset = 0;
         }
         var money:Number = conversion * this.mCreditsDef.getCredits();
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_money");
         container.setContent("text",field);
         container.eAddChild(field);
         field.setText(this.getMoneyStr(money,currencyName));
         field.logicLeft -= offset;
         field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("offer"),"text_money_bold");
         container.setContent("offer",field);
         container.eAddChild(field);
         var text:String = DCTextMng.replaceParameters(1086,[this.getDiscountPercentage()]);
         field.setText(text);
         field.logicLeft -= offset;
         return container;
      }
      
      private function getDiscountPercentage() : String
      {
         var percent:Number = NaN;
         var dif:Number = NaN;
         var freeChips:Number = NaN;
         var chips:Number = NaN;
         var dollars:Number = NaN;
         var expect:Number = NaN;
         if(this.mCreditsDef.getOldPrice() > 0)
         {
            dif = this.mCreditsDef.getCredits() - this.mCreditsDef.getOldPrice();
            percent = -100 * dif / this.mCreditsDef.getOldPrice();
         }
         else
         {
            freeChips = this.mCreditsDef.getFreePremiumCurrency();
            chips = this.mCreditsDef.getPremiumCurrency();
            expect = (dollars = this.mCreditsDef.getDollars()) / chips * (chips + freeChips);
            percent = -100 * (expect - dollars) / expect;
         }
         return DCTextMng.convertNumberToStringWithDecimals(percent,0);
      }
      
      private function getMoneyStr(money:Number, currencyName:String) : String
      {
         var moneyStr:String = null;
         moneyStr = DCTextMng.convertNumberToStringWithDecimals(money,2);
         moneyStr += " " + currencyName;
         if(currencyName.toUpperCase() == "USD")
         {
            moneyStr = "$" + moneyStr;
         }
         else if(currencyName.toUpperCase() == "EUR")
         {
            moneyStr = "€" + moneyStr;
         }
         return moneyStr;
      }
      
      private function setupItemsFromItemsArray(items:Array) : Boolean
      {
         var count:int = 0;
         var sku:String = null;
         var isUpselling:Boolean = false;
         var itemDef:ItemsDef = null;
         var area:ELayoutArea = null;
         var bkg:ESprite = null;
         var text:String = null;
         var img:EImage = null;
         var ANGLE:Number = NaN;
         var container:ESpriteContainer = null;
         var amount:String = null;
         var field:ETextField = null;
         var fw:Number = NaN;
         var itemsBkg:EImage = null;
         var itemsContainer:ESprite = null;
         var i:int = 0;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("BoxChips");
         if(items != null)
         {
            count = int(items.length);
            sku = String(items[0][0]);
            isUpselling = InstanceMng.getUpSellingMng().isItemSkuOfferedByCurrentOffer(sku);
            bkg = getContent("Background");
            if(!(count == 1 && isUpselling))
            {
               ANGLE = DCMath.degree2Rad(-9);
               this.mItems = [];
               area = layoutFactory.getArea("cbox_items");
               itemsBkg = this.mViewFactory.getEImage("box_simple",null,false,area);
               bkg.eAddChild(itemsBkg);
               itemsBkg.applySkinProp(null,"special_offer_chips");
               setContent("itemsBkg",itemsBkg);
               itemsContainer = new ESprite();
               bkg.eAddChild(itemsContainer);
               setContent("itemsContainer",itemsContainer);
               (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_title_1")).setText(DCTextMng.getText(69));
               setContent("free",field);
               bkg.addChild(field);
               for(i = 0; i < count; )
               {
                  sku = String(items[i][0]);
                  itemDef = InstanceMng.getItemsDefMng().getDefBySku(sku) as ItemsDef;
                  amount = "x" + items[i][1];
                  container = this.mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalS",itemDef.getAssetId(),amount,null,"text_title_1",true);
                  this.mViewFactory.readjustContentIconWithTextVertical(container);
                  itemsContainer.eAddChild(container);
                  setContent("item" + i,container);
                  this.mItems.push(container);
                  ETooltipMng.getInstance().createTooltipInfoFromDef(itemDef,container,null,true,false);
                  container.mouseChildren = false;
                  if(i == 0)
                  {
                     container.logicTop = 0;
                  }
                  else
                  {
                     container.logicTop = container.height * i;
                  }
                  i++;
               }
               itemsContainer.layoutApplyTransformations(area);
               if((bkg = getContentAsEImage("ChipsImage")) != null)
               {
                  bkg.logicLeft -= 38;
               }
               return true;
            }
            text = "x" + items[0][1].toString();
            if((itemDef = InstanceMng.getItemsDefMng().getDefBySku(sku) as ItemsDef) != null)
            {
               if(sku == "306")
               {
                  text = DCTextMng.getText(516);
               }
               this.mUpsellingContent = this.mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalM",itemDef.getAssetId(),text,null,"text_title_1",true);
               area = layoutFactory.getArea("cbox_circle");
               img = this.mViewFactory.getEImage("circle",null,false,area);
               setContent("circle",img);
               bkg.eAddChild(img);
               area.centerContent(this.mUpsellingContent);
               setContent("upselling",this.mUpsellingContent);
               bkg.eAddChild(this.mUpsellingContent);
               ETooltipMng.getInstance().createTooltipInfoFromDef(itemDef,this.mUpsellingContent,null,true,false);
               return true;
            }
         }
         return false;
      }
      
      private function setupItemsFromCreditDef() : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mCreditsDef != null)
         {
            returnValue = this.setupItemsFromItemsArray(this.mCreditsDef.getItems());
         }
         return returnValue;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mBestValue != null)
         {
            this.mBestValue.rotation += 0.05 * dt;
         }
      }
      
      private function onClickBuy(e:EEvent) : void
      {
         var sku:String = null;
         var saleName:String = null;
         var creditsCount:int = 0;
         InstanceMng.getApplication().setToWindowedMode();
         InstanceMng.getPopupMng().closePopup("NotifyBuyGold");
         Mouse.cursor = "auto";
         if(this.mMobileCredits != null)
         {
            sku = String(this.mMobileCredits.sku);
            creditsCount = int(this.mMobileCredits.credits);
            InstanceMng.getUserDataMng().purchaseCredits(this.mMobileCredits.sku,this.mMobileCredits.user_price,creditsCount);
         }
         else if(this.mCreditsDef != null)
         {
            sku = this.mCreditsDef.mSku;
            saleName = this.mCreditsDef.getSalesName();
            if(saleName != "")
            {
               sku += " " + saleName;
            }
            creditsCount = this.mCreditsDef.getPremiumCurrency() + this.mCreditsDef.getFreePremiumCurrency();
            InstanceMng.getUserDataMng().purchaseCredits(this.mCreditsDef.mSku,this.mCreditsDef.getDollars(),creditsCount);
         }
         else
         {
            DCDebug.trace("There isn\'t credit definition");
         }
         InstanceMng.getApplication().setCreditId(sku);
         if(this.mPopupChips != null)
         {
            InstanceMng.getUIFacade().closePopup(this.mPopupChips);
         }
      }
   }
}
