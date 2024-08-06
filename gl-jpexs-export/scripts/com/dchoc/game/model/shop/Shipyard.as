package com.dchoc.game.model.shop
{
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.view.dc.gui.components.ShipyardQueuedElement;
   import com.dchoc.toolkit.core.component.DCComponent;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class Shipyard extends DCComponent
   {
      
      public static const TYPE_SHIP_COMMERCE:String = "commerceShips";
      
      public static const TYPE_SHIP_WAR_S:String = "warSmallShips";
      
      public static const TYPE_GROUND_UNITS:String = "groundUnits";
      
      public static const TYPE_MECA_UNITS:String = "mecaUnits";
      
      public static const NUM_SHIPS_IN_PROGRESS_BOXES:int = 5;
      
      public static const MAX_LOCKED_SLOTS:int = 3;
       
      
      private var mQueuedElements:Vector.<ShipyardQueuedElement>;
      
      private var mQueuedElementsBoxesUnlocked:SecureInt;
      
      private var mQueuedElementsBoxesFree:SecureInt;
      
      private var mId:String;
      
      private var mTypes:String;
      
      private var mPaused:SecureBoolean;
      
      private var mForcePaused:SecureBoolean;
      
      private var mWorldItemObjectRef:WorldItemObject;
      
      private var mServerBlock:SecureBoolean;
      
      private var mShipyardBarPage:int;
      
      public function Shipyard(id:String, type:String, item:WorldItemObject = null)
      {
         mQueuedElementsBoxesUnlocked = new SecureInt("Shipyard.mQueuedElementsBoxesUnlocked");
         mQueuedElementsBoxesFree = new SecureInt("Shipyard.mQueuedElementsBoxesFree");
         mPaused = new SecureBoolean("Shipyard.mPaused");
         mForcePaused = new SecureBoolean("Shipyard.mForcePaused");
         mServerBlock = new SecureBoolean("Shipyard.mServerBlock");
         super();
         this.mId = id;
         this.mQueuedElements = new Vector.<ShipyardQueuedElement>(5,true);
         this.loadAssets();
         this.mTypes = type;
         this.mWorldItemObjectRef = item;
         this.mQueuedElementsBoxesFree.value = 2;
         this.setQueueAmounts();
      }
      
      public function destroy() : void
      {
         this.mQueuedElements = null;
         this.mShipyardBarPage = 0;
      }
      
      public function getTypes() : String
      {
         return this.mTypes;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function getWorldItemObject() : WorldItemObject
      {
         return this.mWorldItemObjectRef;
      }
      
      public function setWorldItemObject(item:WorldItemObject) : void
      {
         this.mWorldItemObjectRef = item;
         if(item != null && (this.mTypes == null || this.mTypes == ""))
         {
            this.mTypes = item.mDef.getShipsFiles();
         }
         this.setQueueAmounts();
      }
      
      public function isProductionPaused() : Boolean
      {
         return this.mPaused.value;
      }
      
      public function getUpgradeLevel() : int
      {
         return this.mWorldItemObjectRef.mDef.getUpgradeId() + 1;
      }
      
      public function setPage(value:int) : void
      {
         this.mShipyardBarPage = value;
      }
      
      public function getPage() : int
      {
         return this.mShipyardBarPage;
      }
      
      public function setServerBlock(value:Boolean) : void
      {
         this.mServerBlock.value = value;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var queuedElem:ShipyardQueuedElement = null;
         if(this.mForcePaused.value)
         {
            return;
         }
         for each(queuedElem in this.mQueuedElements)
         {
            queuedElem.logicUpdate(dt);
         }
      }
      
      override public function persistenceGetData() : XML
      {
         var slotXML:XML = null;
         var state:int = 0;
         var queuedElement:ShipyardQueuedElement = null;
         var queueElems:int = 0;
         var timeLeft:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var str:* = "<Shipyard sid=\"" + this.mId + "\" type=\"" + this.mTypes + "\" unlockedSlots=\"" + this.mQueuedElementsBoxesUnlocked.value + "\" freeSlots=\"" + this.mQueuedElementsBoxesFree.value + "\"/>";
         var persistence:XML = EUtils.stringToXML(str);
         var slotsXML:XML = EUtils.stringToXML("<Slots/>");
         var l:int = int(this.mQueuedElements.length);
         for(i = 0; i < l; )
         {
            if((state = (queuedElement = this.mQueuedElements[i]).getState()) == 4 || state == 3)
            {
               break;
            }
            slotXML = EUtils.stringToXML("<Slot sku=\"" + queuedElement.getElementSku() + "\"/>");
            if(state == 1 || state == 0)
            {
               slotXML.appendChild(EUtils.stringToXML("<Ship timeLeft=\"" + queuedElement.getTimeLeft() + "\"/>"));
            }
            else if(state == 2)
            {
               timeLeft = queuedElement.getConstructionTime();
               queueElems = queuedElement.getQueuedElementsAmount();
               for(j = 0; j < queueElems; )
               {
                  slotXML.appendChild(EUtils.stringToXML("<Ship timeLeft=\"" + timeLeft + "\"/>"));
                  j++;
               }
            }
            slotsXML.appendChild(slotXML);
            i++;
         }
         persistence.appendChild(slotsXML);
         return persistence;
      }
      
      public function getSlotUnlockedAmount() : int
      {
         return this.mQueuedElementsBoxesUnlocked.value + (this.mQueuedElementsBoxesFree.value - 2);
      }
      
      public function setSlotUnlocked() : void
      {
         var slot:ShipyardQueuedElement = null;
         if(5 - this.mQueuedElementsBoxesFree.value > this.mQueuedElementsBoxesUnlocked.value)
         {
            this.mQueuedElementsBoxesUnlocked.value += 1;
            for each(slot in this.mQueuedElements)
            {
               if(slot.getState() == 4)
               {
                  slot.unlockSlot();
                  break;
               }
            }
         }
      }
      
      public function setNumberOfSlotsUnlocked(value:int) : void
      {
         var state:int = 0;
         var i:int = 0;
         var queuedElement:ShipyardQueuedElement = null;
         this.mQueuedElementsBoxesUnlocked.value = value;
         var stateVoid:int = 3;
         var stateFriends:int = 4;
         var max:int = int(this.mQueuedElements.length);
         var firstBoxNeedFriends:int = this.mQueuedElementsBoxesFree.value + this.mQueuedElementsBoxesUnlocked.value;
         var mainDef:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySku(this.mWorldItemObjectRef.mDef.mSku) as WorldItemDef;
         for(i = 1; i < max; )
         {
            queuedElement = this.mQueuedElements[i];
            state = i < firstBoxNeedFriends ? stateVoid : stateFriends;
            queuedElement.changeState(state);
            if(state == stateFriends)
            {
               queuedElement.setSlotUnlockPrice(mainDef.getSlotsUnlockPrice()[(i + 1) % 3]);
            }
            i++;
         }
      }
      
      public function setNumberOfSlotsFree(value:int) : void
      {
         this.mQueuedElementsBoxesFree.value = value;
      }
      
      private function loadAssets() : void
      {
         var queuedElement:ShipyardQueuedElement = null;
         var state:int = 0;
         var i:int = 0;
         queuedElement = ShipyardQueuedElement.createShipyardQueuedElement(this.mId,i);
         this.mQueuedElements[0] = queuedElement;
         queuedElement.changeState(3);
         var stateVoid:int = 3;
         var stateFriends:int = 4;
         var l:int;
         var firstBoxNeedFriends:int = (l = int(this.mQueuedElements.length)) - (this.mQueuedElementsBoxesFree.value + this.mQueuedElementsBoxesUnlocked.value);
         for(i = 1; i < l; )
         {
            queuedElement = ShipyardQueuedElement.createShipyardQueuedElement(this.mId,i);
            state = i < firstBoxNeedFriends ? stateVoid : stateFriends;
            queuedElement.changeState(state);
            this.mQueuedElements[i] = queuedElement;
            i++;
         }
      }
      
      public function queueAdvance() : void
      {
         var incrementBy:int = 0;
         var i:int = 0;
         var itemSku:String = null;
         var gameUnit:GameUnit = null;
         var def:ShipDef = null;
         var constructionTime:Number = NaN;
         var shipBoxA:ShipyardQueuedElement = this.mQueuedElements[0];
         var shipBoxB:ShipyardQueuedElement = this.mQueuedElements[1];
         var stateA:int = shipBoxA.getState();
         var stateB:int = shipBoxB.getState();
         if(stateA == 3 && stateB == 2)
         {
            itemSku = shipBoxB.getElementSku();
            if((gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(itemSku)) != null)
            {
               def = gameUnit.mDef;
               if(def)
               {
                  constructionTime = shipBoxB.getNextConstructionTime();
                  shipBoxA.addInProgressElement(itemSku,constructionTime);
                  shipBoxB.incrementQueue(-1);
               }
            }
         }
         var l:int = int(this.mQueuedElements.length);
         for(i = 1; i < l - 1; )
         {
            shipBoxA = this.mQueuedElements[i];
            shipBoxB = this.mQueuedElements[i + 1];
            stateA = shipBoxA.getState();
            stateB = shipBoxB.getState();
            if(stateA == 3 && stateB == 2)
            {
               if(shipBoxA.getSlotCapacity() >= shipBoxB.getQueuedElementsAmount())
               {
                  shipBoxA.copyFrom(shipBoxB);
                  shipBoxB.setVoid();
               }
               else
               {
                  shipBoxA.copyFrom(shipBoxB);
                  shipBoxA.incrementQueue(-(shipBoxB.getQueuedElementsAmount() - shipBoxA.getSlotCapacity()));
                  shipBoxB.incrementQueue(-shipBoxA.getSlotCapacity());
               }
            }
            else if(stateA == 2 && stateB == 2 && shipBoxA.getQueuedElementsAmount() < shipBoxA.getSlotCapacity() && shipBoxA.getElementSku() == shipBoxB.getElementSku())
            {
               incrementBy = Math.min(shipBoxA.getSlotCapacity() - shipBoxA.getQueuedElementsAmount(),shipBoxB.getQueuedElementsAmount());
               shipBoxA.incrementQueue(incrementBy,shipBoxB.getConstructionTime());
               shipBoxB.incrementQueue(-incrementBy);
            }
            i++;
         }
      }
      
      public function queueAddElement(itemSku:String, constructionTime:Number, doEvent:Boolean = true, slotId:int = -1, checkCapacity:Boolean = true) : int
      {
         var shipBox:ShipyardQueuedElement = null;
         var state:int = 0;
         var o:Object = null;
         var i:int = 0;
         if(slotId > -1)
         {
            if((state = (shipBox = this.mQueuedElements[slotId]).getState()) == 3)
            {
               if(slotId == 0)
               {
                  shipBox.addInProgressElement(itemSku,constructionTime);
                  if(doEvent)
                  {
                     (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(null,"NOTIFY_SHIPYARD_STARTPRODUCING")).shipSku = itemSku;
                     o.shipyardId = this.mId;
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
                  }
               }
               else
               {
                  shipBox.addQueuedElement(itemSku,constructionTime,checkCapacity);
               }
            }
            else if(state == 2 && itemSku == shipBox.getElementSku())
            {
               shipBox.incrementQueue(1,constructionTime,checkCapacity);
            }
            return slotId;
         }
         if((state = (shipBox = this.mQueuedElements[0]).getState()) == 3)
         {
            shipBox.addInProgressElement(itemSku,constructionTime);
            if(doEvent)
            {
               (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent(null,"NOTIFY_SHIPYARD_STARTPRODUCING")).shipSku = itemSku;
               o.shipyardId = this.mId;
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
            }
            return 0;
         }
         var l:int = int(this.mQueuedElements.length);
         for(i = 1; i < l; )
         {
            if((state = (shipBox = this.mQueuedElements[i]).getState()) == 3)
            {
               shipBox.addQueuedElement(itemSku,constructionTime);
               return i;
            }
            if(state == 2 && itemSku == shipBox.getElementSku())
            {
               if(shipBox.incrementQueue(1,constructionTime))
               {
                  return i;
               }
            }
            if(state == 4)
            {
               return -1;
            }
            i++;
         }
         return -1;
      }
      
      public function isProducing() : Boolean
      {
         return this.getProducingElementSku() != null;
      }
      
      public function isQueueFull(itemSku:String, checkInAdvance:Boolean) : Boolean
      {
         var maxNum:int = 0;
         var queuedElement:ShipyardQueuedElement = null;
         var state:int = 0;
         for each(queuedElement in this.mQueuedElements)
         {
            maxNum = checkInAdvance ? queuedElement.getSlotCapacity() - 1 : queuedElement.getSlotCapacity();
            if((state = queuedElement.getState()) == 3)
            {
               return false;
            }
            if(state == 4)
            {
               return true;
            }
            if(state == 2 && queuedElement.getElementSku() == itemSku && queuedElement.getQueuedElementsAmount() < maxNum)
            {
               return false;
            }
         }
         return true;
      }
      
      public function getProducingElementSku() : String
      {
         var statedId:int = this.mQueuedElements[0].getState();
         if(statedId == 1 || statedId == 0)
         {
            return this.mQueuedElements[0].getElementSku();
         }
         return null;
      }
      
      public function isEmpty() : Boolean
      {
         return this.getProducingElementSku() == null;
      }
      
      public function getShipTimeLeft(position:int = 0) : Number
      {
         if(this.mQueuedElements[position].getState() == 3 || this.mQueuedElements[position].getState() == 4)
         {
            return -1;
         }
         return this.mQueuedElements[position].getTimeLeft();
      }
      
      public function getShipTotalTimeLeft() : Number
      {
         var i:int = 0;
         var queueElem:ShipyardQueuedElement = null;
         var count:int = int(this.mQueuedElements.length);
         var value:Number = 0;
         var sum:Number = 0;
         for(i = 1; i < count; )
         {
            queueElem = ShipyardQueuedElement(this.mQueuedElements[i]);
            if((value = this.getShipConstructionTime(i)) < 0)
            {
               value = 0;
            }
            else
            {
               value *= queueElem.getQueuedElementsAmount();
            }
            sum += value;
            i++;
         }
         return sum + this.getShipTimeLeft();
      }
      
      public function getShipConstructionTime(position:int = 0) : Number
      {
         if(this.mQueuedElements[position].getState() == 3 || this.mQueuedElements[position].getState() == 4)
         {
            return -1;
         }
         var queueElem:ShipyardQueuedElement = ShipyardQueuedElement(this.mQueuedElements[position]);
         var shipdef:ShipDef = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(queueElem.getElementSku()).mDef;
         return shipdef.getConstructionTime();
      }
      
      public function pauseProduction(forcedPause:Boolean = false) : void
      {
         var i:int = 0;
         if(this.mPaused.value)
         {
            return;
         }
         if(forcedPause)
         {
            this.mForcePaused.value = true;
         }
         this.mPaused.value = true;
         if(this.mQueuedElements[0].getState() == 3)
         {
            return;
         }
         (this.mQueuedElements[0] as ShipyardQueuedElement).pauseProduction();
         for(i = 1; i < 5; )
         {
            this.mQueuedElements[i].resetConstructionTime();
            i++;
         }
      }
      
      public function resumeProduction(forceResume:Boolean = false) : void
      {
         if(!this.mPaused.value)
         {
            return;
         }
         if(forceResume)
         {
            this.mForcePaused.value = false;
         }
         if(!this.mForcePaused.value)
         {
            this.mPaused.value = false;
            if(this.mQueuedElements[0].getState() == 0)
            {
               (this.mQueuedElements[0] as ShipyardQueuedElement).resumeProduction();
            }
         }
      }
      
      public function setStateBasedOnWIO() : void
      {
         if(this.mWorldItemObjectRef == null)
         {
            return;
         }
         var stateId:int = this.mWorldItemObjectRef.mServerStateId;
         if(stateId != 1 || this.mWorldItemObjectRef.isBroken())
         {
            if(this.getProducingElementSku() != null)
            {
               this.pauseProduction();
            }
         }
      }
      
      public function checkProcessedUnits() : void
      {
         var shipBox:ShipyardQueuedElement = this.mQueuedElements[0];
         while(shipBox.getState() == 1 && shipBox.getTimeLeft() == 0)
         {
            shipBox.addNotifyAskForAvailableHangar(false);
         }
      }
      
      public function finishProductionQueuedElement() : void
      {
         if(this.mQueuedElements[0] != null)
         {
            this.mQueuedElements[0].setTimeLeft(0);
         }
      }
      
      public function getQueuedElementById(id:int) : ShipyardQueuedElement
      {
         var returnValue:ShipyardQueuedElement = null;
         if(this.mQueuedElements != null && id > 0 && id < this.mQueuedElements.length)
         {
            returnValue = this.mQueuedElements[id];
         }
         return returnValue;
      }
      
      public function getQueuedElements() : Vector.<ShipyardQueuedElement>
      {
         return this.mQueuedElements;
      }
      
      public function getSpeedUpQueueObject(o:Object, noCheck:Boolean = false) : void
      {
         var queuedElem:ShipyardQueuedElement = null;
         var queuedElemSku:String = null;
         var queueAmount:int = 0;
         var itemDef:ShipDef = null;
         var i:int = 0;
         var formattedText:String = null;
         var unitName:* = null;
         var oElemsSkus:String = "";
         var elemsNamesDictionary:Dictionary = null;
         var hangarsSpaceLeft:int = InstanceMng.getHangarControllerMng().getHangarController().getHangarsSpaceLeft();
         for each(queuedElem in this.mQueuedElements)
         {
            if(queuedElem.isInactiveState())
            {
               if(o.failMotive == null)
               {
                  o.failMotive = "inactiveState";
               }
               break;
            }
            queueAmount = int(queuedElem.getState() == 1 || queuedElem.getState() == 0 ? 1 : queuedElem.getQueuedElementsAmount());
            queuedElemSku = queuedElem.getElementSku();
            itemDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(queuedElemSku,InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(queuedElemSku).mDef.getUpgradeId());
            for(i = 0; i < queueAmount; )
            {
               if(noCheck || hangarsSpaceLeft >= itemDef.getSize())
               {
                  hangarsSpaceLeft -= itemDef.getSize();
                  oElemsSkus = oElemsSkus.concat(queuedElemSku).concat(",");
                  if(elemsNamesDictionary == null)
                  {
                     elemsNamesDictionary = new Dictionary();
                  }
                  if(elemsNamesDictionary[itemDef.getNameToDisplay()] == null)
                  {
                     elemsNamesDictionary[itemDef.getNameToDisplay()] = 0;
                  }
                  elemsNamesDictionary[itemDef.getNameToDisplay()] = elemsNamesDictionary[itemDef.getNameToDisplay()] + 1;
               }
               else
               {
                  o.failMotive = "noHangar";
               }
               i++;
            }
         }
         formattedText = "";
         if(elemsNamesDictionary != null)
         {
            for(unitName in elemsNamesDictionary)
            {
               formattedText += "\n" + elemsNamesDictionary[unitName] + "x " + unitName;
            }
         }
         o.elementsSkus = oElemsSkus;
         o.popupText = formattedText;
      }
      
      private function instantBuildUnit(unitSku:String, serverArrObj:Array) : void
      {
         var queuedElem:ShipyardQueuedElement = null;
         var h:Hangar = null;
         var key:String = null;
         for each(queuedElem in this.mQueuedElements)
         {
            if(queuedElem.getElementSku() == unitSku)
            {
               h = InstanceMng.getHangarControllerMng().getHangarController().getHangarForDef(InstanceMng.getShipDefMng().getDefBySku(unitSku) as ShipDef,true);
               queuedElem.removeUnit();
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),{
                  "cmd":"WIOEventShipyardLaunchShipStart",
                  "shipyardId":this.mId,
                  "item":this.mWorldItemObjectRef,
                  "nearestAvailableHangar":h,
                  "shipSku":unitSku,
                  "travelFromShipyardToHangar":true,
                  "waitTime":true
               },true);
               key = unitSku + "," + queuedElem.getSlotId() + "," + h.getSid();
               if(serverArrObj[key] == null)
               {
                  serverArrObj[key] = 0;
               }
               serverArrObj[key] += 1;
               return;
            }
         }
      }
      
      private function setQueueAmounts() : void
      {
         var q:ShipyardQueuedElement = null;
         if(this.mWorldItemObjectRef == null)
         {
            return;
         }
         var i:int = 0;
         var def:WorldItemDef = this.mWorldItemObjectRef.mDef;
         for each(q in this.mQueuedElements)
         {
            q.setSlotCapacity(def.getSlotCapacity(i));
            i++;
         }
      }
      
      public function getAccelerationTime() : Number
      {
         var elemSku:String = this.getProducingElementSku();
         if(elemSku == null)
         {
            return 0;
         }
         var def:ShipDef = InstanceMng.getShipDefMng().getDefBySku(elemSku) as ShipDef;
         var time:Number = def.getConstructionTime();
         time = time * InstanceMng.getSettingsDefMng().getHelpAccelerationTime() * 0.01;
         return Math.max(time,1000);
      }
      
      public function accelerateProductionByFriend() : void
      {
         this.mQueuedElements[0].addTimeLeft(this.getAccelerationTime() * -1);
      }
      
      public function getAccelerateProductionByFriendText() : String
      {
         var time:Number = this.getAccelerationTime();
         if(time == 0)
         {
            return "";
         }
         return GameConstants.getTimeTextFromMs(time);
      }
      
      public function hasUnlockingUnits() : Boolean
      {
         var typeId:int = 0;
         var unit:GameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUnlockingUnit();
         if(unit != null)
         {
            typeId = unit.mDef.mTypeId;
            if(typeId == 0 && this.mTypes.indexOf("warSmallShips") > -1)
            {
               return true;
            }
            if(typeId == 3 && this.mTypes.indexOf("mecaUnits") > -1)
            {
               return true;
            }
            if(typeId == 2 && this.mTypes.indexOf("groundUnits") > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function isBarracks() : Boolean
      {
         return this.mTypes.indexOf("groundUnits") > -1;
      }
      
      public function isMecaFactory() : Boolean
      {
         return this.mTypes.indexOf("mecaUnits") > -1;
      }
      
      public function isShipyard() : Boolean
      {
         return this.mTypes.indexOf("warSmallShips") > -1;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var serverArrObj:Array = null;
         var skus:Array = null;
         var sku:String = null;
         var slotsContentsAccelerated:Array = null;
         var key:* = null;
         var keyArr:Array = null;
         var transaction:Transaction = null;
         var i:int = 0;
         switch(e.cmd)
         {
            case "NOTIFY_HANGAR_AVAILABLE":
               if(this.mPaused.value && !this.mForcePaused.value)
               {
                  this.resumeProduction();
               }
               if(this.mServerBlock.value)
               {
                  this.mServerBlock.value = false;
                  InstanceMng.getUserDataMng().updateShips_block(parseInt(this.mId),this.mServerBlock.value);
               }
               this.mQueuedElements[0].onQueueDoAdvance();
               break;
            case "NOTIFY_HANGAR_NONE_AVAILABLE":
               this.pauseProduction();
               if(this.mServerBlock.value == false)
               {
                  this.mServerBlock.value = true;
                  InstanceMng.getUserDataMng().updateShips_block(parseInt(this.mId),this.mServerBlock.value);
               }
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDITEM":
               this.finishProductionQueuedElement();
               break;
            case "NOTIFY_POPUP_OPEN_SPEEDQUEUE":
               serverArrObj = [];
               skus = e.elementsSkus.split(",");
               for each(sku in skus)
               {
                  if(sku != null && sku != "")
                  {
                     this.instantBuildUnit(sku,serverArrObj);
                     InstanceMng.getTargetMng().updateProgress("speedUpUnit",1,sku);
                  }
               }
               for(i = 0; i < 5; )
               {
                  this.queueAdvance();
                  i++;
               }
               slotsContentsAccelerated = [];
               for(key in serverArrObj)
               {
                  keyArr = key.split(",");
                  slotsContentsAccelerated.push({
                     "sku":keyArr[0],
                     "slot":parseInt(keyArr[1]),
                     "hangarSid":parseInt(keyArr[2]),
                     "amount":serverArrObj[key]
                  });
               }
               transaction = e.transaction;
               InstanceMng.getUserDataMng().updateShips_speedUp(parseInt(this.mId),slotsContentsAccelerated,transaction);
               InstanceMng.getTargetMng().updateProgress("speedUpQueue",1);
         }
         return true;
      }
      
      public function isWorking() : Boolean
      {
         var elem:ShipyardQueuedElement = null;
         if(this.mForcePaused.value)
         {
            return false;
         }
         for each(elem in this.mQueuedElements)
         {
            if(elem.getState() == 2 || elem.getState() == 1)
            {
               return true;
            }
         }
         return false;
      }
   }
}
