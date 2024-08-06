package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ActionAutoscroll extends DCAction
   {
       
      
      public function ActionAutoscroll()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         var coords:DCCoordinate = null;
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
         InstanceMng.getMapControllerPlanet().moveCameraTo(coords.x,coords.y,coords.z);
         return true;
      }
   }
}
