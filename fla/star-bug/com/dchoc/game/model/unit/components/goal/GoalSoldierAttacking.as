package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import flash.utils.Dictionary;
   
   public class GoalSoldierAttacking extends GoalTerrainUnit
   {
       
      
      public function GoalSoldierAttacking(unit:MyUnit)
      {
         super(unit,true,100,"running");
      }
      
      override protected function enterState(state:int) : void
      {
         var target:MyUnit = null;
         super.enterState(state);
         switch(state)
         {
            case 1:
            case -69:
               if(mUsePathIsEnabled)
               {
                  if(shotIsShooting() || state == -69)
                  {
                     if(true)
                     {
                        target = MyUnit(mUnit.mData[13]);
                        askPathToUnit(target);
                     }
                     else
                     {
                        moveArriveTarget();
                     }
                  }
               }
               else
               {
                  moveArriveTarget();
               }
         }
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var mov:UnitComponentMovement = null;
         var behaviours:Dictionary = null;
         super.logicUpdateDoDo(dt,u);
         var data:Array = u.mData;
         switch(mCurrentState)
         {
            case 0:
               if(data[3] != null && u.getMovementComponent().isOnFloor())
               {
                  if(mDrillIsEnabled)
                  {
                     if(!mShotIsEnabled)
                     {
                        return;
                     }
                  }
                  data[13] = data[3];
                  changeState(1);
               }
               break;
            case 1:
               break;
            case -69:
               behaviours = (mov = u.getMovementComponent()).mBehaviourWeights;
         }
      }
   }
}
