package esparragon.resources.textureBuilders
{
   import esparragon.resources.ELoaderMng;
   import esparragon.skins.ESkinPropDef;
   import flash.display.BitmapData;
   
   public class ETextureBuilder
   {
       
      
      protected var mDef:ESkinPropDef;
      
      protected var mSkinSku:String;
      
      protected var mLoaderMng:ELoaderMng;
      
      protected var mOnSuccess:Function;
      
      protected var mOnError:Function;
      
      public function ETextureBuilder(def:ESkinPropDef, skinSku:String)
      {
         super();
         this.mDef = def;
         this.mSkinSku = skinSku;
      }
      
      public static function getTextureIdFromSkuAndSize(textureSku:String, width:int, height:int) : String
      {
         return textureSku + "+" + width + "x" + height;
      }
      
      public function destroy() : void
      {
         this.mDef = null;
         this.mSkinSku = null;
         this.mLoaderMng = null;
         this.mOnSuccess = null;
         this.mOnError = null;
      }
      
      public function getLogicAssetSku() : String
      {
         return this.mDef.getSku();
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
      
      public function getTextureId() : String
      {
         return this.getLogicAssetSku();
      }
      
      protected function getAtlasId() : String
      {
         return null;
      }
      
      protected function getFrameIdInsideAtlas() : String
      {
         return null;
      }
      
      public function getIsInvisibleUntilTextureBuilt() : Boolean
      {
         return false;
      }
      
      protected function getOffX() : int
      {
         return this.mDef != null ? this.mDef.getValueAsInt("offX") : 0;
      }
      
      protected function getOffY() : int
      {
         return this.mDef != null ? this.mDef.getValueAsInt("offY") : 0;
      }
      
      public function buildTexture(loaderMng:ELoaderMng, onSuccess:Function = null, onError:Function = null) : void
      {
         this.mLoaderMng = loaderMng;
         this.mOnSuccess = onSuccess;
         this.mOnError = onError;
         this.extendedBuildTexture();
      }
      
      protected function extendedBuildTexture() : void
      {
      }
      
      protected function onSuccess(bitmapData:BitmapData) : void
      {
         if(this.mOnSuccess != null)
         {
            this.mOnSuccess(this.getTextureId(),this.mSkinSku,this.getAtlasId(),bitmapData,this.getIsInvisibleUntilTextureBuilt(),this.getOffX(),this.getOffY(),this.getFrameIdInsideAtlas());
         }
         this.endLoad();
      }
      
      protected function onError() : void
      {
         if(this.mOnError != null)
         {
            this.mOnError(this.getTextureId(),this.mSkinSku);
         }
         this.endLoad();
      }
      
      protected function endLoad() : void
      {
         this.mLoaderMng = null;
         this.mOnSuccess = null;
         this.mOnError = null;
      }
   }
}
