package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionWait extends DCAction
   {
       
      
      public function ActionWait()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var timeOut:String = null;
         if(isPreaction)
         {
            timeOut = target.getDef().getPreactionTargetSid();
         }
         else
         {
            timeOut = target.getDef().getPostactionTargetSid();
         }
         InstanceMng.getFlowStatePlanet().setTutorialTimerTime(Number(timeOut));
         return true;
      }
   }
}
