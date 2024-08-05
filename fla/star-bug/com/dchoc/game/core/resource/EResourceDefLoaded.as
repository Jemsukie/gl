package com.dchoc.game.core.resource
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.resources.ResourcesMng;
   import com.dchoc.toolkit.core.resource.DCResourceDefLoaded;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class EResourceDefLoaded extends DCResourceDefLoaded
   {
      
      private static var smResourcesMng:ResourcesMng;
       
      
      private var mAssetSku:String;
      
      private var mGroupId:String;
      
      private var mFormat:int;
      
      private var mPriority:int;
      
      public function EResourceDefLoaded(sku:String, assetSku:String, groupId:String, type:String, format:int = -1, priority:int = -1)
      {
         super(sku,null,type,0,false,true,false);
         this.mAssetSku = assetSku;
         this.mGroupId = groupId;
         if(smResourcesMng == null)
         {
            smResourcesMng = InstanceMng.getEResourcesMng();
         }
         this.mFormat = format;
         if(this.mFormat == -1)
         {
            switch(type)
            {
               case ".png":
                  this.mFormat = 2;
                  break;
               case ".swf":
                  this.mFormat = 0;
            }
         }
         if(this.mPriority == -1)
         {
            this.mPriority = 1;
         }
         else
         {
            this.mPriority = priority;
         }
      }
      
      public static function unloadStatic() : void
      {
         smResourcesMng = null;
      }
      
      override public function isLoaded() : Boolean
      {
         return smResourcesMng.isAssetLoaded(this.mAssetSku,this.mGroupId);
      }
      
      override public function request() : void
      {
         smResourcesMng.loadAsset(this.mAssetSku,this.mGroupId,this.mPriority);
      }
      
      override public function getSWFClass(className:String) : Class
      {
         return smResourcesMng.getAssetSWF(this.mAssetSku,this.mGroupId,className);
      }
      
      override public function getDCDisplayObject(animSku:String, format:int = -1) : DCDisplayObject
      {
         if(format == -1)
         {
            format = this.mFormat;
         }
         return smResourcesMng.getDCDisplayObject(this.mAssetSku,this.mGroupId,animSku,format,mSku);
      }
      
      override public function getResource(type:String = null, decode:Boolean = false) : *
      {
         if(mResource == null)
         {
            mResource = smResourcesMng.getAssetData(this.mAssetSku,this.mGroupId);
            if(mResource != null)
            {
               mIsLoaded = true;
            }
         }
         return super.getResource(type,decode);
      }
      
      override public function unload() : void
      {
         mResource = null;
      }
   }
}
