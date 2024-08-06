package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.geom.Vector3D;
   
   public class GoalHealerInBattle extends UnitComponentGoal
   {
      
      private static const STATE_BATTLE_SEEK_TARGET:int = 21;
      
      private static const STATE_BATTLE_GET_CLOSER:int = 22;
      
      private static const STATE_BATTLE_HEALING:int = 23;
      
      private static const RETARGET_COOLDOWN_MS:int = 500;
      
      private static const HEALING_TIME_MS:int = 1000;
       
      
      private var mTarget:MyUnit;
      
      private var mAttacking:Boolean;
      
      private var mRetargetCooldown:int;
      
      private var mHealingTime:int;
      
      public function GoalHealerInBattle(unit:MyUnit, attacking:Boolean)
      {
         super(unit);
         this.resetMovement(unit);
         this.mTarget = null;
         this.mAttacking = attacking;
         this.resetRetargetCooldown();
         this.resetHealingTime();
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
         changeState(21);
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         super.logicUpdateDoDo(dt,u);
         switch(mCurrentState - 21)
         {
            case 0:
               if(!u.getViewComponent().isPlayingAnimId("still"))
               {
                  u.getViewComponent().setAnimationId("still",-1,true,true,true,true);
               }
               this.findTarget(dt,u);
               this.moveCloserToTarget(dt,u);
               this.resetRetargetCooldown();
               this.resetHealingTime();
               break;
            case 1:
               this.getCloser(dt,u);
               this.resetHealingTime();
               break;
            case 2:
               if(this.mHealingTime == 0)
               {
                  if(u.mDef.getSku().indexOf("warSmallShips_001_005") == -1)
                  {
                     u.getViewComponent().setAnimationId("shooting",-1,true,true,true,true);
                  }
               }
               if(this.mHealingTime > 1000)
               {
                  u.getViewComponent().setAnimationId("still",-1,true,true,true,true);
                  this.changeState(21);
               }
               this.mHealingTime += dt;
         }
         separateUnitsFromEachOther(false);
      }
      
      private function getCloser(dt:int, u:MyUnit) : void
      {
         if(this.targetStillValid())
         {
            this.moveCloserToTarget(dt,u);
            this.checkRetarget(dt,u);
         }
         else
         {
            changeState(21);
         }
      }
      
      private function checkRetarget(dt:int, u:MyUnit) : void
      {
         this.mRetargetCooldown -= dt;
         var retarget:* = this.mRetargetCooldown <= 0;
         if(retarget)
         {
            this.resetRetargetCooldown();
         }
         if(retarget)
         {
            changeState(21);
         }
      }
      
      private function resetRetargetCooldown() : void
      {
         this.mRetargetCooldown = 500;
      }
      
      private function resetHealingTime() : void
      {
         this.mHealingTime = 0;
      }
      
      private function moveCloserToTarget(dt:int, u:MyUnit) : void
      {
         var dist:Number = NaN;
         var mov:UnitComponentMovement = null;
         if(this.mTarget != null)
         {
            dist = DCMath.distanceSqr(u.mPosition,this.mTarget.mPosition);
            u.spinSetTargetAngle(this.getAngle(u,this.mTarget));
            if(dist > u.mDef.getShotDistanceSqr())
            {
               mov = u.getMovementComponent();
               u.setUnitTarget(this.mTarget);
               mov.setTarget(this.mTarget.mPosition);
               mov.goToPosition(this.mTarget.mPosition);
               this.moveOut(u);
            }
            else
            {
               this.halt(u);
               this.attemptToHeal(dt,u);
            }
         }
      }
      
      private function getAngle(u1:MyUnit, u2:MyUnit) : Number
      {
         var v1:Vector3D = new Vector3D(u1.mPositionDrawX,u1.mPositionDrawY,0);
         var v2:Vector3D = new Vector3D(u2.mPositionDrawX,u2.mPositionDrawY,0);
         return DCMath.getAngle(v1,v2);
      }
      
      private function attemptToHeal(dt:int, u:MyUnit) : void
      {
         var closeEnough:*;
         if(!(closeEnough = DCMath.distanceSqr(u.mPosition,this.mTarget.mPosition) < u.mDef.getShotDistanceSqr()))
         {
            return;
         }
         var canShoot:Boolean = u.getShotComponent().isShotAllowed(u);
         if(!canShoot)
         {
            return;
         }
         if(!this.targetStillValid())
         {
            return;
         }
         changeState(23);
         this.shoot(dt,u);
      }
      
      private function shoot(dt:int, u:MyUnit) : void
      {
         if(this.mTarget != null)
         {
            u.shotShoot(this.mTarget);
         }
      }
      
      private function targetStillValid() : Boolean
      {
         return this.mTarget != null && this.mTarget.mIsAlive && this.mTarget.getEnergyPercent() < 90;
      }
      
      private function findTarget(dt:int, u:MyUnit) : void
      {
         var units:Vector.<MyUnit> = null;
         var target:* = null;
         var unit:MyUnit = null;
         var dist:Number = NaN;
         var mEnergyDist:Number = NaN;
         var dist1:* = NaN;
         var dist2:* = NaN;
         var aux:* = NaN;
         var maxDistanceLocal:Number = u.mDef.getShotDistanceSqr() * 9;
         var targetHurtLocal:* = null;
         var targetClosestLocal:* = null;
         var targetClosestLocalDist:* = 0;
         var targetClosestGlobal:* = null;
         var targetClosestGlobalDist:* = 0;
         var unitLists:Vector.<Vector.<MyUnit>> = this.mAttacking ? MyUnit.smUnitScene.getAllAttackingUnits() : MyUnit.smUnitScene.getAllDefendingUnits();
         for each(units in unitLists)
         {
            for each(unit in units)
            {
               if(!(!unit.mIsAlive || unit == u))
               {
                  if(!unit.mDef.isHealer())
                  {
                     if((dist = DCMath.distanceSqr(u.mPosition,unit.mPosition)) < maxDistanceLocal)
                     {
                        if(targetHurtLocal == null || unit.getEnergyPercent() < targetHurtLocal.getEnergyPercent())
                        {
                           targetHurtLocal = unit;
                        }
                        if(targetClosestLocal == null || dist < targetClosestLocalDist)
                        {
                           targetClosestLocal = unit;
                           targetClosestLocalDist = dist;
                        }
                     }
                     else if(targetClosestGlobal == null || dist < targetClosestGlobalDist)
                     {
                        targetClosestGlobal = unit;
                        targetClosestGlobalDist = dist;
                     }
                  }
               }
            }
         }
         if((target = targetHurtLocal) == null)
         {
            target = targetClosestLocal;
         }
         if(target == null)
         {
            target = targetClosestGlobal;
         }
         if(this.mTarget != null && this.mTarget.mIsAlive && target != null)
         {
            mEnergyDist = Math.abs(this.mTarget.getEnergyPercent() - target.getEnergyPercent());
            dist1 = DCMath.distanceSqr(u.mPosition,target.mPosition);
            dist2 = DCMath.distanceSqr(u.mPosition,this.mTarget.mPosition);
            if(dist1 > dist2)
            {
               aux = dist1;
               dist1 = dist2;
               dist2 = aux;
            }
            if(mEnergyDist < 10 && (dist1 == 0 || dist2 / dist1 < 1.1))
            {
               target = this.mTarget;
            }
         }
         if(target != null)
         {
            this.mTarget = target;
            this.moveOut(u);
            changeState(22);
         }
         else
         {
            this.mTarget = null;
            this.halt(u);
         }
      }
      
      private function moveOut(u:MyUnit) : void
      {
         u.movementResume();
      }
      
      private function halt(u:MyUnit) : void
      {
         u.movementStop();
      }
      
      override public function notify(e:Object) : void
      {
         var bunker:Bunker = null;
         var _loc3_:* = e.cmd;
         if("unitEventReturnToBunker" === _loc3_)
         {
            bunker = e.bunker;
            if(bunker != null)
            {
               goToItem(bunker.getWIO());
               mUnit.goalSetForCurrentId("unitGoalForReturnToBunker");
            }
         }
      }
   }
}
