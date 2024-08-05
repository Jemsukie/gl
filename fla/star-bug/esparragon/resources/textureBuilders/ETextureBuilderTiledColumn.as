package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledColumn extends ETextureBuilderAbstractTiledArea
   {
       
      
      public function ETextureBuilderTiledColumn(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int)
      {
         super(def,skinSku,centerTexture,width,height);
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var centerIndex:int = 0;
         var centerWidth:int = tilesGetWidth(centerIndex);
         var centerHeight:int = tilesGetHeight(centerIndex);
         var topIndex:int = 1;
         var topHeight:int = 0;
         if(tilesIsDefined(topIndex,true))
         {
            topHeight = tilesGetHeight(topIndex);
         }
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,0);
         var matrix:Matrix = new Matrix();
         var offX:Number = 0;
         if(centerWidth < mWidth && mCenterTexture)
         {
            offX = (mWidth - centerWidth) / 2;
         }
         var horizontalScale:Number;
         var verticalScale:* = horizontalScale = Math.min(mWidth / centerWidth,1);
         if(centerWidth > mWidth)
         {
            verticalScale *= 1.06;
         }
         matrix.scale(horizontalScale,verticalScale);
         matrix.translate(offX,0);
         if(tilesIsDefined(topIndex,true))
         {
            tilesDrawTile(bmp,topIndex,matrix);
            matrix.identity();
            matrix.scale(horizontalScale,-verticalScale);
            matrix.translate(offX,mHeight);
            tilesDrawTile(bmp,topIndex,matrix);
         }
         matrix.identity();
         matrix.scale(horizontalScale,(mHeight - topHeight * 2 * horizontalScale) / centerHeight);
         matrix.translate(offX,topHeight * horizontalScale);
         tilesDrawTile(bmp,centerIndex,matrix);
         return bmp;
      }
   }
}
