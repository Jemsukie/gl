package com.dchoc.game.model.map
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.pathfinder.PathFinderWithArrays;
   import com.dchoc.game.model.rule.RebornObstaclesDefMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   import com.dchoc.toolkit.utils.astar.DCAstar;
   import com.dchoc.toolkit.utils.astar.DCPath;
   import com.dchoc.toolkit.utils.astar.DCSearchable;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.utils.xml.DCXMLUtil;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class MapModel extends DCComponent implements DCSearchable
   {
      
      private static const PERSISTENCE_ENABLED:Boolean = true;
      
      private static const PATHFINDER_WEIGHT_NONE:int = 0;
      
      private static const PATHFINDER_WEIGHT_EMPTY:int = 1;
      
      private static const PATHFINDER_WEIGHT_BUSY:int = 100;
      
      private static const PATHFINDER_WEIGHT_WALL:int = 5;
      
      private static const PATHFINDER_WEIGHT_DECORATION:int = 5;
      
      private static const PATHFINDER_TILES_TYPE_NONE:int = 0;
      
      private static const PATHFINDER_TILES_TYPE_EMPTY:int = 1;
      
      private static const PATHFINDER_TILES_TYPE_BUSY:int = 2;
      
      private static const PATHFINDER_TILES_TYPE_WALL:int = 3;
      
      private static const PATHFINDER_TILES_TYPE_WALL_CORNER:int = 4;
      
      private static const PATHFINDER_TILES_TYPE_DECORATION:int = 5;
      
      private static const PATHFINDER_TILES_WEIGHTS:Array = [0,1,100,5,5];
      
      private static const PATHFINDER_TILE_WEIGHTS_NO_WALLS:Array = [0,1,100,1,1,5];
      
      private static const PATHFINDER_TILE_WEIGHTS_NO_DECOS:Array = [0,1,100,5,5,1];
      
      private static const PATHFINDER_TILES_TYPES_NEED_TO_CHECK_ITEM_TO_STEP:Array = [false,false,true,true,true,false];
      
      private static const PATHFINDER_MAX_PATHS_PER_TICK:int = 1;
      
      public static const EVENT_MAP_MODEL_ADD_TILE:int = 0;
      
      public static const EVENT_MAP_MODEL_REMOVE_TILE:int = 1;
       
      
      private var mSid:String;
      
      public var mMapController:MapControllerPlanet;
      
      private var mWorld:World;
      
      private var mCoor:DCCoordinate;
      
      private var mWorldItemDefMng:WorldItemDefMng;
      
      private var mAstar:DCAstar;
      
      public var mAstarStartItem:WorldItemObject;
      
      private var mStartTile:TileData;
      
      private var mGoalTile:TileData;
      
      private var mLastPath:DCPath;
      
      private var mLastItemClicked:WorldItemObject;
      
      private var mLogicTilesTypes:Vector.<String>;
      
      private var mLogicTilesData:Vector.<Vector.<int>>;
      
      private var LOGIC_TILES_TYPES:Vector.<String>;
      
      private var mItemTileDatas:Vector.<TileData>;
      
      public var mTilesData:Vector.<TileData>;
      
      public var mPathFinderTileTypes:Vector.<int>;
      
      private var mPathFinder:PathFinderWithArrays;
      
      private var mPathsToSolve:Vector.<Object>;
      
      private var mPathFinderGenericPath:Vector.<int>;
      
      private var mPathLatestRequestByUnits:Dictionary;
      
      private var mProfilerInfo:Object;
      
      private var mObstaclesCreated:Boolean = false;
      
      private var mObstaclesCount:int;
      
      private var mObstaclesCreationDenied:Boolean = false;
      
      private var mDeployAreas:Array;
      
      public function MapModel()
      {
         this.LOGIC_TILES_TYPES = new <String>["Road","Terrain","NoPlayable","Plot"];
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mCoor = new DCCoordinate();
            this.astarLoad();
            this.tilesDataLoad();
            this.logicTilesLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mCoor = null;
         this.astarUnload();
         this.tilesDataUnload();
         this.logicTilesUnload();
         this.mMapController = null;
         this.mWorld = null;
         this.mWorldItemDefMng = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var e:Object = null;
         switch(step)
         {
            case 0:
               this.mWorldItemDefMng = InstanceMng.getWorldItemDefMng();
               this.mMapController = InstanceMng.getMapControllerPlanet();
               if(this.mMapController != null)
               {
                  if(this.mMapController.isBuilt())
                  {
                     this.mWorld = InstanceMng.getWorld();
                     buildAdvanceSyncStep();
                  }
               }
               else
               {
                  e = {
                     "cmd":"eventAbortApplication",
                     "msg":"A MapController must be assigned to MapModel before building it."
                  };
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getApplication(),e);
                  if(Config.DEBUG_ASSERTS)
                  {
                     DCDebug.trace(e.msg,3);
                  }
               }
               break;
            case 1:
               if(mPersistenceData != null)
               {
                  this.mSid = EUtils.xmlReadString(mPersistenceData,"sid");
                  this.tilesDataBuild();
                  this.logicTilesBuild();
                  this.mObstaclesCount = 0;
                  this.mObstaclesCreated = false;
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mAstarStartItem = null;
         this.tilesDataUnbuild();
         this.logicTilesUnbuild();
         this.mObstaclesCreated = false;
         this.mObstaclesCreationDenied = false;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         this.pathFinderLogicUpdate(dt);
         var obstacles:int = InstanceMng.getUserInfoMng().getProfileLogin().getCountObstaclesToCreate();
         if(obstacles > 0)
         {
            this.createObstacles(obstacles);
            if(this.mObstaclesCreated || this.mObstaclesCreationDenied)
            {
               InstanceMng.getUserInfoMng().getProfileLogin().setCountObstaclesToCreate(0);
               if(!this.mObstaclesCreationDenied)
               {
                  this.mObstaclesCreated = false;
               }
            }
         }
      }
      
      public function setMapController(value:MapControllerPlanet) : void
      {
         this.mMapController = value;
      }
      
      private function astarLoad() : void
      {
         this.mAstar = new DCAstar(this);
      }
      
      private function astarUnload() : void
      {
         this.mAstar.unload();
         this.mAstar = null;
      }
      
      public function getNodeTransitionCost(n1:DCAStarNode, n2:DCAStarNode) : Number
      {
         return 1;
      }
      
      public function getNode(col:int, row:int) : DCAStarNode
      {
         return this.getTileData(col,row);
      }
      
      public function getTileData(col:int, row:int) : TileData
      {
         var index:int = this.mMapController.getTileXYToIndex(col,row);
         return this.getTileDataFromIndex(index);
      }
      
      public function getTileDataFromIndex(tileIndex:int) : TileData
      {
         var returnValue:TileData = null;
         if(this.mMapController.isIndexInMap(tileIndex))
         {
            returnValue = this.mTilesData[tileIndex];
         }
         return returnValue;
      }
      
      public function getCols() : int
      {
         return this.mMapController.mTilesCols;
      }
      
      public function getRows() : int
      {
         return this.mMapController.mTilesRows;
      }
      
      private function logicTilesLoad() : void
      {
         var typesCount:int = 0;
         var i:int = 0;
         this.mLogicTilesTypes = this.logicTilesGetTypes();
         if(this.mLogicTilesTypes != null)
         {
            typesCount = int(this.mLogicTilesTypes.length);
            this.mLogicTilesData = new Vector.<Vector.<int>>(typesCount);
            for(i = 0; i < typesCount; )
            {
               this.mLogicTilesData[i] = new Vector.<int>(0);
               i++;
            }
         }
      }
      
      protected function logicTilesGetTypes() : Vector.<String>
      {
         return this.LOGIC_TILES_TYPES;
      }
      
      private function logicTilesUnload() : void
      {
         if(this.mLogicTilesTypes != null)
         {
            this.mLogicTilesTypes = null;
            this.mLogicTilesData = null;
         }
      }
      
      private function logicTilesBuild() : void
      {
         var tilesStr:String = null;
         var tiles:Array = null;
         var coors:Array = null;
         var x:int = 0;
         var y:int = 0;
         var tileIndex:uint = 0;
         var typeId:int = 0;
         var xmlList:XMLList = null;
         var itemXML:XML = null;
         var i:String = null;
         if(this.mLogicTilesTypes != null)
         {
            for(typeId = this.mLogicTilesTypes.length - 1; typeId > -1; )
            {
               xmlList = EUtils.xmlGetChildrenList(mPersistenceData,this.mLogicTilesTypes[typeId]);
               for each(itemXML in xmlList)
               {
                  tiles = (tilesStr = EUtils.xmlReadString(itemXML,"chunk")).split(",");
                  for each(i in tiles)
                  {
                     if(i != "")
                     {
                        coors = i.split(":");
                        x = parseInt(coors[0]);
                        y = parseInt(coors[1]);
                        tileIndex = uint(this.mMapController.getTileRelativeXYToIndex(x,y));
                        this.logicTilesAddTile(tileIndex,typeId,false);
                     }
                  }
               }
               typeId--;
            }
         }
      }
      
      private function logicTilesUnbuild() : void
      {
         var typeId:int = 0;
         if(this.mLogicTilesTypes != null)
         {
            for(typeId = this.mLogicTilesTypes.length - 1; typeId > -1; )
            {
               this.mLogicTilesData[typeId].length = 0;
               typeId--;
            }
         }
      }
      
      private function logicTilesAddTile(tileIndex:int, typeId:int, effective:Boolean = true) : void
      {
         var tileData:TileData = null;
         var tilesArray:Vector.<int> = null;
         var str:* = null;
         if(this.mMapController.isIndexInMap(tileIndex) && typeId >= 0 && typeId < this.mLogicTilesData.length)
         {
            this.mLogicTilesData[typeId].push(tileIndex);
            (tileData = this.mTilesData[tileIndex]).setTypeId(typeId);
            switch(typeId - 1)
            {
               case 0:
                  this.mMapController.tilesModifyTile(tileIndex,2);
                  break;
               case 1:
                  this.mMapController.tilesModifyTile(tileIndex,-1);
                  break;
               default:
                  tilesArray = new Vector.<int>(0);
                  this.mMapController.tilesShapeSetTile(tileIndex,tilesArray,typeId);
            }
            if(effective && this.logicTilesTypeNeedsPersistence(typeId))
            {
               this.mMapController.getIndexToTileRelativeXY(tileIndex,this.mCoor);
            }
            if(tileData.canBeStepped())
            {
               this.logicTilesLoopNeighbours(tileIndex,this.logicTilesRegisterItem);
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            str = "";
            if(!this.mMapController.isIndexInMap(tileIndex))
            {
               str += " tileIndex  doesn\'t belong to the map";
            }
            if(!(typeId >= 0 && typeId < this.mLogicTilesData.length))
            {
               str += " / typeId " + typeId + " is not a valid type";
            }
            DCDebug.trace("ERROR in MapModel.logicTilesAddTile: tileIndex " + tileIndex + " is not allowed to be added to the map: " + str,1);
         }
      }
      
      private function logicTilesRemoveTile(tileIndex:int, typeId:int, effective:Boolean = true) : void
      {
         var pos:int = 0;
         var tileData:TileData = null;
         var unregister:Boolean = false;
         var newType:int = 0;
         var tilesArray:Vector.<int> = null;
         if(this.mMapController.isIndexInMap(tileIndex) && typeId >= 0 && typeId < this.mLogicTilesData.length)
         {
            if((pos = this.mLogicTilesData[typeId].indexOf(tileIndex)) > -1)
            {
               this.mLogicTilesData[typeId].splice(pos,1);
               unregister = (tileData = this.mTilesData[tileIndex]).canBeStepped();
               newType = typeId == 0 || typeId == 3 ? 1 : 2147483647;
               tileData.setTypeId(newType);
               this.mMapController.tilesModifyTile(tileIndex,3);
               if(typeId == 0)
               {
                  tilesArray = new Vector.<int>(0);
                  this.mMapController.tilesShapeSetTile(tileIndex,tilesArray,typeId);
               }
               this.mMapController.tilesModifyTile(tileIndex,3);
               if(effective && this.logicTilesTypeNeedsPersistence(typeId))
               {
                  this.mMapController.getIndexToTileRelativeXY(tileIndex,this.mCoor);
               }
               this.logicTilesAddTile(tileIndex,newType,false);
               if(unregister)
               {
                  this.logicTilesLoopNeighbours(tileIndex,this.logicTilesUnregisterItem);
               }
            }
         }
      }
      
      private function logicTilesTypeNeedsPersistence(typeId:int) : Boolean
      {
         return typeId == 2 || this.needsToBeNotifiedToServer(typeId);
      }
      
      private function logicTilesPersistenceGetData(persistence:XML) : void
      {
         var tiles:Vector.<String> = null;
         var tileData:TileData = null;
         var str:String = null;
         var xmlStr:* = null;
         var xml:XML = null;
         var xmlUtil:DCXMLUtil = null;
         var i:int = 0;
         var tileIndex:int = 0;
         if(this.mLogicTilesTypes != null)
         {
            tiles = new Vector.<String>(0);
            for(i = this.mLogicTilesTypes.length - 1; i > -1; )
            {
               if(this.logicTilesTypeNeedsPersistence(i))
               {
                  tiles.length = 0;
                  for each(tileIndex in this.mLogicTilesData[i])
                  {
                     tileData = this.mTilesData[tileIndex];
                     if(i != 0 || i == 0 && tileData.mBaseItem == null)
                     {
                        this.mMapController.getIndexToTileRelativeXY(tileIndex,this.mCoor);
                        str = this.mCoor.x + ":" + this.mCoor.y;
                        if(tiles.indexOf(str) == -1)
                        {
                           tiles.push(str);
                        }
                     }
                  }
                  xmlStr = "<" + this.mLogicTilesTypes[i] + "/>";
                  xml = EUtils.stringToXML(xmlStr);
                  (xmlUtil = new DCXMLUtil(xml,tiles)).addToXML(persistence);
               }
               i--;
            }
         }
      }
      
      private function logicTilesLoopNeighbours(tileIndex:int, thisFunction:Function) : void
      {
         var tile:TileData = this.mTilesData[tileIndex];
         var index:int = tileIndex - 1;
         this.logicTilesRegisterOnNeighbour(index,tile,thisFunction);
         index = tileIndex - this.mMapController.mTilesCols;
         this.logicTilesRegisterOnNeighbour(index,tile,thisFunction);
         index = tileIndex + 1;
         this.logicTilesRegisterOnNeighbour(index,tile,thisFunction);
         index = tileIndex + this.mMapController.mTilesCols;
         this.logicTilesRegisterOnNeighbour(index,tile,thisFunction);
      }
      
      private function logicTilesRegisterOnNeighbour(index:int, tileRoad:TileData, thisFunction:Function) : void
      {
         var tileData:TileData = null;
         var item:WorldItemObject = null;
         if(this.mMapController.isIndexInMap(index))
         {
            (tileData = this.mTilesData[index]).setNeighbors(null);
            if((item = tileData.mBaseItem) != null)
            {
               thisFunction(item,tileRoad);
            }
         }
      }
      
      private function logicTilesRegisterItem(item:WorldItemObject, tile:TileData) : void
      {
         if(item.mDef.usesPath())
         {
            item.pathRegisterTile(tile);
         }
      }
      
      private function logicTilesUnregisterItem(item:WorldItemObject, tile:TileData) : void
      {
         if(item.mDef.usesPath())
         {
            item.pathUnregisterTile(tile);
         }
      }
      
      public function logicTilesCanBeStepped(tileIndex:int) : Boolean
      {
         var tileType:int = this.mPathFinderTileTypes[tileIndex];
         if(tileType == 4)
         {
            return false;
         }
         if(this.mMapController.isIndexInMap(tileIndex) && PATHFINDER_TILES_TYPES_NEED_TO_CHECK_ITEM_TO_STEP[tileType])
         {
            return TileData(this.mTilesData[tileIndex]).canBeStepped(true);
         }
         return true;
      }
      
      public function isAWall(tileIndex:int) : Boolean
      {
         var baseItem:WorldItemObject = null;
         var returnValue:Boolean = false;
         if(this.mMapController.isIndexInMap(tileIndex) && PATHFINDER_TILES_TYPES_NEED_TO_CHECK_ITEM_TO_STEP[this.mPathFinderTileTypes[tileIndex]])
         {
            baseItem = TileData(this.mTilesData[tileIndex]).mBaseItem;
            returnValue = baseItem != null && baseItem.mDef.isAWall();
         }
         return returnValue;
      }
      
      override public function persistenceGetData() : XML
      {
         var str:* = "<Map sid=\"" + this.mSid + "\"/>";
         var persistence:XML = EUtils.stringToXML(str);
         this.logicTilesPersistenceGetData(persistence);
         return persistence;
      }
      
      private function placeLoopTilesData(item:WorldItemObject, process:Function) : void
      {
         var i:* = 0;
         var tileIndex:int = 0;
         var tileData:TileData = null;
         var j:* = 0;
         var tileX:int = int(this.mMapController.getTileRelativeXToTile(item.mTileRelativeX));
         var tileY:int = int(this.mMapController.getTileRelativeYToTile(item.mTileRelativeY));
         var canBeStepped:Boolean = false;
         var lastCol:int = item.getBaseCols() - 1;
         var lastRow:int = item.getBaseRows() - 1;
         var stepablePerimeter:int = item.mDef.getStepablePerimeter();
         var lastColStepable:* = lastCol;
         var lastRowStepable:* = lastRow;
         if(stepablePerimeter > 0)
         {
            lastColStepable -= stepablePerimeter - 1;
            lastRowStepable -= stepablePerimeter - 1;
         }
         for(i = lastCol; i > -1; )
         {
            for(j = lastRow; j > -1; )
            {
               canBeStepped = this.mWorldItemDefMng.isTileXYStepable(item,i,j) || stepablePerimeter > 0 && (i < stepablePerimeter || i >= lastColStepable || (j < stepablePerimeter || j >= lastRowStepable));
               if((tileIndex = this.mMapController.getTileXYToIndex(tileX + i,tileY + j)) > -1)
               {
                  tileData = this.mTilesData[tileIndex];
                  process(tileData,item,canBeStepped);
               }
               j--;
            }
            i--;
         }
      }
      
      private function getTypeWeightTileIndexBecauseOfBaseItem(tileIndex:int) : int
      {
         var tileData:TileData = null;
         var item:WorldItemObject = null;
         var tileX:int = 0;
         var tileY:int = 0;
         var coor:DCCoordinate = null;
         var tileIndexX:int = 0;
         var tileIndexY:int = 0;
         var canBeStepped:Boolean = false;
         var lastCol:int = 0;
         var lastRow:int = 0;
         var stepablePerimeter:int = 0;
         var lastColStepable:* = 0;
         var lastRowStepable:* = 0;
         var returnValue:int = 0;
         if(this.mMapController.isIndexInMap(tileIndex))
         {
            item = (tileData = this.mTilesData[tileIndex]).mBaseItem;
            if(item != null)
            {
               tileX = int(this.mMapController.getTileRelativeXToTile(item.mTileRelativeX));
               tileY = int(this.mMapController.getTileRelativeYToTile(item.mTileRelativeY));
               coor = MyUnit.smCoor;
               this.mMapController.getIndexToTileXY(tileIndex,coor);
               tileIndexX = coor.x - tileX;
               tileIndexY = coor.y - tileY;
               canBeStepped = false;
               lastCol = item.getBaseCols() - 1;
               lastRow = item.getBaseRows() - 1;
               stepablePerimeter = item.mDef.getStepablePerimeter();
               lastColStepable = lastCol;
               lastRowStepable = lastRow;
               if(stepablePerimeter > 0)
               {
                  lastColStepable -= stepablePerimeter - 1;
                  lastRowStepable -= stepablePerimeter - 1;
               }
               returnValue = (canBeStepped = this.mWorldItemDefMng.isTileXYStepable(item,tileIndexX,tileIndexY) || stepablePerimeter > 0 && (tileIndexX < stepablePerimeter || tileIndexX >= lastColStepable || (tileIndexY < stepablePerimeter || tileIndexY >= lastRowStepable))) ? 1 : this.pathFinderGetWeightTypeByDef(item.mDef);
            }
         }
         return returnValue;
      }
      
      public function placeIsPlaceable(tileX:int, tileY:int, cols:int, rows:int) : Boolean
      {
         var tileIndex:int = 0;
         var tileData:TileData = null;
         var i:int = 0;
         var j:int = 0;
         var returnValue:Boolean = false;
         returnValue = true;
         for(i = cols - 1; i > -1; )
         {
            for(j = rows - 1; j > -1; )
            {
               if((tileIndex = this.mMapController.getTileXYToIndex(tileX + i,tileY + j)) <= -1)
               {
                  return false;
               }
               if((tileData = this.mTilesData[tileIndex]) == null || !tileData.canBePlacedIn())
               {
                  return false;
               }
               j--;
            }
            i--;
         }
         return returnValue;
      }
      
      public function placeIsItemDefPlaceable(itemDef:WorldItemDef, tileX:int, tileY:int) : Boolean
      {
         return this.placeIsPlaceable(tileX,tileY,itemDef.getBaseCols(),itemDef.getBaseRows());
      }
      
      public function placeIsItemPlaceable(item:WorldItemObject, tileX:int, tileY:int) : Boolean
      {
         return this.placeIsPlaceable(tileX,tileY,item.getBaseCols(),item.getBaseRows());
      }
      
      public function placePlaceItem(item:WorldItemObject, isForBuffer:Boolean = false, forcePlacing:Boolean = false) : Boolean
      {
         var i:int = 0;
         var col:int = int(this.mMapController.getTileRelativeXToTile(item.mTileRelativeX));
         var row:int = int(this.mMapController.getTileRelativeYToTile(item.mTileRelativeY));
         var returnValue:* = this.placeIsItemPlaceable(item,col,row);
         if(forcePlacing)
         {
            returnValue = true;
         }
         if(returnValue == false)
         {
            i = 0;
         }
         if(isForBuffer)
         {
            returnValue = isForBuffer;
         }
         if(returnValue)
         {
            if(this.mAstarStartItem == null && item.mDef.isHeadQuarters())
            {
               this.mAstarStartItem = item;
            }
            if(item.mDef.mTypeId == 12)
            {
               this.mObstaclesCount++;
            }
            this.placeLoopTilesData(item,this.placeAddItemToMap);
            if(item.mDef.isAWall())
            {
               this.wallSetCorners(item,4);
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("ERROR in MapModel.placePlaceItem: item " + item.mSid + " is not allowed to be placed in map",1);
         }
         return returnValue;
      }
      
      private function wallSetCorners(item:WorldItemObject, tileType:int) : void
      {
         var col:int = int(this.mMapController.getTileRelativeXToTile(item.mTileRelativeX));
         var row:int = int(this.mMapController.getTileRelativeYToTile(item.mTileRelativeY));
         var tileIndex:int = this.mMapController.getTileXYToIndex(col,row - 1);
         this.wallSetCorner(tileIndex,tileType);
         tileIndex = this.mMapController.getTileXYToIndex(col,row + 1);
         this.wallSetCorner(tileIndex,tileType);
         tileIndex = this.mMapController.getTileXYToIndex(col - 1,row);
         this.wallSetCorner(tileIndex,tileType);
         tileIndex = this.mMapController.getTileXYToIndex(col + 1,row);
         this.wallSetCorner(tileIndex,tileType);
      }
      
      private function wallSetCorner(tileIndex:int, tileType:int) : void
      {
         if(this.mMapController.isIndexInMap(tileIndex))
         {
            if(tileType == 4)
            {
               if(this.wallCheckIfMakesACorner(tileIndex))
               {
                  this.pathFinderSetWeight(tileIndex,tileType);
               }
            }
            else if(this.mPathFinderTileTypes[tileIndex] == 4 && !this.wallCheckIfMakesACorner(tileIndex))
            {
               this.pathFinderSetWeight(tileIndex,this.getTypeWeightTileIndexBecauseOfBaseItem(tileIndex));
            }
         }
      }
      
      public function wallCheckIfMakesACorner(tileIndex:int, v:Vector.<int> = null) : Boolean
      {
         var coor:DCCoordinate = null;
         var tileData:TileData = null;
         var baseItem:WorldItemObject = null;
         var col:int = 0;
         var row:int = 0;
         var tileIndexLeft:int = 0;
         var tileIndexUp:int = 0;
         var tileIndexDown:int = 0;
         var tileIndexRight:int = 0;
         var returnValue:Boolean = false;
         if(tileIndex > -1)
         {
            coor = MyUnit.smCoor;
            this.mMapController.getIndexToTileXY(tileIndex,coor);
            col = coor.x;
            row = coor.y;
            tileIndexLeft = this.mMapController.getTileXYToIndex(col - 1,row);
            tileIndexUp = this.mMapController.getTileXYToIndex(col,row - 1);
            if(v != null)
            {
               v.length = 0;
            }
            if(returnValue = this.wallCheckIfMakeACornerBetweenTwoTiles(tileIndexLeft,tileIndexUp))
            {
               if(v != null)
               {
                  v.push(tileIndexLeft);
                  v.push(tileIndexUp);
               }
            }
            else
            {
               tileIndexDown = this.mMapController.getTileXYToIndex(col,row + 1);
               if(returnValue = this.wallCheckIfMakeACornerBetweenTwoTiles(tileIndexLeft,tileIndexDown))
               {
                  if(v != null)
                  {
                     v.push(tileIndexLeft);
                     v.push(tileIndexDown);
                  }
               }
               else
               {
                  tileIndexRight = this.mMapController.getTileXYToIndex(col + 1,row);
                  if(returnValue = this.wallCheckIfMakeACornerBetweenTwoTiles(tileIndexDown,tileIndexRight))
                  {
                     if(v != null)
                     {
                        v.push(tileIndexDown);
                        v.push(tileIndexRight);
                     }
                  }
                  else if((returnValue = this.wallCheckIfMakeACornerBetweenTwoTiles(tileIndexUp,tileIndexRight)) && v != null)
                  {
                     v.push(tileIndexUp);
                     v.push(tileIndexRight);
                  }
               }
            }
         }
         return returnValue;
      }
      
      private function wallCheckIfMakeACornerBetweenTwoTiles(tileIndex1:int, tileIndex2:int) : Boolean
      {
         var tileData:TileData = null;
         var baseItem:WorldItemObject = null;
         var returnValue:Boolean = false;
         if(tileIndex1 > -1 && tileIndex2 > -1)
         {
            if((baseItem = (tileData = this.mTilesData[tileIndex1]).mBaseItem) != null && baseItem.mDef.isAWall() && this.mPathFinderTileTypes[tileIndex1] == 3)
            {
               returnValue = (baseItem = (tileData = this.mTilesData[tileIndex2]).mBaseItem) != null && baseItem.mDef.isAWall() && this.mPathFinderTileTypes[tileIndex2] == 3;
            }
         }
         return returnValue;
      }
      
      public function placeUnplaceItem(item:WorldItemObject) : void
      {
         this.placeLoopTilesData(item,this.placeRemoveItemFromMap);
         if(item.mDef.isAWall())
         {
            this.wallSetCorners(item,0);
         }
      }
      
      private function placeAddItemToMap(tileData:TileData, item:WorldItemObject, canBeStepped:Boolean = false) : void
      {
         tileData.setBaseItem(item,canBeStepped);
         var weight:int = canBeStepped || item.isBroken() ? 1 : this.pathFinderGetWeightTypeByDef(item.mDef);
         this.pathFinderSetWeight(tileData.mTileIndex,weight,item);
      }
      
      private function placeRemoveItemFromMap(tileData:TileData, item:WorldItemObject, canBeStepped:Boolean = false) : void
      {
         tileData.setBaseItem(null);
         this.mPathFinderTileTypes[tileData.mTileIndex] = 0;
         this.wallSetCorner(tileData.mTileIndex,4);
      }
      
      public function placeGetItemTileDatas(item:WorldItemObject) : Vector.<TileData>
      {
         if(this.mItemTileDatas == null)
         {
            this.mItemTileDatas = new Vector.<TileData>(0);
         }
         else
         {
            this.mItemTileDatas.length = 0;
         }
         this.placeLoopTilesData(item,this.placePushTileDataStep);
         return this.mItemTileDatas;
      }
      
      private function placePushTileDataStep(tileData:TileData, item:WorldItemObject, canBeStepped:Boolean = false) : void
      {
         if(canBeStepped)
         {
            this.mItemTileDatas.push(tileData);
         }
      }
      
      private function tilesDataLoad() : void
      {
         this.mTilesData = new Vector.<TileData>(0);
         this.pathFinderLoad();
      }
      
      private function tilesDataUnload() : void
      {
         this.mTilesData = null;
         this.pathFinderUnload();
      }
      
      private function tilesDataBuild() : void
      {
         var i:int = 0;
         var tilesCount:int = int(this.mMapController.mTilesCount);
         for(i = 0; i < tilesCount; )
         {
            this.mMapController.getIndexToTileXY(i,this.mCoor);
            this.mTilesData.push(new TileData(this.mCoor.x,this.mCoor.y,i,1));
            this.mPathFinderTileTypes[i] = 0;
            i++;
         }
         this.pathFinderBuild();
      }
      
      private function tilesDataUnbuild() : void
      {
         var tileData:TileData = null;
         if(this.mTilesData != null)
         {
            while(this.mTilesData.length > 0)
            {
               tileData = this.mTilesData.shift();
               tileData.unload();
            }
         }
         this.pathFinderUnbuild();
      }
      
      public function tilesDataApplyFunc(tileX:int, tileY:int, tileCols:int, tileRows:int, centered:Boolean, func:Function, ... args) : void
      {
         var i:int = 0;
         var tileIndex:int = 0;
         var tileData:TileData = null;
         var j:int = 0;
         if(centered)
         {
            tileX -= tileCols >> 1;
            tileY -= tileRows >> 1;
         }
         var appliedItemSids:Array = [];
         var sid:String = null;
         for(i = tileCols - 1; i > -1; )
         {
            for(j = tileRows - 1; j > -1; )
            {
               if((tileIndex = this.mMapController.getTileXYToIndex(tileX + i,tileY + j)) > -1)
               {
                  if((tileData = this.mTilesData[tileIndex]) != null)
                  {
                     if(tileData.mBaseItem != null)
                     {
                        sid = tileData.mBaseItem.mSid;
                        if(appliedItemSids.indexOf(sid) == -1)
                        {
                           appliedItemSids.push(sid);
                           func(tileData,args);
                        }
                     }
                  }
               }
               j--;
            }
            i--;
         }
      }
      
      private function pathFinderLoad() : void
      {
         this.mPathFinderTileTypes = new Vector.<int>(0);
         this.mPathFinder = new PathFinderWithArrays();
         this.mPathsToSolve = new Vector.<Object>(0);
      }
      
      private function pathFinderUnload() : void
      {
         this.mPathFinderTileTypes = null;
         if(this.mPathFinder != null)
         {
            this.mPathFinder.unload();
            this.mPathFinder = null;
         }
         if(this.mPathsToSolve != null)
         {
            this.mPathsToSolve = null;
         }
         this.mPathFinderGenericPath = null;
      }
      
      private function pathFinderBuild() : void
      {
         if(this.mPathFinderGenericPath == null)
         {
            this.mPathFinderGenericPath = new Vector.<int>(this.mMapController.mTilesCount);
         }
         this.mPathFinder.init(this.mMapController.mTilesCols,this.mMapController.mTilesRows,this.mPathFinderTileTypes);
         this.mPathLatestRequestByUnits = new Dictionary(false);
      }
      
      private function pathFinderUnbuild() : void
      {
         this.mPathsToSolve.length = 0;
         this.mPathLatestRequestByUnits = null;
      }
      
      public function pathFinderGetWeight(tileIndex:int) : int
      {
         return this.mPathFinderTileTypes[tileIndex];
      }
      
      private function pathFinderSetWeight(tileIndex:int, tileType:int, item:WorldItemObject = null) : void
      {
         var str:String = null;
         this.mPathFinderTileTypes[tileIndex] = tileType;
         if(Config.DEBUG_MODE && this.mPathFinderTileTypes[tileIndex] > 0)
         {
            str = "weight[" + tileIndex + "] = " + this.mPathFinderTileTypes[tileIndex];
            if(this.mTilesData[tileIndex].mBaseItem != null)
            {
               str += " baseITem = " + this.mTilesData[tileIndex].mBaseItem.mSid;
            }
         }
      }
      
      private function pathFinderGetWeightTypeByDef(def:WorldItemDef) : int
      {
         var returnValue:int = 2;
         if(def.isAWall())
         {
            returnValue = 3;
         }
         else if(def.isAMine())
         {
            returnValue = 1;
         }
         else if(def.canBeStepped())
         {
            returnValue = 5;
         }
         else
         {
            returnValue = 2;
         }
         return returnValue;
      }
      
      public function pathFinderRequestPath(request:Object) : void
      {
         var enqueue:Boolean = true;
         var u:MyUnit = request.unit;
         if(u != null)
         {
            if(this.mPathLatestRequestByUnits[u.mId] != null)
            {
               enqueue = false;
            }
            this.mPathLatestRequestByUnits[u.mId] = request;
         }
         if(enqueue)
         {
            if(request.priority == null || request.priority == 0)
            {
               this.mPathsToSolve.push(request);
            }
            else
            {
               this.mPathsToSolve.unshift(request);
            }
         }
      }
      
      public function pathFinderResetRequestPath(uId:int) : void
      {
         var request:Object = this.mPathLatestRequestByUnits[uId];
         if(request != null)
         {
            request.invalid = true;
         }
      }
      
      public function pathFinderLogicUpdate(dt:int) : void
      {
         var r:Object = null;
         var listener:DCComponent = null;
         var u:MyUnit = null;
         var indexSource:int = 0;
         var map:Vector.<int> = null;
         var array:Array = null;
         var length:int = int(this.mPathsToSolve.length);
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate = MyUnit.smCoor;
         var i:int = 0;
         while(i < length && i < 1)
         {
            r = this.mPathsToSolve.shift();
            if((u = r.unit) != null)
            {
               r = this.mPathLatestRequestByUnits[u.mId];
            }
            if(r.invalid == true)
            {
               i--;
            }
            else
            {
               r.cmd = "MapModelEventPathResolved";
               map = this.mPathFinderTileTypes;
               array = PATHFINDER_TILES_WEIGHTS;
               if(u == null || u.isBuilt())
               {
                  if(u != null)
                  {
                     if(u.isAllowedToStepWalls())
                     {
                        array = PATHFINDER_TILE_WEIGHTS_NO_WALLS;
                     }
                     else if(u.mFaction == 0)
                     {
                        array = PATHFINDER_TILE_WEIGHTS_NO_DECOS;
                     }
                  }
                  if(r.recalculateTileIndexSource)
                  {
                     coor.x = u.mPosition.x;
                     coor.y = u.mPosition.y;
                     viewMng.logicPosToViewPos(coor);
                     viewMng.worldViewPosToTileXY(coor);
                     indexSource = this.mMapController.getTileXYToIndex(coor.x,coor.y,true);
                  }
                  else
                  {
                     indexSource = int(r.tileIndexSource);
                  }
                  if(!u.isAllowedToStepWalls() && !this.logicTilesCanBeStepped(indexSource))
                  {
                     r.complete = false;
                     this.mPathFinderGenericPath[0] = 2;
                     this.mPathFinderGenericPath[1] = indexSource;
                     this.mPathFinderGenericPath[2] = -1;
                  }
                  else
                  {
                     r.complete = this.mPathFinder.findPath(indexSource,r.tileIndexDest,this.mPathFinderGenericPath,100,r.itemFrom,r.itemTo,r.ignoreItems,map,array);
                  }
                  r.path = this.mPathFinderGenericPath;
                  r.listener.notify(r);
               }
            }
            length = int(this.mPathsToSolve.length);
            if(u != null)
            {
               this.mPathLatestRequestByUnits[u.mId] = null;
            }
            i++;
         }
      }
      
      private function itemSetBaseType(item:WorldItemObject, typeId:int) : void
      {
         var i:* = 0;
         var tileIndex:int = 0;
         var j:* = 0;
         var tileX:int = int(this.mMapController.getTileRelativeXToTile(item.mTileRelativeX));
         var tileY:int = int(this.mMapController.getTileRelativeYToTile(item.mTileRelativeY));
         var stepablePerimeter:int = item.mDef.getStepablePerimeter();
         var lastColStepable:int = item.getBaseCols() - 1;
         var lastRowStepable:int = item.getBaseRows() - 1;
         if(stepablePerimeter > 0)
         {
            lastColStepable -= stepablePerimeter - 1;
            lastRowStepable -= stepablePerimeter - 1;
         }
         for(i = lastColStepable; i > -1; )
         {
            for(j = lastRowStepable; j > -1; )
            {
               tileIndex = this.mMapController.getTileXYToIndex(tileX + i,tileY + j);
               if(typeId == 2)
               {
                  if(this.mWorldItemDefMng.isTileXYStepable(item,i,j))
                  {
                     typeId = 1;
                  }
               }
               this.pathFinderSetWeight(tileIndex,typeId,item);
               j--;
            }
            i--;
         }
         if(item.mDef.isAWall())
         {
            if(typeId == 1)
            {
               this.wallSetCorners(item,1);
            }
            else
            {
               this.wallSetCorners(item,4);
            }
         }
      }
      
      public function itemSetBaseEmpty(item:WorldItemObject) : void
      {
         this.itemSetBaseType(item,1);
      }
      
      public function itemSetBaseBusy(item:WorldItemObject) : void
      {
         this.itemSetBaseType(item,this.pathFinderGetWeightTypeByDef(item.mDef));
      }
      
      private function needsToBeNotifiedToServer(typeId:int) : Boolean
      {
         return typeId == 0;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = true;
         switch(e.cmd)
         {
            case 0:
               if(e.typeId == 2)
               {
                  if(this.mMapController.isIndexInMap(e.tileIndex))
                  {
                     this.logicTilesRemoveTile(e.tileIndex,TileData(this.mTilesData[e.tileIndex]).getTypeId());
                  }
                  else if(Config.DEBUG_ASSERTS)
                  {
                     DCDebug.trace("WARNING in MapModel.notify(): Tile <" + e.tileIndex + "> is required to be NOT PLAYABLE, but that index is out of bounds",1);
                  }
               }
               this.logicTilesAddTile(e.tileIndex,e.typeId);
               break;
            case 1:
               this.logicTilesRemoveTile(e.tileIndex,e.typeId);
               break;
            default:
               returnValue = false;
         }
         return returnValue;
      }
      
      public function createObstacles(forceCreateObstacles:int = 0, notifyServer:Boolean = true) : void
      {
         var profile:Profile = null;
         var count:int = 0;
         var maxObstacles:int = 0;
         var items:Vector.<WorldItemObject> = null;
         var starType:int = 0;
         var itemsDef:Vector.<WorldItemDef> = null;
         var obstacleDef:WorldItemDef = null;
         var tileX:int = 0;
         var tileY:int = 0;
         var totalObstacles:int = 0;
         var tries:int = 0;
         var mapTilesCols:int = 0;
         var mapTilesRows:int = 0;
         var i:int = 0;
         var isRoleOwner:* = InstanceMng.getRole().mId == 0;
         var tutoRunning:Boolean = InstanceMng.getFlowStatePlanet().isTutorialRunning();
         var goOn:Boolean = (!this.mObstaclesCreated || forceCreateObstacles != 0) && isRoleOwner && tutoRunning == false;
         var rebornDefMng:RebornObstaclesDefMng = InstanceMng.getRebornObstaclesDefMng();
         var bgControllerBuild:Boolean = InstanceMng.getBackgroundController().isBuilt();
         if(rebornDefMng.isBuilt() && bgControllerBuild && goOn)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            count = forceCreateObstacles != 0 ? forceCreateObstacles : rebornDefMng.getObstaclesCount(profile.getLastVisit());
            maxObstacles = InstanceMng.getSettingsDefMng().mSettingsDef.getMaxObstacles();
            items = InstanceMng.getWorld().itemsGetAllObstacles();
            starType = InstanceMng.getApplication().goToGetCurrentStarType();
            this.mObstaclesCount = items.length;
            if(count > 0 && this.mObstaclesCount < maxObstacles)
            {
               if((itemsDef = InstanceMng.getBackgroundController().getObstaclesForCurrentBackground()) != null && itemsDef.length != 0)
               {
                  DCDebug.trace("Creating obstacles");
                  this.mObstaclesCreated = true;
                  totalObstacles = int(itemsDef.length);
                  mapTilesCols = int(this.mMapController.mTilesCols);
                  mapTilesRows = int(this.mMapController.mTilesRows);
                  for(i = 0; i < count; )
                  {
                     obstacleDef = itemsDef[int(Math.random() * totalObstacles)] as WorldItemDef;
                     tileX = Math.random() * (mapTilesCols - obstacleDef.getBaseCols());
                     tileY = Math.random() * (mapTilesRows - obstacleDef.getBaseRows());
                     if(this.placeIsItemDefPlaceable(obstacleDef,tileX,tileY))
                     {
                        this.mWorld.itemsPlaceItem(obstacleDef.mSku,null,tileX,tileY,"AddItem",notifyServer);
                        this.mObstaclesCount++;
                        if(this.mObstaclesCount == maxObstacles)
                        {
                           return;
                        }
                     }
                     else
                     {
                        tries++;
                        i--;
                        if(tries > 100)
                        {
                           tries = 0;
                           i++;
                        }
                     }
                     i++;
                  }
               }
               else
               {
                  this.mObstaclesCreationDenied = true;
               }
            }
            else
            {
               this.mObstaclesCreationDenied = true;
            }
         }
      }
      
      public function removeObstaclesFromScene() : void
      {
         var item:WorldItemObject = null;
         var t:Transaction = null;
         var items:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllObstacles();
         DCDebug.trace("Removing obstacles");
         for each(item in items)
         {
            t = InstanceMng.getRuleMng().getTransactionDemolishEnd(item.mDef,null);
            item.setTransaction(t);
            InstanceMng.getWorld().itemsUnplaceItem(item,true);
            InstanceMng.getItemsMng().getCollectionItemsParticleByAction(item.mDef.mSku,"recycle",item.mViewCenterWorldX,item.mViewCenterWorldY,item.mUpgradeId);
         }
      }
      
      public function getRebornObstaclesAvailable() : Vector.<WorldItemDef>
      {
         var i:int = 0;
         var obstacle:WorldItemDef = null;
         var itemsDef:Vector.<DCDef> = InstanceMng.getWorldItemDefMng().getDefsFromTypeId(12);
         var obstacles:Vector.<WorldItemDef> = new Vector.<WorldItemDef>(0);
         for(i = 0; i < itemsDef.length; )
         {
            if((obstacle = itemsDef[i] as WorldItemDef).getCanReborn())
            {
               obstacles.push(obstacle);
            }
            i++;
         }
         return obstacles;
      }
      
      public function setDeployAreas(areas:Array) : void
      {
         this.mDeployAreas = areas;
      }
      
      public function getDeployAreas() : Array
      {
         return this.mDeployAreas;
      }
      
      public function isInDeployArea(tileX:int, tileY:int) : Boolean
      {
         var area:Array = null;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coor:DCCoordinate = new DCCoordinate(tileX,tileY,0);
         viewMng.tileXYToWorldPos(coor,false);
         for each(area in this.mDeployAreas)
         {
            if(coor.x >= area[0] && coor.x <= area[2] && coor.y >= area[1] && coor.y <= area[3])
            {
               return true;
            }
         }
         return false;
      }
      
      public function testIsPlaceable() : void
      {
         var obstacleDef:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySku("o_001_003") as WorldItemDef;
         var seed:Number = 0.5;
         var mapTilesCols:int = int(this.mMapController.mTilesCols);
         var mapTilesRows:int = int(this.mMapController.mTilesRows);
         var tileX:int = seed * (mapTilesCols - obstacleDef.getBaseCols());
         var tileY:int = seed * (mapTilesRows - obstacleDef.getBaseRows());
         var resultPlace:Boolean = this.placeIsItemDefPlaceable(obstacleDef,tileX,tileY);
      }
   }
}
