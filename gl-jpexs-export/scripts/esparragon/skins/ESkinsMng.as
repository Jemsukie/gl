package esparragon.skins
{
   import com.dchoc.game.eview.skins.SkinsMng;
   import esparragon.core.Esparragon;
   import esparragon.display.ESprite;
   import esparragon.layout.ELayoutArea;
   import esparragon.resources.EResourcesMng;
   import esparragon.resources.textureBuilders.ETextureBuilder;
   import esparragon.resources.textureBuilders.ETextureBuilderSingleAsset;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledArea;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledAreaNoFlipped;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledAreaNoFlippedTopTrimming;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledColumn;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledRow;
   import esparragon.resources.textureBuilders.ETextureBuilderTiledXFlipped;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class ESkinsMng
   {
       
      
      private var mSkinSkus:Vector.<String>;
      
      private var mSkins:Dictionary;
      
      private var mSkinsLoaded:int;
      
      private var mCurrentSkinSku:String;
      
      private var mDefaultSkinSku:String;
      
      private var mCurrentFoundationSku:String;
      
      private var mDefaultFoundationSku:String;
      
      private var mCheckErrorsInDefinitions:Boolean;
      
      public function ESkinsMng()
      {
         super();
      }
      
      protected function doInit(skinSkus:Vector.<String>, groupId:String, defaultSkinSku:String, currentSkinSku:String, defaultFoundationSku:String, currentFoundationSku:String, checkErrorsInDefinitions:Boolean) : void
      {
         var sku:String = null;
         this.mSkinSkus = skinSkus;
         this.mDefaultSkinSku = defaultSkinSku;
         this.mCurrentSkinSku = currentSkinSku;
         this.mDefaultFoundationSku = defaultFoundationSku;
         this.mCurrentFoundationSku = currentFoundationSku;
         this.mSkinsLoaded = 0;
         this.mCheckErrorsInDefinitions = checkErrorsInDefinitions;
         var resourcesMng:EResourcesMng = Esparragon.getResourcesMng();
         for each(sku in this.mSkinSkus)
         {
            resourcesMng.loadAsset(sku,groupId,1,this.skinLoadOnSuccess,this.skinLoadOnError);
         }
      }
      
      public function destroy() : void
      {
         var k:* = null;
         var skin:ESkin = null;
         if(this.mSkinSkus != null)
         {
            this.mSkinSkus = null;
         }
         if(this.mSkins != null)
         {
            for(k in this.mSkins)
            {
               skin = this.mSkins[k];
               skin.destroy();
               delete this.mSkins[k];
            }
            this.mSkins = null;
         }
         this.mDefaultSkinSku = null;
         this.mCurrentSkinSku = null;
      }
      
      private function skinLoadOnSuccess(skinSku:String, groupId:String) : void
      {
         var skinXML:XML = Esparragon.getResourcesMng().getAssetXML(skinSku,groupId);
         var skin:ESkin;
         (skin = new ESkin(skinSku)).setup();
         skin.fromXml(skinXML,this.mCheckErrorsInDefinitions,this.mCheckErrorsInDefinitions && skinSku == this.mDefaultSkinSku);
         if(this.mSkins == null)
         {
            this.mSkins = new Dictionary(true);
         }
         this.mSkins[skinSku] = skin;
         this.mSkinsLoaded++;
         if(this.isReady())
         {
            this.buildSkins();
         }
      }
      
      private function skinLoadOnError(skinId:String, groupId:String) : void
      {
         Esparragon.traceMsg("Class [ESkinsMng].skinLoadOnError(). Error loading skin <" + skinId + "> in group <" + groupId + ">.","E_ERROR",true);
      }
      
      private function buildSkins() : void
      {
         var k:* = null;
         var sku:String = null;
         var skin:ESkin = null;
         var defaultSkin:ESkin = this.getSkinBySku(this.mDefaultSkinSku);
         for(k in this.mSkins)
         {
            if((sku = k as String) != this.mDefaultSkinSku)
            {
               skin = this.mSkins[sku];
               if(this.mCheckErrorsInDefinitions)
               {
                  this.checkErrorsInSkin(skin);
               }
               skin.build(defaultSkin);
            }
         }
      }
      
      public function isReady() : Boolean
      {
         return this.mSkinSkus == null ? false : this.mSkinsLoaded == this.mSkinSkus.length;
      }
      
      private function setSkinSkus(currentSkin:String) : void
      {
         this.mCurrentSkinSku = currentSkin;
         this.mDefaultSkinSku = currentSkin;
      }
      
      private function getSkinESprite(s:ESprite, assignCurrentSkinWhenNoFound:Boolean = true) : ESkin
      {
         var k:* = null;
         var skin:ESkin = null;
         for(k in this.mSkins)
         {
            skin = this.mSkins[k];
            if(skin.containsESprite(s))
            {
               return skin;
            }
         }
         if(assignCurrentSkinWhenNoFound)
         {
            return this.mSkins[this.mCurrentSkinSku];
         }
         return null;
      }
      
      public function registerESprite(s:ESprite, skinSku:String) : void
      {
         var newSkin:ESkin = null;
         var oldSkin:ESkin = this.getSkinESprite(s,false);
         if(oldSkin == null || oldSkin.getSku() != skinSku)
         {
            if((newSkin = this.getSkinBySku(skinSku)) != null)
            {
               newSkin.registerESprite(s);
               if(oldSkin != null)
               {
                  oldSkin.unregisterESprite(s);
               }
            }
         }
      }
      
      public function unregisterESprite(s:ESprite) : void
      {
         var skin:ESkin = this.getSkinESprite(s);
         if(skin != null)
         {
            skin.unregisterESprite(s);
         }
      }
      
      public function applyPropToSprite(skinSku:String, propSku:String, s:ESprite) : void
      {
         var skin:ESkin = null;
         if(skinSku == null)
         {
            skinSku = this.getSkinESprite(s).getSku();
         }
         if(this.existSkin(skinSku) && propSku != null)
         {
            if(!(skin = this.getSkinBySku(skinSku)).applyPropToESprite(propSku,s) && Config.DEBUG_MODE)
            {
               Esparragon.traceMsg("Class [ESkinsMng].applyPropToSprite(). prop <" + propSku + "> not defined for skin <" + skinSku + ">.","E_ERROR");
            }
         }
      }
      
      public function unapplyPropToSprite(skinSku:String, propSku:String, s:ESprite) : void
      {
         var skin:ESkin = null;
         if(skinSku == null)
         {
            skinSku = this.getSkinESprite(s).getSku();
         }
         if(this.existSkin(skinSku) && propSku != null)
         {
            if(!(skin = this.getSkinBySku(skinSku)).unapplyPropToESprite(propSku,s) && Config.DEBUG_MODE)
            {
               Esparragon.traceMsg("Class [ESkinsMng].unapplyPropToSprite(). prop <" + propSku + "> not defined for skin <" + skinSku + ">.","E_ERROR");
            }
         }
      }
      
      public function getTextureBuilder(textureSku:String, skinSku:String, atlasSku:String, area:ELayoutArea) : ETextureBuilder
      {
         var textureDef:ESkinPropDef = this.getTextureDef(textureSku,skinSku,atlasSku);
         return this.getTextureBuilderFromPropDef(textureDef,skinSku,area);
      }
      
      private function getTextureDef(textureSku:String, skinSku:String, atlasSku:String) : ESkinPropDef
      {
         var textureDef:ESkinPropDef = null;
         var str:* = null;
         var xml:XML = null;
         if(this.existSkin(skinSku))
         {
            if((textureDef = this.getSkinBySku(skinSku).getPropDef(textureSku)) == null)
            {
               textureDef = this.getSkinBySku(this.mDefaultSkinSku).getPropDef(textureSku);
            }
         }
         if(textureDef == null)
         {
            textureDef = new ESkinPropDef();
            str = "<prop sku=\"" + textureSku + "\" type=\"single_asset\" assetId=\"" + textureSku;
            if(atlasSku != null)
            {
               str += "\" atlasId=\"" + atlasSku;
            }
            str += "\"/>";
            xml = EUtils.stringToXML(str);
            textureDef.fromXml(xml);
         }
         return textureDef;
      }
      
      private function getTextureBuilderFromPropDef(def:ESkinPropDef, skinSku:String, area:ELayoutArea) : ETextureBuilder
      {
         var textureSku:String = null;
         var assetIdsString:String = null;
         var centerTexture:Boolean = false;
         var atlasId:String = null;
         var type:String = null;
         var returnValue:ETextureBuilder = null;
         if(def != null)
         {
            textureSku = def.getSku();
            assetIdsString = def.getValueAsString("assetIds");
            centerTexture = def.getValueAsBoolean("centerTexture");
            atlasId = def.getValueAsString("atlasId");
            switch(type = def.getValueAsString("type"))
            {
               case "single_asset":
                  returnValue = new ETextureBuilderSingleAsset(def,skinSku);
                  break;
               case "tiled_area":
                  returnValue = new ETextureBuilderTiledArea(def,skinSku,centerTexture,area.width,area.height,false);
                  break;
               case "tiled_area_noflipped_top_trimming":
                  returnValue = new ETextureBuilderTiledAreaNoFlippedTopTrimming(def,skinSku,centerTexture,area.width,area.height,false);
                  break;
               case "tiled_area_noflipped":
                  returnValue = new ETextureBuilderTiledAreaNoFlipped(def,skinSku,centerTexture,area.width,area.height,false);
                  break;
               case "tiled_row":
                  returnValue = new ETextureBuilderTiledRow(def,skinSku,centerTexture,area.width,area.height);
                  break;
               case "tiled_column":
                  returnValue = new ETextureBuilderTiledColumn(def,skinSku,centerTexture,area.width,area.height);
                  break;
               case "tiled_x_flipped":
                  returnValue = new ETextureBuilderTiledXFlipped(def,skinSku,centerTexture,area.width,area.height);
                  break;
               default:
                  if(Config.DEBUG_MODE)
                  {
                     Esparragon.throwError("Class [EskinsMng].getTextureBuilderFromPropDef() type <" + type + "> not supported for sku <" + textureSku + "> in skin <" + skinSku + ">.","E_ERROR");
                  }
            }
         }
         return returnValue;
      }
      
      public function getSkinBySku(skinSku:String) : ESkin
      {
         return this.mSkins == null ? null : this.mSkins[skinSku] as ESkin;
      }
      
      public function getCurrentSkinSku() : String
      {
         return this.mCurrentSkinSku;
      }
      
      public function getDefaultSkinSku() : String
      {
         return this.mDefaultSkinSku;
      }
      
      public function getCurrentFoundationSku() : String
      {
         return SkinsMng.getValidFoundationSku(this.mCurrentFoundationSku);
      }
      
      public function getCurrentFoundationAsset() : String
      {
         return SkinsMng.getFoundationAssetFromSku(this.mCurrentFoundationSku);
      }
      
      public function setCurrentFoundationSku(input:String) : void
      {
         this.mCurrentFoundationSku = SkinsMng.getValidFoundationSku(input);
      }
      
      private function existSkin(skinSku:String) : Boolean
      {
         return this.getSkinBySku(skinSku) != null;
      }
      
      public function existPropInSkin(skinSku:String, propSku:String) : Boolean
      {
         var skin:ESkin = null;
         var returnValue:Boolean = false;
         if(this.existSkin(skinSku))
         {
            returnValue = (skin = this.getSkinBySku(skinSku)).existProp(propSku);
         }
         return returnValue;
      }
      
      public function changeSkin(skinSku:String) : void
      {
         var oldSkin:ESkin = null;
         var newSkin:ESkin = null;
         if(skinSku != this.mCurrentSkinSku)
         {
            oldSkin = this.getSkinBySku(this.mCurrentSkinSku);
            newSkin = this.getSkinBySku(skinSku);
            if(oldSkin != null && newSkin != null)
            {
               oldSkin.moveToSkin(newSkin);
            }
            Esparragon.getResourcesMng().moveResourcesBetweenGroups(this.mCurrentSkinSku,skinSku);
            this.setSkinSkus(skinSku);
         }
      }
      
      private function checkErrorsInSkin(skin:ESkin) : void
      {
         var sku:String = null;
         var i:int = 0;
         var msg:String = null;
         var defaultSkin:ESkin;
         var abstractPropSkus:Vector.<String> = (defaultSkin = this.getSkinBySku(this.mDefaultSkinSku)).getAbstractPropSkus();
         var props:Dictionary = skin.getProps();
         var length:int = int(abstractPropSkus.length);
         var propsNotImplemented:* = null;
         for(i = 0; i < length; )
         {
            sku = abstractPropSkus[i];
            if(props == null || props[sku] == null)
            {
               sku = EUtils.getNameInBrackets(sku);
               if(propsNotImplemented == null)
               {
                  propsNotImplemented = sku;
               }
               else
               {
                  propsNotImplemented += ", " + sku;
               }
            }
            i++;
         }
         if(propsNotImplemented != null)
         {
            msg = "The skin needs to implement the following abstract properties of <skin_default>: " + propsNotImplemented;
            Esparragon.traceMsg(msg,skin.getSku(),true,10);
         }
      }
   }
}
