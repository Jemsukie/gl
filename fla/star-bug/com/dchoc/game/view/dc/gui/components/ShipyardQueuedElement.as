package com.dchoc.game.view.dc.gui.components
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   
   public class ShipyardQueuedElement
   {
      
      public static const STATE_PAUSED:int = 0;
      
      public static const STATE_IN_PROGRESS:int = 1;
      
      public static const STATE_QUEUED:int = 2;
      
      public static const STATE_VOID:int = 3;
      
      public static const STATE_UNLOCK_FB_CREDITS:int = 4;
      
      private static const DEFAULT_MSECONDS_LEFT:Number = 5000;
      
      private static const CANCEL_UNIT_INTERVAL:int = 200;
      
      private static const DEFAULT_TIME:Number = -1;
      
      private static const CANCEL_UNIT:Number = -2;
       
      
      private var mLastUnitCancelledTimeElapsed:int = 0;
      
      private var mAutoIncrementedAmount:int = 0;
      
      private var mIsCancelling:Boolean = false;
      
      private var mNotifyObject:Object;
      
      private var mState:SecureInt;
      
      private var mParentId:String;
      
      private var mElementSku:String;
      
      private var mLastState:SecureInt;
      
      private var mConstructionTime:SecureNumber;
      
      private var mTimeLeft:SecureNumber;
      
      private var mQueuedElementsAmount:SecureInt;
      
      private var mConstructionTimes:Vector.<Number>;
      
      private var mInfoIcon:String;
      
      private var mSlotId:SecureInt;
      
      private var mSlotCapacity:SecureInt;
      
      private var mSlotUnlockPrice:SecureInt;
      
      private var mGameUnitRef:GameUnit;
      
      public function ShipyardQueuedElement(parentId:String, slotId:int)
      {
         mState = new SecureInt("ShipyardQueuedElement.mState");
         mLastState = new SecureInt("ShipyardQueuedElement.mLastState");
         mConstructionTime = new SecureNumber("ShipyardQueuedElement.mConstructionTime");
         mTimeLeft = new SecureNumber("ShipyardQueuedElement.mTimeLeft");
         mQueuedElementsAmount = new SecureInt("ShipyardQueuedElement.mQueuedElementsAmount");
         mSlotId = new SecureInt("ShipyardQueuedElement.mSlotId");
         mSlotCapacity = new SecureInt("ShipyardQueuedElement.mSlotCapacity");
         mSlotUnlockPrice = new SecureInt("ShipyardQueuedElement.mSlotUnlockPrice");
         super();
         this.mTimeLeft.value = 5000;
         this.mQueuedElementsAmount.value = 0;
         this.mParentId = parentId;
         this.mNotifyObject = {};
         this.mNotifyObject.shipyardId = this.mParentId;
         this.mNotifyObject.sendResponseTo = InstanceMng.getShipyardController();
         this.mLastState.value = 3;
         this.mConstructionTimes = new Vector.<Number>(0);
         this.mSlotId.value = slotId;
      }
      
      public static function createShipyardQueuedElement(parentId:String, slotId:int) : ShipyardQueuedElement
      {
         return new ShipyardQueuedElement(parentId,slotId);
      }
      
      public function getShipyardId() : String
      {
         return this.mParentId;
      }
      
      public function getLastState() : int
      {
         return this.mLastState.value;
      }
      
      public function getState() : int
      {
         return this.mState.value;
      }
      
      public function getQueuedElementsAmount() : int
      {
         return this.mQueuedElementsAmount.value;
      }
      
      public function isInactiveState() : Boolean
      {
         return this.mState.value == 3 || this.mState.value == 4;
      }
      
      public function getConstructionTime() : Number
      {
         return this.mConstructionTime.value;
      }
      
      public function getElementSku() : String
      {
         return this.mElementSku;
      }
      
      public function getInfoIcon() : String
      {
         return this.mInfoIcon;
      }
      
      public function getTimeLeft() : Number
      {
         return this.mTimeLeft.value;
      }
      
      public function setTimeLeft(value:Number) : void
      {
         this.mTimeLeft.value = value;
      }
      
      public function addTimeLeft(value:Number) : void
      {
         this.mTimeLeft.value += value;
      }
      
      public function setSlotCapacity(value:int) : void
      {
         this.mSlotCapacity.value = value;
      }
      
      public function getSlotCapacity() : int
      {
         return this.mSlotCapacity.value;
      }
      
      public function getSlotUnlockPrice() : int
      {
         return this.mSlotUnlockPrice.value;
      }
      
      private function getIsCancelling() : Boolean
      {
         return this.mIsCancelling;
      }
      
      private function setIsCancelling(isCancelling:Boolean) : void
      {
         this.mIsCancelling = isCancelling;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var interval:Number = NaN;
         if(this.getIsCancelling())
         {
            interval = Math.max(15,200 * (1 - this.mAutoIncrementedAmount * 0.05));
            this.mLastUnitCancelledTimeElapsed += dt;
            if(this.mLastUnitCancelledTimeElapsed >= interval)
            {
               this.onRemoveUnit();
               this.mLastUnitCancelledTimeElapsed -= interval;
               this.mAutoIncrementedAmount++;
            }
         }
         if(this.mState.value == 0)
         {
            this.addNotifyAskForAvailableHangar();
            return;
         }
         if(this.mState.value != 1)
         {
            return;
         }
         this.mTimeLeft.value -= dt;
         if(int(this.mTimeLeft.value) <= 0)
         {
            this.mTimeLeft.value = 0;
            this.addNotifyAskForAvailableHangar();
            return;
         }
      }
      
      private function updateInfoIcon(value:String) : void
      {
         this.mInfoIcon = value;
      }
      
      public function setSlotUnlockPrice(amount:int) : void
      {
         this.mSlotUnlockPrice.value = amount;
      }
      
      public function changeState(state:int, restart:Boolean = true) : void
      {
         if(this.mState.value == state)
         {
            return;
         }
         this.mLastState.value = this.mState.value;
         if(state == 0)
         {
            this.mState.value = state;
         }
         else
         {
            this.mState.value = state;
            switch(this.mState.value - 1)
            {
               case 0:
                  if(restart)
                  {
                     this.mTimeLeft.value = this.mConstructionTime.value;
                  }
                  break;
               case 2:
                  this.mElementSku = null;
                  this.mInfoIcon = null;
                  this.mConstructionTimes.length = 0;
            }
         }
      }
      
      private function recoverState() : void
      {
         this.changeState(this.mLastState.value,false);
      }
      
      private function commonAssign(itemSku:String, constructionTime:Number) : void
      {
         this.mElementSku = itemSku;
         this.mConstructionTime.value = constructionTime;
         this.mGameUnitRef = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(this.mElementSku);
         if(this.mGameUnitRef)
         {
            this.updateInfoIcon(this.mGameUnitRef.mDef.getIcon());
         }
      }
      
      public function addInProgressElement(itemSku:String, constructionTime:Number) : void
      {
         this.commonAssign(itemSku,constructionTime);
         this.changeState(1);
         this.updateView();
      }
      
      public function addQueuedElement(itemSku:String, constructionTime:Number, checkCapacity:Boolean = true) : void
      {
         this.commonAssign(itemSku,constructionTime);
         this.changeState(2);
         this.incrementQueue(1,constructionTime,checkCapacity);
      }
      
      public function getNextConstructionTime() : Number
      {
         return this.mConstructionTimes.shift();
      }
      
      public function getSlotId() : int
      {
         return this.mSlotId.value;
      }
      
      public function removeUnit() : void
      {
         switch(this.mState.value - 1)
         {
            case 0:
               this.setVoid();
               break;
            case 1:
               this.incrementQueue(-1);
         }
      }
      
      public function resetConstructionTime() : void
      {
         var i:int = 0;
         if(this.mState.value == 3 || this.mState.value == 4)
         {
            return;
         }
         var time:Number = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(this.mElementSku).mDef.getConstructionTime();
         this.mTimeLeft.value = time;
         this.mConstructionTime.value = time;
         if(this.mConstructionTimes)
         {
            for(i = this.mConstructionTimes.length - 1; i >= 0; )
            {
               this.mConstructionTimes[i] = time;
               i--;
            }
         }
      }
      
      public function addNotifyAskForAvailableHangar(travelFromShipyardToHangar:Boolean = true) : void
      {
         this.mNotifyObject.cmd = "NOTIFY_SHIPYARD_QUEUEADVANCE_ASK";
         this.mNotifyObject.shipSku = this.mElementSku;
         this.mNotifyObject.travelFromShipyardToHangar = travelFromShipyardToHangar;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),this.mNotifyObject,true);
      }
      
      public function onQueueDoAdvance() : void
      {
         if(this.mTimeLeft.value > 0)
         {
            return;
         }
         var itemSkuBAK:String = this.mElementSku;
         this.setVoid();
         var o:Object = InstanceMng.getGUIControllerPlanet().createNotifyEvent(2,"NOTIFY_SHIPYARD_QUEUEADVANCE",InstanceMng.getShipyardController());
         o.xp = this.mGameUnitRef.mDef.getExperience();
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getShipyardController(),o,true);
         this.mNotifyObject.cmd = "NOTIFY_SHIPYARD_QUEUEADVANCE";
         this.mNotifyObject.shipSku = itemSkuBAK;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),this.mNotifyObject,true);
      }
      
      public function buySlot(respObj:Object) : void
      {
         if(respObj != null)
         {
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getShipyardController(),respObj);
         }
      }
      
      public function onRemoveUnit() : void
      {
         var o:Object = null;
         var wasPaused:Boolean = false;
         if(this.mState.value == 0)
         {
            wasPaused = true;
            InstanceMng.getShipyardController().getShipyard(this.mParentId).resumeProduction();
         }
         var itemSkuBak:String;
         if((itemSkuBak = this.mElementSku) == null || itemSkuBak == "")
         {
            return;
         }
         var addNotifyQueue:Boolean = false;
         var addNotifyCurrency:Boolean = false;
         if(this.mState.value == 1)
         {
            this.setVoid();
            addNotifyQueue = true;
            addNotifyCurrency = true;
         }
         else if(this.mState.value == 2)
         {
            this.incrementQueue(-1,-2);
            addNotifyCurrency = true;
            addNotifyQueue = true;
         }
         var coins:int = this.mGameUnitRef.mDef.getConstructionCoins();
         var minerals:int = this.mGameUnitRef.mDef.getConstructionMineral();
         var transaction:Transaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,coins,minerals);
         if(addNotifyCurrency)
         {
            (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(2,"NOTIFY_SHIPYARD_QUEUEUPDATE",InstanceMng.getShipyardController())).constructionCost = coins;
            o.constructionMineral = minerals;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getShipyardController(),o,true);
         }
         if(addNotifyQueue)
         {
            this.mNotifyObject.cmd = "NOTIFY_SHIPYARD_QUEUEUPDATE";
            this.mNotifyObject.shipSku = itemSkuBak;
            this.mNotifyObject.wasPaused = wasPaused;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),this.mNotifyObject,true);
         }
         InstanceMng.getUserDataMng().updateShips_shipRemoved(int(this.mParentId),itemSkuBak,this.mSlotId.value,transaction);
      }
      
      public function unlockSlot() : void
      {
         this.setVoid();
      }
      
      public function pauseProduction() : void
      {
         this.changeState(0);
         this.updateView();
      }
      
      public function resumeProduction() : void
      {
         this.recoverState();
         this.updateView();
      }
      
      public function onStartCancelUnit() : void
      {
         this.setIsCancelling(true);
         this.onRemoveUnit();
         this.mLastUnitCancelledTimeElapsed = 0;
      }
      
      public function onEndCancelUnit() : void
      {
         if(this.getIsCancelling())
         {
            this.setIsCancelling(false);
            this.mLastUnitCancelledTimeElapsed = 0;
            this.mAutoIncrementedAmount = 0;
         }
      }
      
      public function incrementQueue(amount:int, constructionTime:Number = -1, checkCapacity:Boolean = true) : Boolean
      {
         var i:int = 0;
         if(checkCapacity && amount > 0 && this.mQueuedElementsAmount.value + amount > this.mSlotCapacity.value)
         {
            return false;
         }
         this.mQueuedElementsAmount.value += amount;
         if(this.mQueuedElementsAmount.value == 0)
         {
            this.changeState(3);
         }
         i = 0;
         while(i < Math.abs(amount))
         {
            if(amount < 0)
            {
               if(constructionTime == -2)
               {
                  this.mConstructionTimes.pop();
               }
            }
            else
            {
               this.mConstructionTimes.push(constructionTime);
            }
            i++;
         }
         this.updateView();
         return true;
      }
      
      public function copyFrom(anotherElem:ShipyardQueuedElement) : void
      {
         var time:int = 0;
         this.mConstructionTime.value = anotherElem.mConstructionTime.value;
         this.mElementSku = anotherElem.mElementSku;
         this.mConstructionTimes.length = 0;
         for each(time in anotherElem.mConstructionTimes)
         {
            this.mConstructionTimes.push(time);
         }
         this.changeState(anotherElem.mState.value);
         this.mTimeLeft.value = anotherElem.mTimeLeft.value;
         this.mQueuedElementsAmount.value = anotherElem.mQueuedElementsAmount.value;
         if(this.mInfoIcon != anotherElem.getInfoIcon())
         {
            this.updateInfoIcon(anotherElem.getInfoIcon());
         }
         this.mGameUnitRef = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(this.mElementSku);
         this.updateView();
      }
      
      public function setVoid() : void
      {
         this.changeState(3);
         this.mTimeLeft.value = 0;
         this.mQueuedElementsAmount.value = 0;
         this.updateView();
      }
      
      private function updateView() : void
      {
         InstanceMng.getShipyardController().shipyardQueuedElementUpdate(this.mParentId,this.mSlotId.value);
      }
   }
}
