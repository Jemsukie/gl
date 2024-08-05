package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionHasWaveBeenLaunched extends Condition
   {
       
      
      public function ConditionHasWaveBeenLaunched()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return InstanceMng.getUnitScene().deployHasWaveBeenLaunched();
      }
   }
}
