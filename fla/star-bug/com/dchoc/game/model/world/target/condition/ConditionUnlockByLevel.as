package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionUnlockByLevel extends Condition
   {
       
      
      public function ConditionUnlockByLevel()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var levelNeeded:int = int(target.getDef().getConditionAmount());
         var playerLevel:int = InstanceMng.getUserInfoMng().getProfileLogin().getLevel();
         return playerLevel >= levelNeeded;
      }
   }
}
