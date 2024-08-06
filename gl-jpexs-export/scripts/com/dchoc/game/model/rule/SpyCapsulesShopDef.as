package com.dchoc.game.model.rule
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class SpyCapsulesShopDef extends DCDef
   {
       
      
      private var mItemsEncoded:String = "";
      
      private var mPriceCash:SecureInt;
      
      private var mEntryReward:Entry;
      
      private var mEntryPay:Entry;
      
      private var mEntry:Entry;
      
      private var mItemSku:String;
      
      private var mItemQuantity:SecureInt;
      
      public function SpyCapsulesShopDef()
      {
         mPriceCash = new SecureInt("SpyCapsulesShopDef.mPriceCash");
         mItemQuantity = new SecureInt("SpyCapsulesShopDef.mItemQuantity");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "items";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemsEncoded(EUtils.xmlReadString(info,attribute));
         }
         attribute = "cash";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPriceCash(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      override public function build() : void
      {
         this.mEntry = null;
         this.mEntryReward = null;
         this.mEntryPay = null;
      }
      
      private function setItemsEncoded(value:String) : void
      {
         this.mItemsEncoded = value;
         var split:Array = value.split(":");
         this.mItemSku = split[0];
         this.mItemQuantity.value = parseInt(split[1]);
      }
      
      public function getItemsEncoded() : String
      {
         return this.mItemsEncoded;
      }
      
      private function setPriceCash(value:int) : void
      {
         this.mPriceCash.value = value;
      }
      
      public function getPriceCash() : int
      {
         return this.mPriceCash.value;
      }
      
      public function getEntryReward() : Entry
      {
         if(this.mEntryReward == null)
         {
            this.mEntryReward = EntryFactory.createItemSingleEntry(this.mItemSku,this.mItemQuantity.value);
            this.mEntryReward.setParam("checkLimit",false);
         }
         return this.mEntryReward;
      }
      
      public function getEntryPay() : Entry
      {
         if(this.mEntryPay == null)
         {
            this.mEntryPay = EntryFactory.createCashSingleEntry(this.mPriceCash.value,true);
         }
         return this.mEntryPay;
      }
      
      public function getEntry() : Entry
      {
         var vecSingleEntries:Vector.<Entry> = null;
         if(this.mEntry == null)
         {
            vecSingleEntries = new Vector.<Entry>(0);
            vecSingleEntries.push(this.getEntryReward());
            vecSingleEntries.push(this.getEntryPay());
            this.mEntry = EntryFactory.createEntryFromSingleEntries(vecSingleEntries);
         }
         return this.mEntry;
      }
      
      public function getItemRewardSku() : String
      {
         return this.mItemSku;
      }
      
      public function getItemRewardQuantity() : int
      {
         return this.mItemQuantity.value;
      }
   }
}
