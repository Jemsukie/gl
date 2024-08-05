package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.utils.Dictionary;
   
   public class ActionShowSpotlight extends DCAction
   {
      
      private static const RADIUS_FOR_BUTTON:int = 55;
      
      private static const RADIUS_FOR_GUIBAR_ELEMENT:int = 100;
       
      
      public function ActionShowSpotlight()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         var infoArr:Array = null;
         var coords:DCCoordinate = new DCCoordinate();
         var i:int = 0;
         if(isPreaction)
         {
            componentName = target.getDef().getPreactionTargetSid();
         }
         else
         {
            componentName = target.getDef().getPostactionTargetSid();
         }
         if(componentName == "")
         {
            coords = getTargetCoordinates(target.getDef(),isPreaction);
         }
         var params:Dictionary = new Dictionary();
         infoArr = componentName.split(":");
         params["containerName"] = infoArr[0];
         for(i = 1; i < infoArr.length; )
         {
            params["elementName"] = infoArr[i];
            MessageCenter.getInstance().sendMessage("uiUnlockElement",params);
            i++;
         }
         return true;
      }
   }
}
