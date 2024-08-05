package esparragon.resources
{
   import esparragon.core.Esparragon;
   import esparragon.display.EDisplayFactory;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.resources.textureBuilders.ETextureBuilder;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class EResourcesMng
   {
      
      private static const CHANNEL_RESOURCES:String = "E_RESOURCES";
       
      
      private var mLoaderMng:ELoaderMng;
      
      private var mDisplayFactory:EDisplayFactory;
      
      private var mOnSetTexture:Function;
      
      private var mOnSetMovieClip:Function;
      
      private var mOnGetTextureBuilder:Function;
      
      private var mTexturesBuilders:Dictionary;
      
      public function EResourcesMng()
      {
         super();
      }
      
      public function init(displayFactory:EDisplayFactory, filesBaseUrl:String, lutUrl:String, onGetTextureBuilder:Function, onSetTexture:Function, onSetMovieClip:Function, maxRequestsAllowedSimultaneously:int = 2147483647) : void
      {
         if(this.mLoaderMng == null)
         {
            this.mDisplayFactory = displayFactory;
            this.mLoaderMng = new ELoaderMng(filesBaseUrl,lutUrl,null,maxRequestsAllowedSimultaneously);
            this.mOnGetTextureBuilder = onGetTextureBuilder;
            this.mOnSetTexture = onSetTexture;
            this.mOnSetMovieClip = onSetMovieClip;
         }
         else
         {
            Esparragon.throwError("Class [EResourcesMng].init() It\'s already initialized.","E_RESOURCES");
         }
      }
      
      public function destroy() : void
      {
         this.mDisplayFactory = null;
         if(this.mLoaderMng != null)
         {
            this.mLoaderMng.destroy();
            this.mLoaderMng = null;
         }
         this.mOnGetTextureBuilder = null;
         this.mOnSetTexture = null;
         this.mOnSetMovieClip = null;
         this.texturesDestroy();
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mLoaderMng != null)
         {
            this.mLoaderMng.logicUpdate(dt);
         }
         else
         {
            Esparragon.throwError("Class [EResourcesMng].logicUpdate(). Call init() method before calling logicUpdate()","E_RESOURCES");
         }
      }
      
      public function isReady() : Boolean
      {
         return this.mLoaderMng.isReady();
      }
      
      public function getELoaderMng() : ELoaderMng
      {
         return this.mLoaderMng;
      }
      
      public function addAssetFromXml(assetId:String, groupId:String, xml:XML = null) : EAsset
      {
         return this.mLoaderMng.assetsAddAssetFromXml(assetId,groupId,xml);
      }
      
      public function getEAsset(assetId:String, groupId:String) : EAsset
      {
         return this.mLoaderMng.assetsGetAsset(assetId,groupId);
      }
      
      public function getEAssetThroughGroups(assetId:String, groupId:String) : EAsset
      {
         return this.mLoaderMng.assetsGetAssetThroughGroups(assetId,groupId);
      }
      
      public function getAssetUrl(assetId:String, groupId:String) : String
      {
         var returnValue:String = null;
         var asset:EAsset;
         if((asset = this.mLoaderMng.getAssetCheckingElseGroups(assetId,groupId)) != null)
         {
            returnValue = asset.getUrl();
         }
         return returnValue;
      }
      
      public function getEImage(imageId:String, groupId:String, area:ELayoutArea = null, atlasId:String = null, onError:Function = null) : EImage
      {
         var image:EImage = Esparragon.getDisplayFactory().createImage(null);
         if(area != null)
         {
            image.setLayoutArea(area,true);
         }
         this.setTextureToImage(imageId,groupId,area,image,true,atlasId,onError);
         return image;
      }
      
      public function getEMovieClip(swfAssetId:String, groupId:String, clipName:String) : EMovieClip
      {
         var returnValue:EMovieClip = null;
         var group:EGroup;
         if((group = this.mLoaderMng.groupsGetGroup(groupId)) != null)
         {
            returnValue = Esparragon.getDisplayFactory().createMovieClip();
            group.addMovieClip(swfAssetId,clipName,returnValue);
         }
         return returnValue;
      }
      
      public function returnEMovieClip(mc:EMovieClip) : void
      {
         var group:EGroup = null;
         if(mc != null)
         {
            group = this.mLoaderMng.groupsGetGroup(mc.getGroupId());
            if(group != null)
            {
               group.removeMovieClip(mc);
            }
         }
      }
      
      public function getOnSetMovieClip() : Function
      {
         return this.mOnSetMovieClip;
      }
      
      public function resizeImage(image:EImage, width:int, height:int) : void
      {
         var textureBuilder:ETextureBuilder = null;
         var imageArea:ELayoutArea = null;
         var area:ELayoutArea = null;
         var currentTexture:ETexture;
         if((currentTexture = image.getTexture()) != null)
         {
            if((textureBuilder = this.getTextureBuilder(currentTexture)) != null)
            {
               if((imageArea = image.getLayoutArea()) != null)
               {
                  (area = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(imageArea)).width = width;
                  area.height = height;
               }
               else
               {
                  area = ELayoutAreaFactory.createLayoutArea(width,height);
               }
               image.setLayoutArea(area);
               this.setTextureToImage(textureBuilder.getLogicAssetSku(),textureBuilder.getSkinSku(),area,image,true);
            }
         }
      }
      
      private function unsetTextureToImage(image:EImage) : void
      {
         var texture:ETexture = null;
         var textureBuilder:ETextureBuilder = null;
         var group:EGroup = null;
         var textureId:String = null;
         if(image == null)
         {
            return;
         }
         texture = image.getTexture();
         if(texture == null)
         {
            return;
         }
         textureBuilder = this.getTextureBuilder(texture);
         if(textureBuilder != null)
         {
            if((group = this.mLoaderMng.groupsGetGroup(textureBuilder.getSkinSku())) != null)
            {
               textureId = textureBuilder.getTextureId();
               group.unsetTextureToImage(textureId,image);
               if(group.getNumImagesUsingTextureId(textureId) == 0)
               {
                  this.removeTextureBuilder(texture);
                  group.removeTexture(textureId);
               }
            }
         }
         else if(Config.DEBUG_MODE)
         {
            if(this.mTexturesBuilders == null)
            {
               Esparragon.traceMsg("Class [EResourcesMng].unsetTextureToImage() mTexturesBuilders not initialized.","E_RESOURCES");
            }
            else if(texture == null)
            {
               Esparragon.traceMsg("Class [EResourcesMng].unsetTextureToImage() texture is null.","E_RESOURCES");
            }
         }
      }
      
      public function setTextureToImage(imageId:String, groupId:String, area:ELayoutArea, image:EImage, checkIfAlreadyHasATexture:Boolean = true, atlasId:String = null, onError:Function = null) : String
      {
         var currentTexture:ETexture = null;
         var textureBuilder:ETextureBuilder = null;
         var texture:ETexture = null;
         var hasAlreadyATexture:Boolean = false;
         var textureId:String = null;
         var returnValue:String = null;
         var group:EGroup;
         if((group = this.mLoaderMng.groupsGetGroup(groupId)) != null)
         {
            currentTexture = image.getTexture();
            texture = this.getETexture(imageId,groupId,area,atlasId,onError);
            if(hasAlreadyATexture = checkIfAlreadyHasATexture && currentTexture != null && currentTexture != texture)
            {
               if((textureBuilder = this.getTextureBuilder(currentTexture)) != null)
               {
                  returnValue = textureBuilder.getTextureId();
                  this.unsetTextureToImage(image);
               }
            }
            if(currentTexture != texture)
            {
               if((textureId = this.getTextureIdFromTexture(texture)) != null)
               {
                  textureBuilder = this.getTextureBuilder(texture);
                  group.setTextureToImage(textureId,image);
               }
               if(texture.getBitmapData() != null)
               {
                  this.applyETextureToEImage(image,texture,textureId,atlasId);
               }
               else
               {
                  image.setTexture(texture);
                  if(!hasAlreadyATexture)
                  {
                     if((textureBuilder = this.mTexturesBuilders[texture]) != null && textureBuilder.getIsInvisibleUntilTextureBuilt())
                     {
                        image.visible = false;
                     }
                  }
               }
            }
         }
         return returnValue;
      }
      
      public function getTextureBuilder(texture:ETexture) : ETextureBuilder
      {
         return this.mTexturesBuilders != null ? this.mTexturesBuilders[texture] as ETextureBuilder : null;
      }
      
      public function removeTextureBuilder(texture:ETexture) : void
      {
         var textureBuilder:ETextureBuilder = null;
         if(this.mTexturesBuilders != null)
         {
            if(this.mTexturesBuilders[texture] != null)
            {
               textureBuilder = this.mTexturesBuilders[texture];
               textureBuilder.destroy();
               delete this.mTexturesBuilders[texture];
            }
         }
      }
      
      private function getTextureIdFromTexture(texture:ETexture) : String
      {
         var returnValue:String = null;
         var textureBuilder:ETextureBuilder = this.getTextureBuilder(texture);
         if(textureBuilder != null)
         {
            returnValue = textureBuilder.getTextureId();
         }
         return returnValue;
      }
      
      private function applyETextureToEImage(image:EImage, texture:ETexture, assetId:String, atlasId:String) : void
      {
         if(this.mOnSetTexture != null)
         {
            this.mOnSetTexture(image,texture,assetId,atlasId);
         }
         this.setETextureToEImage(image,texture);
      }
      
      public function setETextureToEImage(image:EImage, texture:ETexture) : void
      {
         var parentESprite:ESprite = null;
         var area:ELayoutArea = null;
         image.setTexture(texture);
         var layoutArea:ELayoutArea;
         if((layoutArea = image.getLayoutArea()) != null)
         {
            layoutArea.performBehaviors(image);
         }
         if(image.parent != null && image.parent is ESprite)
         {
            area = (parentESprite = image.parent as ESprite).getLayoutArea();
            if(area != null)
            {
               area.performBehaviors(parentESprite);
            }
         }
         image.setSmooth(true);
      }
      
      public function returnEImage(image:EImage, disposeTexture:Boolean = false) : void
      {
         var texture:ETexture = image.getTexture();
         if(texture != null)
         {
            this.unsetTextureToImage(image);
         }
      }
      
      public function returnETextField(field:ETextField) : void
      {
      }
      
      public function isAssetPriorityAllowedToLoad(priority:int) : Boolean
      {
         return this.mLoaderMng.isAssetPriorityAllowedToLoad(priority);
      }
      
      public function isAssetLoaded(assetId:String, groupId:String) : Boolean
      {
         return this.mLoaderMng.isAssetLoaded(assetId,groupId);
      }
      
      public function loadAsset(assetId:String, groupId:String, priority:int = -1, completeFunc:Function = null, errorFunc:Function = null) : void
      {
         if(priority == -1)
         {
            priority = 1;
         }
         this.mLoaderMng.loadAsset(assetId,groupId,priority,completeFunc,errorFunc);
      }
      
      public function loadAtlas(atlasId:String, groupId:String, priority:int, onSuccess:Function, onError:Function) : void
      {
         var url:String = null;
         var id:String = null;
         var xml:XML = null;
         var xmlStr:* = null;
         var src:* = null;
         var asset:EAsset;
         if((asset = this.getEAssetThroughGroups(atlasId,groupId)) != null)
         {
            url = asset.getUrl();
            id = EGroup.atlasGetPngId(atlasId);
            if((asset = this.getEAsset(id,groupId)) == null)
            {
               src = url + ".png";
               xmlStr = "<asset id=\"" + id + "\"" + " src=\"" + this.mLoaderMng.getFileURL(src,true) + "\" type=\"PNG\"/>";
               xml = EUtils.stringToXML(xmlStr);
               this.addAssetFromXml(id,groupId,xml);
            }
            this.loadAsset(id,groupId,priority,onSuccess,onError);
            id = EGroup.atlasGetXmlId(atlasId);
            if((asset = this.getEAsset(id,groupId)) == null)
            {
               src = url + ".xml";
               xmlStr = "<asset id=\"" + id + "\"" + " src=\"" + this.mLoaderMng.getFileURL(src,true) + "\" type=\"XML\"/>";
               xml = EUtils.stringToXML(xmlStr);
               this.addAssetFromXml(id,groupId,xml);
            }
            this.loadAsset(id,groupId,priority,onSuccess,onError);
         }
      }
      
      public function getAssetData(assetId:String, groupId:String) : Object
      {
         return this.mLoaderMng.getAssetData(assetId,groupId);
      }
      
      public function getAssetXML(assetId:String, groupId:String) : XML
      {
         return this.mLoaderMng.getAssetXML(assetId,groupId);
      }
      
      public function getAssetString(assetId:String, groupId:String) : String
      {
         return this.mLoaderMng.getAssetString(assetId,groupId);
      }
      
      public function getAssetByteArray(assetId:String, groupId:String) : ByteArray
      {
         return this.mLoaderMng.getAssetByteArray(assetId,groupId);
      }
      
      public function getAssetSWF(assetId:String, groupId:String, clipName:String) : Class
      {
         return this.mLoaderMng.getAssetSWF(assetId,groupId,clipName);
      }
      
      public function getAssetBitmap(assetId:String, groupId:String) : Bitmap
      {
         return this.mLoaderMng.getAssetBitmap(assetId,groupId);
      }
      
      public function getAssetBitmapData(assetId:String, groupId:String) : BitmapData
      {
         return this.mLoaderMng.getAssetBitmapData(assetId,groupId);
      }
      
      private function texturesDestroy() : void
      {
         var k:* = null;
         if(this.mTexturesBuilders != null)
         {
            for(k in this.mTexturesBuilders)
            {
               delete this.mTexturesBuilders[k];
            }
            this.mTexturesBuilders = null;
         }
      }
      
      private function getETexture(logicAssetSku:String, groupId:String, area:ELayoutArea, atlasSku:String, onError:Function = null) : ETexture
      {
         var returnValue:ETexture = null;
         var textureBuilder:ETextureBuilder = null;
         var textureId:String = null;
         if(!logicAssetSku)
         {
            logicAssetSku = "no_texture";
         }
         var group:EGroup;
         if((group = this.mLoaderMng.groupsGetGroup(groupId)) == null)
         {
            Esparragon.traceMsg("Class [EResourcesMng].getETexture() group <" + groupId + "> not defined so a texture can\'t be generated for <" + logicAssetSku + ">.","E_RESOURCES");
         }
         else if((returnValue = group.getTexture(logicAssetSku,area)) == null)
         {
            returnValue = Esparragon.getDisplayFactory().createTextureFromBitmapData(null);
            textureId = (textureBuilder = this.mOnGetTextureBuilder(logicAssetSku,groupId,atlasSku,area)).getTextureId();
            group.addTexture(textureId,returnValue);
            textureBuilder.buildTexture(this.mLoaderMng,this.textureOnBuildSuccess,onError);
            if(this.mTexturesBuilders == null)
            {
               this.mTexturesBuilders = new Dictionary();
            }
            this.mTexturesBuilders[returnValue] = textureBuilder;
         }
         return returnValue;
      }
      
      private function returnETexture(texture:ETexture) : void
      {
         var textureBuilder:ETextureBuilder = null;
         if(texture != null)
         {
            textureBuilder = this.getTextureBuilder(texture);
            if(textureBuilder != null)
            {
               textureBuilder.destroy();
               delete this.mTexturesBuilders[texture];
            }
         }
      }
      
      private function textureOnBuildSuccess(textureId:String, groupId:String, atlasId:String, bitmapData:BitmapData, setVisible:Boolean, offX:int, offY:int, frameId:String) : void
      {
         var group:EGroup;
         if((group = this.mLoaderMng.groupsGetGroup(groupId)) != null)
         {
            group.setBitmapDataToTexture(bitmapData,textureId,atlasId,this.applyETextureToEImage,setVisible,offX,offY,frameId);
         }
      }
      
      public function moveResourcesBetweenGroups(oldGroupId:String, newGroupId:String) : void
      {
         var images:Dictionary = null;
         var image:EImage = null;
         var v:Vector.<EImage> = null;
         var texture:ETexture = null;
         var textureBuilder:ETextureBuilder = null;
         var k:* = null;
         var textures:Dictionary = null;
         var textureId:String = null;
         var str:String = null;
         var oldGroup:EGroup = this.mLoaderMng.groupsGetGroup(oldGroupId);
         var newGroup:EGroup = this.mLoaderMng.groupsGetGroup(newGroupId);
         if(oldGroup != null && newGroup != null)
         {
            images = oldGroup.getImages();
            for(k in images)
            {
               v = images[k];
               for each(image in v)
               {
                  texture = image.getTexture();
                  if((textureBuilder = this.getTextureBuilder(texture)) != null)
                  {
                     this.setTextureToImage(textureBuilder.getLogicAssetSku(),newGroupId,image.getLayoutArea(),image,false);
                  }
               }
            }
            textures = oldGroup.getTextures();
            for(k in textures)
            {
               texture = textures[k];
               textureId = this.getTextureIdFromTexture(texture);
               oldGroup.removeTexture(textureId);
               this.returnETexture(texture);
            }
         }
         else
         {
            str = "";
            if(oldGroup == null)
            {
               str += " group <" + oldGroupId + "> doesnt exist";
            }
            if(newGroup == null)
            {
               str += " group <" + newGroupId + "> doesnt exist";
            }
            Esparragon.traceMsg("Class [EResourcesMng].moveResourcesBetweenGroups() resources can\'t be moved between groups: " + str + ".","E_RESOURCES");
         }
      }
   }
}
