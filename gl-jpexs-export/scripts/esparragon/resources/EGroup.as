package esparragon.resources
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESubTexture;
   import esparragon.display.ETexture;
   import esparragon.layout.ELayoutArea;
   import esparragon.resources.textureBuilders.ETextureBuilder;
   import esparragon.utils.EUtils;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class EGroup
   {
      
      private static const CHANNEL_GROUP:String = "E_GROUP";
      
      private static const ATLAS_SEPARATOR:String = "/";
       
      
      private var mId:String;
      
      private var mElseGroupId:String;
      
      private var mTextures:Dictionary;
      
      private var mImages:Dictionary;
      
      private var mAtlasRequests:Dictionary;
      
      private var mAtlasSubTextures:Dictionary;
      
      private var mMovieClips:Dictionary;
      
      public function EGroup()
      {
         super();
      }
      
      public static function atlasGetAtlasIdFromXmlId(xmlId:String) : String
      {
         return xmlId.split("/")[0];
      }
      
      public static function atlasGetPngId(atlasId:String) : String
      {
         return atlasId + "/" + "png";
      }
      
      public static function atlasGetXmlId(atlasId:String) : String
      {
         return atlasId + "/" + "xml";
      }
      
      public static function atlasIsIdValid(atlasId:String) : Boolean
      {
         return atlasId != null && atlasId != "";
      }
      
      public function destroy() : void
      {
         var k:* = null;
         var v:Vector.<EImage> = null;
         this.mId = null;
         this.mElseGroupId = null;
         if(this.mTextures != null)
         {
            for(k in this.mTextures)
            {
               this.removeTexture(k as String);
            }
            this.mTextures = null;
         }
         if(this.mImages != null)
         {
            for(k in this.mImages)
            {
               v = this.mImages[k];
               v.length = 0;
               delete this.mImages[k];
            }
         }
         this.atlasDestroy();
         this.destroyMovieClips();
      }
      
      public function fromXml(xml:XML) : void
      {
         this.mId = EUtils.xmlReadString(xml,"id");
         var attribute:String = "elseId";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mElseGroupId = EUtils.xmlReadString(xml,attribute);
         }
      }
      
      public function getTextures() : Dictionary
      {
         return this.mTextures;
      }
      
      public function getImages() : Dictionary
      {
         return this.mImages;
      }
      
      public function hasElseGroup() : Boolean
      {
         return this.mElseGroupId != null;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function getElseGroupId() : String
      {
         return this.mElseGroupId;
      }
      
      public function addTexture(textureId:String, texture:ETexture) : void
      {
         if(this.mTextures == null)
         {
            this.mTextures = new Dictionary();
         }
         if(this.mTextures[textureId] != null && Config.DEBUG_MODE)
         {
            Esparragon.traceMsg("Class [EGroup].addTexture() there\'s already a texture with id <" + textureId + "> in group <" + this.mId + ">.","E_ERROR");
         }
         else
         {
            this.mTextures[textureId] = texture;
         }
      }
      
      public function removeTexture(textureId:String) : void
      {
         if(this.mTextures != null && this.mTextures[textureId] != null)
         {
            if(this.mImages != null && this.mImages[textureId] != null)
            {
               delete this.mImages[textureId];
            }
            delete this.mTextures[textureId];
         }
      }
      
      public function getTexture(logicAssetSku:String, area:ELayoutArea) : ETexture
      {
         var sku:String = null;
         var returnValue:ETexture = null;
         if(this.mTextures != null)
         {
            returnValue = this.mTextures[logicAssetSku] as ETexture;
            if(returnValue == null && area != null)
            {
               sku = ETextureBuilder.getTextureIdFromSkuAndSize(logicAssetSku,area.width,area.height);
               returnValue = this.mTextures[sku] as ETexture;
            }
         }
         return returnValue;
      }
      
      public function setTextureToImage(textureId:String, image:EImage) : void
      {
         var v:Vector.<EImage> = null;
         if(this.mImages == null)
         {
            this.mImages = new Dictionary(true);
         }
         if(this.mImages[textureId] == null)
         {
            this.mImages[textureId] = new Vector.<EImage>(0);
         }
         v = this.mImages[textureId];
         if(v != null && v.indexOf(image) == -1)
         {
            v.push(image);
         }
         else if(Config.DEBUG_MODE)
         {
            Esparragon.traceMsg("Class [EGroup].setTextureToImage() this image has already been set to texture with id <" + textureId + "> in group <" + this.mId + ">.","E_ERROR");
         }
      }
      
      public function unsetTextureToImage(textureId:String, image:EImage) : void
      {
         var v:Vector.<EImage> = null;
         var index:int = 0;
         var error:Boolean = true;
         if(this.mImages != null)
         {
            v = this.mImages[textureId];
         }
         if(v != null)
         {
            if((index = v.indexOf(image)) > -1)
            {
               error = false;
               v.splice(index,1);
               if(v.length == 0)
               {
                  delete this.mImages[textureId];
               }
            }
         }
         if(error && Config.DEBUG_MODE)
         {
            if(this.mImages == null)
            {
               Esparragon.traceMsg("Class [EGroup].unsetTextureToImage() images dictionary not initialized in group <" + this.mId + ">.","E_ERROR");
            }
            else if(v == null)
            {
               Esparragon.traceMsg("Class [EGroup].unsetTextureToImage() texture with id <" + textureId + "> does not exist in images dictionary in group <" + this.mId + ">.","E_ERROR");
            }
            else if(image == null)
            {
               Esparragon.traceMsg("Class [EGroup].unsetTextureToImage() image is null.","E_ERROR");
            }
            else if(index != -1)
            {
               Esparragon.traceMsg("Class [EGroup].unsetTextureToImage() this image is not using texture with id <" + textureId + "> in group <" + this.mId + ">.","E_ERROR");
            }
         }
      }
      
      public function getNumImagesUsingTextureId(textureId:String) : int
      {
         var v:Vector.<EImage> = null;
         var returnValue:int = 0;
         if(this.mImages != null)
         {
            v = this.mImages[textureId];
            if(v != null)
            {
               returnValue = int(v.length);
            }
         }
         return returnValue;
      }
      
      public function setBitmapDataToTexture(bitmapData:BitmapData, textureId:String, atlasId:String, onImageReady:Function, setVisible:Boolean, offX:int, offY:int, frameId:String) : void
      {
         var texture:ETexture = null;
         var v:Vector.<EImage> = null;
         var subTexture:ESubTexture = null;
         var image:EImage = null;
         var i:int = 0;
         var length:int = 0;
         if((this.mTextures == null || this.mTextures[textureId] == null) && Config.DEBUG_MODE)
         {
            Esparragon.traceMsg("Class [EGroup].setBitmapDataToTexture() there\'s no texture stored for texture id <" + textureId + "> in group <" + this.mId + ">.","E_ERROR");
         }
         else
         {
            (texture = this.mTextures[textureId]).setBitmapData(bitmapData);
            if(atlasIsIdValid(atlasId))
            {
               if(frameId == null)
               {
                  frameId = textureId;
               }
               if((subTexture = this.atlasGetSubTexture(atlasId,frameId,Esparragon.isDebugModeEnabled())) != null)
               {
                  texture.setSubTexture(subTexture);
               }
            }
            texture.setOffX(offX);
            texture.setOffY(offY);
            if((v = this.mImages[textureId]) != null)
            {
               length = int(v.length);
               for(i = 0; i < length; )
               {
                  image = v[i];
                  if(setVisible)
                  {
                     image.visible = true;
                  }
                  if(onImageReady != null)
                  {
                     onImageReady(image,texture,textureId,atlasId);
                  }
                  if(v.length == length)
                  {
                     i++;
                  }
                  else
                  {
                     length = int(v.length);
                  }
               }
            }
         }
      }
      
      private function atlasDestroy() : void
      {
         var k:* = null;
         var atlasId:String = null;
         var v:Vector.<EAssetRequest> = null;
         var r:EAssetRequest = null;
         var d:Dictionary = null;
         var j:* = null;
         var frameId:String = null;
         var subTexture:ESubTexture = null;
         if(this.mAtlasRequests != null)
         {
            for(k in this.mAtlasRequests)
            {
               atlasId = k as String;
               if((v = this.mAtlasRequests[atlasId]) != null)
               {
                  while(v.length > 0)
                  {
                     r = v.shift();
                     r.destroy();
                  }
               }
               delete this.mAtlasRequests[atlasId];
            }
            this.mAtlasRequests = null;
         }
         if(this.mAtlasSubTextures != null)
         {
            for(k in this.mAtlasSubTextures)
            {
               atlasId = k as String;
               d = this.mAtlasSubTextures[atlasId];
               for(j in d)
               {
                  frameId = j as String;
                  subTexture = d[j];
                  if(subTexture != null)
                  {
                     subTexture.destroy();
                  }
                  delete d[j];
               }
               delete this.mAtlasSubTextures[k];
            }
            this.mAtlasSubTextures = null;
         }
      }
      
      public function atlasAddAssetIdToAtlas(assetId:String, atlasId:String, priority:int, completeFunc:Function, errorFunc:Function) : void
      {
         var v:Vector.<EAssetRequest> = null;
         var r:EAssetRequest = null;
         var asset:EAsset;
         var eResourcesMng:EResourcesMng;
         if((asset = (eResourcesMng = Esparragon.getResourcesMng()).getEAssetThroughGroups(atlasId,this.mId)) == null)
         {
            Esparragon.throwError("Class [EGroup].atlasAddAssetIdToAtlas() atlas <" + atlasId + "> hasn\'t been defined in group <" + this.mId + "> in resources_queue.xml.","E_LOADER_ERROR");
         }
         else
         {
            if(this.mAtlasRequests == null)
            {
               this.mAtlasRequests = new Dictionary(true);
            }
            if(this.mAtlasRequests[atlasId] == null)
            {
               this.mAtlasRequests[atlasId] = new Vector.<EAssetRequest>(0);
            }
            v = this.mAtlasRequests[atlasId];
            if((r = this.atlasGetAssetRequest(atlasId,assetId)) == null)
            {
               r = new EAssetRequest(assetId,this.mId,priority,completeFunc,errorFunc);
               v.push(r);
               eResourcesMng.loadAtlas(atlasId,this.mId,priority,this.atlasOnComplete,this.atlasOnError);
            }
            else
            {
               r.addRequest(completeFunc,errorFunc);
            }
         }
      }
      
      private function atlasGetAssetRequest(atlasId:String, assetId:String) : EAssetRequest
      {
         var v:Vector.<EAssetRequest> = null;
         var i:int = 0;
         var length:int = 0;
         var returnValue:EAssetRequest = null;
         if(this.mAtlasRequests != null)
         {
            if((v = this.mAtlasRequests[atlasId]) != null)
            {
               length = int(v.length);
               i = 0;
               while(i < length && returnValue == null)
               {
                  returnValue = v[i];
                  if(returnValue.getAssetId() != assetId)
                  {
                     returnValue = null;
                  }
                  i++;
               }
            }
         }
         return returnValue;
      }
      
      private function atlasOnComplete(assetId:String, groupId:String) : void
      {
         var tokens:Array;
         var atlasId:String = String((tokens = assetId.split("/"))[0]);
         var extension:String = String(tokens[1]);
         var otherFileId:* = atlasId + "/";
         if(extension == "xml")
         {
            otherFileId += "png";
         }
         else
         {
            otherFileId += "xml";
         }
         if(Esparragon.getResourcesMng().isAssetLoaded(otherFileId,groupId))
         {
            this.atlasDoSuccess(atlasId,groupId);
         }
      }
      
      private function atlasOnError(assetId:String, groupId:String) : void
      {
         var tokens:Array;
         var atlasId:String = String((tokens = assetId.split("/"))[0]);
         this.atlasDoError(atlasId,groupId);
      }
      
      private function atlasDoSuccess(atlasId:String, groupId:String) : void
      {
         var v:Vector.<EAssetRequest> = null;
         var r:EAssetRequest = null;
         var assetId:String = null;
         if(this.mAtlasRequests != null)
         {
            if((v = this.mAtlasRequests[atlasId]) != null)
            {
               assetId = atlasGetPngId(atlasId);
               while(v.length > 0)
               {
                  r = v.shift();
                  r.success(assetId);
                  r.destroy();
               }
               delete this.mAtlasRequests[atlasId];
            }
         }
      }
      
      private function atlasDoError(atlasId:String, groupId:String) : void
      {
         var v:Vector.<EAssetRequest> = null;
         var r:EAssetRequest = null;
         var assetId:String = null;
         if(this.mAtlasRequests != null)
         {
            if((v = this.mAtlasRequests[atlasId]) != null)
            {
               assetId = atlasGetPngId(atlasId);
               while(v.length > 0)
               {
                  r = v.shift();
                  r.error(assetId);
               }
               delete this.mAtlasRequests[atlasId];
            }
         }
      }
      
      public function atlasGetSubTexture(atlasId:String, frameId:String, throwError:Boolean = false) : ESubTexture
      {
         var d:Dictionary = null;
         var eResourcesMng:EResourcesMng = null;
         var xmlId:String = null;
         var xml:XML = null;
         var xmlList:XMLList = null;
         var frameXml:XML = null;
         var name:String = null;
         var returnValue:ESubTexture = null;
         if(this.mAtlasSubTextures != null && this.mAtlasSubTextures[atlasId] != null)
         {
            if((d = this.mAtlasSubTextures[atlasId])[frameId] != null)
            {
               returnValue = d[frameId];
            }
         }
         if(returnValue == null)
         {
            eResourcesMng = Esparragon.getResourcesMng();
            xmlId = atlasGetXmlId(atlasId);
            if(eResourcesMng.isAssetLoaded(xmlId,this.mId))
            {
               if(this.mAtlasSubTextures == null)
               {
                  this.mAtlasSubTextures = new Dictionary(true);
               }
               if(this.mAtlasSubTextures[atlasId] == null)
               {
                  this.mAtlasSubTextures[atlasId] = new Dictionary(true);
               }
               d = this.mAtlasSubTextures[atlasId];
               xml = eResourcesMng.getAssetXML(xmlId,this.mId);
               xmlList = EUtils.xmlGetChildrenList(xml,"SubTexture");
               for each(frameXml in xmlList)
               {
                  name = EUtils.xmlReadString(frameXml,"name");
                  if(frameId == name)
                  {
                     (returnValue = new ESubTexture()).fromXml(frameXml);
                     d[frameId] = returnValue;
                     break;
                  }
               }
            }
         }
         if(returnValue == null && throwError)
         {
            Esparragon.throwError("Class [EGroup].atlasGetSubTexture() frame Id <" + frameId + "> hasn\'t been defined in atlas Id <" + atlasId + "> in group <" + this.mId + "> in resources_queue.xml.","E_LOADER_ERROR");
         }
         return returnValue;
      }
      
      private function destroyMovieClips() : void
      {
         var k:* = null;
         var j:* = null;
         var assetId:String = null;
         if(this.mMovieClips != null)
         {
            for(k in this.mMovieClips)
            {
               for(j in this.mMovieClips[k])
               {
                  delete this.mMovieClips[k][j];
               }
               delete this.mMovieClips[k];
            }
            this.mMovieClips = null;
         }
      }
      
      public function addMovieClip(swfAssetId:String, clipName:String, mc:EMovieClip, onLoaded:Function = null) : void
      {
         if(this.mMovieClips == null)
         {
            this.mMovieClips = new Dictionary(true);
         }
         if(this.mMovieClips[swfAssetId] == null)
         {
            this.mMovieClips[swfAssetId] = new Dictionary(true);
         }
         var d:Dictionary;
         if((d = this.mMovieClips[swfAssetId])[clipName] == null)
         {
            d[clipName] = new Vector.<EMovieClip>();
         }
         var v:Vector.<EMovieClip>;
         if((v = d[clipName]).indexOf(mc) == -1)
         {
            v.push(mc);
         }
         var resourcesMng:EResourcesMng;
         if((resourcesMng = Esparragon.getResourcesMng()).isAssetLoaded(swfAssetId,this.mId))
         {
            this.setMovieClip(mc,swfAssetId,clipName);
         }
         else
         {
            resourcesMng.loadAsset(swfAssetId,this.mId,-1,this.onSwfLoaded,null);
         }
      }
      
      private function setMovieClip(mc:EMovieClip, swfAssetId:String, clipName:String) : void
      {
         var thisClass:Class;
         if((thisClass = InstanceMng.getEResourcesMng().getAssetSWF(swfAssetId,this.mId,clipName)) == null)
         {
            Esparragon.traceMsg("Clip with name " + EUtils.getNameInBrackets(clipName) + " wasn\'t found in " + swfAssetId,"E_ERROR");
         }
         else
         {
            mc.setMovieClip(this.mId,swfAssetId,clipName,thisClass);
         }
         var onSetMovieClip:Function;
         if((onSetMovieClip = Esparragon.getResourcesMng().getOnSetMovieClip()) != null)
         {
            onSetMovieClip(mc);
         }
      }
      
      public function removeMovieClip(mc:EMovieClip) : void
      {
         var swfAssetId:String = null;
         var clipName:String = null;
         var d:Dictionary = null;
         var v:Vector.<EMovieClip> = null;
         var index:int = 0;
         if(this.mMovieClips != null && mc != null)
         {
            swfAssetId = mc.getSwfAssetId();
            clipName = mc.getClipName();
            d = this.mMovieClips[swfAssetId];
            if(d != null && d[clipName] != null)
            {
               if((v = d[clipName]) != null)
               {
                  if((index = v.indexOf(mc)) > -1)
                  {
                     v.splice(index,1);
                  }
                  if(v.length == 0)
                  {
                     delete d[clipName];
                  }
               }
            }
         }
      }
      
      private function onSwfLoaded(swfAssetId:String, groupId:String) : void
      {
         var d:Dictionary = null;
         var k:* = null;
         var clipName:String = null;
         var i:int = 0;
         var v:Vector.<EMovieClip> = null;
         var length:int = 0;
         var mc:EMovieClip = null;
         var resourcesMng:EResourcesMng = null;
         if(this.mMovieClips != null)
         {
            d = this.mMovieClips[swfAssetId];
            if(d != null)
            {
               resourcesMng = Esparragon.getResourcesMng();
               for(k in d)
               {
                  clipName = k as String;
                  length = int((v = d[clipName]).length);
                  for(i = 0; i < length; )
                  {
                     mc = v[i];
                     this.setMovieClip(mc,swfAssetId,clipName);
                     i++;
                  }
               }
            }
         }
      }
   }
}
