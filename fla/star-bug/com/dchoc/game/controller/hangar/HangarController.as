package com.dchoc.game.controller.hangar
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class HangarController extends DCComponent
   {
      
      public static const WAR_UNIT_SKU:int = 0;
      
      public static const WAR_UNIT_HANGARSIDS:int = 1;
      
      public static const WAR_UNIT_DEF:int = 2;
      
      public static const WAR_UNIT_AMOUNT:int = 3;
      
      public static const WAR_UNIT_FROM_HANGAR:int = 4;
      
      public static const WAR_UNIT_SOCIAL_ITEM_SKU:int = 5;
      
      public static const WAR_VECTOR_LENGTH:int = 5;
       
      
      private var mHangars:Array;
      
      protected var mWorldItemDefMngRef:WorldItemDefMng;
      
      private var mKeepHangars:Boolean = false;
      
      private var HANGAR_ID_ALLY:String = "ally";
      
      public function HangarController()
      {
         super();
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
            this.mHangars = [];
            this.mWorldItemDefMngRef = InstanceMng.getWorldItemDefMng();
         }
      }
      
      override protected function unloadDo() : void
      {
         var hangar:Hangar = null;
         for each(hangar in this.mHangars)
         {
            hangar.unload();
         }
         this.mHangars.length = 0;
         this.mHangars = null;
         this.mWorldItemDefMngRef = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && mPersistenceData != null && InstanceMng.getWorld().isBuilt() && InstanceMng.getUnitScene().isBuilt())
         {
            this.loadFromXML();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         var hangar:Hangar = null;
         if(this.mKeepHangars)
         {
            for each(hangar in this.mHangars)
            {
               hangar.removeUnits();
            }
         }
         else
         {
            this.mHangars.length = 0;
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
      }
      
      override public function persistenceGetData() : XML
      {
         var hangar:Hangar = null;
         var persistence:XML = EUtils.stringToXML("<Hangars/>");
         for each(hangar in this.mHangars)
         {
            persistence.appendChild(hangar.persistenceGetData());
         }
         return persistence;
      }
      
      protected function loadFromXML() : void
      {
         var hangarXML:XML = null;
         var shipXML:XML = null;
         var sid:String = null;
         var maxCapacity:int = 0;
         var shipSku:String = null;
         var storedInside:Boolean = false;
         var spaceOccupied:int = 0;
         var hangar:Hangar = null;
         var hangarWIO:WorldItemObject = null;
         var shipDef:ShipDef = null;
         var storeOk:Boolean = false;
         if(InstanceMng.getRole().mId == 7)
         {
            return;
         }
         var world:World = InstanceMng.getWorld();
         var createUnitsOnHangar:*;
         var checkStoreOk:Boolean = createUnitsOnHangar = InstanceMng.getRole().mId != 3;
         for each(hangarXML in EUtils.xmlGetChildrenList(mPersistenceData,"Hangar"))
         {
            sid = EUtils.xmlReadString(hangarXML,"sid");
            hangar = this.mHangars[sid];
            if(hangar != null)
            {
               hangarWIO = hangar.getWIO();
               for each(shipXML in EUtils.xmlGetChildrenList(hangarXML,"Unit"))
               {
                  shipSku = EUtils.xmlReadString(shipXML,"sku");
                  if((shipDef = ShipDef(InstanceMng.getShipDefMng().getDefBySku(shipSku))) == null)
                  {
                     if(Config.DEBUG_ASSERTS)
                     {
                        DCDebug.trace("WARNING in HangarController.loadFromXML(): unis sku <" + shipSku + "> not valid",1);
                     }
                  }
                  else
                  {
                     storedInside = false;
                     spaceOccupied = shipDef.getSize();
                     if(checkStoreOk)
                     {
                        if((storeOk = this.checkDependingOnRole(hangar,hangarWIO,spaceOccupied,true)) == false && hangarWIO.isCompletelyBroken())
                        {
                           storeOk = true;
                        }
                     }
                     else
                     {
                        storeOk = true;
                     }
                     if(storeOk)
                     {
                        hangar.store(shipSku,spaceOccupied,storedInside,false);
                        if(!storedInside && createUnitsOnHangar)
                        {
                           InstanceMng.getUnitScene().shipsPlaceShipWarOnHangar(shipSku,hangarWIO);
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function setKeepHangars(value:Boolean) : void
      {
         this.mKeepHangars = value;
      }
      
      protected function checkDependingOnRole(hangar:Hangar, hangarWIO:WorldItemObject, spaceOccupied:int, infoFromServer:Boolean = false) : Boolean
      {
         if(InstanceMng.getFlowStatePlanet().isCurrentRoleOwner())
         {
            if(infoFromServer)
            {
               return hangarWIO != null && hangar != null && hangarWIO.isCompletelyBroken() == false;
            }
            return hangarWIO != null && hangarWIO.isConnected() && hangarWIO.mState.mStateId == 19 && hangar.canStoreItem(spaceOccupied);
         }
         return hangarWIO != null && hangarWIO.isConnected() && hangarWIO.mState.mStateId != 18;
      }
      
      public function moveUnitsToItem(units:Vector.<Array>, bunker:Bunker) : void
      {
         var sku:String = null;
         var hangarsForUnit:Array = null;
         var def:ShipDef = null;
         var defForTransaction:ShipDef = null;
         var amount:int = 0;
         var unitHangarsDic:Dictionary = null;
         var hangarId:* = null;
         var hangar:Hangar = null;
         var t:Transaction = null;
         var i:int = 0;
         var unitInfo:Array = null;
         var bunkerUnitsInfo:Object = null;
         var item:WorldItemObject = bunker.getWIO();
         var v:Vector.<ShipDef> = new Vector.<ShipDef>(0);
         for each(unitInfo in units)
         {
            sku = String(unitInfo[0]);
            hangarsForUnit = String(unitInfo[1]).split(",");
            def = unitInfo[2];
            amount = int(unitInfo[3]);
            defForTransaction = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef.getUpgradeId());
            unitHangarsDic = new Dictionary();
            for(i = 0; i < amount; )
            {
               hangarId = hangarsForUnit.shift();
               if(unitHangarsDic[hangarId] == null)
               {
                  unitHangarsDic[hangarId] = 0;
               }
               unitHangarsDic[hangarId]++;
               i++;
            }
            for(hangarId in unitHangarsDic)
            {
               bunkerUnitsInfo = bunker.getUnitsInfo();
               amount = int(unitHangarsDic[hangarId]);
               hangar = this.mHangars[hangarId];
               for(i = 0; i < amount; )
               {
                  hangar.removeUnit(sku,false);
                  v.push(defForTransaction);
                  i++;
               }
               t = InstanceMng.getRuleMng().getTransactionTransfer({"defs":v});
               InstanceMng.getUserDataMng().updateShips_moveFromHangarToBunker(sku,amount,parseInt(hangar.getSid()),parseInt(item.mSid),bunkerUnitsInfo,t);
               bunker.storeUnitsAmount(sku,amount);
               hangar.moveUnitsToItem(item,sku,amount);
               v.length = 0;
            }
            unitHangarsDic = null;
         }
      }
      
      public function summonShipsInHangars() : void
      {
         var hangar:Hangar = null;
         var hangarWIO:WorldItemObject = null;
         var idsArr:Array = null;
         var id:String = null;
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         for each(hangar in this.mHangars)
         {
            hangarWIO = hangar.getWIO();
            unitScene.shipsUnplaceShipsWarOnHangar(hangarWIO);
            idsArr = hangar.getStoredOutsideUnits().split(",");
            for each(id in idsArr)
            {
               if(id != "")
               {
                  unitScene.shipsPlaceShipWarOnHangar(id,hangarWIO);
               }
            }
         }
      }
      
      private function unsummonShipsInHangar(id:String) : void
      {
         var hangarWIO:WorldItemObject = Hangar(this.mHangars[id]).getWIO();
         InstanceMng.getUnitScene().shipsUnplaceShipsWarOnHangar(hangarWIO);
      }
      
      public function addByItem(item:WorldItemObject) : void
      {
         var sku:String = null;
         var def:WorldItemDef = null;
         var capacity:int = 0;
         var sid:String = item.mSid;
         if(this.mHangars[sid] == null)
         {
            sku = item.mDef.mSku;
            def = this.mWorldItemDefMngRef.getDefBySku(sku) as WorldItemDef;
            capacity = def.getShipCapacity();
            this.mHangars[sid] = new Hangar(sid,capacity,item);
         }
         else
         {
            this.mHangars[sid].setWIO(item);
         }
      }
      
      public function removeBySid(id:String) : void
      {
         if(this.mHangars[id] != null)
         {
            this.unsummonShipsInHangar(id);
            this.mHangars[id].destroy();
            delete this.mHangars[id];
         }
      }
      
      public function getFromSid(id:String) : Hangar
      {
         return this.mHangars[id];
      }
      
      private function sumOverHangars(op:Function) : int
      {
         var idx:* = null;
         var sum:int = 0;
         for(idx in this.mHangars)
         {
            sum += op(this.mHangars[idx]);
         }
         return sum;
      }
      
      public function getTotalCapacityOccupied() : int
      {
         return this.sumOverHangars(function(hg:Hangar):int
         {
            return hg.getCapacityOccupied();
         });
      }
      
      public function getTotalMaxCapacity() : int
      {
         return this.sumOverHangars(function(hg:Hangar):int
         {
            return hg.getMaxCapacity();
         });
      }
      
      public function canAdd(size:int) : Boolean
      {
         var availableHangars:int = this.sumOverHangars(function(hg:Hangar):int
         {
            var worldObj:WorldItemObject = hg.getWIO();
            if(worldObj != null)
            {
               if(!worldObj.isBroken())
               {
                  return 1;
               }
            }
            return 0;
         });
         if(availableHangars <= 0)
         {
            return false;
         }
         return this.getTotalCapacityOccupied() + size <= this.getTotalMaxCapacity();
      }
      
      public function getAvailableCapacity() : Vector.<int>
      {
         var idx:* = null;
         var hangar:Hangar = null;
         var result:Vector.<int> = new Vector.<int>(0);
         for(idx in this.mHangars)
         {
            hangar = this.mHangars[idx];
            result.push(hangar.getCapacityLeft());
         }
         return result;
      }
      
      public function getUnitsInAllHangars() : Vector.<Array>
      {
         var shipDef:ShipDef = null;
         var count:int = 0;
         var hangar:Hangar = null;
         var v:Array = null;
         var result:Vector.<Array> = new Vector.<Array>(0);
         var idxMap:Object = {};
         var unitsDefs:Vector.<DCDef> = InstanceMng.getGameUnitMngController().getGameUnitMng().getAllUnitsCurrentDef();
         for each(shipDef in unitsDefs)
         {
            count = 0;
            for each(hangar in this.mHangars)
            {
               count += hangar.getUnitCountForDef(shipDef);
            }
            if(count > 0)
            {
               (v = [])[0] = shipDef.mSku;
               v[2] = shipDef;
               v[3] = count.toString();
               result.push(v);
            }
         }
         return result;
      }
      
      public function getHangarContainingSku(sku:String) : Hangar
      {
         var hangar:Hangar = null;
         var units:Vector.<Array> = null;
         var unit:Array = null;
         for each(hangar in this.mHangars)
         {
            units = hangar.getWarUnitsInfoAsVector();
            for each(unit in units)
            {
               if(unit[0] === sku)
               {
                  return hangar;
               }
            }
         }
         return null;
      }
      
      public function getHangarForDef(def:ShipDef, store:Boolean) : Hangar
      {
         var hangar:Hangar = null;
         var id:String = def.mSku;
         var space:int = def.getSize();
         var defaultHangar:* = null;
         for each(hangar in this.mHangars)
         {
            if(hangar.canStoreItem(space) && !hangar.getWIO().isBroken() && !hangar.getWIO().needsRepairs())
            {
               if(store)
               {
                  hangar.store(id,space,false);
               }
               return hangar;
            }
            if(defaultHangar === null)
            {
               defaultHangar = hangar;
            }
         }
         if(defaultHangar != null && store && this.canAdd(def.getSize()))
         {
            defaultHangar.store(id,space,false);
         }
         return defaultHangar;
      }
      
      public function getHangarsSpaceLeft() : int
      {
         var h:Hangar = null;
         var result:int = 0;
         for each(h in this.mHangars)
         {
            result += h.getCapacityLeft();
         }
         return result;
      }
      
      public function areHangarsEmpty() : Boolean
      {
         var h:Hangar = null;
         for each(h in this.mHangars)
         {
            if(h.isEmpty() == false)
            {
               return false;
            }
         }
         return true;
      }
      
      public function removeUnits(sid:String) : void
      {
         var hangar:Hangar = this.mHangars[sid];
         if(hangar == null)
         {
            return;
         }
         if(hangar.isEmpty())
         {
            return;
         }
         this.unsummonShipsInHangar(sid);
         Hangar(this.mHangars[sid]).removeUnits();
      }
      
      public function getStoredUnitsInfo() : Vector.<Array>
      {
         var i:int = 0;
         var amount:int = 0;
         var shipsArr:Array = null;
         var shipInfoVector:Vector.<String> = null;
         var shipSku:String = null;
         var hangar:Hangar = null;
         var unitsDefs:Vector.<DCDef> = null;
         var shipDef:ShipDef = null;
         var v:Vector.<Array> = null;
         var gArr:Array = [];
         var gArrLength:int = 0;
         for each(hangar in this.mHangars)
         {
            shipsArr = hangar.getWarUnitsInfo();
            for each(shipInfoVector in shipsArr)
            {
               shipSku = String(shipInfoVector[0]);
               if(gArr[shipSku] == null)
               {
                  gArrLength++;
                  gArr[shipSku] = [];
                  gArr[shipSku][0] = shipSku;
                  gArr[shipSku][1] = "";
                  gArr[shipSku][2] = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(shipSku).mDef;
                  gArr[shipSku][3] = 0;
                  gArr[shipSku][4] = true;
               }
               amount = int(shipInfoVector[3]);
               for(i = 0; i < amount; )
               {
                  gArr[shipSku][1] += shipInfoVector[1] + ",";
                  i++;
               }
               gArr[shipSku][3] += amount;
            }
         }
         unitsDefs = InstanceMng.getShipDefMng().getDefsSorted(true,true);
         v = new Vector.<Array>(gArrLength);
         i = 0;
         for each(shipDef in unitsDefs)
         {
            shipsArr = gArr[shipDef.mSku];
            if(shipsArr != null)
            {
               v[i++] = shipsArr;
            }
         }
         return v;
      }
      
      public function getUnitsInfo() : Object
      {
         var hangar:Hangar = null;
         var returnValue:Object = {};
         for each(hangar in this.mHangars)
         {
            returnValue[int(hangar.getSid())] = hangar.getUnitsInfo();
         }
         return returnValue;
      }
      
      public function getUnitsInfoBySid(sid:String) : Object
      {
         var returnValue:Object = null;
         var hangar:Hangar = this.getFromSid(sid);
         if(hangar != null)
         {
            returnValue = hangar.getUnitsInfo();
         }
         return returnValue;
      }
      
      public function getAllUnitsStored() : Vector.<Array>
      {
         var result:Vector.<Array> = this.getStoredUnitsInfo();
         result = this.setupHangarUnitsArray(result,InstanceMng.getMissionsMng().getExtraUnitsForUncompletedTargets(this.HANGAR_ID_ALLY));
         return result.concat(this.getUnitsFromInventory());
      }
      
      private function setupHangarUnitsArray(hangarUnitsInfo:Vector.<Array>, extraUnitsInfo:Vector.<Array>) : Vector.<Array>
      {
         var def:DCDef = null;
         var sku:String = null;
         var added:Boolean = false;
         var idx:int = 0;
         if(hangarUnitsInfo == null)
         {
            return extraUnitsInfo;
         }
         if(extraUnitsInfo == null)
         {
            return hangarUnitsInfo;
         }
         var unitsSkus:Array = DCUtils.vector2Array(hangarUnitsInfo).map(this.mapGetSku);
         var extrasSkus:Array = DCUtils.vector2Array(extraUnitsInfo).map(this.mapGetSku);
         var ret:Vector.<Array> = new Vector.<Array>(0);
         var unitsDefs:Vector.<DCDef> = InstanceMng.getShipDefMng().getDefsSorted(true,true);
         for each(def in unitsDefs)
         {
            sku = String(def.mSku);
            added = false;
            if((idx = extrasSkus.indexOf(sku)) > -1)
            {
               ret.push(extraUnitsInfo[idx]);
               added = true;
            }
            if((idx = unitsSkus.indexOf(sku)) > -1)
            {
               if(added)
               {
                  ret[ret.length - 1][1] += hangarUnitsInfo[idx][1];
                  ret[ret.length - 1][3] += hangarUnitsInfo[idx][3];
               }
               else
               {
                  ret.push(hangarUnitsInfo[idx]);
               }
            }
         }
         return ret;
      }
      
      private function mapGetSku(element:Array, index:int, array:Array) : String
      {
         return element[0];
      }
      
      private function getUnitsFromInventory() : Vector.<Array>
      {
         var gArr:Array = null;
         var item:ItemObject = null;
         var unitSku:String = null;
         var items:Vector.<ItemObject> = InstanceMng.getItemsMng().getItemsDeployUnits();
         var v:Vector.<Array> = new Vector.<Array>(0);
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         for each(item in items)
         {
            gArr = [];
            unitSku = item.mDef.getActionParam();
            gArr[0] = unitSku;
            gArr[1] = "";
            gArr[2] = unitScene.unitsGetUnitDefFromSkuAndUpgradeId(unitSku);
            gArr[3] = item.quantity;
            gArr[4] = false;
            gArr[5] = item.mDef.mSku;
            v.push(gArr);
         }
         return v;
      }
      
      public function removeUnitsFromHangars(selectedUnits:Vector.<Array>, removeFromView:Boolean = true) : void
      {
         var unitSku:String = null;
         var hangarIds:String = null;
         var amount:int = 0;
         var i:int = 0;
         var hangarIdArr:Array = null;
         var unitsArr:Array = null;
         for each(unitsArr in selectedUnits)
         {
            unitSku = String(unitsArr[0]);
            hangarIds = String(unitsArr[1]);
            amount = int(unitsArr[3]);
            hangarIdArr = hangarIds.split(",");
            for(i = 0; i < amount; )
            {
               hangarIds = String(hangarIdArr[i]);
               if(this.mHangars[hangarIds] != null)
               {
                  Hangar(this.mHangars[hangarIds]).removeUnit(unitSku,removeFromView);
               }
               i++;
            }
         }
      }
      
      public function battlePrepareUnitsInHangars() : void
      {
         var hangar:Hangar = null;
         for each(hangar in this.mHangars)
         {
            hangar.battlePrepareUnits();
         }
      }
      
      public function battleRestoreUnitsInHangarsAfterBattle() : void
      {
         var hangar:Hangar = null;
         for each(hangar in this.mHangars)
         {
            hangar.battleRestoreUnitsAfterBattle();
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         return true;
      }
   }
}
