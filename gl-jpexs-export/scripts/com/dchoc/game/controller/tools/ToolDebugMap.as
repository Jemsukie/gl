package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ToolDebugMap extends Tool
   {
       
      
      private var mTextField:TextField;
      
      public function ToolDebugMap(id:int)
      {
         var textFormat:TextFormat = null;
         this.mTextField = new TextField();
         this.mTextField.wordWrap = false;
         this.mTextField.autoSize = "center";
         this.mTextField.background = true;
         this.mTextField.backgroundColor = 0;
         this.mTextField.textColor = 16777184;
         textFormat = this.mTextField.defaultTextFormat;
         textFormat.bold = true;
         textFormat.size = 12;
         this.mTextField.defaultTextFormat = textFormat;
         DCTextMng.setText(this.mTextField,"blabla");
         super(id,true,-1,-1,false,true);
      }
      
      override public function checkUiDisable(tileX:int, tileY:int) : Boolean
      {
         return false;
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function cursorDoIsApplicable(tile:TileData) : Boolean
      {
         return tile != null;
      }
      
      override protected function cursorDoBegin() : void
      {
         InstanceMng.getViewMngPlanet().addChildToLayer(this.mTextField,InstanceMng.getViewMngPlanet().getCursorLayerSku());
      }
      
      override protected function cursorDoEnd() : void
      {
         InstanceMng.getViewMngPlanet().removeChildFromLayer(this.mTextField,InstanceMng.getViewMngPlanet().getCursorLayerSku());
      }
      
      override protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         var viewMng:ViewMngPlanet = null;
         viewMng = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate;
         (coor = getCoor()).x = x;
         coor.y = y;
         viewMng.screenToTileXY(coor,true);
         tileX = coor.x;
         tileY = coor.y;
         viewMng.tileXYToWorldPos(coor,false);
         var worldX:int = int(coor.x * 10) / 10;
         var worldY:int = int(coor.y * 10) / 10;
         coor.x = tileX;
         coor.y = tileY;
         viewMng.tileXYToWorldViewPos(coor,false);
         var viewX:int = int(coor.x * 10) / 10;
         var viewY:int = int(coor.y * 10) / 10;
         DCTextMng.setText(this.mTextField,"worldX = " + worldX + " worldY = " + worldY + " viewX = " + viewX + " viewY = " + viewY);
         this.mTextField.x = x - this.mTextField.width / 2;
         this.mTextField.y = y - 25;
      }
      
      override public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         var item:WorldItemObject = null;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate;
         (coor = getCoor()).x = x;
         coor.y = y;
         viewMng.screenToTileXY(coor,true);
         tileX = coor.x;
         tileY = coor.y;
         viewMng.tileXYToWorldPos(coor,false);
         var worldX:int = int(coor.x * 10) / 10;
         var worldY:int = int(coor.y * 10) / 10;
         coor.x = tileX;
         coor.y = tileY;
         viewMng.tileXYToWorldViewPos(coor,false);
         var str:String = "";
         var thisCoor:DCCoordinate = new DCCoordinate();
         coor.x = worldX;
         coor.y = worldY;
         viewMng.logicPosToTileRelativeXY(thisCoor);
         var tile:TileData;
         if((tile = smMapController.getTileDataFromTileXY(tileX,tileY)) != null)
         {
            str += " tileIndex = " + tile.mTileIndex;
            if((item = tile.mBaseItem) != null)
            {
               str += " item = " + item.mSid;
               if(Config.useUmbrella() && item.mUnit)
               {
                  str += " isProtected = " + InstanceMng.getUmbrellaMng().isUnitProtected(item.mUnit);
               }
            }
         }
         super.uiMouseUpCoors(x,y,tileX,tileY);
      }
      
      override protected function onMouseDoUpCoors(tileX:int, tileY:int) : Boolean
      {
         var item:WorldItemObject = null;
         var relTileX:int = 0;
         var relTileY:int = 0;
         var tile:TileData = smMapController.getTileDataFromTileXY(tileX,tileY);
         if(this.cursorDoIsApplicable(tile))
         {
         }
         if(tile != null && tile.mBaseItem != null)
         {
            item = tile.mBaseItem;
            tileX = int(smMapController.getTileRelativeXToTile(item.mTileRelativeX));
            tileY = int(smMapController.getTileRelativeYToTile(item.mTileRelativeY));
            relTileX = tile.getCol() - tileX;
            relTileY = tile.getRow() - tileY;
         }
         return true;
      }
   }
}
