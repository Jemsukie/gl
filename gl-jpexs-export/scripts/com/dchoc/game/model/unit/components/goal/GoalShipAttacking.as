package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.shot.ShotLaser;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class GoalShipAttacking extends GoalShip
   {
      
      private static const STATE_ASK_FOR_BATTLE_START:int = 20;
      
      private static const STATE_BATTLE_START:int = 21;
      
      private static const STATE_BATTLE_ATTACK:int = 22;
      
      private static const STATE_BATTLE_SHOOTING:int = 23;
      
      private static const STATE_BATTLE_RETREAT:int = 24;
      
      private static const STATE_BATTLE_RELOAD:int = 25;
      
      private static const STATE_BATTLE_SHOOTING_ZEPPELIN:int = 26;
      
      private static const STATE_BATTLE_SHOOTING_BURST:int = 27;
      
      private static const STATE_BATTLE_RETREATING_AFTER_WINNING:int = 28;
      
      private static const STATE_BATTLE_SHOOTING_QUIET:int = 29;
       
      
      private var mReloadTimer:int;
      
      private var mShotCounter:int;
      
      private var mShotTimer:int;
      
      private var mIsShooting:Boolean = false;
      
      private var mBunker:Bunker;
      
      public function GoalShipAttacking(unit:MyUnit)
      {
         super(unit);
         this.resetMovement(unit);
      }
      
      private function resetMovement(unit:MyUnit) : void
      {
         var mov:UnitComponentMovement = unit.getMovementComponent();
         mov.setMaxSpeed(unit.mDef.getMaxSpeed());
         mov.setMaxForce(unit.mDef.getMaxForce());
      }
      
      override public function activate() : void
      {
         super.activate();
         changeState(20);
      }
      
      override protected function exitState(state:int) : void
      {
         switch(state - 29)
         {
            case 0:
               mUnit.movementResume();
         }
      }
      
      override protected function logicUpdateDoDoDo(dt:int, u:MyUnit) : void
      {
         var endVolley:Boolean = false;
         var atShot:* = false;
         var enemyVector:Vector3D = null;
         var angle:Number = NaN;
         var isAlive:Boolean = false;
         var battlePos:Vector3D = null;
         var pos:Vector3D = null;
         var looksForATarget:Boolean = false;
         var posTarget:Vector3D = null;
         var inBunkerRange:Boolean = false;
         var returnToBunker:Boolean = false;
         mUnit = u;
         var data:Array = u.mData;
         var def:UnitDef = u.mDef;
         var mov:UnitComponentMovement;
         var behaviours:Dictionary = (mov = u.getMovementComponent()).mBehaviourWeights;
         var unitNearest:MyUnit;
         var unitNearestIsEnemy:Boolean = (unitNearest = data[1]) != null && unitNearest.mFaction != u.mFaction;
         var unitNearestDistanceSqr:Number = Number(data[2]);
         var unitShotableNearest:MyUnit = data[3];
         var bunker:Bunker;
         if((bunker = data[34]) != null)
         {
            if(!(inBunkerRange = unitShotableNearest == null ? false : DCMath.distanceSqr(bunker.getPosition(),unitShotableNearest.mPosition) <= bunker.getWIO().mDef.getShotDistanceSqr()))
            {
               unitShotableNearest = bunker.getClosestAttacker();
            }
            if(unitShotableNearest == null)
            {
               returnToBunker = true;
            }
            if(returnToBunker)
            {
               this.notify({
                  "cmd":"unitEventReturnToBunker",
                  "bunker":bunker
               });
            }
         }
         switch(mCurrentState)
         {
            case 20:
               if((battlePos = MyUnit.smUnitScene.sceneGetBattlePos()) != null)
               {
                  u.movementWanderToPosition(battlePos);
                  changeState(21);
               }
               break;
            case 21:
               if(unitShotableNearest != null)
               {
                  u.setUnitTarget(unitShotableNearest);
                  if(data[4] < def.getShotDistanceSqr())
                  {
                     changeState(22);
                  }
               }
               looksForATarget = true;
               if(data[13] != null)
               {
                  pos = MyUnit(data[13]).mPosition;
               }
               else if(unitShotableNearest == null)
               {
                  data[31] *= 2;
               }
               if(pos != null)
               {
                  mov.setTarget(pos);
                  behaviours[1] = 2;
                  behaviours[8] = 0.5;
               }
               break;
            case -69:
               posTarget = MyUnit(data[13]).mPosition;
               mov.setTarget(posTarget);
               behaviours[1] = 2;
               behaviours[8] = 0.5;
               if(unitShotableNearest.mId == MyUnit(data[13]).mId)
               {
                  changeState(22);
               }
               break;
            case 22:
               behaviours[8] = 0.6;
               if(unitShotableNearest == null)
               {
                  behaviours[1] = 1;
                  changeState(21);
               }
               else
               {
                  if(unitShotableNearest.getMovementComponent() != null)
                  {
                     mov.setTargetUnitMobile(unitShotableNearest);
                     behaviours[3] = 1.5;
                  }
                  else
                  {
                     mov.setTarget(unitShotableNearest.mPosition);
                     behaviours[1] = 1.5;
                  }
                  behaviours[8] = 0;
                  if(atShot = Math.min(DCMath.distanceSqr(unitShotableNearest.mPosition,mUnit.mPosition),data[4]) < def.getShotDistanceSqr())
                  {
                     enemyVector = new Vector3D(unitShotableNearest.mPosition.x - u.mPosition.x,unitShotableNearest.mPosition.y - u.mPosition.y,mov.mVelocity.z);
                     angle = Vector3D.angleBetween(mov.mVelocity,enemyVector);
                     angle = Math.abs(angle);
                     this.laserShipReposition(u);
                     if(angle <= 3.141592653589793 / def.getShotAngleDiv())
                     {
                        if(u.getShotComponent().isShotAllowed(u))
                        {
                           this.changeAttackStateToSpecificAttackType(unitShotableNearest);
                        }
                     }
                  }
               }
               break;
            case 27:
               endVolley = false;
               behaviours[2] = 1.5;
               behaviours[8] = 0;
               if(unitShotableNearest != null && unitShotableNearest.getIsAlive())
               {
                  enemyVector = new Vector3D(unitShotableNearest.mPosition.x - u.mPosition.x,unitShotableNearest.mPosition.y - u.mPosition.y,mov.mVelocity.z);
                  angle = Vector3D.angleBetween(mov.mVelocity,enemyVector);
                  atShot = (angle = Math.abs(angle)) <= 3.141592653589793 / def.getShotAngleDiv();
                  if(this.mShotCounter < mUnit.mDef.getShotBurstLength() && atShot)
                  {
                     this.mShotTimer += dt;
                     if(this.mShotTimer >= 100)
                     {
                        if(atShot = DCMath.distanceSqr(unitShotableNearest.mPosition,mUnit.mPosition) < def.getShotDistanceSqr())
                        {
                           mUnit.getShotComponent().doShoot(mUnit,unitShotableNearest);
                           this.mShotCounter++;
                           this.mShotTimer = 0;
                        }
                     }
                  }
                  else
                  {
                     endVolley = true;
                  }
               }
               else
               {
                  endVolley = true;
               }
               if(endVolley)
               {
                  changeState(25);
                  this.laserShipReposition(u);
               }
               break;
            case 23:
               behaviours[2] = 1.5;
               behaviours[8] = 0.9;
               this.laserShipReposition(u);
               if(unitNearest != null && unitNearest.mIsAlive && !this.mIsShooting)
               {
                  mUnit.getShotComponent().doShoot(mUnit,unitShotableNearest);
                  changeState(25);
               }
               else if(this.mIsShooting)
               {
                  if(ShotLaser(u.getShotComponent()).mState == 0)
                  {
                     this.mIsShooting = false;
                     u.getViewComponent().setAnimationId("running",-1,true,true,true,true);
                     changeState(25);
                  }
               }
               break;
            case 26:
               isAlive = unitShotableNearest != null && unitShotableNearest.getIsAlive();
               atShot = data[4] < def.getShotDistanceSqr();
               if(isAlive && atShot)
               {
                  this.mReloadTimer -= dt;
                  if(this.mReloadTimer <= 0)
                  {
                     mUnit.getShotComponent().doShoot(mUnit,unitShotableNearest);
                     this.mReloadTimer = u.mDef.getShotWaitingTime();
                  }
               }
               else
               {
                  changeState(25);
               }
               break;
            case 29:
               isAlive = unitShotableNearest != null && unitShotableNearest.getIsAlive();
               atShot = data[4] < def.getShotDistanceSqr();
               if(isAlive && atShot)
               {
                  mUnit.shotShoot(unitShotableNearest);
               }
               else
               {
                  changeState(25);
               }
               break;
            case 24:
               if(unitNearestIsEnemy)
               {
                  mov.setTarget(unitNearest.mPosition);
                  behaviours[2] = 1.6;
                  behaviours[8] = 0.4;
                  if(unitNearestDistanceSqr > data[31] * data[31])
                  {
                     changeState(21);
                  }
               }
               break;
            case 25:
               this.mReloadTimer -= dt;
               mov.resetBehaviours();
               if(unitShotableNearest != null)
               {
                  behaviours[2] = 1.5;
                  behaviours[8] = 0.5;
               }
               if(this.mReloadTimer <= 0)
               {
                  if(unitShotableNearest != null)
                  {
                     changeState(22);
                  }
                  else
                  {
                     changeState(21);
                  }
               }
         }
      }
      
      private function changeAttackStateToSpecificAttackType(unitShotableNearest:MyUnit) : void
      {
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         var behaviours:Dictionary = mov.mBehaviourWeights;
         if(mUnit.mDef.getAssetId() == "zeppelin" || mUnit.mDef.getAssetId() == "ovni")
         {
            changeState(26);
            behaviours[2] = 0;
            behaviours[8] = 0;
            behaviours[1] = 0;
            mov.mVelocity.x = 0;
            mov.mVelocity.y = 0;
         }
         else if(mUnit.mDef.belongsToGroup("shotQuiet"))
         {
            changeState(29);
            mUnit.movementStop();
         }
         else if(mUnit.mDef.getAmmoSku() == "b_burst_001")
         {
            changeState(27);
            mUnit.getViewComponent().setAnimationId("shooting",-1,true,true,true,true);
            this.mShotCounter = 0;
            this.mShotTimer = 0;
         }
         else
         {
            changeState(23);
            if(mUnit.mDef.getAmmoSku() == "b_laser_001")
            {
               mUnit.getShotComponent().doShoot(mUnit,unitShotableNearest);
               mUnit.getViewComponent().setAnimationId("shooting",-1,true,true,true,true);
               this.mIsShooting = true;
            }
         }
      }
      
      override protected function enterState(newState:int) : void
      {
         super.enterState(newState);
         switch(newState - 25)
         {
            case 0:
               if(mUnit.mDef.getAssetId() != "ovni")
               {
                  mUnit.getViewComponent().setAnimationId("running",-1,true,true,true,true);
               }
               this.mReloadTimer = mUnit.mDef.getShotWaitingTime();
               break;
            case 3:
               mUnit.getMovementComponent().wander(0.5);
               mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed() * 0.6);
               mUnit.getViewComponent().setAnimationId("running",-1,true,true,true,true);
         }
      }
      
      override protected function avoidCollisionExit(u:MyUnit) : void
      {
         changeState(21);
      }
      
      protected function laserShipReposition(u:MyUnit) : void
      {
         if(u.mDef.getAmmoSku() != "b_laser_001")
         {
            return;
         }
         var mov:UnitComponentMovement = u.getMovementComponent();
         var behaviours:Dictionary = mov.mBehaviourWeights;
         behaviours[8] = 0;
         if(u.mData[4] < 3 * u.mDef.getShotDistanceSqr() / 4)
         {
            behaviours[2] = 0;
            behaviours[1] = 0.1;
            mov.mVelocity.scaleBy(0.3);
         }
         else
         {
            behaviours[2] = 0;
            behaviours[1] = 0.1;
            mov.mVelocity.scaleBy(0.9);
         }
      }
      
      override public function notify(e:Object) : void
      {
         super.notify(e);
         switch(e.cmd)
         {
            case "unitEventReturnToBunker":
               changeState(21);
               this.mBunker = e.bunker;
               if(this.mBunker != null)
               {
                  mUnit.setUnitTarget(null);
                  mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed());
                  InstanceMng.getUnitScene().shipsSendFromItemToItem(mUnit,null,this.mBunker.getWIO(),"unitEventHasArrived",true);
                  mUnit.goalSetForCurrentId("unitGoalForReturnToBunker");
               }
               break;
            case "unitEventHasArrived":
               if(!(this.mBunker == null || this.mCurrentState == 22))
               {
                  InstanceMng.getBunkerController().unitGettingBunker(mUnit,this.mBunker);
                  break;
               }
         }
      }
   }
}
