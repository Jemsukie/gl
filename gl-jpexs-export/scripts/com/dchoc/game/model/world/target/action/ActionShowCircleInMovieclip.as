package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.utils.Dictionary;
   
   public class ActionShowCircleInMovieclip extends DCAction
   {
       
      
      public function ActionShowCircleInMovieclip()
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
         if(componentName == null || componentName == "")
         {
            return true;
         }
         var infoArr:Array;
         var componentId:String = String((infoArr = componentName.split(":"))[1]);
         var dict:Dictionary;
         (dict = new Dictionary())["elementName"] = componentId;
         MessageCenter.getInstance().sendMessage("putTutorialCircle",dict);
         return true;
      }
   }
}
