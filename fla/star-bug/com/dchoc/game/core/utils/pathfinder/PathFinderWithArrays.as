package com.dchoc.game.core.utils.pathfinder
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class PathFinderWithArrays
   {
      
      private static const MAX_ITERATIONS:int = 50;
      
      public static var mHeuristic:Function = manhattanHeuristic;
       
      
      private const NEW_LOWEST_SCORE:Boolean = true;
      
      private const NATURAL_PATHFIDING:Boolean = false;
      
      private var mOpenList:Array;
      
      private var mClosedList:Array;
      
      private var mMapWeights:Vector.<int>;
      
      private var mMapCells:Vector.<Cell>;
      
      private var mSizeX:int;
      
      private var mSizeY:int;
      
      private var mCurrentCell:Cell;
      
      private var mCurrentCellPos:int;
      
      private var mSourceCell:Cell;
      
      private var mClosestCell:Cell;
      
      private var mDestCell:Cell;
      
      private var mCellsToCheck:Vector.<Cell>;
      
      private var mTilesData:Vector.<TileData>;
      
      private var mMapControllerRef:MapControllerPlanet;
      
      private var mCurrentCoor:DCCoordinate;
      
      private var mLastCoor:DCCoordinate;
      
      public function PathFinderWithArrays()
      {
         super();
      }
      
      public static function origHeuristic(node:Object, destinationNode:Object) : Number
      {
         return Math.abs(destinationNode.x - node.x) + Math.abs(destinationNode.y - node.y);
      }
      
      public static function diagonalHeuristic(node:Object, destinationNode:Object, cost:Number = 1, diagonalCost:Number = 1) : Number
      {
         var dx:Number = Math.abs(node.x - destinationNode.x);
         var dy:Number = Math.abs(node.y - destinationNode.y);
         var diag:Number = Math.min(dx,dy);
         var straight:Number = dx + dy;
         return diagonalCost * diag + cost * (straight - 2 * diag);
      }
      
      public static function euclideanHeuristic(node:Object, destinationNode:Object, cost:Number = 1) : Number
      {
         var dx:Number = node.x - destinationNode.x;
         var dy:Number = node.y - destinationNode.y;
         return Math.sqrt(dx * dx + dy * dy) * cost;
      }
      
      public static function manhattanHeuristic(node:Object, destinationNode:Object, cost:Number = 1) : Number
      {
         return Math.abs(node.x - destinationNode.x) * cost + Math.abs(node.y + destinationNode.y) * cost;
      }
      
      public function init(sizeX:int, sizeY:int, map:Vector.<int>) : void
      {
         this.mSizeX = sizeX;
         this.mSizeY = sizeY;
         this.mOpenList = [];
         this.mClosedList = [];
         this.mMapWeights = map;
         this.mMapCells = new Vector.<Cell>(0);
         this.mCellsToCheck = new Vector.<Cell>(0);
         this.mCurrentCoor = new DCCoordinate();
         this.mLastCoor = new DCCoordinate();
         this.reinit();
         var mapModel:MapModel = InstanceMng.getMapModel();
         this.mTilesData = mapModel.mTilesData;
         this.mMapControllerRef = mapModel.mMapController;
      }
      
      public function reinit() : void
      {
         var i:int = 0;
         var c:Cell = null;
         var length:int = int(this.mMapCells.length);
         if(length == 0)
         {
            for(i = 0; i < this.mMapWeights.length; )
            {
               c = new Cell();
               c.x = i % this.mSizeX;
               c.y = i / this.mSizeX;
               c.tileIndex = i;
               this.mMapCells.push(c);
               i++;
            }
         }
         else
         {
            i = 0;
            while(i < this.mOpenList.length)
            {
               this.mOpenList[i].parentCell = null;
               this.mOpenList[i].childCell = null;
               this.mOpenList[i].g = 0;
               this.mOpenList[i].h = 0;
               this.mOpenList[i].score = 0;
               this.mOpenList[i].isDiag = false;
               this.mOpenList[i].inClosedList = false;
               this.mOpenList[i].inOpenList = false;
               i++;
            }
            for(i = 0; i < this.mClosedList.length; )
            {
               this.mClosedList[i].parentCell = null;
               this.mClosedList[i].childCell = null;
               this.mClosedList[i].g = 0;
               this.mClosedList[i].h = 0;
               this.mClosedList[i].score = 0;
               this.mClosedList[i].isDiag = false;
               this.mClosedList[i].inClosedList = false;
               this.mClosedList[i].inOpenList = false;
               i++;
            }
         }
      }
      
      public function unload() : void
      {
         this.mTilesData = null;
         this.mMapControllerRef = null;
         this.mMapCells = null;
         this.mCurrentCoor = null;
         this.mLastCoor = null;
      }
      
      public function findPath(tileIndexSource:int, tileIndexDest:int, path:Vector.<int>, depth:int, itemFrom:Object = null, itemTo:Object = null, ignoreItems:Boolean = false, map:Vector.<int> = null, weights:Array = null) : Boolean
      {
         var enqueue:Boolean = false;
         var baseItem:WorldItemObject = null;
         var h:Number = NaN;
         var g:int = 0;
         var score:int = 0;
         var indexOfCurrent:int = 0;
         var cellsToCheckCount:int = 0;
         var arryPtr:Cell = null;
         var index:int = 0;
         var ii:int = 0;
         var iterations:int = 0;
         var weight:* = 0;
         var cell_weight:int = 0;
         var n:int = 0;
         var angleOptimal:Number = NaN;
         var angleNeighbor:Number = NaN;
         var rest:Number = NaN;
         var indexToRemoveFrom:int = 0;
         var minScore:int = 0;
         var returnValue:Boolean = true;
         if(map == null)
         {
            map = this.mMapWeights;
         }
         this.reinit();
         this.mOpenList.length = 0;
         this.mClosedList.length = 0;
         this.mSourceCell = this.mMapCells[tileIndexSource];
         this.mDestCell = this.mMapCells[tileIndexDest];
         this.mClosestCell = null;
         if(this.mSourceCell == this.mDestCell)
         {
            path[1] = this.mDestCell.tileIndex;
            path[0] = 1;
         }
         else
         {
            this.mCurrentCell = this.mSourceCell;
            this.mCurrentCell.h = Math.abs(this.mDestCell.x - this.mCurrentCell.x) + Math.abs(this.mDestCell.y - this.mCurrentCell.y);
            iterations = 0;
            while(this.mCurrentCell != this.mDestCell && iterations < 50)
            {
               iterations++;
               if(this.mCurrentCell == null)
               {
                  iterations = 50;
                  break;
               }
               this.mCurrentCell.inOpenList = true;
               this.mOpenList.push(this.mCurrentCell);
               cellsToCheckCount = 0;
               if(this.mCurrentCell.y >= 1)
               {
                  index = (this.mCurrentCell.y - 1) * this.mSizeX + this.mCurrentCell.x;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = false;
                  }
               }
               if(this.mCurrentCell.x >= 1)
               {
                  index = this.mCurrentCell.y * this.mSizeX + this.mCurrentCell.x - 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = false;
                  }
               }
               if(this.mCurrentCell.y < this.mSizeY - 1)
               {
                  index = (this.mCurrentCell.y + 1) * this.mSizeX + this.mCurrentCell.x;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = false;
                  }
               }
               if(this.mCurrentCell.x < this.mSizeX - 1)
               {
                  index = this.mCurrentCell.y * this.mSizeX + this.mCurrentCell.x + 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = false;
                  }
               }
               if(this.mCurrentCell.x >= 1 && this.mCurrentCell.y >= 1)
               {
                  index = (this.mCurrentCell.y - 1) * this.mSizeX + this.mCurrentCell.x - 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = true;
                  }
               }
               if(this.mCurrentCell.x < this.mSizeX - 1 && this.mCurrentCell.y >= 1)
               {
                  index = (this.mCurrentCell.y - 1) * this.mSizeX + this.mCurrentCell.x + 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = true;
                  }
               }
               if(this.mCurrentCell.x < this.mSizeX - 1 && this.mCurrentCell.y < this.mSizeY - 1)
               {
                  index = (this.mCurrentCell.y + 1) * this.mSizeX + this.mCurrentCell.x + 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = true;
                  }
               }
               if(this.mCurrentCell.x >= 1 && this.mCurrentCell.y < this.mSizeY - 1)
               {
                  index = (this.mCurrentCell.y + 1) * this.mSizeX + this.mCurrentCell.x - 1;
                  if(!(arryPtr = this.mMapCells[index]).inClosedList)
                  {
                     this.mCellsToCheck[cellsToCheckCount++] = arryPtr;
                     arryPtr.isDiag = true;
                  }
               }
               weight = 1;
               for(ii = 0; ii < cellsToCheckCount; )
               {
                  index = (arryPtr = this.mCellsToCheck[ii]).tileIndex;
                  weight = 1;
                  if((weight = cell_weight = int(weights[map[index]])) < 100)
                  {
                     enqueue = true;
                  }
                  else if((enqueue = (baseItem = this.mTilesData[index].mBaseItem) == itemFrom || baseItem == itemTo) && ignoreItems)
                  {
                     weight = 0;
                  }
                  if(enqueue)
                  {
                     g = weight + this.mCurrentCell.g;
                     h = Math.abs(this.mDestCell.x - arryPtr.x) + Math.abs(this.mDestCell.y - arryPtr.y);
                     n = 0;
                     if(false)
                     {
                        angleOptimal = Math.atan2(this.mDestCell.y - this.mCurrentCell.y,this.mDestCell.x - this.mCurrentCell.x);
                        angleNeighbor = Math.atan2(arryPtr.y - this.mCurrentCell.y,arryPtr.x - this.mCurrentCell.x);
                        n = (rest = Math.abs(angleOptimal - angleNeighbor)) * 7;
                     }
                     score = h + g + n;
                     if(!arryPtr.inOpenList)
                     {
                        arryPtr.parentCell = this.mCurrentCell;
                        arryPtr.score = score;
                        arryPtr.g = g;
                        arryPtr.h = h;
                        arryPtr.inOpenList = true;
                        this.mOpenList.push(arryPtr);
                     }
                     else if(arryPtr.score > score)
                     {
                        arryPtr.score = score;
                        arryPtr.g = g;
                        arryPtr.parentCell = this.mCurrentCell;
                     }
                  }
                  ii++;
               }
               if(this.mOpenList.length == 0)
               {
                  if(Config.DEBUG_CONSOLE)
                  {
                     DCDebug.traceCh("ERROR","PathFinderWithArrays.findPath: no solution for connecting " + tileIndexSource + " with " + tileIndexDest);
                  }
                  break;
               }
               this.mCurrentCell.inClosedList = true;
               this.mCurrentCell.inOpenList = false;
               this.mClosedList.push(this.mCurrentCell);
               indexOfCurrent = this.mOpenList.indexOf(this.mCurrentCell);
               this.mOpenList.splice(indexOfCurrent,1);
               if(this.mClosestCell == null || this.mCurrentCell.h < this.mClosestCell.h)
               {
                  this.mClosestCell = this.mCurrentCell;
               }
               if(true)
               {
                  this.mCurrentCellPos = this.getLowestFScorePos();
                  if(this.mCurrentCellPos >= 0)
                  {
                     this.mCurrentCell = this.mOpenList[this.mCurrentCellPos];
                     this.mCurrentCell.inOpenList = false;
                     this.mOpenList.splice(this.mCurrentCellPos,1);
                  }
               }
               else
               {
                  this.mOpenList.sortOn("score",16 | 2);
                  this.mCurrentCell = this.mOpenList.pop();
                  if(this.mCurrentCell != null)
                  {
                     this.mCurrentCell.inOpenList = false;
                  }
               }
            }
            if(this.mClosedList.length > 0)
            {
               if(iterations < 50)
               {
                  path[1] = this.mDestCell.tileIndex;
                  index = 1;
               }
               else
               {
                  index = 0;
               }
               arryPtr = this.mClosestCell;
               indexToRemoveFrom = -1;
               minScore = 2147483647;
               while(arryPtr != this.mSourceCell)
               {
                  path[index + 1] = arryPtr.tileIndex;
                  arryPtr = arryPtr.parentCell;
                  index++;
               }
               path[index] = this.mSourceCell.tileIndex;
               path[0] = index;
            }
         }
         return iterations < 50;
      }
      
      public function getLowestFScorePos() : int
      {
         var i:int = 0;
         var c:Cell = null;
         var minNode:* = -1;
         var minCost:int = 1000000;
         for(i = 0; i < this.mOpenList.length; )
         {
            c = this.mOpenList[i];
            if(c.score < minCost)
            {
               minCost = c.score;
               minNode = i;
            }
            i++;
         }
         return minNode;
      }
   }
}

class Cell
{
    
   
   public var parentCell:Cell;
   
   public var childCell:Cell;
   
   public var g:int;
   
   public var h:int;
   
   public var score:int;
   
   public var x:int;
   
   public var y:int;
   
   public var tileIndex:int;
   
   public var isDiag:Boolean;
   
   public var inOpenList:Boolean;
   
   public var inClosedList:Boolean;
   
   public function Cell()
   {
      super();
   }
}
