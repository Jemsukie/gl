package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionBuildBattle extends DCAction
   {
       
      
      public function ActionBuildBattle()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var timeOut:String = null;
         var battleMode:int = 0;
         if(isPreaction)
         {
            timeOut = target.getDef().getPreactionTargetSid();
         }
         else
         {
            timeOut = target.getDef().getPostactionTargetSid();
         }
         var infoArr:Array = timeOut.split(":");
         if(infoArr[1] != "")
         {
            switch(infoArr[1])
            {
               case "defenderWins":
                  battleMode = 2;
                  break;
               case "attackerWins":
                  battleMode = 1;
                  break;
               case "defenderWinsMarineAttack":
                  battleMode = 5;
                  break;
               case "attackerWinsMarines":
                  battleMode = 6;
            }
         }
         timeOut = String(infoArr[0]);
         InstanceMng.getUnitScene().battleStart(battleMode);
         return true;
      }
   }
}
