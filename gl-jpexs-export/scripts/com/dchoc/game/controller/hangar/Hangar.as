package com.dchoc.game.controller.hangar
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class Hangar
   {
      
      public static const WAR_UNIT_SKU:int = 0;
      
      public static const WAR_UNIT_HANGARID:int = 1;
      
      public static const WAR_UNIT_DEF:int = 2;
      
      public static const WAR_UNIT_AMOUNT:int = 3;
      
      private static const WAR_VECTOR_LENGTH:int = 5;
       
      
      protected var mId:String;
      
      protected var mCapacityOccupied:int;
      
      protected var mWorldItemObjectRef:WorldItemObject;
      
      protected var mWorldItemObjectSid:String;
      
      protected var mUnitIds:Vector.<String>;
      
      protected var mUnitSizes:Vector.<int>;
      
      protected var mUnitStoredInside:Vector.<Boolean>;
      
      protected var mCurrentUnitPointer:int;
      
      private var mHelpUserAccountIds:Vector.<String>;
      
      private var mHelpUserAccountIdsThanked:Vector.<String>;
      
      private var mBattleUnitsEnergy:Vector.<Number>;
      
      private var mUnitsOnItsWayToRemove:Dictionary;
      
      private var mUnitsOnItsWayToSendToBunker:Dictionary;
      
      public function Hangar(id:String, capacity:int, item:WorldItemObject = null)
      {
         super();
         this.mId = id;
         this.mCapacityOccupied = 0;
         this.setWIO(item);
         this.mUnitIds = new Vector.<String>(0);
         this.mUnitSizes = new Vector.<int>(0);
         this.mUnitStoredInside = new Vector.<Boolean>(0);
         this.mCurrentUnitPointer = 0;
         this.helpLoad();
      }
      
      public function getSid() : String
      {
         return this.mId;
      }
      
      public function unload() : void
      {
         this.mUnitIds = null;
         this.mUnitSizes = null;
         this.mUnitStoredInside = null;
         this.helpUnload();
         this.battleUnload();
         this.unitsOnItsWayUnload();
         this.mWorldItemObjectRef = null;
      }
      
      public function destroy() : void
      {
         this.unload();
      }
      
      public function isAlive() : Boolean
      {
         return this.mWorldItemObjectRef != null;
      }
      
      public function getWIO() : WorldItemObject
      {
         return this.mWorldItemObjectRef;
      }
      
      public function setWIO(wio:WorldItemObject) : void
      {
         this.mWorldItemObjectRef = wio;
         if(wio != null)
         {
            this.mWorldItemObjectSid = wio.mSid;
         }
      }
      
      public function getWIOSid() : String
      {
         return this.mWorldItemObjectSid;
      }
      
      public function getCapacityOccupied() : int
      {
         return this.mCapacityOccupied;
      }
      
      public function getCapacityLeft() : int
      {
         return this.mWorldItemObjectRef.mDef.getShipCapacity() - this.mCapacityOccupied;
      }
      
      public function getMaxCapacity() : int
      {
         return this.mWorldItemObjectRef.mDef.getShipCapacity();
      }
      
      public function canStoreItem(spaceAmount:int) : Boolean
      {
         if(this.mWorldItemObjectRef != null && this.mWorldItemObjectRef.isConnected() && this.mWorldItemObjectRef.isBroken() == false && this.mWorldItemObjectRef.mServerStateId == 1)
         {
            return this.mCapacityOccupied + spaceAmount <= this.mWorldItemObjectRef.mDef.getShipCapacity();
         }
         return false;
      }
      
      public function storeUnitsAmount(sku:String, unitsAmount:int) : void
      {
         var i:int = 0;
         var def:ShipDef = ShipDef(InstanceMng.getShipDefMng().getDefBySku(sku));
         var space:int = def.getSize();
         for(i = 0; i < unitsAmount; )
         {
            this.store(sku,space);
            i++;
         }
      }
      
      public function store(id:String, spaceAmount:int, inside:Boolean = false, doEvent:Boolean = true) : void
      {
         this.mCapacityOccupied += spaceAmount;
         var parkedInside:Boolean = true;
         if(!inside)
         {
            parkedInside = false;
         }
         this.mUnitIds.push(id);
         this.mUnitSizes.push(spaceAmount);
         this.mUnitStoredInside.push(parkedInside);
         this.mCurrentUnitPointer++;
         if(doEvent)
         {
            InstanceMng.getTargetMng().updateProgress("build",1,id);
         }
      }
      
      public function latestShipParkedInside() : Boolean
      {
         return this.mUnitStoredInside[this.mCurrentUnitPointer - 1];
      }
      
      public function getUnitPositionFromSku(sku:String) : int
      {
         var i:int = 0;
         for(i = 0; i < this.mCurrentUnitPointer; )
         {
            if(this.mUnitIds[i] == sku)
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      public function removeUnit(unitSku:String, fromView:Boolean = true, location:int = -1, deleteFromOutside:Boolean = true) : Boolean
      {
         var count:int = 0;
         var returnValue:Boolean = true;
         if(location == -1)
         {
            location = this.getUnitPositionFromSku(unitSku);
         }
         if(location == -1)
         {
            return false;
         }
         var freedSpace:int = this.mUnitSizes[location];
         this.mCapacityOccupied -= freedSpace;
         if(this.mUnitStoredInside[location] == false && fromView)
         {
            if((count = InstanceMng.getUnitScene().shipsUnplaceShipsWarOnHangar(this.mWorldItemObjectRef,this.mUnitIds[location],1)) == 0)
            {
               this.unitsOnItsWayRemoveUnit(this.mUnitIds[location]);
            }
         }
         this.mUnitIds.splice(location,1);
         this.mUnitSizes.splice(location,1);
         this.mUnitStoredInside.splice(location,1);
         if(this.mBattleUnitsEnergy != null && location >= 0)
         {
            this.mBattleUnitsEnergy.splice(location,1);
         }
         this.mCurrentUnitPointer--;
         InstanceMng.getTargetMng().updateProgress("killOwnUnit",1,unitSku);
         return returnValue;
      }
      
      public function removeUnits() : void
      {
         this.mUnitIds.length = 0;
         this.mUnitStoredInside.length = 0;
         this.mUnitSizes.length = 0;
         this.mCurrentUnitPointer = 0;
         this.mCapacityOccupied = 0;
      }
      
      public function isEmpty() : Boolean
      {
         return this.getCapacityOccupied() == 0;
      }
      
      public function isFull() : Boolean
      {
         return this.getCapacityOccupied() >= this.getMaxCapacity();
      }
      
      public function getWarUnitsInfo() : Array
      {
         var unitsku:String = null;
         var arr:Array = [];
         for each(unitsku in this.mUnitIds)
         {
            if(unitsku != null)
            {
               if(arr[unitsku] == null)
               {
                  arr[unitsku] = new Vector.<String>(5,true);
                  arr[unitsku][0] = unitsku;
                  arr[unitsku][1] = this.mId;
                  arr[unitsku][2] = null;
                  arr[unitsku][3] = 0;
               }
               arr[unitsku][3]++;
            }
         }
         return arr;
      }
      
      public function getWarUnitsInfoAsVector() : Vector.<Array>
      {
         var values:Vector.<String> = null;
         var shipDef:ShipDef = null;
         var v:Vector.<Array> = new Vector.<Array>(0);
         var arr:Array = this.getWarUnitsInfo();
         var i:int = 0;
         var unitsDefs:Vector.<DCDef> = InstanceMng.getGameUnitMngController().getGameUnitMng().getAllUnitsCurrentDef();
         for each(shipDef in unitsDefs)
         {
            if((values = arr[shipDef.mSku]) != null)
            {
               v.push([]);
               v[i][0] = values[0];
               v[i][1] = values[1];
               v[i][2] = shipDef;
               v[i][3] = values[3];
               i++;
            }
         }
         return v;
      }
      
      public function getUnitCountForDef(shipDef:ShipDef) : int
      {
         var values:Vector.<String> = this.getWarUnitsInfo()[shipDef.mSku];
         if(values != null)
         {
            return parseInt(values[3]);
         }
         return 0;
      }
      
      public function getUnitsInfo() : Object
      {
         var unitsku:String = null;
         var returnValue:Object = {};
         for each(unitsku in this.mUnitIds)
         {
            if(unitsku != null)
            {
               if(returnValue[unitsku] == null)
               {
                  returnValue[unitsku] = 0;
               }
               returnValue[unitsku]++;
            }
         }
         return returnValue;
      }
      
      public function getStoredOutsideUnits() : String
      {
         var i:int = 0;
         var s:String = "";
         for(i = 0; i < this.mCurrentUnitPointer; )
         {
            if(this.mUnitStoredInside[i] == false)
            {
               s += this.mUnitIds[i] + ",";
            }
            i++;
         }
         return s;
      }
      
      public function redirectUnits() : void
      {
         InstanceMng.getUnitScene().unitsInItemGoToItem(this.mWorldItemObjectRef,this.mWorldItemObjectRef,"unitGoalForReturnToHangar");
      }
      
      public function persistenceGetData() : XML
      {
         var i:int = 0;
         var shipId:String = null;
         var unitStr:* = null;
         var persistence:XML = EUtils.stringToXML("<Hangar sid=\"" + this.mId + "\"/>");
         for(i = 0; i < this.mCurrentUnitPointer; )
         {
            unitStr = "<Unit sku= \"" + this.mUnitIds[i] + "\"/>";
            persistence.appendChild(EUtils.stringToXML(unitStr));
            i++;
         }
         return persistence;
      }
      
      public function receiveUnit(u:MyUnit) : void
      {
      }
      
      public function moveUnitsToItem(item:WorldItemObject, sku:String, amount:int) : void
      {
         var unitScene:UnitScene;
         var success:int = (unitScene = InstanceMng.getUnitScene()).unitsInItemGoToItem(this.getWIO(),item,"unitGoalForHangarToBunker",sku,amount);
         var diff:int;
         if((diff = amount - success) > 0)
         {
            this.unitsOnItsWaySendToItem(item,sku,diff);
         }
      }
      
      public function getHelpUserAccountIds() : Vector.<String>
      {
         return this.mHelpUserAccountIds;
      }
      
      public function isHelpUserThanked(accountId:String) : Boolean
      {
         return this.mHelpUserAccountIdsThanked.indexOf(accountId) >= 0;
      }
      
      public function setHelpUserThanked(accountId:String) : void
      {
         if(!this.isHelpUserThanked(accountId))
         {
            this.mHelpUserAccountIdsThanked.push(accountId);
         }
      }
      
      private function helpLoad() : void
      {
         this.mHelpUserAccountIds = new Vector.<String>(0);
         this.mHelpUserAccountIdsThanked = new Vector.<String>(0);
      }
      
      private function helpUnload() : void
      {
         this.mHelpUserAccountIds = null;
      }
      
      public function helpReceiveHelpFromUser(accountId:String, helpsUnits:Vector.<Object>) : void
      {
         var helpUnit:Object = null;
         var sku:String = null;
         var amount:int = 0;
         var size:int = 0;
         var i:int = 0;
         var pos:int;
         if((pos = this.mHelpUserAccountIds.indexOf(accountId)) == -1)
         {
            this.mHelpUserAccountIds.push(accountId);
         }
         var shipDefMng:ShipDefMng = InstanceMng.getShipDefMng();
         for each(helpUnit in helpsUnits)
         {
            sku = String(helpUnit.sku);
            amount = int(helpUnit.amount);
            size = (shipDefMng.getDefBySku(sku) as ShipDef).getSize();
            for(i = 0; i < amount; )
            {
               this.store(sku,size);
               i++;
            }
         }
      }
      
      public function setHelpUserAccountIds(userAccIds:Array) : void
      {
         var pos:int = 0;
         var i:int = 0;
         if(userAccIds != null)
         {
            if(this.mHelpUserAccountIds == null)
            {
               this.mHelpUserAccountIds = new Vector.<String>(0);
            }
            i = 0;
            while(i < userAccIds.length)
            {
               pos = this.mHelpUserAccountIds.indexOf(userAccIds[i]);
               if(pos == -1)
               {
                  this.mHelpUserAccountIds.push(userAccIds[i]);
               }
               i++;
            }
         }
      }
      
      private function battleLoad() : void
      {
         this.mBattleUnitsEnergy = new Vector.<Number>(0);
      }
      
      private function battleUnload() : void
      {
         this.mBattleUnitsEnergy = null;
      }
      
      public function battlePrepareUnits() : void
      {
         var id:String = null;
         var def:ShipDef = null;
         if(this.mBattleUnitsEnergy == null)
         {
            this.battleLoad();
         }
         else
         {
            this.mBattleUnitsEnergy.length = 0;
         }
         var defMng:ShipDefMng = InstanceMng.getShipDefMng();
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         var removeUnitsFromView:Boolean = this.battleMustRemoveUnitsView();
         if(this.mWorldItemObjectRef != null && this.mWorldItemObjectRef.mDef.isABunker())
         {
            removeUnitsFromView = false;
         }
         var count:int = 0;
         for each(id in this.mUnitIds)
         {
            def = defMng.getDefBySku(id) as ShipDef;
            this.mBattleUnitsEnergy.push(def.getMaxEnergy());
            if(removeUnitsFromView)
            {
               if((count = unitScene.shipsUnplaceShipsWarOnHangar(this.mWorldItemObjectRef,id,1)) < 1)
               {
                  this.unitsOnItsWayRemoveUnit(id);
               }
            }
         }
      }
      
      public function battleRestoreUnitsAfterBattle() : void
      {
         var id:String = null;
         var unitScene:UnitScene = null;
         var restoreUnitsToView:Boolean = this.battleMustRemoveUnitsView();
         if(restoreUnitsToView)
         {
            unitScene = InstanceMng.getUnitScene();
            for each(id in this.mUnitIds)
            {
               unitScene.shipsPlaceShipWarOnHangar(id,this.mWorldItemObjectRef);
            }
         }
      }
      
      private function battleMustRemoveUnitsView() : Boolean
      {
         var roleId:int = InstanceMng.getRole().mId;
         return roleId == 0 || roleId == 7;
      }
      
      public function battleIsHurt(damage:Number) : void
      {
         var i:int = 0;
         var energy:Number = NaN;
         var length:int = int(this.mBattleUnitsEnergy.length);
         var damagePerUnit:Number = damage / length;
         for(i = 0; i < length; )
         {
            if((energy = (energy = this.mBattleUnitsEnergy[i]) - damagePerUnit) <= 0)
            {
               this.removeUnit(this.mUnitIds[i],true,i);
               length--;
            }
            else
            {
               this.mBattleUnitsEnergy[i] = energy;
               i++;
            }
         }
      }
      
      private function unitsOnItsWayUnload() : void
      {
         this.mUnitsOnItsWayToRemove = null;
         this.mUnitsOnItsWayToSendToBunker = null;
      }
      
      private function unitsOnItsWayRemoveUnit(unitSku:String) : void
      {
         if(this.mUnitsOnItsWayToRemove == null)
         {
            this.mUnitsOnItsWayToRemove = new Dictionary(false);
         }
         if(this.mUnitsOnItsWayToRemove[unitSku] == null)
         {
            this.mUnitsOnItsWayToRemove[unitSku] = 0;
         }
         this.mUnitsOnItsWayToRemove[unitSku]++;
      }
      
      private function unitsOnItsWaySendToItem(item:WorldItemObject, unitSku:String, amount:int) : void
      {
         var i:int = 0;
         var request:Object = null;
         if(this.mUnitsOnItsWayToSendToBunker == null)
         {
            this.mUnitsOnItsWayToSendToBunker = new Dictionary(false);
         }
         if(this.mUnitsOnItsWayToSendToBunker[unitSku] == null)
         {
            this.mUnitsOnItsWayToSendToBunker[unitSku] = new Vector.<Object>(0);
         }
         var length:int = int(this.mUnitsOnItsWayToSendToBunker[unitSku].length);
         for(i = 0; i < length; )
         {
            if((request = this.mUnitsOnItsWayToSendToBunker[unitSku][i]).item == item)
            {
               break;
            }
            i++;
         }
         if(i == length)
         {
            this.mUnitsOnItsWayToSendToBunker[unitSku].push({
               "item":item,
               "amount":amount
            });
         }
         else
         {
            request.amount += amount;
         }
      }
      
      public function unitsOnItsWayCheckIsNeededToGet(u:MyUnit) : void
      {
         var request:Object = null;
         var goOn:Boolean = true;
         var sku:String = u.mDef.mSku;
         if(this.mUnitsOnItsWayToRemove != null && this.mUnitsOnItsWayToRemove[sku] > 0)
         {
            this.mUnitsOnItsWayToRemove[sku]--;
            u.exitSceneStart(1);
            goOn = false;
         }
         if(goOn && this.mUnitsOnItsWayToSendToBunker != null)
         {
            if(this.mUnitsOnItsWayToSendToBunker[sku] != null)
            {
               if(this.mUnitsOnItsWayToSendToBunker[sku].length > 0)
               {
                  request = this.mUnitsOnItsWayToSendToBunker[sku][0];
                  if(request.amount == 1)
                  {
                     this.mUnitsOnItsWayToSendToBunker[sku].splice(0,1);
                  }
                  else
                  {
                     request.amount--;
                  }
                  MyUnit.smUnitScene.unitsGoToItem(u,request.item,"unitGoalForHangarToBunker");
                  if(this.mUnitsOnItsWayToSendToBunker[sku].length == 0)
                  {
                     this.mUnitsOnItsWayToSendToBunker[sku] = null;
                  }
               }
            }
         }
      }
   }
}
