package com.dchoc.game.controller.shop
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.ShipyardBarFacade;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.game.view.dc.gui.components.ShipyardQueuedElement;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ShipyardController extends DCComponent
   {
      
      public static const TYPE_SHIPS:int = 0;
      
      public static const TYPE_BARRACKS:int = 1;
      
      public static const TYPE_MECHAS:int = 2;
      
      private static const SHIPYARD_QUEUED_ELEMENT_TOOLTIP_TIME:int = 5000;
       
      
      private var mWorldItemDefMngRef:WorldItemDefMng;
      
      private var mShipDefMngRef:ShipDefMng;
      
      private var mShipyards:Array;
      
      private var mCurrentShipyard:Shipyard;
      
      private var mShipyardQueuedElementTooltipShow:Boolean;
      
      private var mShipyardQueuedElementTooltipTimer:int;
      
      public function ShipyardController()
      {
         super();
      }
      
      public static function createUnlockObject(def:UnitDef, shipyard:Shipyard) : Object
      {
         var gameUnit:GameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(def.mSku);
         return {
            "type":1,
            "cmd":"NOTIFY_POPUP_OPEN_LABS",
            "unit":gameUnit,
            "isLab":true
         };
      }
      
      public static function createUnlockingObject(def:UnitDef, shipyard:Shipyard) : Object
      {
         var gameUnit:GameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(def.mSku);
         return {
            "type":"EventPopup",
            "cmd":"NOTIFY_POPUP_OPEN_SPEEDITEM",
            "shipyardId":shipyard.getId(),
            "unitSku":def.mSku,
            "itemDef":gameUnit.mDef,
            "unlock":true,
            "timeLeft":gameUnit.mTimeLeft,
            "sendResponseTo":InstanceMng.getGameUnitMngController().getGameUnitMngOwner()
         };
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mShipyards = [];
            this.mShipDefMngRef = InstanceMng.getShipDefMng();
            this.mWorldItemDefMngRef = InstanceMng.getWorldItemDefMng();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mShipyards = null;
         this.mCurrentShipyard = null;
         this.mShipDefMngRef = null;
         this.mWorldItemDefMngRef = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var hangarControllerBuilt:Boolean = true;
         if(InstanceMng.getRole().mId == 0)
         {
            hangarControllerBuilt = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().isBuilt();
         }
         if(step == 0 && mPersistenceData != null && InstanceMng.getWorld().isBuilt() && InstanceMng.getGameUnitMngController().isBuilt() && hangarControllerBuilt && InstanceMng.getUnitScene().isBuilt())
         {
            this.loadFromXML();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mShipyards.length = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var shipyard:Shipyard = null;
         if(!isPaused())
         {
            for each(shipyard in this.mShipyards)
            {
               if(this.shipyardAvailabilityCheck(shipyard.getId()))
               {
                  shipyard.logicUpdate(dt);
               }
            }
            this.shipyardQueuedElementUpdateTooltip(dt);
         }
      }
      
      private function loadFromXML() : void
      {
         var shipyardXML:XML = null;
         var xml:XML = null;
         var subxml:XML = null;
         var sid:String = null;
         var type:String = null;
         var sku:String = null;
         var timeLeft:Number = NaN;
         var def:ShipDef = null;
         var unlockedSlots:String = null;
         var block:Boolean = false;
         var i:int = 0;
         var shipyard:Shipyard = null;
         var shipInProgress:ShipyardQueuedElement = null;
         var item:WorldItemObject = null;
         var attribute:String = null;
         var slotsXML:XML = null;
         var freeSlots:int = 0;
         var doEvent:Boolean = false;
         var slotId:int = 0;
         var createProgress:* = InstanceMng.getRole().mId == 0;
         for each(shipyardXML in EUtils.xmlGetChildrenList(mPersistenceData,"Shipyard"))
         {
            sid = EUtils.xmlReadString(shipyardXML,"sid");
            type = EUtils.xmlReadString(shipyardXML,"type");
            unlockedSlots = EUtils.xmlReadString(shipyardXML,"unlockedSlots");
            block = EUtils.xmlReadBoolean(shipyardXML,"block");
            if(this.mShipyards[sid] != null)
            {
               shipyard = this.mShipyards[sid];
               freeSlots = 2;
               attribute = "freeSlots";
               if(EUtils.xmlIsAttribute(shipyardXML,attribute))
               {
                  freeSlots = EUtils.xmlReadInt(shipyardXML,attribute);
               }
               shipyard.setNumberOfSlotsFree(freeSlots);
               shipyard.setNumberOfSlotsUnlocked(int(unlockedSlots));
               shipyard.setServerBlock(block);
               if(createProgress)
               {
                  item = shipyard.getWorldItemObject();
                  doEvent = item != null && item.mServerStateId == 1 && item.isBroken() == false;
                  slotId = 0;
                  slotsXML = EUtils.XMLListToXML(EUtils.xmlGetChildrenList(shipyardXML,"Slots"));
                  for each(xml in EUtils.xmlGetChildrenList(slotsXML,"Slot"))
                  {
                     sku = EUtils.xmlReadString(xml,"sku");
                     for each(subxml in EUtils.xmlGetChildrenList(xml,"Ship"))
                     {
                        timeLeft = EUtils.xmlReadNumber(subxml,"timeLeft");
                        shipyard.queueAddElement(sku,timeLeft,doEvent,slotId,false);
                     }
                     slotId++;
                  }
               }
               shipyard.setStateBasedOnWIO();
               shipyard.checkProcessedUnits();
            }
         }
      }
      
      override public function persistenceGetData() : XML
      {
         var shipyard:Shipyard = null;
         var persistence:XML = EUtils.stringToXML("<Shipyards/>");
         for each(shipyard in this.mShipyards)
         {
            persistence.appendChild(shipyard.persistenceGetData());
         }
         return persistence;
      }
      
      public function addShipyardByItem(item:WorldItemObject) : void
      {
         var types:String = null;
         var shipyard:Shipyard = null;
         var sid:String = item.mSid;
         if(this.mShipyards[sid] == null)
         {
            types = item.mDef.getShipsFiles();
            shipyard = new Shipyard(sid,types,item);
            this.addShipyard(shipyard);
            shipyard.setNumberOfSlotsUnlocked(0);
         }
         else
         {
            this.mShipyards[sid].setWorldItemObject(item);
         }
      }
      
      public function removeShipyardBySid(sid:String) : void
      {
         this.removeShipyard(sid);
      }
      
      private function addShipyard(shipyard:Shipyard) : void
      {
         var id:String = shipyard.getId();
         if(this.mShipyards[id] == null)
         {
            this.mShipyards[id] = shipyard;
         }
      }
      
      private function removeShipyard(id:String) : void
      {
         if(this.mShipyards[id] != null)
         {
            this.mShipyards[id].destroy();
            delete this.mShipyards[id];
         }
      }
      
      public function getShipyard(id:String) : Shipyard
      {
         return this.mShipyards[id];
      }
      
      public function getAllShipyards() : Array
      {
         return this.mShipyards;
      }
      
      public function getPreviousShipyardId(currentId:String = null) : String
      {
         var index:int = this.getIdIndex(currentId);
         index--;
         if(index < 0)
         {
            index = this.getAllShipyardIds().length - 1;
         }
         return this.getAllShipyardIds()[index];
      }
      
      public function getNextShipyardId(currentId:String = null) : String
      {
         var index:int = this.getIdIndex(currentId);
         index++;
         if(index >= this.getAllShipyardIds().length)
         {
            index = 0;
         }
         return this.getAllShipyardIds()[index];
      }
      
      private function getIdIndex(id:String = null) : int
      {
         if(id === null)
         {
            id = this.getCurrentShipyard().getId();
         }
         var allIds:Vector.<String> = this.getAllShipyardIds();
         return allIds.indexOf(id);
      }
      
      public function getAllShipyardIds() : Vector.<String>
      {
         var shipyard:Shipyard = null;
         var result:Vector.<String> = new Vector.<String>(0);
         for each(shipyard in this.mShipyards)
         {
            result.push(shipyard.getId());
         }
         return result;
      }
      
      public function getCurrentShipyard() : Shipyard
      {
         return this.mCurrentShipyard;
      }
      
      public function isShipyardOpen() : Boolean
      {
         return this.mCurrentShipyard != null;
      }
      
      public function isShipyardEmpty(id:String) : Boolean
      {
         if(this.mShipyards[id] == null)
         {
            return true;
         }
         return this.mShipyards[id].isEmpty();
      }
      
      public function getShipyardType(shipFiles:String) : int
      {
         if(shipFiles.indexOf("groundUnits") != -1)
         {
            return 1;
         }
         if(shipFiles.indexOf("mecaUnits") != -1)
         {
            return 2;
         }
         return 0;
      }
      
      public function isQueueFull(itemSku:String, checkInAdvance:Boolean = true) : Boolean
      {
         return this.mCurrentShipyard.isQueueFull(itemSku,checkInAdvance);
      }
      
      public function setCurrentShipyard(shipyardId:String) : void
      {
         this.mCurrentShipyard = this.mShipyards[shipyardId];
      }
      
      public function removeCurrentShipyard() : void
      {
         var wioShipyard:WorldItemObject = this.mCurrentShipyard.getWorldItemObject();
         wioShipyard.viewSetSelected(false,0,true,true);
         this.mCurrentShipyard = null;
      }
      
      public function getShipsInfo(types:String = null) : Vector.<DCDef>
      {
         var def:ShipDef = null;
         var gameUnit:GameUnit = null;
         var ret:Vector.<DCDef> = null;
         if(types == null)
         {
            types = this.mCurrentShipyard.getTypes();
         }
         var v:Vector.<DCDef> = this.mShipDefMngRef.getDefsFromTypes(types);
         var arr:Array = [];
         for each(def in v)
         {
            if(def.getUpgradeId() == 0)
            {
               (gameUnit = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(def.mSku)).mDef.mSortCriteria = gameUnit.mDef.getShopOrder();
               arr.push(gameUnit.mDef);
            }
         }
         arr.sortOn("mSortCriteria",16);
         return DCUtils.array2VectorDCDef(arr);
      }
      
      public function getShipInfoByUnitSku(sku:String, types:String = null) : DCDef
      {
         var def:DCDef = null;
         var v:Vector.<DCDef> = this.getShipsInfo(types);
         for each(def in v)
         {
            if(sku == def.mSku)
            {
               return def;
            }
         }
         return null;
      }
      
      private function shipyardAvailabilityCheck(id:String = null) : Boolean
      {
         var shipyard:Shipyard;
         if((shipyard = id == null ? this.mCurrentShipyard : this.mShipyards[id]) == null)
         {
            return false;
         }
         var shipyardWIO:WorldItemObject = shipyard.getWorldItemObject();
         if(shipyardWIO == null)
         {
            return false;
         }
         var hasState:*;
         var stateId:int = int((hasState = shipyardWIO.mState != null) ? shipyardWIO.mState.mStateId : -1);
         return shipyardWIO.isConnected() && (stateId == -1 || stateId == 10 || stateId == 13 || stateId == 11 || stateId == 12);
      }
      
      public function queueAdvance(shipyardId:String) : void
      {
         if(this.shipyardAvailabilityCheck(shipyardId))
         {
            this.mShipyards[shipyardId].queueAdvance();
         }
      }
      
      public function queueAddShip(itemSku:String, constructionTime:Number) : int
      {
         var gu:GameUnit = null;
         var slot:int = -1;
         if(this.shipyardAvailabilityCheck())
         {
            slot = this.mCurrentShipyard.queueAddElement(itemSku,constructionTime);
            if(slot == -1)
            {
               if((gu = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(itemSku)) && gu.mDef)
               {
                  this.playerAdd(gu.mDef.getConstructionCoins(),gu.mDef.getConstructionMineral());
               }
            }
         }
         return slot;
      }
      
      private function playerAdd(coinsToAdd:int, mineralsToAdd:int) : void
      {
         var transaction:Transaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,coinsToAdd,mineralsToAdd);
         transaction.performAllTransactions();
      }
      
      public function getProducingElementSku(sId:String) : String
      {
         if(this.mShipyards[sId] != null)
         {
            return (this.mShipyards[sId] as Shipyard).getProducingElementSku();
         }
         return null;
      }
      
      public function pauseShipyard(id:String) : void
      {
         if(this.mShipyards[id] != null)
         {
            Shipyard(this.mShipyards[id]).pauseProduction();
         }
      }
      
      public function resumeShipyard(id:String) : void
      {
         if(this.mShipyards[id] != null)
         {
            Shipyard(this.mShipyards[id]).resumeProduction();
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var xp:int = 0;
         var returnValue:Boolean = true;
         switch(e.type)
         {
            case 2:
               switch(e.cmd)
               {
                  case "NOTIFY_SHIPYARD_QUEUEADVANCE":
                     xp = int(e.xp);
                     InstanceMng.getUserInfoMng().getProfileLogin().addXp(xp);
                     break;
                  case "NOTIFY_SHIPYARD_QUEUEUPDATE":
                     this.playerAdd(e.constructionCost,e.constructionMineral);
               }
               break;
            case "EventPopup":
               var _loc4_:* = e.cmd;
               if("NotifyUnlockShipSlot" !== _loc4_)
               {
                  if(e.shipyardId != null)
                  {
                     this.getShipyard(e.shipyardId).notify(e);
                  }
               }
               else
               {
                  this.getCurrentShipyard().setSlotUnlocked();
                  InstanceMng.getUserDataMng().updateShips_addSlot(int(this.getCurrentShipyard().getId()),e.transaction);
               }
               break;
            default:
               if(e.shipyardId != null)
               {
                  this.getShipyard(e.shipyardId).notify(e);
               }
         }
         return returnValue;
      }
      
      private function getShipyardBarFacade() : ShipyardBarFacade
      {
         return InstanceMng.getGUIControllerPlanet().getShipyardBar();
      }
      
      private function shipyardQueuedElementCheckShipyardId(shipyardId:String, shipyardQueuedElementId:int) : Boolean
      {
         var currentShipyard:Shipyard = this.getCurrentShipyard();
         return currentShipyard != null && currentShipyard.getId() == shipyardId;
      }
      
      public function shipyardQueuedElementUpdate(shipyardId:String, shipyardQueuedElementId:int) : void
      {
         if(this.shipyardQueuedElementCheckShipyardId(shipyardId,shipyardQueuedElementId))
         {
            this.getShipyardBarFacade().shipyardQueuedElementUpdate(shipyardQueuedElementId);
         }
      }
      
      public function shipyardQueuedElementUnlock(shipyardQueuedElementId:int) : void
      {
         var o:Object = null;
         var trans:Transaction = null;
         var currentShipyard:Shipyard;
         if((currentShipyard = this.getCurrentShipyard()) != null)
         {
            o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyUnlockShipSlot",this);
            trans = InstanceMng.getRuleMng().getTransactionShipyardUnlockSlot(currentShipyard.getId(),o);
            o.transaction = trans;
            o.phase = "OUT";
            o.button = "EventYesButtonPressed";
            o.shipyardQueuedElement = currentShipyard.getQueuedElementById(shipyardQueuedElementId);
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
         }
      }
      
      public function shipyardQueuedElementShowBuySlotTooltip() : void
      {
         var currentShipyard:Shipyard = null;
         var slotId:* = 0;
         var queuedElements:Vector.<ShipyardQueuedElement> = null;
         var length:int = 0;
         var shipyardQueuedElement:ShipyardQueuedElement = null;
         var i:int = 0;
         if(!this.mShipyardQueuedElementTooltipShow)
         {
            if((currentShipyard = this.getCurrentShipyard()) != null)
            {
               slotId = -1;
               length = int((queuedElements = currentShipyard.getQueuedElements()).length);
               for(i = 0; i < length; )
               {
                  shipyardQueuedElement = queuedElements[i];
                  if(shipyardQueuedElement.getState() == 4)
                  {
                     slotId = i;
                     break;
                  }
                  i++;
               }
               if(slotId > -1)
               {
                  this.getShipyardBarFacade().shipyardQueuedElementShowBuySlotTooltip(slotId);
                  this.mShipyardQueuedElementTooltipShow = true;
                  this.mShipyardQueuedElementTooltipTimer = 5000;
               }
            }
         }
      }
      
      private function shipyardQueuedElementUpdateTooltip(dt:int) : void
      {
         if(this.mShipyardQueuedElementTooltipShow)
         {
            this.mShipyardQueuedElementTooltipTimer -= dt;
            if(this.mShipyardQueuedElementTooltipTimer <= 0)
            {
               this.shipyardQueuedElementHideBuySlotTooltip();
            }
         }
      }
      
      public function shipyardQueuedElementHideBuySlotTooltip() : void
      {
         if(this.mShipyardQueuedElementTooltipShow)
         {
            this.getShipyardBarFacade().shipyardQueuedElementHideBuySlotTooltip();
            this.mShipyardQueuedElementTooltipShow = false;
         }
      }
      
      public function getSpeedUpPrice() : Number
      {
         var o:Object = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_POPUP_OPEN_SPEEDQUEUE");
         this.getCurrentShipyard().getSpeedUpQueueObject(o,true);
         if(o.elementsSkus == "")
         {
            return 0;
         }
         o.elementsSkus = o.elementsSkus.slice(0,o.elementsSkus.length - 1);
         o.item = InstanceMng.getShipyardController().getCurrentShipyard();
         var transaction:Transaction = InstanceMng.getRuleMng().getTransactionSpeedUpQueue(o);
         return transaction.getTransCashToPay();
      }
   }
}
