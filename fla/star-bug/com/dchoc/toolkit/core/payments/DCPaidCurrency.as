package com.dchoc.toolkit.core.payments
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   
   public class DCPaidCurrency
   {
       
      
      public var mAmount:Number;
      
      public var mCurrencyKey:String;
      
      public function DCPaidCurrency(amount:Number, currencyKey:String)
      {
         super();
         this.mAmount = amount;
         this.mCurrencyKey = currencyKey;
      }
      
      public function add(value:DCPaidCurrency) : void
      {
         if(this.mCurrencyKey == value.mCurrencyKey)
         {
            this.mAmount += value.mAmount;
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in DCPaidCurrency.add(): two DCPaidCurrency objects need to have the same currency key in order to be added.",1);
         }
      }
   }
}
