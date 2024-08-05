package com.dchoc.game.controller.entry
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.userdata.Transaction;
   import esparragon.utils.EUtils;
   
   public class EntryFactory
   {
       
      
      public function EntryFactory()
      {
         super();
      }
      
      public static function createSingleEntryFromString(entryRaw:String, negative:Boolean = false) : Entry
      {
         return new SingleEntry(entryRaw,negative);
      }
      
      private static function createKeySingleEntry(key:String, amount:int, negative:Boolean) : Entry
      {
         var entryStr:* = key + ":";
         if(negative)
         {
            entryStr += "-";
         }
         entryStr += amount;
         return new SingleEntry(entryStr);
      }
      
      public static function createCoinsSingleEntry(amount:int, negative:Boolean = false) : Entry
      {
         return createKeySingleEntry("coins",amount,negative);
      }
      
      public static function createMineralsSingleEntry(amount:int, negative:Boolean = false) : Entry
      {
         return createKeySingleEntry("minerals",amount,negative);
      }
      
      public static function createBadgesSingleEntry(amount:int, negative:Boolean = false) : Entry
      {
         return createKeySingleEntry("badges",amount,negative);
      }
      
      public static function createScoreSingleEntry(amount:int) : Entry
      {
         return createKeySingleEntry("score",amount,false);
      }
      
      public static function createCashSingleEntry(amount:int, negative:Boolean = false) : Entry
      {
         return createKeySingleEntry("cash",amount,negative);
      }
      
      public static function createCreditsSingleEntry(amount:Number, negative:Boolean = false) : Entry
      {
         return createKeySingleEntry("credits",amount,negative);
      }
      
      public static function createUnitSingleEntry(unitSku:String) : Entry
      {
         return new SingleEntry("unit:" + unitSku);
      }
      
      public static function createItemSingleEntry(sku:String, amount:int, negative:Boolean = false) : Entry
      {
         var raw:* = sku + ":";
         if(negative)
         {
            raw += "-";
         }
         return new SingleEntry(raw + amount);
      }
      
      public static function createEntryFromSingleEntries(vecSingleEntries:Vector.<Entry>) : Entry
      {
         return new CompositeEntry(vecSingleEntries);
      }
      
      public static function createEntryFromEntrySet(entrySet:String, checkLimit:Boolean = true) : Entry
      {
         var strEntry:String = null;
         var singleEntry:Entry = null;
         if(entrySet == null)
         {
            return null;
         }
         var vecEntries:Vector.<Entry> = new Vector.<Entry>(0);
         for each(strEntry in entrySet.split(","))
         {
            strEntry = EUtils.trim(strEntry);
            singleEntry = EntryFactory.createSingleEntryFromString(strEntry);
            if(checkLimit == false)
            {
               singleEntry.setParam("checkLimit",false);
            }
            vecEntries.push(singleEntry);
         }
         return EntryFactory.createEntryFromSingleEntries(vecEntries);
      }
      
      public static function getEntryStringFromServer(currency:String, amount:int, itemSku:String) : String
      {
         var key:String = serverCurrencyToEntryKey(currency);
         var returnValue:String = null;
         if(key != null)
         {
            if((returnValue = key == "items" ? itemSku : key) != null)
            {
               returnValue += ":" + amount;
            }
         }
         return returnValue;
      }
      
      private static function serverCurrencyToEntryKey(currency:String) : String
      {
         var returnValue:String = null;
         switch(currency)
         {
            case "0":
               returnValue = "minerals";
               break;
            case "1":
               returnValue = "coins";
               break;
            case "2":
               returnValue = "cash";
               break;
            case "3":
               returnValue = "items";
               break;
            case "4":
               returnValue = "badges";
         }
         return returnValue;
      }
      
      public static function areTheSameEntry(e1:String, e2:String) : Boolean
      {
         var t1:Transaction = null;
         var entry:Entry = null;
         var t2:Transaction = null;
         var returnValue:Boolean = false;
         if(e1 != null)
         {
            entry = createEntryFromEntrySet(e1);
            t1 = entry.toTransaction(null,false);
         }
         if(e2 != null)
         {
            entry = createEntryFromEntrySet(e2);
            t2 = entry.toTransaction(null,false);
         }
         if(t1 != null && t2 != null)
         {
            returnValue = t1.isEquivalent(t2);
         }
         else
         {
            returnValue = true;
         }
         return returnValue;
      }
      
      public static function getResourceIdFromEntrySku(sku:String) : String
      {
         var item:ItemsDef = null;
         var returnValue:String = null;
         var itemSku:String = null;
         switch(sku)
         {
            case "coins":
               itemSku = "5003";
               break;
            case "minerals":
               itemSku = "5004";
         }
         if(itemSku != null)
         {
            item = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
            if(item != null)
            {
               returnValue = item.getAssetId();
            }
         }
         return returnValue;
      }
   }
}
