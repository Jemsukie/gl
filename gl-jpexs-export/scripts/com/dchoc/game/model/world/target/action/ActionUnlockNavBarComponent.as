package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.utils.Dictionary;
   
   public class ActionUnlockNavBarComponent extends DCAction
   {
       
      
      public function ActionUnlockNavBarComponent()
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
         var params:Dictionary;
         (params = new Dictionary())["containerName"] = "navigationbar";
         params["elementName"] = componentName.split(":")[0];
         MessageCenter.getInstance().sendMessage("uiUnlockElement",params);
         InstanceMng.getMapControllerPlanet().autoScrollReset();
         return true;
      }
   }
}
