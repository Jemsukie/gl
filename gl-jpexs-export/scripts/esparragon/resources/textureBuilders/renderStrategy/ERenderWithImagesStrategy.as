package esparragon.resources.textureBuilders.renderStrategy
{
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESubTexture;
   import esparragon.display.ETexture;
   import esparragon.resources.EResourcesMng;
   import esparragon.skins.ESkinsMng;
   import esparragon.utils.EUtils;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ERenderWithImagesStrategy extends ERenderStrategy
   {
      
      private static var smLocalMatrix:Matrix;
       
      
      private var mImages:Dictionary;
      
      private var mImagesLogicAssetIds:Array;
      
      public function ERenderWithImagesStrategy(skinSku:String, assetIds:Array)
      {
         super(skinSku);
         this.mImagesLogicAssetIds = assetIds;
      }
      
      private static function getLocalMatrix() : Matrix
      {
         if(smLocalMatrix == null)
         {
            smLocalMatrix = new Matrix();
         }
         return smLocalMatrix;
      }
      
      override protected function extendedDestroy() : void
      {
         var k:* = null;
         var image:ESprite = null;
         if(this.mImages != null)
         {
            for(k in this.mImages)
            {
               image = this.mImages[k];
               if(image != null)
               {
                  image.destroy();
               }
               delete this.mImages[k];
            }
            this.mImages = null;
         }
         this.mImagesLogicAssetIds = null;
      }
      
      override protected function extendedRequestTiles() : void
      {
         var assetId:String = null;
         var image:EImage = null;
         this.mImages = new Dictionary(true);
         var resourcesMng:EResourcesMng = Esparragon.getResourcesMng();
         var skinsMng:ESkinsMng = Esparragon.getSkinsMng();
         for each(assetId in this.mImagesLogicAssetIds)
         {
            if(assetId != "no_texture")
            {
               mTilesToLoadAmount++;
               image = resourcesMng.getEImage(assetId,mSkinSku,null,null,this.onImageError);
               if(skinsMng.existPropInSkin(mSkinSku,assetId))
               {
                  image.applySkinProp(mSkinSku,assetId);
               }
               image.onSetTextureLoaded = this.onImageLoaded;
               this.mImages[assetId] = image;
            }
            else
            {
               this.mImages[assetId] = null;
            }
         }
      }
      
      override public function tilesGetDefinedAmount() : int
      {
         return this.mImagesLogicAssetIds == null ? 0 : int(this.mImagesLogicAssetIds.length);
      }
      
      private function onImageLoaded(image:EImage) : void
      {
         onTileLoaded();
      }
      
      private function onImageError(assetId:String, groupId:String) : void
      {
         onTileError();
      }
      
      override public function tilesIsDefined(index:int, ignoreNoTexture:Boolean = false) : Boolean
      {
         var returnValue:* = false;
         if(this.mImagesLogicAssetIds != null)
         {
            returnValue = this.mImagesLogicAssetIds[index] != null;
            if(returnValue && ignoreNoTexture)
            {
               returnValue = this.mImagesLogicAssetIds[index] != "no_texture";
            }
         }
         return returnValue;
      }
      
      private function tilesGetImage(index:int) : EImage
      {
         var logicAssetSku:String = null;
         var returnValue:EImage = null;
         if(this.mImagesLogicAssetIds != null)
         {
            if(index >= 0 && index < this.mImagesLogicAssetIds.length)
            {
               logicAssetSku = String(this.mImagesLogicAssetIds[index]);
               if(logicAssetSku != null)
               {
                  returnValue = this.mImages[logicAssetSku];
               }
            }
         }
         return returnValue;
      }
      
      private function tilesGetTexture(index:int) : ETexture
      {
         var returnValue:ETexture = null;
         var image:EImage = this.tilesGetImage(index);
         if(image != null)
         {
            returnValue = image.getTexture();
         }
         return returnValue;
      }
      
      override protected function tilesGetBitmapData(index:int) : BitmapData
      {
         var returnValue:BitmapData = null;
         var texture:ETexture = this.tilesGetTexture(index);
         if(texture != null)
         {
            returnValue = texture.getBitmapData();
         }
         return returnValue;
      }
      
      override public function tilesGetWidth(index:int) : int
      {
         var returnValue:int = 0;
         var tile:ESprite = this.tilesGetImage(index);
         if(tile != null)
         {
            returnValue = tile.width;
         }
         return returnValue;
      }
      
      override public function tilesGetHeight(index:int) : int
      {
         var returnValue:int = 0;
         var tile:ESprite = this.tilesGetImage(index);
         if(tile != null)
         {
            returnValue = tile.height;
         }
         return returnValue;
      }
      
      override public function tilesDrawTile(bmp:BitmapData, index:int, matrix:Matrix, smooth:Boolean = true) : void
      {
         var texture:ETexture = null;
         var subTexture:ESubTexture = null;
         var clipRect:Rectangle = null;
         var source:BitmapData = null;
         var localMatrix:Matrix = null;
         var offX:int = 0;
         var offY:int = 0;
         var imageRotation:Number = NaN;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var offBmpX:int = 0;
         var offBmpY:int = 0;
         var image:EImage;
         if((image = this.tilesGetImage(index)) != null)
         {
            if((texture = image.getTexture()) != null)
            {
               clipRect = (subTexture = texture.getSubTexture()) != null ? subTexture.clipRectangle : null;
               source = texture.getBitmapData();
               if((imageRotation = image.rotation) != 0)
               {
                  offBmpX = matrix.tx;
                  offBmpY = matrix.ty;
                  matrix.translate(-offBmpX,-offBmpY);
                  localMatrix = getLocalMatrix();
                  offX = image.logicLeft + image.width / 2;
                  offY = image.logicTop + image.height / 2;
                  localMatrix.translate(-offX,-offY);
                  localMatrix.rotate(imageRotation / 180 * 3.141592653589793);
                  localMatrix.translate(offX,offY);
                  matrix.concat(localMatrix);
                  if(image.scaleY == -1)
                  {
                     localMatrix.identity();
                     localMatrix.translate(-offX,-offY);
                     localMatrix.scale(1,-1);
                     localMatrix.translate(offX,offY);
                     matrix.concat(localMatrix);
                  }
                  matrix.translate(offBmpX,offBmpY);
               }
               if(image.isFlippedX())
               {
                  offX = image.width;
                  scaleX = -1;
               }
               else
               {
                  offX = 0;
                  scaleX = 1;
               }
               if(image.isFlippedY())
               {
                  offY = image.height;
                  scaleY = -1;
               }
               else
               {
                  offY = 0;
                  scaleY = 1;
               }
               if(scaleX == -1 || scaleY == -1)
               {
                  (localMatrix = getLocalMatrix()).identity();
                  localMatrix.scale(scaleX,scaleY);
                  localMatrix.translate(offX,offY);
                  matrix.concat(localMatrix);
               }
               EUtils.bitmapDataDraw(bmp,source,matrix,null,null,clipRect,smooth);
            }
         }
      }
   }
}
