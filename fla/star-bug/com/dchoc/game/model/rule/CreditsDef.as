package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class CreditsDef extends DCDef
   {
       
      
      private var mId:SecureInt;
      
      private var mDollars:SecureNumber;
      
      private var mPremiumCurrency:SecureInt;
      
      private var mCredits:SecureNumber;
      
      private var mFreePremiumCurrency:SecureInt;
      
      private var mOldPrice:SecureNumber;
      
      private var mOldFreePC:SecureNumber;
      
      private var mBestValue:SecureBoolean;
      
      private var mItems:Array;
      
      private var mSalesName:SecureString;
      
      public function CreditsDef()
      {
         mId = new SecureInt("CreditsDef.mId");
         mDollars = new SecureNumber("CreditsDef.mDollars");
         mPremiumCurrency = new SecureInt("CreditsDef.mPremiumCurrency");
         mCredits = new SecureNumber("CreditsDef.mCredits");
         mFreePremiumCurrency = new SecureInt("CreditsDef.mFreePremiumCurrency");
         mOldPrice = new SecureNumber("CreditsDef.mOldPrice");
         mOldFreePC = new SecureNumber("CreditsDef.mOldFreePC");
         mBestValue = new SecureBoolean("CreditsDef.mBestValue");
         mSalesName = new SecureString("CreditsDef.mSalesName","");
         super();
      }
      
      override protected function doReset() : void
      {
         this.mId.value = 0;
         this.mDollars.value = 0;
         this.mPremiumCurrency.value = 0;
         this.mCredits.value = 0;
         this.mFreePremiumCurrency.value = 0;
         this.mOldPrice.value = 0;
         this.mOldFreePC.value = 0;
         this.mBestValue.value = false;
         this.mItems = null;
         this.mSalesName.value = "";
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "sku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mId.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "premiumCurrency";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mPremiumCurrency.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "credits";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mCredits.value = EUtils.xmlReadNumber(info,attribute);
         }
         attribute = "dollars";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mDollars.value = EUtils.xmlReadNumber(info,attribute);
         }
         attribute = "freePC";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mFreePremiumCurrency.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "oldPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mOldPrice.value = EUtils.xmlReadNumber(info,attribute);
         }
         attribute = "oldFreePC";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mOldFreePC.value = EUtils.xmlReadNumber(info,attribute);
         }
         attribute = "items";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItems(EUtils.xmlReadString(info,attribute));
         }
         attribute = "salesName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSalesName(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getId() : int
      {
         return this.mId.value;
      }
      
      public function getDollars() : Number
      {
         return this.mDollars.value;
      }
      
      public function getPremiumCurrency() : int
      {
         return this.mPremiumCurrency.value;
      }
      
      public function getCredits() : Number
      {
         return this.mCredits.value;
      }
      
      public function getFreePremiumCurrency() : int
      {
         return this.mFreePremiumCurrency.value;
      }
      
      public function getOldPrice() : Number
      {
         return this.mOldPrice.value;
      }
      
      public function getOldFreePC() : Number
      {
         return this.mOldFreePC.value;
      }
      
      public function setOldPrice(value:Number) : void
      {
         this.mOldPrice.value = value;
      }
      
      public function setDollars(value:Number) : void
      {
         this.mDollars.value = value;
      }
      
      public function setIsBestValue(value:Boolean) : void
      {
         this.mBestValue.value = value;
      }
      
      public function getIsBestValue() : Boolean
      {
         return this.mBestValue.value;
      }
      
      private function setItems(value:String) : void
      {
         var item:String = null;
         if(value == "" || value == null)
         {
            this.mItems = null;
            return;
         }
         var items:Array = value.split(",");
         this.mItems = [];
         for each(item in items)
         {
            this.mItems.push(item.split(":"));
         }
      }
      
      public function getItems() : Array
      {
         return this.mItems;
      }
      
      private function setSalesName(value:String) : void
      {
         this.mSalesName.value = value;
      }
      
      public function getSalesName() : String
      {
         return this.mSalesName.value;
      }
   }
}
