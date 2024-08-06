package com.dchoc.game.controller.tools
{
   import com.dchoc.game.model.map.TileData;
   
   public class ToolUpgrade extends Tool
   {
       
      
      public function ToolUpgrade(id:int, cursorId:int = -1, actionId:int = -1)
      {
         super(id,true,cursorId,actionId);
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return false;
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return tile.mBaseItem != null;
      }
   }
}
