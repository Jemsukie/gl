package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledAreaNoFlipped extends ETextureBuilderAbstractTiledArea
   {
       
      
      private var mUseGradient:Boolean;
      
      public function ETextureBuilderTiledAreaNoFlipped(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int, useGradient:Boolean)
      {
         super(def,skinSku,centerTexture,width,height);
         this.mUseGradient = useGradient;
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var scale:Number = NaN;
         var toprightIndex:* = 0;
         var bottomRightIndex:* = 0;
         var shineIndex:* = 0;
         var shineWidth:int = 0;
         var shineHeight:int = 0;
         var index:int;
         var topLeftIndex:* = index = 0;
         var topLeftWidth:int = tilesGetWidth(index);
         var topLeftHeight:int = tilesGetHeight(index);
         var topRightWidth:* = topLeftWidth;
         var topRightHeight:* = topLeftHeight;
         var leftIndex:* = index = 1;
         var leftWidth:int = tilesGetWidth(index);
         var leftHeight:int = tilesGetHeight(index);
         var topIndex:int;
         var topWidth:int = tilesGetWidth(topIndex = 2);
         var bottomLeftIndex:* = index = 3;
         var bottomLeftWidth:int = tilesGetWidth(index);
         var bottomLeftHeight:int = tilesGetHeight(index);
         var bottomRightWidth:* = bottomLeftWidth;
         var bottomRightHeight:* = bottomLeftWidth;
         var bottomIndex:* = index = 4;
         var gradientIndex:* = index = 5;
         var gradientWidth:int = tilesGetWidth(index);
         var gradientHeight:int = tilesGetHeight(index);
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,16711935);
         var matrix:Matrix = new Matrix();
         index = 6;
         if(tilesIsDefined(index))
         {
            toprightIndex = index;
            topRightWidth = tilesGetWidth(index);
            topRightHeight = tilesGetHeight(index);
         }
         index = 7;
         if(tilesIsDefined(index))
         {
            bottomRightIndex = index;
            bottomRightWidth = tilesGetWidth(index);
            bottomRightHeight = tilesGetHeight(index);
         }
         var offsetX:Number = Math.max(topLeftWidth,bottomLeftWidth) + Math.max(topRightWidth,bottomRightWidth);
         var offsetY:Number = Math.max(topLeftHeight,topRightHeight) + Math.max(bottomLeftHeight,bottomRightHeight);
         matrix.identity();
         matrix.scale((mWidth - offsetX) / gradientWidth,(mHeight - offsetY) / gradientHeight);
         matrix.translate(Math.max(topLeftWidth,bottomLeftWidth),Math.max(topLeftHeight,topRightHeight));
         tilesDrawTile(bmp,gradientIndex,matrix);
         matrix.identity();
         matrix.scale(1,1);
         tilesDrawTile(bmp,topLeftIndex,matrix);
         matrix.identity();
         matrix.scale(-1,1);
         matrix.translate(mWidth,0);
         tilesDrawTile(bmp,!!toprightIndex ? toprightIndex : topLeftIndex,matrix);
         matrix.identity();
         matrix.translate(0,mHeight - bottomLeftHeight);
         tilesDrawTile(bmp,bottomLeftIndex,matrix);
         matrix.identity();
         matrix.scale(-1,1);
         matrix.translate(mWidth,mHeight - bottomLeftHeight);
         tilesDrawTile(bmp,!!bottomRightIndex ? bottomRightIndex : bottomLeftIndex,matrix);
         var h:Number = mHeight - offsetY;
         var w:Number = mWidth - offsetX;
         scale = h / leftHeight;
         matrix.identity();
         matrix.scale(!!Math.max(topLeftWidth,bottomLeftWidth) ? 1 : 0,scale);
         matrix.translate(0,Math.max(topLeftHeight,topRightHeight));
         tilesDrawTile(bmp,leftIndex,matrix);
         scale = h / leftHeight;
         matrix.identity();
         matrix.scale(-(!!Math.max(topRightWidth,bottomRightWidth) ? 1 : leftWidth / topRightWidth),scale);
         matrix.translate(mWidth,Math.max(topLeftHeight,topRightHeight));
         tilesDrawTile(bmp,leftIndex,matrix);
         scale = w / topWidth;
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(Math.max(topLeftWidth,bottomLeftWidth),0);
         tilesDrawTile(bmp,topIndex,matrix);
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(Math.max(topLeftWidth,bottomLeftWidth),mHeight - Math.max(bottomLeftHeight,bottomRightHeight));
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
