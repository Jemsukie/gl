package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionDroidCreated extends Condition
   {
       
      
      public function ConditionDroidCreated()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var storedInServerAmount:int = 0;
         if(target.State <= 1)
         {
            return false;
         }
         if(target.getProgress(index) >= target.getDef().getMiniTargetAmount(index))
         {
            super.check(target,index);
            return true;
         }
         var currDroids:int = InstanceMng.getUserInfoMng().getProfileLogin().getMaxDroidsAmount();
         var amountNeeded:Number = target.getDef().getMiniTargetAmount(index);
         if(currDroids >= amountNeeded)
         {
            super.check(target,index);
            if((storedInServerAmount = target.getProgress(index)) < currDroids)
            {
               target.updateProgress("droidsCreated",amountNeeded,"","",1);
            }
            return true;
         }
         return false;
      }
   }
}
