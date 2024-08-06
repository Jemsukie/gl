package esparragon.resources.textureBuilders
{
   import esparragon.resources.textureBuilders.renderStrategy.ERenderStrategy;
   import esparragon.resources.textureBuilders.renderStrategy.ERenderWithImagesStrategy;
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   
   public class ETextureBuilderAbstractTiledArea extends ETextureBuilder
   {
       
      
      protected var mCenterTexture:Boolean;
      
      protected var mWidth:int;
      
      protected var mHeight:int;
      
      private var mRenderStrategy:ERenderStrategy;
      
      public function ETextureBuilderAbstractTiledArea(def:ESkinPropDef, skinSku:String, centerTexture:Boolean, width:int, height:int)
      {
         super(def,skinSku);
         this.mCenterTexture = centerTexture;
         this.mWidth = width;
         this.mHeight = height;
      }
      
      override public function getTextureId() : String
      {
         return ETextureBuilder.getTextureIdFromSkuAndSize(getLogicAssetSku(),this.mWidth,this.mHeight);
      }
      
      override public function destroy() : void
      {
         this.endLoad();
      }
      
      override protected function endLoad() : void
      {
         if(this.mRenderStrategy != null)
         {
            this.mRenderStrategy.destroy();
            this.mRenderStrategy = null;
         }
      }
      
      override protected function extendedBuildTexture() : void
      {
         var assetIds:String = null;
         if(this.mRenderStrategy == null)
         {
            assetIds = mDef.getValueAsString("assetIds");
            if(assetIds != null && assetIds != "")
            {
               this.mRenderStrategy = new ERenderWithImagesStrategy(mSkinSku,assetIds.split(","));
            }
         }
         this.mRenderStrategy.requestTiles(this.onTilesSuccess,this.onTilesError);
      }
      
      protected function createBitmapData() : BitmapData
      {
         return null;
      }
      
      private function onTilesSuccess() : void
      {
         onSuccess(this.createBitmapData());
      }
      
      private function onTilesError() : void
      {
         onError();
      }
      
      public function tilesGetWidth(index:int) : int
      {
         var returnValue:int = 0;
         if(this.mRenderStrategy != null)
         {
            returnValue = this.mRenderStrategy.tilesGetWidth(index);
         }
         return returnValue;
      }
      
      public function tilesGetHeight(index:int) : int
      {
         var returnValue:int = 0;
         if(this.mRenderStrategy != null)
         {
            returnValue = this.mRenderStrategy.tilesGetHeight(index);
         }
         return returnValue;
      }
      
      protected function tilesIsDefined(index:int, ignoreNoTexture:Boolean = false) : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mRenderStrategy != null)
         {
            returnValue = this.mRenderStrategy.tilesIsDefined(index,ignoreNoTexture);
         }
         return returnValue;
      }
      
      protected function tilesDrawTile(bmp:BitmapData, index:int, matrix:Matrix, smooth:Boolean = true) : void
      {
         if(this.mRenderStrategy != null)
         {
            this.mRenderStrategy.tilesDrawTile(bmp,index,matrix,smooth);
         }
      }
   }
}
