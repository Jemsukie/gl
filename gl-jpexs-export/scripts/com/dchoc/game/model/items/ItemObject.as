package com.dchoc.game.model.items
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   
   public class ItemObject extends DCComponent
   {
       
      
      public var mDef:ItemsDef;
      
      private var mQuantity:SecureInt;
      
      private var mSequenceIndex:SecureInt;
      
      private var mPositionIndex:SecureInt;
      
      private var mCounter:SecureInt;
      
      private var mTimeLeft:SecureNumber;
      
      public var mVisualStarIconAmount:SecureInt;
      
      private var mOfferStart:SecureNumber;
      
      public function ItemObject(def:ItemsDef)
      {
         mQuantity = new SecureInt("ItemObject.mQuantity");
         mSequenceIndex = new SecureInt("ItemObject.mSequenceIndex");
         mPositionIndex = new SecureInt("ItemObject.mPositionIndex");
         mCounter = new SecureInt("ItemObject.mCounter");
         mTimeLeft = new SecureNumber("ItemObject.mTimeLeft");
         mVisualStarIconAmount = new SecureInt("ItemObject.mVisualStarIconAmount");
         mOfferStart = new SecureNumber("ItemObject.mOfferStart");
         super();
         this.mDef = def;
         var date:Date = new Date(this.mDef.getOfferStartDate());
         this.mOfferStart.value = date.valueOf();
      }
      
      public function get quantity() : int
      {
         if(this.mQuantity == null)
         {
            this.mQuantity = new SecureInt("ItemObject.mQuantity");
         }
         return this.mQuantity.value;
      }
      
      public function set quantity(value:int) : void
      {
         if(this.mQuantity == null)
         {
            this.mQuantity = new SecureInt("ItemObject.mQuantity");
         }
         this.mQuantity.value = value;
      }
      
      public function set sequenceIndex(value:int) : void
      {
         this.mSequenceIndex.value = value;
      }
      
      public function get positionIndex() : int
      {
         return this.mPositionIndex.value;
      }
      
      public function set positionIndex(value:int) : void
      {
         this.mPositionIndex.value = value;
      }
      
      public function set indexesCount(value:int) : void
      {
         this.mCounter.value = value;
      }
      
      public function get indexesCount() : int
      {
         return this.mCounter.value;
      }
      
      public function getTooltipDescriptionText() : String
      {
         return this.mDef.getNameToDisplay() + ":\n" + this.mDef.getDescToDisplay();
      }
      
      public function canIGetOne() : Boolean
      {
         var i:int = 0;
         var incSeq:Boolean = false;
         DCDebug.traceCh("ItemsSequence","Enter function item: " + this.mDef.mSku + " sequence: " + this.mSequenceIndex.value + " counter: " + this.mCounter.value);
         if(!this.mDef.validDateIsValid(InstanceMng.getUserDataMng().getServerCurrentTimemillis()))
         {
            return false;
         }
         var contestOwner:String;
         if((contestOwner = this.mDef.getContestOwner()) != null && (InstanceMng.getContestMng().getCurrentContestSku() == contestOwner && InstanceMng.getContestMng().getRunningTimeLeft() == 0 || InstanceMng.getContestMng().getCurrentContestSku() != contestOwner))
         {
            return false;
         }
         var returnValue:Boolean = false;
         var sequences:Array = this.mDef.getSequences();
         if(this.ownsToMenu("inventory") && this.mDef.hasMaxAmountInventory() && this.quantity >= this.mDef.getMaxAmountInventory())
         {
            return false;
         }
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() && !this.mDef.isDroidPart())
         {
            return false;
         }
         if(this.mDef.getGivingCondition() == "skumission")
         {
            if(InstanceMng.getMissionsMng().isMissionStarted(sequences[0]) && !InstanceMng.getMissionsMng().isMissionEnded(sequences[0]) && this.quantity == 0)
            {
               this.quantity++;
               InstanceMng.getTargetMng().updateProgress("lootCollectable",1,this.mDef.mSku);
               this.mTimeLeft.value = this.mDef.getTimeToGive();
               InstanceMng.getUserDataMng().updateSocialItem_nextStep(this.mDef.mSku,incSeq,true,this.mSequenceIndex.value,0,this.mCounter.value,this.quantity);
               this.mTimeLeft.value = this.mDef.getTimeToGive();
               return true;
            }
            return false;
         }
         if(this.mSequenceIndex.value >= sequences.length)
         {
            this.mSequenceIndex.value = 0;
            this.mCounter.value = 0;
         }
         this.mCounter.value++;
         var length:int = int(sequences[this.mSequenceIndex.value][0]);
         for(i = 1; i < length; )
         {
            if(this.mCounter.value == sequences[this.mSequenceIndex.value][i])
            {
               returnValue = true;
               this.quantity++;
               InstanceMng.getTargetMng().updateProgress("lootCollectable",1,this.mDef.mSku);
               this.mTimeLeft.value = this.mDef.getTimeToGive();
               break;
            }
            i++;
         }
         if(this.mCounter.value >= length)
         {
            if(this.mSequenceIndex.value < sequences.length - 1)
            {
               this.mSequenceIndex.value++;
               incSeq = true;
            }
            else
            {
               this.mSequenceIndex.value = 0;
            }
            this.mCounter.value = 0;
         }
         DCDebug.traceCh("ItemsSequence","Out function item: " + this.mDef.mSku + " sequence: " + this.mSequenceIndex.value + " counter: " + this.mCounter.value);
         InstanceMng.getUserDataMng().updateSocialItem_nextStep(this.mDef.mSku,incSeq,returnValue,this.mSequenceIndex.value,0,this.mCounter.value,this.quantity);
         return returnValue;
      }
      
      public function ownsToMenu(menu:String) : Boolean
      {
         return this.mDef.getMenusList().indexOf(menu) > -1;
      }
      
      public function getTimeLeft() : Number
      {
         return this.mTimeLeft.value;
      }
      
      public function setTimeLeft(value:Number) : void
      {
         this.mTimeLeft.value = value;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(this.mTimeLeft.value > 0)
         {
            this.mTimeLeft.value -= dt;
            if(this.mTimeLeft.value < 0)
            {
               this.mTimeLeft.value = 0;
            }
         }
      }
      
      public function isAChipCollectable() : Boolean
      {
         var sku:String = this.mDef.mSku;
         var chipCollectables:Vector.<String> = ItemsMng.ITEM_SKUS_CHIP_COLLECTABLES;
         return chipCollectables.indexOf(sku) > -1;
      }
      
      public function hasRunningTimeLeft() : Boolean
      {
         return this.mDef.getActionType() == "powerups";
      }
      
      public function getRunningTimeLeft() : Number
      {
         var returnValue:Number = 0;
         if(this.hasRunningTimeLeft())
         {
            if(this.mDef.getActionType() == "powerups" && InstanceMng.getPowerUpMng().getPowerUpTimeLeft(this.mDef.getActionParam()) > 0)
            {
               returnValue = InstanceMng.getPowerUpMng().getPowerUpTimeLeft(this.mDef.getActionParam());
            }
         }
         return returnValue;
      }
      
      public function isRunningTimeLeft() : Boolean
      {
         return this.hasRunningTimeLeft() && this.getRunningTimeLeft() > 0;
      }
   }
}
