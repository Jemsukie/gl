package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionFireworksOver extends Condition
   {
       
      
      public function ConditionFireworksOver()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return !FireWorksMng.getInstance().areFireworksRunning();
      }
   }
}
