package esparragon.resources.textureBuilders
{
   import esparragon.display.EImage;
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderTiledRow extends ETextureBuilderAbstractTiledArea
   {
       
      
      public function ETextureBuilderTiledRow(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int)
      {
         super(def,skinSku,centerTexture,width,height);
      }
      
      override protected function createBitmapData() : BitmapData
      {
         var right:EImage = null;
         var rightWidth:int = 0;
         var rightHeight:int = 0;
         var leftIndex:int;
         var leftWidth:int = tilesGetWidth(leftIndex = 0);
         var centerIndex:int;
         var centerWidth:int = tilesGetWidth(centerIndex = 1);
         var existCenter:Boolean;
         var heightIndex:int = (existCenter = tilesIsDefined(centerIndex,true)) ? centerIndex : leftIndex;
         var textureHeight:int = tilesGetHeight(heightIndex);
         var bmp:BitmapData = new BitmapData(mWidth,mHeight,true,0);
         var matrix:Matrix = new Matrix();
         var offY:Number = 0;
         if(textureHeight < mHeight && mCenterTexture)
         {
            offY = (mHeight - textureHeight) / 2;
         }
         var verticalScale:Number;
         var horizontalScale:* = verticalScale = Math.min(mHeight / textureHeight,1);
         if(textureHeight > mHeight)
         {
            horizontalScale *= 1.06;
         }
         matrix.scale(horizontalScale,verticalScale);
         matrix.translate(0,offY);
         tilesDrawTile(bmp,leftIndex,matrix);
         if(existCenter)
         {
            matrix.identity();
            var index:int = 2;
            if(tilesIsDefined(index))
            {
               rightHeight = tilesGetHeight(index);
               rightWidth = tilesGetWidth(index);
               horizontalScale = verticalScale = Math.min(mHeight / rightHeight,1);
               if(textureHeight > mHeight)
               {
                  horizontalScale *= 1.06;
               }
               matrix.scale(horizontalScale,verticalScale);
               matrix.translate(mWidth - rightWidth,offY);
            }
            else
            {
               index = 0;
               matrix.scale(-horizontalScale,verticalScale);
               matrix.translate(mWidth,offY);
            }
            rightWidth = tilesGetWidth(index);
            tilesDrawTile(bmp,index,matrix);
            matrix.identity();
            matrix.scale((mWidth - (leftWidth + rightWidth) * verticalScale) / centerWidth,verticalScale);
            matrix.translate(leftWidth * verticalScale,offY);
            tilesDrawTile(bmp,centerIndex,matrix,false);
         }
         return bmp;
      }
   }
}
