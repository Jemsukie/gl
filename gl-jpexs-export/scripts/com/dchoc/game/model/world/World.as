package com.dchoc.game.model.world
{
   import com.dchoc.game.controller.animation.JailAnimMng;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.core.utils.animations.AnimImpSWFStar;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.powerups.PowerUpDef;
   import com.dchoc.game.model.powerups.PowerUpDefMng;
   import com.dchoc.game.model.powerups.PowerUpMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.mngs.TrafficMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class World extends DCComponent
   {
      
      private static const BUILD_STEP_WAIT_FOR_MAP_BUILT:int = 0;
      
      private static const BUILD_STEP_WAIT_FOR_UNIT_FACTORY:int = 1;
      
      private static const BUILD_STEP_WAIT_FOR_PERSISTENCE:int = 2;
      
      private static const BUILD_STEP_WAIT_FOR_EXPENDABLES:int = 3;
      
      private static const BUILD_STEP_END:int = 4;
      
      private static const BUILD_STEPS_COUNT:int = 5;
      
      public static const ATTACK_NOTIFICATION_NONE:int = 0;
      
      public static const ATTACK_NOTIFICATION_BEGIN:int = 1;
      
      public static const ATTACK_NOTIFICATION_END:int = 2;
      
      public static const ATTACK_NOTIFICATION_HQ_DESTROYED:String = "ATTACK_NOTIFICATION_HQ_DESTROYED";
      
      private static const ITEMS_LIST_CAN_SPAWN_CIVILS_ID:int = 0;
      
      private static const ITEMS_LIST_CAN_GENERATE_RESOURCES_ID:int = 1;
      
      private static const ITEMS_LIST_ALL_ITEMS_ID:int = 2;
      
      private static const ITEMS_LIST_COUNT:int = 3;
      
      private static const ITEMS_LIST_IS_OWNER:Array = [false,false,true];
      
      public static const ITEMS_CRITERIA_ALREADY_BUILT:String = "_built";
      
      private static const LOOT_SAFE_ENABLED:Boolean = true;
      
      public static const ACTION_ON_ITEM_ACTION_NONE:int = -1;
      
      public static const ACTION_ON_ITEM_ACTION_UPGRADE_FROM_SOCIAL_ITEM:int = 0;
      
      private static const ACTION_ON_ITEM_STATE_NONE:int = -1;
      
      private static const ACTION_ON_ITEM_STATE_MOVE_CAMERA:int = 0;
      
      private static const ACTION_ON_ITEM_STATE_APPLYING:int = 1;
       
      
      private var mMap:MapModel;
      
      private var mViewMng:ViewMngrGame;
      
      private var mCoor:DCCoordinate;
      
      public var mStartedRepairs:Boolean;
      
      private var mShowRepairsPopup:Boolean;
      
      private var mShowRepairsPopupEnabled:Boolean = true;
      
      private var mNeedsToWaitForRepairingToStart:Boolean = false;
      
      private var mExpendablesStartDemolition:Boolean = false;
      
      private var mAttackNotification:int;
      
      private var mWorldItemObjectController:WorldItemObjectController;
      
      private var mWorldItemDefMng:WorldItemDefMng;
      
      private var mPowerUpDefMng:PowerUpDefMng;
      
      private var mPowerUpMng:PowerUpMng;
      
      private var mBuildingsScoreAttack:Number;
      
      private var mBuildingsScoreAttackWithDestroyed:Number;
      
      private var mEvent:Object = null;
      
      private var mItems:Vector.<Vector.<WorldItemObject>>;
      
      private var mItemsNextSid:int;
      
      private var mItemsHQRef:WorldItemObject;
      
      private var mItemsLabRef:WorldItemObject;
      
      private var mItemsObservatoryRef:WorldItemObject;
      
      private var mItemsListsIdsTemp:Vector.<int>;
      
      private var mItemsAmountPerKey:Dictionary;
      
      private var mItemsSig:Vector.<WorldItemObject>;
      
      private var mUnitScene:UnitScene;
      
      private var mLootMax:Dictionary;
      
      private var mLootTemp:Dictionary;
      
      public var mLootMaxBySid:Dictionary;
      
      public var mLootSoFarBySid:Dictionary;
      
      private var mLootItems:Vector.<WorldItemObject>;
      
      private var mLootMightBePreservedCoins:Vector.<WorldItemObject>;
      
      private var mLootMightBePreservedMinerals:Vector.<WorldItemObject>;
      
      private var mLootNeedsToBeCalculated:Boolean;
      
      private var mExpendables:Dictionary;
      
      private var mAllRangePreviewsVisible:Boolean = false;
      
      private var mActionOnItemActionId:int = -1;
      
      private var mActionOnItemWIO:WorldItemObject;
      
      private var mActionOnItemState:int = -1;
      
      private var mActionOnItemTimer:int;
      
      public function World()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 5;
         mBuildAsyncTotalSteps = 0;
         this.mBuildingsScoreAttack = 0;
         this.mBuildingsScoreAttackWithDestroyed = 0;
      }
      
      override protected function beginDo() : void
      {
         var ownerId:String = null;
         super.beginDo();
         var currRoleId:int = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
         var loadedAccId:String = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
         if(currRoleId == 1)
         {
            InstanceMng.getTargetMng().updateProgress("visitingCitySku",1,"",loadedAccId);
            ownerId = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
            if(ownerId != loadedAccId)
            {
               InstanceMng.getTargetMng().updateProgress("visitAnyCity",1,"");
            }
         }
         else if(currRoleId == 3)
         {
            InstanceMng.getTargetMng().updateProgress("attackingCitySku",1,"",loadedAccId);
         }
         else if(currRoleId == 2)
         {
            InstanceMng.getTargetMng().updateProgress("spyingCitySku",1,"",loadedAccId);
         }
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.itemsLoad();
            this.mCoor = new DCCoordinate();
            this.mWorldItemObjectController = InstanceMng.getWorldItemObjectController();
            this.mWorldItemDefMng = InstanceMng.getWorldItemDefMng();
            if(Config.usePowerUps())
            {
               this.mPowerUpDefMng = InstanceMng.getPowerUpDefMng();
               this.mPowerUpMng = InstanceMng.getPowerUpMng();
            }
         }
      }
      
      override protected function unloadDo() : void
      {
         this.itemsUnload();
         this.lootUnload();
         this.mCoor = null;
         this.mWorldItemObjectController = null;
         this.mWorldItemDefMng = null;
         if(Config.usePowerUps())
         {
            this.mPowerUpDefMng = null;
            this.mPowerUpMng = null;
         }
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var profile:Profile = null;
         if(step == 0)
         {
            if(this.mMap == null)
            {
               this.mMap = InstanceMng.getMapModel();
            }
            if(this.mMap.isBuilt() && InstanceMng.getMapViewPlanet().isBuilt())
            {
               this.mViewMng = InstanceMng.getMapViewPlanet().mViewMng;
               buildAdvanceSyncStep();
            }
         }
         else if(step == 1)
         {
            if(this.mUnitScene.isBuilt())
            {
               buildAdvanceSyncStep();
            }
         }
         else if(step == 2)
         {
            if(mPersistenceData != null && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt())
            {
               this.itemsBuild();
               buildAdvanceSyncStep();
            }
         }
         else if(step == 3)
         {
            profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
            if(profile.isBuilt())
            {
               this.expendablesBuild(profile.getExpendables());
               buildAdvanceSyncStep();
            }
         }
         else if(step == 4)
         {
            this.actionOnItemReset();
            this.setAttackNotification(0);
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mUnitScene.unbuild();
         this.itemsUnbuild();
         this.lootUnbuild();
         mPersistenceData = null;
         this.mViewMng = null;
         this.mMap = null;
         this.mEvent = null;
         this.actionOnItemReset();
      }
      
      public function getSig() : int
      {
         var item:WorldItemObject = null;
         var u:MyUnit = null;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate = MyUnit.smCoor;
         var returnValue:int = 0;
         var z:int = 0;
         for each(item in this.mItemsSig)
         {
            u = item.mUnit;
            coor.x = item.mTileRelativeX;
            coor.y = item.mTileRelativeY;
            z = 0;
            DCDebug.traceCh("SigWorld","item has NO unit");
            DCDebug.traceCh("SigWorld","Adding " + coor.x + " + " + coor.y + " + " + z + " (" + (coor.x + coor.y + z) + ") for sku " + item.mDef.mSku + " to running sig of " + returnValue);
            returnValue += coor.x + coor.y;
         }
         DCDebug.traceCh("SigWorld","FINAL WORLD SIG = " + returnValue);
         return returnValue;
      }
      
      public function notifyEventToItems(e:Object) : void
      {
         this.mEvent = e;
         var _loc2_:* = e.cmd;
         if("battleEventHasStarted" === _loc2_)
         {
            this.mStartedRepairs = false;
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var i:int = 0;
         var ruleMng:RuleMng = null;
         var item:WorldItemObject = null;
         if(this.mLootNeedsToBeCalculated)
         {
            this.lootReset();
            ruleMng = InstanceMng.getRuleMng();
            this.mBuildingsScoreAttack = 0;
            this.mBuildingsScoreAttackWithDestroyed = 0;
         }
         if(this.mShowRepairsPopup)
         {
            this.mShowRepairsPopup = false;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),{
               "type":"EventPopup",
               "cmd":"NOTIFY_OPEN_START_REPAIRS_POPUP"
            },true);
         }
         if(this.mExpendablesStartDemolition)
         {
            this.mExpendablesStartDemolition = false;
            this.expendablesStartDemolition();
         }
         i = 0;
         while(i < 3)
         {
            if(ITEMS_LIST_IS_OWNER[i])
            {
               for each(item in this.mItems[i])
               {
                  switch(this.mAttackNotification - 1)
                  {
                     case 0:
                        item.pauseToReceiveAttack();
                        break;
                     case 1:
                        item.resumeFromReceivingAttack();
                  }
                  if(this.mEvent != null)
                  {
                     item.notify(this.mEvent);
                  }
                  item.logicUpdate(dt);
                  if(this.mLootNeedsToBeCalculated)
                  {
                     if(item.getEnergy() > 0 && ruleMng.canItemBeLooted(item))
                     {
                        this.lootAddLootableItem(item);
                     }
                     if(item.shotCanBeATarget())
                     {
                        this.mBuildingsScoreAttackWithDestroyed += item.mDef.getScoreAttack();
                        if(item.getEnergy() > 0)
                        {
                           this.mBuildingsScoreAttack += item.mDef.getScoreAttack();
                        }
                     }
                  }
               }
            }
            i++;
         }
         this.mEvent = null;
         if(this.mLootNeedsToBeCalculated)
         {
            this.lootCalculateMaxLoot();
         }
         if(this.mAttackNotification != 0)
         {
            this.setAttackNotification(0);
         }
         this.expendablesLogicUpdate(dt);
         this.actionOnItemLogicUpdate(dt);
      }
      
      override protected function childrenCreate() : void
      {
         this.mUnitScene = new UnitScene();
         MyUnit.setUnitEventListener(this.mUnitScene);
         childrenAddChild(this.mUnitScene);
         InstanceMng.registerUnitScene(this.mUnitScene);
      }
      
      public function setAttackNotification(value:int) : void
      {
         this.mAttackNotification = value;
      }
      
      public function userAcceptsRepairingStart() : void
      {
         this.mStartedRepairs = true;
         this.mExpendablesStartDemolition = true;
         this.mNeedsToWaitForRepairingToStart = false;
      }
      
      private function itemsLoad() : void
      {
         var i:int = 0;
         if(this.mItems == null)
         {
            this.mItems = new Vector.<Vector.<WorldItemObject>>();
            for(i = 0; i < 3; )
            {
               this.mItems[i] = new Vector.<WorldItemObject>(0);
               i++;
            }
            this.mItemsListsIdsTemp = new Vector.<int>(0);
            this.mItemsSig = new Vector.<WorldItemObject>(0);
         }
      }
      
      private function itemsUnload() : void
      {
         this.mItems = null;
         this.mItemsHQRef = null;
         this.mItemsListsIdsTemp = null;
         this.mItemsSig = null;
      }
      
      private function itemsBuild() : void
      {
         var energy:int = 0;
         var resourceSkus:Vector.<String> = null;
         var upgradeId:int = 0;
         var def:WorldItemDef = null;
         var item:WorldItemObject = null;
         var itemSku:String = null;
         var itemXml:XML = null;
         var aniImp:AnimImpSWFStar = null;
         var profile:Profile;
         (profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).resetMineralsCapacityAmount();
         profile.resetCoinsCapacityAmount();
         profile.resetDroids();
         this.mItemsNextSid = 0;
         this.mItemsAmountPerKey = new Dictionary(true);
         var checkStartRepairing:Boolean = InstanceMng.getFlowStatePlanet().isCurrentRoleOwner();
         var startRepairingIsNeeded:Boolean = false;
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         var animBrokenImp:AnimImpSWFStar = AnimImpSWFStar(InstanceMng.getAnimMng().impCatalogGet(58));
         this.lootReset();
         this.mBuildingsScoreAttack = 0;
         this.mBuildingsScoreAttackWithDestroyed = 0;
         this.mItemsSig.length = 0;
         for each(itemXml in EUtils.xmlGetChildrenList(mPersistenceData,"Item"))
         {
            itemSku = EUtils.xmlReadString(itemXml,"sku");
            upgradeId = int(EUtils.xmlIsAttribute(itemXml,"upgradeId") ? EUtils.xmlReadInt(itemXml,"upgradeId") : 0);
            def = this.mWorldItemDefMng.getDefBySkuAndUpgradeId(itemSku,upgradeId);
            if(def != null)
            {
               item = this.itemsPoolCreateItem();
               item.load();
               item.persistenceSetData(itemXml);
               item.build();
               if(int(item.mSid) > this.mItemsNextSid)
               {
                  this.mItemsNextSid = int(item.mSid);
               }
               if(this.mMap.placePlaceItem(item,false,true))
               {
                  this.itemsAddItem(item);
                  if(!item.mDef.isADecoration() && !item.mDef.isAnObstacle())
                  {
                     this.mItemsSig.push(item);
                  }
                  if(checkStartRepairing)
                  {
                     if(!startRepairingIsNeeded)
                     {
                        startRepairingIsNeeded = item.needsRepairs();
                     }
                     if(!this.mShowRepairsPopup)
                     {
                        this.mShowRepairsPopup = item.needsRepairs() && !item.mHasStartedRepairing;
                     }
                  }
                  if((energy = item.getEnergy()) > 0 && ruleMng.canItemBeLooted(item))
                  {
                     this.lootAddLootableItem(item);
                  }
                  if(item.canBeBroken())
                  {
                     resourceSkus = animBrokenImp.itemCalculateSkus(item);
                     resourceMng.requestsAddRequest(resourceSkus[0],"requestsBattleStart");
                  }
                  if(item.mDef.isABunker())
                  {
                     resourceSkus = (aniImp = AnimImpSWFStar(InstanceMng.getAnimMng().impCatalogGet(33))).itemCalculateSkus(item);
                     resourceMng.requestsAddRequest(resourceSkus[0],"requestsGameStart");
                     resourceSkus = (aniImp = AnimImpSWFStar(InstanceMng.getAnimMng().impCatalogGet(34))).itemCalculateSkus(item);
                     resourceMng.requestsAddRequest(resourceSkus[0],"requestsGameStart");
                     resourceSkus = (aniImp = AnimImpSWFStar(InstanceMng.getAnimMng().impCatalogGet(35))).itemCalculateSkus(item);
                     resourceMng.requestsAddRequest(resourceSkus[0],"requestsGameStart");
                  }
                  if(item.shotCanBeATarget())
                  {
                     this.mBuildingsScoreAttackWithDestroyed += item.mDef.getScoreAttack();
                     if(energy > 0)
                     {
                        this.mBuildingsScoreAttack += item.mDef.getScoreAttack();
                     }
                  }
               }
            }
            else if(Config.DEBUG_ASSERTS)
            {
               DCDebug.trace("WARNING in World.itemsBuild(): an item with a not valid <sku, upgradeId> = " + itemSku + ", " + upgradeId + " has been tried to be built",1);
            }
         }
         this.lootCalculateMaxLoot();
         this.mExpendablesStartDemolition = false;
         if(!this.mShowRepairsPopupEnabled)
         {
            this.mShowRepairsPopup = false;
            this.mShowRepairsPopupEnabled = true;
         }
         else if(!this.mShowRepairsPopup)
         {
            this.mExpendablesStartDemolition = true;
         }
         this.mStartedRepairs = startRepairingIsNeeded && !this.mShowRepairsPopup;
         this.mNeedsToWaitForRepairingToStart = this.mShowRepairsPopup;
         profile.regulateCurrency(0,1);
         profile.regulateCurrency(0,2);
      }
      
      private function itemsBuildItem(itemXml:XML) : WorldItemObject
      {
         var upgradeId:int = 0;
         var def:WorldItemDef = null;
         var item:WorldItemObject = null;
         var itemSku:String = EUtils.xmlReadString(itemXml,"sku");
         upgradeId = int(EUtils.xmlIsAttribute(itemXml,"upgradeId") ? EUtils.xmlReadInt(itemXml,"upgradeId") : 0);
         def = this.mWorldItemDefMng.getDefBySkuAndUpgradeId(itemSku,upgradeId);
         if(def != null)
         {
            item = this.itemsPoolCreateItem();
            item.load();
            item.persistenceSetData(itemXml);
            item.build();
            if(int(item.mSid) > this.mItemsNextSid)
            {
               this.mItemsNextSid = int(item.mSid);
            }
            this.itemsAddItem(item);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in World.itemsBuild(): an item with a not valid <sku, upgradeId> = " + itemSku + ", " + upgradeId + " has been tried to be built",1);
         }
         return item;
      }
      
      private function itemsUnbuild() : void
      {
         var item:WorldItemObject = null;
         var list:Vector.<WorldItemObject> = null;
         var i:int = 0;
         var length:int = 0;
         this.expendablesUnbuild();
         if(this.mItems != null)
         {
            length = int(this.mItems.length);
            for(i = 0; i < length; )
            {
               list = this.mItems[i];
               if(ITEMS_LIST_IS_OWNER[i])
               {
                  while(list.length > 0)
                  {
                     item = list.shift();
                     this.itemsDestroyItem(item,false);
                  }
               }
               else
               {
                  list.length = 0;
               }
               i++;
            }
         }
         this.mItemsHQRef = null;
         this.mItemsAmountPerKey = null;
         InstanceMng.getResourceMng().requestsUnbuild();
      }
      
      public function itemsGetItemsAllowedToSpawnCivils() : Vector.<WorldItemObject>
      {
         return this.mItems[0];
      }
      
      public function itemsGetItemsCanGenerateResources() : Vector.<WorldItemObject>
      {
         return this.mItems[1];
      }
      
      public function itemsGetAllItems() : Vector.<WorldItemObject>
      {
         return this.mItems[2];
      }
      
      public function itemsGetAllObstacles() : Vector.<WorldItemObject>
      {
         var item:WorldItemObject = null;
         var items:Vector.<WorldItemObject> = this.itemsGetAllItems();
         var returnValue:Vector.<WorldItemObject> = new Vector.<WorldItemObject>(0);
         for each(item in items)
         {
            if(item.mDef.isAnObstacle())
            {
               returnValue.push(item);
            }
         }
         return returnValue;
      }
      
      public function itemsGetNextSid() : String
      {
         this.mItemsNextSid++;
         return "" + this.mItemsNextSid;
      }
      
      public function itemsSetSid(SId:int) : void
      {
         this.mItemsNextSid = SId;
      }
      
      public function itemsGetHeadquarters() : WorldItemObject
      {
         if(this.mItemsHQRef == null)
         {
            this.mItemsHQRef = this.itemsGetItemBySid("1");
         }
         return this.mItemsHQRef;
      }
      
      public function itemsGetRefinery() : WorldItemObject
      {
         return this.itemsGetItemBySku("refinery");
      }
      
      public function itemsGetEmbassy() : WorldItemObject
      {
         return this.itemsGetItemBySku("labs_002_001");
      }
      
      public function itemsGetItemBySku(sku:String) : WorldItemObject
      {
         return this.itemsFindFirst(function(item:WorldItemObject):Boolean
         {
            return item.mDef.mSku == sku;
         });
      }
      
      private function itemsFindFirst(func:Function) : WorldItemObject
      {
         var item:WorldItemObject = null;
         for each(item in this.itemsGetAllItems())
         {
            if(func(item))
            {
               return item;
            }
         }
         return null;
      }
      
      public function itemsGetLabRef() : WorldItemObject
      {
         return this.mItemsLabRef;
      }
      
      public function itemsGetLabLevel() : int
      {
         if(this.mItemsLabRef == null)
         {
            return -1;
         }
         if(this.mItemsLabRef.mServerStateId != 1)
         {
            return -1;
         }
         return this.mItemsLabRef.mDef.getUpgradeId();
      }
      
      public function itemsGetObservatoryLevel() : int
      {
         if(this.mItemsObservatoryRef == null)
         {
            return -1;
         }
         if(this.mItemsObservatoryRef.mServerStateId == 0)
         {
            return -1;
         }
         return this.mItemsObservatoryRef.mDef.getUpgradeId();
      }
      
      public function itemsGetItemByIndex(index:int, idList:int) : WorldItemObject
      {
         var list:Vector.<WorldItemObject> = this.itemsGetListById(idList);
         return list[index];
      }
      
      public function itemsGetItemBySid(sid:String) : WorldItemObject
      {
         var returnValue:WorldItemObject = null;
         var length:int = 0;
         var j:int = 0;
         var i:int = 0;
         while(i < 3 && returnValue == null)
         {
            length = int(this.mItems[i].length);
            j = 0;
            while(j < length && returnValue == null)
            {
               returnValue = this.mItems[i][j];
               if(returnValue.mSid != sid)
               {
                  returnValue = null;
               }
               j++;
            }
            i++;
         }
         return returnValue;
      }
      
      private function itemsGetListsIds(item:WorldItemObject) : Vector.<int>
      {
         this.mItemsListsIdsTemp.length = 0;
         if(item.mDef.canSpawnCivils() && !item.isBroken())
         {
            this.mItemsListsIdsTemp.push(0);
         }
         if(item.mDef.canGenerateResources())
         {
            this.mItemsListsIdsTemp.push(1);
         }
         this.mItemsListsIdsTemp.push(2);
         return this.mItemsListsIdsTemp;
      }
      
      public function itemsGetListById(id:int) : Vector.<WorldItemObject>
      {
         return Vector.<WorldItemObject>(this.mItems[id]);
      }
      
      private function itemsAddItem(item:WorldItemObject) : void
      {
         var id:int = 0;
         var l:Vector.<WorldItemObject> = null;
         var roleId:int = 0;
         var lists:Vector.<int> = this.itemsGetListsIds(item);
         for each(id in lists)
         {
            (l = this.mItems[id]).push(item);
         }
         roleId = InstanceMng.getFlowState().getCurrentRoleId();
         if(item.mDef.isALaboratory() && roleId == 0)
         {
            this.mItemsLabRef = item;
         }
         if(item.mDef.isAnObservatory() && roleId == 0)
         {
            this.mItemsObservatoryRef = item;
         }
      }
      
      public function itemsAmountGetAlreadyBuilt(sku:String, upgradeId:int = -1, checkBiggerUpgrade:Boolean = false) : int
      {
         return this.itemsAmountGet(sku,upgradeId,checkBiggerUpgrade,"_built");
      }
      
      public function itemsAmountGet(sku:String, upgradeId:int = -1, checkBiggerUpgrade:Boolean = false, suffix:String = "") : int
      {
         var startId:* = 0;
         var endId:* = 0;
         var i:* = 0;
         var key:* = sku;
         var returnValue:int = 0;
         if(!isBuilt() || this.mItemsAmountPerKey == null)
         {
            DCDebug.trace("The world should be built. Returning 0",1);
            return 0;
         }
         if(upgradeId > -1)
         {
            startId = upgradeId;
            if(checkBiggerUpgrade)
            {
               endId = this.mWorldItemDefMng.getMaxUpgradeLevel(sku);
            }
            else
            {
               endId = startId;
            }
            sku += "_";
            for(i = startId; i <= endId; )
            {
               key = sku + i + suffix;
               returnValue += this.mItemsAmountPerKey[key] == null ? 0 : this.mItemsAmountPerKey[key];
               i++;
            }
         }
         else
         {
            key += suffix;
            returnValue = int(this.mItemsAmountPerKey[key] == null ? 0 : int(this.mItemsAmountPerKey[key]));
         }
         return returnValue;
      }
      
      private function itemsAmountAddKey(key:String, checkPowerUp:Boolean = false) : void
      {
         if(this.mItemsAmountPerKey[key] == null)
         {
            this.mItemsAmountPerKey[key] = 0;
         }
         if(Config.usePowerUps() && checkPowerUp)
         {
            this.itemsIsAnyPowerUpActivate(key,true);
         }
         this.mItemsAmountPerKey[key]++;
      }
      
      private function itemsIsAnyPowerUpActivate(key:String, on:Boolean) : void
      {
         var def:WorldItemDef = null;
         var powerUpSkus:String = null;
         var tokens:Array = null;
         var token:String = null;
         var powerUpDef:PowerUpDef = null;
         var isAnyPowerUpActivate:Boolean = this.mPowerUpMng.unitsIsAnyPowerUpActiveByUnitSku(key,1);
         var goOn:Boolean = false;
         if(on)
         {
            goOn = this.mItemsAmountPerKey[key] == 0 && !isAnyPowerUpActivate;
         }
         else
         {
            goOn = this.mItemsAmountPerKey[key] == 1 && isAnyPowerUpActivate;
         }
         if(goOn)
         {
            def = this.mWorldItemDefMng.getDefBySku(key) as WorldItemDef;
            if(def != null)
            {
               if((powerUpSkus = this.mPowerUpMng.getPowerUpsActiveAsStr(1)) != null)
               {
                  tokens = powerUpSkus.split(",");
                  for each(token in tokens)
                  {
                     if((powerUpDef = this.mPowerUpDefMng.getDefBySku(token) as PowerUpDef) != null && def.belongsToGroup(powerUpDef.getSubtarget()))
                     {
                        this.mPowerUpMng.unitsRegisterPowerUpSku(key,token,1,on);
                     }
                  }
               }
            }
         }
      }
      
      private function itemsAmountSubtractKey(key:String, checkPowerUp:Boolean = false) : void
      {
         if(!(this.mItemsAmountPerKey[key] == null || this.mItemsAmountPerKey[key] == 0))
         {
            if(Config.usePowerUps() && checkPowerUp)
            {
               this.itemsIsAnyPowerUpActivate(key,false);
            }
            this.mItemsAmountPerKey[key]--;
         }
      }
      
      private function itemsAmountOpItem(item:WorldItemObject, add:Boolean) : void
      {
         var alreadyBuilt:* = false;
         var sku:String = null;
         var key:* = null;
         if(item.mServerStateId != -1)
         {
            alreadyBuilt = item.mServerStateId != 0;
            key = sku = item.mDef.mSku;
            if(add)
            {
               this.itemsAmountAddKey(key,true);
            }
            else
            {
               this.itemsAmountSubtractKey(key,true);
            }
            if(alreadyBuilt)
            {
               key += "_built";
               if(add)
               {
                  this.itemsAmountAddKey(key);
               }
               else
               {
                  this.itemsAmountSubtractKey(key);
               }
            }
            key = sku + "_" + item.mUpgradeId;
            if(add)
            {
               this.itemsAmountAddKey(key);
            }
            else
            {
               this.itemsAmountSubtractKey(key);
            }
            if(alreadyBuilt)
            {
               key += "_built";
               if(add)
               {
                  this.itemsAmountAddKey(key);
               }
               else
               {
                  this.itemsAmountSubtractKey(key);
               }
            }
         }
      }
      
      public function itemsAmountAddItem(item:WorldItemObject) : void
      {
         this.itemsAmountOpItem(item,true);
      }
      
      public function itemsAmountSubtractItem(item:WorldItemObject) : void
      {
         this.itemsAmountOpItem(item,false);
      }
      
      private function itemsDestroyItem(item:WorldItemObject, unregister:Boolean = true) : void
      {
         if(item.mDef.isALaboratory())
         {
            this.mItemsLabRef = null;
         }
         this.mMap.placeUnplaceItem(item);
         if(unregister)
         {
            this.itemsUnregisterItem(item,true);
         }
         this.itemsAmountSubtractItem(item);
         if(item.mUnit != null)
         {
            InstanceMng.getUnitScene().removeItem(item,true);
         }
         item.unbuild();
         this.itemsPoolReleaseItem(item);
      }
      
      public function itemsRegisterItem(item:WorldItemObject) : void
      {
         var typeId:int = 0;
         var def:WorldItemDef = null;
         if(item.isActive())
         {
            typeId = item.mDef.getWorkingTypeId();
            switch(typeId - 2)
            {
               case 0:
                  def = item.mDef;
                  if(def != null)
                  {
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addMineralCapacityAmount(def.getMineralsStorage());
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addCoinsCapacityAmount(def.getCoinsStorage());
                  }
                  break;
               case 1:
                  InstanceMng.getShipyardController().addShipyardByItem(item);
                  break;
               case 5:
                  InstanceMng.getHangarControllerMng().getHangarController().addByItem(item);
                  break;
               case 6:
                  InstanceMng.getBunkerController().addByItem(item);
            }
         }
      }
      
      public function itemsUnregisterItem(item:WorldItemObject, notifyProfile:Boolean = false) : void
      {
         var typeId:int = 0;
         var def:WorldItemDef = null;
         var profile:Profile = null;
         if(item.isActive())
         {
            switch((typeId = item.mDef.getWorkingTypeId()) - 2)
            {
               case 0:
                  def = item.mDef;
                  if(def != null)
                  {
                     (profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).subtractMineralCapacityAmount(def.getMineralsStorage());
                     profile.subtractCoinsCapacityAmount(def.getCoinsStorage());
                     if(notifyProfile)
                     {
                        profile.regulateCurrency(0,1);
                        profile.regulateCurrency(0,2);
                     }
                  }
                  break;
               case 1:
                  InstanceMng.getShipyardController().removeShipyardBySid(item.mSid);
            }
         }
      }
      
      public function itemsUpgradeItem(item:WorldItemObject, newUpgradeId:int) : void
      {
         var usesRegister:Boolean = false;
         var typeId:int = item.mDef.getWorkingTypeId();
         var oldStorageCoins:Number = item.mDef.getCoinsStorage();
         var oldStorageMinerals:Number = item.mDef.getMineralsStorage();
         switch(typeId - 2)
         {
            case 0:
            case 1:
               break;
            default:
               usesRegister = true;
         }
         if(usesRegister)
         {
            this.itemsUnregisterItem(item);
         }
         this.itemsAmountSubtractItem(item);
         item.mUpgradeId = newUpgradeId;
         this.itemsAmountAddItem(item);
         item.mDef = this.mWorldItemDefMng.getDefBySkuAndUpgradeId(item.mDef.mSku,item.mUpgradeId);
         item.setEnergy(item.mDef.getMaxEnergy());
         if(item.mUnit != null)
         {
            InstanceMng.getUnitScene().buildingsSetupFromItem(item);
         }
         InstanceMng.getTargetMng().updateProgress("upgrade",1,item.mDef.mSku);
         this.mWorldItemObjectController.changeServerState(item,false,1,0);
         if(usesRegister)
         {
            this.itemsRegisterItem(item);
         }
         else
         {
            switch(typeId - 2)
            {
               case 0:
                  if(item.mDef != null)
                  {
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addMineralCapacityAmount(item.mDef.getMineralsStorage() - oldStorageMinerals);
                     InstanceMng.getUserInfoMng().getCurrentProfileLoaded().addCoinsCapacityAmount(item.mDef.getCoinsStorage() - oldStorageCoins);
                  }
                  break;
               case 1:
                  InstanceMng.getShipyardController().getShipyard(item.mSid).setWorldItemObject(item);
                  InstanceMng.getShipyardController().resumeShipyard(item.mSid);
            }
         }
      }
      
      private function itemsPoolCreateItem() : WorldItemObject
      {
         return new WorldItemObject();
      }
      
      private function itemsPoolReleaseItem(item:WorldItemObject) : void
      {
         item = null;
      }
      
      public function itemsCreateItemForToolPlace(sku:String) : WorldItemObject
      {
         var returnValue:WorldItemObject = this.itemsPoolCreateItem();
         var def:WorldItemDef = WorldItemDef(this.mWorldItemDefMng.getDefBySku(sku));
         var itemXml:XML = WorldItemObject.smWorldItemObjectController.getItemXmlForToolPlace(def);
         returnValue.load();
         returnValue.persistenceSetData(itemXml);
         returnValue.setIsForToolPlace(true);
         returnValue.build();
         returnValue.begin();
         return returnValue;
      }
      
      private function itemsCreateItemAfterUsingToolPlace(item:WorldItemObject, tileX:int, tileY:int) : WorldItemObject
      {
         item.unbuild();
         item.persistenceSetData(WorldItemObject.smWorldItemObjectController.getItemXmlAfterUsingToolPlace(item.mDef,tileX,tileY));
         item.setHasJustBeenCreated(true);
         item.setIsForToolPlace(false);
         item.build();
         item.begin();
         return item;
      }
      
      public function itemsPlaceItem(sku:String, item:WorldItemObject, tileX:int, tileY:int, subcmd:String = "AddItem", notifyServer:Boolean = true, isForBuffer:Boolean = false) : WorldItemObject
      {
         if(item == null)
         {
            item = this.itemsCreateItemForToolPlace(sku);
         }
         var newItem:*;
         if(newItem = subcmd == "AddItem")
         {
            item = this.itemsCreateItemAfterUsingToolPlace(item,tileX,tileY);
            this.itemsAddItem(item);
            if(Config.useUmbrella())
            {
               InstanceMng.getUmbrellaMng().effectConsiderItem(item);
            }
         }
         this.mMap.placePlaceItem(item,isForBuffer);
         if(item.mDef.hasBuildingProcess())
         {
            if(item.buildingCanStart())
            {
               item.buildingStart();
            }
         }
         if(newItem)
         {
            item.setHasJustBeenCreated(false);
         }
         if(notifyServer)
         {
            switch(subcmd)
            {
               case "AddItem":
                  InstanceMng.getUserDataMng().updateItem_newItem(item.persistenceGetData(),item.getTransaction());
                  item.setTransaction(null);
                  break;
               case "MoveItem":
                  InstanceMng.getUserDataMng().updateItem_move(int(item.mSid),item.mTileRelativeX,item.mTileRelativeY);
                  break;
               case "FlipItem":
                  InstanceMng.getUserDataMng().updateItem_rotate(int(item.mSid),item.mTileRelativeX,item.mTileRelativeY,item.mIsFlipped);
            }
         }
         return item;
      }
      
      public function itemsUnplaceItem(item:WorldItemObject, notifyServer:Boolean) : void
      {
         var id:int = 0;
         var l:Vector.<WorldItemObject> = null;
         var pos:int = 0;
         var lists:Vector.<int> = this.itemsGetListsIds(item);
         var trafficMng:TrafficMng = InstanceMng.getTrafficMng();
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         for each(id in lists)
         {
            pos = (l = this.mItems[id]).indexOf(item);
            if(pos > -1)
            {
               if(ITEMS_LIST_IS_OWNER[id])
               {
                  if(notifyServer)
                  {
                     userDataMng.updateItem_destroy(int(item.mSid),item.getTransaction());
                  }
                  this.itemsDestroyItem(item);
               }
               l.splice(pos,1);
            }
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var isForBuffer:* = false;
         var jailAnimMng:JailAnimMng = null;
         var wio:WorldItemObject = null;
         var returnValue:Boolean = true;
         var item:WorldItemObject = e.item;
         var notifyServer:Boolean = true;
         switch(e.cmd)
         {
            case "WorldEventPlaceItem":
               isForBuffer = !!e.isForBuffer;
               if(e.hasOwnProperty("notifyServer") && e.notifyServer == false)
               {
                  notifyServer = false;
               }
               this.itemsPlaceItem(null,item,e.tileX,e.tileY,e.subcmd,notifyServer,isForBuffer);
               if(item.mDef.getCanBeRide())
               {
                  InstanceMng.getTrafficMng().notify(e);
               }
               break;
            case "WorldEventDemolishItem":
               this.itemsUnplaceItem(item,e.notifyServer);
               break;
            case "ATTACK_NOTIFICATION_HQ_DESTROYED":
               if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3 && InstanceMng.getMissionsMng().isJailMissionActive())
               {
                  jailAnimMng = InstanceMng.getJailAnimMng();
                  for each(wio in this.itemsGetAllItems())
                  {
                     if(wio.mDef.getAssetId() == "jail_001")
                     {
                        jailAnimMng.addWorldItemObject(wio);
                     }
                  }
                  jailAnimMng.startAllStates();
               }
               break;
            case "WorldEventMoveCameraToItem":
               this.actionOnItemSetState(1);
               break;
            default:
               returnValue = false;
         }
         return returnValue;
      }
      
      override public function persistenceGetData() : XML
      {
         var list:Vector.<WorldItemObject> = null;
         var item:WorldItemObject = null;
         var xml:XML = EUtils.stringToXML("<World/>");
         var items:XML = EUtils.stringToXML("<Items/>");
         var id:int = 0;
         for each(list in this.mItems)
         {
            if(ITEMS_LIST_IS_OWNER[id])
            {
               for each(item in list)
               {
                  items.appendChild(item.persistenceGetData());
               }
            }
            id++;
         }
         xml.appendChild(items);
         return xml;
      }
      
      public function isCurrentWorldCapital() : Boolean
      {
         var currentPlanet:String = InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetId();
         var capitalId:String = InstanceMng.getUserInfoMng().getProfileLogin().getCapitalPlanet().getPlanetId();
         return capitalId == currentPlanet;
      }
      
      public function setShowRepairsPopupEnabled(value:Boolean) : void
      {
         this.mShowRepairsPopupEnabled = value;
      }
      
      public function needsToWaitForRepairingToStart() : Boolean
      {
         return this.mNeedsToWaitForRepairingToStart;
      }
      
      public function setNeedsToWaitForRepairingToStart(value:Boolean) : void
      {
         this.mNeedsToWaitForRepairingToStart = value;
      }
      
      private function lootUnload() : void
      {
         this.mLootMax = null;
         this.mLootTemp = null;
         this.mLootItems = null;
         this.mLootMightBePreservedCoins = null;
         this.mLootMightBePreservedMinerals = null;
      }
      
      private function lootUnbuild() : void
      {
         this.mLootMaxBySid = null;
         this.mLootSoFarBySid = null;
         this.mLootItems.length = 0;
         if(true)
         {
            this.mLootMightBePreservedCoins.length = 0;
            this.mLootMightBePreservedMinerals.length = 0;
         }
      }
      
      private function lootReset() : void
      {
         if(this.mLootMax == null)
         {
            this.mLootMax = new Dictionary();
            this.mLootTemp = new Dictionary();
         }
         this.mLootMax["damageCoins"] = 0;
         this.mLootMax["damageMinerals"] = 0;
         this.mLootMaxBySid = new Dictionary();
         this.mLootSoFarBySid = new Dictionary();
         if(this.mLootItems == null)
         {
            this.mLootItems = new Vector.<WorldItemObject>(0);
         }
         else
         {
            this.mLootItems.length = 0;
         }
         if(true)
         {
            if(this.mLootMightBePreservedCoins == null)
            {
               this.mLootMightBePreservedCoins = new Vector.<WorldItemObject>(0);
            }
            else
            {
               this.mLootMightBePreservedCoins.length = 0;
            }
            if(this.mLootMightBePreservedMinerals == null)
            {
               this.mLootMightBePreservedMinerals = new Vector.<WorldItemObject>(0);
            }
            else
            {
               this.mLootMightBePreservedMinerals.length = 0;
            }
         }
      }
      
      public function lootSetNeedsToBeCalculated(value:Boolean) : void
      {
         this.mLootNeedsToBeCalculated = value;
      }
      
      public function getMaxAmountLootable() : Dictionary
      {
         return this.mLootMax;
      }
      
      private function lootAddLootableItem(item:WorldItemObject) : void
      {
         this.mLootItems.push(item);
      }
      
      private function lootCalculateMaxLoot() : void
      {
         var item:WorldItemObject = null;
         var energy:int = 0;
         var maxCoins:* = NaN;
         var minCoins:Number = NaN;
         var subtractAmount:Number = NaN;
         var subtractSoFar:Number = NaN;
         var length:int = 0;
         var i:int = 0;
         var lootItem:Number = NaN;
         var diff:Number = NaN;
         var maxMinerals:* = NaN;
         var minMinerals:Number = NaN;
         var profileAttacked:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         this.mLootTemp["profileMinerals"] = profileAttacked.getMinerals();
         this.mLootTemp["profileCoins"] = profileAttacked.getCoins();
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         var maxLootCoinsToBePreserved:Number = 0;
         var maxLootMineralsToBePreserved:Number = 0;
         for each(item in this.mLootItems)
         {
            energy = item.getEnergy();
            ruleMng.getBattleResourceDamage(item,energy,0,false,this.mLootTemp,false);
            if(item.mDef.getWorkingTypeId() == 2)
            {
               if(this.mLootTemp["damageCoins"] > 0)
               {
                  this.mLootMightBePreservedCoins.push(item);
                  maxLootCoinsToBePreserved += this.mLootTemp["damageCoins"];
               }
               if(this.mLootTemp["damageMinerals"] > 0)
               {
                  this.mLootMightBePreservedMinerals.push(item);
                  maxLootMineralsToBePreserved += this.mLootTemp["damageMinerals"];
               }
            }
            this.mLootMaxBySid[item.mSid] = {
               "coins":this.mLootTemp["damageCoins"],
               "minerals":this.mLootTemp["damageMinerals"]
            };
            this.mLootMax["damageCoins"] += this.mLootTemp["damageCoins"];
            this.mLootMax["damageMinerals"] += this.mLootTemp["damageMinerals"];
            if(this.mLootTemp["applyOnProfile"])
            {
               this.mLootTemp["profileMinerals"] -= this.mLootTemp["damageMinerals"];
               this.mLootTemp["profileCoins"] -= this.mLootTemp["damageCoins"];
            }
         }
         if(true)
         {
            maxCoins = maxLootCoinsToBePreserved;
            minCoins = InstanceMng.getSettingsDefMng().getBattleSafeResourceCoins();
            subtractAmount = maxCoins > minCoins ? minCoins : maxCoins;
            this.mLootMax["damageCoins"] -= subtractAmount;
            subtractSoFar = 0;
            length = int(this.mLootMightBePreservedCoins.length);
            for(i = 0; subtractSoFar < subtractAmount; )
            {
               item = this.mLootMightBePreservedCoins[i % length];
               if((lootItem = Number(this.mLootMaxBySid[item.mSid].coins)) > 0)
               {
                  diff = Math.min(subtractAmount - subtractSoFar,100);
                  diff = Math.min(diff,lootItem);
                  this.mLootMaxBySid[item.mSid].coins = lootItem - diff;
                  subtractSoFar += diff;
               }
               i++;
            }
            maxMinerals = maxLootMineralsToBePreserved;
            minMinerals = InstanceMng.getSettingsDefMng().getBattleSafeResourceMinerals();
            subtractAmount = maxMinerals > minMinerals ? minMinerals : maxMinerals;
            this.mLootMax["damageMinerals"] -= subtractAmount;
            subtractSoFar = 0;
            length = int(this.mLootMightBePreservedMinerals.length);
            for(i = 0; subtractSoFar < subtractAmount; )
            {
               item = this.mLootMightBePreservedMinerals[i % length];
               if((lootItem = Number(this.mLootMaxBySid[item.mSid].minerals)) > 0)
               {
                  diff = Math.min(subtractAmount - subtractSoFar,100);
                  diff = Math.min(diff,lootItem);
                  this.mLootMaxBySid[item.mSid].minerals = lootItem - diff;
                  subtractSoFar += diff;
               }
               i++;
            }
         }
         this.mLootNeedsToBeCalculated = false;
      }
      
      public function lootGetMaxCoinsBySid(sid:String) : Number
      {
         var loot:Object = this.mLootMaxBySid[sid];
         var returnValue:Number = 0;
         if(loot != null)
         {
            returnValue = Number(loot.coins);
         }
         return returnValue;
      }
      
      public function lootGetMaxMineralsBySid(sid:String) : Number
      {
         var loot:Object = this.mLootMaxBySid[sid];
         var returnValue:Number = 0;
         if(loot != null)
         {
            returnValue = Number(loot.minerals);
         }
         return returnValue;
      }
      
      public function getBuildingsScoreAttack() : Number
      {
         return this.mBuildingsScoreAttack;
      }
      
      public function getBuildingsScoreAttackWithDestroyed() : Number
      {
         return this.mBuildingsScoreAttackWithDestroyed;
      }
      
      public function getSurvivalPercentage() : int
      {
         var totalMaxEnergy:Number = 0;
         var totalCurrentEnergy:Number = 0;
         for each(var item in this.itemsGetAllItems())
         {
            if(item.shotCanBeATarget() && !item.mDef.isAWall() && !item.mDef.isAMine() && item.mDef.getMaxEnergy() != 0)
            {
               totalMaxEnergy += item.mDef.getMaxEnergy();
               totalCurrentEnergy += item.getEnergy();
            }
         }
         if(totalMaxEnergy == 0)
         {
            return 0;
         }
         var returnValue:int = Math.floor(100 * totalCurrentEnergy / totalMaxEnergy);
         DCDebug.trace("Survival: " + totalCurrentEnergy + " / " + totalMaxEnergy + " = " + returnValue + "%");
         return returnValue;
      }
      
      private function expendablesBuild(expendables:String) : void
      {
         var types:Array = null;
         var type:String = null;
         var data:Array = null;
         var sku:String = null;
         var items:Array = null;
         var item:String = null;
         this.mExpendables = new Dictionary();
         if(expendables != null && expendables != "")
         {
            types = expendables.split(";");
            for each(type in types)
            {
               if(type != "")
               {
                  sku = String((data = type.split("="))[0]);
                  items = data[1].split(",");
                  for each(item in items)
                  {
                     if(item != "")
                     {
                        data = item.split(":");
                        this.expendablesAddItem(sku,int(data[0]),int(data[1]));
                     }
                  }
               }
            }
         }
      }
      
      private function expendablesUnbuild() : void
      {
         var k:* = null;
         var key:String = null;
         var expendables:Vector.<Expendable> = null;
         var expendable:Expendable = null;
         var returnValue:String = null;
         if(this.mExpendables != null)
         {
            returnValue = "";
            for(k in this.mExpendables)
            {
               key = k;
               if(this.mExpendables[k] != null)
               {
                  if((expendables = Vector.<Expendable>(this.mExpendables[k])).length > 0)
                  {
                     for each(expendable in expendables)
                     {
                        expendable.unbuild();
                     }
                  }
               }
            }
            this.mExpendables = null;
         }
      }
      
      public function expendablesGetPersistenceString() : String
      {
         var k:* = null;
         var key:String = null;
         var expendables:Vector.<Expendable> = null;
         var expendable:Expendable = null;
         var returnValue:* = "";
         for(k in this.mExpendables)
         {
            key = k;
            if(this.mExpendables[k] != null)
            {
               if((expendables = Vector.<Expendable>(this.mExpendables[k])).length > 0)
               {
                  returnValue += key + "=";
                  for each(expendable in expendables)
                  {
                     returnValue += expendable.getPersistenceString() + ",";
                  }
                  returnValue += ";";
               }
            }
         }
         return returnValue;
      }
      
      private function expendablesLogicUpdate(dt:int) : void
      {
         var i:int = 0;
         var length:int = 0;
         var k:* = null;
         var key:String = null;
         var expendables:Vector.<Expendable> = null;
         var expendable:Expendable = null;
         if(this.mExpendables != null)
         {
            for(k in this.mExpendables)
            {
               key = k;
               if(this.mExpendables[k] != null)
               {
                  length = int((expendables = Vector.<Expendable>(this.mExpendables[k])).length);
                  for(i = 0; i < length; )
                  {
                     expendable = expendables[i];
                     expendable.logicUpdate(dt);
                     if(expendable.isOver())
                     {
                        expendables.splice(i,1);
                        length--;
                     }
                     else
                     {
                        i++;
                     }
                  }
                  if(length == 0)
                  {
                     this.mExpendables[key] = null;
                  }
               }
            }
         }
      }
      
      public function expendablesStartDemolition() : void
      {
         var k:* = null;
         var key:String = null;
         var expendables:Vector.<Expendable> = null;
         var expendable:Expendable = null;
         for(k in this.mExpendables)
         {
            key = k;
            if(this.mExpendables[k] != null)
            {
               expendables = Vector.<Expendable>(this.mExpendables[k]);
               for each(expendable in expendables)
               {
                  expendable.startDemolition();
               }
            }
         }
      }
      
      public function expendablesSkipDemolition() : void
      {
         var k:* = null;
         var key:String = null;
         var expendables:Vector.<Expendable> = null;
         var expendable:Expendable = null;
         for(k in this.mExpendables)
         {
            key = k;
            if(this.mExpendables[k] != null)
            {
               expendables = Vector.<Expendable>(this.mExpendables[k]);
               for each(expendable in expendables)
               {
                  expendable.skipDemolition();
               }
            }
         }
      }
      
      public function expendablesAddItem(sku:String, worldViewX:int, worldViewY:int) : void
      {
         if(this.mExpendables[sku] == null)
         {
            this.mExpendables[sku] = new Vector.<Expendable>(0);
         }
         var expendable:Expendable;
         (expendable = new Expendable()).build(sku,worldViewX,worldViewY);
         this.mExpendables[sku].push(expendable);
      }
      
      public function toggleAllRangePreviews(disable:Boolean = false) : void
      {
         this.mAllRangePreviewsVisible = !mAllRangePreviewsVisible;
         if(disable)
         {
            this.mAllRangePreviewsVisible = false;
         }
         for each(var item in this.itemsGetAllItems())
         {
            item.setCupolaForcedVisible(this.mAllRangePreviewsVisible);
            item.viewSetDefenseCupola(this.mAllRangePreviewsVisible);
            item.logicUpdate(0);
         }
      }
      
      private function actionOnItemReset() : void
      {
         this.mActionOnItemActionId = -1;
         this.mActionOnItemWIO = null;
         this.actionOnItemSetState(-1);
      }
      
      public function actionOnItemMoveCameraAndApply(item:WorldItemObject, actionId:int) : void
      {
         this.mActionOnItemWIO = item;
         this.mActionOnItemActionId = actionId;
         InstanceMng.getGUIController().cinematicsStart();
         InstanceMng.getMapControllerPlanet().moveCameraTo(item.mViewCenterWorldX,item.mViewCenterWorldY,2,true,this,"WorldEventMoveCameraToItem");
      }
      
      private function actionOnItemSetState(state:int) : void
      {
         if(this.mActionOnItemState != state)
         {
            this.mActionOnItemState = state;
            switch(this.mActionOnItemState - -1)
            {
               case 0:
                  InstanceMng.getGUIController().cinematicsFinish();
                  break;
               case 2:
                  if(this.actionOnItemApplyAction())
                  {
                     this.mActionOnItemTimer = 1500;
                     break;
                  }
            }
         }
      }
      
      private function actionOnItemApplyAction() : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mActionOnItemWIO != null)
         {
            switch(this.mActionOnItemActionId)
            {
               case 0:
                  InstanceMng.getWorldItemObjectController().wioUpgradeFromSocialItem(this.mActionOnItemWIO);
                  returnValue = true;
            }
         }
         return returnValue;
      }
      
      private function actionOnItemLogicUpdate(dt:int) : void
      {
         if(this.mActionOnItemState == 1)
         {
            this.mActionOnItemTimer -= dt;
            if(this.mActionOnItemTimer <= 0)
            {
               this.actionOnItemSetState(-1);
            }
         }
      }
   }
}
