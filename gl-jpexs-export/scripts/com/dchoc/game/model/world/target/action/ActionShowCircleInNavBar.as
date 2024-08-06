package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.utils.Dictionary;
   
   public class ActionShowCircleInNavBar extends DCAction
   {
       
      
      public function ActionShowCircleInNavBar()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         if((InstanceMng.getMapView() != null && InstanceMng.getMapView().isBuilt()) == false)
         {
            return false;
         }
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
         MessageCenter.getInstance().sendMessage("putTutorialCircle",params);
         return true;
      }
   }
}
