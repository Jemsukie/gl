package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionBuildingsCreated extends Condition
   {
       
      
      public function ConditionBuildingsCreated()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var targetSku:String = null;
         var upgradeLevel:int = 0;
         var currAmount:int = 0;
         var neededAmount:int = 0;
         var storedInServerAmount:int = 0;
         if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() != 0)
         {
            return false;
         }
         if(target.State <= 1)
         {
            return false;
         }
         if(target.getProgress(index) >= target.getDef().getMiniTargetAmount(index))
         {
            super.check(target,index);
            return true;
         }
         if(InstanceMng.getWorld().isBuilt())
         {
            targetSku = target.getDef().getMiniTargetSku(index);
            upgradeLevel = target.getDef().getMiniTargetLevel(index);
            currAmount = InstanceMng.getWorld().itemsAmountGetAlreadyBuilt(targetSku,upgradeLevel,true);
            neededAmount = target.getDef().getMiniTargetAmount(index);
            storedInServerAmount = target.getProgress(index);
            if(currAmount >= neededAmount)
            {
               super.check(target,index);
               if(storedInServerAmount < currAmount)
               {
                  target.updateProgress("buildingsCreated",neededAmount,targetSku,"",upgradeLevel);
               }
               return true;
            }
         }
         return false;
      }
   }
}
