package com.dchoc.game.model.gameunit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class GameUnitMng extends DCComponent
   {
       
      
      private var mGameUnits:Dictionary;
      
      private var mUpgradingUnits:Vector.<GameUnit>;
      
      private var mUnlockingUnit:GameUnit;
      
      private var mUpgradingUnit:GameUnit;
      
      public function GameUnitMng()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && InstanceMng.getWorld().isBuilt() && InstanceMng.getShipDefMng().isBuilt())
         {
            if(this.mGameUnits == null)
            {
               this.mGameUnits = new Dictionary();
               this.mUpgradingUnits = new Vector.<GameUnit>(0);
               this.mUnlockingUnit = null;
            }
            this.loadFromXML();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.unbuildMode(InstanceMng.getApplication().mFlowStateUnbuildMode);
      }
      
      override public function unbuildMode(mode:int) : void
      {
         if(mode == 1)
         {
            this.mGameUnits = null;
            this.mUpgradingUnits.length = 0;
            this.mUpgradingUnits = null;
            this.mUnlockingUnit = null;
            this.mUpgradingUnit = null;
         }
      }
      
      override public function persistenceGetData() : XML
      {
         var gu:GameUnit = null;
         var str:* = null;
         var xml:XML = EUtils.stringToXML("<GameUnits/>");
         for each(gu in this.mGameUnits)
         {
            if(gu.mDef != null)
            {
               str = "<GameUnit sku=\"" + gu.mSku + "\" upgradeId=\"" + gu.mDef.getUpgradeId() + "\" unlocked=\"" + int(gu.mIsUnlocked) + "\" timeLeft=\"" + gu.mTimeLeft + "\"/>";
               xml.appendChild(EUtils.stringToXML(str));
            }
         }
         return xml;
      }
      
      private function addToDictionary(gameUnit:GameUnit) : void
      {
         this.mGameUnits[gameUnit.mSku] = gameUnit;
      }
      
      public function addToUpgrading(gameUnit:GameUnit) : void
      {
         if(this.mGameUnits[gameUnit.mSku] == null)
         {
            return;
         }
         if(gameUnit.mTimeLeft > -1)
         {
            this.mUpgradingUnits.push(gameUnit);
            if(gameUnit.mIsUnlocked == true)
            {
               this.mUpgradingUnit = gameUnit;
            }
         }
         if(gameUnit.mIsUnlocked == false)
         {
            this.mUnlockingUnit = gameUnit;
         }
      }
      
      public function getUpgradingUnitsByIndex() : GameUnit
      {
         var gu:GameUnit = null;
         if(this.mUpgradingUnits != null)
         {
            var _loc3_:int = 0;
            var _loc2_:* = this.mUpgradingUnits;
            for each(gu in _loc2_)
            {
               return gu;
            }
         }
         return null;
      }
      
      public function isUnitBeingUpgraded(sku:String) : Boolean
      {
         var gu:GameUnit = null;
         if(this.mUpgradingUnits != null)
         {
            for each(gu in this.mUpgradingUnits)
            {
               if(gu.mDef.getSku() == sku)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function getCurrentUpgradeIdBySku(sku:String) : int
      {
         return this.getGameUnitBySku(sku).mDef.getUpgradeId();
      }
      
      public function getUnlockingUnit() : GameUnit
      {
         return this.mUnlockingUnit;
      }
      
      public function getUpgradingUnit() : GameUnit
      {
         return this.mUpgradingUnit;
      }
      
      private function loadFromXML() : void
      {
         var gameUnit:GameUnit = null;
         var key:* = null;
         var sku:String = null;
         var upgradeId:int = 0;
         var isUnlocked:Boolean = false;
         var timeLeft:Number = NaN;
         var xml:XML = null;
         var rulesUnits:Dictionary = this.loadFromDefinitions();
         var persistenceUnits:Dictionary = new Dictionary();
         if(mPersistenceData != "")
         {
            for each(xml in EUtils.xmlGetChildrenList(mPersistenceData,"GameUnit"))
            {
               sku = EUtils.xmlReadString(xml,"sku");
               upgradeId = EUtils.xmlReadInt(xml,"upgradeId");
               timeLeft = EUtils.xmlReadNumber(xml,"timeLeft");
               isUnlocked = EUtils.xmlReadBoolean(xml,"unlocked");
               gameUnit = GameUnit.createGameUnit(sku,InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,upgradeId),timeLeft,isUnlocked,this);
               persistenceUnits[sku] = gameUnit;
            }
         }
         for(key in rulesUnits)
         {
            gameUnit = persistenceUnits[key] == null ? rulesUnits[key] : persistenceUnits[key];
            this.addToDictionary(gameUnit);
            if(gameUnit.mTimeLeft >= 0)
            {
               this.addToUpgrading(gameUnit);
            }
         }
      }
      
      private function loadFromDefinitions() : Dictionary
      {
         var gameUnit:GameUnit = null;
         var def:ShipDef = null;
         var unlocked:* = false;
         var ret:Dictionary = new Dictionary();
         var vGroups:Vector.<String> = new Vector.<String>(0);
         vGroups.push(ShipDefMng.TYPE_SKUS[2]);
         vGroups.push(ShipDefMng.TYPE_SKUS[3]);
         vGroups.push(ShipDefMng.TYPE_SKUS[0]);
         var vDefs:Vector.<DCDef> = InstanceMng.getShipDefMng().getDefs(vGroups);
         for each(def in vDefs)
         {
            if(def != null && def.getUpgradeId() == 0)
            {
               unlocked = !def.getStartLocked();
               gameUnit = GameUnit.createGameUnit(def.mSku,def,-1,unlocked,this);
               ret[gameUnit.mSku] = gameUnit;
            }
         }
         return ret;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var gu:GameUnit = null;
         var nextDef:ShipDef = null;
         var hasUpgraded:Boolean = false;
         var hasUnlocked:Boolean = false;
         var popupObject:Object = null;
         if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() != 0)
         {
            return;
         }
         var idx:int = 0;
         for each(gu in this.mUpgradingUnits)
         {
            popupObject = null;
            hasUnlocked = false;
            hasUpgraded = gu.logicUpdate(dt);
            if(gu.mIsUnlocked == true && this.mUnlockingUnit == gu)
            {
               this.mUnlockingUnit = null;
               hasUnlocked = true;
            }
            if(hasUpgraded)
            {
               this.mUpgradingUnits.splice(idx,1);
               if(this.mUpgradingUnit == gu)
               {
                  this.mUpgradingUnit = null;
               }
            }
            if(hasUpgraded || hasUnlocked)
            {
               this.setUnitUpgraded(gu,hasUnlocked);
            }
            if(hasUpgraded)
            {
               return;
            }
            idx++;
         }
      }
      
      public function setUnitUpgraded(gu:GameUnit, hasUnlocked:Boolean) : void
      {
         var popupObject:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_UNIT_UPGRADED",null,null,null,null,gu.mDef);
         popupObject.hasUnlocked = hasUnlocked;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),popupObject,true);
      }
      
      public function getGameUnitBySku(sku:String) : GameUnit
      {
         return this.mGameUnits[sku];
      }
      
      public function pauseUpgrading() : void
      {
         if(this.mUpgradingUnit != null)
         {
            this.mUpgradingUnit.mPaused = true;
         }
      }
      
      public function resumeUpgrading() : void
      {
         if(this.mUpgradingUnit != null)
         {
            this.mUpgradingUnit.mPaused = false;
         }
      }
      
      public function cancelCurrentAction(gu:GameUnit) : void
      {
         var idx:int = 0;
         if(gu != this.mUnlockingUnit && gu != this.mUpgradingUnit)
         {
            return;
         }
         if(gu == this.mUnlockingUnit)
         {
            this.mUnlockingUnit.mTimeLeft = -1;
            this.returnCostToPlayer(this.mUnlockingUnit.mDef,true);
            idx = this.mUpgradingUnits.indexOf(this.mUnlockingUnit);
            if(idx > -1)
            {
               this.mUpgradingUnits.splice(idx,1);
            }
            this.mUnlockingUnit = null;
            return;
         }
         if(gu == this.mUpgradingUnit)
         {
            this.mUpgradingUnit.mTimeLeft = -1;
            this.returnCostToPlayer(this.mUpgradingUnit.getNextDef(),false);
            idx = this.mUpgradingUnits.indexOf(this.mUpgradingUnit);
            if(idx > -1)
            {
               this.mUpgradingUnits.splice(idx,1);
            }
            this.mUpgradingUnit = null;
            return;
         }
      }
      
      private function returnCostToPlayer(unitDef:ShipDef, isUnlock:Boolean) : void
      {
         var t:Transaction = InstanceMng.getRuleMng().getTransactionCancelGameUnit(unitDef);
         if(t.performAllTransactions() == true)
         {
            if(isUnlock)
            {
               InstanceMng.getUserDataMng().updateGameUnits_unlockCancel(unitDef.mSku,t);
            }
            else
            {
               InstanceMng.getUserDataMng().updateGameUnits_upgradeCancel(unitDef.mSku,unitDef.getUpgradeId(),t);
            }
         }
      }
      
      public function isGameUnitUnlocked(sku:String) : Boolean
      {
         var g:GameUnit = this.getGameUnitBySku(sku);
         return g != null && g.isLocked() == false && g.isUnLocking() == false;
      }
      
      public function getUpgradeHqLists(hqLevel:int) : String
      {
         var gu:GameUnit = null;
         var def:ShipDef = null;
         var hqLevelNext:int = hqLevel + 1;
         for each(gu in this.mGameUnits)
         {
            if(gu.mIsUnlocked)
            {
               def = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(gu.mSku,gu.mDef.getUpgradeId() + 1);
               if(def != null && hqLevelNext == def.getUnlockHQUpgradeIdRequired())
               {
                  return DCTextMng.getText(125) + "/";
               }
            }
         }
         return "";
      }
      
      public function getAllUnitsCurrentDef(type:int = -1) : Vector.<DCDef>
      {
         var gameUnit:GameUnit = null;
         var defs:Vector.<DCDef> = new Vector.<DCDef>(0);
         for each(gameUnit in this.mGameUnits)
         {
            if(type == -1 || ShipDef(gameUnit.mDef).getUnitTypeId() == type)
            {
               defs.push(gameUnit.mDef);
            }
         }
         return defs;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var gameUnit:GameUnit = null;
         if(e.cmd == "NOTIFY_POPUP_OPEN_SPEEDITEM")
         {
            gameUnit = this.mGameUnits[e.unitSku];
            if(gameUnit != null)
            {
               gameUnit.mTimeLeft = -1;
               gameUnit.upgradeUnit(e.transaction,null);
               this.logicUpdateDo(0);
            }
         }
         return true;
      }
   }
}
