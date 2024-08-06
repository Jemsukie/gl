package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class BuyResourcesBoxDef extends DCDef
   {
       
      
      private var mAmount:SecureNumber;
      
      private var mCurrency:String = "";
      
      private var mCurrencyId:SecureInt;
      
      public function BuyResourcesBoxDef()
      {
         mAmount = new SecureNumber("BuyResourcesBoxDef.mAmount");
         mCurrencyId = new SecureInt("BuyResourcesBoxDef.mCurrencyId");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "amount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAmount(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "currency";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCurrency(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setAmount(value:Number) : void
      {
         this.mAmount.value = value;
      }
      
      private function setCurrency(value:String) : void
      {
         this.mCurrency = value;
         this.mCurrencyId.value = GameConstants.currencyGetIdFromKey(this.mCurrency);
      }
      
      public function getAmount() : Number
      {
         return this.mAmount.value;
      }
      
      public function getCurrency() : String
      {
         return this.mCurrency;
      }
      
      public function getCurrencyId() : int
      {
         return this.mCurrencyId.value;
      }
   }
}
