package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.view.UnitViewCustom;
   
   public class GoalSpecialAttackBigRock extends UnitComponentGoal
   {
       
      
      public function GoalSpecialAttackBigRock(unit:MyUnit)
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
            condition = viewComp.getCurrentFrame() == 12;
            if(condition)
            {
               goalParams = {
                  "affectsArea":true,
                  "hasExploded":true
               };
               MyUnit.smUnitScene.bulletsShoot("b_rocket_001",u.mDef.getShotDamage(),"unitGoalImpact",goalParams,u,null,0,false,false);
               InstanceMng.getViewMngGame().cameraShakeStart(0.02,2000);
            }
            condition = viewComp.getCurrentFrame() >= viewComp.getTotalFrames();
            if(condition)
            {
               mUnit.markToBeReleasedFromScene();
            }
         }
      }
   }
}
