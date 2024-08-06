package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.utils.Dictionary;
   
   public class ActionShowCircleInButton extends DCAction
   {
       
      
      public function ActionShowCircleInButton()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         var infoArr:Array = null;
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
         var params:Dictionary = new Dictionary();
         var i:int = 0;
         infoArr = componentName.split(":");
         params["containerName"] = infoArr[0];
         for(i = 1; i < infoArr.length; )
         {
            params["elementName"] = infoArr[i];
            MessageCenter.getInstance().sendMessage("putTutorialCircle",params);
            i++;
         }
         return true;
      }
   }
}
