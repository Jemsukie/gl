package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class ActionShowCircleInTiles extends DCAction
   {
       
      
      public function ActionShowCircleInTiles()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var coord:DCCoordinate = getTargetCoordinates(target.getDef(),isPreaction);
         coord.x += 1;
         coord.y += 1;
         coord = InstanceMng.getViewMngPlanet().tileRelativeXYToWorldViewPos(coord);
         var w:int = InstanceMng.getMapViewPlanet().getTileViewWidth();
         var h:int = InstanceMng.getMapViewPlanet().getTileViewHeight();
         var x:int = coord.x;
         var y:int = coord.y + (h >> 1);
         w *= 4;
         h *= 4;
         w += 20;
         h += 40;
         InstanceMng.getViewMngPlanet().addHighlightFromCoords(x,y,w,h);
         return true;
      }
   }
}
