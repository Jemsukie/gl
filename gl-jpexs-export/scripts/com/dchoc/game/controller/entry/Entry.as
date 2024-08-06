package com.dchoc.game.controller.entry
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.utils.anticheat.SecureString;
   import flash.utils.Dictionary;
   
   public class Entry
   {
      
      public static var smDefaultParams:Dictionary;
      
      public static const KEY_ITEMS:String = "items";
      
      public static const KEY_CASH:String = "cash";
      
      public static const KEY_CHIPS:String = "chips";
      
      public static const KEY_COINS:String = "coins";
      
      public static const KEY_MINERALS:String = "minerals";
      
      public static const KEY_BADGES:String = "badges";
      
      public static const KEY_SCORE:String = "score";
      
      public static const KEY_CREDITS:String = "credits";
      
      public static const KEY_UNIT:String = "unit";
      
      public static const PARAM_ITEMS_CHECK_LIMIT:String = "checkLimit";
      
      public static const FREE:String = "free";
       
      
      private var mResourceId:SecureString;
      
      protected var mEntryRaw:SecureString;
      
      protected var mParams:Dictionary;
      
      public function Entry(entryRaw:String)
      {
         mResourceId = new SecureString("Entry.mResourceId");
         mEntryRaw = new SecureString("Entry.mEntryRaw");
         super();
         this.mEntryRaw.value = entryRaw;
         this.mParams = null;
      }
      
      public static function init() : void
      {
         smDefaultParams = new Dictionary(true);
         smDefaultParams["checkLimit"] = true;
      }
      
      public function getEntryRaw() : String
      {
         return this.mEntryRaw.value;
      }
      
      public function toTransaction(transaction:Transaction = null, computeValues:Boolean = true) : Transaction
      {
         if(transaction == null)
         {
            transaction = new Transaction();
         }
         this.toTransactionDo(transaction);
         if(computeValues)
         {
            transaction.computeAmountsLeftValues();
         }
         return transaction;
      }
      
      public function toTransactionDo(transaction:Transaction) : void
      {
      }
      
      public function setParam(param:String, value:Object) : void
      {
         if(this.mParams == null)
         {
            this.mParams = new Dictionary(true);
         }
         this.mParams[param] = value;
      }
      
      public function getParam(param:String) : Object
      {
         if(this.mParams == null || this.mParams[param] == null)
         {
            return smDefaultParams[param];
         }
         return this.mParams[param];
      }
      
      public function getSingleEntry(idx:int = 0) : Entry
      {
         return null;
      }
      
      public function getStringSingleEntry(idx:int = 0) : String
      {
         return this.getSingleEntry(idx).getEntryRaw();
      }
      
      public function getKey(idx:int = 0) : String
      {
         return null;
      }
      
      public function getAmount(idx:int = 0, positive:Boolean = false) : String
      {
         return null;
      }
      
      public function setAmount(idx:int = 0, value:Number = 0) : void
      {
      }
      
      public function getItemSku(idx:int = 0) : String
      {
         return null;
      }
      
      public function getTextProp(useNegativeProp:Boolean, forPremiumShop:Boolean = false) : String
      {
         var value:* = NaN;
         var amountStr:String;
         var amount:Number = Number(amountStr = this.getAmount());
         var textProp:String = null;
         var key:String = this.getKey();
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         switch(key)
         {
            case "coins":
               textProp = "text_coins";
               value = profile.getCoins();
               break;
            case "minerals":
               textProp = "text_minerals";
               value = profile.getMinerals();
               break;
            case "badges":
               textProp = "text_score";
               value = profile.getBadges();
               break;
            default:
               textProp = "text_title_3";
               value = amount;
         }
         if(!forPremiumShop && useNegativeProp)
         {
            if(amount < 0 || amount > value)
            {
               textProp = "text_negative";
            }
         }
         return textProp;
      }
      
      public function setResourceId(id:String) : void
      {
         this.mResourceId.value = id;
      }
      
      public function getResourceId() : String
      {
         return this.mResourceId.value;
      }
   }
}
