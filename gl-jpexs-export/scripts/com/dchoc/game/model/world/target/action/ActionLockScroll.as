package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockScroll extends DCAction
   {
       
      
      public function ActionLockScroll()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         if(isPreaction)
         {
            componentName = target.getDef().getPreactionTargetSid();
         }
         else
         {
            componentName = target.getDef().getPostactionTargetSid();
         }
         if(componentName != "")
         {
            if(componentName == "true")
            {
               InstanceMng.getMapControllerPlanet().setIsScrollAllowed(true);
            }
            else
            {
               InstanceMng.getMapControllerPlanet().setIsScrollAllowed(false);
            }
         }
         return true;
      }
   }
}
