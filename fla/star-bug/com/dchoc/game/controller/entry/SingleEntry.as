package com.dchoc.game.controller.entry
{
   import com.dchoc.game.model.userdata.Transaction;
   
   public class SingleEntry extends Entry
   {
       
      
      public function SingleEntry(entryRaw:String, negative:Boolean = false)
      {
         var params:Array = null;
         if(negative)
         {
            params = entryRaw.split(":");
            entryRaw = params[0] + ":-" + params[1];
         }
         super(entryRaw);
      }
      
      override public function toTransactionDo(transaction:Transaction) : void
      {
         var cashPrice:Number = NaN;
         var priceItemSku:String = null;
         var priceItemAmount:Number = NaN;
         var mineralsAmount:int = 0;
         var coinsAmount:int = 0;
         switch(this.getKey())
         {
            case "chips":
            case "cash":
               cashPrice = new Number(this.getAmount(0));
               transaction.setTransCash(cashPrice);
               break;
            case "items":
               priceItemSku = this.getItemSku();
               priceItemAmount = new Number(this.getAmount());
               transaction.addTransItem(priceItemSku,priceItemAmount,false);
               if(getParam("checkLimit") == false)
               {
                  transaction.setCheckItemLimit(false);
               }
               if(priceItemAmount > 0)
               {
                  transaction.setIsDevolution(true);
               }
               break;
            case "minerals":
               mineralsAmount = int(this.getAmount(0));
               transaction.setTransMinerals(mineralsAmount);
               break;
            case "coins":
               coinsAmount = int(this.getAmount(0));
               transaction.setTransCoins(coinsAmount);
               break;
            case "unit":
         }
      }
      
      override public function getKey(idx:int = 0) : String
      {
         var key:String = String(mEntryRaw.value.split(":")[0]);
         switch(key)
         {
            case "minerals":
               return "minerals";
            case "chips":
            case "cash":
               break;
            case "coins":
               return "coins";
            case "unit":
               return "unit";
            case "credits":
               return "credits";
            default:
               return "items";
         }
         return "cash";
      }
      
      override public function getAmount(idx:int = 0, positive:Boolean = false) : String
      {
         var returnValue:String = String(mEntryRaw.value.split(":")[1]);
         var value:Number;
         if((value = parseFloat(returnValue)) < 0 && positive)
         {
            value *= -1;
         }
         return value.toString();
      }
      
      override public function setAmount(idx:int = 0, value:Number = 0) : void
      {
         var token:String = null;
         var i:int = 0;
         var tokens:Array;
         var length:int = int((tokens = mEntryRaw.value.split(":")).length);
         mEntryRaw.value = "";
         for(i = 0; i < length; )
         {
            if(i == 1)
            {
               token = "" + value;
            }
            else
            {
               token = String(tokens[i]);
            }
            mEntryRaw.value += token;
            if(i < length - 1)
            {
               mEntryRaw.value += ":";
            }
            i++;
         }
      }
      
      override public function getItemSku(idx:int = 0) : String
      {
         if(this.getKey() == "items")
         {
            return mEntryRaw.value.split(":")[0];
         }
         if(this.getKey() == "unit")
         {
            return mEntryRaw.value.split(":")[1];
         }
         return "";
      }
   }
}
