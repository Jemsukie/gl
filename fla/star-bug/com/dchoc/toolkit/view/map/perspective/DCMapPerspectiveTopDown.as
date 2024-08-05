package com.dchoc.toolkit.view.map.perspective
{
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class DCMapPerspectiveTopDown implements DCMapPerspective
   {
       
      
      public function DCMapPerspectiveTopDown()
      {
         super();
      }
      
      public function mapToScreen(coor:DCCoordinate) : DCCoordinate
      {
         coor.y = -coor.z;
         coor.z = 0;
         return coor;
      }
      
      public function screenToMap(coor:DCCoordinate) : DCCoordinate
      {
         coor.z = -coor.y;
         coor.y = 0;
         return coor;
      }
      
      public function getMapAnchorX(mapViewWidth:int) : int
      {
         return 0;
      }
      
      public function getTileAnchorX(tileViewWidth:int) : int
      {
         return 0;
      }
      
      public function getTopLeftOfCenterScreen(mapViewWidth:int, mapViewHeight:int, stageWidth:int, stageHeight:int, coor:DCCoordinate = null) : DCCoordinate
      {
         if(coor == null)
         {
            coor = new DCCoordinate();
         }
         coor.x = stageWidth - mapViewWidth >> 1;
         coor.y = stageHeight - mapViewHeight >> 1;
         return coor;
      }
   }
}
