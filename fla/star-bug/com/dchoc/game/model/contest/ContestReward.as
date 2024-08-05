package com.dchoc.game.model.contest
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureString;
   
   public class ContestReward
   {
       
      
      private var mFromPos:SecureInt;
      
      private var mToPos:SecureInt;
      
      private var mEntryString:SecureString;
      
      public function ContestReward()
      {
         mFromPos = new SecureInt("ContestReward.mFromPos");
         mToPos = new SecureInt("ContestReward.mToPos");
         mEntryString = new SecureString("ContestReward.mEntryString");
         super();
      }
      
      public function destroy() : void
      {
         this.mEntryString.value = null;
      }
      
      public function setup(fromPos:int, toPos:int, entryString:String) : void
      {
         this.mFromPos.value = fromPos;
         this.mToPos.value = toPos;
         this.mEntryString.value = entryString;
      }
      
      public function getFromPos() : int
      {
         return this.mFromPos.value;
      }
      
      public function getToPos() : int
      {
         return this.mToPos.value;
      }
      
      public function setToPos(value:int) : void
      {
         this.mToPos.value = value;
      }
      
      public function getEntryString() : String
      {
         return this.mEntryString.value;
      }
      
      public function belongsToGroup(pos:int) : Boolean
      {
         return pos >= this.mFromPos.value && pos <= this.mToPos.value || pos >= this.mFromPos.value && this.mToPos.value == -1;
      }
      
      public function isAllowedToJoin(pos:int, entry:String) : Boolean
      {
         var returnValue:Boolean = false;
         if(Math.abs(this.mFromPos.value - pos) <= 1 || Math.abs(this.mToPos.value - pos) <= 1)
         {
            returnValue = EntryFactory.areTheSameEntry(this.mEntryString.value,entry);
         }
         return returnValue;
      }
      
      public function joinPos(pos:int) : void
      {
         if(pos < this.mFromPos.value)
         {
            this.mFromPos.value = pos;
         }
         else if(pos > this.mToPos.value)
         {
            this.mToPos.value = pos;
         }
      }
   }
}
