package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionIsUnitUpgraded extends Condition
   {
       
      
      public function ConditionIsUnitUpgraded()
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
         var isUnlocked:Boolean = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().isGameUnitUnlocked(target.getDef().getMiniTargetSku(index));
         var unitUpgradeValue:int;
         var isUpgraded:* = (unitUpgradeValue = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getCurrentUpgradeIdBySku(target.getDef().getMiniTargetSku(index))) >= target.getDef().getMiniTargetLevel(index);
         if(isUnlocked && isUpgraded)
         {
            super.check(target,index);
            if((storedInServerAmount = target.getProgress(index)) == 0 && isUnlocked == true)
            {
               target.updateProgress("unitUnlocked",1,"","",1);
            }
            return true;
         }
         return false;
      }
   }
}
