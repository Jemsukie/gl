package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class ToolSetTile extends Tool
   {
       
      
      private var mTypeId:int;
      
      public function ToolSetTile(id:int, typeId:int, cursorId:int = -1)
      {
         if(cursorId == -1)
         {
            cursorId = -1;
         }
         super(id,true,cursorId);
         this.mTypeId = typeId;
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return tile != null && tile.mBaseItem == null && InstanceMng.getRole().toolSetTileIsAllowed(this.mTypeId,tile.getTypeId());
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var componentTarget:DCComponent = null;
         var e:Object = null;
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         if(this.cursorDoIsApplicable(tile))
         {
            componentTarget = smMapController.mMapModel;
            e = {};
            e.cmd = 0;
            e.tileIndex = tile.getTileIndex();
            e.typeId = this.mTypeId;
            InstanceMng.getNotifyMng().addEvent(componentTarget,e);
         }
         return true;
      }
   }
}
