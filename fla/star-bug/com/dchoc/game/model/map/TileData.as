package com.dchoc.game.model.map
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   
   public class TileData implements DCAStarNode
   {
      
      public static const TILE_TYPE_LOCKED_ID:int = 2147483647;
      
      public static const TILE_TYPE_ROAD_ID:int = 0;
      
      public static const TILE_TYPE_TERRAIN_ID:int = 1;
      
      public static const TILE_TYPE_NOT_PLAYABLE_ID:int = 2;
      
      public static const TILE_TYPE_PLOT_ID:int = 3;
      
      public static const TILE_SET_EMPTY_ID:int = -1;
      
      public static const TILE_SET_NOT_PLAYABLE_ID:int = -1;
      
      public static const TILE_SET_TERRAIN_ID:int = 2;
      
      public static const TILE_SET_LOCKED_ID:int = 3;
      
      public static const TILE_SET_ALLOWED_ID:int = 0;
      
      public static const TILE_SET_FORBIDDEN_ID:int = 1;
       
      
      private var mTypeId:int;
      
      private var mHeuristic:Number;
      
      public var mTileIndex:int;
      
      public var mCol:int;
      
      public var mRow:int;
      
      public var mCanBeStepped:Boolean;
      
      private var mNeighbors:Vector.<DCAStarNode>;
      
      public var mBaseItem:WorldItemObject;
      
      public var mInfluenceItems:Vector.<WorldItemObject>;
      
      public function TileData(col:int, row:int, tileIndex:int, typeId:int = 2147483647)
      {
         super();
         this.mCol = col;
         this.mRow = row;
         this.mTileIndex = tileIndex;
         this.setTypeId(typeId,true);
      }
      
      public function unload() : void
      {
         this.mNeighbors = null;
         this.mInfluenceItems = null;
      }
      
      public function getTypeId() : int
      {
         return this.mTypeId;
      }
      
      public function setTypeId(value:int, calculateCanBeStepped:Boolean = true) : void
      {
         this.mTypeId = value;
         if(calculateCanBeStepped)
         {
            this.mCanBeStepped = this.canTypeBeStepped();
         }
      }
      
      public function setBaseItem(value:WorldItemObject, canBeStepped:Boolean = false) : void
      {
         this.mBaseItem = value;
         this.mCanBeStepped = value == null ? this.canTypeBeStepped() : canBeStepped;
      }
      
      private function canTypeBeStepped() : Boolean
      {
         return this.mTypeId == 1;
      }
      
      public function setCanBeStepped(value:Boolean) : void
      {
         this.mCanBeStepped = value;
      }
      
      public function obstacleCanBePlaced() : Boolean
      {
         return this.mBaseItem == null;
      }
      
      public function canBeStepped(checkItems:Boolean = true, item:Object = null) : Boolean
      {
         var returnValue:Boolean = false;
         if(checkItems)
         {
            returnValue = item == null || this.mBaseItem == null ? this.mCanBeStepped : this.mBaseItem == item;
         }
         else
         {
            returnValue = true;
         }
         return returnValue;
      }
      
      public function canBePlacedIn() : Boolean
      {
         return (this.mTypeId == 1 || this.mTypeId == 3) && this.mBaseItem == null;
      }
      
      public function getNodeType() : String
      {
         return "grass";
      }
      
      public function getNodeId() : int
      {
         return this.mTileIndex;
      }
      
      public function setNeighbors(value:Vector.<DCAStarNode>) : void
      {
         this.mNeighbors = value;
      }
      
      public function getNeighbors() : Vector.<DCAStarNode>
      {
         return this.mNeighbors;
      }
      
      public function setCol(num:int) : void
      {
         this.mCol = num;
      }
      
      public function getTileIndex() : int
      {
         return this.mTileIndex;
      }
      
      public function getCol() : int
      {
         return this.mCol;
      }
      
      public function setRow(num:int) : void
      {
         this.mRow = num;
      }
      
      public function getRow() : int
      {
         return this.mRow;
      }
      
      public function setHeuristic(h:Number) : void
      {
         this.mHeuristic = h;
      }
      
      public function getHeuristic() : Number
      {
         return this.mHeuristic;
      }
      
      public function toString() : String
      {
         return "";
      }
      
      public function influenceRegisterItem(item:WorldItemObject) : void
      {
         var registerItem:* = true;
         if(this.mInfluenceItems == null)
         {
            this.mInfluenceItems = new Vector.<WorldItemObject>(0);
         }
         else
         {
            registerItem = this.mInfluenceItems.indexOf(item) == -1;
         }
         if(registerItem)
         {
            this.mInfluenceItems.push(item);
         }
      }
      
      public function influenceUnregisterItem(item:WorldItemObject) : void
      {
         var pos:int = 0;
         if(this.mInfluenceItems != null)
         {
            pos = this.mInfluenceItems.indexOf(item);
            if(pos > -1)
            {
               this.mInfluenceItems.splice(pos,1);
            }
            if(this.mInfluenceItems.length == 0)
            {
               this.mInfluenceItems = null;
            }
         }
      }
      
      public function dataToString() : String
      {
         var item:WorldItemObject = null;
         var returnValue:* = "tileIndex = " + this.mTileIndex + " canBeStepped = " + this.mCanBeStepped + " typeId = " + this.mTypeId;
         if(this.mInfluenceItems != null)
         {
            returnValue += " influenceItems = ";
            for each(item in this.mInfluenceItems)
            {
               returnValue += item.mSid + ",";
            }
         }
         return returnValue;
      }
   }
}
