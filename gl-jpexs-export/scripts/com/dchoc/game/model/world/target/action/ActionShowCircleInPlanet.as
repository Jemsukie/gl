package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.display.DisplayObjectContainer;
   
   public class ActionShowCircleInPlanet extends DCAction
   {
       
      
      public function ActionShowCircleInPlanet()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var planetId:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         var container:DisplayObjectContainer = InstanceMng.getMapViewSolarSystem().getPlanetDisplayObject(planetId,planetId,true);
         if(container != null)
         {
            InstanceMng.getViewMngGame().addHighlightFromContainer(container);
         }
         return true;
      }
   }
}
