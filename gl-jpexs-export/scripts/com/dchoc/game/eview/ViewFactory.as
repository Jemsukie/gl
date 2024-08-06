package com.dchoc.game.eview
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.layout.LayoutAreaFactoriesMng;
   import com.dchoc.game.eview.skins.SkinsMng;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.game.eview.widgets.hud.EHudNavigationBar;
   import com.dchoc.game.eview.widgets.hud.EHudProfileBasicView;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarHud;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarUmbrella;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.cache.GraphicsCacheMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.behaviors.EBehavior;
   import esparragon.core.Esparragon;
   import esparragon.display.EDisplayFactory;
   import esparragon.display.EGraphics;
   import esparragon.display.EImage;
   import esparragon.display.EMovieClip;
   import esparragon.display.EScrollArea;
   import esparragon.display.EScrollBar;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.display.ETexture;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactoriesMng;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.layout.behaviors.ELayoutBehavior;
   import esparragon.resources.EPool;
   import esparragon.skins.ESkin;
   import esparragon.skins.ESkinPropDef;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   
   public class ViewFactory extends EPool
   {
      
      public static const HALIGN_JUSTIFIED:int = 0;
      
      public static const HALIGN_CENTER:int = 1;
      
      public static const HALIGN_RIGHT:int = 2;
      
      public static const VALIGN_TOP:int = 0;
      
      public static const VALIGN_CENTER:int = 1;
      
      public static const VALIGN_TOP_NO_SPACE:int = 4;
      
      private static const SPEECH_BOX_MARGIN:Number = 16;
      
      public static const DROP_DOWN_DIRECTION_DOWN:String = "down";
      
      public static const DROP_DOWN_DIRECTION_UP:String = "up";
      
      public static const BUTTON_DISTRIBUTION_EQUAL:String = "equal";
      
      public static const BUTTON_DISTRIBUTION_TEXT_WIDTH:String = "textWidth";
      
      private static const TAB_TEXT_MARGIN:int = 10;
      
      public static const DEFAULT_BUTTON_DISTRIBUTION_PADDING:int = 8;
      
      public static const DISTRIBUTE_HORIZONTAL:int = 0;
      
      public static const DISTRIBUTE_VERTICAL:int = 1;
      
      public static const COLONIES_MAX:int = 12;
       
      
      private var mLayoutAreaFactoriesMng:LayoutAreaFactoriesMng;
      
      public function ViewFactory()
      {
         super();
      }
      
      private static function defaultEButtonCallback(evt:EEvent) : void
      {
         var button:EButton = evt.getTarget() as EButton;
         if(button)
         {
            if(Config.USE_SOUNDS)
            {
               SoundManager.getInstance().playSound(button.getSoundId(),0.7);
            }
            InstanceMng.getApplication().lastClickSetLabel(button.getFunnelLabel());
            if(button.getDefaultRemoveTooltipOnMouseUp())
            {
               ETooltipMng.getInstance().removeCurrentTooltip();
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this.mLayoutAreaFactoriesMng != null)
         {
            this.mLayoutAreaFactoriesMng.destroy();
            this.mLayoutAreaFactoriesMng = null;
         }
      }
      
      public function getMouseBehavior(sku:String) : EBehavior
      {
         return InstanceMng.getBehaviorsMng().getMouseBehavior(sku);
      }
      
      protected function getLayoutAreaFactoriesMng() : ELayoutAreaFactoriesMng
      {
         if(this.mLayoutAreaFactoriesMng == null)
         {
            this.mLayoutAreaFactoriesMng = new LayoutAreaFactoriesMng();
         }
         return this.mLayoutAreaFactoriesMng;
      }
      
      public function getLayoutAreaFactory(sku:String) : ELayoutAreaFactory
      {
         return this.getLayoutAreaFactoriesMng().getFactory(sku);
      }
      
      public function getLayoutAreaFactoryFromDisplayObjectContainer(dsp:DisplayObjectContainer) : ELayoutAreaFactory
      {
         return this.getLayoutAreaFactoriesMng().createFactoryFromDisplayObjectContainer(dsp);
      }
      
      private function addLoadingAnimToESprite(e:ESprite) : void
      {
         var area:ELayoutArea = null;
         var left:int = 0;
         var top:int = 0;
         var loadingTimeBox:DisplayObjectContainer;
         if((loadingTimeBox = new EmbeddedAssets.LoadingAnim#1()) != null)
         {
            loadingTimeBox.name = "loading";
            e.addChild(loadingTimeBox);
            area = e.getLayoutArea();
            if(area != null)
            {
               left = -area.pivotX * area.width;
               top = -area.pivotY * area.height;
               loadingTimeBox.x = left + area.width / 2;
               loadingTimeBox.y = top + area.height / 2;
            }
         }
         else
         {
            DCDebug.traceCh("VIEW_FACTORY"," LOADING ANIMATION not found.");
         }
      }
      
      private function removeLoadingAnimFromESprite(e:ESprite) : void
      {
         var child:DisplayObject = null;
         var i:int = 0;
         var length:int = e.numChildren;
         if(length > 1)
         {
            for(i = 0; i < length; )
            {
               if((child = e.getChildAt(i)) != null && child.name == "loading")
               {
                  e.removeChild(child);
                  break;
               }
               i++;
            }
         }
      }
      
      public function getResourceAsESprite(resourceId:String, skinSku:String, setLoading:Boolean = false, area:ELayoutArea = null, onLoaded:Function = null) : ESprite
      {
         var prop:ESkinPropDef = null;
         var isMovieClip:* = false;
         var type:String = null;
         var returnValue:ESprite = null;
         skinSku = this.getSkinSku(skinSku);
         var skin:ESkin;
         if((skin = InstanceMng.getSkinsMng().getSkinBySku(skinSku)) != null)
         {
            prop = skin.getPropDef(resourceId);
            isMovieClip = false;
            if(prop != null)
            {
               isMovieClip = (type = prop.getValueAsString("type")) == "swf";
            }
            if(isMovieClip)
            {
               ((returnValue = this.getEMovieClip(resourceId,skinSku,setLoading,area)) as EMovieClip).onSetTextureLoaded = onLoaded;
            }
            else
            {
               ((returnValue = this.getEImage(resourceId,skinSku,setLoading,area)) as EImage).onSetTextureLoaded = onLoaded;
            }
         }
         return returnValue;
      }
      
      public function getEMovieClip(resourceId:String, skinSku:String, setLoading:Boolean = false, area:ELayoutArea = null) : EMovieClip
      {
         var errorMsg:String = null;
         var prop:ESkinPropDef = null;
         var swfAssetId:String = null;
         var clipName:String = null;
         var propMissing:* = null;
         var returnValue:EMovieClip = null;
         skinSku = this.getSkinSku(skinSku);
         var skin:ESkin;
         if((skin = InstanceMng.getSkinsMng().getSkinBySku(skinSku)) != null)
         {
            if((prop = skin.getPropDef(resourceId)) == null)
            {
               errorMsg = EUtils.getNameInBrackets(resourceId) + " hasn\'t been defined for skin " + EUtils.getNameInBrackets(skinSku);
            }
            else
            {
               swfAssetId = prop.getValueAsString("swfId");
               if((clipName = prop.getValueAsString("assetId")) == null)
               {
                  clipName = prop.getValueAsString("assetIds");
               }
               if(swfAssetId != null && clipName != null)
               {
                  returnValue = Esparragon.getResourcesMng().getEMovieClip(swfAssetId,skinSku,clipName);
                  if(area != null)
                  {
                     returnValue.setLayoutArea(area,true);
                  }
                  if(setLoading && !returnValue.isTextureLoaded())
                  {
                     this.addLoadingAnimToESprite(returnValue);
                  }
               }
               else
               {
                  propMissing = null;
                  if(swfAssetId == null)
                  {
                     propMissing = EUtils.getNameInBrackets("swfId");
                  }
                  if(clipName == null)
                  {
                     if(propMissing == null)
                     {
                        propMissing = "";
                     }
                     else
                     {
                        propMissing += ",";
                     }
                     propMissing += EUtils.getNameInBrackets("assetId");
                  }
                  errorMsg = "Properties " + propMissing + " hasn\'t been defined for prop with sku " + EUtils.getNameInBrackets(resourceId) + " in skin " + EUtils.getNameInBrackets(skinSku);
               }
            }
         }
         if(errorMsg != null)
         {
            Esparragon.traceMsg(errorMsg,skinSku,Config.THROW_EXCEPTION_IF_ERROR_IN_ASSETS_OR_SKINS,10);
         }
         return returnValue;
      }
      
      public function onEMovieClipLoaded(mc:EMovieClip) : void
      {
         this.removeLoadingAnimFromESprite(mc);
      }
      
      public function getGraphics() : EGraphics
      {
         return Esparragon.getDisplayFactory().createGraphics();
      }
      
      public function getESpriteContainer() : ESpriteContainer
      {
         return new ESpriteContainer();
      }
      
      public function getESprite(skinSku:String, area:ELayoutArea = null) : ESprite
      {
         skinSku = this.getSkinSku(skinSku);
         var esp:ESprite = new ESprite();
         esp.setSkinSku(skinSku);
         if(area != null)
         {
            esp.setLayoutArea(area,true);
         }
         return esp;
      }
      
      public function getETextField(skinSku:String, area:ELayoutTextArea = null, propSku:String = null) : ETextField
      {
         skinSku = this.getSkinSku(skinSku);
         var returnValue:ETextField;
         (returnValue = Esparragon.getDisplayFactory().createTextField()).setSkinSku(skinSku);
         if(area != null)
         {
            returnValue.setLayoutArea(area,true);
         }
         if(propSku != null)
         {
            InstanceMng.getSkinsMng().applyPropToSprite(skinSku,propSku,returnValue);
         }
         return returnValue;
      }
      
      private function getSkinSku(skinSku:String) : String
      {
         return skinSku == null ? InstanceMng.getSkinsMng().getCurrentSkinSku() : skinSku;
      }
      
      private function applyPropsToESprite(skinSku:String, propSku:String, s:ESprite) : void
      {
         var skinsMng:SkinsMng;
         if((skinsMng = InstanceMng.getSkinsMng()).existPropInSkin(skinSku,propSku))
         {
            if(s != null)
            {
               s.setSkinSku(skinSku);
            }
            skinsMng.applyPropToSprite(skinSku,propSku,s);
         }
      }
      
      private function unapplyPropsToESprite(skinSku:String, propSku:String, s:ESprite) : void
      {
         var skinsMng:SkinsMng;
         if((skinsMng = InstanceMng.getSkinsMng()).existPropInSkin(skinSku,propSku))
         {
            skinsMng.unapplyPropToSprite(skinSku,propSku,s);
         }
      }
      
      public function getEImage(textureSku:String, skinSku:String = null, setLoading:Boolean = false, area:ELayoutArea = null, propSku:String = null) : EImage
      {
         skinSku = this.getSkinSku(skinSku);
         var returnValue:EImage = InstanceMng.getEResourcesMng().getEImage(textureSku,skinSku,area);
         if(area != null)
         {
            returnValue.setLayoutArea(area);
         }
         if(setLoading && (returnValue.getTexture() == null || !returnValue.getTexture().isLoaded()))
         {
            this.addLoadingAnimToESprite(returnValue);
         }
         this.applyPropsToESprite(skinSku,textureSku,returnValue);
         if(propSku != null)
         {
            this.applyPropsToESprite(skinSku,propSku,returnValue);
         }
         return returnValue;
      }
      
      public function getEImageProfileFromURL(url:String, skinSku:String, propSku:String) : EImage
      {
         skinSku = this.getSkinSku(skinSku);
         var graphicsCacheMng:GraphicsCacheMng = InstanceMng.getGraphicsCacheMng();
         var bitmapData:BitmapData = url == null ? graphicsCacheMng.getDefaultPicture() : graphicsCacheMng.getCachedImage(url);
         if(url == null)
         {
            url = "defaultProfileImg";
         }
         return this.getEImageFromBitmapData(url,bitmapData);
      }
      
      public function getEImageFromBitmapData(url:String, bitmapData:BitmapData) : EImage
      {
         var displayFactory:EDisplayFactory;
         var texture:ETexture = (displayFactory = Esparragon.getDisplayFactory()).createTextureFromBitmapData(bitmapData);
         var returnValue:EImage = Esparragon.getDisplayFactory().createImage(null);
         this.applyTextureToImage(returnValue,texture,url,null,true);
         return returnValue;
      }
      
      public function setTextureToImageFromURL(url:String, image:EImage, skinSku:String = null, propSku:String = null) : void
      {
         var graphicsCacheMng:GraphicsCacheMng = InstanceMng.getGraphicsCacheMng();
         var displayFactory:EDisplayFactory = Esparragon.getDisplayFactory();
         var bitmapData:BitmapData = url == null ? graphicsCacheMng.getDefaultPicture() : graphicsCacheMng.getCachedImage(url);
         var texture:ETexture = displayFactory.createTextureFromBitmapData(bitmapData);
         this.applyTextureToImage(image,texture,url,null,true);
         if(mImagesProfileFromUrl == null)
         {
            mImagesProfileFromUrl = new Dictionary();
         }
         if(url == null)
         {
            url = "defaultProfileImg";
         }
         mImagesProfileFromUrl[image] = url;
         this.applyPropsToESprite(skinSku,propSku,image);
      }
      
      public function setTextureToImage(textureId:String, skinSku:String, image:EImage) : void
      {
         var oldTextureId:String = null;
         skinSku = this.getSkinSku(skinSku);
         var skinsMng:SkinsMng;
         if((skinsMng = InstanceMng.getSkinsMng()).existPropInSkin(skinSku,textureId))
         {
            skinsMng.applyPropToSprite(skinSku,textureId,image);
         }
         else if((oldTextureId = InstanceMng.getEResourcesMng().setTextureToImage(textureId,skinSku,image.getLayoutArea(),image)) != textureId)
         {
            this.unapplyPropsToESprite(skinSku,oldTextureId,image);
         }
      }
      
      public function applyTextureToImage(image:EImage, texture:ETexture, assetId:String, atlasId:String, setTextureEngine:Boolean = false) : void
      {
         this.removeLoadingAnimFromESprite(image);
         if(setTextureEngine)
         {
            InstanceMng.getEResourcesMng().setETextureToEImage(image,texture);
         }
      }
      
      public function getSpeechBubble(areaSpeech:ELayoutArea, areaArrow:ELayoutArea, content:ESprite, skinSku:String, propSku:String = null, fitWidth:Boolean = false, textureName:String = null, verticalPadding:int = 0) : ESprite
      {
         var maxHeight:Number = NaN;
         var minHeight:Number = NaN;
         var currentHeight:* = NaN;
         var currentWidth:Number = NaN;
         var img:EImage = null;
         var area:ELayoutArea = null;
         var scale:Number = NaN;
         if(areaSpeech != null && areaArrow != null)
         {
            maxHeight = areaSpeech.height;
            minHeight = areaArrow.height + 16 * 2;
            currentWidth = areaSpeech.width;
            if(content != null)
            {
               if((currentHeight = content.getLogicHeight() + verticalPadding) < minHeight)
               {
                  currentHeight = minHeight;
               }
               if(content.getLogicHeight() > maxHeight)
               {
                  scale = maxHeight / content.getLogicHeight();
                  content.scaleLogicX = scale;
                  content.scaleLogicY = scale;
                  currentHeight = maxHeight;
               }
               if(fitWidth && content.getLogicWidth() < currentWidth)
               {
                  currentWidth = content.getLogicWidth();
               }
            }
            else
            {
               currentHeight = maxHeight;
            }
            skinSku = this.getSkinSku(skinSku);
            (area = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(areaSpeech)).height = currentHeight;
            area.width = currentWidth;
            if(textureName == null)
            {
               textureName = "box_simple";
            }
            (img = this.getEImage(textureName,skinSku,false,area,propSku)).logicX = areaSpeech.x + (areaSpeech.width - currentWidth) / 2;
            img.logicY = areaSpeech.y + (areaSpeech.height - currentHeight) / 2;
            if(content != null)
            {
               content.logicX = img.logicX + (currentWidth - content.getLogicWidth()) / 2;
               content.logicY = img.logicY + (currentHeight - content.getLogicHeight()) / 2;
            }
            return img;
         }
         if(areaSpeech == null)
         {
            throw new Error("We can\'t build speech bubble, areaSpeech is null");
         }
         throw new Error("We can\'t build speech bubble, areaArrow is null");
      }
      
      public function getButtonSocial(skinSku:String, area:ELayoutArea, text:String) : EButton
      {
         var w:Number = this.getMaxButtonSize(area);
         var button:EButton = this.getButtonByTextWidth(text,w,"btn_social");
         if(area != null)
         {
            button.layoutApplyTransformations(area);
         }
         return button;
      }
      
      public function getAttackButton(userInfo:UserInfo, area:ELayoutArea = null, buttonText:String = null, planet:Planet = null) : EButton
      {
         var button:EButton = null;
         var resource:String = null;
         var revengeId:String = InstanceMng.getUserInfoMng().getRevengeAvailable(userInfo);
         if(buttonText == null)
         {
            if(revengeId != null)
            {
               buttonText = DCTextMng.getText(321);
            }
            else
            {
               buttonText = DCTextMng.getText(145);
            }
         }
         if(this.userCanBeAttackedPlanet(userInfo,planet))
         {
            resource = "btn_can_attack";
         }
         else
         {
            resource = "btn_cant_attack";
         }
         var maxWith:Number = this.getMaxButtonSize(area);
         button = this.getButtonByTextWidth(buttonText,maxWith,resource);
         if(area != null)
         {
            button.setLayoutArea(area,true);
         }
         return button;
      }
      
      public function userCanBeAttacked(userInfo:UserInfo) : Boolean
      {
         var revengeId:String = InstanceMng.getUserInfoMng().getRevengeAvailable(userInfo);
         var attackObject:Object = InstanceMng.getApplication().createIsAttackableObject(userInfo.mAccountId,null,revengeId != null,false,true,true);
         return attackObject["isAttackableCheckTargetReasons"];
      }
      
      public function userCanBeAttackedPlanet(userInfo:UserInfo, planet:Planet) : Boolean
      {
         var revengeId:String = InstanceMng.getUserInfoMng().getRevengeAvailable(userInfo);
         var attackObject:Object = InstanceMng.getApplication().createIsAttackableObject(userInfo.mAccountId,planet,revengeId != null,false,true,true);
         DCDebug.traceCh("AttackLogic","[VFac] attackable? userInfo = " + userInfo + " | planet = " + planet + " | attackable = " + attackObject["isAttackableCheckTargetReasons"]);
         return attackObject["isAttackableCheckTargetReasons"];
      }
      
      public function configureAttackButton(userInfo:UserInfo, button:EButton, buttonText:String = null) : void
      {
         var planet:Planet = null;
         var area:ELayoutArea = null;
         var revengeId:String = null;
         if(buttonText == null)
         {
            if((revengeId = InstanceMng.getUserInfoMng().getRevengeAvailable(userInfo)) != null)
            {
               buttonText = DCTextMng.getText(321);
            }
            else
            {
               buttonText = DCTextMng.getText(145);
            }
         }
         button.setText(buttonText);
         var resource:String = "btn_cant_attack";
         if(userInfo != null)
         {
            if(this.userCanBeAttackedPlanet(userInfo,planet))
            {
               resource = "btn_can_attack";
            }
            else
            {
               resource = "btn_cant_attack";
            }
         }
         var background:EImage;
         if((background = button.getBackground()) != null)
         {
            area = background.getLayoutArea();
            background.destroy();
         }
         background = this.getEImage(resource,null,false,area);
         button.setBackground(background);
      }
      
      public function getButtonConfirm(skinSku:String, area:ELayoutArea = null, text:String = null) : EButton
      {
         var maxWidth:Number = this.getMaxButtonSize(area);
         if(text == null)
         {
            text = DCTextMng.getText(6);
         }
         return this.getButtonByTextWidth(text,maxWidth,"btn_accept",null,skinSku);
      }
      
      public function getButtonReload(skinSku:String, area:ELayoutArea = null) : EButton
      {
         var maxWidth:Number = this.getMaxButtonSize(area);
         var button:EButton = this.getButtonByTextWidth(DCTextMng.getText(287),maxWidth,"btn_accept",null,skinSku);
         button.eAddEventListener("click",this.onReloadGame);
         return button;
      }
      
      public function getButtonClose(skinSku:String, area:ELayoutArea = null) : EButton
      {
         var image:EImage = this.getEImage("btn_close",skinSku,false,area);
         return this.createButton(image,null,null);
      }
      
      public function getButtonRecycle(skinSku:String, area:ELayoutArea = null) : EButton
      {
         var maxWidth:Number = this.getMaxButtonSize(area);
         return this.getButtonByTextWidth(DCTextMng.getText(515),maxWidth,"btn_accept",null,skinSku);
      }
      
      public function getButtonCancel(skinSku:String, area:ELayoutArea = null, text:String = null) : EButton
      {
         if(text == null)
         {
            text = DCTextMng.getText(4);
         }
         var maxWidth:Number = this.getMaxButtonSize(area);
         return this.getButtonByTextWidth(text,maxWidth,"btn_cancel",null,skinSku);
      }
      
      private function getMaxButtonSize(area:ELayoutArea) : Number
      {
         var w:Number = 0;
         if(area != null)
         {
            w = area.width;
         }
         return w;
      }
      
      public function getButton(backgroundAssetId:String, skinSku:String, size:String, text:String = null, icon:String = null, shapeArea:ELayoutArea = null) : EButton
      {
         var iconImg:EImage = null;
         var img:EImage = null;
         var hasIcon:Boolean = icon != null && icon != "";
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = this.getLayoutAreaFactory(this.getButtonLayout(size,hasIcon))).getArea("base");
         skinSku = this.getSkinSku(skinSku);
         if(backgroundAssetId != null)
         {
            img = this.getEImage(backgroundAssetId,skinSku,false,area);
         }
         var textField:ETextField;
         (textField = this.getETextField(skinSku,layoutFactory.getTextArea("text"))).setText(text);
         textField.applySkinProp(skinSku,this.getButtonTextPropByButtonType(backgroundAssetId));
         if(hasIcon)
         {
            area = layoutFactory.getArea("icon");
            iconImg = this.getEImage(icon,skinSku,true,area,null);
         }
         var button:EButton = this.createButton(img,textField,iconImg);
         var buttonArea:ELayoutArea = layoutFactory.getContainerLayoutArea();
         button.setShapeArea(buttonArea,shapeArea);
         return button;
      }
      
      public function getButtonByTextWidth(text:String, maxWidth:Number, assetId:String, icon:String = null, skinSku:String = null, size:String = null, shapeArea:ELayoutArea = null) : EButton
      {
         if(shapeArea != null)
         {
            maxWidth = shapeArea.getOriginalWidth();
         }
         if(size == null)
         {
            size = "XXL";
         }
         var button:EButton;
         if((button = this.getButton(assetId,skinSku,size,text,icon,shapeArea)).getLayoutArea() != null && maxWidth == 0)
         {
            maxWidth = button.getLayoutArea().width;
         }
         this.setHeadersWidthByTextWidth(button,0,maxWidth);
         if(shapeArea != null)
         {
            button.setLayoutArea(shapeArea,true);
         }
         return button;
      }
      
      public function getButtonTextPropByButtonType(buttonType:String) : String
      {
         switch(buttonType)
         {
            case "btn_hud_attack":
               return "text_attack";
            case "btn_cancel":
               return "text_cancel";
            case "btn_can_attack":
               return "text_can_attack";
            case "btn_cant_attack":
               return "text_cant_attack";
            default:
               return "text_title_1";
         }
      }
      
      public function getButtonImage(assetId:String, skinSku:String, area:ELayoutArea = null) : EButton
      {
         var areaCopy:ELayoutArea = null;
         if(area)
         {
            areaCopy = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area,1);
         }
         var image:EImage = this.getEImage(assetId,skinSku,false,areaCopy,null);
         var button:EButton = this.createButton(image,null,null);
         if(area != null)
         {
            button.setLayoutArea(area,true);
         }
         return button;
      }
      
      public function getButtonIcon(backgroundId:String, assetId:String, skinSku:String, area:ELayoutArea = null, iconPropSku:String = null, checkResizeIcon:Boolean = false) : EButton
      {
         var areaCopy:ELayoutArea;
         (areaCopy = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area)).x = 0;
         areaCopy.y = 0;
         var bg:EImage = this.getEImage(backgroundId,skinSku,false,areaCopy);
         var image:EImage = this.getEImage(assetId,skinSku,false,areaCopy,null);
         this.distributeSpritesInArea(areaCopy,[image],1,1);
         if(iconPropSku)
         {
            image.applySkinProp(skinSku,iconPropSku);
         }
         var button:EButton = this.createButton(bg,null,image);
         if(area != null)
         {
            button.layoutApplyTransformations(area);
            button.setLayoutArea(area);
         }
         return button;
      }
      
      public function getButtonChips(price:String, area:ELayoutArea = null, skinSku:String = null, size:String = null) : EButton
      {
         var w:int = 0;
         var layoutFactory:ELayoutAreaFactory = null;
         if(size == null)
         {
            size = "XXL";
         }
         if(area != null)
         {
            w = area.getOriginalWidth();
         }
         else
         {
            area = (layoutFactory = this.getLayoutAreaFactory(this.getButtonLayout(size,true))).getTextArea("text");
            w = area.getOriginalWidth();
            area = null;
         }
         return this.getButtonByTextWidth(price,w,"btn_common","icon_chip",skinSku,size,area);
      }
      
      public function getButtonCredits(area:ELayoutArea, price:String, skinSku:String = null) : EButton
      {
         var maxWidth:Number = this.getMaxButtonSize(area);
         return this.getButtonByTextWidth(price,maxWidth,"btn_accept",null,skinSku);
      }
      
      public function getButtonPayment(area:ELayoutArea, entry:Entry, skinSku:String = null, size:String = null) : EButton
      {
         var button:EButton = null;
         var price:String = this.getStrPrice(entry);
         if(entry.getKey() == "credits")
         {
            price = DCTextMng.getText(13);
            button = this.getButtonCredits(area,price,skinSku);
            if(area != null)
            {
               button.layoutApplyTransformations(area);
            }
         }
         else
         {
            button = this.getButtonChips(price,area,skinSku,size);
         }
         return button;
      }
      
      public function getButtonIconLink(assetId:String, url:String, area:ELayoutArea = null, skinSku:String = null) : EButton
      {
         var button:EButton = this.getButtonIcon("btn_hud",assetId,skinSku,area);
         button.eAddEventListener("click",function():void
         {
            navigateToURL(new URLRequest(url),"_blank");
         });
         return button;
      }
      
      public function getButtonLayout(size:String, hasIcon:Boolean) : String
      {
         var name:String = "";
         if(hasIcon)
         {
            name = "I";
         }
         return name + ("Btn" + size.toUpperCase());
      }
      
      private function createButton(img:EImage, text:ETextField, iconImg:EImage, isCloseButton:Boolean = false, setDefaultButtonBehaviors:Boolean = true) : EButton
      {
         var button:EButton = new EButton(img,text,iconImg,"click.mp3");
         if(setDefaultButtonBehaviors)
         {
            this.setButtonBehaviors(button,isCloseButton);
         }
         this.setButtonListeners(button);
         return button;
      }
      
      private function setButtonListeners(sp:ESprite) : void
      {
         sp.eAddEventListener("click",defaultEButtonCallback);
      }
      
      public function setButtonBehaviors(sp:ESprite, isCloseButton:Boolean = false) : void
      {
         sp.eAddEventBehavior("Disable",this.getMouseBehavior("Disable"));
         sp.eAddEventBehavior("Enable",this.getMouseBehavior("Enable"));
         sp.eAddEventBehavior("rollOver",this.getMouseBehavior("MouseOverButton"));
         sp.eAddEventBehavior("rollOut",this.getMouseBehavior("MouseOutButton"));
         sp.eAddEventBehavior("mouseUp",this.getMouseBehavior("MouseUp"));
         sp.eAddEventBehavior("mouseDown",this.getMouseBehavior("MouseDown"));
         if(isCloseButton)
         {
            sp.eAddEventBehavior("rollOver",this.getMouseBehavior("MouseOverRed"));
         }
      }
      
      public function removeButtonBehaviors(sp:ESprite) : void
      {
         sp.eRemoveAllEventsBehaviors();
         sp.eRemoveAllEventsListeners();
      }
      
      public function setTextFieldClickableBehaviors(field:ETextField) : void
      {
         field.eAddEventBehavior("rollOver",this.getMouseBehavior("MouseOverUnderline"));
         field.eAddEventBehavior("rollOut",this.getMouseBehavior("MouseOutUnderline"));
         field.eAddEventBehavior("rollOver",this.getMouseBehavior("MouseOverSetCursorFinger"));
         field.eAddEventBehavior("rollOut",this.getMouseBehavior("MouseOutResetCursor"));
      }
      
      public function getDropDownSprite(skinSku:String, content:ESpriteContainer, layoutName:String, dropDirection:String, minWidth:int = 0, minHeight:int = 0) : EDropDownSprite
      {
         var dropdownSprite:EDropDownSprite = null;
         var s:ESprite = null;
         var tf:ETextField = null;
         var textFieldArea:ELayoutTextArea;
         var dropdownLayout:ELayoutAreaFactory;
         minWidth = !!(textFieldArea = (dropdownLayout = this.getLayoutAreaFactory(layoutName)).areaExist("text_title") ? dropdownLayout.getTextArea("text_title") : null) ? int(Math.max(textFieldArea.width,minWidth)) : minWidth;
         minHeight = !!textFieldArea ? int(Math.max(textFieldArea.height,minHeight)) : minHeight;
         dropdownSprite = new EDropDownSprite(1);
         var speechLayout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(dropdownLayout.getArea("content"));
         if(dropDirection == "up")
         {
            speechLayout.y -= content.getLogicHeight();
         }
         speechLayout.width += content.getLogicWidth();
         speechLayout.height += content.getLogicHeight();
         speechLayout.width = Math.max(minWidth,speechLayout.width);
         speechLayout.height = Math.max(minHeight,speechLayout.height);
         var offsetX:int = !!textFieldArea ? int(Math.max(textFieldArea.width,content.getLogicWidth()) / 2) : int(content.getLogicWidth() / 2);
         speechLayout.x -= offsetX;
         dropdownSprite.eAddChild(s = this.getEImage("tooltip_bkg",skinSku,false,speechLayout));
         dropdownSprite.setContent("speech",s);
         content.logicLeft = s.logicLeft + 8;
         content.logicTop = s.logicTop + 8;
         var resId:String = dropDirection == "up" ? "tooltip_arrow" : "tooltip_arrow_up";
         dropdownSprite.eAddChild(s = this.getEImage(resId,skinSku,false,dropdownLayout.getArea("arrow")));
         s.logicLeft = s.logicLeft;
         s.logicTop = s.logicTop;
         s.setPivotLogicXY(0.5,0.5);
         dropdownSprite.setContent("arrow",s);
         if(textFieldArea)
         {
            tf = this.getETextField(null,textFieldArea,"text_title");
            dropdownSprite.setContent("text_title",tf);
            dropdownSprite.eAddChild(tf);
            content.logicTop += tf.getLogicHeight();
            content.logicLeft += Math.max(0,(textFieldArea.width - content.getLogicWidth()) / 2);
         }
         dropdownSprite.eAddChild(content);
         dropdownSprite.setContent("content",content);
         return dropdownSprite;
      }
      
      public function getDropDownButtonFromContent(skinSku:String, content:ESpriteContainer, button:EButton, clickFunction:Function = null) : EDropDownButton
      {
         var dropdownSprite:EDropDownSprite;
         (dropdownSprite = this.getDropDownSprite(skinSku,content,"LayoutHudEmptyDropDown","up")).logicLeft = button.logicLeft + button.getLogicWidth() / 2;
         dropdownSprite.logicTop = button.logicTop;
         return this.getDropDownButton(button,dropdownSprite,clickFunction);
      }
      
      public function getDropDownButton(button:EButton, dropdown:EDropDownSprite, clickFunction:Function = null) : EDropDownButton
      {
         return new EDropDownButton(button,dropdown,clickFunction);
      }
      
      public function createFillBar(type:int, width:Number, height:Number, maxValue:Number, color:String = null) : EFillBar
      {
         var layout:ELayoutArea;
         (layout = new ELayoutArea()).width = width;
         layout.height = height;
         var image:EImage = this.getEImage("bar",this.getSkinSku(null),false,layout,color);
         var fillBar:EFillBar;
         (fillBar = Esparragon.getDisplayFactory().createFillBar(image,type,maxValue,-1)).applySkinProp(InstanceMng.getSkinsMng().getCurrentSkinSku(),color);
         return fillBar;
      }
      
      public function createFillbarSegments(fillbar:EFillBar, segments:int) : ESpriteContainer
      {
         var i:int = 0;
         var gfx:EGraphics = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var offsetX:Number = fillbar.getLogicWidth() / segments;
         var height:Number = fillbar.getLogicHeight();
         var count:int = segments - 1;
         for(i = 0; i < count; )
         {
            (gfx = Esparragon.getDisplayFactory().createGraphics()).drawRect(1,height,16777215);
            gfx.logicLeft = offsetX * (i + 1);
            container.setContent("segment" + i,gfx);
            container.eAddChild(gfx);
            i++;
         }
         container.applySkinProp(this.getSkinSku(null),"color_fillbar_separator");
         return container;
      }
      
      public function getContentOneText(layoutFactorySku:String, text:String, textProp:String, skinSku:String, textName:String = "text_info") : ESpriteContainer
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutFactorySku);
         var content:ESpriteContainer = this.getESpriteContainer();
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea(textName))).setText(text);
         if(field.height > field.textWithMarginHeight)
         {
            field.height = field.textWithMarginHeight;
         }
         field.applySkinProp(this.getSkinSku(skinSku),textProp);
         content.setContent(textName,field);
         content.eAddChild(field);
         return content;
      }
      
      public function getContentTextAndButton(skinSku:String, layoutFactorySku:String, text:String, textprop:String, buttonType:String, buttonSize:String, buttonText:String, buttonAction:Function) : ESprite
      {
         var container:ESpriteContainer = this.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutFactorySku);
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text_info"))).setText(text);
         field.applySkinProp(skinSku,textprop);
         container.setContent("text",field);
         container.eAddChild(field);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn");
         var button:EButton = this.getButton(buttonType,skinSku,buttonSize,buttonText);
         container.eAddChild(button);
         container.setContent("button",button);
         button.layoutApplyTransformations(buttonArea);
         if(buttonAction != null)
         {
            button.eAddEventListener("click",buttonAction);
         }
         return container;
      }
      
      public function getContentTwoTexts(layoutFactorySku:String, title:String, text:String, skinSku:String, propTitle:String = null, propText:String = null, assignLayout:Boolean = false) : ESpriteContainer
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutFactorySku);
         var content:ESpriteContainer = this.getESpriteContainer();
         skinSku = this.getSkinSku(skinSku);
         if(assignLayout)
         {
            content.setLayoutArea(layoutFactory.getContainerLayoutArea());
         }
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text_title"))).setText(title);
         field.applySkinProp(skinSku,propTitle);
         content.setContent("title",field);
         content.eAddChild(field);
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text_info"))).setText(text);
         field.applySkinProp(skinSku,propText);
         content.setContent("text",field);
         content.eAddChild(field);
         return content;
      }
      
      public function getContentIconWithTextHorizontal(layout:String, icon:String, text:String, skinSku:String, textProp:String = null, assignLayout:Boolean = false, setLoading:Boolean = true) : ESpriteContainer
      {
         var iconImg:EImage = null;
         skinSku = this.getSkinSku(skinSku);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layout);
         var espc:ESpriteContainer = this.getESpriteContainer();
         if(icon != null)
         {
            (iconImg = this.getEImage(icon,skinSku,setLoading,layoutFactory.getArea("icon"),null)).setSmooth(true);
            espc.setContent("icon",iconImg);
            espc.eAddChild(iconImg);
         }
         var field:ETextField = this.getETextField(skinSku,layoutFactory.getTextArea("text"));
         if(textProp != null)
         {
            field.applySkinProp(skinSku,textProp);
         }
         field.setText(text);
         field.autoSize(true);
         espc.setContent("text",field);
         espc.eAddChild(field);
         if(icon == null)
         {
            field.logicLeft = 0;
         }
         if(assignLayout)
         {
            espc.setLayoutArea(layoutFactory.getContainerLayoutArea());
         }
         return espc;
      }
      
      public function getContentIconWithTwoTextsHorizontal(layout:String, icon:String, text:String, textBottom:String, skinSku:String, topTextProp:String = null, bottomTextProp:String = null, assignLayout:Boolean = false, autosize1:Boolean = true, autosize2:Boolean = true) : ESpriteContainer
      {
         var iconImg:EImage = null;
         skinSku = this.getSkinSku(skinSku);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layout);
         var espc:ESpriteContainer = this.getESpriteContainer();
         if(icon != null)
         {
            (iconImg = this.getEImage(icon,skinSku,true,layoutFactory.getArea("icon"),null)).setSmooth(true);
            espc.setContent("icon",iconImg);
            espc.eAddChild(iconImg);
         }
         var field:ETextField = this.getETextField(skinSku,layoutFactory.getTextArea("text"));
         if(topTextProp != null)
         {
            field.applySkinProp(skinSku,topTextProp);
         }
         field.setText(text);
         field.autoSize(autosize1);
         espc.setContent("text",field);
         espc.eAddChild(field);
         if(icon == null)
         {
            field.logicLeft = 0;
         }
         field = this.getETextField(skinSku,layoutFactory.getTextArea("text_1"));
         if(bottomTextProp != null)
         {
            field.applySkinProp(skinSku,bottomTextProp);
         }
         field.setText(textBottom);
         field.autoSize(autosize2);
         espc.setContent("text_1",field);
         espc.eAddChild(field);
         if(icon == null)
         {
            field.logicLeft = 0;
         }
         if(assignLayout)
         {
            espc.setLayoutArea(layoutFactory.getContainerLayoutArea());
         }
         return espc;
      }
      
      public function getContentIconWithTextVertical(layout:String, icon:String, text:String, skinSku:String, textProp:String = null, assignLayout:Boolean = false) : ESpriteContainer
      {
         var iconImg:EImage = null;
         skinSku = this.getSkinSku(skinSku);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layout);
         var espc:ESpriteContainer = this.getESpriteContainer();
         if(icon != null)
         {
            (iconImg = this.getEImage(icon,skinSku,true,layoutFactory.getArea("icon"))).setSmooth(true);
            espc.setContent("icon",iconImg);
            espc.eAddChild(iconImg);
         }
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text"))).applySkinProp(skinSku,textProp);
         espc.setContent("text",field);
         espc.eAddChild(field);
         field.setText(text);
         if(assignLayout)
         {
            espc.setLayoutArea(layoutFactory.getContainerLayoutArea());
         }
         return espc;
      }
      
      public function readjustContentIconWithTextVertical(container:ESpriteContainer) : void
      {
         var fw:Number = NaN;
         var field:ETextField = container.getContentAsETextField("text");
         var itemsBkg:EImage = container.getContentAsEImage("icon");
         if(field != null)
         {
            field.autoSize(true);
            field.width = field.width;
            if(field.width <= itemsBkg.getLogicWidth())
            {
               itemsBkg.logicLeft = 0;
               field.logicLeft = (itemsBkg.getLogicWidth() - field.width) * 0.5;
            }
            else
            {
               field.logicLeft = 0;
               itemsBkg.logicLeft = (field.width - itemsBkg.getLogicWidth()) * 0.5;
            }
         }
         var containerArea:ELayoutArea;
         if((containerArea = container.getLayoutArea()) != null)
         {
            fw = Math.max(field.width,itemsBkg.getLogicWidth());
            (containerArea = new ELayoutArea(containerArea)).width = fw;
            container.setLayoutArea(containerArea);
         }
         if((containerArea = itemsBkg.getLayoutArea()) != null)
         {
            (containerArea = new ELayoutArea(containerArea)).x = itemsBkg.logicLeft;
            itemsBkg.setLayoutArea(containerArea);
         }
         if((containerArea = field.getLayoutArea()) != null)
         {
            (containerArea = new ELayoutArea(containerArea)).x = field.logicLeft;
            containerArea.width = field.width;
            field.setLayoutArea(containerArea);
         }
      }
      
      public function getLayoutByConditions(conditionsCount:int) : String
      {
         var returnValue:String = "IconTextLLarge";
         if(conditionsCount == 2)
         {
            returnValue = "IconTextS";
         }
         else if(conditionsCount >= 3)
         {
            returnValue = "IconTextSLarge";
         }
         return returnValue;
      }
      
      public function relocateChildInContainer(container:ESprite) : void
      {
         var i:int = 0;
         var element:ESprite = null;
         var elemCount:int = container.numChildren;
         for(i = 0; i < elemCount; )
         {
            if((element = container.eGetChildAt(i)) != null)
            {
               element.logicLeft -= container.logicLeft;
               element.logicTop -= container.logicTop;
            }
            i++;
         }
      }
      
      private function getTextTabHeader(text:String, layoutAreaFactoryName:String, bkgImageId:String, bkgImageUnselectedId:String, skinSku:String, propSku:String) : EButton
      {
         skinSku = this.getSkinSku(skinSku);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutAreaFactoryName);
         var bkg:EImage = this.getEImage(bkgImageId,skinSku,false,layoutFactory.getArea("base"));
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text"),!!propSku ? propSku : "text_btn_common")).setText(text);
         var button:EButton = this.createButton(bkg,field,null,false,false);
         if(bkgImageUnselectedId)
         {
            bkg = this.getEImage(bkgImageUnselectedId,skinSku,false,layoutFactory.getArea("base"));
            button.setContent("bkgUnselected",bkg);
         }
         return button;
      }
      
      public function getTextTabHeaderPopup(text:String, skinSku:String = null) : EButton
      {
         return this.getTextTabHeader(text,"TabHeader","tabHeader","tabHeaderUnselected",skinSku,null);
      }
      
      public function getTextTabHeaderHud(text:String, skinSku:String = null, propSku:String = null) : EButton
      {
         return this.getTextTabHeader(text,"LayoutHudNavigationTab","tab_hud",null,skinSku,propSku);
      }
      
      public function createButtonNotification(button:EButton) : void
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("TabHeader");
         var notification:ESpriteContainer = this.getNotificationArea(null,layoutFactory.getArea("notification_area"));
         var realX:int = layoutFactory.getArea("base").width - layoutFactory.getArea("notification_area").x;
         realX = button.width - realX;
         notification.logicLeft = realX;
         notification.visible = false;
         button.eAddChild(notification);
         button.setContent("notification",notification);
      }
      
      public function getPaginatorAssetSimple(area:ELayoutArea, factory:String, skinSku:String = null) : ESpriteContainer
      {
         var sp:ESpriteContainer;
         (sp = this.getESpriteContainer()).layoutApplyTransformations(area);
         skinSku = this.getSkinSku(skinSku);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(factory);
         var button:EButton = this.getButtonImage("btn_arrow",skinSku,layoutFactory.getContainerLayoutArea());
         sp.eAddChild(button);
         sp.setContent("arrowNext",button);
         button.logicLeft = area.width;
         button.logicTop = (area.height - button.height) / 2;
         button = this.getButtonImage("btn_arrow",skinSku,layoutFactory.getContainerLayoutArea());
         sp.eAddChild(button);
         sp.setContent("arrowPrevious",button);
         button.scaleLogicX = -1;
         button.logicLeft = 0;
         button.logicTop = (area.height - button.height) / 2;
         return sp;
      }
      
      public function getPaginatorAsset(skinSku:String) : ESpriteContainer
      {
         skinSku = this.getSkinSku(skinSku);
         var sp:ESpriteContainer = this.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("Pagination");
         sp.setLayoutArea(layoutFactory.getContainerLayoutArea());
         var textbkg:EImage = this.getEImage("bar",skinSku,false,layoutFactory.getArea("bar"));
         sp.eAddChild(textbkg);
         sp.setContent("bkg",textbkg);
         var field:ETextField = this.getETextField(skinSku,layoutFactory.getTextArea("text_numbers"));
         field.applySkinProp(skinSku,"text_body");
         sp.eAddChild(field);
         sp.setContent("textPage",field);
         field.setText("0/0");
         var button:EButton = this.getButtonImage("btn_arrow",skinSku,layoutFactory.getArea("btn_arrow_flip"));
         sp.eAddChild(button);
         sp.setContent("arrowPrevious",button);
         button = this.getButtonImage("btn_arrow",skinSku,layoutFactory.getArea("btn_arrow"));
         sp.eAddChild(button);
         sp.setContent("arrowNext",button);
         button = this.getButtonImage("btn_double_arrow",skinSku,layoutFactory.getArea("btn_doublearrow_flip"));
         sp.eAddChild(button);
         sp.setContent("arrowFirst",button);
         button = this.getButtonImage("btn_double_arrow",skinSku,layoutFactory.getArea("btn_doublearrow"));
         sp.eAddChild(button);
         sp.setContent("arrowLast",button);
         return sp;
      }
      
      public function getWarningStripe(skinSku:String, icon:String, bkgProp:String, msg:String, textProp:String, area:ELayoutArea = null) : ESpriteContainer
      {
         var container:ESpriteContainer = this.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("WarningStripe");
         container.setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = this.getEImage(bkgProp,skinSku,false,layoutFactory.getArea("stripe"));
         container.eAddChild(img);
         container.setContent("bkg",img);
         img = this.getEImage(icon,skinSku,true,layoutFactory.getArea("icon"));
         container.eAddChild(img);
         container.setContent("icon",img);
         var field:ETextField = this.getETextField(skinSku,layoutFactory.getTextArea("text_info"),textProp);
         container.eAddChild(field);
         container.setContent("text_info",field);
         field.setText(msg);
         container.setLayoutArea(area,true);
         return container;
      }
      
      public function getNotificationArea(skinSku:String, area:ELayoutArea = null) : ESpriteContainer
      {
         var s:ESprite = null;
         var returnValue:ESpriteContainer = this.getESpriteContainer();
         var layout:ELayoutAreaFactory = this.getLayoutAreaFactory("NotificationAreaHud");
         returnValue.eAddChild(s = this.getEImage("box_negative",skinSku,false,layout.getArea("base")));
         returnValue.setContent("bkg",s);
         returnValue.eAddChild(s = this.getETextField(skinSku,layout.getTextArea("text"),"text_title_3"));
         returnValue.setContent("text",s);
         ETextField(s).setText("0");
         returnValue.setLayoutArea(area,true);
         return returnValue;
      }
      
      public function getSingleEntryContainer(entryStr:String, layout:String, skinSku:String, useNegativeProp:Boolean = false) : ESpriteContainer
      {
         var returnValue:ESpriteContainer = null;
         var itemSku:String = null;
         var itemDef:ItemsDef = null;
         if(entryStr == null || entryStr == "")
         {
            return null;
         }
         var entry:Entry = EntryFactory.createEntryFromEntrySet(entryStr);
         var assetId:String = this.getResourceIdFromEntry(entry);
         var key:String = entry.getKey();
         var amount:Number = Number(entry.getAmount());
         var textProp:String = entry.getTextProp(useNegativeProp);
         if(amount < 0)
         {
            amount = -amount;
         }
         var amountStr:String = DCTextMng.convertNumberToString(amount,-1,-1);
         if(layout.indexOf("Vertical") > -1)
         {
            returnValue = this.getContentIconWithTextVertical(layout,assetId,amountStr,skinSku,textProp);
         }
         else
         {
            returnValue = this.getContentIconWithTextHorizontal(layout,assetId,amountStr,skinSku,textProp);
         }
         if(key == "items")
         {
            itemSku = entry.getItemSku();
            itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
            ETooltipMng.getInstance().createTooltipInfoFromDef(itemDef,!!returnValue.getContent("icon") ? returnValue.getContent("icon") : returnValue,null,true,false);
         }
         return returnValue;
      }
      
      public function getMultipleEntryContainers(entryStr:String, layout:String, skinSku:String, useNegativeProp:Boolean = false) : Array
      {
         var entriesStr:Array = null;
         var container:ESpriteContainer = null;
         var entriesCount:int = 0;
         var i:int = 0;
         var containers:Array = [];
         if(entryStr != null && entryStr != "")
         {
            entriesCount = int((entriesStr = entryStr.split(",")).length);
            for(i = 0; i < entriesCount; )
            {
               if((container = this.getSingleEntryContainer(entriesStr[i],layout,skinSku,useNegativeProp)) != null)
               {
                  containers.push(container);
               }
               i++;
            }
         }
         return containers;
      }
      
      public function getResourceIdFromEntry(entry:Entry) : String
      {
         var itemDef:ItemsDef = null;
         var resourceId:String = entry.getResourceId();
         if(resourceId == null)
         {
            switch(entry.getKey())
            {
               case "cash":
                  resourceId = "icon_chip";
                  break;
               case "coins":
                  resourceId = "icon_coins";
                  break;
               case "minerals":
                  resourceId = "icon_minerals";
                  break;
               case "score":
                  resourceId = "icon_score";
                  break;
               case "unit":
                  resourceId = (InstanceMng.getShipDefMng().getDefBySku(entry.getItemSku()) as ShipDef).getIcon();
                  break;
               case "items":
                  itemDef = InstanceMng.getItemsDefMng().getDefBySku(entry.getItemSku()) as ItemsDef;
                  resourceId = itemDef.getAssetId();
            }
         }
         return resourceId;
      }
      
      public function getRewardBox(entryStr:String, textureSku:String, skinSku:String) : ESpriteContainer
      {
         var entry:Entry = EntryFactory.createEntryFromEntrySet(entryStr,false);
         var espc:ESpriteContainer = this.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("BoxReward");
         var img:EImage = this.getEImage(textureSku,skinSku,false,layoutFactory.getArea("container_box"));
         espc.eAddChild(img);
         espc.setContent("background",img);
         var assetId:String = this.getResourceIdFromEntry(entry);
         img = this.getEImage(assetId,skinSku,true,layoutFactory.getArea("icon"));
         espc.eAddChild(img);
         espc.setContent("icon",img);
         var field:ETextField = this.getETextField(skinSku,layoutFactory.getTextArea("text_value"));
         espc.eAddChild(field);
         espc.setContent("amount",field);
         if(entry.getAmount() == "NaN")
         {
            field.visible = false;
         }
         else
         {
            field.setText(DCTextMng.convertNumberToString(parseInt(entry.getAmount()),1,8));
         }
         field.applySkinProp(skinSku,"text_title_1");
         field = this.getETextField(skinSku,layoutFactory.getTextArea("text_title"));
         espc.eAddChild(field);
         espc.setContent("title",field);
         field.setText(DCTextMng.getText(35));
         field.applySkinProp(skinSku,"text_title_1");
         return espc;
      }
      
      private function getContainerItemPrivate(assetId:String, layoutFactory:ELayoutAreaFactory, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         var field:ETextField = null;
         skinSku = this.getSkinSku(skinSku);
         var container:ESpriteContainer;
         (container = this.getESpriteContainer()).setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = this.getEImage(assetId,skinSku,showLoading,layoutFactory.getArea("icon"));
         container.eAddChild(img);
         container.setContent("icon",img);
         if(amount != null)
         {
            field = this.getETextField(skinSku,layoutFactory.getTextArea("text"));
            container.eAddChild(field);
            container.setContent("text",field);
            if(amount != "")
            {
               field.setText("x" + amount);
            }
            else
            {
               field.setText("");
            }
            field.applySkinProp(skinSku,"text_title_3");
         }
         return container;
      }
      
      public function getContainerItem(assetId:String, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         return this.getContainerItemPrivate(assetId,this.getLayoutAreaFactory("ContainerItem"),amount,skinSku,showLoading);
      }
      
      public function getContainerItemSmall(assetId:String, backgroundId:String, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         var box:EImage = null;
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("ContainerItemS");
         var result:ESpriteContainer = this.getContainerItemPrivate(assetId,layoutFactory,amount,skinSku,showLoading);
         if(backgroundId)
         {
            box = this.getEImage(backgroundId,skinSku,false,layoutFactory.getArea("container_box"),null);
            result.eAddChildAt(box,0);
            result.setContent("bkg",box);
         }
         return result;
      }
      
      public function getContainerItemButtonIconSmall(assetId:String, button:EButton, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         return this.getContainerItemButton(assetId,button,"ContainerItemButtonIcon",amount,skinSku,showLoading);
      }
      
      public function getContainerItemButtonIconLarge(assetId:String, button:EButton, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         return this.getContainerItemButton(assetId,button,"ContainerItemButtonIconLarge",amount,skinSku,showLoading);
      }
      
      private function getContainerItemButton(assetId:String, button:EButton, layoutName:String, amount:String = null, skinSku:String = null, showLoading:Boolean = true) : ESpriteContainer
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutName);
         var result:ESpriteContainer = this.getContainerItemPrivate(assetId,layoutFactory,amount,skinSku,showLoading);
         button.setLayoutArea(layoutFactory.getArea("ibtn"),true);
         result.eAddChild(button);
         result.setContent("ibtn",button);
         return result;
      }
      
      public function getHeaderStripes(layoutFactory:ELayoutAreaFactory, instances:Array, texts:Array, textsProps:String, skinSku:String) : ESpriteContainer
      {
         var i:int = 0;
         var field:ETextField = null;
         skinSku = this.getSkinSku(skinSku);
         var container:ESpriteContainer = this.getESpriteContainer();
         var count:int = int(instances.length);
         for(i = 0; i < count; )
         {
            (field = this.getETextField(skinSku,layoutFactory.getTextArea(instances[i]))).setText(texts[i]);
            field.applySkinProp(skinSku,textsProps);
            container.setContent(instances[i],field);
            container.eAddChild(field);
            i++;
         }
         return container;
      }
      
      public function getColorBehavior(color:uint) : ELayoutBehavior
      {
         if(this.mLayoutAreaFactoriesMng == null)
         {
            this.mLayoutAreaFactoriesMng = new LayoutAreaFactoriesMng();
         }
         return this.mLayoutAreaFactoriesMng.getColoBehavior(color);
      }
      
      public function getStrPrice(entry:Entry) : String
      {
         var platformDefMng:PlatformSettingsDefMng = null;
         var conversion:Number = NaN;
         var conversionName:String = null;
         var symbol:String = null;
         var amountStr:String = entry.getAmount(0,true);
         var amount:Number = parseFloat(amountStr);
         var money:String = null;
         switch(entry.getKey())
         {
            case "credits":
               platformDefMng = InstanceMng.getPlatformSettingsDefMng();
               conversion = platformDefMng.getCurrencyConversion();
               conversionName = platformDefMng.getCurrencyName();
               if(InstanceMng.getRuleMng().hasUserCurrency())
               {
                  conversionName = InstanceMng.getRuleMng().getUserCurrency();
                  conversion = InstanceMng.getRuleMng().getCurrencyExchangeValue();
               }
               symbol = this.getCoinSymbol(conversionName);
               money = DCTextMng.convertNumberToStringWithDecimals(amount * conversion,2);
               money = symbol + money + " " + conversionName.toUpperCase();
               break;
            case "chips":
            case "cash":
               money = DCTextMng.convertNumberToStringWithDecimals(amount,0);
         }
         return money;
      }
      
      public function getCoinSymbol(name:String) : String
      {
         switch(name.toUpperCase())
         {
            case "USD":
               return "$";
            case "EUR":
               return "€";
            case "GBP":
               return "£";
            default:
               return "";
         }
      }
      
      public function getIconBar(area:ELayoutArea, layoutSku:String, colorSku:String, iconSku:String) : IconBar
      {
         var capacityBar:IconBar;
         (capacityBar = new IconBar()).setup(layoutSku,0,100,colorSku,iconSku);
         capacityBar.logicUpdate(0);
         if(area)
         {
            capacityBar.layoutApplyTransformations(area);
         }
         return capacityBar;
      }
      
      public function getIconBarHud(area:ELayoutArea, layoutSku:String, colorSku:String, iconSku:String, callback:Function) : IconBar
      {
         var capacityBar:IconBarHud;
         (capacityBar = new IconBarHud()).setup(layoutSku,0,100,colorSku,iconSku);
         capacityBar.setupButton("btn_plus",callback);
         capacityBar.logicUpdate(0);
         if(area)
         {
            capacityBar.layoutApplyTransformations(area);
         }
         return capacityBar;
      }
      
      public function getIconBarUmbrella() : IconBarUmbrella
      {
         var returnValue:IconBarUmbrella = new IconBarUmbrella();
         returnValue.setup("IconBarS",0,0,"color_white","star_trek_energy");
         return returnValue;
      }
      
      public function getNavigationInputBarHud() : EHudNavigationBar
      {
         return new EHudNavigationBar();
      }
      
      public function getNavigationInfoBarHud() : ESpriteContainer
      {
         var s:ESprite = null;
         var result:ESpriteContainer = this.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("NavigationInfoHud");
         s = this.getEImage("bar",null,false,layoutFactory.getArea("bar"));
         result.eAddChild(s);
         result.setContent("bkg",s);
         s = this.getETextField(null,layoutFactory.getTextArea("text_value"),"text_title_0");
         result.eAddChild(s);
         result.setContent("text",s);
         s = this.getEImage("icon_galaxy",null,false,layoutFactory.getArea("icon"));
         result.eAddChild(s);
         result.setContent("icon",s);
         s = this.getButtonImage("btn_bookmark_add",null,layoutFactory.getArea("btn"));
         result.eAddChild(s);
         result.setContent("btn_add",s);
         s = this.getButtonImage("btn_bookmark_remove",null,layoutFactory.getArea("btn"));
         result.eAddChild(s);
         result.setContent("btn_remove",s);
         return result;
      }
      
      public function getProfileInfoBasic(playerInfo:UserInfo) : EHudProfileBasicView
      {
         var profileInfoBasic:EHudProfileBasicView = new EHudProfileBasicView();
         profileInfoBasic.setUserInfo(playerInfo);
         return profileInfoBasic;
      }
      
      public function getProfileExtendedFromPlanet(planet:Planet, checkAttackable:Boolean = false) : ESpriteContainer
      {
         var prop:String = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("ProfileExtended");
         var userInfo:UserInfo;
         if((userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(planet.getOwnerAccId(),0)).isNeighbor())
         {
            prop = "box_profile";
         }
         else
         {
            prop = "box_attack";
         }
         if(this.userCanBeAttackedPlanet(userInfo,planet) || !checkAttackable)
         {
            container.alpha = 1;
         }
         else
         {
            container.alpha = 0.4;
         }
         var img:EImage = this.getEImage(prop,null,false,layoutFactory.getArea("container_box"));
         container.eAddChild(img);
         container.setContent("background",img);
         if(userInfo.mIsNPC.value)
         {
            img = this.getEImage(planet.getURL(),null,false);
         }
         else
         {
            img = this.getEImageProfileFromURL(userInfo.getThumbnailURL(),null,null);
         }
         img.setLayoutArea(layoutFactory.getArea("img"),true);
         container.eAddChild(img);
         container.setContent("userPicture",img);
         var field:ETextField;
         (field = this.getETextField(null,layoutFactory.getTextArea("text_name"),"text_header")).setText(userInfo.getPlayerName());
         container.eAddChild(field);
         container.setContent("text_name",field);
         var boxes:Array = [];
         var level:int = planet.getHQLevel();
         var content:ESpriteContainer = this.getContentIconWithTextHorizontal("IconTextXS","icon_hq",level.toString(),null,"text_title_3");
         container.eAddChild(content);
         container.setContent("hqLevel",content);
         boxes.push(content);
         content = this.getContentIconWithTextHorizontal("IconTextXS","icon_score_level",userInfo.getLevel().toString(),null,"text_score");
         container.eAddChild(content);
         container.setContent("userLevel",content);
         boxes.push(content);
         this.distributeSpritesInArea(layoutFactory.getArea("container_icon_text"),boxes,1,1,1,2,true);
         return container;
      }
      
      public function getEmptyPlanetView(planet:Planet) : ESpriteContainer
      {
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory("ProfileExtendedPlanet");
         var img:EImage = this.getEImage("box_profile",null,false,layoutFactory.getArea("container_box"));
         container.eAddChild(img);
         container.setContent("background",img);
         var field:ETextField;
         (field = this.getETextField(null,layoutFactory.getTextArea("text_name"),"text_header")).setText(DCTextMng.getText(2742));
         container.eAddChild(field);
         container.setContent("text_name",field);
         var resourceStr:String = InstanceMng.getResourceMng().getAssetByParameter(planet.getParentStarType(),-1,false,false,true);
         img = this.getEImage(resourceStr,null,true,layoutFactory.getArea("img"));
         container.eAddChild(img);
         container.setContent("img",img);
         return container;
      }
      
      public function onReloadGame(e:EEvent) : void
      {
         InstanceMng.getApplication().reloadGame(true);
      }
      
      public function onRetryLogin(e:EEvent) : void
      {
         InstanceMng.getUserDataMng().login(true);
      }
      
      public function distributeButtons(buttons:Vector.<EButton>, area:ELayoutArea, sumOffset:Boolean, distributionType:String = "textWidth") : void
      {
         var distributionArea:* = null;
         var button:EButton = null;
         var oldButton:EButton = null;
         var count:int = 0;
         var totalSeparation:int = 0;
         var areaWidth:Number = NaN;
         var tabWidth:Number = NaN;
         var separation:Number = NaN;
         var i:int = 0;
         var sumWidthTexts:Number = NaN;
         var size:Number = NaN;
         var field:ETextField = null;
         var offset:Number = NaN;
         var buttonOffset:* = NaN;
         var SEPARATION:int = 3;
         var TAB_AREA_MARGIN:int = 7;
         if((distributionArea = area) != null && buttons != null)
         {
            count = int(buttons.length);
            totalSeparation = SEPARATION * (count - 1) + TAB_AREA_MARGIN * 2;
            if(!sumOffset)
            {
               totalSeparation = SEPARATION * (count + 1);
            }
            tabWidth = (areaWidth = distributionArea.width - totalSeparation) / count;
            separation = SEPARATION;
            switch(distributionType)
            {
               case "equal":
                  this.setHeadersWidth(buttons,tabWidth,distributionArea.height);
                  break;
               case "textWidth":
                  sumWidthTexts = this.getTextsWidth(buttons);
                  offset = 0;
                  field = (button = buttons[0]).getTextField();
                  if(sumWidthTexts > area.width - totalSeparation)
                  {
                     if(field != null)
                     {
                        size = field.getFontSize();
                     }
                     do
                     {
                        this.setTextsSize(buttons,size);
                        sumWidthTexts = this.getTextsWidth(buttons);
                        size--;
                        if(size <= 10)
                        {
                           this.setTextsSize(buttons,size);
                           break;
                        }
                     }
                     while(sumWidthTexts > area.width - totalSeparation);
                     
                  }
                  buttonOffset = 0;
                  if(sumOffset)
                  {
                     buttonOffset = offset = (areaWidth - sumWidthTexts) / count;
                  }
                  else
                  {
                     offset = (areaWidth - sumWidthTexts) / (count + 1);
                     separation += offset;
                  }
                  for(i = 0; i < count; )
                  {
                     this.setHeadersWidthByTextWidth(buttons[i],buttonOffset);
                     i++;
                  }
            }
            (button = buttons[0]).logicLeft = distributionArea.x + TAB_AREA_MARGIN;
            if(!sumOffset)
            {
               button.logicLeft += offset;
            }
            button.logicTop = distributionArea.y;
            for(i = 1; i < count; )
            {
               oldButton = buttons[i - 1];
               (button = buttons[i]).logicLeft = oldButton.logicLeft + oldButton.width + separation;
               button.logicTop = distributionArea.y;
               i++;
            }
         }
      }
      
      private function setHeadersWidth(headers:Vector.<EButton>, w:Number, h:Number) : void
      {
         var i:int = 0;
         var button:EButton = null;
         var field:ETextField = null;
         var bkg:EImage = null;
         var count:int = int(headers.length);
         for(i = 0; i < count; )
         {
            if((bkg = (button = headers[i]).getBackground()) != null)
            {
               InstanceMng.getEResourcesMng().resizeImage(bkg,w,h);
            }
            if((field = button.getTextField()) != null)
            {
               field.width = w;
               button.eAddChild(field);
            }
            i++;
         }
      }
      
      public function setHeadersWidthByTextWidth(header:EButton, offset:Number = 0, maxWidth:Number = 0) : void
      {
         var field:ETextField = null;
         var bkg:EImage = null;
         var w:Number = NaN;
         var height:Number = NaN;
         var diff:int = 0;
         var icon:EImage = header.getIcon();
         var bkgX:Number = 0;
         var fieldX:Number = 0;
         bkg = header.getBackground();
         fieldX = (field = header.getTextField()).logicLeft;
         if(icon != null && bkg != null)
         {
            bkgX = bkg.logicLeft;
            field.x = icon.logicLeft + icon.width;
         }
         w = this.getTextWidth(field,bkg) + offset;
         if(maxWidth > 0 && w + bkgX > maxWidth)
         {
            w = maxWidth - bkgX;
         }
         if(bkg != null)
         {
            field.width = w - fieldX;
            field.logicLeft = fieldX;
         }
         if(bkg != null)
         {
            height = bkg.getLogicHeight();
            InstanceMng.getEResourcesMng().resizeImage(bkg,w,height);
         }
         var origArea:ELayoutArea = header.getLayoutArea();
         var area:ELayoutArea;
         (area = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(origArea)).width = w + bkgX;
         if(origArea != null)
         {
            if((diff = origArea.getOriginalWidth() - area.width) > 0)
            {
               area.x += diff / 2;
            }
         }
         header.setLayoutArea(area,true);
         if((bkg = header.getContent("bkgUnselected") as EImage) != null)
         {
            height = bkg.getLogicHeight();
            InstanceMng.getEResourcesMng().resizeImage(bkg,w,height);
         }
      }
      
      private function getTextsWidth(headers:Vector.<EButton>) : Number
      {
         var i:int = 0;
         var field:ETextField = null;
         var sumWidthFields:Number = 0;
         var count:int = int(headers.length);
         for(i = 0; i < count; )
         {
            field = headers[i].getTextField();
            if(field != null)
            {
               sumWidthFields += this.getTextWidth(field,headers[i].getBackground());
            }
            i++;
         }
         return sumWidthFields;
      }
      
      private function getTextWidth(field:ETextField, bkg:ESprite = null) : Number
      {
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = this.getLayoutAreaFactory("BtnXS")).getArea("base");
         if(field != null)
         {
            field.width = 1000;
            field.width = field.textWithMarginWidth;
            if(bkg == null)
            {
               return field.width;
            }
            return Math.max(field.width + 10 * 2,area.width);
         }
         return area.width;
      }
      
      private function setTextsSize(headers:Vector.<EButton>, size:Number) : void
      {
         var i:int = 0;
         var field:ETextField = null;
         var count:int = int(headers.length);
         for(i = 0; i < count; )
         {
            field = headers[i].getTextField();
            if(field != null)
            {
               field.setFontSize(size);
            }
            i++;
         }
      }
      
      public function distributeSpritesInArea(area:ELayoutArea, boxes:Array, hAlign:int = 0, vAlign:int = 0, cols:int = -1, rows:int = 1, applyBodyPos:Boolean = false, percentForOff:int = 0, considerBoxesSize:Boolean = true) : void
      {
         var r:int = 0;
         var totalOff:Number = NaN;
         var scale:Number = NaN;
         var box:ESprite = null;
         var subarea:ELayoutArea = null;
         var separation:Number = NaN;
         var spaces:int = 0;
         var pos:* = NaN;
         var b:int = 0;
         var boxesCount:int = int(boxes.length);
         if(cols == -1)
         {
            cols = boxesCount;
         }
         else
         {
            rows = Math.ceil(boxesCount / Math.max(cols,1));
         }
         var biBoxes:Array = EUtils.array2BidimensionalArray(boxes,rows,cols);
         var size:int;
         var off:int = (size = Math.min(area.width,area.height)) * percentForOff / 100;
         var maxWidth:* = 0;
         var currentWidth:Number = 0;
         if(considerBoxesSize)
         {
            for(r = 0; r < rows; )
            {
               if((currentWidth = this.getGroupWidth(biBoxes[r])) > maxWidth)
               {
                  maxWidth = currentWidth;
               }
               r++;
            }
         }
         totalOff = off * (cols + 1);
         maxWidth += totalOff;
         var maxHeight:Number = considerBoxesSize ? this.getMaxHeight(biBoxes,rows) : 0;
         totalOff = off * (rows + 1);
         maxHeight += totalOff;
         var scaleWidth:Number = 1;
         var scaleHeight:Number = 1;
         if(maxWidth > area.width)
         {
            scaleWidth = area.width / maxWidth;
         }
         if(maxHeight > area.height)
         {
            scaleHeight = area.height / maxHeight;
         }
         if((scale = Math.min(scaleWidth,scaleHeight)) < 1)
         {
            for(b = 0; b < boxesCount; )
            {
               (box = boxes[b]).scaleLogicX = scale;
               box.scaleLogicY = scale;
               b++;
            }
         }
         var freeSpace:Number = area.height;
         if(considerBoxesSize)
         {
            freeSpace -= this.getMaxHeight(biBoxes,rows);
         }
         if(vAlign == 1)
         {
            spaces = rows + 1;
         }
         else
         {
            spaces = rows - 1;
         }
         if(vAlign == 4)
         {
            separation = 0;
         }
         else if(spaces == 0)
         {
            separation = 0;
         }
         else
         {
            separation = freeSpace / spaces;
         }
         if(vAlign == 1)
         {
            pos = separation;
         }
         else
         {
            pos = 0;
         }
         subarea = ELayoutAreaFactory.createLayoutArea(area.width,0);
         for(r = 0; r < rows; )
         {
            subarea.height = considerBoxesSize ? this.getGroupHeight(biBoxes[r]) : 0;
            subarea.y = pos;
            this.distributeBoxesInRow(subarea,biBoxes[r],hAlign,considerBoxesSize);
            pos += separation + subarea.height;
            r++;
         }
         if(applyBodyPos)
         {
            for(b = 0; b < boxesCount; )
            {
               box = boxes[b];
               box.logicLeft += area.x;
               box.logicTop += area.y;
               b++;
            }
         }
      }
      
      private function getMaxHeight(boxes:Array, rows:int) : Number
      {
         var r:int = 0;
         var maxHeight:Number = 0;
         for(r = 0; r < rows; )
         {
            maxHeight += this.getGroupHeight(boxes[r]);
            r++;
         }
         return maxHeight;
      }
      
      private function getGroupWidth(boxes:Array) : Number
      {
         var b:int = 0;
         var box:ESprite = null;
         var boxesCount:int = int(boxes.length);
         var returnValue:Number = 0;
         for(b = 0; b < boxesCount; )
         {
            box = boxes[b];
            returnValue += box.getLogicWidth();
            b++;
         }
         return returnValue;
      }
      
      private function getGroupHeight(boxes:Array) : Number
      {
         var b:int = 0;
         var box:ESprite = null;
         var boxesCount:int = int(boxes.length);
         var returnValue:* = 0;
         var currentHeight:Number = 0;
         for(b = 0; b < boxesCount; )
         {
            if((currentHeight = (box = boxes[b]).getLogicHeight()) > returnValue)
            {
               returnValue = currentHeight;
            }
            b++;
         }
         return returnValue;
      }
      
      private function distributeBoxesInRow(area:ELayoutArea, boxes:Array, hAlign:int, considerBoxesSize:Boolean = true) : void
      {
         var b:int = 0;
         var spaces:int = 0;
         var separation:Number = NaN;
         var box:ESprite = null;
         var pos:* = NaN;
         var freeSpace:Number = area.width;
         if(considerBoxesSize)
         {
            freeSpace -= this.getGroupWidth(boxes);
         }
         var boxesCount:int = int(boxes.length);
         if(hAlign == 1)
         {
            spaces = boxesCount + 1;
         }
         else
         {
            spaces = boxesCount - 1;
         }
         if(spaces > 0)
         {
            separation = freeSpace / spaces;
         }
         else
         {
            separation = 0;
         }
         if(hAlign == 1)
         {
            pos = separation;
         }
         else if(hAlign == 2)
         {
            pos = area.width;
         }
         else
         {
            pos = 0;
         }
         for(b = 0; b < boxesCount; )
         {
            box = boxes[b];
            if(hAlign == 2)
            {
               pos -= separation;
               if(considerBoxesSize)
               {
                  pos -= box.getLogicWidth();
               }
            }
            box.logicLeft = pos;
            box.logicTop = area.y + (area.height - (considerBoxesSize ? box.getLogicHeight() : 0)) / 2;
            if(hAlign != 2)
            {
               pos += separation;
               if(considerBoxesSize)
               {
                  pos += box.getLogicWidth();
               }
            }
            b++;
         }
      }
      
      public function createMinimumLayoutArea(sprites:Array, maxColumns:int = 0, maxRows:int = 0, padding:int = 8, distribution:int = 1) : ELayoutArea
      {
         var column:int = 0;
         var columnWidth:int = 0;
         var columnHeight:int = 0;
         var row:int = 0;
         var numsprite:int = 0;
         if(sprites.length == 0)
         {
            return new ELayoutArea();
         }
         var rows:* = maxRows;
         var columns:*;
         if((columns = maxColumns) == 0 && rows == 0)
         {
            rows = Math.ceil(Math.sqrt(sprites.length));
            columns = Math.ceil(sprites.length / rows);
         }
         else if(rows == 0)
         {
            rows = Math.ceil(sprites.length / columns);
         }
         else if(columns == 0)
         {
            columns = Math.ceil(sprites.length / rows);
         }
         var totalWidth:int = 0;
         var totalHeight:int = 0;
         for(column = 0; column < columns; )
         {
            columnWidth = 0;
            columnHeight = 0;
            for(row = 0; row < rows; )
            {
               numsprite = column * rows + row;
               if(distribution == 0)
               {
                  numsprite = row * columns + column;
               }
               if(numsprite < sprites.length)
               {
                  columnWidth = Math.max(columnWidth,sprites[numsprite].getLogicWidth() + padding);
                  columnHeight += sprites[numsprite].getLogicHeight() + padding;
               }
               row++;
            }
            totalWidth += columnWidth;
            totalHeight = Math.max(totalHeight,columnHeight);
            column++;
         }
         var result:ELayoutArea;
         (result = new ELayoutArea()).width = totalWidth - padding;
         result.height = totalHeight - padding;
         return result;
      }
      
      public function arrangeToFitInMinimumScreen(s:ESprite, currentScreenSize:Boolean = false) : void
      {
         var spriteRect:Rectangle = null;
         if(s.stage != InstanceMng.getApplication().stageGetStage().getDisplayObjectContent())
         {
            return;
         }
         var additionalWidthMargin:int = (InstanceMng.getApplication().stageGetWidth() - 760) / 2;
         if(currentScreenSize)
         {
            additionalWidthMargin = 0;
         }
         var topLeft:Point = s.getRect(s.stage).topLeft;
         spriteRect = new Rectangle(topLeft.x,topLeft.y,s.getLogicWidth(),s.getLogicHeight());
         if(spriteRect.left < additionalWidthMargin)
         {
            s.logicX += additionalWidthMargin - spriteRect.left;
         }
         else if(spriteRect.right > InstanceMng.getApplication().stageGetWidth() - additionalWidthMargin)
         {
            s.logicX += InstanceMng.getApplication().stageGetWidth() - additionalWidthMargin - spriteRect.right;
         }
      }
      
      public function getCheckBox(area:ELayoutArea, skinSku:String = null, rescale:Boolean = false) : ESpriteContainer
      {
         var container:ESpriteContainer = new ESpriteContainer();
         var img:EImage = this.getEImage("bar",skinSku,false,area);
         container.eAddChild(img);
         container.setContent("bkg",img);
         img = this.getEImage("icon_check",skinSku,false,area);
         container.eAddChild(img);
         container.setContent("check",img);
         if(rescale)
         {
            img.onSetTextureLoaded = function():void
            {
               img.layoutApplyTransformations(area);
               img.scaleLogicX = area.width / img.getTexture().getBitmapData().width;
               img.scaleLogicY = area.height / img.getTexture().getBitmapData().height;
            };
         }
         container.eAddEventBehavior("click",this.getMouseBehavior("CHECK"));
         container.mouseChildren = false;
         container.buttonMode = true;
         this.setButtonBehaviors(container);
         return container;
      }
      
      public function getCheckBoxWithText(factory:String, text:String, textProp:String, skinSku:String = null) : ESpriteContainer
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutAreaFactory(factory);
         var espc:ESpriteContainer = this.getESpriteContainer();
         var check:ESpriteContainer = this.getCheckBox(layoutFactory.getArea("icon"));
         espc.setContent("check",check);
         espc.eAddChild(check);
         var field:ETextField;
         (field = this.getETextField(skinSku,layoutFactory.getTextArea("text"),textProp)).setText(text);
         field.autoSize(true);
         espc.setContent("text",field);
         espc.eAddChild(field);
         return espc;
      }
      
      public function isCheckBoxChecked(box:ESpriteContainer) : Boolean
      {
         if(box == null)
         {
            return false;
         }
         var img:EImage = box.getContentAsEImage("check");
         if(img != null)
         {
            return img.visible;
         }
         return false;
      }
      
      public function setChecked(box:ESpriteContainer, value:Boolean) : void
      {
         var img:EImage = box.getContentAsEImage("check");
         if(img != null)
         {
            img.visible = value;
         }
      }
      
      public function getEScrollBar(area:EScrollArea) : EScrollBar
      {
         var topArrow:EImage = this.getEImage("scrollbar_arrow",null,false);
         var bottomArrow:EImage = this.getEImage("scrollbar_arrow",null,false);
         var barBkg:EImage = this.getEImage("scrollbar",null,false);
         var bar:EImage = this.getEImage("btn_scrollbar",null,false);
         bottomArrow.scaleLogicY *= -1;
         return new EScrollBar(0,topArrow,bottomArrow,barBkg,bar,area);
      }
      
      public function getColoniesForDropDown(onColoniesClick:Function, userInfo:UserInfo, highlightPlanet:Planet = null) : ESpriteContainer
      {
         return this.getColonies(onColoniesClick,userInfo,"normal",4,-1,highlightPlanet);
      }
      
      public function getColoniesForVisitorHud(onColoniesClick:Function, userInfo:UserInfo, highlightPlanet:Planet = null) : ESpriteContainer
      {
         return this.getColonies(onColoniesClick,userInfo,"xsmall",-1,2,highlightPlanet);
      }
      
      private function getColonies(onColoniesClick:Function, userInfo:UserInfo, size:String, maxCols:int, maxRows:int, highlightPlanet:Planet = null) : ESpriteContainer
      {
         var i:int = 0;
         var colony:ESpriteContainer = null;
         var coloniesCount:int = 0;
         var numRows:int = 0;
         var numCols:int = 0;
         var distribution:int = 0;
         var colonyInfo:Planet = null;
         var container:ESpriteContainer = this.getESpriteContainer();
         var coloniesInfo:Vector.<Planet>;
         if((coloniesCount = int((coloniesInfo = userInfo.mPlanets) == null ? 0 : int(coloniesInfo.length))) > 12)
         {
            coloniesCount = 12;
         }
         var coloniesView:Array = [];
         var isCapital:Boolean = false;
         for(i = 0; i < coloniesCount; )
         {
            isCapital = (colonyInfo = coloniesInfo[i]) != null && colonyInfo.isCapital();
            switch(size)
            {
               case "normal":
                  colony = this.getColonyView(colonyInfo);
                  break;
               case "small":
                  colony = this.getColonyViewSmall(colonyInfo);
                  break;
               case "xsmall":
                  colony = this.getColonyViewXSmall(colonyInfo);
            }
            coloniesView.push(colony);
            colony.mouseChildren = false;
            if(colonyInfo.getSku() && colonyInfo.getSku() != "" && !colonyInfo.isReserved() && !colonyInfo.hasToBeGrayedOut())
            {
               colony.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
               colony.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
            }
            else
            {
               colony.eAddEventBehavior("Disable",this.getMouseBehavior("Disable"));
               colony.setIsEnabled(false);
               colony.mouseEnabled = false;
            }
            container.eAddChild(colony);
            container.setContent(colony.name,colony);
            container.eAddEventListener("click",onColoniesClick);
            if(highlightPlanet == colonyInfo)
            {
               colony.applySkinProp(null,"active");
            }
            i++;
         }
         if(maxCols > 0)
         {
            numRows = Math.ceil(coloniesView.length / maxCols);
            numCols = Math.ceil(Math.min(coloniesView.length,maxCols));
            distribution = 0;
         }
         else if(maxRows > 0)
         {
            numRows = Math.ceil(coloniesView.length / maxRows);
            numCols = Math.ceil(Math.min(coloniesView.length,maxRows));
            distribution = 1;
         }
         else
         {
            numCols = Math.ceil(Math.sqrt(coloniesView.length));
            numRows = Math.ceil(coloniesView.length / numCols);
            distribution = 0;
         }
         container.setLayoutArea(this.createMinimumLayoutArea(coloniesView,numCols,numRows,8,distribution),true);
         this.distributeSpritesInArea(container.getLayoutArea(),coloniesView,1,1,numCols,numRows);
         return container;
      }
      
      public function getColonyView(planetInfo:Planet) : ESpriteContainer
      {
         var skinSku:String = InstanceMng.getSkinsMng().getCurrentSkinSku();
         var layout:ELayoutAreaFactory = this.getLayoutAreaFactory("BoxColony");
         var container:ESpriteContainer = this.getESpriteContainer();
         var planetType:int = int(planetInfo.isCapital() ? -1 : planetInfo.getParentStarType());
         var resourceStr:String = InstanceMng.getResourceMng().getAssetByParameter(planetType,-1,false,false,true);
         var planetImage:EImage = this.getEImage(resourceStr,skinSku,true,layout.getArea("icon_planet"));
         container.eAddChild(planetImage);
         container.setContent("icon_planet",planetImage);
         var textField:ETextField;
         (textField = this.getETextField(skinSku,layout.getTextArea("text_name_colony"),"text_title_3")).setText(planetInfo.getName());
         container.eAddChild(textField);
         container.setContent("text_name_colony",textField);
         var levelContainer:ESpriteContainer;
         (levelContainer = this.getContentIconWithTextHorizontal("IconTextXS","icon_hq",planetInfo.getHQLevel().toString(),skinSku,"text_title_3",false)).setLayoutArea(layout.getArea("icon_text_xs"),true);
         container.eAddChild(levelContainer);
         container.setContent("icon_text_xs",levelContainer);
         var coords:DCCoordinate;
         if((coords = planetInfo.getParentStarCoords()) && !InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
         {
            (textField = this.getETextField(skinSku,layout.getTextArea("text_parameters"),"text_title_3")).setText("(" + coords.x + "," + coords.y + ")");
            container.eAddChild(textField);
            container.setContent("text_parameters",textField);
         }
         container.name = planetInfo.getPlanetId();
         return container;
      }
      
      public function getColonyViewXSmall(planetInfo:Planet) : ESpriteContainer
      {
         return this.getColonyViewWithoutName(planetInfo,"BoxColonyXS");
      }
      
      public function getColonyViewSmall(planetInfo:Planet) : ESpriteContainer
      {
         return this.getColonyViewWithoutName(planetInfo,"BoxColonyS");
      }
      
      private function getColonyViewWithoutName(planetInfo:Planet, layoutName:String) : ESpriteContainer
      {
         var skinSku:String = InstanceMng.getSkinsMng().getCurrentSkinSku();
         var layout:ELayoutAreaFactory = this.getLayoutAreaFactory(layoutName);
         var container:ESpriteContainer = this.getESpriteContainer();
         var planetType:int = int(planetInfo.isCapital() ? -1 : planetInfo.getParentStarType());
         var resourceStr:String = InstanceMng.getResourceMng().getAssetByParameter(planetType,-1,false,false,true);
         var planetImage:EImage = this.getEImage(resourceStr,skinSku,true,layout.getArea("icon_planet"));
         container.eAddChild(planetImage);
         container.setContent("icon_planet",planetImage);
         var levelContainer:ESpriteContainer;
         (levelContainer = this.getContentIconWithTextHorizontal("IconTextXS","icon_hq",planetInfo.getHQLevel().toString(),skinSku,"text_title_3",false)).setLayoutArea(layout.getArea("icon_text_xs"),true);
         container.eAddChild(levelContainer);
         container.setContent("icon_text_xs",levelContainer);
         container.name = planetInfo.getPlanetId();
         return container;
      }
   }
}
