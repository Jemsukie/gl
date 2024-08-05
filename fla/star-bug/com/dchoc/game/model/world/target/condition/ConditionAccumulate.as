package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionAccumulate extends Condition
   {
       
      
      public function ConditionAccumulate()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var amount:int = 0;
         var progress:int = 0;
         if(target.getDef().getNumMinitargetsFound() != 0)
         {
            amount = target.getDef().getMiniTargetAmount(index);
         }
         else
         {
            amount = target.getDef().getAmount();
         }
         if((progress = target.getProgress(index)) >= amount)
         {
            super.check(target,index);
            return true;
         }
         return false;
      }
   }
}
