package com.dchoc.game.model.unit
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   import com.dchoc.toolkit.utils.astar.DCPath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class Path
   {
      
      public static const PATH_TYPE_NORMAL:uint = 0;
      
      public static const PATH_TYPE_LOOP:uint = 2;
      
      private static var smMapControllerRef:MapControllerPlanet;
      
      private static var smViewMngPlanet:ViewMngPlanet;
      
      public static const PATH_EVENT_ARRIVAL:String = "Arrival";
       
      
      public var mWaypoints:Vector.<DCCoordinate>;
      
      public var mWaypointsTileDatas:Vector.<TileData>;
      
      public var mIndex:int;
      
      public var mType:uint;
      
      protected var mStopped:Boolean;
      
      public var mReverseOrder:Boolean;
      
      private var mEvents:Dictionary;
      
      public function Path()
      {
         super();
         if(smMapControllerRef == null)
         {
            smMapControllerRef = InstanceMng.getMapControllerPlanet();
         }
         if(smViewMngPlanet == null)
         {
            smViewMngPlanet = InstanceMng.getViewMngPlanet();
         }
      }
      
      public static function unloadStatic() : void
      {
         smMapControllerRef = null;
         smViewMngPlanet = null;
      }
      
      public function reset() : void
      {
         this.mStopped = this.mWaypoints == null || this.mWaypoints.length == 0;
         this.mIndex = 0;
         this.mEvents = new Dictionary();
         this.mReverseOrder = false;
      }
      
      public function build(path:Vector.<DCCoordinate> = null, type:uint = 0) : void
      {
         this.mWaypoints = path;
         this.mType = type;
         this.reset();
      }
      
      public function buildFromSearchResults(results:DCPath, reversePath:Boolean = false, type:uint = 0) : void
      {
         var nodeArray:Array = null;
         var node:DCAStarNode = null;
         var i:int = 0;
         var loopCheck:Function = null;
         var loopInc:Function = null;
         if(results != null)
         {
            nodeArray = results.getNodes();
            loopCheck = function(i:int):Boolean
            {
               return reversePath ? i >= 0 : i < nodeArray.length;
            };
            loopInc = function(i:int):int
            {
               return reversePath ? i - 1 : i + 1;
            };
            i = int(reversePath ? nodeArray.length - 1 : 0);
            while(Boolean(loopCheck(i)))
            {
               node = nodeArray[i];
               this.addWaypointFromTileXY(node.getCol(),node.getRow());
               i = int(loopInc(i));
            }
            this.mType = type;
            this.reset();
         }
      }
      
      private function buildLoopCheck(i:int, reversePath:Boolean, nodesLength:int) : Boolean
      {
         return reversePath ? i >= 0 : i < nodesLength;
      }
      
      private function buildLoopInc(i:int, reversePath:Boolean) : int
      {
         return reversePath ? i - 1 : i + 1;
      }
      
      public function buildFromPoints(path:Vector.<int>, tileIndexDest:int, complete:Boolean, reversePath:Boolean = false, type:uint = 0, itemFrom:WorldItemObject = null, itemTo:WorldItemObject = null, mPosition:Vector3D = null, stopInWalls:Boolean = true) : void
      {
         var tileData:TileData = null;
         var i:* = 0;
         var itemToDismiss:* = null;
         var tileItem:WorldItemObject = null;
         var addWp:Boolean = false;
         var coor2:DCCoordinate = null;
         var destTileX:int = 0;
         var destTileY:int = 0;
         var currentTileIndex:int = 0;
         var offX:int = 0;
         var offY:int = 0;
         var diff:int = 0;
         var minDiff:* = 0;
         var minIndex:* = 0;
         var clamped:Boolean = false;
         var nodesLength:* = path[0];
         var firstIndex:* = int(reversePath ? nodesLength - 1 : 0);
         if(smMapControllerRef == null)
         {
            smMapControllerRef = InstanceMng.getMapControllerPlanet();
         }
         var mapModel:MapModel;
         var tiles:Vector.<TileData> = (mapModel = smMapControllerRef.mMapModel).mTilesData;
         var coor:DCCoordinate = MyUnit.smCoor;
         var tileIndex:int = -99;
         var item:* = null;
         if(!complete && false)
         {
            smMapControllerRef.getIndexToTileXY(currentTileIndex,coor);
            destTileX = coor.x;
            destTileY = coor.y;
            minDiff = 2147483647;
            for(i = 1; i < nodesLength; )
            {
               currentTileIndex = path[i];
               smMapControllerRef.getIndexToTileXY(currentTileIndex,coor);
               offX = coor.x - destTileX;
               offY = coor.y - destTileY;
               if((diff = offX * offX + offY * offY) < minDiff)
               {
                  minDiff = diff;
                  minIndex = i;
               }
               i++;
            }
            if(reversePath)
            {
               firstIndex = minIndex;
            }
            else
            {
               nodesLength = minIndex;
            }
         }
         i = firstIndex;
         if(itemFrom == null && mPosition != null)
         {
            coor.x = mPosition.x;
            coor.y = mPosition.y;
            coor.z = 0;
            coor = smViewMngPlanet.logicPosToTileXY(coor,false);
            clamped = smMapControllerRef.clampTileXY(coor);
            (coor2 = this.addWaypointFromTileXY(coor.x,coor.y)).x = mPosition.x;
            coor2.y = mPosition.y;
            if(!clamped && nodesLength > 1)
            {
               i = this.buildLoopInc(i,reversePath);
            }
         }
         while(this.buildLoopCheck(i,reversePath,nodesLength))
         {
            if(itemToDismiss == null)
            {
               if(itemTo != null)
               {
                  itemToDismiss = itemTo;
               }
               else
               {
                  itemToDismiss = itemFrom;
               }
            }
            tileIndex = path[i + 1];
            if(smMapControllerRef.isIndexInMap(tileIndex))
            {
               tileItem = (tileData = tiles[tileIndex]).mBaseItem;
               addWp = true;
               if(tileItem != null)
               {
                  if(tileItem == itemToDismiss)
                  {
                     item = itemToDismiss;
                     addWp = false;
                  }
                  else if(item != null)
                  {
                     smMapControllerRef.getIndexToTileXY(path[i],coor);
                     this.addWaypointFromTileXY(coor.x,coor.y);
                     item = null;
                     itemToDismiss = itemFrom;
                  }
               }
               if(addWp)
               {
                  smMapControllerRef.getIndexToTileXY(tileIndex,coor);
                  coor2 = this.addWaypointFromTileXY(coor.x,coor.y);
               }
               if(stopInWalls && mapModel.isAWall(tileIndex))
               {
                  break;
               }
            }
            i = this.buildLoopInc(i,reversePath);
         }
         this.mType = type;
         this.reset();
      }
      
      public function unbuild() : void
      {
         if(this.mWaypoints != null)
         {
            this.mWaypoints.length = 0;
            this.mWaypointsTileDatas.length = 0;
         }
         this.mStopped = true;
         if(Config.DEBUG_PATHS)
         {
            this.updateView();
         }
      }
      
      public function addWaypointFromTileXY(col:int, row:int) : DCCoordinate
      {
         if(!this.mWaypoints)
         {
            this.mWaypoints = new Vector.<DCCoordinate>(0);
            this.mWaypointsTileDatas = new Vector.<TileData>(0);
         }
         this.mWaypointsTileDatas.push(smMapControllerRef.getTileDataFromTileXY(col,row));
         var worldCoords:DCCoordinate = new DCCoordinate(col,row);
         InstanceMng.getViewMngPlanet().tileXYToWorldPos(worldCoords,true);
         this.mWaypoints.push(worldCoords);
         return worldCoords;
      }
      
      private function getTypename(type:uint) : String
      {
         switch(int(type))
         {
            case 0:
               return "Normal";
            case 2:
               return "Loop";
            default:
               return "";
         }
      }
      
      public function setType(type:uint) : void
      {
         this.mType = type;
      }
      
      public function getWorldCoords(i:int) : DCCoordinate
      {
         if(this.mWaypoints != null && this.mWaypoints.length > 0 && i >= 0 && i < this.mWaypoints.length)
         {
            return this.mWaypoints[i];
         }
         return null;
      }
      
      public function isNotEmpty() : Boolean
      {
         return this.getPathLength() > 0;
      }
      
      public function getPathLength() : int
      {
         return !!this.mWaypoints ? int(this.mWaypoints.length) : 0;
      }
      
      public function advance() : void
      {
         if(this.mWaypoints && this.mWaypoints.length > 0 && !this.mStopped)
         {
            switch(int(this.mType))
            {
               case 0:
                  this.mIndex = this.mReverseOrder ? this.mIndex - 1 : this.mIndex + 1;
                  if(this.mReverseOrder && this.mIndex < 0)
                  {
                     this.endPath(0,false);
                  }
                  if(!this.mReverseOrder && this.mIndex == this.mWaypoints.length)
                  {
                     this.endPath(this.mWaypoints.length - 1,true);
                  }
                  break;
               case 2:
                  this.mIndex++;
                  if(this.mIndex == this.mWaypoints.length)
                  {
                     this.mIndex = 0;
                     break;
                  }
            }
         }
      }
      
      public function finished() : Boolean
      {
         return this.mStopped;
      }
      
      public function currentWaypoint() : DCCoordinate
      {
         if(this.mWaypoints && this.mWaypoints.length > 0)
         {
            return this.mWaypoints[this.mIndex];
         }
         return null;
      }
      
      public function currentWaypointAsWorldCoord() : DCCoordinate
      {
         if(this.mWaypoints && this.mWaypoints.length > 0)
         {
            return this.mWaypoints[this.mIndex];
         }
         return null;
      }
      
      public function currentWaypointIndex() : int
      {
         return !!this.mWaypoints ? this.mIndex : -1;
      }
      
      public function setWaypointIndex(value:int) : void
      {
         this.mIndex = value;
      }
      
      public function isCurrentWaypointThePenultimate() : Boolean
      {
         return this.mReverseOrder && this.mIndex == 1 || !this.mReverseOrder && this.mIndex == this.mWaypoints.length - 1;
      }
      
      private function endPath(newIndex:int, reversePath:Boolean) : void
      {
         var execCallback:Function = null;
         var params:Object = null;
         this.mIndex = newIndex;
         this.mReverseOrder = reversePath;
         this.stop();
         if(this.mEvents["Arrival"] != null)
         {
            execCallback = this.mEvents["Arrival"]["callback"];
            params = this.mEvents["Arrival"]["params"];
            execCallback(params);
         }
      }
      
      public function stop() : void
      {
         this.mStopped = true;
      }
      
      public function start() : void
      {
         this.mStopped = false;
      }
      
      public function addEvent(msg:String, eventData:Object) : void
      {
         this.mEvents[msg] = eventData;
      }
      
      public function removeEvent(msg:String) : void
      {
         if(this.mEvents != null && this.mEvents[msg] != null)
         {
            delete this.mEvents[msg];
         }
      }
      
      public function updateView(pointColor:uint = 16776960, lineColor:uint = 52224) : void
      {
         this.drawPath(pointColor,lineColor);
      }
      
      public function drawPath(pointColor:uint = 16776960, lineColor:uint = 16763904) : void
      {
         var waypointCoor:DCCoordinate = null;
         var i:int = 0;
         var sprite:Sprite = InstanceMng.getUnitScene().debugGetSprite(this,"debugPath");
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var coords:DCCoordinate = new DCCoordinate();
         sprite.graphics.clear();
         if(this.mWaypoints && this.mWaypoints.length > 0)
         {
            this.drawPoint(0,sprite,pointColor);
            for(i = 0; i < this.mWaypoints.length - 1; )
            {
               sprite.graphics.lineStyle(1,lineColor);
               coords.copy(this.mWaypoints[i]);
               viewMng.logicPosToViewPos(coords);
               sprite.graphics.moveTo(coords.x,coords.y);
               coords.copy(this.mWaypoints[i + 1]);
               viewMng.logicPosToViewPos(coords);
               sprite.graphics.lineTo(coords.x,coords.y);
               this.drawPoint(i + 1,sprite,i == 0 ? 16711680 : 65280);
               i++;
            }
            if(this.mType == 2)
            {
               sprite.graphics.lineStyle(1,lineColor);
               coords.copy(this.mWaypoints[1 - 1]);
               viewMng.logicPosToViewPos(coords);
               sprite.graphics.moveTo(coords.x,coords.y);
               coords.copy(this.mWaypoints[0]);
               viewMng.logicPosToViewPos(coords);
               sprite.graphics.lineTo(coords.x,coords.y);
            }
         }
      }
      
      private function drawPoint(i:int, g:Sprite, pointColor:uint = 16776960) : void
      {
         var coords:DCCoordinate = new DCCoordinate();
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         coords.copy(this.mWaypoints[i]);
         viewMng.logicPosToViewPos(coords);
         g.graphics.beginFill(pointColor);
         g.graphics.drawRect(coords.x - 2,coords.y - 2,4,4);
         g.graphics.endFill();
      }
      
      public function addToView() : void
      {
      }
      
      public function removeFromView() : void
      {
         if(Config.DEBUG_MODE)
         {
            InstanceMng.getUnitScene().debugRemoveSprite(this,"debugPath");
         }
      }
   }
}
