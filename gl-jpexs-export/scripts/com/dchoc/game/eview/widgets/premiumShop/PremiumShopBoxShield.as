package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.ProtectionTimeDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class PremiumShopBoxShield extends PremiumShopBox
   {
       
      
      private var mShieldDef:ProtectionTimeDef;
      
      public function PremiumShopBoxShield(viewFactory:ViewFactory, skinSku:String, timerIsAllowed:Boolean, buyAction:Function)
      {
         super(viewFactory,skinSku,timerIsAllowed,buyAction);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mShieldDef = null;
         ETooltipMng.getInstance().destroyTooltipFromContainer(this);
      }
      
      override public function build() : void
      {
      }
      
      override public function setInfoFromItemDef(info:ItemsDef) : void
      {
         var shieldSku:String = null;
         var layoutFactory:ELayoutAreaFactory = null;
         var timeValues:Array = null;
         var field:ETextField = null;
         var transaction:Transaction = null;
         var entry:Entry = null;
         var button:EButton = null;
         mItemDef = info;
         if(mItemDef != null)
         {
            shieldSku = mItemDef.getActionParam();
            this.mShieldDef = InstanceMng.getProtectionTimeDefMng().getDefBySku(shieldSku) as ProtectionTimeDef;
         }
         if(this.mShieldDef != null)
         {
            layoutFactory = mViewFactory.getLayoutAreaFactory("PremiumShopItemBoxShield");
            createBackground(layoutFactory);
            setIconImg(layoutFactory.getArea("img"),mItemDef.getAssetId());
            timeValues = this.mShieldDef.getTimeAsTexts();
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_value"));
            eAddChild(field);
            setContent("text_value",field);
            field.applySkinProp(mSkinSku,"text_title_1");
            field.setText(timeValues[0].toString());
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"));
            eAddChild(field);
            setContent("text_info",field);
            field.applySkinProp(mSkinSku,"text_title_1");
            field.setText(timeValues[1].toString());
            transaction = InstanceMng.getRuleMng().getTransactionProtectionTime(this.mShieldDef);
            entry = EntryFactory.createCashSingleEntry(transaction.getTransCash(),false);
            button = mViewFactory.getButtonPayment(layoutFactory.getArea("btn"),entry,mSkinSku);
            eAddChild(button);
            setContent("button",button);
            button.eAddEventListener("click",onBuyButtonClick);
         }
      }
      
      override public function onBuyPerformed() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(profile != null && !profile.flagsGetFirstShieldUsed())
         {
            InstanceMng.getNotificationsMng().guiOpenMessagePopup("PopupInventoryShieldBought",DCTextMng.getText(478),DCTextMng.replaceParameters(1085,[mItemDef.getNameToDisplay()]),"scientist_happy");
            profile.flagsSetFirstShieldUsed(true);
         }
      }
   }
}
