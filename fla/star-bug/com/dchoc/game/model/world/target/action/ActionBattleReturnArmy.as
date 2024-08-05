package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionBattleReturnArmy extends DCAction
   {
       
      
      public function ActionBattleReturnArmy()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         var wave:String = unitScene.battleGetWave(7);
         unitScene.startDeployUnits(2100,1200,wave,3,null,true);
         return true;
      }
   }
}
