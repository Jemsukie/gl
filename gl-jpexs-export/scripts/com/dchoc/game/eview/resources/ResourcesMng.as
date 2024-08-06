package com.dchoc.game.eview.resources
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import esparragon.resources.EAsset;
   import esparragon.resources.EResourcesMng;
   
   public class ResourcesMng extends EResourcesMng
   {
       
      
      public function ResourcesMng()
      {
         super();
      }
      
      public function getDCDisplayObject(assetId:String, groupId:String, clipName:String, format:int, dcAssetId:String = null) : DCDisplayObject
      {
         var returnValue:DCDisplayObject = null;
         var asset:EAsset;
         if((asset = getEAsset(assetId,groupId)) != null)
         {
            returnValue = this.getDCDisplayObjectFromEAsset(asset,clipName,format,dcAssetId);
         }
         return returnValue;
      }
      
      private function getDCDisplayObjectFromEAsset(asset:EAsset, clipName:String, format:int, dcAssetId:String = null) : DCDisplayObject
      {
         var anim:Object = null;
         var thisClass:Class = null;
         var dcMc:DCBitmapMovieClip = null;
         var returnValue:DCDisplayObject = null;
         var sku:String = asset.getId();
         var groupId:String = asset.getGroupId();
         switch(format)
         {
            case 0:
               if((thisClass = getAssetSWF(sku,groupId,clipName)) != null)
               {
                  returnValue = new DCDisplayObjectSWF(new thisClass());
               }
               break;
            case 2:
               if((anim = InstanceMng.getResourceMng().getBitmapAnimationFromCatalog(dcAssetId,"")) == null)
               {
                  anim = InstanceMng.getResourceMng().generateBitmapFromPng(dcAssetId);
               }
               if(anim != null)
               {
                  (dcMc = new DCBitmapMovieClip()).setAnimation(anim);
                  returnValue = dcMc;
               }
               break;
            case 3:
               if((anim = InstanceMng.getResourceMng().getBitmapAnimationFromCatalog(sku,clipName)) == null)
               {
                  anim = InstanceMng.getResourceMng().generateBitmapFromMovieclip(sku,clipName,getAssetSWF(sku,groupId,clipName));
               }
               if(anim != null)
               {
                  (dcMc = new DCBitmapMovieClip()).setAnimation(anim);
                  dcMc.getDisplayObject().name = clipName;
                  returnValue = dcMc;
               }
         }
         return returnValue;
      }
   }
}
