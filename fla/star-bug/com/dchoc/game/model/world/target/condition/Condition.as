package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   
   public class Condition extends DCCondition
   {
       
      
      public function Condition()
      {
         super();
      }
      
      override public function launchEventOnConditionAccomplished(target:DCTarget, index:int = 0) : void
      {
         if(getConditionAlreadyNotified() == false)
         {
            if(InstanceMng.getTopHudFacade() != null)
            {
               InstanceMng.getTopHudFacade().showProgressIcon(target.Id);
            }
            setConditionAlreadyNotified(true);
            this.notifyTracking(target,index);
         }
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return true;
      }
      
      protected function notifyTracking(target:DCTarget, index:int) : void
      {
         if(Config.USE_METRICS && !InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            DCMetrics.sendMetric("Mission Flow","Mission Progress",target.getDef().mSku,index.toString());
         }
      }
   }
}
