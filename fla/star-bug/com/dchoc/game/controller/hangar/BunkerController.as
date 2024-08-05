package com.dchoc.game.controller.hangar
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EUtils;
   
   public class BunkerController extends HangarController
   {
      
      private static const WAR_UNIT_BUNKERSIDS:int = 1;
       
      
      private var mBunkers:Array;
      
      public function BunkerController()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mBunkers = [];
            mWorldItemDefMngRef = InstanceMng.getWorldItemDefMng();
         }
      }
      
      override protected function unloadDo() : void
      {
         var bunker:Bunker = null;
         for each(bunker in this.mBunkers)
         {
            bunker.unload();
         }
         this.mBunkers.length = 0;
         this.mBunkers = null;
         mWorldItemDefMngRef = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && mPersistenceData != null && InstanceMng.getWorld().isBuilt())
         {
            this.loadFromXML();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mBunkers.length = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var bunker:Bunker = null;
         for each(bunker in this.mBunkers)
         {
            bunker.logicUpdate(dt);
         }
      }
      
      override public function persistenceGetData() : XML
      {
         var bunker:Hangar = null;
         var persistence:XML = EUtils.stringToXML("<Bunkers/>");
         for each(bunker in this.mBunkers)
         {
            persistence.appendChild(bunker.persistenceGetData());
         }
         return persistence;
      }
      
      override protected function loadFromXML() : void
      {
         var bunkerXML:XML = null;
         var unitXML:XML = null;
         var sid:String = null;
         var maxCapacity:int = 0;
         var unitSku:String = null;
         var spaceOccupied:int = 0;
         var bunker:Bunker = null;
         var bunkerWIO:WorldItemObject = null;
         var def:ShipDef = null;
         var storeOk:Boolean = false;
         var helpers:String = null;
         var item:WorldItemObject = null;
         var world:World = InstanceMng.getWorld();
         var shipDefMng:ShipDefMng = InstanceMng.getShipDefMng();
         var helpersList:Array = [];
         for each(bunkerXML in EUtils.xmlGetChildrenList(mPersistenceData,"Bunker"))
         {
            sid = EUtils.xmlReadString(bunkerXML,"sid");
            helpers = EUtils.xmlReadString(bunkerXML,"helpersAccountIds");
            helpersList = helpers != "" ? helpers.split(",") : null;
            item = world.itemsGetItemBySid(sid);
            if(item != null)
            {
               maxCapacity = item.mDef.getShipCapacity();
               bunker = this.mBunkers[sid];
               if(bunker != null)
               {
                  if(helpersList != null)
                  {
                     bunker.setHelpUserAccountIds(helpersList);
                  }
                  bunkerWIO = bunker.getWIO();
                  for each(unitXML in EUtils.xmlGetChildrenList(bunkerXML,"Unit"))
                  {
                     unitSku = EUtils.xmlReadString(unitXML,"sku");
                     if((def = shipDefMng.getDefBySku(unitSku) as ShipDef) == null)
                     {
                        if(Config.DEBUG_ASSERTS)
                        {
                           DCDebug.trace("WARNING in BunkerController.loadFromXML(): units sku <" + unitSku + "> not valid",1);
                        }
                     }
                     else
                     {
                        spaceOccupied = def.getSize();
                        if((storeOk = checkDependingOnRole(bunker,bunkerWIO,spaceOccupied,true)) == false && bunkerWIO.isCompletelyBroken())
                        {
                           storeOk = true;
                        }
                        if(storeOk)
                        {
                           bunker.store(unitSku,spaceOccupied,true,false);
                        }
                     }
                  }
               }
            }
         }
      }
      
      override public function addByItem(item:WorldItemObject) : void
      {
         var sku:String = null;
         var def:WorldItemDef = null;
         var capacity:int = 0;
         var sid:String = item.mSid;
         if(this.mBunkers[sid] == null)
         {
            sku = item.mDef.mSku;
            def = mWorldItemDefMngRef.getDefBySku(sku) as WorldItemDef;
            capacity = def.getShipCapacity();
            this.mBunkers[sid] = new Bunker(sid,capacity,item);
            if(isBuilt())
            {
            }
         }
         else
         {
            this.mBunkers[sid].setWIO(item);
            if(isBuilt())
            {
            }
         }
      }
      
      override public function removeBySid(id:String) : void
      {
         if(this.mBunkers[id] != null)
         {
            this.mBunkers[id].destroy();
            delete this.mBunkers[id];
         }
      }
      
      override public function getFromSid(id:String) : Hangar
      {
         return this.mBunkers[id];
      }
      
      public function getAllItems() : Array
      {
         return this.mBunkers;
      }
      
      override public function removeUnits(sid:String) : void
      {
         var bunker:Bunker = this.mBunkers[sid];
         if(bunker == null)
         {
            return;
         }
         if(bunker.isEmpty())
         {
            return;
         }
         Bunker(this.mBunkers[sid]).removeUnits();
      }
      
      override public function getStoredUnitsInfo() : Vector.<Array>
      {
         var i:int = 0;
         var amount:int = 0;
         var unitsArr:Array = null;
         var unitInfoVector:Vector.<String> = null;
         var sku:String = null;
         var bunker:Hangar = null;
         var v:Vector.<Array> = null;
         var gArr:Array = [];
         var gArrLength:int = 0;
         for each(bunker in this.mBunkers)
         {
            unitsArr = bunker.getWarUnitsInfo();
            for each(unitInfoVector in unitsArr)
            {
               sku = String(unitInfoVector[0]);
               if(gArr[sku] == null)
               {
                  gArrLength++;
                  gArr[sku] = [];
                  gArr[sku][0] = sku;
                  gArr[sku][1] = "";
                  gArr[sku][2] = InstanceMng.getShipDefMng().getDefBySku(sku);
                  gArr[sku][3] = 0;
               }
               amount = int(unitInfoVector[3]);
               for(i = 0; i < amount; )
               {
                  gArr[sku][1] += unitInfoVector[1] + ",";
                  i++;
               }
               gArr[sku][3] += amount;
            }
         }
         v = new Vector.<Array>(gArrLength,true);
         i = 0;
         for each(unitsArr in gArr)
         {
            v[i++] = unitsArr;
         }
         return v;
      }
      
      public function areBunkersEmpty() : Boolean
      {
         var b:Bunker = null;
         for each(b in this.mBunkers)
         {
            if(b.isEmpty() == false)
            {
               return false;
            }
         }
         return true;
      }
      
      public function unitGettingBunker(u:MyUnit, hangar:Hangar) : void
      {
         if(hangar == null || !hangar.isAlive())
         {
            u.exitSceneStart(1);
         }
         else if(u.goalGetForCurrentId() == "unitGoalForReturnToBunker")
         {
            Bunker(hangar).battleUnitHasReturned(u);
         }
         else
         {
            hangar.receiveUnit(u);
         }
      }
      
      public function getUnitsScoreAttack() : Number
      {
         var bunker:Bunker = null;
         var result:Number = 0;
         for each(bunker in this.mBunkers)
         {
            if(bunker.isAlive() && !bunker.isEmpty())
            {
               result += bunker.getUnitsScoreAttack();
            }
         }
         return result;
      }
      
      override public function battlePrepareUnitsInHangars() : void
      {
         var bunker:Bunker = null;
         for each(bunker in this.mBunkers)
         {
            bunker.battlePrepareUnits();
         }
      }
      
      override public function battleRestoreUnitsInHangarsAfterBattle() : void
      {
         var bunker:Bunker = null;
         for each(bunker in this.mBunkers)
         {
            bunker.battleRestoreUnitsAfterBattle();
         }
      }
      
      override public function summonShipsInHangars() : void
      {
      }
      
      override public function getHangarForDef(def:ShipDef, store:Boolean) : Hangar
      {
         return null;
      }
      
      override public function areHangarsEmpty() : Boolean
      {
         return false;
      }
      
      override public function removeUnitsFromHangars(selectedUnits:Vector.<Array>, fromView:Boolean = true) : void
      {
      }
   }
}
