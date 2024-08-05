package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.utils.math.DCMath;
   
   public class GoalBulletImpact extends UnitComponentGoal
   {
       
      
      private var mCheckGround:Boolean;
      
      private var mAffectsArea:Boolean;
      
      private var mHasExploded:Boolean;
      
      private var mHasSmoke:Boolean;
      
      private var mUnitFromInfoObject:Object;
      
      private var mUnitFromDef:UnitDef;
      
      private var mFollowTarget:Boolean;
      
      private var mUnitFrom:MyUnit;
      
      private var mIsFreeze:Boolean;
      
      private var mFreezeParams:Array;
      
      private const MIN_PERCENT:Number = 30;
      
      public function GoalBulletImpact(unit:MyUnit, unitFrom:MyUnit, affectsArea:Boolean, hasExploded:Boolean)
      {
         super(unit);
         this.mUnitFromInfoObject = MyUnit.shotCreateUnitInfoObject(unitFrom);
         this.mUnitFrom = unitFrom;
         this.mUnitFromDef = unitFrom.mDef;
         this.mAffectsArea = affectsArea;
         this.setHasExploded(hasExploded);
         this.mHasSmoke = unit.mDef.getAnimationDefSku() == "missile";
         this.mFollowTarget = unit.mDef.bombNeedsToFollowTarget();
         this.mCheckGround = unit.mDef.bombNeedsToCheckGround() || this.mUnitFrom.mDef.bombNeedsToCheckGround();
      }
      
      public static function doImpact(u:MyUnit, target:MyUnit, uFromInfo:Object = null, damage:int = -1) : void
      {
         if(uFromInfo == null)
         {
            uFromInfo = MyUnit.shotCreateUnitInfoObject(u);
         }
         if(target != null)
         {
            if(damage == -1)
            {
               target.shotHit(u.shotGetDamage(),uFromInfo,false,target.mDef.getDeathType());
            }
            else
            {
               target.shotHit(damage,uFromInfo,false,target.mDef.getDeathType());
            }
         }
         u.markToBeReleasedFromScene();
      }
      
      public static function playEffects(u:MyUnit, target:MyUnit, explosionType:int = -1) : void
      {
         var sound:String = null;
         if(explosionType == -1)
         {
            if(target != null && (target.mDef.isTerrainUnit() || target.mDef.isABuilding()))
            {
               explosionType = 7;
            }
            else
            {
               explosionType = 0;
            }
            if(u.mDef.mSku == "b_bomb_001")
            {
               explosionType = 21;
            }
         }
         if(explosionType != -1)
         {
            sound = "explode.mp3";
            if(explosionType == 7 || explosionType == 21)
            {
               ParticleMng.addParticle(12,u.mPositionDrawX,u.mPositionDrawY);
               ParticleMng.addParticle(explosionType,u.mPositionDrawX,u.mPositionDrawY,1);
            }
            else
            {
               ParticleMng.addParticle(explosionType,u.mPositionDrawX,u.mPositionDrawY,0);
               if(target != null && !target.mIsAlive)
               {
                  ParticleMng.addParticle(explosionType,target.mPositionDrawX,target.mPositionDrawY,0);
               }
            }
            if(Config.USE_SOUNDS && u.mDef.getAutoPlaySound())
            {
               SoundManager.getInstance().playSound(sound);
            }
         }
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var blastRadius:Number = NaN;
         var mov:UnitComponentMovement = null;
         var time:int = 0;
         var distance:Number = NaN;
         var data:Array;
         var target:MyUnit = (data = u.mData)[13];
         var unitNearest:MyUnit = data[1];
         if(this.mAffectsArea && this.mHasExploded)
         {
            if((blastRadius = this.mUnitFromDef.getBlastRadius()) == 0)
            {
               doImpact(u,target,this.mUnitFromInfoObject,u.shotGetDamage());
            }
            else
            {
               this.explode(u);
            }
            u.mData[16] = 0;
            return;
         }
         if(this.mCheckGround && u.mPosition.z > 0)
         {
            if(target != null && !target.getIsAlive() || target == null)
            {
               u.markToBeReleasedFromScene();
               playEffects(u,null,7);
            }
         }
         if(this.mCheckGround)
         {
            if(u.mPosition.z > 0)
            {
               if(this.mAffectsArea)
               {
                  this.mHasExploded = true;
                  this.explode(u);
               }
               else
               {
                  doImpact(u,unitNearest,this.mUnitFromInfoObject);
               }
            }
         }
         if(target != null)
         {
            (mov = u.getMovementComponent()).setTarget(target.mPosition);
            if(this.mFollowTarget)
            {
               mov.mBehaviourWeights[1] = 1;
               mov.mBehaviourWeights[8] = target.mData[35] != null ? 0 : 0.5;
            }
            if(this.mHasSmoke)
            {
               if((time = (time = int(u.mData[12])) + dt) > 30)
               {
                  ParticleMng.addParticle(1,u.mPositionDrawX,u.mPositionDrawY + u.mPosition.z,1);
                  time -= 30;
               }
               data[12] = time;
            }
            if(!this.mCheckGround)
            {
               if(unitNearest != null)
               {
                  if(u.mData[16] < 500 && this.mFollowTarget)
                  {
                     u.mData[16] = 500;
                  }
                  distance = u.getBoundingRadius() + unitNearest.getBoundingRadius();
                  if(data[2] < distance * distance)
                  {
                     if(this.mAffectsArea)
                     {
                        this.mHasExploded = true;
                        this.explode(u);
                     }
                     else
                     {
                        doImpact(u,unitNearest,this.mUnitFromInfoObject);
                     }
                  }
               }
               else
               {
                  u.mData[16] = 0;
               }
            }
         }
         else if(!this.mCheckGround)
         {
            u.markToBeReleasedFromScene();
         }
      }
      
      private function explode(u:MyUnit) : void
      {
         var v:MyUnit = null;
         var l:Vector.<MyUnit> = null;
         var check:Boolean = false;
         var distanceSqr:Number = NaN;
         var damage:* = NaN;
         var distancePercent:Number = NaN;
         var k:Number = NaN;
         var percentage:int = 0;
         var list:Vector.<Vector.<MyUnit>> = MyUnit.smUnitScene.senseEnvironmentGetLists(u,this.mUnitFrom);
         var uDamage:Number = u.shotGetDamage();
         var blastRadiusSqr:Number = this.mUnitFromDef.getBlastRadiusSqr();
         var damageGradual:*;
         if(damageGradual = this.mUnitFromDef.getBlastDamageDistribution() != "uniform")
         {
            k = (100 - 30) / blastRadiusSqr;
         }
         else
         {
            damage = uDamage;
         }
         for each(l in list)
         {
            for each(v in l)
            {
               if(check = v != u && v.mIsAlive)
               {
                  if((distanceSqr = Math.floor(DCMath.distanceSqr(v.mPosition,u.mPosition) - v.getBoundingRadiusSqr())) < 0)
                  {
                     distanceSqr = 0;
                  }
                  if(distanceSqr < blastRadiusSqr)
                  {
                     if(damageGradual)
                     {
                        distancePercent = k * (blastRadiusSqr - distanceSqr);
                        damage = (percentage = Math.floor(30 + distancePercent)) * uDamage / 100;
                        this.mUnitFromInfoObject.shotBlast = percentage;
                        this.mUnitFromInfoObject.shotBlastDistanceSqr = distanceSqr;
                     }
                     if(this.mIsFreeze)
                     {
                        v.slowDownDoEffect(this.mFreezeParams);
                     }
                     else
                     {
                        doImpact(u,v,this.mUnitFromInfoObject,damage);
                     }
                  }
               }
            }
         }
         if(!this.mIsFreeze)
         {
            playEffects(u,v);
         }
      }
      
      private function setHasExploded(value:Boolean) : void
      {
         this.mHasExploded = value;
         if(this.mHasExploded)
         {
            mUnit.mData[16] = 10000;
         }
      }
      
      public function setFreeze(durationMs:Number, moveMultiplier:Number, fireRateMultiplier:Number, viewType:String) : void
      {
         this.mIsFreeze = true;
         this.mFreezeParams = [];
         this.mFreezeParams.push(0);
         this.mFreezeParams.push(durationMs);
         this.mFreezeParams.push(moveMultiplier);
         this.mFreezeParams.push(fireRateMultiplier);
         this.mFreezeParams.push(viewType);
      }
   }
}
