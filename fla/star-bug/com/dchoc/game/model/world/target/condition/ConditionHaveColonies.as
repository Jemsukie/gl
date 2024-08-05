package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionHaveColonies extends Condition
   {
       
      
      public function ConditionHaveColonies()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var currAmount:int = 0;
         var neededAmount:int = 0;
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
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         if(uInfo != null)
         {
            currAmount = uInfo.getPlanetsAmount() - 1;
            neededAmount = target.getDef().getMiniTargetAmount(index);
            storedInServerAmount = target.getProgress(index);
            if(currAmount >= neededAmount)
            {
               super.check(target,index);
               if(storedInServerAmount < currAmount)
               {
                  target.updateProgress("haveColonies",neededAmount,"","",1);
               }
               return true;
            }
         }
         return false;
      }
   }
}
