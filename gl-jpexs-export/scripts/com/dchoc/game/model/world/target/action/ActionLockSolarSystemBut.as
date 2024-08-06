package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockSolarSystemBut extends DCAction
   {
       
      
      public function ActionLockSolarSystemBut()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var id:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         InstanceMng.getMapViewSolarSystem().lockPlanets(id);
         return true;
      }
   }
}
