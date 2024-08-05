package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.view.UnitViewCustom;
   
   public class GoalSpecialAttackFreezeBomb extends UnitComponentGoal
   {
       
      
      public function GoalSpecialAttackFreezeBomb(unit:MyUnit)
      {
         super(unit);
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var condition:* = false;
         var goalParams:Object = null;
         var viewComp:UnitViewCustom;
         if((viewComp = mUnit.getViewComponent() as UnitViewCustom) != null)
         {
            condition = viewComp.getCurrentFrame() >= viewComp.getTotalFrames() >> 1;
            if(condition)
            {
               goalParams = {
                  "affectsArea":true,
                  "hasExploded":true,
                  "freeze":{
                     "durationMs":30000,
                     "moveMultiplier":0.3,
                     "fireRateMultiplier":0.3,
                     "viewType":"freeze"
                  }
               };
               MyUnit.smUnitScene.bulletsShoot("b_freeze_001",0,"unitGoalImpact",goalParams,u,null,0,false,false);
               mUnit.markToBeReleasedFromScene();
            }
         }
      }
   }
}
