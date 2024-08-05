package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionLoadStarmapAmount extends Condition
   {
       
      
      public function ConditionLoadStarmapAmount()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var progress:int = target.getProgress(index);
         var amount:int = target.getDef().getAmount();
         return progress >= amount;
      }
   }
}
