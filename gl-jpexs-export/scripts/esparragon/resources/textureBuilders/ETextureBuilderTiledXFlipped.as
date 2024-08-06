package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledXFlipped extends ETextureBuilderAbstractTiledArea
   {
       
      
      public function ETextureBuilderTiledXFlipped(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int)
      {
         super(def,skinSku,centerTexture,width,height);
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var i:int = 0;
         var scale:Number = NaN;
         var topLeftIndex:int = 0;
         var topLeftWidth:int = tilesGetWidth(topLeftIndex);
         var topLeftHeight:int = tilesGetHeight(topLeftIndex);
         var leftIndex:int = 1;
         var leftHeight:int = tilesGetHeight(leftIndex);
         var topIndex:int = 2;
         var topWidth:int = tilesGetWidth(topIndex);
         var gradientIndex:int = 3;
         var gradientWidth:int = tilesGetWidth(gradientIndex);
         var gradientHeight:int = tilesGetHeight(gradientIndex);
         var bottomIndex:int = 4;
         var bottomHeight:int = tilesGetHeight(bottomIndex);
         var bottomLeftIndex:int = 5;
         var bottomLeftWidth:int = tilesGetWidth(bottomLeftIndex);
         var bottomLeftHeight:int = tilesGetHeight(bottomLeftIndex);
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,16711935);
         var matrix:Matrix;
         (matrix = new Matrix()).identity();
         matrix.scale((mWidth - topLeftWidth - bottomLeftWidth) / gradientWidth,(mHeight - topLeftHeight - bottomLeftHeight) / gradientHeight);
         matrix.translate(topLeftWidth,topLeftHeight);
         tilesDrawTile(bmp,gradientIndex,matrix);
         matrix.identity();
         tilesDrawTile(bmp,topLeftIndex,matrix);
         matrix.identity();
         matrix.translate(0,mHeight - bottomLeftHeight);
         tilesDrawTile(bmp,bottomLeftIndex,matrix);
         matrix.identity();
         matrix.scale(-1,-1);
         matrix.translate(mWidth,bottomLeftHeight);
         tilesDrawTile(bmp,bottomLeftIndex,matrix);
         matrix.identity();
         matrix.scale(-1,-1);
         matrix.translate(mWidth,mHeight);
         tilesDrawTile(bmp,topLeftIndex,matrix);
         scale = (mHeight - topLeftHeight - bottomLeftHeight) / leftHeight;
         for(i = 0; i < 2; )
         {
            matrix.identity();
            matrix.scale(i + 1 - 3 * i,scale);
            matrix.translate(i * mWidth,topLeftHeight);
            tilesDrawTile(bmp,leftIndex,matrix);
            i++;
         }
         scale = (mWidth - topLeftWidth - bottomLeftWidth) / topWidth;
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(topLeftWidth,0);
         tilesDrawTile(bmp,topIndex,matrix);
         matrix.identity();
         matrix.scale(scale,1);
         matrix.translate(topLeftWidth,mHeight - bottomHeight);
         tilesDrawTile(bmp,bottomIndex,matrix);
         return bmp;
      }
   }
}
