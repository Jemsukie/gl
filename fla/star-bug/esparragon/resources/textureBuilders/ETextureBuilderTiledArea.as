package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledArea extends ETextureBuilderAbstractTiledArea
   {
       
      
      private var mUseGradient:Boolean;
      
      public function ETextureBuilderTiledArea(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int, useGradient:Boolean)
      {
         if(width <= 0)
         {
            width = 1;
         }
         if(height <= 0)
         {
            height = 1;
         }
         super(def,skinSku,centerTexture,width,height);
         this.mUseGradient = useGradient;
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var i:int = 0;
         var xPos:int = 0;
         var yPos:int = 0;
         var scale:Number = NaN;
         var shineWidth:int = 0;
         var shineHeight:int = 0;
         var topLeftIndex:int = 0;
         var topLeftWidth:int = tilesGetWidth(topLeftIndex);
         var topLeftHeight:int = tilesGetHeight(topLeftIndex);
         var leftIndex:int = 1;
         var leftWidth:int = tilesGetWidth(leftIndex);
         var leftHeight:int = tilesGetHeight(leftIndex);
         var topIndex:int = 2;
         var topWidth:int = tilesGetWidth(topIndex);
         var topHeight:int = tilesGetHeight(topIndex);
         var gradientIndex:int = 3;
         var gradientWidth:int = tilesGetWidth(gradientIndex);
         var gradientHeight:int = tilesGetHeight(gradientIndex);
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,16711935);
         var matrix:Matrix = new Matrix();
         var BKG_MARGIN:int;
         var offsetX:Number = BKG_MARGIN = 2;
         var offsetY:Number = BKG_MARGIN;
         offsetX = leftWidth * 2 - BKG_MARGIN;
         offsetY = topHeight * 2 - BKG_MARGIN;
         matrix.identity();
         matrix.scale((mWidth - offsetX) / gradientWidth,(mHeight - offsetY) / gradientHeight);
         matrix.translate(offsetX >> 1,offsetY >> 1);
         tilesDrawTile(bmp,gradientIndex,matrix);
         for(i = 0; i < 4; )
         {
            xPos = i % 2;
            yPos = i / 2;
            matrix.identity();
            matrix.scale(xPos + 1 - 3 * xPos,yPos + 1 - 3 * yPos);
            matrix.translate(mWidth * xPos,mHeight * yPos);
            tilesDrawTile(bmp,topLeftIndex,matrix);
            i++;
         }
         var h:Number = mHeight - topLeftHeight * 2;
         var w:Number = mWidth - topLeftWidth * 2;
         for(i = 0; i < 2; )
         {
            scale = h / leftHeight;
            matrix.identity();
            matrix.scale(i + 1 - 3 * i,scale);
            matrix.translate(i * mWidth,topLeftHeight);
            tilesDrawTile(bmp,leftIndex,matrix);
            scale = w / topWidth;
            matrix.identity();
            matrix.scale(scale,i + 1 - 3 * i);
            matrix.translate(topLeftWidth,i * mHeight);
            tilesDrawTile(bmp,topIndex,matrix);
            i++;
         }
         var shineIndex:int = 4;
         if(this.mUseGradient && tilesIsDefined(shineIndex,true))
         {
            shineWidth = tilesGetWidth(shineIndex);
            shineHeight = tilesGetHeight(shineIndex);
            matrix.identity();
            matrix.scale(mWidth / shineWidth,mHeight / shineHeight);
            tilesDrawTile(bmp,shineIndex,matrix);
         }
         return bmp;
      }
   }
}
