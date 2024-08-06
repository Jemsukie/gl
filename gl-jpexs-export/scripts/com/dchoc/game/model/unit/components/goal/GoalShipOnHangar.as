package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.geom.Vector3D;
   
   public class GoalShipOnHangar extends GoalShip
   {
      
      public static const STATE_SEEK_CENTER:int = 100;
      
      public static const STATE_SEEK_START:int = 122;
      
      public static const STATE_OUT_OF_POSITION:int = 120;
      
      public static const STATE_WANDERING:int = 121;
      
      private static const HANGAR_MAX_RADIUS:int = 320;
      
      private static const HANGAR_MAX_RADIUS_SQR:int = 102400;
      
      private static const HANGAR_SAFE_RADIUS:int = 260;
      
      private static const HANGAR_SAFE_RADIUS_SQR:int = 67600;
      
      public static const HANGAR_UNIT_OFFSET:int = 20;
      
      public static const HANGAR_GROUND_LIMIT_MAX_X:int = 90;
      
      public static const HANGAR_GROUND_LIMIT_MAX_Y:int = 90;
      
      public static const HANGAR_GROUND_LIMIT_MIN_X:int = -90;
      
      public static const HANGAR_GROUND_LIMIT_MIN_Y:int = -90;
      
      private static const SEEK_TART_TO_START_DISTANCE_SQR:int = 1600;
       
      
      private var mHangarPosition:Vector3D;
      
      private var mAirHangarPosition:Vector3D;
      
      private var mTargetPosition:Vector3D;
      
      private var mSceneUnits:Vector.<MyUnit>;
      
      private var mHangar:WorldItemObject;
      
      private var mStateChangeCooldownTimer:int;
      
      private var mOffset:Number;
      
      private var mIsGroundUnit:Boolean;
      
      private var mActivate:Boolean;
      
      public function GoalShipOnHangar(unit:MyUnit, hangar:WorldItemObject, setPosition:Boolean = false)
      {
         super(unit);
         mCurrentState = 0;
         this.mHangar = hangar;
         this.mStateChangeCooldownTimer = 0;
         this.mTargetPosition = new Vector3D();
         if(setPosition)
         {
            mUnit.setPositionInViewSpace(hangar.mViewCenterWorldX + 90,hangar.mViewCenterWorldY);
            this.mActivate = true;
         }
      }
      
      override public function activate() : void
      {
         var viewComponent:UnitComponentView = null;
         super.activate();
         this.mOffset = mUnit.mId % 3 * 20 - 20 * 1.5;
         MyUnit.smCoor.x = this.mHangar.mViewCenterWorldX;
         MyUnit.smCoor.y = this.mHangar.mViewCenterWorldY;
         this.mHangarPosition = this.mHangar.mUnit.mPosition;
         this.calculateAirHangarPosition();
         MyUnit.smUnitScene.itemRegisterUnit(this.mHangar.mSid,mUnit);
         mCurrentState = 0;
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         mov.goToReset();
         if(mUnit.mDef.getUnitTypeId() == 2)
         {
            mov.setMaxSpeed(1);
            this.mIsGroundUnit = false;
            mCurrentState = 0;
         }
         else
         {
            mov.setMaxSpeed(0.5);
            viewComponent = mUnit.getViewComponent();
            if(viewComponent != null)
            {
               viewComponent.setFrameRate(1);
            }
            mov.mEaseArrival = false;
            mov.resume();
            this.mIsGroundUnit = true;
            mCurrentState = 122;
            this.calculateTargetPosition(this.mActivate);
         }
         this.mSceneUnits = MyUnit.smUnitScene.sceneGetList(mUnit);
         mCheckCollisionsEnabled = true;
         mov.mAcceleration.scaleBy(0);
         mov.mWanderDistance = 10;
         mov.mWanderStep = 4;
         mUnit.mCanBeATarget = false;
      }
      
      private function calculateTargetPosition(activate:Boolean) : void
      {
         var angle:Number = NaN;
         var realCenterX:Number = NaN;
         var realCenterY:Number = NaN;
         if(this.mHangar != null && this.mHangar.mUnit != null)
         {
            this.mHangarPosition = this.mHangar.mUnit.mPosition;
            angle = mUnit.mId / 3 * 6833 % 18 * 22 - 90;
            angle = angle * 3.141592653589793 / 180;
            realCenterX = this.mHangarPosition.x + this.mOffset;
            realCenterY = this.mHangarPosition.y + this.mOffset;
            this.mTargetPosition.x = realCenterX + Math.cos(angle) * 60;
            this.mTargetPosition.y = realCenterY + Math.sin(angle) * 60;
            if(activate)
            {
               this.mActivate = false;
               mUnit.setPosition(realCenterX + Math.cos(angle) * 58.064516129032256,realCenterY + Math.sin(angle) * 58.064516129032256);
            }
         }
      }
      
      private function calculateAirHangarPosition() : void
      {
         if(this.mAirHangarPosition == null)
         {
            this.mAirHangarPosition = new Vector3D();
         }
         this.mAirHangarPosition.x = this.mHangarPosition.x - 380;
         this.mAirHangarPosition.y = this.mHangarPosition.y - 100;
         this.mAirHangarPosition.z = mUnit.mPosition.z;
      }
      
      override public function deactivate() : void
      {
         MyUnit.smUnitScene.itemUnregisterUnit(this.mHangar.mSid,mUnit);
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         mov.setMaxSpeed(mUnit.mDef.getMaxSpeed());
         this.mSceneUnits = null;
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var hangarDistanceSqr:Number = NaN;
         var targetDistance:Number = NaN;
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         if(this.mIsGroundUnit)
         {
            hangarDistanceSqr = DCMath.distanceSqr(mUnit.mPosition,this.mHangarPosition);
         }
         else
         {
            hangarDistanceSqr = DCMath.distanceSqr(mUnit.mPosition,this.mAirHangarPosition);
         }
         if(this.mStateChangeCooldownTimer > 0)
         {
            this.mStateChangeCooldownTimer -= dt;
         }
         switch(mCurrentState)
         {
            case 122:
               mov.resetBehaviours();
               this.calculateTargetPosition(false);
               mov.setTarget(this.mTargetPosition);
               mov.mBehaviourWeights[1] = 1;
               if((targetDistance = DCMath.distanceSqr(mUnit.mPosition,this.mTargetPosition)) < 1600)
               {
                  this.changeState(0);
               }
               break;
            case 0:
            case 100:
               if(this.mIsGroundUnit)
               {
                  if(this.mHangar.isBeingMoved())
                  {
                     this.changeState(122);
                  }
                  else
                  {
                     mov.resetBehaviours();
                     this.checkTurnAround(u);
                  }
               }
               else
               {
                  if(this.mHangar.isBeingMoved())
                  {
                     this.calculateAirHangarPosition();
                  }
                  mUnit.getMovementComponent().setTarget(this.mAirHangarPosition);
                  mov.resetBehaviours();
                  mov.mBehaviourWeights[8] = 0.2;
                  mov.mBehaviourWeights[1] = 0.2;
                  if(this.mStateChangeCooldownTimer <= 0)
                  {
                     if(hangarDistanceSqr <= 67600)
                     {
                        mCurrentState = 121;
                        mov.resetBehaviours();
                     }
                     if(checkCollisions(u))
                     {
                        mCurrentState = 1;
                     }
                  }
                  this.checkInsideHangar(u,hangarDistanceSqr);
               }
               break;
            case 120:
               mUnit.getMovementComponent().setTarget(this.mAirHangarPosition);
               mov.resetBehaviours();
               mov.mBehaviourWeights[1] = 1;
               mov.mBehaviourWeights[8] = 0.2;
               if(this.mStateChangeCooldownTimer <= 0)
               {
                  if(this.checkInsideHangar(u,hangarDistanceSqr))
                  {
                     mov.mAcceleration.scaleBy(0.1);
                     mCurrentState = 100;
                     mov.resetBehaviours();
                  }
               }
               break;
            case 121:
               mUnit.getMovementComponent().setTarget(this.mAirHangarPosition);
               mov.resetBehaviours();
               mov.mBehaviourWeights[8] = 0.5;
               if(this.mStateChangeCooldownTimer <= 0)
               {
                  if(hangarDistanceSqr > 67600)
                  {
                     mCurrentState = 100;
                     mov.resetBehaviours();
                  }
                  if(checkCollisions(u))
                  {
                     mCurrentState = 1;
                  }
               }
               this.checkInsideHangar(u,hangarDistanceSqr);
               break;
            case 1:
               avoidCollision(dt,u);
               this.checkInsideHangar(u,hangarDistanceSqr);
         }
      }
      
      private function checkInsideHangar(u:MyUnit, hangarDistanceSqr:Number) : Boolean
      {
         if(hangarDistanceSqr > 102400)
         {
            mCurrentState = 120;
            return false;
         }
         return true;
      }
      
      private function checkTurnAround(u:MyUnit) : Boolean
      {
         if(this.mStateChangeCooldownTimer > 0)
         {
            return true;
         }
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         var dx:Number = mUnit.mPosition.x - this.mHangarPosition.x;
         var dy:Number = mUnit.mPosition.y - this.mHangarPosition.y;
         if(dx > 90 + this.mOffset || dy > 90 + this.mOffset || dx < -90 + this.mOffset || dy < -90 + this.mOffset)
         {
            mUnit.mPosition.x = mov.mOldPosition.x;
            mUnit.mPosition.y = mov.mOldPosition.y;
            if(Math.abs(mov.mVelocity.x) > Math.abs(mov.mVelocity.y))
            {
               if(mov.mVelocity.x > 0)
               {
                  mov.mVelocity.y = 0.2;
               }
               else
               {
                  mov.mVelocity.y = -0.2;
               }
               mov.mVelocity.x = 0;
            }
            else
            {
               if(mov.mVelocity.y > 0)
               {
                  mov.mVelocity.x = -0.2;
               }
               else
               {
                  mov.mVelocity.x = 0.2;
               }
               mov.mVelocity.y = 0;
            }
            return false;
         }
         return true;
      }
      
      override public function changeState(state:int) : void
      {
         mCurrentState = state;
         this.mStateChangeCooldownTimer = 500;
      }
   }
}
