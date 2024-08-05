package com.dchoc.game.controller.hangar
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.gameunit.GameUnitMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.DCMath;
   import esparragon.utils.EUtils;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class Bunker extends Hangar
   {
      
      private static const SCENE_UNIT_TYPES_ATTACKER:Array = GameConstants.SCENE_UNIT_TYPES_ATTACKER;
      
      private static const DOORS_STATE_NONE:int = -1;
      
      private static const DOORS_STATE_CLOSED:int = 0;
      
      private static const DOORS_STATE_OPENING:int = 1;
      
      private static const DOORS_STATE_OPEN:int = 2;
      
      private static const DOORS_STATE_CLOSING:int = 3;
      
      private static const DOORS_STATE_COUNT:int = 4;
      
      private static const DOORS_STATE_OPENING_TIME_MAX:int = 3000;
       
      
      private var mBattleUnitsSensed:Vector.<MyUnit>;
      
      private var mUnitsOutside:Vector.<MyUnit>;
      
      private var mStoredUnitEnergies:Dictionary;
      
      private var mPosition:Vector3D;
      
      private var mBattleReturningUnits:Boolean;
      
      private var mDoorsNeedHighlight:Boolean;
      
      private var mDoorsState:int;
      
      private var mDoorsTimer:int;
      
      private var mDoorsStatePending:int = -1;
      
      private var mWasAbleToPlayAnims:Boolean;
      
      public function Bunker(id:String, capacity:int, item:WorldItemObject = null)
      {
         super(id,capacity,item);
         this.mStoredUnitEnergies = new Dictionary();
         this.doorsChangeState(0);
      }
      
      override public function unload() : void
      {
         this.mBattleUnitsSensed = null;
         this.mUnitsOutside = null;
      }
      
      public function isWIOAlive() : Boolean
      {
         return mWorldItemObjectRef != null && mWorldItemObjectRef.mUnit != null && mWorldItemObjectRef.mUnit.mIsAlive;
      }
      
      override public function store(sku:String, spaceAmount:int, inside:Boolean = false, doEvent:Boolean = true) : void
      {
         inside = true;
         mCapacityOccupied += spaceAmount;
         mUnitIds.push(sku);
         mUnitSizes.push(spaceAmount);
         mUnitStoredInside.push(inside);
         mCurrentUnitPointer++;
      }
      
      override public function persistenceGetData() : XML
      {
         var i:int = 0;
         var bunkerStr:* = null;
         var persistence:XML = EUtils.stringToXML("<Bunker sid=\"" + mId + "\"/>");
         for(i = 0; i < mCurrentUnitPointer; )
         {
            bunkerStr = "<Unit sku=\"" + mUnitIds[i] + "\"/>";
            persistence.appendChild(EUtils.stringToXML(bunkerStr));
            i++;
         }
         return persistence;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var storedEnergies:* = undefined;
         var energyIndex:int = 0;
         var u:MyUnit = null;
         var c:UnitComponentGoal = null;
         var i:int = 0;
         var unitsInsideCount:int = 0;
         var unitScene:UnitScene = MyUnit.smUnitScene;
         var relaunchUnits:Boolean = false;
         var isWorking:* = !mWorldItemObjectRef.isBroken();
         this.doorsLogicUpdate(dt);
         if(unitScene.battleIsRunning() || Config.DEBUG_MODE)
         {
            if(this.mBattleUnitsSensed == null)
            {
               this.mBattleUnitsSensed = new Vector.<MyUnit>(0);
               if(mWorldItemObjectRef.mUnit != null)
               {
                  this.mPosition = mWorldItemObjectRef.mUnit.mPosition;
               }
            }
            if(this.mUnitsOutside == null)
            {
               this.mUnitsOutside = new Vector.<MyUnit>(0);
            }
            if(isWorking || this.mUnitsOutside.length > 0)
            {
               this.battleSenseEnvironment(unitScene);
               if(this.mBattleUnitsSensed.length > 0)
               {
                  if((unitsInsideCount = int(mUnitIds.length)) > 0 && isWorking)
                  {
                     if(this.mDoorsState == 0)
                     {
                        this.doorsChangeState(1);
                     }
                     else if(this.mDoorsState == 2)
                     {
                        this.battleLaunchUnits(unitScene);
                     }
                  }
                  else if(this.mBattleReturningUnits)
                  {
                     this.mBattleReturningUnits = false;
                     relaunchUnits = true;
                  }
               }
               else if(!this.mBattleReturningUnits && this.mUnitsOutside != null && this.mUnitsOutside.length > 0)
               {
                  this.battleReturnUnits(false);
               }
            }
         }
         var unitsOutsideCount:int = int(this.mUnitsOutside == null ? 0 : int(this.mUnitsOutside.length));
         for(i = 0; i < unitsOutsideCount; )
         {
            if((u = this.mUnitsOutside[i]).mSecureIsInScene.value)
            {
               if(!u.mIsAlive)
               {
                  this.mUnitsOutside.splice(i,1);
                  unitsOutsideCount--;
                  if((storedEnergies = this.mStoredUnitEnergies[u.mDef.mSku]) != null && storedEnergies.length > 0)
                  {
                     for(energyIndex = 0; energyIndex < storedEnergies.length; )
                     {
                        if(storedEnergies[energyIndex] == u.getInitEnergyFromBunker())
                        {
                           storedEnergies.splice(energyIndex,1);
                           break;
                        }
                        energyIndex++;
                     }
                  }
               }
               else
               {
                  if(this.mBattleUnitsSensed != null && this.mBattleUnitsSensed.length > 0)
                  {
                     if(relaunchUnits)
                     {
                        if((c = u.getGoalComponent()) != null)
                        {
                           c.notify({"cmd":"unitEventDefendBunker"});
                        }
                     }
                  }
                  unitScene.senseEnvironmentBunker(u,this.mBattleUnitsSensed);
                  i++;
               }
            }
            else
            {
               i++;
            }
         }
         if(isWorking && this.mDoorsState == 2 && this.mUnitsOutside != null && this.mUnitsOutside.length == 0)
         {
            this.doorsChangeState(3);
         }
         if(this.mDoorsState == 0 || this.mDoorsState == -1)
         {
            this.mDoorsNeedHighlight = mWorldItemObjectRef.highlightGet();
         }
      }
      
      private function battleSenseEnvironment(unitScene:UnitScene) : void
      {
         if(this.mPosition == null)
         {
            return;
         }
         var u:MyUnit = null;
         var typeId:int = 0;
         var list:Vector.<MyUnit> = null;
         var distanceSqr:Number = NaN;
         var shotDistanceSqr:Number = NaN;
         if(mWorldItemObjectRef != null && (this.isWIOAlive() || this.mUnitsOutside.length > 0))
         {
            this.mBattleUnitsSensed.length = 0;
            shotDistanceSqr = mWorldItemObjectRef.mDef.getShotDistanceSqr();
            for each(typeId in SCENE_UNIT_TYPES_ATTACKER)
            {
               list = unitScene.mSceneUnits[typeId];
               for each(u in list)
               {
                  if(u.mIsAlive)
                  {
                     distanceSqr = DCMath.distanceSqr(u.mPosition,this.mPosition);
                     if(distanceSqr <= shotDistanceSqr)
                     {
                        this.mBattleUnitsSensed.push(u);
                     }
                  }
               }
            }
         }
         else
         {
            this.mPosition = null;
         }
      }
      
      private function battleLaunchUnits(unitScene:UnitScene) : void
      {
         var storedEnergies:* = undefined;
         var energy:int = 0;
         var u:MyUnit = null;
         var units:Vector.<MyUnit> = null;
         var sku:String = null;
         var waveString:String = null;
         var gameUnitMng:GameUnitMng = InstanceMng.getGameUnitMngController().getGameUnitMng();
         for each(sku in mUnitIds)
         {
            this.removeUnit(sku,false,-1,false);
            waveString = unitScene.wavesGetStringFromAttack(1,sku,gameUnitMng.getCurrentUpgradeIdBySku(sku),mWorldItemObjectRef.mSid);
            units = unitScene.wavesCreateAttackWave(waveString,mWorldItemObjectRef.mViewCenterWorldX,mWorldItemObjectRef.mViewCenterWorldY,1,4);
            for each(u in units)
            {
               u.mData[34] = this;
               this.mUnitsOutside.push(u);
               if((storedEnergies = this.mStoredUnitEnergies[u.mDef.mSku]) != null && storedEnergies.length > 0)
               {
                  energy = storedEnergies.shift();
                  u.setEnergy(energy);
                  u.setInitEnergyFromBunker(energy);
                  u.liveBarSetVisible(true,true);
               }
            }
         }
      }
      
      public function battleReturnUnits(storeForced:Boolean) : void
      {
         var u:MyUnit = null;
         var c:UnitComponentGoal = null;
         var i:int = 0;
         var unitsOutsideCount:int = int(this.mUnitsOutside.length);
         if(storeForced && this.mBattleUnitsSensed != null)
         {
            this.mBattleUnitsSensed.length = 0;
         }
         i = 0;
         while(i < unitsOutsideCount)
         {
            u = this.mUnitsOutside[i];
            if(u.mWasAddToScene && !u.mIsAlive)
            {
               u.markToBeReleasedFromScene();
               this.mUnitsOutside.splice(i,1);
               unitsOutsideCount--;
            }
            else if(storeForced)
            {
               if(this.battleUnitHasReturned(u,true))
               {
                  unitsOutsideCount--;
               }
               else
               {
                  i++;
               }
            }
            else
            {
               c = u.getGoalComponent();
               if(c != null)
               {
                  c.notify({
                     "cmd":"unitEventReturnToBunker",
                     "bunker":this
                  });
               }
               i++;
            }
         }
         this.mBattleReturningUnits = true;
      }
      
      public function battleUnitHasReturned(u:MyUnit, checkWIOIsAlive:Boolean = false) : Boolean
      {
         var sku:String = null;
         var pos:int = 0;
         var doStore:Boolean = false;
         var def:ShipDef = null;
         var returnValue:Boolean = false;
         if(this.mUnitsOutside != null)
         {
            if((pos = this.mUnitsOutside.indexOf(u)) > -1)
            {
               this.mUnitsOutside.splice(pos,1);
               doStore = true;
               if(checkWIOIsAlive)
               {
                  doStore = this.isWIOAlive();
               }
               if(doStore)
               {
                  def = ShipDef(u.mDef);
                  this.store(def.mSku,def.getSize());
                  sku = u.mDef.mSku;
                  if(this.mStoredUnitEnergies[sku] == null)
                  {
                     this.mStoredUnitEnergies[sku] = new <int>[u.getEnergy()];
                  }
                  else
                  {
                     this.mStoredUnitEnergies[sku].push(u.getEnergy());
                  }
               }
               returnValue = true;
               u.exitSceneStart(1);
            }
         }
         else
         {
            u.exitSceneStart(1);
         }
         return returnValue;
      }
      
      override public function battleRestoreUnitsAfterBattle() : void
      {
         this.battleReturnUnits(true);
      }
      
      private function doorsChangeState(state:int) : void
      {
         if(this.mDoorsStatePending == -1)
         {
            if(this.doorsCanPlayAnims())
            {
               this.mDoorsState = state;
               switch(this.mDoorsState - 1)
               {
                  case 0:
                     mWorldItemObjectRef.viewLayersTypeRequiredSet(1,34);
                     this.mDoorsTimer = 3000;
                     break;
                  case 2:
                     mWorldItemObjectRef.viewLayersTypeRequiredSet(1,35);
                     this.mDoorsTimer = 3000;
               }
            }
            else
            {
               this.mDoorsStatePending = state;
            }
         }
         else
         {
            this.mDoorsStatePending = state;
         }
      }
      
      private function doorsCanPlayAnims() : Boolean
      {
         var wio:WorldItemObject = getWIO();
         return wio != null && !wio.isBeingMoved() && !wio.isFlatBed() && (InstanceMng.getUnitScene().actualBattleIsRunning() || !wio.isUpgrading());
      }
      
      private function doorsLogicUpdate(dt:int) : void
      {
         var d:DCDisplayObject = null;
         var needsToChangeState:* = false;
         var state:int = 0;
         if(this.mWasAbleToPlayAnims && !this.doorsCanPlayAnims())
         {
            this.mDoorsStatePending = this.mDoorsState;
         }
         this.mWasAbleToPlayAnims = this.doorsCanPlayAnims();
         if(this.mDoorsStatePending == -1)
         {
            switch(this.mDoorsState - 1)
            {
               case 0:
               case 2:
                  this.mDoorsTimer -= dt;
                  d = mWorldItemObjectRef.mViewLayersAnims[1];
                  needsToChangeState = this.mDoorsTimer <= 0;
                  if(!needsToChangeState)
                  {
                     if(d != null && mWorldItemObjectRef.viewLayersTypeRequiredGet(1) == mWorldItemObjectRef.viewLayersTypeCurrentGet(1))
                     {
                        if(d.currentFrame == d.totalFrames)
                        {
                           needsToChangeState = true;
                        }
                     }
                  }
                  if(needsToChangeState)
                  {
                     if(d != null)
                     {
                        d.gotoAndStop(d.totalFrames);
                     }
                     this.doorsChangeState((this.mDoorsState + 1) % 4);
                  }
                  break;
               case 1:
                  d = mWorldItemObjectRef.mViewLayersAnims[1];
                  d.gotoAndStop(d.totalFrames);
            }
         }
         else if(this.doorsCanPlayAnims())
         {
            state = this.mDoorsStatePending;
            switch(this.mDoorsStatePending)
            {
               case 0:
                  if(mWorldItemObjectRef.highlightGet())
                  {
                     mWorldItemObjectRef.viewLayersTypeRequiredSet(1,36);
                  }
                  else
                  {
                     mWorldItemObjectRef.viewLayersTypeRequiredSet(1,1);
                  }
                  if(this.mDoorsState == 2)
                  {
                     state = -1;
                  }
                  break;
               case 1:
                  if(this.mDoorsState == 2)
                  {
                     state = -1;
                  }
                  break;
               case 3:
                  if(this.mDoorsState == 0)
                  {
                     state = -1;
                  }
            }
            d = mWorldItemObjectRef.mViewLayersAnims[1];
            if(d.isAnimationOver() || d.currentFrame == 0)
            {
               this.mDoorsStatePending = -1;
            }
            if(state != -1)
            {
               this.doorsChangeState(state);
            }
         }
      }
      
      public function removeConcreteUnit(u:MyUnit) : void
      {
         if(this.mUnitsOutside == null)
         {
            return;
         }
         var pos:int = this.mUnitsOutside.indexOf(u);
         if(pos > -1)
         {
            if(!u.mSecureIsAboutToExitScene.value)
            {
               u.exitSceneStart(1);
            }
            this.mUnitsOutside.splice(pos,1);
         }
      }
      
      override public function removeUnit(unitSku:String, fromView:Boolean = true, location:int = -1, deleteFromOutside:Boolean = true) : Boolean
      {
         var diff:int = 0;
         var i:int = 0;
         var u:MyUnit = null;
         var returnValue:Boolean = super.removeUnit(unitSku,fromView,location);
         if(this.mUnitsOutside != null && deleteFromOutside)
         {
            if((diff = this.mUnitsOutside.length - mUnitIds.length) > 0)
            {
               for(i = 0; i < diff; )
               {
                  (u = this.mUnitsOutside[0]).exitSceneStart(1);
                  this.mUnitsOutside.splice(0,1);
                  i++;
               }
            }
         }
         return returnValue;
      }
      
      public function waitForUnit(u:MyUnit) : void
      {
         if(this.mUnitsOutside == null)
         {
            this.mUnitsOutside = new Vector.<MyUnit>(0);
         }
         this.mUnitsOutside.push(u);
         if(this.mDoorsState != 1 && this.mDoorsState != 2)
         {
            this.doorsChangeState(1);
         }
      }
      
      override public function receiveUnit(u:MyUnit) : void
      {
         var pos:int = 0;
         if(this.mUnitsOutside != null)
         {
            pos = this.mUnitsOutside.indexOf(u);
            if(pos > -1)
            {
               this.mUnitsOutside.splice(pos,1);
            }
         }
      }
      
      public function getUnitsScoreAttack() : Number
      {
         var sku:String = null;
         var shipDef:ShipDef = null;
         var result:Number = 0;
         for each(sku in mUnitIds)
         {
            shipDef = ShipDef(InstanceMng.getShipDefMng().getDefBySku(sku));
            result += shipDef.getScoreAttack();
         }
         return result;
      }
      
      public function getUnitsContent() : Object
      {
         var sku:String = null;
         var result:Object = {};
         for each(sku in mUnitIds)
         {
            if(result[sku] == null)
            {
               result[sku] = 1;
            }
            else
            {
               result[sku]++;
            }
         }
         return result;
      }
      
      public function getPosition() : Vector3D
      {
         return this.mPosition;
      }
      
      public function getClosestAttacker() : MyUnit
      {
         var returnValue:* = null;
         var distance:Number = NaN;
         var distanceMin:* = 1.7976931348623157e+308;
         var u:MyUnit = null;
         for each(u in this.mBattleUnitsSensed)
         {
            if(u.getIsAlive())
            {
               distance = DCMath.distanceSqr(this.mPosition,u.mPosition);
               if(distance < distanceMin && distance < this.getWIO().mDef.getShotDistanceSqr())
               {
                  distanceMin = distance;
                  returnValue = u;
               }
            }
         }
         return returnValue;
      }
   }
}
