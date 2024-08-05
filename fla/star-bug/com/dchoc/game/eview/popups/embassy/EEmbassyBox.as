package com.dchoc.game.eview.popups.embassy
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EEmbassyBox extends ESpriteContainer
   {
      
      private static const BACKGROUND:String = "area";
      
      private static const SHINE:String = "shine";
      
      private static const SHINE_SPRITE:String = "shine_sprite";
      
      private static const IMAGE:String = "img";
      
      private static const BUTTON:String = "btn";
      
      private static const TEXT:String = "text_info";
      
      private static const TEXT_PRICE:String = "text_value";
      
      private static const TEXT_TITLE:String = "text_title";
       
      
      private var mTitleField:ETextField;
      
      private var mTextField:ETextField;
      
      private var mItemDef:ItemsDef;
      
      public function EEmbassyBox()
      {
         super();
      }
      
      public function build() : void
      {
         var img:EImage = null;
         var layoutFactory:ELayoutAreaFactory;
         var viewFactory:ViewFactory;
         var bgArea:ELayoutArea = (layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("PremiumShopItemBox")).getArea("area");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         img = viewFactory.getEImage("box_with_border",null,false,bgArea);
         eAddChildAt(img,0);
         setContent("area",img);
         img = viewFactory.getEImage("shine_base",null,false,bgArea);
         eAddChildAt(img,1);
         setContent("shine",img);
         var field:ETextField = viewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_title_3");
         setContent("text_info",field);
         eAddChild(field);
         this.mTextField = field;
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title"));
         setContent("text_title",field);
         eAddChild(field);
         field.applySkinProp(null,"text_title_1");
         this.mTitleField = field;
      }
      
      public function setInfo(def:ItemsDef) : void
      {
         var img:EImage = null;
         var button:EButton = null;
         this.mItemDef = def;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("PremiumShopItemBox");
         var entry:Entry = EntryFactory.createItemSingleEntry(this.mItemDef.mSku,1);
         img = viewFactory.getEImage(viewFactory.getResourceIdFromEntry(entry),null,false,layoutFactory.getArea("img"));
         setContent("img",img);
         eAddChildAt(img,2);
         button = viewFactory.getButtonByTextWidth(DCTextMng.convertNumberToString(this.getPriceBadges(),-1,-1),layoutFactory.getArea("btn").getOriginalWidth(),"btn_common","icon_user_badges");
         button.eAddEventListener("click",this.onBuyButtonClick);
         button.layoutApplyTransformations(layoutFactory.getArea("btn"));
         button.setIsEnabled(this.canAfford());
         setContent("btn",button);
         eAddChild(button);
         var amount:int = parseInt(entry.getAmount());
         if(def.getUseActionItemAmount() > 1)
         {
            amount = def.getUseActionItemAmount();
         }
         if(amount > 0)
         {
            this.mTextField.setText("x" + amount);
         }
         this.mTitleField.setText(this.mItemDef.getNameToDisplay());
         if(this.mItemDef != null)
         {
            ETooltipMng.getInstance().createTooltipInfoFromTexts(this.mItemDef.getNameToDisplay(),ETooltipMng.getTooltipBodyForItemDef(this.mItemDef),this,null,true,false);
         }
      }
      
      private function onBuyButtonClick(e:EEvent) : void
      {
         if(this.canAfford())
         {
            InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmEmbassyBuy",DCTextMng.getText(3063),DCTextMng.replaceParameters(3970,[DCTextMng.convertNumberToString(this.getPriceBadges(),-1,-1)]),"orange_normal",DCTextMng.getText(1),null,function():void
            {
               onBuyConfirmed();
            },null);
         }
      }
      
      private function onBuyConfirmed() : void
      {
         var popup:EPopupEmbassy = null;
         var trans:Transaction = this.createTransaction();
         InstanceMng.getUserDataMng().updateSocialItem_buyItem(this.mItemDef.mSku,trans);
         if(trans.performAllTransactions())
         {
            popup = InstanceMng.getPopupMng().getPopupOpened("PopupEmbassy") as EPopupEmbassy;
            if(popup)
            {
               popup.refreshCurrentPage();
            }
         }
      }
      
      private function canAfford() : Boolean
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         return profile.getBadges() >= this.getPriceBadges();
      }
      
      public function refreshBuyButton() : void
      {
         getContentAsEButton("btn").setIsEnabled(this.canAfford());
      }
      
      private function getPriceBadges() : int
      {
         var embassy:WorldItemObject = InstanceMng.getWorld().itemsGetEmbassy();
         if(embassy == null)
         {
            return 0;
         }
         var discountsFromSettings:Array = InstanceMng.getSettingsDefMng().mSettingsDef.getEmbassyDiscounts().split(",");
         if(embassy.mUpgradeId >= discountsFromSettings.length)
         {
            return 0;
         }
         var discount:int = int(discountsFromSettings[embassy.mUpgradeId]);
         var priceMultiplier:Number = (100 - discount) / 100;
         return Math.ceil(this.mItemDef.getPriceBadges() * priceMultiplier);
      }
      
      private function createTransaction() : Transaction
      {
         var trans:Transaction = new Transaction();
         trans.setTransBadges(-this.getPriceBadges());
         trans.addTransItem(this.mItemDef.mSku,1,false);
         trans.computeAmountsLeftValues();
         return trans;
      }
   }
}
