package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import esparragon.utils.EUtils;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledAreaNoFlippedTopTrimming extends ETextureBuilderAbstractTiledArea
   {
       
      
      private var mUseGradient:Boolean;
      
      public function ETextureBuilderTiledAreaNoFlippedTopTrimming(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int, useGradient:Boolean)
      {
         super(def,skinSku,centerTexture,width,height);
         this.mUseGradient = useGradient;
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var i:int = 0;
         var xPos:int = 0;
         var scale:Number = NaN;
         var shineIndex:* = 0;
         var shineWidth:int = 0;
         var shineHeight:int = 0;
         var index:int;
         var topLeftIndex:* = index = 0;
         var topleftWidth:int = tilesGetWidth(index);
         var topleftHeight:int = tilesGetHeight(index);
         var leftIndex:* = index = 1;
         var leftWidth:int = tilesGetWidth(index);
         var leftHeight:int = tilesGetHeight(index);
         var topIndex:* = index = 2;
         var topWidth:int = tilesGetWidth(index);
         var topHeight:int = tilesGetHeight(index);
         var bottomLeftIndex:int;
         var bottomLeftHeight:int = tilesGetHeight(bottomLeftIndex = 3);
         var bottomIndex:int;
         var bottomHeight:int = tilesGetHeight(bottomIndex = 4);
         var gradientIndex:* = index = 5;
         var gradientWidth:int = tilesGetWidth(index);
         var gradientHeight:int = tilesGetHeight(index);
         var topTrimIndex:* = index = 6;
         var topTrimWidth:int = tilesGetWidth(index);
         var topTrimHeight:int = tilesGetHeight(index);
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,16711935);
         var matrix:Matrix = new Matrix();
         var BKG_MARGIN:int;
         var offsetX:Number = BKG_MARGIN = 2;
         var offsetY:Number = BKG_MARGIN;
         if(mSkinSku == "skin_old")
         {
            offsetX = leftWidth * 2 - BKG_MARGIN;
            offsetY = topHeight + bottomHeight - BKG_MARGIN;
         }
         matrix.identity();
         matrix.scale((mWidth - offsetX) / gradientWidth,(mHeight - offsetY) / gradientHeight);
         matrix.translate(offsetX >> 1,offsetY >> 1);
         tilesDrawTile(bmp,gradientIndex,matrix);
         var timesToReplicate:int = Math.ceil((mWidth - offsetX) / topTrimWidth);
         var topTrimBmp:BitmapData = new BitmapData(timesToReplicate * topTrimWidth,topTrimHeight,true,16711935);
         matrix.identity();
         for(i = 0; i < timesToReplicate; )
         {
            tilesDrawTile(topTrimBmp,topTrimIndex,matrix);
            matrix.translate(topTrimWidth,0);
            i++;
         }
         matrix.identity();
         matrix.scale((mWidth - offsetX) / topTrimBmp.width,1);
         EUtils.bitmapDataDraw(bmp,topTrimBmp,matrix,null,null,null,true);
         for(i = 0; i < 4; )
         {
            xPos = i % 2;
            matrix.identity();
            matrix.scale(1 - 2 * xPos,1);
            matrix.translate(mWidth * xPos,0);
            tilesDrawTile(bmp,topLeftIndex,matrix);
            matrix.identity();
            matrix.scale(1 - 2 * xPos,1);
            matrix.translate(mWidth * xPos,mHeight - bottomLeftHeight);
            tilesDrawTile(bmp,bottomLeftIndex,matrix);
            i++;
         }
         var h:Number = mHeight - topleftHeight - bottomLeftHeight;
         var w:Number = mWidth - topleftWidth * 2;
         for(i = 0; i < 2; )
         {
            scale = h / leftHeight;
            matrix.identity();
            matrix.scale(1 - 2 * i,scale);
            matrix.translate(i * mWidth,topleftHeight);
            tilesDrawTile(bmp,leftIndex,matrix);
            i++;
         }
         scale = w / topWidth;
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(topleftWidth,0);
         tilesDrawTile(bmp,topIndex,matrix);
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(topleftWidth,mHeight - bottomHeight);
         tilesDrawTile(bmp,bottomIndex,matrix);
         index = 4;
         if(this.mUseGradient && tilesIsDefined(index,true))
         {
            shineIndex = index;
            shineWidth = tilesGetWidth(index);
            shineHeight = tilesGetHeight(index);
            matrix.identity();
            matrix.scale(mWidth / shineWidth,mHeight / shineHeight);
            tilesDrawTile(bmp,shineIndex,matrix);
         }
         return bmp;
      }
   }
}
