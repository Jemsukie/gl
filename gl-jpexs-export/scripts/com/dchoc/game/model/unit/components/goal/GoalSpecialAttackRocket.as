package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.view.UnitViewCustom;
   
   public class GoalSpecialAttackRocket extends UnitComponentGoal
   {
       
      
      public function GoalSpecialAttackRocket(unit:MyUnit)
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
                  "hasExploded":true
               };
               MyUnit.smUnitScene.bulletsShoot("b_rocket_001",u.mDef.getShotDamage(),"unitGoalImpact",goalParams,u,null,0,false,false);
               mUnit.markToBeReleasedFromScene();
            }
         }
      }
   }
}
