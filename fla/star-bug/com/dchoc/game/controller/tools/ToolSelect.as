package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class ToolSelect extends Tool
   {
      
      private static const DEBUG:Boolean = false;
       
      
      public function ToolSelect(id:int)
      {
         super(id,false,-1,25);
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var tile:TileData = null;
         var str:String = null;
         if(false)
         {
            tile = smMapController.getTileDataFromTileXY(tileX,tileY);
            str = "tileX = " + tileX + " tileY = " + tileY;
            if(tile != null)
            {
               str += tile.dataToString();
            }
            if(tile.mBaseItem != null)
            {
               str += "item select: " + tile.mBaseItem.dataToString();
               if(Config.DEBUG_PATHS)
               {
                  smMapController.mMapViewPlanet.debugDrawPoints(smMapController.mMapModel.placeGetItemTileDatas(tile.mBaseItem));
               }
            }
         }
         return true;
      }
      
      override public function getToolActionId(item:WorldItemObject) : int
      {
         var typeId:int = 0;
         var returnValue:int = super.getToolActionId(item);
         if(InstanceMng.getRole().mId == 0 && item.mServerStateId == 1)
         {
            typeId = item.mDef.getTypeId();
            switch(typeId - 5)
            {
               case 0:
               case 1:
                  returnValue = 9;
                  break;
               case 4:
                  if(item.mDef.belongsToGroup("observatory"))
                  {
                     returnValue = 9;
                  }
                  break;
               case 7:
                  returnValue = 7;
            }
         }
         return returnValue;
      }
   }
}
