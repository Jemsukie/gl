package com.dchoc.game.controller.map
{
   import com.dchoc.game.controller.tools.Tool;
   import com.dchoc.game.controller.world.item.actionsUI.ActionUI;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.rule.BackgroundDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.MapView;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import esparragon.utils.EUtils;
   
   public class MapControllerPlanet extends MapController
   {
      
      private static const TILES_SHAPE_OFFSETS:Array = [13,62,1,77];
      
      private static const SCROLL_OFF_TO_BE_ENABLED:int = 6;
      
      private static const MAX_CHECKS:int = 10;
       
      
      public var mMapViewDef:DCMapViewDef;
      
      public var mMapModel:MapModel;
      
      public var mMapViewPlanet:MapViewPlanet;
      
      private var mMapOffX:int;
      
      private var mMapOffY:int;
      
      private var mStageWidth:Number;
      
      private var mStageHeight:Number;
      
      private var mOriginalCenterCamPosCoords:DCCoordinate;
      
      protected var mCoor:DCCoordinate;
      
      private var mInternalTimer:int = 0;
      
      private var mToolExceptionAction:String;
      
      private var mToolExceptionSid:String;
      
      private var mToolExceptionEnabled:Boolean;
      
      public var mTilesCols:uint;
      
      public var mTilesRows:uint;
      
      public var mTilesCount:uint;
      
      private var mTilesIds:Vector.<int>;
      
      private var mTilesChangedIndex:Vector.<int>;
      
      protected var mUiTool:Tool;
      
      public var mUiCrossDO:DCDisplayObject;
      
      public var mUiCoor:DCCoordinate;
      
      private var mScrollIsBegun:Boolean;
      
      private var mScrollCheckStart:Boolean;
      
      private var mScrollMouseDownX:int;
      
      private var mScrollMouseDownY:int;
      
      private var mIsScrollAllowed:Boolean = true;
      
      private var mAutoScrollIsBegun:Boolean;
      
      protected var mAutoScrollCheckStart:Boolean;
      
      private var mPosX:Number;
      
      private var mPosY:Number;
      
      private var mFutureX:Number;
      
      private var mFutureY:Number;
      
      private var mVelocityX:Number;
      
      private var mVelocityY:Number;
      
      private var mDistanceX:Number;
      
      private var mDistanceY:Number;
      
      private var mCurrentTime:Number;
      
      private var mTotalTime:Number;
      
      private var mAccelerationX:Number;
      
      private var mAccelerationY:Number;
      
      private var mAcceleratedMotion:Boolean;
      
      private var mInitialPosition:DCCoordinate;
      
      private var mOldPosX:int;
      
      private var mOldPosY:int;
      
      private var mNumChecks:int;
      
      private var mBeforeAutoScrollCoords:DCCoordinate;
      
      private var mAutoScrollEventTarget:DCComponent;
      
      private var mAutoScrollEventCmd:String;
      
      public function MapControllerPlanet()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.tilesLoad();
            this.uiLoad();
            this.autoScrollReset();
            this.mCoor = new DCCoordinate();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.tilesUnload();
         this.uiUnload();
         this.mMapModel = null;
         this.mMapViewPlanet = null;
         this.mUiTool = null;
         this.mCoor = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var currProfileLoaded:Profile = null;
         if(step == 0)
         {
            currProfileLoaded = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
            if(this.mMapViewDef != null && InstanceMng.getRuleMng().filesIsFileLoaded("mapDefinitions.xml") && InstanceMng.getBackgroundController().isBuilt() && currProfileLoaded != null && currProfileLoaded.isBuilt())
            {
               this.tilesAssignMapSize();
               this.tilesBuild();
               buildAdvanceSyncStep();
               this.setOriginalCenterCamPos();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.tilesUnbuild();
      }
      
      override protected function beginDo() : void
      {
         var viewMng:ViewMngPlanet = null;
         this.scrollEnd();
         viewMng = InstanceMng.getViewMngPlanet();
         viewMng.worldBegin();
         var tutoRunning:Boolean = InstanceMng.getFlowStatePlanet().isTutorialRunning();
         var currentRoleIsTutorial:* = InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 5;
         var isPlayerBackFromVisiting:Boolean = InstanceMng.getFlowStatePlanet().isPlayerIsBackFromVisiting();
         if(tutoRunning && currentRoleIsTutorial && !isPlayerBackFromVisiting)
         {
            this.mCoor.x = -60;
            this.mCoor.y = -80;
            viewMng.tileRelativeXYToWorldViewPos(this.mCoor);
            viewMng.worldCameraCenterInPosition(this.mCoor.x - (this.mMapViewDef.mTileViewWidth >> 1),this.mCoor.y);
            this.mMapViewPlanet.startFade();
            Tool.tooltipsEnabled = false;
         }
         else
         {
            Tool.tooltipsEnabled = true;
            viewMng.worldCameraCenterInTileXY(this.getTileRelativeXToTile(0),this.getTileRelativeYToTile(0));
         }
         this.toolExceptionBegin();
         this.mInternalTimer = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mTilesChangedIndex.length > 0)
         {
            this.mMapViewPlanet.flush(this.mTilesIds,this.mTilesChangedIndex);
            this.mTilesChangedIndex.length = 0;
         }
         if(InstanceMng.getUnitScene().isFixedUnitDeltaTimeEnabled())
         {
            this.mInternalTimer += dt;
            while(this.mInternalTimer >= 50)
            {
               if(this.mAutoScrollCheckStart)
               {
                  this.updateCamPosition(50);
               }
               this.mInternalTimer -= 50;
            }
         }
         else if(this.mAutoScrollCheckStart)
         {
            if(dt < 10)
            {
               dt = 10;
            }
            if(dt > 100)
            {
               dt = 100;
            }
            this.updateCamPosition(dt);
         }
      }
      
      public function toolExceptionBegin() : void
      {
         this.mToolExceptionEnabled = false;
         this.mToolExceptionAction = null;
         this.mToolExceptionSid = null;
      }
      
      public function toolExceptionSet(exception:Object) : void
      {
         if(exception == null)
         {
            this.toolExceptionBegin();
         }
         else
         {
            this.mToolExceptionAction = exception.action;
            if(this.mToolExceptionAction == "")
            {
               this.mToolExceptionAction = null;
            }
            this.mToolExceptionSid = exception.sid;
            if(this.mToolExceptionSid == "")
            {
               this.mToolExceptionSid = null;
            }
            this.mToolExceptionEnabled = this.mToolExceptionAction != null || this.mToolExceptionSid != null;
         }
      }
      
      public function toolExceptionIsAllowed(actionUI:ActionUI, item:WorldItemObject) : Boolean
      {
         var sidAllowed:* = false;
         var actionAllowed:Boolean = false;
         var actionId:int = 0;
         var returnValue:*;
         if(!(returnValue = !this.mToolExceptionEnabled))
         {
            sidAllowed = true;
            if(this.mToolExceptionSid != null && item != null)
            {
               sidAllowed = this.mToolExceptionSid == item.mSid;
            }
            actionAllowed = true;
            if(this.mToolExceptionAction != null && actionUI != null)
            {
               actionId = actionUI.getActionId(item);
               var _loc7_:* = this.mToolExceptionAction;
               if("instant_build" === _loc7_)
               {
                  actionAllowed = actionId == 2 || actionId == 6;
               }
            }
            returnValue = sidAllowed && actionAllowed;
         }
         return returnValue;
      }
      
      public function getMapOffX() : int
      {
         return this.mMapOffX;
      }
      
      public function getMapOffY() : int
      {
         return this.mMapOffY;
      }
      
      public function setMapViewDef(value:DCMapViewDef) : void
      {
         this.mMapViewDef = value;
      }
      
      public function setMapModel(value:MapModel) : void
      {
         this.mMapModel = value;
      }
      
      override public function setMapView(value:MapView) : void
      {
         super.setMapView(value);
         this.mMapViewPlanet = MapViewPlanet(value);
      }
      
      public function flush() : void
      {
         this.mMapViewPlanet.flush(this.mTilesIds);
      }
      
      private function tilesLoad() : void
      {
         this.mTilesIds = new Vector.<int>(0);
         this.mTilesChangedIndex = new Vector.<int>(0);
      }
      
      private function tilesUnload() : void
      {
         this.mTilesIds = null;
         this.mTilesChangedIndex = null;
      }
      
      protected function tilesBuild() : void
      {
         var i:int = 0;
         var coor:DCCoordinate = null;
         var tileId:int = 0;
         for(i = 0; i < this.mTilesCount; )
         {
            tileId = 3;
            this.tilesModifyTile(i,tileId);
            i++;
         }
      }
      
      private function tilesUnbuild() : void
      {
         this.mTilesIds.length = 0;
         this.mTilesChangedIndex.length = 0;
      }
      
      public function tilesFlushChanged() : void
      {
         this.mTilesChangedIndex.length = 0;
      }
      
      public function tilesModifyTile(tileIndex:uint, tileId:int) : void
      {
         var pos:int = this.mTilesChangedIndex.indexOf(tileIndex);
         if(pos == -1)
         {
            this.mTilesChangedIndex.push(tileIndex);
         }
         this.mTilesIds[tileIndex] = tileId;
      }
      
      public function tilesShapeSetTile(tileIndex:int, tileArray:Vector.<int>, tileType:int) : void
      {
         var value:int = this.mTilesIds[tileIndex];
         var newTile:int = this.tilesGetShapeForm(tileIndex,tileType);
         var nextTile:int = tileIndex + 1;
         if(newTile != value && tileArray.indexOf(tileIndex) == -1)
         {
            this.tilesModifyTile(tileIndex,newTile);
            tileArray.push(tileIndex);
            this.tilesShapeCheckAdjacentTiles(tileIndex,tileArray,tileType);
         }
      }
      
      private function tilesShapeCheckAdjacentTiles(tileIndex:int, tileArray:Vector.<int>, tileType:int) : void
      {
         var nextTile:int = tileIndex + 1;
         if(this.tilesShapeIsInTheSameRow(tileIndex,nextTile,tileType))
         {
            this.tilesShapeSetTile(nextTile,tileArray,tileType);
         }
         nextTile = tileIndex - 1;
         if(this.tilesShapeIsInTheSameRow(tileIndex,nextTile,tileType))
         {
            this.tilesShapeSetTile(nextTile,tileArray,tileType);
         }
         nextTile = tileIndex - this.mTilesCols;
         if(this.tilesShapeIsInTheMap(nextTile,tileType))
         {
            this.tilesShapeSetTile(nextTile,tileArray,tileType);
         }
         nextTile = tileIndex + this.mTilesCols;
         if(this.tilesShapeIsInTheMap(nextTile,tileType))
         {
            this.tilesShapeSetTile(nextTile,tileArray,tileType);
         }
      }
      
      protected function tilesShapeIsInTheSameRow(tileIndex:int, nextTile:int, typeId:int) : Boolean
      {
         return int(tileIndex / this.mTilesCols) == int(nextTile / this.mTilesCols) && this.isIndexInMap(nextTile) && (this.mMapModel.mTilesData[nextTile] as TileData).getTypeId() == typeId;
      }
      
      protected function tilesShapeIsInTheMap(tileIndex:int, typeId:int) : Boolean
      {
         return this.isIndexInMap(tileIndex) && (this.mMapModel.mTilesData[tileIndex] as TileData).getTypeId() == typeId;
      }
      
      protected function tilesGetShapeForm(tileIndex:int, typeId:int) : int
      {
         var tileValue:int = 0;
         var tileId:int = tileIndex + 1;
         var tile:int = 15;
         var isLeft:Boolean = false;
         var isRight:Boolean = false;
         var isDown:Boolean = false;
         var isUp:Boolean = false;
         var isUpLeft:Boolean = false;
         var isUpRight:Boolean = false;
         var isDownLeft:Boolean = false;
         var isDownRight:Boolean = false;
         if(this.tilesShapeIsInTheSameRow(tileIndex,tileId,typeId))
         {
            isRight = true;
         }
         tileId = tileIndex - 1;
         if(this.tilesShapeIsInTheSameRow(tileIndex,tileId,typeId))
         {
            isLeft = true;
         }
         tileId = tileIndex - this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isUp = true;
         }
         tileId = tileIndex + this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isDown = true;
         }
         tileId = tileIndex - 1 - this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isUpLeft = true;
         }
         tileId = tileIndex + 1 - this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isUpRight = true;
         }
         tileId = tileIndex - 1 + this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isDownLeft = true;
         }
         tileId = tileIndex + 1 + this.mTilesCols;
         if(this.tilesShapeIsInTheMap(tileId,typeId))
         {
            isDownRight = true;
         }
         if(isRight)
         {
            tile = 12;
            if(isLeft)
            {
               tile = 10;
               if(isUp)
               {
                  tile = 19;
                  if(isDown)
                  {
                     tile = 16;
                     if(isUpLeft)
                     {
                        tile = 41;
                        if(isUpRight)
                        {
                           tile = 28;
                           if(isDownRight)
                           {
                              tile = 29;
                              if(isDownLeft)
                              {
                                 tile = 4;
                              }
                           }
                           else if(isDownLeft)
                           {
                              tile = 32;
                           }
                        }
                        else if(isDownRight)
                        {
                           tile = 45;
                           if(isDownLeft)
                           {
                              tile = 30;
                           }
                        }
                        else if(isDownLeft)
                        {
                           tile = 26;
                        }
                     }
                     else if(isUpRight)
                     {
                        tile = 44;
                        if(isDownRight)
                        {
                           tile = 25;
                           if(isDownLeft)
                           {
                              tile = 31;
                           }
                        }
                        else if(isDownLeft)
                        {
                           tile = 46;
                        }
                     }
                     else if(isDownRight)
                     {
                        tile = 43;
                        if(isDownLeft)
                        {
                           tile = 27;
                        }
                     }
                     else if(isDownLeft)
                     {
                        tile = 42;
                     }
                  }
                  else if(isUpLeft)
                  {
                     tile = 35;
                     if(isUpRight)
                     {
                        tile = 7;
                     }
                  }
                  else if(isUpRight)
                  {
                     tile = 39;
                  }
               }
               else if(isDown)
               {
                  tile = 20;
                  if(isDownLeft)
                  {
                     tile = 40;
                     if(isDownRight)
                     {
                        tile = 1;
                     }
                  }
                  else if(isDownRight)
                  {
                     tile = 36;
                  }
               }
            }
            else if(isUp)
            {
               tile = 23;
               if(isDown)
               {
                  tile = 18;
                  if(isUpRight)
                  {
                     tile = 34;
                     if(isDownRight)
                     {
                        tile = 3;
                     }
                  }
                  else if(isDownRight)
                  {
                     tile = 38;
                  }
               }
               else if(isUpRight)
               {
                  tile = 6;
               }
            }
            else if(isDown)
            {
               tile = 21;
               if(isDownRight)
               {
                  tile = 0;
               }
            }
         }
         else if(isLeft)
         {
            tile = 11;
            if(isUp)
            {
               tile = 24;
               if(isDown)
               {
                  tile = 17;
                  if(isUpLeft)
                  {
                     tile = 33;
                     if(isDownLeft)
                     {
                        tile = 5;
                     }
                  }
                  else if(isDownLeft)
                  {
                     tile = 37;
                  }
               }
               else if(isUpLeft)
               {
                  tile = 8;
               }
            }
            else if(isDown)
            {
               tile = 22;
               if(isDownLeft)
               {
                  tile = 2;
               }
            }
         }
         else if(isUp)
         {
            tile = 14;
            if(isDown)
            {
               tile = 9;
            }
         }
         else if(isDown)
         {
            tile = 13;
         }
         return tile + TILES_SHAPE_OFFSETS[typeId];
      }
      
      protected function tilesAssignMapSize() : void
      {
         var mapDefinition:XML = InstanceMng.getRuleMng().filesGetFileAsXML("mapDefinitions.xml");
         var bgDef:BackgroundDef = InstanceMng.getBackgroundController().getBackgroundDefForCurrentSituation();
         if(bgDef != null)
         {
            InstanceMng.getMapModel().setDeployAreas(bgDef.getDeployAreas());
         }
         var definitionXML:XML = EUtils.xmlGetChildrenListAsXML(mapDefinition,"Definition");
         var mapTilesWidth:int = EUtils.xmlReadInt(definitionXML,"numTilesWidth");
         var mapTilesHeight:int = EUtils.xmlReadInt(definitionXML,"numTilesHeight");
         this.tilesSetMapSize(mapTilesWidth,mapTilesHeight);
         this.mMapOffX = EUtils.xmlReadInt(definitionXML,"offX");
         this.mMapOffY = EUtils.xmlReadInt(definitionXML,"offY");
      }
      
      protected function tilesSetMapSize(cols:uint, rows:uint) : void
      {
         this.mTilesCols = cols;
         this.mTilesRows = rows;
         this.mTilesCount = this.mTilesCols * this.mTilesRows;
      }
      
      public function getTileXYToIndex(x:int, y:int, approx:Boolean = false) : int
      {
         if(approx)
         {
            if(x < 0)
            {
               x = 0;
            }
            else if(x >= this.mTilesCols)
            {
               x = this.mTilesCols - 1;
            }
            if(y < 0)
            {
               y = 0;
            }
            else if(y >= this.mTilesRows)
            {
               y = this.mTilesRows - 1;
            }
         }
         return x < 0 || x >= this.mTilesCols || y < 0 || y >= this.mTilesRows ? -1 : int(y * this.mTilesCols + x);
      }
      
      public function getIndexToTileXY(index:uint, coor:DCCoordinate = null) : DCCoordinate
      {
         if(coor == null)
         {
            coor = new DCCoordinate();
         }
         coor.x = index % this.mTilesCols;
         coor.y = Math.floor(index / this.mTilesCols);
         return coor;
      }
      
      public function getTileToTileRelativeX(tileX:uint) : int
      {
         return tileX - (this.mTilesCols >> 1);
      }
      
      public function getTileToTileRelativeY(tileY:uint) : int
      {
         return tileY - (this.mTilesRows >> 1);
      }
      
      public function getTileRelativeXToTile(tileRelativeX:int) : uint
      {
         return tileRelativeX + (this.mTilesCols >> 1);
      }
      
      public function getTileRelativeYToTile(tileRelativeY:int) : uint
      {
         return tileRelativeY + (this.mTilesRows >> 1);
      }
      
      public function getTileRelativeXYToIndex(tileRelativeX:int, tileRelativeY:int) : int
      {
         return this.getTileXYToIndex(this.getTileRelativeXToTile(tileRelativeX),this.getTileRelativeYToTile(tileRelativeY));
      }
      
      public function getIndexToTileRelativeXY(index:uint, coor:DCCoordinate = null) : DCCoordinate
      {
         this.getIndexToTileXY(index,coor);
         coor.x = this.getTileToTileRelativeX(coor.x);
         coor.y = this.getTileToTileRelativeY(coor.y);
         return coor;
      }
      
      public function isIndexInMap(tileIndex:int) : Boolean
      {
         return tileIndex > -1 && tileIndex < this.mTilesCount;
      }
      
      public function isTileXYInMap(tileX:int, tileY:int) : Boolean
      {
         return tileX > -1 && tileX < this.mTilesCols && tileY > -1 && tileY < this.mTilesRows;
      }
      
      public function isTileXYInMapWithFrame(tileX:int, tileY:int, frameCols:int, frameRows:int) : Boolean
      {
         return tileX > -1 + frameCols && tileX < this.mTilesCols - frameCols && tileY > -1 + frameRows && tileY < this.mTilesRows - frameRows;
      }
      
      public function getTileDataFromTileXY(x:uint, y:uint) : TileData
      {
         return this.isTileXYInMap(x,y) ? this.mMapModel.mTilesData[this.getTileXYToIndex(x,y)] : null;
      }
      
      public function getTileDataFromTileIndex(tileIndex:int) : TileData
      {
         return this.isIndexInMap(tileIndex) ? this.mMapModel.mTilesData[tileIndex] : null;
      }
      
      public function getTileXYToPos(coor:DCCoordinate, center:Boolean = false, transform:Boolean = true) : DCCoordinate
      {
         coor.x *= this.mMapViewDef.mTileLogicWidth;
         coor.z = -coor.y * this.mMapViewDef.mTileLogicHeight;
         coor.y = 0;
         if(center)
         {
            coor.x += this.mMapViewDef.mTileLogicWidth >> 1;
            coor.z -= this.mMapViewDef.mTileLogicHeight >> 1;
         }
         if(transform)
         {
            this.mMapViewDef.mPerspective.mapToScreen(coor);
         }
         return coor;
      }
      
      public function getLogicPosToTileXY(coor:DCCoordinate, decimals:Boolean = false, clamp:Boolean = false) : DCCoordinate
      {
         var x:Number = coor.x;
         var y:Number = coor.y;
         x /= this.mMapViewDef.mTileLogicWidth;
         y /= this.mMapViewDef.mTileLogicHeight;
         coor.x = x;
         coor.y = y;
         return coor;
      }
      
      public function getPosToTileXY(coor:DCCoordinate, decimals:Boolean = false, clamp:Boolean = false) : DCCoordinate
      {
         this.mMapViewDef.mPerspective.screenToMap(coor);
         var x:Number = coor.x;
         var y:Number = coor.y;
         x /= this.mMapViewDef.mTileLogicWidth;
         y = Math.abs(coor.z / this.mMapViewDef.mTileLogicHeight);
         if(!decimals)
         {
            x = Math.floor(x);
            y = Math.floor(y);
         }
         if(coor.z >= 0)
         {
            y = (y + 1) * -1;
         }
         if(clamp)
         {
            if(x < 0)
            {
               x = 0;
            }
            else if(x >= this.mTilesCols)
            {
               x = this.mTilesCols - 1;
            }
            if(y < 0)
            {
               y = 0;
            }
            else if(y >= this.mTilesRows)
            {
               y = this.mTilesRows - 1;
            }
         }
         coor.x = x;
         coor.y = y;
         return coor;
      }
      
      public function getPosToTileIndex(coor:DCCoordinate) : int
      {
         this.getPosToTileXY(coor);
         return this.getTileXYToIndex(coor.x,coor.y,false);
      }
      
      public function clampTileXY(coor:DCCoordinate) : Boolean
      {
         var x:Number = coor.x;
         var y:Number = coor.y;
         if(x < 0)
         {
            coor.x = 0;
         }
         else if(x >= this.mTilesCols)
         {
            coor.x = this.mTilesCols - 1;
         }
         if(y < 0)
         {
            coor.y = 0;
         }
         else if(y >= this.mTilesRows)
         {
            coor.y = this.mTilesRows - 1;
         }
         return x != coor.x || y != coor.y;
      }
      
      protected function uiLoad() : void
      {
         this.mUiCoor = new DCCoordinate();
      }
      
      protected function uiUnload() : void
      {
         this.mUiCoor = null;
         if(Config.DEBUG_MODE)
         {
            this.mUiCrossDO = null;
         }
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         if(this.mUiTool != null)
         {
            this.mUiTool.uiEnable();
         }
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         this.scrollEnd();
         if(this.mUiTool != null)
         {
            this.mUiTool.uiDisable(true);
         }
      }
      
      public function uiGetTool() : Tool
      {
         return this.mUiTool;
      }
      
      public function uiSetTool(tool:Tool) : void
      {
         this.mUiTool = tool;
      }
      
      public function uiGetToolId() : int
      {
         return this.mUiTool.mId;
      }
      
      public function uiMouseMoveCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var adx:Number = NaN;
         var ady:Number = NaN;
         if(this.mAutoScrollCheckStart)
         {
            return;
         }
         if(this.mScrollCheckStart)
         {
            dx = x - this.mScrollMouseDownX;
            dy = y - this.mScrollMouseDownY;
            if(!this.mScrollIsBegun)
            {
               adx = Math.abs(dx);
               ady = Math.abs(dy);
               if(adx > 6 || ady > 6)
               {
                  this.scrollBegin();
               }
            }
         }
         if(this.mScrollIsBegun)
         {
            this.mScrollMouseDownX = x;
            this.mScrollMouseDownY = y;
            this.mMapViewPlanet.mViewMngPlanet.worldCameraMove(-dx,-dy);
         }
         else if(this.mUiTool != null)
         {
            if(this.mUiTool.checkUiDisable(tileX,tileY))
            {
               this.mUiTool.uiDisable();
            }
            else if(!this.mUiTool.uiIsEnabled())
            {
               this.mUiTool.uiEnable();
            }
            this.mUiTool.uiMouseMoveCoors(x,y,tileX,tileY);
         }
      }
      
      public function uiMouseDownCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         if(this.mAutoScrollCheckStart)
         {
            return;
         }
         if(this.mAutoScrollCheckStart == false)
         {
            this.mScrollCheckStart = true;
         }
         this.mScrollCheckStart = this.mIsScrollAllowed;
         this.mScrollMouseDownX = x;
         this.mScrollMouseDownY = y;
         if(InstanceMng.getToolsMng().getCurrentToolId() == 15 || this.mUiTool != null && this.isTileXYInMap(tileX,tileY))
         {
            this.mUiTool.uiMouseDownCoors(tileX,tileY);
         }
      }
      
      public function uiMouseUpCoors(x:int, y:int, tileX:int, tileY:int) : void
      {
         if(this.mAutoScrollCheckStart)
         {
            return;
         }
         if(this.mScrollIsBegun)
         {
            this.scrollEnd();
         }
         else
         {
            this.mScrollCheckStart = false;
            if(this.mUiTool != null)
            {
               this.mUiTool.uiMouseUpCoors(x,y,tileX,tileY);
            }
         }
      }
      
      public function disableTooltips() : void
      {
         if(this.mUiTool != null)
         {
            this.mUiTool.setTooltipsEnabled(false);
         }
      }
      
      public function enableTooltips() : void
      {
         if(this.mUiTool != null)
         {
            this.mUiTool.setTooltipsEnabled(true);
         }
      }
      
      override public function onMouseOverCoors(tileX:int, tileY:int) : void
      {
         if(this.mUiTool != null)
         {
            if(!this.isTileXYInMap(tileX,tileY))
            {
               this.mUiTool.uiDisable();
            }
            else
            {
               if(!this.mUiTool.uiIsEnabled())
               {
                  this.mUiTool.uiEnable();
               }
               this.mUiTool.onMouseOverCoors(tileX,tileY);
            }
         }
      }
      
      override public function onMouseUpCoors(tileX:int, tileY:int) : void
      {
         if(this.mScrollIsBegun)
         {
            this.scrollEnd();
         }
         else
         {
            this.mScrollCheckStart = false;
            if(this.mUiTool != null && this.isTileXYInMap(tileX,tileY))
            {
               this.mUiTool.onMouseUpCoors(tileX,tileY);
            }
         }
      }
      
      public function setIsScrollAllowed(allow:Boolean) : void
      {
         this.mIsScrollAllowed = allow;
      }
      
      private function scrollBegin() : void
      {
         this.mScrollIsBegun = true;
         if(this.mUiTool != null)
         {
            this.mUiTool.uiDisable();
         }
         InstanceMng.getGUIControllerPlanet().cursorSetId(4);
         this.mMapViewPlanet.scrollBegin();
      }
      
      private function scrollEnd() : void
      {
         this.mScrollIsBegun = false;
         this.mScrollCheckStart = false;
         if(mUiEnabled)
         {
            if(this.mUiTool != null)
            {
               this.mUiTool.uiEnable();
            }
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),{"cmd":"NOTIFY_MAP_SCROLLEND"});
         }
         this.mMapViewPlanet.scrollEnd();
      }
      
      override public function hasScrollBegun() : Boolean
      {
         return this.mScrollIsBegun;
      }
      
      public function autoScrollReset() : void
      {
         this.mAutoScrollIsBegun = false;
         this.mAutoScrollCheckStart = false;
         this.mAutoScrollEventTarget = null;
         this.mAutoScrollEventCmd = null;
      }
      
      public function moveCameraTo(x:int, y:int, totalTime:Number, acceleration:Boolean = true, eventTarget:DCComponent = null, eventCmd:String = null) : void
      {
         var zoom:Number = InstanceMng.getViewMngPlanet().getZoom();
         x *= zoom;
         y *= zoom;
         this.mAutoScrollEventTarget = eventTarget;
         this.mAutoScrollEventCmd = eventCmd;
         this.mAcceleratedMotion = acceleration;
         this.mStageWidth = InstanceMng.getApplication().stageGetWidth();
         this.mStageHeight = InstanceMng.getApplication().stageGetHeight();
         this.mPosX = this.mMapViewPlanet.mViewMngPlanet.mWorldCameraX;
         this.mPosY = this.mMapViewPlanet.mViewMngPlanet.mWorldCameraY;
         this.mInitialPosition = new DCCoordinate(this.mPosX,this.mPosY);
         this.setBeforeAutoscrollCoords(this.mPosX + this.mStageWidth / 2,this.mPosY + this.mStageHeight / 2);
         this.mCurrentTime = 0;
         this.mTotalTime = DCTimerUtil.secondToMs(totalTime);
         this.mFutureX = x;
         this.mFutureY = y;
         this.mDistanceX = this.mFutureX - this.mStageWidth / 2 - this.mPosX;
         this.mDistanceY = this.mFutureY - this.mStageHeight / 2 - this.mPosY;
         if(this.mAcceleratedMotion == true)
         {
            this.mVelocityX = 2 * this.mDistanceX / this.mTotalTime;
            this.mVelocityY = 2 * this.mDistanceY / this.mTotalTime;
         }
         else
         {
            this.mVelocityX = this.mDistanceX / this.mTotalTime;
            this.mVelocityY = this.mDistanceY / this.mTotalTime;
         }
         this.mAccelerationX = -(this.mVelocityX / this.mTotalTime);
         this.mAccelerationY = -(this.mVelocityY / this.mTotalTime);
         this.mAutoScrollCheckStart = true;
         this.mOldPosX = -1;
         this.mOldPosY = -1;
      }
      
      public function centerCameraInHQ(travelTimeInSecs:int = 2, eventTarget:DCComponent = null, eventCmd:String = null) : void
      {
         var hq:WorldItemObject = InstanceMng.getWorld().itemsGetHeadquarters();
         this.moveCameraTo(hq.mViewCenterWorldX,hq.mViewCenterWorldY,travelTimeInSecs,true,eventTarget,eventCmd);
      }
      
      public function cameraHasReachedTheTarget() : Boolean
      {
         return !this.mAutoScrollCheckStart;
      }
      
      public function cameraIsThisPosTheTargetPos(targetX:int, targetY:int) : Boolean
      {
         return this.mFutureX == targetX && this.mFutureY == targetY;
      }
      
      public function cameraGetTargetX() : int
      {
         return this.mFutureX;
      }
      
      public function cameraGetTargetY() : int
      {
         return this.mFutureY;
      }
      
      public function getCoordsBeforeAutoscroll() : DCCoordinate
      {
         return this.mBeforeAutoScrollCoords;
      }
      
      protected function updateCamPosition(dt:Number) : void
      {
         this.mCurrentTime += dt;
         if(this.mAcceleratedMotion == true)
         {
            this.mPosX = this.mInitialPosition.x + this.mVelocityX * this.mCurrentTime + 0.5 * this.mAccelerationX * (this.mCurrentTime * this.mCurrentTime);
            this.mPosY = this.mInitialPosition.y + this.mVelocityY * this.mCurrentTime + 0.5 * this.mAccelerationY * (this.mCurrentTime * this.mCurrentTime);
         }
         else
         {
            this.mPosX = this.mInitialPosition.x + this.mVelocityX * this.mCurrentTime;
            this.mPosY = this.mInitialPosition.y + this.mVelocityY * this.mCurrentTime;
         }
         if(this.mCurrentTime >= this.mTotalTime)
         {
            this.mCurrentTime = this.mTotalTime;
            this.mPosX = this.mFutureX - this.mStageWidth / 2;
            this.mPosY = this.mFutureY - this.mStageHeight / 2;
            this.mAutoScrollCheckStart = false;
            if(this.mAutoScrollEventTarget != null)
            {
               InstanceMng.getNotifyMng().addEvent(this.mAutoScrollEventTarget,{"cmd":this.mAutoScrollEventCmd},true);
            }
         }
         this.mMapViewPlanet.mViewMngPlanet.worldCameraSetXY(this.mPosX,this.mPosY);
      }
      
      public function getBeforeAutoScrollCoords() : DCCoordinate
      {
         return this.mBeforeAutoScrollCoords;
      }
      
      private function setBeforeAutoscrollCoords(coordX:Number, coordY:Number) : void
      {
         if(this.mBeforeAutoScrollCoords == null)
         {
            this.mBeforeAutoScrollCoords = new DCCoordinate();
         }
         this.mBeforeAutoScrollCoords.x = coordX;
         this.mBeforeAutoScrollCoords.y = coordY;
      }
      
      protected function setOriginalCenterCamPos() : void
      {
         this.mOriginalCenterCamPosCoords = this.getCameraCenteredCoordinates();
      }
      
      public function getOriginalCenterCamPos() : DCCoordinate
      {
         return this.mOriginalCenterCamPosCoords;
      }
      
      public function getCameraCenteredCoordinates() : DCCoordinate
      {
         var viewMng:ViewMngPlanet;
         var camCenterX:Number = (viewMng = InstanceMng.getViewMngPlanet()).mWorldCameraX + this.mStageWidth / 2;
         var camCenterY:Number = viewMng.mWorldCameraY + this.mStageHeight / 2;
         return new DCCoordinate(camCenterX,camCenterY);
      }
   }
}
