package esparragon.resources.textureBuilders
{
   import esparragon.skins.ESkinPropDef;
   import flash.display.Bitmap;
   
   public class ETextureBuilderSingleAsset extends ETextureBuilder
   {
       
      
      public function ETextureBuilderSingleAsset(def:ESkinPropDef, skinSku:String)
      {
         super(def,skinSku);
      }
      
      private function getRawAssetId() : String
      {
         var returnValue:String = null;
         if(mDef != null)
         {
            if(mDef.hasKey("assetId"))
            {
               returnValue = mDef.getValueAsString("assetId");
            }
            else if(mDef.hasKey("assetIds"))
            {
               returnValue = mDef.getValueAsString("assetIds");
            }
         }
         return returnValue;
      }
      
      override protected function getAtlasId() : String
      {
         var returnValue:String = null;
         if(mDef != null)
         {
            if(mDef.hasKey("atlasId"))
            {
               returnValue = mDef.getValueAsString("atlasId");
            }
         }
         return returnValue;
      }
      
      override protected function getFrameIdInsideAtlas() : String
      {
         var key:String = null;
         var returnValue:String = null;
         if(mDef != null)
         {
            key = "assetId";
            if(mDef.hasKey(key))
            {
               returnValue = mDef.getValueAsString(key);
            }
         }
         return returnValue;
      }
      
      override protected function extendedBuildTexture() : void
      {
         mLoaderMng.loadAsset(this.getRawAssetId(),mSkinSku,2,this.onLoaderNotification,this.onLoaderNotification,this.getAtlasId());
      }
      
      private function onLoaderNotification(assetId:String, groupId:String) : void
      {
         var bitmap:Bitmap = null;
         if(mLoaderMng != null)
         {
            bitmap = Bitmap(mLoaderMng.getAssetData(assetId,groupId));
            if(bitmap != null)
            {
               onSuccess(bitmap.bitmapData);
            }
            else
            {
               onError();
            }
         }
      }
   }
}
