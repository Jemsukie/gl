package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class ToolDemolish extends Tool
   {
       
      
      public function ToolDemolish(id:int)
      {
         super(id,true,0,7);
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return false;
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return InstanceMng.getRole().actionUIIsAllowed(mActionId,tile);
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var componentTarget:DCComponent = null;
         var e:Object = null;
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         if(this.cursorDoIsApplicable(tile))
         {
            e = {};
            if(tile.mBaseItem == null)
            {
               componentTarget = smMapController.mMapModel;
               e.cmd = 1;
               e.tileIndex = tile.getTileIndex();
               e.typeId = tile.getTypeId();
               InstanceMng.getNotifyMng().addEvent(componentTarget,e);
            }
         }
         return true;
      }
   }
}
