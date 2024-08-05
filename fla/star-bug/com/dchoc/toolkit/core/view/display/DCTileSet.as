package com.dchoc.toolkit.core.view.display
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DCTileSet extends DCDisplayObject
   {
      
      public static const TILE_SET_EMPTY_ID:int = -1;
       
      
      private var mBitmap:Bitmap;
      
      private var mBmpData:BitmapData;
      
      private var mBmpSource:BitmapData;
      
      private var mBmpSourceAux:BitmapData;
      
      private var mBmpSourceAlpha:BitmapData;
      
      private var mBmpSourceCor:Vector.<int>;
      
      private var mMapViewDef:DCMapViewDef;
      
      private var mMap:Vector.<int>;
      
      private var mRect:Rectangle;
      
      private var mPosition:Point;
      
      private var mAlphaPoint:Point;
      
      private var mAlpha:Number;
      
      private var mTileWidth:int;
      
      private var mTileHeight:int;
      
      private var mMapTilesWidth:int;
      
      private var mMapTilesHeight:int;
      
      private var mTileIdVisibleStart:int = -1;
      
      private var mPerspectiveOffX:int;
      
      private var mRectangularOffX:int;
      
      private var mColorMatrix:ColorMatrixFilter;
      
      public function DCTileSet()
      {
         super();
      }
      
      public function build(sku:String, cor:Vector.<int>, mapViewDef:DCMapViewDef, mapTilesWidth:int, mapTilesHeight:int) : void
      {
         this.mBmpSource = InstanceMng.getResourceMng().getImageFromCatalog(sku);
         this.mBmpSourceAux = this.mBmpSource.clone();
         this.mBmpSourceAlpha = new BitmapData(this.mBmpSource.width,this.mBmpSource.height,true,16777215);
         this.mBmpSourceAlpha.draw(this.mBmpSource,null,null,"alpha");
         this.mBmpSourceCor = cor;
         this.mMapViewDef = mapViewDef;
         if(this.mBitmap == null)
         {
            this.mBitmap = new Bitmap();
            this.mBitmap.smoothing = false;
            this.mRect = new Rectangle(0,0,1,1);
         }
         this.mTileWidth = this.mMapViewDef.mTileViewWidth;
         this.mTileHeight = this.mMapViewDef.mTileViewHeight;
         this.setMapSize(mapTilesWidth,mapTilesHeight);
         var matrix:Array = (matrix = (matrix = (matrix = (matrix = []).concat([1,0,0,0,0])).concat([0,1,0,0,0])).concat([0,0,1,0,0])).concat([0,0,0,1,0]);
         this.mColorMatrix = new ColorMatrixFilter(matrix);
         this.alpha = 1;
         this.mPosition = new Point(0,0);
         this.mAlphaPoint = new Point(0,0);
      }
      
      public function unload() : void
      {
         this.mBitmap = null;
         this.mBmpData = null;
         this.mBmpSource = null;
         this.mBmpSourceCor = null;
         this.mMap = null;
         this.mMapViewDef = null;
         this.mRect = null;
      }
      
      public function setTileIdVisibleStart(value:int) : void
      {
         this.mTileIdVisibleStart = value;
      }
      
      public function setMapSize(tilesWidth:int, tilesHeight:int) : void
      {
         var xRight:Number = NaN;
         var bufferWidth:int = 0;
         var bufferHeight:int = 0;
         if(tilesWidth != this.mMapTilesWidth || tilesHeight != this.mMapTilesHeight)
         {
            this.mMapTilesWidth = tilesWidth;
            this.mMapTilesHeight = tilesHeight;
            mCoor.x = tilesWidth * this.mMapViewDef.mTileLogicWidth;
            mCoor.y = 0;
            mCoor.z = 0;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            xRight = mCoor.x;
            mCoor.x = 0;
            mCoor.y = 0;
            mCoor.z = -tilesHeight * this.mMapViewDef.mTileLogicHeight;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            bufferWidth = xRight - mCoor.x;
            mCoor.x = tilesWidth / 2 * this.mMapViewDef.mTileLogicWidth;
            mCoor.y = 0;
            mCoor.z = -(tilesHeight / 2) * this.mMapViewDef.mTileLogicHeight;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            this.mRectangularOffX = -mCoor.x;
            this.mPerspectiveOffX = this.mMapViewDef.mPerspective.getTileAnchorX(this.mMapViewDef.mTileViewWidth) + (bufferWidth >> 1);
            mCoor.x = tilesWidth * this.mMapViewDef.mTileLogicWidth;
            mCoor.y = 0;
            mCoor.z = -tilesHeight * this.mMapViewDef.mTileLogicHeight;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            bufferHeight = mCoor.y;
            this.mBmpData = new BitmapData(bufferWidth,bufferHeight,true,16777215);
            this.mBitmap.bitmapData = this.mBmpData;
         }
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mBitmap;
      }
      
      override public function get x() : Number
      {
         return this.mBitmap.x;
      }
      
      override public function set x(value:Number) : void
      {
         this.mBitmap.x = value - (this.mBitmap.width >> 1) - this.mRectangularOffX;
      }
      
      override public function get y() : Number
      {
         return this.mBitmap.y;
      }
      
      override public function set y(value:Number) : void
      {
         this.mBitmap.y = value;
      }
      
      public function draw() : void
      {
         var i:int = 0;
         var tileIndex:int = 0;
         var j:int = 0;
         for(i = 0; i < this.mMapTilesHeight; )
         {
            tileIndex = i * this.mMapTilesWidth;
            for(j = 0; j < this.mMapTilesWidth; )
            {
               this.drawTile(tileIndex + j);
               j++;
            }
            i++;
         }
      }
      
      public function drawTile(tileIndex:int) : void
      {
         var screenX:int = 0;
         var screenY:int = 0;
         var offX:int = this.mPerspectiveOffX + this.mRectangularOffX;
         var tileX:int = tileIndex % this.mMapTilesWidth;
         var tileY:int = tileIndex / this.mMapTilesWidth;
         var frameId:int = this.mMap[tileIndex];
         if(frameId > this.mTileIdVisibleStart)
         {
            mCoor.x = tileX * this.mMapViewDef.mTileLogicWidth;
            mCoor.y = 0;
            mCoor.z = -tileY * this.mMapViewDef.mTileLogicHeight;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            screenX = offX + mCoor.x;
            screenY = mCoor.y;
            this.drawXY(frameId,screenX,screenY);
         }
      }
      
      public function removeTile(tileIndex:int) : void
      {
         var screenX:int = 0;
         var screenY:int = 0;
         var offX:int = this.mPerspectiveOffX + this.mRectangularOffX;
         var tileX:int = tileIndex % this.mMapTilesWidth;
         var tileY:int = tileIndex / this.mMapTilesWidth;
         var frameId:int = this.mMap[tileIndex];
         if(frameId > -1)
         {
            mCoor.x = tileX * this.mMapViewDef.mTileLogicWidth;
            mCoor.y = 0;
            mCoor.z = -tileY * this.mMapViewDef.mTileLogicHeight;
            this.mMapViewDef.mPerspective.mapToScreen(mCoor);
            screenX = offX + mCoor.x;
            screenY = mCoor.y;
            this.mBmpData.fillRect(new Rectangle(screenX,screenY,this.mMapViewDef.mTileViewWidth,this.mMapViewDef.mTileViewHeight),0);
         }
      }
      
      public function updateTile(tileIndex:int) : void
      {
         this.removeTile(tileIndex);
         this.drawTile(tileIndex);
         if((tileIndex - 1) % this.mMapTilesWidth < tileIndex % this.mMapTilesWidth && tileIndex - 1 >= 0)
         {
            this.drawTile(tileIndex - 1);
         }
         if((tileIndex + 1) % this.mMapTilesWidth > tileIndex % this.mMapTilesWidth && tileIndex + 1 < this.mMapTilesHeight * this.mMapTilesWidth)
         {
            this.drawTile(tileIndex + 1);
         }
         if(tileIndex - this.mMapTilesWidth >= 0)
         {
            this.drawTile(tileIndex - this.mMapTilesWidth);
         }
         if(tileIndex + this.mMapTilesWidth < this.mMapTilesHeight * this.mMapTilesWidth)
         {
            this.drawTile(tileIndex + this.mMapTilesWidth);
         }
      }
      
      private function drawXY(frameId:int, x:int, y:int) : void
      {
         var destX:Number = NaN;
         var destY:Number = NaN;
         var sizeX:int = 0;
         var sizeY:int = 0;
         var sourX:int = 0;
         var sourY:int = 0;
         var frame:int = 0;
         var tileX:int = 0;
         var tileY:int = 0;
         var scale:Number = 1;
         if(this.mBmpSourceCor != null)
         {
            frame = frameId * 6;
            destX = this.mBmpSourceCor[frame++] * scale + x;
            destY = this.mBmpSourceCor[frame++] * scale + y;
            if((sizeX = this.mBmpSourceCor[frame++] * scale) != 0)
            {
               sizeY = this.mBmpSourceCor[frame++] * scale;
               sourX = this.mBmpSourceCor[frame++] * scale;
               sourY = this.mBmpSourceCor[frame++] * scale;
            }
         }
         else
         {
            tileX = frameId % 16;
            tileY = frameId / 16;
            sizeX = this.mMapViewDef.mTileViewWidth * scale;
            sizeY = this.mMapViewDef.mTileViewHeight * scale;
            sourX = tileX * sizeX;
            sourY = tileY * sizeY;
            destX = x;
            destY = y;
         }
         this.mRect.x = sourX;
         this.mRect.y = sourY;
         this.mRect.width = sizeX;
         this.mRect.height = sizeY;
         if(this.mRect.width > this.mBmpData.width)
         {
            this.mRect.width = this.mBmpData.width;
         }
         if(this.mRect.height > this.mBmpData.height)
         {
            this.mRect.height = this.mBmpData.height;
         }
         this.mBmpData.copyPixels(this.mBmpSourceAux,this.mRect,new Point(destX,destY),this.mBmpSourceAlpha,new Point(sourX,sourY),true);
      }
      
      public function flush(map:Vector.<int> = null, indices:Vector.<int> = null) : void
      {
         var length:int = 0;
         var i:int = 0;
         if(map != null)
         {
            this.mMap = map;
            if(indices == null)
            {
               this.draw();
            }
            else
            {
               length = int(indices.length);
               for(i = 0; i < length; )
               {
                  this.updateTile(indices[i]);
                  i++;
               }
            }
         }
      }
      
      public function redraw() : void
      {
         var length:int = 0;
         var i:int = 0;
         if(this.mMap != null)
         {
            length = int(this.mMap.length);
            for(i = 0; i < length; )
            {
               this.updateTile(i);
               i++;
            }
         }
      }
      
      override public function get alpha() : Number
      {
         return this.mAlpha;
      }
      
      override public function set alpha(a:Number) : void
      {
         if(a > 1)
         {
            a = 1;
         }
         this.mAlpha = a;
         var matrix:Array = this.mColorMatrix.matrix;
         matrix[18] = a;
         this.mColorMatrix.matrix = matrix;
         this.mBmpSourceAux.applyFilter(this.mBmpSource,this.mBmpSource.rect,new Point(0,0),this.mColorMatrix);
         this.mBmpSourceAlpha.applyFilter(this.mBmpSource,this.mBmpSource.rect,new Point(0,0),this.mColorMatrix);
      }
   }
}
