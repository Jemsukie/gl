package com.dchoc.toolkit.view.map.perspective
{
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public interface DCMapPerspective
   {
       
      
      function mapToScreen(param1:DCCoordinate) : DCCoordinate;
      
      function screenToMap(param1:DCCoordinate) : DCCoordinate;
      
      function getTopLeftOfCenterScreen(param1:int, param2:int, param3:int, param4:int, param5:DCCoordinate = null) : DCCoordinate;
      
      function getMapAnchorX(param1:int) : int;
      
      function getTileAnchorX(param1:int) : int;
   }
}
