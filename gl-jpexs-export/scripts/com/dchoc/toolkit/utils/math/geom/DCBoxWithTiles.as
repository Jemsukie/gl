package com.dchoc.toolkit.utils.math.geom
{
   public class DCBoxWithTiles extends DCBox
   {
       
      
      public var mTileX:Number;
      
      public var mTileY:Number;
      
      public var mTilesWidth:Number;
      
      public var mTilesHeight:Number;
      
      public function DCBoxWithTiles(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, tileX:Number = 0, tileY:Number = 0, tilesWidth:Number = 0, tilesHeight:Number = 0)
      {
         super(x,y,width,height);
         this.mTileX = tileX;
         this.mTileY = tileY;
         this.mTilesWidth = tilesWidth;
         this.mTilesHeight = tilesHeight;
      }
      
      public function getTileRight() : Number
      {
         return this.mTileX + this.mTilesWidth;
      }
      
      public function getTileDown() : Number
      {
         return this.mTileY + this.mTilesHeight;
      }
      
      public function setTileXY(x:Number, y:Number) : void
      {
         this.mTileX = x;
         this.mTileY = y;
      }
      
      public function setTileSize(w:Number, h:Number) : void
      {
         this.mTilesWidth = w;
         this.mTilesHeight = h;
      }
      
      override public function getLeft() : Number
      {
         return this.mTileX;
      }
      
      override public function getRight() : Number
      {
         return this.mTileX + this.mTilesWidth;
      }
      
      override public function getTop() : Number
      {
         return this.mTileY;
      }
      
      override public function getBottom() : Number
      {
         return this.mTileY + this.mTilesHeight;
      }
      
      public function getMinDimension() : Number
      {
         return this.mTilesWidth < this.mTilesHeight ? this.mTilesWidth : this.mTilesHeight;
      }
      
      public function get isoOrder() : Number
      {
         var a:Number = this.mTileX + this.mTilesWidth + (this.mTileX + this.mTileX + this.mTilesWidth) / 2;
         var b:Number = this.mTileY + this.mTilesHeight + (this.mTileY + this.mTileY + this.mTilesHeight) / 2;
         return a + b + mZ + id * 0.00001;
      }
      
      override public function isBehind(b:DCBox) : Boolean
      {
         return this.isoOrder < (b as DCBoxWithTiles).isoOrder;
      }
      
      override public function clone(copy:DCBox) : DCBox
      {
         var copyTiles:DCBoxWithTiles = null;
         if(copy == null)
         {
            copyTiles = new DCBoxWithTiles();
            copy = copyTiles;
         }
         else
         {
            copyTiles = DCBoxWithTiles(copy);
         }
         super.clone(copy);
         copyTiles.mTileX = this.mTileX;
         copyTiles.mTileY = this.mTileY;
         copyTiles.mTilesWidth = this.mTilesWidth;
         copyTiles.mTilesHeight = this.mTilesHeight;
         return copy;
      }
   }
}
