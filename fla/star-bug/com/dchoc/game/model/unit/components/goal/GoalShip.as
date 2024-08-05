package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   
   public class GoalShip extends UnitComponentGoal
   {
      
      protected static const STATE_START:int = 0;
      
      protected static const STATE_AVOID_COLLISION:int = 1;
       
      
      protected var mCheckCollisionsEnabled:Boolean = true;
      
      private var mPreviousState:int;
      
      public function GoalShip(unit:MyUnit)
      {
         super(unit);
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         super.logicUpdateDoDo(dt,u);
         if(mCurrentState != 1)
         {
            this.logicUpdateDoDoDo(dt,u);
         }
         separateUnitsFromEachOther(false);
      }
      
      protected function checkCollisions(u:MyUnit) : void
      {
         var uNearest:MyUnit = null;
         var threshold:* = 0;
         var mov:UnitComponentMovement = null;
         if(this.mCheckCollisionsEnabled)
         {
            if((uNearest = u.mData[7]) != null)
            {
               threshold = u.getPanicDistance() + uNearest.getPanicDistance();
               threshold >>= 1;
               if(u.mData[8] < threshold * threshold)
               {
                  mov = u.getMovementComponent();
                  mov.setTarget(uNearest.mPosition);
                  this.mPreviousState = mCurrentState;
                  changeState(1);
                  mov.resetBehaviours();
               }
            }
         }
      }
      
      protected function logicUpdateDoDoDo(dt:int, u:MyUnit) : void
      {
      }
      
      protected function avoidCollision(dt:int, u:MyUnit) : void
      {
         var threshold:* = 0;
         var uNearest:MyUnit;
         var collisionAvoided:* = (uNearest = u.mData[7]) == null;
         if(uNearest != null)
         {
            threshold = (threshold = u.getPanicDistance() + uNearest.getPanicDistance()) >> 1;
            if(u.mData[8] > threshold * threshold)
            {
               collisionAvoided = true;
            }
         }
         if(collisionAvoided)
         {
            this.avoidCollisionExit(u);
         }
         else
         {
            this.avoidCollisionDo(dt,u);
         }
      }
      
      protected function avoidCollisionDo(dt:int, u:MyUnit) : void
      {
         var mov:UnitComponentMovement = u.getMovementComponent();
         mov.mBehaviourWeights[2] = 1;
         mov.mBehaviourWeights[8] = 0.5;
         var uNearest:MyUnit = u.mData[7];
         mov.setTarget(uNearest.mPosition);
      }
      
      protected function avoidCollisionExit(u:MyUnit) : void
      {
         changeState(this.mPreviousState);
      }
   }
}
