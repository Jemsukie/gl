package com.dchoc.game.controller.entry
{
   import com.dchoc.game.model.userdata.Transaction;
   
   public class CompositeEntry extends Entry
   {
       
      
      private var mEntries:Vector.<Entry>;
      
      public function CompositeEntry(entries:Vector.<Entry>)
      {
         var i:int = 0;
         this.mEntries = entries;
         var raw:* = "";
         for(i = 0; i < this.mEntries.length; )
         {
            raw += this.mEntries[i].getEntryRaw();
            if(i < this.mEntries.length - 1)
            {
               raw += ",";
            }
            i++;
         }
         super(raw);
      }
      
      override public function toTransactionDo(transaction:Transaction) : void
      {
         var entry:Entry = null;
         for each(entry in this.mEntries)
         {
            entry.toTransactionDo(transaction);
         }
      }
      
      override public function getSingleEntry(idx:int = 0) : Entry
      {
         if(idx < this.mEntries.length)
         {
            return this.mEntries[idx];
         }
         return this.mEntries[0];
      }
      
      override public function getKey(idx:int = 0) : String
      {
         var singleEntry:Entry = this.getSingleEntry(idx);
         return singleEntry.getKey();
      }
      
      override public function getAmount(idx:int = 0, positive:Boolean = false) : String
      {
         var singleEntry:Entry = this.getSingleEntry(idx);
         return singleEntry.getAmount(idx,positive);
      }
      
      override public function getItemSku(idx:int = 0) : String
      {
         var singleEntry:Entry = this.getSingleEntry(idx);
         return singleEntry.getItemSku();
      }
   }
}
