package esparragon.skins
{
   import com.gskinner.geom.ColorMatrix;
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.resources.EResourcesMng;
   import esparragon.resources.textureBuilders.ETextureBuilder;
   import esparragon.utils.EUtils;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   
   public class ESkin
   {
      
      public static const PROP_KEY_EMPTY:String = "empty";
      
      public static const PROP_KEY_COLOR:String = "color";
      
      public static const PROP_KEY_INTENSITY:String = "intensity";
      
      public static const PROP_KEY_PROPS:String = "props";
      
      public static const PROP_KEY_STROKE:String = "stroke";
      
      public static const PROP_KEY_GLOW:String = "glow";
      
      public static const PROP_KEY_COLOR_HUE:String = "colorHUE";
      
      public static const PROP_KEY_SAT_FILTER:String = "satFilter";
      
      public static const PROP_KEY_ALPHA:String = "alpha";
      
      public static const PROP_KEY_DROPSHADOW:String = "dropShadow";
      
      public static const PROP_KEY_DROPSHADOW_LIGHT:String = "dropShadowLight";
      
      public static const PROP_KEY_BOLD:String = "bold";
      
      public static const PROP_KEY_ROTATION:String = "rotation";
      
      public static const PROP_KEY_FLIP_X:String = "flipX";
      
      public static const PROP_KEY_FLIP_Y:String = "flipY";
      
      public static const PROP_KEY_FONT_NAME:String = "fontName";
      
      public static const PROP_KEY_TEXT_COLOR:String = "textColor";
      
      public static const PROP_KEY_TYPE:String = "type";
      
      public static const PROP_KEY_ASSET_ID:String = "assetId";
      
      public static const PROP_KEY_ASSET_IDS:String = "assetIds";
      
      public static const PROP_KEY_ATLAS_ID:String = "atlasId";
      
      public static const PROP_KEY_SWF_ID:String = "swfId";
      
      public static const PROP_KEY_IS_INVISIBLE_UNTIL_TEXTURE_BUILT:String = "isInvisibleUntilTextureBuilt";
      
      public static const PROP_KEY_OFF_X:String = "offX";
      
      public static const PROP_KEY_OFF_Y:String = "offY";
      
      public static const PROP_KEY_CENTER_TEXTURE:String = "centerTexture";
      
      private static const PROPS_SUPPORTED:Array = ["empty","color","intensity","props","stroke","glow","colorHUE","satFilter","alpha","dropShadow","dropShadowLight","bold","rotation","flipX","flipY","fontName","textColor","type","assetId","assetIds","atlasId","swfId","isInvisibleUntilTextureBuilt","offX","offY","centerTexture"];
      
      public static const TYPE_SINGLE_ASSET:String = "single_asset";
      
      public static const TYPE_TILED_AREA:String = "tiled_area";
      
      public static const TYPE_TILED_AREA_NO_FLIPPED_TOP_TRIMMING:String = "tiled_area_noflipped_top_trimming";
      
      public static const TYPE_TILED_AREA_NO_FLIPPED:String = "tiled_area_noflipped";
      
      public static const TYPE_TILED_ROW:String = "tiled_row";
      
      public static const TYPE_TILED_COLUMN:String = "tiled_column";
      
      public static const TYPE_TILED_X_FLIPPED:String = "tiled_x_flipped";
      
      public static const TYPE_SWF:String = "swf";
      
      private static const TYPES_SUPPORTED:Array = ["single_asset","tiled_area","tiled_area_noflipped_top_trimming","tiled_area_noflipped","tiled_row","tiled_column","tiled_x_flipped","swf"];
       
      
      private var mSkinSku:String;
      
      private var mProps:Dictionary;
      
      private var mAbstractPropSkus:Vector.<String>;
      
      private var mESprites:Dictionary;
      
      private var mFilters:Dictionary;
      
      public function ESkin(skinSku:String)
      {
         super();
         this.mSkinSku = skinSku;
      }
      
      public function setup() : void
      {
         this.mProps = new Dictionary(true);
      }
      
      public function destroy() : void
      {
         var k:* = null;
         this.mSkinSku = null;
         if(this.mProps != null)
         {
            for(k in this.mProps)
            {
               delete this.mProps[k];
            }
            this.mProps = null;
         }
         this.mAbstractPropSkus = null;
         if(this.mFilters != null)
         {
            for(k in this.mFilters)
            {
               delete this.mFilters[k];
            }
            this.mFilters = null;
         }
      }
      
      public function fromXml(info:XML, checkErrors:Boolean, storeAbstractProps:Boolean) : void
      {
         var tokensXML:XML = null;
         var t:XML = null;
         var propDef:ESkinPropDef = null;
         var sku:String = null;
         var msg:* = null;
         if(info != null)
         {
            tokensXML = EUtils.xmlGetChildrenListAsXML(info,"props");
            for each(t in EUtils.xmlGetChildrenList(tokensXML,"prop"))
            {
               if(checkErrors)
               {
                  this.checkXml(t,storeAbstractProps);
               }
               (propDef = new ESkinPropDef()).fromXml(t);
               sku = propDef.getSku();
               if(checkErrors)
               {
                  if(this.mProps[sku] != null)
                  {
                     msg = "Property with sku " + EUtils.getNameInBrackets(sku) + " defined twice.";
                     Esparragon.traceMsg(msg,this.mSkinSku,true,10);
                  }
               }
               this.mProps[sku] = propDef;
            }
         }
      }
      
      private function checkXml(info:XML, storeAbstractProps:Boolean) : void
      {
         var attr:XML = null;
         var name:String = null;
         var index:int = 0;
         var sku:String = null;
         var msg:* = null;
         var attributes:XMLList = EUtils.xmlGetAttributesAsXMLList(info);
         var propSkusNotSupported:* = null;
         var attributesCount:int = 0;
         for each(attr in attributes)
         {
            if((name = String(attr.name())) == "sku")
            {
               sku = EUtils.xmlReadString(info,name);
            }
            else if((index = PROPS_SUPPORTED.indexOf(name)) == -1)
            {
               name = EUtils.getNameInBrackets(name);
               if(propSkusNotSupported == null)
               {
                  propSkusNotSupported = name;
               }
               else
               {
                  propSkusNotSupported += ", " + name;
               }
            }
            else
            {
               this.checkAttribute(info,name);
               attributesCount++;
            }
         }
         if(sku == null)
         {
            msg = "Attribute " + EUtils.getNameInBrackets("sku") + " must be defined.";
            Esparragon.traceMsg(msg,this.mSkinSku,true,10);
         }
         else
         {
            if(propSkusNotSupported != null)
            {
               msg = "Attributes " + propSkusNotSupported + " in prop with sku " + EUtils.getNameInBrackets(sku) + " are not supported by the engine.";
               Esparragon.traceMsg(msg,this.mSkinSku,true,10);
            }
            if(storeAbstractProps && attributesCount == 0)
            {
               if(this.mAbstractPropSkus == null)
               {
                  this.mAbstractPropSkus = new Vector.<String>(0);
               }
               if(this.mAbstractPropSkus.indexOf(sku) == -1)
               {
                  this.mAbstractPropSkus.push(sku);
               }
            }
         }
      }
      
      private function checkAttribute(info:XML, name:String) : void
      {
         var value:String = null;
         var msg:String = null;
         var propMissing:* = null;
         var sku:String = EUtils.xmlReadString(info,"sku");
         sku = EUtils.getNameInBrackets(sku);
         var prefix:* = "Prop with sku " + sku + ": ";
         var _loc8_:* = name;
         if("type" === _loc8_)
         {
            value = EUtils.xmlReadString(info,name);
            if(TYPES_SUPPORTED.indexOf(value) > -1)
            {
               propMissing = null;
               switch(value)
               {
                  case "single_asset":
                     if(!EUtils.xmlIsAttribute(info,"assetId") && !EUtils.xmlIsAttribute(info,"assetIds"))
                     {
                        propMissing = EUtils.getNameInBrackets("assetId");
                     }
                     break;
                  case "swf":
                     if(!EUtils.xmlIsAttribute(info,"assetId") && !EUtils.xmlIsAttribute(info,"assetIds"))
                     {
                        propMissing = EUtils.getNameInBrackets("assetId");
                     }
                     if(!EUtils.xmlIsAttribute(info,"swfId"))
                     {
                        if(propMissing == null)
                        {
                           propMissing = "";
                        }
                        else
                        {
                           propMissing += ",";
                        }
                        propMissing += EUtils.getNameInBrackets("swfId");
                     }
                     break;
                  default:
                     if(!EUtils.xmlIsAttribute(info,"assetIds"))
                     {
                        propMissing = EUtils.getNameInBrackets("assetIds");
                     }
               }
               if(propMissing != null)
               {
                  msg = prefix + propMissing + " needs to be defined for a prop of type " + EUtils.getNameInBrackets(value);
                  Esparragon.traceMsg(msg,this.mSkinSku,true,10);
               }
            }
            else
            {
               value = EUtils.getNameInBrackets(value);
               msg = prefix + value + " is not a valid value for the attribute " + EUtils.getNameInBrackets(name);
               Esparragon.traceMsg(msg,this.mSkinSku,true,10);
            }
         }
      }
      
      public function build(parentSkin:ESkin) : void
      {
         var k:* = null;
         var propDef:ESkinPropDef = null;
         var sku:String = null;
         var values:Dictionary = null;
         var j:int = 0;
         var length:int = 0;
         var key:String = null;
         var value:String = null;
         var propDefToExpand:ESkinPropDef = null;
         var keys:Vector.<Object> = null;
         var parentProps:Dictionary = parentSkin.getProps();
         for(k in parentProps)
         {
            propDef = parentProps[k];
            sku = propDef.getSku();
            if(this.mProps[sku] == null)
            {
               this.mProps[sku] = new ESkinPropDef(propDef);
            }
         }
         for(k in this.mProps)
         {
            propDef = this.mProps[k];
            this.expandPropDef(propDef);
            values = propDef.getValues();
            keys = EUtils.getDictionaryKeys(values);
            length = int(keys.length);
            for(j = 0; j < length; )
            {
               if((key = keys[j] as String) != "assetId" && key != "assetIds" && key != "swfId")
               {
                  value = String(values[key]);
                  values[key] = this.getValue(value,key);
               }
               j++;
            }
         }
      }
      
      private function expandPropDef(def:ESkinPropDef) : void
      {
         var propValue:String = null;
         var defToExpand:ESkinPropDef = null;
         var values:Dictionary = null;
         var expandedValues:Dictionary = null;
         var k:* = null;
         var key:String = null;
         var msg:String = null;
         if(def.hasKey("props"))
         {
            propValue = def.getValueAsString("props");
            defToExpand = this.mProps[propValue];
            values = def.getValues();
            delete values["props"];
            if(defToExpand != null)
            {
               this.expandPropDef(defToExpand);
               expandedValues = defToExpand.getValues();
               for(k in expandedValues)
               {
                  key = k as String;
                  if(!def.hasKey(key))
                  {
                     values[key] = expandedValues[key];
                  }
               }
            }
            else
            {
               msg = EUtils.getNameInBrackets(propValue) + " defined as <props> not found for prop with sku " + EUtils.getNameInBrackets(def.getSku());
               Esparragon.traceMsg(msg,this.getSku(),false,10);
            }
         }
      }
      
      public function getSku() : String
      {
         return this.mSkinSku;
      }
      
      public function containsESprite(s:ESprite) : Boolean
      {
         return this.mESprites != null && this.mESprites[s] != undefined;
      }
      
      public function getValue(sku:String, key:String) : String
      {
         var returnValue:* = null;
         var propDef:ESkinPropDef = this.mProps[sku];
         if(propDef == null)
         {
            returnValue = sku;
         }
         else if(propDef.hasKey(key))
         {
            returnValue = this.getValue(propDef.getValueAsString(key),key);
         }
         else
         {
            if(key == "textColor" || key == "stroke" || key == "glow")
            {
               key = "color";
            }
            returnValue = this.getValue(propDef.getValueAsString(key),key);
         }
         return propDef == null ? sku : this.getValue(propDef.getValueAsString(key),key);
      }
      
      public function getProps() : Dictionary
      {
         return this.mProps;
      }
      
      public function getAbstractPropSkus() : Vector.<String>
      {
         return this.mAbstractPropSkus;
      }
      
      public function getPropDef(propSku:String) : ESkinPropDef
      {
         return this.mProps != null ? this.mProps[propSku] : null;
      }
      
      private function getFilter(k:String) : Object
      {
         return this.mFilters != null && this.mFilters[k] != undefined ? this.mFilters[k] : null;
      }
      
      private function registerFilter(key:String, filter:Object) : void
      {
         if(this.mFilters == null)
         {
            this.mFilters = new Dictionary(true);
         }
         this.mFilters[key] = filter;
      }
      
      private function registerPropInESprite(propSku:String, s:ESprite) : void
      {
         this.registerESprite(s);
         var v:Vector.<String> = this.mESprites[s];
         if(v.indexOf(propSku) == -1)
         {
            v.push(propSku);
         }
      }
      
      private function unregisterPropInESprite(propSku:String, s:ESprite) : void
      {
         var v:Vector.<String> = null;
         var index:int = 0;
         if(this.mESprites != null)
         {
            v = this.mESprites[s];
            if(v != null)
            {
               if((index = v.indexOf(propSku)) > -1)
               {
                  v.splice(index,1);
               }
            }
         }
      }
      
      public function registerESprite(s:ESprite) : void
      {
         if(this.mESprites == null)
         {
            this.mESprites = new Dictionary(true);
         }
         if(this.mESprites[s] == null)
         {
            this.mESprites[s] = new Vector.<String>(0);
         }
      }
      
      public function unregisterESprite(s:ESprite) : void
      {
         var v:Vector.<String> = null;
         if(this.mESprites != null && this.mESprites[s] != null)
         {
            v = this.mESprites[s];
            v.length = 0;
            delete this.mESprites[s];
         }
      }
      
      private function hasPropBeenAppliedToESprite(propSku:String, s:ESprite) : Boolean
      {
         var d:Vector.<String> = null;
         var returnValue:* = false;
         if(this.mESprites != null)
         {
            if((d = this.mESprites[s]) != null)
            {
               returnValue = d.indexOf(propSku) > -1;
            }
         }
         return returnValue;
      }
      
      public function existProp(propSku:String) : Boolean
      {
         var def:ESkinPropDef = this.getPropDef(propSku);
         return def != null;
      }
      
      public function applyPropToESprite(propSku:String, s:ESprite) : Boolean
      {
         var def:ESkinPropDef = this.getPropDef(propSku);
         if(def != null)
         {
            if(s is EImage && this.isAPropTexture(propSku))
            {
               this.applyPropTextureToEImage(propSku,s as EImage);
            }
            this.applyPropAttributesToESprite(def,s);
            this.registerPropInESprite(propSku,s);
            return true;
         }
         return false;
      }
      
      public function unapplyPropToESprite(propSku:String, s:ESprite) : Boolean
      {
         var def:ESkinPropDef = null;
         var returnValue:Boolean = false;
         if(this.hasPropBeenAppliedToESprite(propSku,s))
         {
            if((def = this.getPropDef(propSku)) != null)
            {
               this.unapplyPropAttributesToESprite(def,s);
               this.unregisterPropInESprite(propSku,s);
               returnValue = true;
            }
         }
         else
         {
            returnValue = true;
         }
         return returnValue;
      }
      
      private function applyPropAttributesToESprite(def:ESkinPropDef, s:ESprite) : void
      {
         var textField:ETextField = null;
         this.applyProps(def,s);
         this.applySatColor(def,s);
         this.applyColorHue(def,s);
         this.applyColor(def,s);
         this.applyFilter(def,s,"stroke");
         this.applyFilter(def,s,"glow");
         this.applyFilter(def,s,"dropShadow");
         this.applyFilter(def,s,"dropShadowLight");
         this.applyAlpha(def,s);
         this.applyRotation(def,s);
         this.applyFlipX(def,s);
         this.applyFlipY(def,s);
         if(s is ETextField)
         {
            textField = s as ETextField;
            this.applyFontName(def,textField);
            this.applyFontBold(def,textField);
            this.applyTextColor(def,textField);
         }
      }
      
      private function unapplyPropAttributesToESprite(def:ESkinPropDef, s:ESprite) : void
      {
         var textField:ETextField = null;
         this.unapplyProps(def,s);
         this.unapplySatColor(def,s);
         this.unapplyColor(def,s);
         this.unapplyColorHue(def,s);
         this.unapplyFilter(def,s,"stroke");
         this.unapplyFilter(def,s,"glow");
         this.unapplyFilter(def,s,"dropShadow");
         this.unapplyFilter(def,s,"dropShadowLight");
         this.unapplyAlpha(def,s);
         this.unapplyRotation(def,s);
         this.unapplyFlipX(def,s);
         this.unapplyFlipY(def,s);
         if(s is ETextField)
         {
            textField = s as ETextField;
            this.unapplyFontBold(def,textField);
            this.unapplyTextColor(def,textField);
         }
      }
      
      private function applyPropTextureToEImage(propSku:String, image:EImage) : void
      {
         var currentTexture:ETexture = null;
         var resourcesMng:EResourcesMng = null;
         var textureBuilder:ETextureBuilder = null;
         var prevPropSku:String = null;
         if(image != null)
         {
            if((currentTexture = image.getTexture()) != null)
            {
               textureBuilder = (resourcesMng = Esparragon.getResourcesMng()).getTextureBuilder(currentTexture);
               if(textureBuilder != null)
               {
                  if((prevPropSku = textureBuilder.getLogicAssetSku()) != propSku)
                  {
                     this.unapplyPropToESprite(prevPropSku,image);
                     resourcesMng.setTextureToImage(propSku,this.mSkinSku,image.getLayoutArea(),image,true);
                  }
               }
            }
         }
      }
      
      private function isAPropTexture(propSku:String) : Boolean
      {
         var def:ESkinPropDef = this.getPropDef(propSku);
         return def != null && def.hasKey("type");
      }
      
      private function doProps(propDef:ESkinPropDef, s:ESprite, func:Function) : void
      {
         var props:Array = null;
         var propSku:String = null;
         var key:String = "props";
         if(propDef.hasKey(key))
         {
            props = propDef.getValueAsString(key).split(",");
            for each(propSku in props)
            {
               propSku = EUtils.trim(propSku);
               func(propSku,s);
            }
         }
      }
      
      private function applyProps(propDef:ESkinPropDef, s:ESprite) : void
      {
         this.doProps(propDef,s,this.applyPropToESprite);
      }
      
      private function unapplyProps(propDef:ESkinPropDef, s:ESprite) : void
      {
         this.doProps(propDef,s,this.unapplyPropToESprite);
      }
      
      private function applyFontName(propDef:ESkinPropDef, t:ETextField) : void
      {
         var key:String = "fontName";
         if(propDef.hasKey(key))
         {
            t.setFontName(propDef.getValueAsString(key));
         }
      }
      
      private function applyFontBold(propDef:ESkinPropDef, t:ETextField) : void
      {
         var key:String = "bold";
         if(propDef.hasKey(key))
         {
            t.setBold(propDef.getValueAsBoolean(key));
         }
      }
      
      private function unapplyFontBold(propDef:ESkinPropDef, t:ETextField) : void
      {
         t.setBold(false);
      }
      
      private function applyTextColor(propDef:ESkinPropDef, t:ETextField) : void
      {
         var key:String = "textColor";
         if(propDef.hasKey(key))
         {
            t.setTextColor(propDef.getValueAsColor(key));
         }
      }
      
      private function unapplyTextColor(propDef:ESkinPropDef, t:ETextField) : void
      {
         t.rollbackTextColor();
      }
      
      private function getFilterObject(propDef:ESkinPropDef, key:String) : Object
      {
         var returnValue:Object = null;
         var colorMatrix:ColorMatrix = null;
         switch(key)
         {
            case "stroke":
               returnValue = new GlowFilter(propDef.getValueAsColor(key),1,5,5,50);
               break;
            case "glow":
               returnValue = new GlowFilter(propDef.getValueAsColor(key),1,8,8,2,2);
               break;
            case "satFilter":
               (colorMatrix = new ColorMatrix()).adjustSaturation(-100);
               returnValue = new ColorMatrixFilter(colorMatrix.toArray());
               break;
            case "dropShadow":
               returnValue = new DropShadowFilter(3,90,propDef.getValueAsColor(key),0.5,2,2,3,3);
               break;
            case "dropShadowLight":
               returnValue = new DropShadowFilter(0,90,propDef.getValueAsColor(key),0.5,10,10,2,2);
         }
         return returnValue;
      }
      
      private function applyFilter(propDef:ESkinPropDef, s:ESprite, key:String, check:Boolean = true) : void
      {
         var color:String = null;
         var filterKey:String = null;
         var filter:Object = null;
         if(propDef.hasKey(key) || !check)
         {
            color = propDef.getValueAsString(key);
            filterKey = key + "_" + color;
            if((filter = this.getFilter(filterKey)) == null)
            {
               filter = this.getFilterObject(propDef,key);
               this.registerFilter(filterKey,filter);
            }
            s.addFilter(filter);
         }
      }
      
      private function unapplyFilter(propDef:ESkinPropDef, s:ESprite, key:String, check:Boolean = true) : void
      {
         var color:String = null;
         var filterKey:String = null;
         var filter:Object = null;
         if(propDef.hasKey(key) || !check)
         {
            color = propDef.getValueAsString(key);
            filterKey = key + "_" + color;
            if((filter = this.getFilter(filterKey)) != null)
            {
               s.removeFilter(filter);
            }
         }
      }
      
      private function applyColor(propDef:ESkinPropDef, s:ESprite) : void
      {
         var baseColor:uint = propDef.hasKey("color") ? propDef.getValueAsColor("color") : 16777215;
         var intensity:Number = propDef.hasKey("intensity") ? propDef.getValueAsNumber("intensity") : 1;
         if(propDef.hasKey("color") || propDef.hasKey("intensity"))
         {
            s.setColor(baseColor,intensity);
         }
      }
      
      private function unapplyColor(propDef:ESkinPropDef, s:ESprite) : void
      {
         if(propDef.hasKey("color") || propDef.hasKey("intensity"))
         {
            s.resetColor();
         }
      }
      
      private function applyRotation(propDef:ESkinPropDef, s:ESprite) : void
      {
         var key:String = "rotation";
         if(propDef.hasKey(key))
         {
            s.rotation = propDef.getValueAsNumber(key);
         }
      }
      
      private function applyFlipX(propDef:ESkinPropDef, s:ESprite) : void
      {
         var key:String = "flipX";
         if(propDef.getValueAsBoolean(key) && s is EImage)
         {
            (s as EImage).flipX();
         }
      }
      
      private function unapplyFlipX(propDef:ESkinPropDef, s:ESprite) : void
      {
         var eImage:EImage = null;
         var key:String = "flipX";
         if(propDef.getValueAsBoolean(key) && s is EImage)
         {
            eImage = s as EImage;
            if(eImage.isFlippedX())
            {
               eImage.flipX();
            }
         }
      }
      
      private function applyFlipY(propDef:ESkinPropDef, s:ESprite) : void
      {
         var key:String = "flipY";
         if(propDef.getValueAsBoolean(key) && s is EImage)
         {
            (s as EImage).flipY();
         }
      }
      
      private function unapplyFlipY(propDef:ESkinPropDef, s:ESprite) : void
      {
         var eImage:EImage = null;
         var key:String = "flipY";
         if(propDef.getValueAsBoolean(key) && s is EImage)
         {
            eImage = s as EImage;
            if(eImage.isFlippedY())
            {
               eImage.flipY();
            }
         }
      }
      
      private function unapplyRotation(propDef:ESkinPropDef, s:ESprite) : void
      {
         var key:String = "rotation";
         if(propDef.hasKey(key))
         {
            s.rotation = -propDef.getValueAsNumber(key);
         }
      }
      
      public function moveToSkin(skin:ESkin) : void
      {
         var k:* = null;
         var s:ESprite = null;
         var props:Vector.<String> = null;
         var propSku:String = null;
         var count:int = 0;
         if(this.mESprites != null)
         {
            count = 0;
            for(k in this.mESprites)
            {
               count++;
               s = ESprite(k);
               props = this.mESprites[k];
               skin.registerESprite(s);
               if(props != null)
               {
                  while(props.length > 0)
                  {
                     propSku = props[0];
                     this.unapplyPropToESprite(propSku,s);
                     skin.applyPropToESprite(propSku,s);
                  }
               }
            }
            this.mESprites = null;
         }
         if(this.mFilters != null)
         {
            for(k in this.mFilters)
            {
               delete this.mFilters[k];
            }
         }
      }
      
      private function applyColorHue(propDef:ESkinPropDef, s:ESprite) : void
      {
         var intensity:Number = NaN;
         var key:String = "colorHUE";
         if(propDef.hasKey(key))
         {
            this.applySatColor(propDef,s,false);
            intensity = 0.5;
            s.setColor(propDef.getValueAsColor(key),intensity);
         }
      }
      
      private function unapplyColorHue(propDef:ESkinPropDef, s:ESprite) : void
      {
         var key:String = "colorHUE";
         if(propDef.hasKey(key))
         {
            this.unapplySatColor(propDef,s,false);
            s.resetColor();
         }
      }
      
      private function applySatColor(propDef:ESkinPropDef, s:ESprite, check:Boolean = true) : void
      {
         var key:String = "satFilter";
         if(propDef.hasKey(key) || !check)
         {
            this.applyFilter(propDef,s,key,check);
         }
      }
      
      private function unapplySatColor(propDef:ESkinPropDef, s:ESprite, check:Boolean = true) : void
      {
         this.unapplyFilter(propDef,s,"satFilter",check);
      }
      
      private function applyAlpha(propDef:ESkinPropDef, s:ESprite) : void
      {
         var alpha:Number = NaN;
         var key:String = "alpha";
         if(propDef.hasKey(key))
         {
            alpha = propDef.getValueAsNumber(key);
            s.alpha = alpha;
         }
      }
      
      private function unapplyAlpha(propDef:ESkinPropDef, s:ESprite) : void
      {
         if(propDef.hasKey("alpha"))
         {
            s.alpha = 1;
         }
      }
   }
}
