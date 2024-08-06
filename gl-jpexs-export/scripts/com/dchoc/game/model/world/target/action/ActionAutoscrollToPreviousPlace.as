package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ActionAutoscrollToPreviousPlace extends DCAction
   {
       
      
      public function ActionAutoscrollToPreviousPlace()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var coords:DCCoordinate = null;
         var timeToGo:Number = NaN;
         if(isPreaction)
         {
            timeToGo = Number(target.getDef().getPreactionTargetSid());
         }
         else
         {
            timeToGo = Number(target.getDef().getPostactionTargetSid());
         }
         if((coords = InstanceMng.getMapControllerPlanet().getBeforeAutoScrollCoords()) == null)
         {
            coords = InstanceMng.getMapControllerPlanet().getOriginalCenterCamPos();
         }
         InstanceMng.getMapControllerPlanet().moveCameraTo(coords.x,coords.y,timeToGo);
         return true;
      }
   }
}
