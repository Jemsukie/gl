package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.map.MapController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.selectioncircle.ESelectionCircleMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   
   public class ToolSelectGroup extends Tool
   {
       
      
      private var mTileOriginX:int;
      
      private var mTileOriginY:int;
      
      private var mTileDestX:int;
      
      private var mTileDestY:int;
      
      private var mTileOldX:int;
      
      private var mTileOldY:int;
      
      private var mTileCountX:int;
      
      private var mTileCountY:int;
      
      private var mMapViewPlanet:MapViewPlanet;
      
      private var mMapController:MapController;
      
      private var mSelectionCircleMng:ESelectionCircleMng;
      
      private var mItemPreviousTileX:int;
      
      private var mItemPreviousTileY:int;
      
      private var mIsMoving:Boolean;
      
      private var mCanReleaseGroup:Boolean = true;
      
      private var mStartDrag:Boolean = false;
      
      private var multipleSelection:Boolean = false;
      
      private var lowLevelWalls:Vector.<WorldItemObject>;
      
      public function ToolSelectGroup(id:int, cursorAsAWhole:Boolean = false, cursorId:int = -1, actionId:int = -1, itemSelectedIsAllowed:Boolean = true, cursorDrawTileIsEnabled:Boolean = false)
      {
         super(id,cursorAsAWhole,cursorId,actionId,itemSelectedIsAllowed,cursorDrawTileIsEnabled);
         this.mMapViewPlanet = InstanceMng.getMapViewPlanet();
         this.mMapController = InstanceMng.getMapController();
         this.mSelectionCircleMng = InstanceMng.getSelectionCircleMng();
         mSelection = new Vector.<WorldItemObject>(0);
         this.mIsMoving = false;
      }
      
      private function selectItem(item:WorldItemObject) : void
      {
         if(item.isFlatBed())
         {
            item.viewLayersTypeRequiredSet(4,45);
         }
         else
         {
            item.viewLayersTypeRequiredSet(4,26);
         }
      }
      
      override public function onMouseDownCoors(tileX:int, tileY:int) : void
      {
         var item:WorldItemObject = null;
         if(mIsSelectionDone)
         {
            this.startMoving(tileX,tileY);
         }
         else
         {
            if(mItemSelected != null)
            {
               item = mItemSelected;
            }
            this.mTileOriginX = tileX;
            this.mTileOriginY = tileY;
            this.mTileDestX = tileX;
            this.mTileDestY = tileY;
            if(item != null && item.mDef.isAWall() && !this.multipleSelection)
            {
               if(this.isWallSelected(item))
               {
                  item.viewLayersTypeRequiredSet(4,2);
                  this.remove(mSelection,item);
                  if(!this.isSelectionMade())
                  {
                     this.mSelectionCircleMng.destroyPane();
                  }
               }
               else
               {
                  item.setOldTiles(item.mTileRelativeX,item.mTileRelativeY);
                  item.setOldWorldPos(item.mViewCenterWorldX,item.mViewCenterWorldY);
                  mSelection.push(item);
                  this.mSelectionCircleMng.destroyPane();
                  this.selectItem(item);
                  if(!this.mSelectionCircleMng.isPaneActive())
                  {
                     this.mSelectionCircleMng.createPane(item,null,"wall_select_upgrade");
                  }
               }
            }
            else
            {
               this.multipleSelection = true;
               if(this.isSelectionMade())
               {
                  for each(item in mSelection)
                  {
                     item.setOldTiles(item.mTileRelativeX,item.mTileRelativeY);
                     item.setOldWorldPos(item.mViewCenterWorldX,item.mViewCenterWorldY);
                  }
                  if(this.mSelectionCircleMng.isPaneActive())
                  {
                     this.mSelectionCircleMng.destroyPane();
                  }
                  this.multipleSelection = false;
               }
               if(!this.mIsMoving)
               {
                  this.mStartDrag = !this.mStartDrag;
               }
               if(this.mStartDrag)
               {
                  this.mTileOriginX = tileX;
                  this.mTileOriginY = tileY;
                  this.mTileDestX = tileX;
                  this.mTileDestY = tileY;
                  itemSelectedSetIsAllowed(false);
                  this.updateWallTiles();
               }
               else if(this.isSelectionMade())
               {
                  this.mMapViewPlanet.clearMap();
                  for each(item in mSelection)
                  {
                     this.selectItem(item);
                  }
                  if(!this.mSelectionCircleMng.isPaneActive())
                  {
                     this.mSelectionCircleMng.createPane(mSelection[0],null,"wall_select_upgrade");
                  }
               }
            }
         }
      }
      
      private function startMoving(tileX:int, tileY:int) : void
      {
         var items:Array = null;
         var item:WorldItemObject = new WorldItemObject();
         if(this.isSelectionMade())
         {
            this.mIsMoving = !this.mIsMoving;
            if(this.mIsMoving)
            {
               InstanceMng.getUIFacade().hideAllHUDElements(0.1);
               for each(item in mSelection)
               {
                  this.moveBegin(item);
               }
               this.mTileOldX = tileX;
               this.mTileOldY = tileY;
               this.moveItems(tileX,tileY);
            }
            else if(this.mCanReleaseGroup)
            {
               items = [];
               for each(item in mSelection)
               {
                  this.moveItemEnd(item);
                  items.push(item.mSid,item.mTileRelativeX,item.mTileRelativeY);
               }
               mSelection = new Vector.<WorldItemObject>(0);
               InstanceMng.getToolsMng().getCurrentTool().mIsSelectionDone = false;
               this.multipleSelection = false;
               InstanceMng.getUserDataMng().updateItem_moveAll(items);
            }
            else
            {
               this.mIsMoving = true;
            }
         }
         else
         {
            mSelection = new Vector.<WorldItemObject>(0);
            InstanceMng.getToolsMng().getCurrentTool().mIsSelectionDone = false;
            this.multipleSelection = false;
         }
      }
      
      private function updateWallTiles(setOldPos:Boolean = true) : void
      {
         var tileX:* = 0;
         var tileData:TileData = null;
         var item:WorldItemObject = null;
         var tileY:* = 0;
         var tilesCountX:int = this.mTileDestX - this.mTileOriginX;
         var tilesCountY:int = this.mTileDestY - this.mTileOriginY;
         var incrementX:* = tilesCountX;
         var incrementY:* = tilesCountY;
         tilesCountX = Math.abs(tilesCountX);
         tilesCountY = Math.abs(tilesCountY);
         var tileOriginX:int = this.mTileOriginX;
         var tileOriginY:int = this.mTileOriginY;
         var tileDestX:int = this.mTileDestX;
         var tileDestY:int = this.mTileDestY;
         if(incrementX < 0)
         {
            tileOriginX = this.mTileDestX;
            tileDestX = this.mTileOriginX;
         }
         if(incrementY < 0)
         {
            tileOriginY = this.mTileDestY;
            tileDestY = this.mTileOriginY;
         }
         this.mTileCountX = tilesCountX;
         this.mTileCountY = tilesCountY;
         this.mMapViewPlanet.clearMap();
         this.mMapViewPlanet.drawTilesArea(tileOriginX,tileOriginY,tilesCountX,tilesCountY);
         mSelection.length = 0;
         for(tileX = tileOriginX; tileX != tileDestX; )
         {
            for(tileY = tileOriginY; tileY != tileDestY; )
            {
               if(smMapController.isTileXYInMap(tileX,tileY))
               {
                  item = (tileData = smMapController.getTileDataFromTileXY(tileX,tileY)).mBaseItem;
                  if(item != null && item.mDef.isAWall())
                  {
                     this.mMapViewPlanet.drawItemBorder(item,65280,1);
                     if(setOldPos)
                     {
                        item.setOldTiles(item.mTileRelativeX,item.mTileRelativeY);
                        item.setOldWorldPos(item.mViewCenterWorldX,item.mViewCenterWorldY);
                     }
                     mSelection.push(item);
                  }
               }
               tileY++;
            }
            tileX++;
         }
      }
      
      private function isWallSelected(wioItem:WorldItemObject) : Boolean
      {
         var item:WorldItemObject = null;
         var returnVal:Boolean = false;
         for each(item in mSelection)
         {
            if(item == wioItem)
            {
               returnVal = true;
               break;
            }
         }
         return returnVal;
      }
      
      private function remove(data:Vector.<WorldItemObject>, object:WorldItemObject) : void
      {
         var index:int = data.indexOf(object);
         object = null;
         data.splice(index,1);
      }
      
      override protected function cursorIsEnabled() : Boolean
      {
         return true;
      }
      
      override protected function cursorMove(x:int, y:int, tileX:int, tileY:int) : void
      {
         if(this.mStartDrag)
         {
            this.mTileDestX = tileX;
            this.mTileDestY = tileY;
            this.updateWallTiles(false);
         }
         if(this.mIsMoving)
         {
            this.moveItems(tileX,tileY);
         }
      }
      
      private function moveBegin(item:WorldItemObject) : void
      {
         cursorEnd();
         itemSelectedSetIsAllowed(false);
         smMapController.mMapModel.placeUnplaceItem(item);
         item.moveBegin(false);
         this.mItemPreviousTileX = smMapController.getTileRelativeXToTile(item.mTileRelativeX);
         this.mItemPreviousTileY = smMapController.getTileRelativeYToTile(item.mTileRelativeY);
         cursorBegin();
      }
      
      private function moveItemEnd(item:WorldItemObject) : void
      {
         mApplyOnTile = null;
         itemSelectedSetIsAllowed(true);
         this.mItemPreviousTileX = -1;
         this.mItemPreviousTileY = -1;
         smMapController.mMapViewPlanet.gridEnd();
         item.moveEnd();
         InstanceMng.getUIFacade().showAllHUDElements();
         var e:Object = {};
         var subcmd:String = "MoveItem";
         e.item = item;
         e.cmd = "WorldEventPlaceItem";
         e.subcmd = subcmd;
         e.tileX = item.mTileRelativeX;
         e.tileY = item.mTileRelativeY;
         e.notifyServer = false;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorld(),e,true);
      }
      
      override public function getLowestLevelWalls() : Vector.<WorldItemObject>
      {
         var item:WorldItemObject = null;
         this.lowLevelWalls = new Vector.<WorldItemObject>(0);
         var min:int = mSelection[0].mDef.getUpgradeId();
         for each(item in mSelection)
         {
            if(item.mDef.getUpgradeId() < min)
            {
               min = item.mDef.getUpgradeId();
            }
         }
         for each(item in mSelection)
         {
            if(item.mDef.getUpgradeId() == min)
            {
               this.lowLevelWalls.push(item);
            }
         }
         return this.lowLevelWalls;
      }
      
      override public function destroySelection() : void
      {
         var item:WorldItemObject = null;
         this.mMapViewPlanet.clearMap();
         if(this.isSelectionMade())
         {
            for each(item in mSelection)
            {
               item.viewLayersTypeRequiredSet(4,2);
               if(mIsSelectionDone)
               {
                  item.mTileRelativeX = item.getOldTileX();
                  item.mTileRelativeY = item.getOldTileY();
                  item.viewSetBaseAtTile(item.mTileRelativeX,item.mTileRelativeY);
                  item.mViewCenterWorldX = item.getOldWorldPosX();
                  item.mViewCenterWorldY = item.getOldWorldPosY();
                  this.moveItemEnd(item);
               }
               else
               {
                  this.moveItemEnd(item);
               }
            }
            if(this.mSelectionCircleMng.isPaneActive())
            {
               this.mSelectionCircleMng.destroyPane();
            }
            mIsSelectionDone = false;
            this.mIsMoving = false;
            mSelection.length = 0;
         }
      }
      
      override public function isSelectionMade() : Boolean
      {
         return mSelection.length != 0;
      }
      
      private function moveItems(tileX:int, tileY:int) : void
      {
         var movedX:int = 0;
         var movedY:int = 0;
         var item:WorldItemObject = null;
         var tileData:TileData = null;
         if(this.mTileOldX != tileX || this.mTileOldY != tileY)
         {
            movedX = tileX - this.mTileOldX;
            movedY = tileY - this.mTileOldY;
            this.mTileOldX = tileX;
            this.mTileOldY = tileY;
            this.mMapViewPlanet.clearMap();
            this.mCanReleaseGroup = true;
            for each(item in mSelection)
            {
               tileX = smMapController.getTileRelativeXToTile(item.mTileRelativeX) + movedX;
               tileY = smMapController.getTileRelativeYToTile(item.mTileRelativeY) + movedY;
               item.setTileXY(tileX,tileY);
               if((tileData = smMapController.getTileDataFromTileXY(tileX,tileY)) == null || tileData != null && tileData.mBaseItem != null)
               {
                  item.viewLayersTypeRequiredSet(4,27);
                  this.mCanReleaseGroup = false;
               }
               else
               {
                  this.selectItem(item);
               }
            }
         }
      }
   }
}
