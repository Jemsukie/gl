package com.dchoc.game.model.world.item
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.animations.AnimMng;
   import com.dchoc.game.core.utils.memory.PoolMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.components.goal.GoalDefense;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.states.WorldItemObjectState;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   import com.dchoc.toolkit.utils.astar.DCSearchResults;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCBoxWithTiles;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.ETextField;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class WorldItemObject extends DCComponent implements DCItemAnimatedInterface
   {
      
      private static var smViewMng:ViewMngPlanet;
      
      private static var smMapController:MapControllerPlanet;
      
      private static var smWorldItemDefMng:WorldItemDefMng;
      
      public static var smWorldItemObjectController:WorldItemObjectController;
      
      private static var smPoolMng:PoolMng;
      
      private static const ANCHOR_POINT_WIO_BOTTOM_RIGHT:int = 1;
      
      private static var smAnimMng:AnimMng;
      
      private static const CONNECTION_NONE_ID:int = -1;
      
      private static const CONNECTION_CONNECTING_ID:int = 1;
      
      private static const CONNECTION_CONNECTED_ID:int = 2;
      
      private static const RATIO:int = 1;
      
      public static const BROKEN_ENERGY_SEGMENTS:Vector.<int> = new <int>[80,100];
      
      public static const BROKEN_LEVELS_COUNT:int = BROKEN_ENERGY_SEGMENTS.length;
      
      public static const BROKEN_LAST_LEVEL_ID:int = BROKEN_LEVELS_COUNT - 1;
      
      private static const DATA_ENERGY_CURRENT:int = 0;
      
      private static const DATA_BROKEN_LEVEL:int = 1;
      
      private static const VIEW_LAYERS_GROUND_ID:int = 0;
      
      private static const VIEW_LAYERS_BASE_ID:int = 1;
      
      private static const VIEW_LAYERS_BASE_DECORATION_ID:int = 3;
      
      private static const VIEW_LAYERS_PARTICLES_ID:int = 2;
      
      private static const VIEW_LAYERS_OUTLINE_ID:int = 4;
      
      private static const VIEW_LAYERS_ICON_ID:int = 5;
      
      private static const VIEW_LAYERS_ICON_2_ID:int = 6;
      
      private static const VIEW_LAYERS_BAR_ID:int = 7;
      
      private static const VIEW_LAYERS_COUNT:int = 8;
      
      public static const VIEW_LAYERS_ATTRIBUTE_CURRENT_PARTICLE_ID:String = "currentParticleId";
      
      public static const VIEW_LAYERS_ATTRIBUTE_EXTRA_BONUS:String = "extraBonus";
      
      public static const VIEW_LAYERS_ATTRIBUTE_BROKEN_LEVEL:String = "brokenLevel";
      
      public static const VIEW_LAYERS_ATTRIBUTE_SELECTED_LAYER_ID:String = "selectedLayerId";
      
      private static var smInfluenceArea:Sprite;
      
      private static var smInfluenceVertices:Vector.<int>;
      
      private static const ABSORB_IMPACT_INTENSITY_MAX:Number = 0.8;
      
      private static const ABSORB_IMPACT_INTENSITY_MIN:Number = 0.4;
      
      private static const ABSORB_IMPACT_INTENSITY_SPEED:Number = -0.05;
      
      private static const SPY_STATE_NONE:int = 0;
      
      private static const SPY_STATE_WOULD_BE_AFFECTED:int = 1;
      
      private static const SPY_STATE_SPIABLE_NOT_SELECTED_AREA:int = 2;
      
      private static const SPY_STATE_SPIABLE_SELECTED_AREA:int = 3;
      
      private static const SPY_STATE_SPIABLE_SELECTED:int = 4;
      
      private static const DECORATION_TYPE_TELEPORT:String = "teleport";
      
      public static const DECORATION_MODE_NONE:int = 0;
      
      public static const DECORATION_MODE_RIDING:int = 1;
      
      public static const DECORATION_MODE_TELEPORT_OUT:int = 2;
      
      public static const DECORATION_MODE_TELEPORT_WAITING:int = 3;
      
      public static const DECORATION_MODE_TELEPORT_IN:int = 4;
       
      
      private var mSecureSid:SecureInt;
      
      public var mDef:WorldItemDef;
      
      private var mSecureServerStateId:SecureInt;
      
      private var mSecureServerModeId:SecureInt;
      
      public var mIsConnectedId:int;
      
      private var mHasJustBeenCreated:Boolean;
      
      private var mIsForToolPlace:Boolean;
      
      private var mTransaction:Transaction;
      
      public var mSecureTileRelativeX:SecureInt;
      
      public var mSecureTileRelativeY:SecureInt;
      
      private var mOldTileX:int;
      
      private var mOldTileY:int;
      
      private var mOldWorldPosY:int;
      
      private var mOldWorldPosX:int;
      
      public var mTime:SecureNumber;
      
      public var mTimeMax:SecureNumber;
      
      public var mTimeOverEvent:String = null;
      
      public var mEventDispatched:Boolean = false;
      
      private var mTimeBonus:SecureNumber;
      
      public var mIncomeAmountLeftToCollect:SecureNumber;
      
      public var mState:WorldItemObjectState;
      
      public var mBoundingBox:DCBoxWithTiles;
      
      private var mBoundingBoxParticles:DCBoxWithTiles;
      
      private var mBoundingBoxUnderBase:DCBoxWithTiles;
      
      public var mSecureUpgradeId:SecureInt;
      
      public var mUnit:MyUnit;
      
      public var mIsFlipped:Boolean;
      
      public var mHasStartedRepairing:Boolean;
      
      public var mDroidLabourId:int;
      
      private var mHasCollectBonus:SecureBoolean;
      
      private var mIncomeToRestore:SecureInt;
      
      private const HISTORY_MAX_AMOUNT:int = 10;
      
      private var mHistoryEvents:Vector.<String>;
      
      public var mPathTiles:Vector.<DCAStarNode>;
      
      public var mPathSearch:DCSearchResults;
      
      private var mRepairTime:Number = -1;
      
      public var mRepairTimeMax:Number = -1;
      
      private var mRepairBonusTime:int = 0;
      
      private var mRepairEnergyInit:int;
      
      private var mRepairIsActive:Boolean;
      
      private var mData:Array;
      
      private var mViewAttributes:Dictionary;
      
      private var mViewLayersTypeRequired:Array;
      
      private var mViewLayersTypeCurrent:Array;
      
      private var mViewLayersImpCurrent:Array;
      
      public var mViewLayersAnims:Array;
      
      private var mViewTimerMS:int;
      
      private var mViewCoor:DCCoordinate;
      
      private var mFlatbedUpgradeText:ETextField;
      
      private var mPreviousFlatbedValue:Boolean;
      
      private var mCupolaForcedVisible:Boolean;
      
      public var mViewCenterWorldX:int;
      
      public var mViewCenterWorldY:int;
      
      public var mViewZ:int;
      
      private var mViewAnimStoppingLayerId:int;
      
      private var mViewAnimStoppingAnimId:int;
      
      private var mViewAnimStoppingAnimToRestoreId:int;
      
      private var mViewIsSelected:Boolean = false;
      
      private var mAnimationDirty:Array;
      
      public var mIsHighlighted:Boolean;
      
      public var mShouldHighLight:Boolean;
      
      private var mItemOnTopIsEnabled:Boolean = false;
      
      private var mUmbrellaIsEnabled:SecureBoolean;
      
      private var mAbsorbImpactStarted:Boolean;
      
      private var mAbsorbImpactIntensity:Number;
      
      private var mAbsorbImpactIncrement:Number;
      
      private var mSpyState:int;
      
      private var mSpyStateType:int = -1;
      
      private var mDecorationMode:int;
      
      public function WorldItemObject()
      {
         mSecureSid = new SecureInt("WorldItemObject.mSecureSid");
         mSecureServerStateId = new SecureInt("WorldItemObject.mSecureServerStateId",-1);
         mSecureServerModeId = new SecureInt("WorldItemObject.mSecureServerModeId",-1);
         mSecureTileRelativeX = new SecureInt("WorldItemObject.mSecureTileRelativeX");
         mSecureTileRelativeY = new SecureInt("WorldItemObject.mSecureTileRelativeY");
         mTime = new SecureNumber("WorldItemObject.mTime");
         mTimeMax = new SecureNumber("WorldItemObject.mTimeMax");
         mTimeBonus = new SecureNumber("WorldItemObject.mTimeBonus");
         mIncomeAmountLeftToCollect = new SecureNumber("WorldItemObject.mIncomeAmountLeftToCollect");
         mSecureUpgradeId = new SecureInt("WorldItemObject.mSecureUpgradeId");
         mHasCollectBonus = new SecureBoolean("WorldItemObject.mHasCollectBonus");
         mIncomeToRestore = new SecureInt("WorldItemObject.mIncomeToRestore");
         mUmbrellaIsEnabled = new SecureBoolean("WorldItemObject.mUmbrellaIsEnabled");
         this.mLogicUpdateFrequency = 50;
         super();
      }
      
      public static function setViewMng(viewMng:ViewMngPlanet) : void
      {
         smViewMng = viewMng;
      }
      
      public static function setMapController(mapController:MapControllerPlanet) : void
      {
         smMapController = mapController;
      }
      
      public static function setWorldItemDefMng(worldItemDefMng:WorldItemDefMng) : void
      {
         smWorldItemDefMng = worldItemDefMng;
      }
      
      public static function setWorldItemObjectController(worldItemObjectController:WorldItemObjectController) : void
      {
         smWorldItemObjectController = worldItemObjectController;
      }
      
      public static function setPoolMng(value:PoolMng) : void
      {
         smPoolMng = value;
      }
      
      public static function setAnimMng(value:AnimMng) : void
      {
         smAnimMng = value;
      }
      
      public static function unloadStatic() : void
      {
         smViewMng = null;
         smMapController = null;
         smWorldItemDefMng = null;
         smWorldItemObjectController = null;
         smPoolMng = null;
         smAnimMng = null;
         smInfluenceArea = null;
         smInfluenceVertices = null;
      }
      
      public function setOldTiles(valueX:int, valueY:int) : void
      {
         this.mOldTileX = valueX;
         this.mOldTileY = valueY;
      }
      
      public function setOldWorldPos(valueX:int, valueY:int) : void
      {
         this.mOldWorldPosX = valueX;
         this.mOldWorldPosY = valueY;
      }
      
      public function getOldWorldPosX() : int
      {
         return this.mOldWorldPosX;
      }
      
      public function getOldWorldPosY() : int
      {
         return this.mOldWorldPosY;
      }
      
      public function getOldTileX() : int
      {
         return this.mOldTileX;
      }
      
      public function getOldTileY() : int
      {
         return this.mOldTileY;
      }
      
      public function set mSid(value:String) : void
      {
         this.mSecureSid.value = parseInt(value,10);
      }
      
      public function get mSid() : String
      {
         return this.mSecureSid.value.toString();
      }
      
      public function get mServerStateId() : int
      {
         return this.mSecureServerStateId.value;
      }
      
      public function set mServerStateId(value:int) : void
      {
         this.mSecureServerStateId.value = value;
      }
      
      public function set mServerModeId(value:int) : void
      {
         this.mSecureServerModeId.value = value;
      }
      
      public function isUpgrading() : Boolean
      {
         return this.mServerStateId == 2;
      }
      
      public function get mServerModeId() : int
      {
         return this.mSecureServerModeId.value;
      }
      
      public function set mUpgradeId(value:int) : void
      {
         this.mSecureUpgradeId.value = value;
      }
      
      public function get mUpgradeId() : int
      {
         return this.mSecureUpgradeId.value;
      }
      
      public function set mTileRelativeX(value:int) : void
      {
         this.mSecureTileRelativeX.value = value;
      }
      
      public function get mTileRelativeX() : int
      {
         return this.mSecureTileRelativeX.value;
      }
      
      public function set mTileRelativeY(value:int) : void
      {
         this.mSecureTileRelativeY.value = value;
      }
      
      public function get mTileRelativeY() : int
      {
         return this.mSecureTileRelativeY.value;
      }
      
      public function reset() : void
      {
         this.mSid = null;
         this.mTime = new SecureNumber("WorldItemObject.mTime",0);
         this.mTimeMax.value = 0;
         this.mTimeOverEvent = null;
         this.mIsForToolPlace = false;
         this.mIncomeAmountLeftToCollect = new SecureNumber("WorldItemObject.mIncomeAmountLeftToCollect",0);
         this.mState = null;
         this.mIsConnectedId = -1;
         this.mIsFlipped = false;
         this.mHasStartedRepairing = false;
         this.mDroidLabourId = -1;
         this.mData.length = 0;
         if(this.mUnit != null)
         {
            this.mUnit = null;
         }
         if(this.mDef != null && this.mDef.usesPath())
         {
            this.pathUnregisterNeighbour();
         }
         this.viewReset();
         this.spySetIsSpiable(false);
         if(Config.useUmbrella())
         {
            this.umbrellaSetIsEnabled(false,false);
         }
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mData = [];
            this.viewLoad();
            this.reset();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mData = null;
         if(this.mDef.usesPath())
         {
            this.pathUnload();
         }
         this.viewUnload();
         this.mBoundingBox = null;
         this.mBoundingBoxParticles = null;
         this.mBoundingBoxUnderBase = null;
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         var isEnergyInPersistence:Boolean = false;
         var energy:int = 0;
         var setEnergyAt1:Boolean = false;
         var energyPercentage:int = 0;
         this.mSid = EUtils.xmlReadString(mPersistenceData,"sid");
         this.mIsConnectedId = 2;
         this.mUpgradeId = EUtils.xmlIsAttribute(mPersistenceData,"upgradeId") ? EUtils.xmlReadInt(mPersistenceData,"upgradeId") : 0;
         this.mDef = smWorldItemDefMng.getDefBySkuAndUpgradeId(EUtils.xmlReadString(mPersistenceData,"sku"),this.mUpgradeId);
         if(this.mDef.isAWall() || this.mDef.isADecoration() || this.mDef.isAnObstacle())
         {
            this.mLogicUpdateFrequency = 1000;
         }
         this.mTileRelativeX = EUtils.xmlReadInt(mPersistenceData,"x");
         this.mTileRelativeY = EUtils.xmlReadInt(mPersistenceData,"y");
         this.mHasStartedRepairing = EUtils.xmlReadBoolean(mPersistenceData,"repairing");
         if(this.mDef.shotCanBeATarget())
         {
            this.mData[1] = -2;
            energy = int((isEnergyInPersistence = EUtils.xmlIsAttribute(mPersistenceData,"energy")) ? EUtils.xmlReadInt(mPersistenceData,"energy") : 100);
            setEnergyAt1 = InstanceMng.getFlowStatePlanet().isCurrentRoleOwner();
            if(setEnergyAt1 && energy == 0)
            {
               energy = 1;
            }
            if(EUtils.xmlIsAttribute(mPersistenceData,"energyPercent"))
            {
               if(isEnergyInPersistence)
               {
                  this.setEnergy(energy);
               }
               else
               {
                  energyPercentage = EUtils.xmlReadInt(mPersistenceData,"energyPercent");
                  if(setEnergyAt1 && energyPercentage == 0)
                  {
                     energyPercentage = 1;
                  }
                  this.setEnergy(this.mDef.getEnergyFromPercentage(energyPercentage));
               }
            }
            else
            {
               this.setEnergy(this.mDef.getEnergyFromPercentage(energy),true);
            }
         }
         else
         {
            this.mData[1] = -1;
         }
         this.viewBuild();
         var state:int = EUtils.xmlReadInt(mPersistenceData,"state");
         var mode:int = 0;
         if(EUtils.xmlIsAttribute(mPersistenceData,"mode"))
         {
            mode = EUtils.xmlReadInt(mPersistenceData,"mode");
         }
         else if(state == 0)
         {
            mode = 1;
         }
         smWorldItemObjectController.changeServerState(this,true,state,mode);
         this.mTime.value = EUtils.xmlReadNumber(mPersistenceData,"time");
         if(this.mDef.usesPath())
         {
            this.pathLoad();
            this.pathRegisterNeighbour();
         }
         this.mIsFlipped = EUtils.xmlReadBoolean(mPersistenceData,"isFlipped");
         if(this.mIsFlipped || this.mDef.isAnObstacle() && parseInt(this.mSid) % 2 == 1 && this.mDef.getBaseCols() == this.mDef.getBaseRows())
         {
            this.mIsFlipped = false;
            this.flip(false);
         }
         this.mHasCollectBonus.value = EUtils.xmlReadBoolean(mPersistenceData,"bonus");
         var reset:Boolean = EUtils.xmlReadBoolean(mPersistenceData,"reset");
         this.mIncomeToRestore.value = EUtils.xmlReadNumber(mPersistenceData,"incomeToRestore");
         smWorldItemObjectController.buildItem(this,reset);
         if(this.needsRepairs())
         {
            this.repairSetup();
         }
         if(this.needsToBeHidden(true))
         {
            this.itemOnTopSetIsEnabled(true);
         }
         this.setCosmeticSpinAngle();
      }
      
      override protected function unbuildDo() : void
      {
         this.reset();
         this.itemOnTopSetIsEnabled(false);
      }
      
      public function setLayerDirty(layer:int, dirty:Boolean) : void
      {
         this.mAnimationDirty[layer] = dirty;
      }
      
      private function setAnimDirty() : void
      {
         var layerId:int = 0;
         if(!this.mAnimationDirty)
         {
            this.mAnimationDirty = [];
         }
         layerId = 0;
         while(layerId < this.viewGetLayersCount())
         {
            this.mAnimationDirty[layerId] = true;
            layerId++;
         }
      }
      
      override protected function beginDo() : void
      {
         if(this.mItemOnTopIsEnabled)
         {
            setEnabled(false);
         }
         this.setAnimDirty();
         this.logicUpdateDo(0);
      }
      
      public function pauseToReceiveAttack() : void
      {
         setEnabled(false);
         if(this.mServerStateId == 2 && this.mDef.showsNormalWhenUpgradingInBattle())
         {
            this.viewLayersTypeRequiredSet(1,1);
            this.viewLayersTypeRequiredSet(2,-1);
         }
         else
         {
            switch(this.mState.mStateId - 22)
            {
               case 0:
                  this.mRepairTime = -1;
            }
         }
         this.mState.pauseToReceiveAttack(this);
      }
      
      public function resumeFromReceivingAttack() : void
      {
         if(this.needsRepairs())
         {
            this.repairSetup();
         }
         setEnabled(true);
         this.mState.resumeFromReceivingAttack(this);
         if(this.mServerStateId == 2 && this.mDef.showsNormalWhenUpgradingInBattle())
         {
            this.viewLayersTypeRequiredSet(1,0);
            this.viewLayersTypeRequiredSet(2,25);
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(mIsEnabled && this.mRepairIsActive)
         {
            this.repairLogicUpdate(dt);
         }
         var mustRunState:Boolean = this.mState.mustBeRun(this) && this.mViewAnimStoppingLayerId == -1 && !this.mItemOnTopIsEnabled;
         if(mustRunState)
         {
            if(this.mState.hasCountdown() && !this.mEventDispatched)
            {
               this.mTime.value -= dt;
               if(this.mTime.value <= 0)
               {
                  this.mTime.value = 0;
                  this.mState.dispatchEvent(this);
               }
            }
         }
         this.updateEnergy();
         this.viewLogicUpdate(dt);
         if(mustRunState)
         {
            this.mState.logicUpdate(this,dt);
         }
         if(mIsEnabled)
         {
            if(this.needsRepairs() && !this.mRepairIsActive && InstanceMng.getWorld().mStartedRepairs && InstanceMng.getFlowStatePlanet().isCurrentRoleOwner() && !InstanceMng.getUnitScene().battleIsRunning())
            {
               this.repairActivate();
               InstanceMng.getNotifyMng().addEvent(smWorldItemObjectController,{
                  "type":0,
                  "cmd":"WIOEventRepairStart",
                  "item":this
               },true);
            }
            this.absorbImpactUpdate(dt);
         }
      }
      
      public function getBoundingRadius() : Number
      {
         return this.mBoundingBox.getMinDimension() * smMapController.mMapViewDef.mTileLogicWidth;
      }
      
      public function getWorldPos(coor:DCCoordinate) : void
      {
         coor.x = this.mTileRelativeX;
         coor.y = this.mTileRelativeY;
         coor = InstanceMng.getViewMngPlanet().tileRelativeXYToWorldPos(coor);
         coor.x += this.mDef.getBaseCols() * 22 >> 1;
         coor.y += this.mDef.getBaseRows() * 22 >> 1;
      }
      
      public function pathGetRoadTileConnectionIndices(insideBase:Boolean) : Vector.<int>
      {
         var tileX:int = 0;
         var tileY:int = 0;
         var worldItemDefMng:WorldItemDefMng = null;
         var i:int = 0;
         var offX:int = 0;
         var offY:int = 0;
         var returnValue:Vector.<int> = null;
         if(this.mDef.isHeadQuarters())
         {
            returnValue = new Vector.<int>(0);
            worldItemDefMng = InstanceMng.getWorldItemDefMng();
            for(i = 0; i < worldItemDefMng.mPathRoadHQTileOffCount; )
            {
               offX = worldItemDefMng.mPathRoadHQTileOffX[i];
               offY = worldItemDefMng.mPathRoadHQTileOffY[i];
               tileX = this.mTileRelativeX + offX;
               tileY = this.mTileRelativeY + offY;
               if(insideBase)
               {
                  if(offX >= this.getBaseCols())
                  {
                     tileX--;
                  }
                  if(offY >= this.getBaseRows())
                  {
                     tileY--;
                  }
               }
               returnValue.push(smMapController.getTileRelativeXYToIndex(tileX,tileY));
               i++;
            }
         }
         return returnValue;
      }
      
      private function connectionSetConnectedBoolean(value:Boolean) : void
      {
         this.connectionSetConnectedId(2);
      }
      
      private function connectionSetConnectedId(value:int) : void
      {
         this.mIsConnectedId = value;
         switch(this.mIsConnectedId - 2)
         {
            case 0:
               if(this.mDef.getTypeId() == 3)
               {
                  InstanceMng.getShipyardController().resumeShipyard(this.mSid);
                  break;
               }
         }
      }
      
      public function isConnected(behaveAsServer:Boolean = false) : Boolean
      {
         return true;
      }
      
      public function setConnected(value:Boolean) : void
      {
         this.connectionSetConnectedBoolean(true);
      }
      
      public function isAllowedToStartUpgrading() : Boolean
      {
         var stateId:int = 0;
         var returnValue:Boolean = false;
         if(this.mState != null)
         {
            if(this.mDef.isARentResource())
            {
               stateId = this.mState.mStateId;
               returnValue = stateId == 5 || stateId == 4;
            }
            else
            {
               returnValue = true;
            }
         }
         return returnValue;
      }
      
      public function isActive() : Boolean
      {
         return smWorldItemObjectController.itemIsActive(this);
      }
      
      public function needsRepairs() : Boolean
      {
         return this.mDef.isAllowedToBeRepaired() && this.canBeBroken() && (this.getEnergy() < this.mDef.getMaxEnergy() || this.mHasStartedRepairing);
      }
      
      public function isBroken() : Boolean
      {
         return this.canBeBroken() && this.getEnergyPercent() <= this.mDef.brokenGetEnergyPercentLogicLevel();
      }
      
      public function isBrokenState() : Boolean
      {
         return this.mState.mStateId == 18 || this.mState.mStateId == 22;
      }
      
      public function isCompletelyBroken() : Boolean
      {
         return this.mData[1] == BROKEN_LAST_LEVEL_ID;
      }
      
      public function canBeBroken() : Boolean
      {
         return this.shotCanBeATarget();
      }
      
      public function shotCanBeATarget() : Boolean
      {
         return this.mDef.shotCanBeATarget() && this.mServerStateId != 0;
      }
      
      public function canBeRide() : Boolean
      {
         return this.mDef.getCanBeRide() && !this.decorationIsBeingRidden() && !this.mIsForToolPlace && !this.labourIsWaitingForDroid() && this.mState.mStateId != 7;
      }
      
      private function getPersistenceDataSku() : String
      {
         return EUtils.xmlReadString(mPersistenceData,"sku");
      }
      
      public function getNextDef() : WorldItemDef
      {
         return this.mServerStateId == 2 ? smWorldItemDefMng.getDefBySkuAndUpgradeId(this.getPersistenceDataSku(),this.mUpgradeId + 1) : this.mDef;
      }
      
      public function getUpgradeDef() : WorldItemDef
      {
         return smWorldItemDefMng.getDefBySkuAndUpgradeId(this.getPersistenceDataSku(),this.mUpgradeId + 1);
      }
      
      public function getMaxUpgradeDef() : WorldItemDef
      {
         var sku:String = this.getPersistenceDataSku();
         var upgrade:int = smWorldItemDefMng.getMaxUpgradeLevel(sku);
         return smWorldItemDefMng.getDefBySkuAndUpgradeId(sku,upgrade);
      }
      
      public function getIsForToolPlace() : Boolean
      {
         return this.mIsForToolPlace;
      }
      
      public function setIsForToolPlace(value:Boolean) : void
      {
         this.mIsForToolPlace = value;
      }
      
      public function getHasJustBeenCreated() : Boolean
      {
         return this.mHasJustBeenCreated;
      }
      
      public function setHasJustBeenCreated(value:Boolean) : void
      {
         this.mHasJustBeenCreated = value;
      }
      
      public function getActionUIId() : int
      {
         var returnValue:int = 25;
         if(this.mIsConnectedId == 2 && this.mState != null)
         {
            returnValue = this.mState.getActionUIId(this);
         }
         return returnValue;
      }
      
      public function setTransaction(transaction:Transaction) : void
      {
         this.mTransaction = transaction;
      }
      
      public function getTransaction() : Transaction
      {
         return this.mTransaction;
      }
      
      public function getBaseCols(def:WorldItemDef = null) : int
      {
         if(def != null)
         {
            return this.mIsFlipped ? def.getBaseRows() : def.getBaseCols();
         }
         return this.mIsFlipped ? this.mDef.getBaseRows() : this.mDef.getBaseCols();
      }
      
      public function getBaseRows(def:WorldItemDef = null) : int
      {
         if(def != null)
         {
            return this.mIsFlipped ? def.getBaseCols() : def.getBaseRows();
         }
         return this.mIsFlipped ? this.mDef.getBaseCols() : this.mDef.getBaseRows();
      }
      
      public function setTileXY(tileX:int, tileY:int) : void
      {
         this.mTileRelativeX = smMapController.getTileToTileRelativeX(tileX);
         this.mTileRelativeY = smMapController.getTileToTileRelativeY(tileY);
         this.viewSetBaseAtTile(tileX,tileY,true);
      }
      
      public function getCenterWorldPos(coor:DCCoordinate) : void
      {
         coor.x = this.mViewCenterWorldX;
         coor.y = this.mViewCenterWorldY;
         InstanceMng.getViewMngPlanet().viewPosToLogicPos(coor);
      }
      
      public function hasSeveralUpgrades() : Boolean
      {
         return smWorldItemDefMng.getMaxUpgradeLevel(this.mDef.mSku) > 1;
      }
      
      public function canBeUpgraded() : Boolean
      {
         return this.mUpgradeId < smWorldItemDefMng.getMaxUpgradeLevel(this.mDef.mSku);
      }
      
      public function hasNoUpgrades() : Boolean
      {
         return smWorldItemDefMng.getMaxUpgradeLevel(this.mDef.mSku) == 1;
      }
      
      public function canBeUpgradedAtCurrentHQLevel() : Boolean
      {
         var hqLevel:Number = InstanceMng.getWorld().itemsGetHeadquarters().mDef.getUpgradeId();
         var mNextDef:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(this.mDef.mSku,this.mDef.getUpgradeId() + 1);
         var levelRequired:int = InstanceMng.getGUIController().getLevelRequiredByItemDef(mNextDef,true);
         return hqLevel >= levelRequired;
      }
      
      public function canStateBeUpgraded() : Boolean
      {
         var INVALID_STATES:Array = [18,2,7,22,16];
         return INVALID_STATES.indexOf(this.mState.mStateId) == -1;
      }
      
      public function setUnit(u:MyUnit) : void
      {
         this.mUnit = u;
         if(u != null)
         {
            u.setEnergy(this.mData[0]);
            this.setEnergy(this.mData[0],true);
            this.setCosmeticSpinAngle();
         }
      }
      
      private function setCosmeticSpinAngle() : void
      {
         var angle:Number = NaN;
         if(this.mUnit == null || !(this.mUnit.getGoalComponent() is GoalDefense) || !InstanceMng.getApplication().isTutorialCompleted())
         {
            return;
         }
         var viewMngPlanet:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var mapControllerPlanet:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         var myCoord:DCCoordinate = viewMngPlanet.tileXYToWorldViewPos(new DCCoordinate(mapControllerPlanet.getTileRelativeXToTile(this.mTileRelativeX),mapControllerPlanet.getTileRelativeYToTile(this.mTileRelativeY)));
         var midCoord:DCCoordinate = viewMngPlanet.tileXYToWorldViewPos(new DCCoordinate(mapControllerPlanet.mTilesCols >> 1,mapControllerPlanet.mTilesRows >> 1));
         if(DCMath.distanceSqr(myCoord,midCoord) == 0)
         {
            angle = 1.5707963267948966;
         }
         else
         {
            angle = DCMath.getAngle(myCoord,midCoord);
         }
         if(!this.mIsFlipped)
         {
            angle += 3.141592653589793;
         }
         this.mUnit.spinSetAngle(angle);
      }
      
      public function getEnergy() : int
      {
         return this.mData[0];
      }
      
      public function setEnergy(value:int, build:Boolean = false) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         var previous:int = int(this.mData[0]);
         if(build)
         {
            previous = this.mDef.getMaxEnergy();
         }
         this.mData[0] = value;
         if(this.mDef.getMaxEnergy() > 0)
         {
            this.setBrokenLevel(previous);
         }
      }
      
      public function setEnergyPercent(value:Number) : void
      {
         var val:int = this.mDef.getEnergyFromPercentage(value);
         this.setEnergy(val);
      }
      
      public function getEnergyPercent() : Number
      {
         return this.mDef.getEnergyPercent(this.mData[0]);
      }
      
      public function updateEnergy() : void
      {
         var unitEnergy:int = 0;
         if(this.mUnit != null && this.mUnit.mDef.shotCanBeATarget())
         {
            unitEnergy = this.mUnit.getEnergy();
            if(unitEnergy != this.mData[0])
            {
               this.setEnergy(unitEnergy);
            }
            if(!this.mUnit.liveBarGetVisible() && this.mUnit.liveBarMustBeDrawn())
            {
               this.mUnit.addLifeBarToUnit();
            }
         }
      }
      
      public function setBrokenLevel(previousEnergy:int) : void
      {
         var i:int = 0;
         var animId:int = -1;
         var currentPercent:Number = this.mDef.getEnergyPercent(this.mData[0]);
         var previousPercent:Number = this.mDef.getEnergyPercent(previousEnergy);
         var brokenLogicLevelPercent:int = this.mDef.brokenGetEnergyPercentLogicLevel();
         if(this.mState != null && this.mState.mStateId == 22)
         {
            if(previousPercent < brokenLogicLevelPercent && currentPercent >= brokenLogicLevelPercent)
            {
               if(this.mUnit != null && this.canBeBroken())
               {
                  InstanceMng.getUnitScene().buildingsSetupFromItem(this,false);
               }
            }
         }
         else if(currentPercent < brokenLogicLevelPercent)
         {
            if(previousPercent >= brokenLogicLevelPercent)
            {
               if(this.mUnit != null && this.canBeBroken())
               {
                  this.mUnit.becomeBroken();
                  InstanceMng.getNotifyMng().addEvent(smWorldItemObjectController,{
                     "type":0,
                     "cmd":"WIOEventBreak",
                     "item":this
                  },true);
               }
            }
         }
         var visualLevels:Vector.<int> = this.mDef.brokenGetVisualLevels();
         var visualLevelsLength:int = int(visualLevels.length);
         currentPercent = 100 - currentPercent;
         i = 0;
         while(i < visualLevelsLength && visualLevels[i] < currentPercent)
         {
            i++;
         }
         animId = i - 1;
         var setPowerUp:int = -1;
         if(this.mData[1] < BROKEN_LAST_LEVEL_ID && animId == BROKEN_LAST_LEVEL_ID)
         {
            this.viewLayersTypeRequiredSet(0,32);
            smMapController.mMapModel.itemSetBaseEmpty(this);
            this.viewLayersTypeRequiredSet(1,8);
            setPowerUp = 0;
         }
         else if(this.mData[1] == BROKEN_LAST_LEVEL_ID && animId < BROKEN_LAST_LEVEL_ID)
         {
            this.viewLayersTypeRequiredSet(0,31);
            smMapController.mMapModel.itemSetBaseBusy(this);
            setPowerUp = 1;
         }
         if(this.mData[1] > -2 && this.mData[1] < animId)
         {
            if(!this.mDef.isAWall())
            {
               ParticleMng.startModularParticles(this);
            }
            InstanceMng.getUnitScene().viewCheckUnitEffects(this.mUnit);
         }
         if(this.mData[1] != animId)
         {
            this.setAnimDirty();
         }
         this.mData[1] = animId;
         if(Config.usePowerUps() && setPowerUp > -1)
         {
            if(InstanceMng.getPowerUpMng().unitsIsAnyPowerUpActiveByUnitSku(this.mDef.mSku,1))
            {
               this.viewSetPowerUp(setPowerUp > 0);
            }
         }
      }
      
      public function setState(value:WorldItemObjectState, resetState:Boolean = false) : void
      {
         var previousStateType:int = this.viewLayersTypeRequiredGet(4);
         if(this.mState != null)
         {
            this.mState.end(this);
         }
         this.mState = value;
         this.mEventDispatched = false;
         if(this.mState == null && Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in WorldItemObject.setState: state null",1);
         }
         else
         {
            this.mState.begin(this,resetState);
            if(this.mTimeBonus.value > 0)
            {
               this.mTime.value -= this.mTimeBonus.value;
               this.mTimeBonus.value = 0;
            }
            if(previousStateType == 40)
            {
               this.viewLayersTypeRequiredSet(4,40);
            }
         }
         this.setAnimDirty();
      }
      
      public function setTimeBonus() : void
      {
         var percent:Number = InstanceMng.getSettingsDefMng().getHelpAccelerationTime() * 0.01;
         var def:WorldItemDef = this.getNextDef();
         var totalHelp:Number = this.mTime.value * percent;
         if(mIsEnabled == false)
         {
            this.mTimeBonus.value += totalHelp;
         }
         else
         {
            this.mTime.value -= totalHelp;
         }
      }
      
      public function getTimeBonus() : Number
      {
         var percent:Number = InstanceMng.getSettingsDefMng().getHelpAccelerationTime() * 0.01;
         var def:WorldItemDef = this.getNextDef();
         return this.mTime.value * percent;
      }
      
      public function getTimeBonusText() : String
      {
         var totalHelp:Number = this.getTimeBonus();
         return GameConstants.getTimeTextFromMs(totalHelp);
      }
      
      public function setHasCollectionBonus(value:Boolean) : void
      {
         this.mHasCollectBonus.value = value;
      }
      
      public function hasCollectionBonus() : Boolean
      {
         return this.mHasCollectBonus.value;
      }
      
      public function getCollectionBonusText(useCurrentIncome:Boolean = false) : String
      {
         if(useCurrentIncome == false)
         {
            return DCTextMng.getText(243);
         }
         return "+" + DCTextMng.convertNumberToString(this.getCollectionBonusAmount(),-1,-1);
      }
      
      public function getCollectionBonusAmount() : Number
      {
         var bonus:Number = this.getIncomeAmount() * InstanceMng.getSettingsDefMng().getHelpPercentageBonus() * 0.01;
         return Math.round(bonus);
      }
      
      public function effectIsEnabled() : Boolean
      {
         return this.mServerStateId == 1 || this.mServerStateId == 2;
      }
      
      private function pathLoad() : void
      {
         this.mPathTiles = new Vector.<DCAStarNode>(0);
         this.mPathSearch = null;
      }
      
      private function pathUnload() : void
      {
         this.mPathTiles = null;
         this.mPathSearch = null;
      }
      
      private function pathRegisterNeighbour() : void
      {
         this.pathLoopNeighbours(this.pathRegisterTile);
      }
      
      private function pathUnregisterNeighbour() : void
      {
         this.pathLoopNeighbours(this.pathUnregisterTile);
      }
      
      private function pathLoopNeighbours(thisFunction:Function) : void
      {
         var i:int = 0;
         var j:int = 0;
         var index:int = 0;
         var tile:TileData = null;
         var endX:int = this.getBaseCols() + 1;
         var endY:int = this.getBaseRows() + 1;
         var register:* = false;
         var worldItemDefMng:WorldItemDefMng = InstanceMng.getWorldItemDefMng();
         for(i = -1; i < endX; )
         {
            for(j = -1; j < endY; )
            {
               if(this.mDef.isHeadQuarters())
               {
                  register = worldItemDefMng.pathRoadHQContainsTileRelative(i,j);
               }
               else
               {
                  register = !((j == -1 || j == endY - 1) && (i == -1 || i == endX - 1));
               }
               if(register)
               {
                  index = smMapController.getTileRelativeXYToIndex(this.mTileRelativeX + i,this.mTileRelativeY + j);
                  if((tile = smMapController.mMapModel.getTileDataFromIndex(index)) != null && (this.mDef.isHeadQuarters() || tile.canBeStepped()))
                  {
                     thisFunction(tile);
                  }
               }
               j++;
            }
            i++;
         }
      }
      
      public function pathRegisterTile(tile:TileData) : void
      {
         var tileX:int = 0;
         var tileY:int = 0;
         var allowed:Boolean = true;
         if(this.mDef.isHeadQuarters() && tile.getTypeId() == 0)
         {
            tileX = smMapController.getTileToTileRelativeX(tile.mCol) - this.mTileRelativeX;
            tileY = smMapController.getTileToTileRelativeY(tile.mRow) - this.mTileRelativeY;
            allowed = InstanceMng.getWorldItemDefMng().pathRoadHQContainsTileRelative(tileX,tileY);
         }
         if(allowed)
         {
            this.mPathTiles.push(tile);
         }
      }
      
      public function pathUnregisterTile(tile:TileData) : void
      {
         var pos:int = this.mPathTiles.indexOf(tile);
         if(pos > -1)
         {
            this.mPathTiles.splice(pos,1);
         }
      }
      
      override public function persistenceGetData() : XML
      {
         var mode:int = int(this.mServerStateId == 0 ? 1 : this.mServerModeId);
         var xml:XML = EUtils.stringToXML("<Item sid=\"" + this.mSid + "\" sku=\"" + this.mDef.mSku + "\" type=\"" + this.mDef.getTypeId() + "\" time=\"" + this.mTime.value + "\" x=\"" + this.mTileRelativeX + "\" y=\"" + this.mTileRelativeY + "\" state=\"" + this.mServerStateId + "\" upgradeId=\"" + this.mUpgradeId + "\" isFlipped=\"" + DCUtils.booleanToString(this.mIsFlipped) + "\" repairing=\"" + DCUtils.booleanToString(this.mHasStartedRepairing) + "\" incomeToRestore=\"" + this.mIncomeToRestore.value + "\"/>");
         if(this.mDef.shotCanBeATarget())
         {
            EUtils.xmlSetAttribute(xml,"energy",this.mData[0]);
            EUtils.xmlSetAttribute(xml,"energyPercent",this.mDef.getEnergyPercent(this.mData[0]));
         }
         return xml;
      }
      
      public function actionUIIsAllowed(actionId:int) : Boolean
      {
         return this.mState != null && this.mState.actionUIIsAllowed(actionId);
      }
      
      override public function notify(e:Object) : Boolean
      {
         var on:Boolean = false;
         var group:String = null;
         var sku:String = null;
         var returnValue:Boolean = false;
         switch(e.cmd)
         {
            case "battleEventHasStarted":
               this.mRepairIsActive = false;
               if(this.needsRepairs())
               {
                  this.repair();
               }
               if(this.mUnit != null)
               {
                  this.mUnit.blockLiveBar(false);
               }
               break;
            case "battleEventHasFinished":
               if(this.needsRepairs())
               {
                  if(this.getEnergy() == 0)
                  {
                     this.setEnergy(1);
                  }
                  this.repairSetup();
               }
               break;
            case "WIOEventPowerUpSwitch":
               on = Boolean(e.on);
               group = String(e.group);
               if(this.mDef.belongsToGroup(group))
               {
                  sku = String(e.powerUpSku);
                  InstanceMng.getPowerUpMng().unitsRegisterPowerUpSku(this.mDef.mSku,sku,1,on);
                  this.viewSetPowerUp(on);
               }
         }
         if(this.mState != null)
         {
            returnValue = this.mState.notify(this,e);
         }
         return returnValue;
      }
      
      private function isReadyForPowerUp() : Boolean
      {
         return !this.isCompletelyBroken() && this.mServerStateId != 0;
      }
      
      public function repairSetup() : void
      {
         var attribute:String = null;
         var time:Number = NaN;
         this.mRepairEnergyInit = this.getEnergyPercent();
         var energyToRepairPercent:Number = 100 - this.mRepairEnergyInit;
         var allRepairingTime:Number = InstanceMng.getSettingsDefMng().getRepairMaxTime();
         this.mRepairTimeMax = allRepairingTime * energyToRepairPercent / 100;
         if(this.mHasStartedRepairing)
         {
            attribute = "repairingTime";
            if(EUtils.xmlIsAttribute(mPersistenceData,attribute))
            {
               this.mRepairTimeMax = EUtils.xmlReadNumber(mPersistenceData,attribute);
               time = allRepairingTime - this.mRepairTimeMax;
               this.mRepairEnergyInit = time * 100 / allRepairingTime;
            }
         }
         this.setTransaction(null);
         this.mRepairTime = this.mRepairTimeMax - this.mRepairBonusTime;
      }
      
      private function repairActivate() : void
      {
         if(this.mUnit == null)
         {
            InstanceMng.getUnitScene().addItem(this);
         }
         this.mUnit.setEnergyPercent(this.mRepairEnergyInit);
         if(this.mRepairEnergyInit == 0)
         {
            this.mUnit.addLifeBarToUnit();
         }
         this.mRepairIsActive = true;
      }
      
      private function repairLogicUpdate(dt:int) : void
      {
         if(this.mState.mStateId != 22)
         {
            return;
         }
         if(this.mRepairTime == -1)
         {
            return;
         }
         if(this.isRepairing() == false)
         {
            return;
         }
         this.mRepairTime -= dt;
         if(this.mRepairTime < 0)
         {
            this.repair();
            InstanceMng.getNotifyMng().addEvent(smWorldItemObjectController,{
               "type":0,
               "cmd":"WIOEventRepairEnd",
               "item":this
            },true);
            return;
         }
         var percent:Number = this.mRepairEnergyInit + DCMath.ruleOf3(this.mRepairTimeMax - this.mRepairTime,this.mRepairTimeMax,100 - this.mRepairEnergyInit);
         this.repairSetEnergyPercent(percent);
      }
      
      public function repair() : void
      {
         if(!this.mRepairIsActive)
         {
            this.repairActivate();
         }
         this.mRepairTime = -1;
         this.mRepairBonusTime = 0;
         this.repairSetEnergyPercent(100);
         this.mHasStartedRepairing = false;
         this.mRepairIsActive = false;
      }
      
      public function repairSetEnergyPercent(percent:Number) : void
      {
         this.setEnergyPercent(percent);
         if(this.mUnit)
         {
            this.mUnit.setEnergyPercent(percent);
         }
      }
      
      public function getRepairTime() : Number
      {
         return this.mRepairTime;
      }
      
      public function setRepairBonusTime() : void
      {
         var percent:Number = InstanceMng.getSettingsDefMng().getHelpAccelerationTime() * 0.01;
         var totalHelp:Number = this.mDef.getRepairingTime() * percent;
         if(this.mState.mStateId != 22)
         {
            this.mRepairBonusTime += totalHelp;
         }
         else
         {
            this.mRepairTime -= totalHelp;
         }
      }
      
      public function getRepairTimeBonus() : Number
      {
         var percent:Number = InstanceMng.getSettingsDefMng().getHelpAccelerationTime() * 0.01;
         return this.mDef.getRepairingTime() * percent;
      }
      
      public function getRepairTimeBonusText() : String
      {
         var totalHelp:Number = this.getRepairTimeBonus();
         return GameConstants.getTimeTextFromMs(totalHelp);
      }
      
      public function isRepairing() : Boolean
      {
         return this.mRepairIsActive;
      }
      
      public function buildingCanStart() : Boolean
      {
         return this.mServerStateId == 0 && this.mServerModeId == 0;
      }
      
      public function buildingStart() : void
      {
         this.mDroidLabourId = 0;
         InstanceMng.getNotifyMng().addEvent(smWorldItemObjectController,{
            "type":0,
            "cmd":"WIOEventDroidRequested",
            "item":this
         },true);
      }
      
      public function getTimeMax() : Number
      {
         return this.mTimeMax.value;
      }
      
      public function getProgressTime() : Number
      {
         return this.mTimeMax.value - this.mTime.value;
      }
      
      public function getTimeLeft(checkRepairTime:Boolean = false) : Number
      {
         var labourId:int = 0;
         var returnValue:Number = this.mTime.value;
         if(this.labourIsWaitingForDroid())
         {
            labourId = this.labourGetId();
            if(labourId == 1 || labourId == 0)
            {
               returnValue = this.getNextDef().getConstructionTime();
            }
         }
         if(checkRepairTime && this.mState != null && this.mState.mStateId == 22)
         {
            returnValue = this.mRepairTime;
         }
         return returnValue;
      }
      
      public function getIncomeToRestore() : int
      {
         return this.mIncomeToRestore.value;
      }
      
      public function setIncomeToRestore(value:int) : void
      {
         this.mIncomeToRestore.value = value;
      }
      
      public function calculateIncomeToRestore() : void
      {
         this.mIncomeToRestore.value = this.getIncomeAmount();
      }
      
      public function getIncomeAmount() : Number
      {
         var returnValue:Number = 0;
         if(this.mServerStateId == 1)
         {
            returnValue = this.mDef.getIncomeAmountFromTime(this.mDef.getIncomeTime() - this.mTime.value);
         }
         return returnValue;
      }
      
      public function getIncomeAmountLineal() : Number
      {
         return this.mDef.getIncomeAmountFromTimeLineal(this.mDef.getIncomeTime() - this.mTime.value);
      }
      
      public function hasIncomeAmountLeftToCollect() : Boolean
      {
         return this.mIncomeAmountLeftToCollect.value > 0.00001;
      }
      
      public function setIncomeTimeFromAmount(amount:Number) : void
      {
         var t:Number = amount / this.mDef.getIncomeSpeed();
         t = Math.floor(InstanceMng.getSettingsDefMng().getIncomePace() * t);
         this.mTime.value = this.mDef.getIncomeTime() - t;
      }
      
      public function setIncomeTimeFromAmountLineal(amount:Number) : void
      {
         var t:Number = Math.floor(amount * this.mDef.getIncomeTime() / this.mDef.getIncomeCapacity());
         this.mTime.value = this.mDef.getIncomeTime() - t;
      }
      
      public function getIncomeAmountLeftToCollect() : Number
      {
         return this.mIncomeAmountLeftToCollect.value;
      }
      
      public function setIncomeAmountLeftToCollect(value:Number) : void
      {
         this.mIncomeAmountLeftToCollect.value = value;
      }
      
      public function labourIsWaitingForDroid() : Boolean
      {
         return smWorldItemObjectController.labourIsWaitingForDroid(this);
      }
      
      public function labourGetId() : int
      {
         return smWorldItemObjectController.labourGetId(this);
      }
      
      public function viewLoad() : void
      {
         this.mViewCoor = new DCCoordinate();
         this.mViewLayersTypeRequired = new Array(this.viewGetLayersCount());
         this.mViewLayersTypeCurrent = new Array(this.viewGetLayersCount());
         this.mViewLayersImpCurrent = new Array(this.viewGetLayersCount());
         this.mViewLayersAnims = new Array(this.viewGetLayersCount());
         this.setAnimDirty();
      }
      
      public function viewUnload() : void
      {
         this.mViewCoor = null;
         this.mViewLayersTypeRequired = null;
         this.mViewLayersTypeCurrent = null;
         this.mViewLayersImpCurrent = null;
         this.mViewLayersAnims = null;
         this.mViewAttributes = null;
      }
      
      public function viewReset() : void
      {
         var layerId:int = 0;
         for(layerId = 0; layerId < this.viewGetLayersCount(); )
         {
            if(this.viewLayersTypeCurrentGet(layerId) != -1 && this.viewLayersAnimGet(layerId) != null && !this.mIsForToolPlace)
            {
               smViewMng.worldItemRemoveFromStage(layerId,this,this.viewLayersTypeCurrentGet(layerId));
            }
            if(this.viewLayersAnimGet(layerId) != null)
            {
               smAnimMng.itemReleaseAnim(this,layerId);
            }
            this.viewLayersTypeRequiredSet(layerId,-1);
            this.viewLayersTypeCurrentSet(layerId,-1);
            this.viewLayersImpCurrentSet(layerId,-1);
            layerId++;
         }
         this.setAnimDirty();
         this.mViewTimerMS = -1;
         this.mViewAnimStoppingLayerId = -1;
         this.mViewAnimStoppingAnimId = -1;
         this.mViewAnimStoppingAnimToRestoreId = -1;
         this.mViewIsSelected = false;
      }
      
      private function viewBuild() : void
      {
         var tileX:int = int(smMapController.getTileRelativeXToTile(this.mTileRelativeX));
         var tileY:int = int(smMapController.getTileRelativeYToTile(this.mTileRelativeY));
         this.viewSetBaseAtTile(tileX,tileY);
      }
      
      private function viewUnbuild() : void
      {
         this.viewReset();
         if(Config.DEBUG_MODE)
         {
            InstanceMng.getUnitScene().debugRemoveSprite(this,"debugLabelBBox");
         }
      }
      
      public function viewLayersTypeRequiredGet(layerId:int) : int
      {
         return this.mViewLayersTypeRequired[layerId];
      }
      
      public function viewLayersTypeRequiredSet(layerId:int, value:int) : void
      {
         this.mViewLayersTypeRequired[layerId] = value;
         this.mAnimationDirty[layerId] = true;
      }
      
      public function viewLayersTypeRequiredGetAll() : Array
      {
         return this.mViewLayersTypeRequired;
      }
      
      public function viewLayersTypeCurrentGet(layerId:int) : int
      {
         return this.mViewLayersTypeCurrent[layerId];
      }
      
      public function viewLayersTypeCurrentSet(layerId:int, value:int) : void
      {
         this.mViewLayersTypeCurrent[layerId] = value;
         this.mAnimationDirty[layerId] = true;
      }
      
      public function viewLayersTypeCurrentGetAll() : Array
      {
         return this.mViewLayersTypeCurrent;
      }
      
      public function viewLayersImpCurrentGet(layerId:int) : int
      {
         return this.mViewLayersImpCurrent[layerId];
      }
      
      public function viewLayersImpCurrentSet(layerId:int, value:int) : void
      {
         if(layerId == 1 && this.mBoundingBox != null)
         {
            if(value == 0)
            {
               this.mBoundingBox.mZ = 0;
            }
            else if(this.mViewLayersImpCurrent[layerId] == 0)
            {
               this.setBoundingBoxZ();
            }
         }
         this.mViewLayersImpCurrent[layerId] = value;
         this.mAnimationDirty[layerId] = true;
      }
      
      public function viewLayersCheckFilters(layerId:int) : void
      {
         switch(layerId - 1)
         {
            case 0:
            case 3:
               if(this.spyGetIsSpiable())
               {
                  switch(this.mSpyState)
                  {
                     case 0:
                     case 1:
                        this.spyApplyFilter(false);
                        break;
                     case 2:
                        this.spyApplyFilter(true,0.15,16711680);
                        break;
                     case 3:
                        this.spyApplyFilter(true,0.4);
                        break;
                     case 4:
                        this.spyApplyFilter(true,0.85,10092492);
                  }
                  break;
               }
               if(this.umbrellaGetIsEnabled())
               {
                  this.umbrellaSetSelected(this.mViewIsSelected);
               }
               break;
         }
      }
      
      public function viewLayersImpCurrentGetAll() : Array
      {
         return this.mViewLayersImpCurrent;
      }
      
      public function viewLayersAnimGet(layerId:int) : DCDisplayObject
      {
         return this.mViewLayersAnims[layerId];
      }
      
      public function viewLayersAnimSet(layerId:int, value:DCDisplayObject) : void
      {
         this.mViewLayersAnims[layerId] = value;
         this.mAnimationDirty[layerId] = true;
      }
      
      public function viewLayersAddToStage(layerId:int) : void
      {
         smViewMng.worldItemAddToStage(layerId,this,this.viewLayersTypeCurrentGet(layerId));
         this.mAnimationDirty[layerId] = true;
      }
      
      public function viewLayersRemoveFromStage(layerId:int) : void
      {
         smViewMng.worldItemRemoveFromStage(layerId,this,this.viewLayersTypeCurrentGet(layerId));
      }
      
      private function viewLayersGetRaisedBoundingBox() : DCBox
      {
         var box:DCBoxWithTiles = DCBoxWithTiles(this.mBoundingBox.clone(null));
         box.mZ += 1;
         return box;
      }
      
      public function viewLayersNeedsToBeRaised(layerId:int) : Boolean
      {
         return layerId == 3 || this.viewLayersTypeCurrentGet(layerId) == 19 || this.viewLayersTypeCurrentGet(layerId) == 18;
      }
      
      public function viewLayersGetBoundingBox(layerId:int) : DCBox
      {
         return this.viewLayersNeedsToBeRaised(layerId) ? this.viewLayersGetRaisedBoundingBox() : this.mBoundingBox;
      }
      
      public function viewLayersGetSortingBox(layerId:int) : DCBox
      {
         var raiseLayer:Boolean = false;
         var returnValue:DCBox = this.mBoundingBox;
         switch(layerId - 2)
         {
            case 0:
               this.mBoundingBoxParticles = DCBoxWithTiles(this.mBoundingBox.clone(this.mBoundingBoxParticles));
               this.mBoundingBoxParticles.mTileX += 1;
               returnValue = this.mBoundingBoxParticles;
               break;
            case 1:
            case 3:
               raiseLayer = this.viewLayersNeedsToBeRaised(layerId);
         }
         if(raiseLayer)
         {
            returnValue = this.viewLayersGetRaisedBoundingBox();
         }
         return returnValue;
      }
      
      public function viewExtraUsesTurretPedestal() : Boolean
      {
         return this.mDef.viewExtraUsesTurretPedestal() && !this.isCompletelyBroken();
      }
      
      public function viewGetGroundAnimSkus(skus:Vector.<String>) : void
      {
         var def:WorldItemDef = this.getNextDef();
         skus[0] = InstanceMng.getSkinsMng().getCurrentFoundationAsset();
         skus[1] = "base_";
         if(this.isCompletelyBroken())
         {
            skus[1] += "broken_";
         }
         else if(this.mDef.viewExtraUsesTurretPedestal())
         {
            skus[1] += "turret_";
         }
         skus[1] += this.getBaseCols(def) + "x" + this.getBaseRows(def);
      }
      
      public function viewGetAnimSkus(skus:Vector.<String>, layerId:int = -1) : void
      {
         var assetFile:String = null;
         var def:WorldItemDef = this.getNextDef();
         if(layerId == 0)
         {
            this.viewGetGroundAnimSkus(skus);
         }
         else
         {
            assetFile = def.getAssetFile();
            if(layerId == 1 && skus[0] == null)
            {
               if(skus[0] == null)
               {
                  skus[0] = InstanceMng.getResourceMng().getWorldItemObjectFileName(def,skus[1],null,2,true);
               }
               else
               {
                  skus[0] = def.getAssetFile();
                  skus[1] = def.getAssetId() + "_" + skus[1];
               }
            }
            else
            {
               skus[0] = assetFile;
               skus[1] = def.getAssetId() + "_" + skus[1];
            }
         }
      }
      
      public function viewLayersIsAllowedToBeDraw(layerId:int) : Boolean
      {
         return layerId == 4 || layerId == 6 || !this.mIsForToolPlace;
      }
      
      public function viewGetWorldX() : int
      {
         return this.mViewCenterWorldX;
      }
      
      public function viewGetWorldY() : int
      {
         return this.mViewCenterWorldY;
      }
      
      public function viewGetWorldZ() : int
      {
         return this.mViewZ;
      }
      
      public function viewSetWorldZ(value:int) : void
      {
         this.mViewZ = value;
      }
      
      public function viewGetAnchorX() : int
      {
         return 0;
      }
      
      public function viewGetAnchorY() : int
      {
         return 0;
      }
      
      public function viewGetImpId(layer:int) : int
      {
         var shouldBeDisplayed:Boolean = false;
         if(this.isFlatBed())
         {
            if(layer == 0)
            {
               return 47;
            }
            if(layer == 1 && !(this.mDef.isAnObstacle() || this.mDef.isADecoration() || this.mDef.isAWall() || this.mDef.isAMine()))
            {
               return 49;
            }
            if(this.mState == null)
            {
               DCDebug.trace("WARNING in WorldItemObject.viewGetImpId(): state is null",1);
               return -3;
            }
            shouldBeDisplayed = layer == 7 && this.mState.mStateId == 7 || layer >= 2 && layer <= 6 && !this.mDef.isHeadQuarters() || layer == 4;
            if(!shouldBeDisplayed || layer == 3 || layer == 5 && (this.mState.mStateId == 5 || this.mState.mStateId == 32))
            {
               return -1;
            }
         }
         return -3;
      }
      
      public function viewGetAnimImpIdBaseReady() : int
      {
         var returnValue:int = this.viewUsesBaseUnit() ? 2 : 1;
         if(this.mDef.getCanBeRide())
         {
            switch(this.mDecorationMode - 2)
            {
               case 0:
                  returnValue = 46;
                  break;
               case 1:
                  returnValue = 40;
                  break;
               case 2:
                  returnValue = 46;
            }
         }
         return returnValue;
      }
      
      public function isFlatBed() : Boolean
      {
         return InstanceMng.getUserInfoMng().getProfileLogin().getFlatbed() && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId() == InstanceMng.getUserInfoMng().getProfileLogin().getAccountId() && InstanceMng.getFlowStatePlanet().getCurrentRoleId() != 7;
      }
      
      private function viewLogicUpdate(dt:int) : void
      {
         var layerId:int = 0;
         var impNeededId:int = 0;
         var d:DCDisplayObject = null;
         var frameId:int = 0;
         var incomeAmount:Number = NaN;
         var pace:int = 0;
         var totalSteps:int = 0;
         var paceFrames:int = 0;
         if(this.canBeBroken() && this.mDef.getAnimOnBase() != null)
         {
            if(this.viewLayersGetAttribute(1,"brokenLevel") == 0)
            {
               this.viewLayersTypeRequiredSet(3,38);
            }
            else
            {
               this.viewLayersTypeRequiredSet(3,-1);
            }
         }
         if(this.mViewTimerMS >= 0)
         {
            this.mViewTimerMS -= dt;
         }
         if(this.mDef.isAWall() && InstanceMng.getUserInfoMng().getProfileLogin().getInvisibleWalls() && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getIsOwner())
         {
            this.viewLayersTypeRequiredSet(1,-1);
         }
         var flatBed:Boolean;
         if((flatBed = this.isFlatBed()) != this.mPreviousFlatbedValue)
         {
            this.mPreviousFlatbedValue = flatBed;
            if(this.mUnit != null && this.mUnit.getViewComponent() != null)
            {
               this.mUnit.getViewComponent().setAlpha(flatBed ? 0 : 1);
            }
         }
         layerId = 0;
         while(layerId < this.viewGetLayersCount())
         {
            if(this.mItemOnTopIsEnabled && layerId > 0)
            {
               break;
            }
            impNeededId = this.viewGetImpId(layerId);
            smAnimMng.itemCheckAnims(this,layerId,dt,impNeededId);
            if((d = this.viewLayersAnimGet(layerId)) != null)
            {
               frameId = 0;
               loop1:
               switch(layerId - 1)
               {
                  case 0:
                     switch(this.mDecorationMode - 2)
                     {
                        case 0:
                        case 2:
                           if(d.currentFrame == d.totalFrames)
                           {
                              this.decorationSetMode(this.mDecorationMode == 2 ? 3 : 0);
                              break loop1;
                           }
                     }
                     break;
                  case 4:
                     switch(this.viewLayersTypeCurrentGet(layerId) - 9)
                     {
                        case 0:
                           if(d.currentFrame == d.totalFrames)
                           {
                              this.connectionSetConnectedId(2);
                           }
                           break;
                        case 2:
                        case 5:
                           if((incomeAmount = this.getIncomeAmount()) > 0)
                           {
                              pace = incomeAmount / this.mDef.getIncomeSpeed() - 1;
                              paceFrames = (totalSteps = this.mDef.getIncomeCapacity() / this.mDef.getIncomeSpeed() - 1) / (d.totalFrames - 1);
                              if(totalSteps % (d.totalFrames - 1) > 0)
                              {
                                 paceFrames++;
                              }
                              frameId = pace / paceFrames + 1;
                           }
                           d.gotoAndStop(frameId + 1);
                     }
                     break;
                  case 6:
                     frameId = this.getProgressTime() * d.totalFrames / this.getTimeMax();
                     d.gotoAndStop(frameId);
               }
               if(layerId == this.mViewAnimStoppingLayerId)
               {
                  if(d != null && this.viewLayersTypeRequiredGet(layerId) == this.viewLayersTypeCurrentGet(layerId))
                  {
                     if(d.currentFrame == d.totalFrames)
                     {
                        this.viewAnimStoppingStateReset();
                     }
                  }
               }
            }
            layerId++;
         }
      }
      
      public function viewIsAnimInLayerOver(layerId:int) : Boolean
      {
         var returnValue:Boolean = false;
         var anim:DCDisplayObject = this.viewLayersAnimGet(layerId);
         if(anim != null && this.viewLayersTypeRequiredGet(layerId) == this.viewLayersTypeCurrentGet(layerId))
         {
            returnValue = anim.isAnimationOver();
         }
         return returnValue;
      }
      
      public function viewLayersGetWorldXY(layerId:int, coor:DCCoordinate, anchorPoint:int = -99) : void
      {
         var radius:int = 0;
         if(anchorPoint == -99)
         {
            anchorPoint = 1;
         }
         if(this.viewLayersTypeCurrentGet(layerId) == 3 || this.viewLayersTypeCurrentGet(layerId) == 4)
         {
            radius = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(this.mDef.mSku,1,"turretsExtraRange",this.mDef.getShotDistance());
            coor.x = this.mViewCenterWorldX;
            coor.y = this.mViewCenterWorldY - (radius >> 1) + radius;
         }
         else if(anchorPoint == 1)
         {
            this.getCornerDownRightWorldViewPos(coor);
         }
         else if(anchorPoint == 2)
         {
            this.getFlatbedUpgradeWorldViewPos(coor);
         }
         else
         {
            coor.x = this.mViewCenterWorldX;
            coor.y = this.mViewCenterWorldY;
         }
      }
      
      public function viewLayersGetScaleXY(layerId:int, coor:DCCoordinate) : void
      {
         var height:int = 0;
         var radius:int = 0;
         var invertIt:* = false;
         var typeId:int;
         switch((typeId = this.viewLayersTypeCurrentGet(layerId)) - 3)
         {
            case 0:
            case 1:
               height = 952;
               radius = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(this.mDef.mSku,1,"turretsExtraRange",this.mDef.getShotDistance());
               coor.x = radius / height;
               coor.y = coor.x;
               break;
            default:
               invertIt = layerId != 7;
               coor.x = this.mIsFlipped && invertIt ? -1 : 1;
               coor.y = 1;
         }
      }
      
      public function viewIsLayerFlipped(layerId:int) : Boolean
      {
         return this.mIsFlipped && (this.viewLayersTypeCurrentGet(layerId) == 31 || layerId == 1 || layerId == 3);
      }
      
      public function viewLayersGetAttribute(layerId:int, attributeSku:String) : Object
      {
         var returnValue:Object = -1;
         switch(attributeSku)
         {
            case "brokenLevel":
               returnValue = this.mDef.shotCanBeATarget() ? this.mData[1] + 1 : 0;
               break;
            case "selectedLayerId":
               returnValue = [];
               if(!this.labourIsWaitingForDroid())
               {
                  returnValue.push(1);
               }
               if(this.mDef.needsGround() && !this.spyGetIsSpiable() && !this.umbrellaGetIsEnabled())
               {
                  returnValue.push(0);
               }
               break;
            default:
               if(this.mViewAttributes != null && this.mViewAttributes[attributeSku] != null)
               {
                  returnValue = this.mViewAttributes[attributeSku];
               }
         }
         return returnValue;
      }
      
      public function viewLayersSetAttribute(value:Object, layerId:int, attributeSku:String) : void
      {
         if(this.mViewAttributes == null)
         {
            this.mViewAttributes = new Dictionary(true);
         }
         this.mViewAttributes[attributeSku] = value;
      }
      
      public function viewLayersGetTimer(layerId:int) : int
      {
         return this.mViewTimerMS;
      }
      
      public function viewLayersSetTimer(layerId:int, valueMS:int) : void
      {
         this.mViewTimerMS = valueMS;
      }
      
      public function viewUsesBaseUnit() : Boolean
      {
         return this.mUnit != null && this.mDef.getAnimationDef() != null && this.canBeBroken();
      }
      
      public function viewGetBase() : *
      {
         return this.mViewLayersAnims[1];
      }
      
      public function viewRequestAnim(layerId:int, animId:int) : void
      {
         if(animId == 23 && this.mDef.requiresDroidToBeDemolished())
         {
            animId = 24;
         }
         this.viewLayersTypeRequiredSet(layerId,animId);
      }
      
      public function viewSetBase(animId:int) : void
      {
         this.viewLayersTypeRequiredSet(1,animId);
      }
      
      public function viewSetOutline(value:int) : void
      {
         this.viewLayersTypeRequiredSet(4,value);
      }
      
      private function viewGetFilterForPersistentSelection(highlight:Boolean, forceUnhighlight:Boolean = false) : int
      {
         var currShipyard:Shipyard = null;
         var wioShipyard:WorldItemObject = null;
         var returnValue:int = -1;
         var shipyardController:ShipyardController;
         if((shipyardController = InstanceMng.getShipyardController()) != null)
         {
            if((currShipyard = shipyardController.getCurrentShipyard()) != null && forceUnhighlight == false)
            {
               wioShipyard = currShipyard.getWorldItemObject();
               returnValue = int(wioShipyard == this ? 40 : -1);
            }
            else
            {
               returnValue = -1;
            }
         }
         return returnValue;
      }
      
      private function viewGetSelectedTypeId() : int
      {
         var selectedTypeId:int = 2;
         if(this.spyGetIsSpiable())
         {
            selectedTypeId = 41;
         }
         else if(this.umbrellaGetIsEnabled())
         {
            selectedTypeId = 44;
         }
         return selectedTypeId;
      }
      
      private function viewIsSelected() : Boolean
      {
         return this.mViewIsSelected;
      }
      
      public function viewSetSelected(value:Boolean, extraBonus:int = 0, showCupola:Boolean = true, forceUnhighlight:Boolean = false) : void
      {
         this.mViewIsSelected = value;
         if(this.umbrellaGetIsEnabled())
         {
            this.umbrellaSetSelected(value);
         }
         else
         {
            this.viewDoSetSelected(value,extraBonus,showCupola,forceUnhighlight);
         }
      }
      
      public function viewDoSetSelected(value:Boolean, extraBonus:int = 0, showCupola:Boolean = true, forceUnhighlight:Boolean = false) : void
      {
         if(this.viewLayersTypeRequiredGet(4) == 26 || this.viewLayersTypeRequiredGet(4) == 45)
         {
            return;
         }
         var newAnimId:int;
         if((newAnimId = value ? this.viewGetSelectedTypeId() : this.viewGetFilterForPersistentSelection(value,forceUnhighlight)) != this.viewLayersTypeRequiredGet(4))
         {
            this.viewLayersTypeRequiredSet(4,newAnimId);
            showCupola &&= InstanceMng.getRole().wioShowCupola(this);
            if(value && showCupola)
            {
               this.viewSetDefenseCupola(value);
            }
            else if(!this.mCupolaForcedVisible)
            {
               this.viewLayersTypeRequiredSet(6,-1);
            }
            if(this.mDef.isAnObservatory() && this.mState.mStateId == 30)
            {
               this.viewLayersTypeRequiredSet(5,value ? 37 : -1);
            }
         }
      }
      
      public function viewSetDefenseCupola(value:Boolean) : void
      {
         if(this.mCupolaForcedVisible && !value)
         {
            return;
         }
         var animTypeId:int = 0;
         if(value && this.mDef.hasCupola())
         {
            animTypeId = this.spyGetIsSpiable() ? 4 : 3;
         }
         else
         {
            animTypeId = -1;
         }
         this.viewLayersTypeRequiredSet(6,animTypeId);
      }
      
      public function setCupolaForcedVisible(value:Boolean) : void
      {
         this.mCupolaForcedVisible = value;
      }
      
      public function viewSetPowerUp(value:Boolean) : void
      {
         var powerupType:String = InstanceMng.getPowerUpMng().unitsGetActivePowerUpTypeByUnitSku(this.mDef.mSku,1);
         var effectType:int = InstanceMng.getPowerUpMng().getEffectTypeFromPowerUpType(powerupType);
         InstanceMng.getUnitScene().effectsSwitch(this.mUnit,effectType,value);
      }
      
      public function viewSetInfluenced(value:Boolean, itemInfluencing:WorldItemObject, extraBonus:int = 0) : void
      {
         if(value)
         {
            this.viewLayersTypeRequiredSet(4,6);
            this.viewLayersTypeRequiredSet(6,itemInfluencing.mDef.mTypeId == 4 || itemInfluencing.mDef.mTypeId == 12 ? 21 : 22);
            if(extraBonus != 0)
            {
               this.viewLayersSetAttribute(extraBonus,6,"extraBonus");
            }
         }
         else
         {
            this.viewLayersTypeRequiredSet(4,-1);
            this.viewLayersTypeRequiredSet(6,-1);
            if(extraBonus != 0)
            {
               this.viewLayersSetAttribute(0,6,"extraBonus");
            }
         }
      }
      
      public function viewSetBaseAtTile(tileX:int, tileY:int, effective:Boolean = false) : void
      {
         var sprite:Sprite = null;
         var layerId:int = 0;
         this.mViewZ = (tileY + this.getBaseRows()) * smMapController.mTilesRows + (tileX + this.getBaseCols()) * 10000;
         this.mViewCoor.x = tileX + this.getBaseCols() / 2;
         this.mViewCoor.y = tileY + this.getBaseRows() / 2;
         InstanceMng.getViewMngPlanet().tileXYToWorldViewPos(this.mViewCoor);
         this.mViewCenterWorldX = this.mViewCoor.x;
         this.mViewCenterWorldY = this.mViewCoor.y;
         if(this.mBoundingBox == null)
         {
            this.mBoundingBox = new DCBoxWithTiles();
            this.mBoundingBox.id = 100 + int(this.mSid);
         }
         this.setBoundingBox(tileX,tileY);
         this.setBoundingBoxZ();
         if(Config.DEBUG_MODE)
         {
            sprite = InstanceMng.getUnitScene().debugGetSprite(this,"debugLabelBBox");
            InstanceMng.getMapViewPlanet().drawPerspectiveRectTiles(sprite.graphics,this.mBoundingBox.mTileX,this.mBoundingBox.mTileY,this.mBoundingBox.mTilesWidth,this.mBoundingBox.mTilesHeight);
         }
         if(effective)
         {
            if(this.mUnit != null)
            {
               this.mUnit.setPositionInViewSpace(this.mViewCenterWorldX,this.mViewCenterWorldY);
            }
            layerId = 0;
            while(layerId < this.viewGetLayersCount())
            {
               smAnimMng.itemCalculatePosition(this,layerId);
               layerId++;
            }
         }
         this.setCosmeticSpinAngle();
      }
      
      public function setBoundingBoxZ() : void
      {
         this.mBoundingBox.mZ = this.mDef.getZOrder() * smMapController.mTilesCount;
      }
      
      private function setBoundingBox(tileX:int, tileY:int) : void
      {
         var width:* = 0;
         var height:* = 0;
         var offX:* = 0;
         var offY:* = 0;
         var temp:* = 0;
         this.getCornerUpLeftWorldViewPos(this.mViewCoor);
         var up:int = this.mViewCoor.y;
         this.getCornerDownLeftWorldViewPos(this.mViewCoor);
         var left:int = this.mViewCoor.x;
         this.getCornerDownRightWorldViewPos(this.mViewCoor);
         var down:int = this.mViewCoor.y;
         this.getCornerUpRightWorldViewPos(this.mViewCoor);
         var right:int = this.mViewCoor.x;
         this.mBoundingBox.setCorners(left,up,right,down);
         var off:Number = this.mDef.getStepablePerimeter() + 0.1;
         this.mBoundingBox.setTileXY(tileX + off,tileY + off);
         off *= 2;
         if(this.mDef.isAHangar())
         {
            width = 4;
            height = 2;
            offX = 3;
            offY = 4;
            if(this.mIsFlipped)
            {
               temp = width;
               width = height;
               height = temp;
               temp = offX;
               offX = offY;
               offY = temp;
            }
            this.mBoundingBox.setTileXY(this.mBoundingBox.mTileX + offX,this.mBoundingBox.mTileY + offY);
            this.mBoundingBox.setTileSize(width,height);
         }
         else
         {
            this.mBoundingBox.setTileSize(this.getBaseCols() - off,this.getBaseRows() - off);
         }
      }
      
      public function viewGetCollisionBoxPackageSku() : String
      {
         return InstanceMng.getCollisionBoxMng().getCollisionBoxSkuForDef(this.mDef);
      }
      
      public function viewAnimStoppingStatePlay(layerId:int, animId:int) : void
      {
         this.mViewAnimStoppingLayerId = layerId;
         this.mViewAnimStoppingAnimId = animId;
         if(this.viewLayersTypeRequiredGet(layerId) != animId)
         {
            this.mViewAnimStoppingAnimToRestoreId = this.viewLayersTypeRequiredGet(layerId);
         }
         this.viewRequestAnim(layerId,animId);
      }
      
      public function viewAnimStoppingStateReset() : void
      {
         if(this.mViewAnimStoppingLayerId > -1)
         {
            this.viewRequestAnim(this.mViewAnimStoppingLayerId,this.mViewAnimStoppingAnimToRestoreId);
         }
         this.mViewAnimStoppingLayerId = -1;
         this.mViewAnimStoppingAnimId = -1;
         this.mViewAnimStoppingAnimToRestoreId = -1;
      }
      
      public function getBoundingBoxCornerUpLeftWorldPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mBoundingBox.mTileX;
         coor.y = this.mBoundingBox.mTileY;
         InstanceMng.getViewMngPlanet().tileXYToWorldPos(coor);
         return coor;
      }
      
      public function getBoundingBoxCornerDownRightWorldPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mBoundingBox.mTileX + this.mBoundingBox.mTilesWidth;
         coor.y = this.mBoundingBox.mTileY + this.mBoundingBox.mTilesHeight;
         InstanceMng.getViewMngPlanet().tileXYToWorldPos(coor);
         return coor;
      }
      
      public function getCornerUpLeftWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mTileRelativeX;
         coor.y = this.mTileRelativeY;
         InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coor);
         return coor;
      }
      
      public function getCornerUpRightWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mTileRelativeX + this.getBaseCols();
         coor.y = this.mTileRelativeY;
         InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coor);
         return coor;
      }
      
      public function getCornerDownLeftWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mTileRelativeX;
         coor.y = this.mTileRelativeY + this.getBaseRows();
         InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coor);
         return coor;
      }
      
      public function getCornerDownRightWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mTileRelativeX + this.getBaseCols();
         coor.y = this.mTileRelativeY + this.getBaseRows();
         InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coor);
         return coor;
      }
      
      public function getFlatbedUpgradeWorldViewPos(coor:DCCoordinate) : DCCoordinate
      {
         coor.x = this.mTileRelativeX + this.getBaseCols();
         coor.y = this.mTileRelativeY;
         InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coor);
         coor.x -= 40;
         coor.y += 10;
         return coor;
      }
      
      public function moveBegin(hasToRemoveFromScene:Boolean = true, forBuffer:Boolean = false) : void
      {
         this.mIsForToolPlace = true;
         if(this.mDef.usesPath())
         {
            this.pathUnregisterNeighbour();
         }
         this.setConnected(false);
         if(hasToRemoveFromScene)
         {
            this.viewSetVisible(true);
         }
         this.viewLayersTypeCurrentSet(6,-1);
         this.viewLayersImpCurrentSet(6,-1);
         this.viewLayersAnimSet(6,null);
         if(hasToRemoveFromScene && this.mUnit != null)
         {
            this.mUnit.removeFromScene();
         }
         if(Config.useUmbrella())
         {
            this.umbrellaSetIsEnabled(false,true);
         }
         if(!forBuffer && this.mState.mStateId == 11 && !this.isFlatBed())
         {
            this.viewLayersTypeRequiredSet(3,-1);
         }
      }
      
      public function moveEnd() : void
      {
         var layerId:int = 0;
         for(layerId = 0; layerId < this.viewGetLayersCount(); )
         {
            this.viewLayersTypeCurrentSet(layerId,-1);
            if(this.viewGetImpId(layerId) != -3)
            {
               this.viewLayersImpCurrentSet(layerId,-1);
            }
            if(this.mDef.isAWall())
            {
               this.viewLayersImpCurrentSet(layerId,0);
            }
            layerId++;
         }
         if(this.mDef.usesPath())
         {
            this.pathRegisterNeighbour();
         }
         this.mIsForToolPlace = false;
         this.mState.begin(this,false);
         if(Config.useUmbrella())
         {
            this.umbrellaSetIsEnabled(InstanceMng.getUmbrellaMng().isUnitProtected(this.mUnit));
         }
         if(this.mDef.isHeadQuarters() && InstanceMng.getMapControllerPlanet().isTileXYInMap(int(this.mBoundingBox.mTileX),int(this.mBoundingBox.mTileY)))
         {
            InstanceMng.getTrafficMng().droidsUpdateWandering();
         }
         InstanceMng.getTargetMng().updateProgress("buildingsMoved",1,this.mDef.mSku);
      }
      
      public function isBeingMoved() : Boolean
      {
         return this.mIsForToolPlace;
      }
      
      public function moveCanBeMoved() : Boolean
      {
         if(this.mDef.isAnObstacle())
         {
            return false;
         }
         if(InstanceMng.getBuildingsBufferController().isBufferOpen())
         {
            return true;
         }
         if(this.mState.moveCanBeMoved() && InstanceMng.getRole().toolMoveCanBeAppliedToItem(this))
         {
            return (this.mServerStateId == 0 || this.mServerStateId == 1 || this.mServerStateId == 2) && this.mState.mStateId != 18 && this.mState.mStateId != 22 && this.mState.mStateId != 1;
         }
         return false;
      }
      
      public function flip(doFlipDo:Boolean = true) : void
      {
         this.mIsFlipped = !this.mIsFlipped;
         var tileX:int = int(smMapController.getTileRelativeXToTile(this.mTileRelativeX));
         var tileY:int = int(smMapController.getTileRelativeYToTile(this.mTileRelativeY));
         this.setBoundingBox(tileX,tileY);
         if(doFlipDo)
         {
            this.flipDO();
         }
      }
      
      private function flipDO() : void
      {
         var NOFLIP_LAYERS:Array = [5,6,7];
         var anim:DCDisplayObject = null;
         var layerId:int = 0;
         var sign:int = -1;
         if(this.mUnit != null && !this.mUnit.mDef.needsFlipWithScale() && !this.isFlatBed() && !this.isUpgrading())
         {
            this.mUnit.flip();
         }
         else
         {
            layerId = 0;
            while(layerId < this.viewGetLayersCount())
            {
               if(NOFLIP_LAYERS.indexOf(layerId) == -1)
               {
                  if((anim = this.viewLayersAnimGet(layerId)) != null)
                  {
                     if(!this.mIsFlipped && this.isUpgrading() && !this.isFlatBed())
                     {
                        sign = 1;
                     }
                     anim.scaleX *= sign;
                  }
               }
               layerId++;
            }
         }
      }
      
      public function dataToString() : String
      {
         return "sid:" + this.mSid + " stateId = " + GameConstants.WIO_SERVER_STATE_ID_TO_STRING[this.mServerStateId] + " modeId = " + this.mServerModeId;
      }
      
      override public function pause() : void
      {
         super.pause();
         DCDebug.trace("WORLD ITEM OBJECT with ID = " + this.mSid + " is now paused. State: " + this.mServerStateId);
      }
      
      override public function resume() : void
      {
         super.resume();
         DCDebug.trace("WORLD ITEM OBJECT with ID = " + this.mSid + " is now resumed. State: " + this.mServerStateId);
      }
      
      public function viewAddUIEvents(layerId:int) : void
      {
      }
      
      public function viewGetAttachedClip(layerId:int) : Vector.<DisplayObjectContainer>
      {
         return null;
      }
      
      public function viewGetLayersCount() : int
      {
         return 8;
      }
      
      public function viewIsAllowedToBeDraw() : Boolean
      {
         return true;
      }
      
      public function viewMustApplyOffset() : Boolean
      {
         return false;
      }
      
      public function viewRemoveUIEvents(layerId:int) : void
      {
      }
      
      public function viewSetWorldX(value:int) : void
      {
         this.mViewCenterWorldX = value;
      }
      
      public function viewSetWorldY(value:int) : void
      {
         this.mViewCenterWorldY = value;
      }
      
      public function viewSetVisible(value:Boolean) : void
      {
         var layerId:int = 0;
         for(layerId = 0; layerId < this.viewGetLayersCount(); )
         {
            if(value)
            {
               smViewMng.worldItemRemoveFromStage(layerId,this,this.viewLayersTypeCurrentGet(layerId));
            }
            else
            {
               this.viewLayersTypeCurrentSet(layerId,-1);
            }
            layerId++;
         }
      }
      
      public function addHistoryEvent(value:String) : void
      {
         if(this.mHistoryEvents == null)
         {
            this.mHistoryEvents = new Vector.<String>(0);
         }
         var command:String = GameConstants.getHistoricalKeyByEventName(value);
         if(command != null && this.mHistoryEvents.length >= 10)
         {
            this.mHistoryEvents.shift();
         }
         if(command != null)
         {
            this.mHistoryEvents.push(command);
         }
      }
      
      public function getCommandStringForServer() : String
      {
         var cmd:String = null;
         var returnValue:String = "";
         if(this.mHistoryEvents != null && this.mHistoryEvents.length != 0)
         {
            for each(cmd in this.mHistoryEvents)
            {
               if(cmd != null)
               {
                  returnValue += cmd + ",";
               }
            }
         }
         return returnValue;
      }
      
      public function highlightAdd() : void
      {
         this.mIsHighlighted = true;
         this.mShouldHighLight = true;
      }
      
      public function highlightGet() : Boolean
      {
         return this.mIsHighlighted && !InstanceMng.getUnitScene().battleIsRunning() && !this.isRepairing();
      }
      
      public function highlightRemove() : void
      {
         this.mIsHighlighted = false;
      }
      
      public function itemOnTopSetIsEnabled(value:Boolean) : void
      {
         var layerId:int = 0;
         if(value != this.mItemOnTopIsEnabled)
         {
            if(value)
            {
               for(layerId = 0; layerId < this.viewGetLayersCount(); )
               {
                  if(layerId != 0)
                  {
                     smViewMng.worldItemRemoveFromStage(layerId,this,this.viewLayersTypeCurrentGet(layerId));
                     this.viewLayersTypeCurrentSet(layerId,-1);
                  }
                  layerId++;
               }
            }
            else if(this.mState != null)
            {
               this.mState.beginView(this);
            }
            setEnabled(!value);
            this.mItemOnTopIsEnabled = value;
         }
      }
      
      public function itemOnTopGetIsEnabled() : Boolean
      {
         return this.mItemOnTopIsEnabled;
      }
      
      public function umbrellaGetIsEnabled() : Boolean
      {
         return this.mUmbrellaIsEnabled.value;
      }
      
      public function umbrellaSetIsEnabled(value:Boolean, apply:Boolean = true) : void
      {
         if(value != this.umbrellaGetIsEnabled())
         {
            if(!value)
            {
               this.absorbImpactEnd();
               this.spyApplyFilter(false);
            }
            this.mUmbrellaIsEnabled.value = value;
         }
         if(value)
         {
            this.umbrellaSetSelected(this.mViewIsSelected);
         }
      }
      
      private function umbrellaSetSelected(value:Boolean) : void
      {
         this.viewDoSetSelected(value);
         this.umbrellaSetFilter();
      }
      
      private function umbrellaSetFilter() : void
      {
         if(this.mViewIsSelected)
         {
            this.spyApplyFilter(true,0.75,11123432);
         }
         else
         {
            this.spyApplyFilter(true,0.4,11123432);
         }
      }
      
      public function absorbImpactStart() : void
      {
         if(this.umbrellaGetIsEnabled())
         {
            this.mAbsorbImpactStarted = true;
            this.mAbsorbImpactIntensity = 0.8;
            this.mAbsorbImpactIncrement = -0.05;
         }
      }
      
      private function absorbImpactEnd() : void
      {
         this.mAbsorbImpactStarted = false;
      }
      
      public function absorbImpactIsOn() : Boolean
      {
         return this.mAbsorbImpactStarted;
      }
      
      public function absorbImpactGetIntensity() : Number
      {
         return this.mAbsorbImpactIntensity;
      }
      
      private function absorbImpactUpdate(dt:int) : void
      {
         if(this.mAbsorbImpactStarted)
         {
            this.mAbsorbImpactIntensity += this.mAbsorbImpactIncrement;
            if(this.mAbsorbImpactIntensity >= 0.8)
            {
               this.mAbsorbImpactIntensity = 0.8;
               this.mAbsorbImpactIncrement = -0.05;
            }
            else if(this.mAbsorbImpactIntensity <= 0.4)
            {
               this.mAbsorbImpactStarted = false;
               this.mAbsorbImpactIntensity = 0.4;
            }
            this.spyApplyFilter(false);
            this.spyApplyFilter(true,this.mAbsorbImpactIntensity,11123432);
         }
      }
      
      private function spySetState(newState:int) : void
      {
         var isSpiable:Boolean = false;
         if(newState == this.mSpyState)
         {
            return;
         }
         if(this.mDef != null && this.mDef.isSpiable())
         {
            this.mSpyState = newState;
            if(this.mDef.isADecoration() || this.mDef.isAnObstacle())
            {
               switch(this.mSpyState - 3)
               {
                  case 0:
                     this.setLayersAlpha(0.4);
                     break;
                  case 1:
                     this.setLayersAlpha(0.2);
                     break;
                  default:
                     this.setLayersAlpha(1);
               }
            }
            else
            {
               isSpiable = this.spyGetIsSpiable();
               switch(this.mSpyState)
               {
                  case 0:
                  case 1:
                     this.spyApplyFilter(false);
                     if(this.umbrellaGetIsEnabled())
                     {
                        this.umbrellaSetSelected(this.mViewIsSelected);
                     }
                     break;
                  case 2:
                     this.spyApplyFilter(true,0.15,16711680);
                     break;
                  case 3:
                     this.spyApplyFilter(true,spyGetFilterAlphaFromType(this.mSpyStateType,true),spyGetFilterColorFromType(this.mSpyStateType,true));
                     this.viewDoSetSelected(false);
                     break;
                  case 4:
                     this.spyApplyFilter(true,spyGetFilterAlphaFromType(this.mSpyStateType,false),spyGetFilterColorFromType(this.mSpyStateType,false));
                     this.viewDoSetSelected(true);
               }
               if(!isSpiable && this.spyGetIsSpiable() && this.mItemOnTopIsEnabled)
               {
                  this.itemOnTopSetIsEnabled(false);
               }
            }
         }
      }
      
      private function spyGetFilterColorFromType(spyType:int, area:Boolean) : uint
      {
         switch(spyType)
         {
            case 0:
               return area ? 65535 : 10092492;
            case 1:
               return 16750848;
            default:
               return 65535;
         }
      }
      
      private function spyGetFilterAlphaFromType(spyType:int, area:Boolean) : Number
      {
         switch(spyType)
         {
            case 0:
               return area ? 0.25 : 0.85;
            case 1:
               return area ? 0.35 : 0.9;
            default:
               return 0.5;
         }
      }
      
      public function spySetIsSpiableSelected(value:Boolean) : void
      {
         if(value)
         {
            if(this.spyGetIsSpiable())
            {
               this.spySetState(4);
            }
         }
         else if(this.mSpyState == 4)
         {
            this.spySetState(3);
         }
      }
      
      public function spySetIsSpiableSelectedArea(value:Boolean) : void
      {
         if(this.mSpyState != 4)
         {
            this.spySetState(value ? 3 : 2);
         }
      }
      
      public function spyGetWouldBeAffected() : Boolean
      {
         return this.mSpyState == 1;
      }
      
      public function spyGetIsSpiable() : Boolean
      {
         return this.mSpyState >= 3 && this.mSpyState <= 4;
      }
      
      public function spySetIsSpiable(value:Boolean) : void
      {
         this.spySetState(value ? 2 : 0);
      }
      
      public function spyGetSpyStateType() : int
      {
         return this.mSpyStateType;
      }
      
      public function spySetSpyStateType(value:int) : void
      {
         this.mSpyStateType = value;
      }
      
      public function spyApplySpyStateType(value:int) : void
      {
         this.spySetSpyStateType(Math.max(this.spyGetSpyStateType(),value));
      }
      
      public function spySetWouldBeAffected(value:Boolean) : void
      {
         this.spySetState(1);
      }
      
      public function getDisplayObjectsForFilter() : Vector.<DCDisplayObject>
      {
         var displayObjects:Vector.<DCDisplayObject> = new Vector.<DCDisplayObject>(0);
         var dispObj:DCDisplayObject = this.viewLayersAnimGet(1);
         if(dispObj != null)
         {
            displayObjects.push(dispObj);
         }
         dispObj = this.viewLayersAnimGet(0);
         if(dispObj != null && this.viewLayersTypeCurrentGet(0) == 33)
         {
            displayObjects.push(dispObj);
         }
         return displayObjects;
      }
      
      public function spyApplyFilter(enabled:Boolean, value:Number = 0, color:uint = 65535) : void
      {
         var dcClip:DCDisplayObject = null;
         for each(dcClip in this.getDisplayObjectsForFilter())
         {
            if(dcClip != null)
            {
               if(enabled)
               {
                  dcClip.setInk(color,value);
               }
               else
               {
                  dcClip.resetFilters();
               }
            }
         }
      }
      
      public function setLayersAlpha(value:Number) : void
      {
         var dsp:DCDisplayObject = null;
         var newValue:* = NaN;
         var layer:int = 0;
         for each(layer in GameConstants.WIO_VIEW_LAYERS_AFFECTED_BY_OBSTRUCTION_ALPHA)
         {
            newValue = value;
            if(layer != 1 && value < 1)
            {
               newValue /= 2;
            }
            dsp = this.viewLayersAnimGet(layer);
            if(dsp != null)
            {
               dsp.getDisplayObjectContent().alpha = newValue;
            }
         }
      }
      
      public function needsToBeHidden(checkIfCouldBeVisible:Boolean = false) : Boolean
      {
         var roleId:int = 0;
         var returnValue:* = false;
         if(this.mDef.isAMine() || this.mDef.isHappeningOnly())
         {
            roleId = InstanceMng.getRole().mId;
            returnValue = roleId == 1 || roleId == 3 || roleId == 2 && !this.spyGetIsSpiable();
            if(checkIfCouldBeVisible && !returnValue)
            {
               returnValue = roleId == 2;
            }
         }
         return returnValue;
      }
      
      public function battleStart() : void
      {
         this.mRepairIsActive = false;
      }
      
      public function battleFinish() : void
      {
      }
      
      public function decorationGetMode() : int
      {
         return this.mDecorationMode;
      }
      
      public function decorationSetRiding() : void
      {
         var mode:int = 1;
         if(this.mDef.belongsToGroup("teleport"))
         {
            mode = 2;
         }
         this.decorationSetMode(mode);
      }
      
      public function decorationIsDismountingAnimOver() : Boolean
      {
         return this.mDecorationMode == 0;
      }
      
      public function decorationSetDismounting() : void
      {
         var mode:int = 0;
         if(this.mDef.belongsToGroup("teleport"))
         {
            mode = 4;
         }
         this.decorationSetMode(mode);
      }
      
      private function decorationSetMode(value:int) : void
      {
         this.mDecorationMode = value;
      }
      
      public function decorationIsBeingRidden() : Boolean
      {
         return this.mDecorationMode > 0;
      }
      
      public function decorationCanBeDismounted() : Boolean
      {
         return this.isActive() && !this.getIsForToolPlace();
      }
   }
}
