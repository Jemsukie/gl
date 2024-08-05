package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.tools.ToolPlaceItem;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionMapTiles extends DCAction
   {
       
      
      public function ActionMapTiles()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var tileCoord:String = null;
         var arr:Array = null;
         var tileIndex:int = 0;
         var fromTile:Array = null;
         var toTile:Array = null;
         var fromTileX:int = 0;
         var fromTileY:int = 0;
         var toTileX:int = 0;
         var toTileY:int = 0;
         var i:* = 0;
         var j:* = 0;
         var actionTilesSku:String = isPreaction ? target.getDef().getPreAction() : target.getDef().getPostAction();
         var action:String;
         var tilesCoords:Array = (action = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSku()).split(":");
         var tileIndexes:Array = [];
         var mapControllerPlanet:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         if(actionTilesSku == "mapTiles")
         {
            for each(tileCoord in tilesCoords)
            {
               arr = tileCoord.split(",");
               tileIndex = mapControllerPlanet.getTileRelativeXYToIndex(arr[0],arr[1]);
               tileIndexes.push(tileIndex);
            }
         }
         else
         {
            fromTile = (tilesCoords[0] as String).split(",");
            toTile = (tilesCoords[1] as String).split(",");
            fromTileX = parseInt(fromTile[0]);
            fromTileY = parseInt(fromTile[1]);
            toTileX = parseInt(toTile[0]);
            toTileY = parseInt(toTile[1]);
            for(i = fromTileX; i <= toTileX; )
            {
               for(j = fromTileY; j <= toTileY; )
               {
                  tileIndex = mapControllerPlanet.getTileRelativeXYToIndex(i,j);
                  tileIndexes.push(tileIndex);
                  j++;
               }
               i++;
            }
         }
         ToolPlaceItem(InstanceMng.getToolsMng().getTool(4)).setPlaceOnTileIndexes(tileIndexes);
         return true;
      }
   }
}
