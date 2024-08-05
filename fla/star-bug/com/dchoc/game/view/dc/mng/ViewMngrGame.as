package com.dchoc.game.view.dc.mng
{
   import com.dchoc.game.model.unit.Particle;
   import com.dchoc.game.view.dc.gui.highlights.Highlight;
   import com.dchoc.toolkit.core.view.display.layer.DCLayer;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class ViewMngrGame extends DCViewMng
   {
      
      protected static const LAYER_DEFAULT_SKU:String = "background";
      
      protected static const CAMERA_BOX_OFF_X:int = Config.DEBUG_SCREEN ? 100 : -50;
      
      protected static const CAMERA_BOX_OFF_Y:int = Config.DEBUG_SCREEN ? 100 : -50;
      
      private static const NUM_HIGHLIGHTS:int = 1;
      
      private static const FADE_FADING_TIME:int = 1000;
      
      private static const FADE_STATE_SOLID:int = 0;
      
      private static const FADE_STATE_FADING:int = 1;
      
      private static const FADE_STATE_END:int = 2;
       
      
      public var mCameraBox:DCBox;
      
      private var mCameraDO:Sprite;
      
      protected var mCameraShakeX:int;
      
      protected var mCameraShakeY:int;
      
      protected var mCameraShakeIntensity:Number;
      
      protected var mCameraShakeTimer:Number;
      
      private var mHighlights:Vector.<Highlight>;
      
      private var mHighlightsContainers:Dictionary;
      
      private var mFadeDO:Sprite;
      
      private var mFadeIsEnabled:Boolean = false;
      
      private var mFadeTime:int = -1;
      
      private var mFadeState:int;
      
      public function ViewMngrGame()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.cameraLoad();
            this.layersPopulate();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.cameraUnload();
         this.fadeUnload();
      }
      
      override protected function endDo() : void
      {
         this.cameraShakeStop();
         this.fadeEnd();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var layer:DCLayer = null;
         for each(layer in mLayers)
         {
            layer.logicUpdate(dt);
         }
         this.cameraShakeLogicUpdate(dt);
         this.fadeLogicUpdate(dt);
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         super.onResize(stageWidth,stageHeight);
         this.fadeResize(stageWidth,stageHeight);
      }
      
      protected function layersPopulate() : void
      {
      }
      
      public function getCursorLayerSku() : String
      {
         return "background";
      }
      
      public function getHudLayerSku() : String
      {
         return "background";
      }
      
      public function getParticlesLayerSku() : String
      {
         return "background";
      }
      
      public function getPopupLayerSku() : String
      {
         return "background";
      }
      
      public function getPortalLayerSku() : String
      {
         return "background";
      }
      
      public function getTooltipLayerSku() : String
      {
         return "background";
      }
      
      public function getMissionsLayerSku() : String
      {
         return "background";
      }
      
      public function getAdvisorIconLayerSku() : String
      {
         return "background";
      }
      
      public function getDebugLayerSku() : String
      {
         return "background";
      }
      
      public function getTutorialArrowLayerSku() : String
      {
         return "background";
      }
      
      public function getMapBackgroundLayerSku() : String
      {
         return "background";
      }
      
      public function addTutorialArrow(d:*) : void
      {
         addChildToLayer(d,this.getTutorialArrowLayerSku());
      }
      
      public function removeTutorialArrow(d:*) : void
      {
         removeChildFromLayer(d,this.getTutorialArrowLayerSku());
      }
      
      public function addAdvisorIcon(d:*) : void
      {
         addChildToLayer(d,this.getAdvisorIconLayerSku());
      }
      
      public function removeAdvisorIcon(d:*) : void
      {
         removeChildFromLayer(d,this.getAdvisorIconLayerSku());
      }
      
      public function addHud(d:*) : void
      {
         addChildToLayer(d,this.getHudLayerSku());
      }
      
      public function removeHud(d:*) : void
      {
         removeChildFromLayer(d,this.getHudLayerSku());
      }
      
      public function addCinematics(d:*) : void
      {
         addChildToLayer(d,this.getHudLayerSku());
      }
      
      public function removeCinematics(d:*) : void
      {
         removeChildFromLayer(d,this.getHudLayerSku());
      }
      
      override public function addPopup(d:*, pos:int = -1) : void
      {
         addChildToLayer(d,this.getPopupLayerSku(),pos);
      }
      
      override public function removePopup(d:*) : void
      {
         removeChildFromLayer(d,this.getPopupLayerSku());
      }
      
      override public function addTooltip(d:*) : void
      {
         addChildToLayer(d,this.getTooltipLayerSku());
      }
      
      override public function removeTooltip(d:*) : void
      {
         removeChildFromLayer(d,this.getTooltipLayerSku());
      }
      
      public function addDebug(d:*) : void
      {
         var layerSku:String = this.getDebugLayerSku();
         addChildToLayer(d,layerSku);
         mLayers[mLayerDictionary[layerSku]].mMustDraw = true;
      }
      
      public function removeDebug(d:*) : void
      {
         var layerSku:String = this.getDebugLayerSku();
         removeChildFromLayer(d,layerSku);
         mLayers[mLayerDictionary[layerSku]].mMustDraw = true;
      }
      
      public function addSpotlightToStage(d:*) : void
      {
         addChildToLayer(d,this.getHudLayerSku());
      }
      
      public function removeSpotlightFromStage(d:*) : void
      {
         removeChildFromLayer(d,this.getHudLayerSku());
      }
      
      public function addFireworksToStage(d:*, addToWorldLayer:Boolean = true) : void
      {
      }
      
      public function removeFireworksFromStage(d:*, addToWorldLayer:Boolean = true) : void
      {
      }
      
      public function addParticle(d:*) : void
      {
         addChildToLayer(d,this.getParticlesLayerSku());
      }
      
      public function removeParticle(d:*) : void
      {
         removeChildFromLayer(d,this.getParticlesLayerSku());
      }
      
      public function mapBackgroundAddToStage(d:*) : void
      {
         addChildToLayer(d,this.getMapBackgroundLayerSku());
      }
      
      public function mapBackgroundRemoveFromStage(d:*) : void
      {
         removeChildFromLayer(d,this.getMapBackgroundLayerSku());
      }
      
      public function cursorAddToStage(d:DisplayObject) : void
      {
         addChildToLayer(d,this.getCursorLayerSku());
      }
      
      public function cursorRemoveFromStage(d:DisplayObject) : void
      {
         removeChildFromLayer(d,this.getCursorLayerSku());
      }
      
      protected function particlesGetLayerStage(type:int) : String
      {
         return this.getParticlesLayerSku();
      }
      
      public function particlesAddToStage(p:Particle) : void
      {
         if(p.mCustomRenderData != null)
         {
            addChildToLayer(p.mCustomRenderData,this.particlesGetLayerStage(p.mType));
         }
         if(p.mTextField != null)
         {
            this.particlesAddText(p.mTextField);
         }
      }
      
      public function particlesRemoveFromStage(p:Particle) : void
      {
         if(p.mCustomRenderData != null)
         {
            removeChildFromLayer(p.mCustomRenderData,this.particlesGetLayerStage(p.mType));
         }
         if(p.mTextField != null)
         {
            this.particlesRemoveText(p.mTextField);
         }
      }
      
      protected function particlesAddText(t:TextField) : void
      {
         addChildToLayer(t,"background");
      }
      
      protected function particlesRemoveText(t:TextField) : void
      {
         removeChildFromLayer(t,"background");
      }
      
      private function cameraLoad() : void
      {
         this.mCameraBox = new DCBox();
      }
      
      private function cameraUnload() : void
      {
         this.mCameraBox = null;
         if(Config.DEBUG_SCREEN)
         {
            this.mCameraDO = null;
         }
      }
      
      override public function cameraGetBox() : DCBox
      {
         return this.mCameraBox;
      }
      
      protected function cameraViewRender(draw:Boolean = false) : void
      {
         if(this.mCameraDO == null)
         {
            this.mCameraDO = new Sprite();
            this.mCameraDO.mouseEnabled = false;
            this.mCameraDO.mouseChildren = false;
            DCUtils.drawRect(this.mCameraDO.graphics,0,0,this.mCameraBox.mWidth,this.mCameraBox.mHeight,16777215);
            if(Config.DEBUG_MODE)
            {
               this.addDebug(this.mCameraDO);
            }
            draw = false;
         }
         this.mCameraDO.x = this.mCameraBox.mX;
         this.mCameraDO.y = this.mCameraBox.mY;
         if(draw)
         {
            DCUtils.drawRect(this.mCameraDO.graphics,0,0,this.mCameraBox.mWidth,this.mCameraBox.mHeight,16777215,draw);
         }
      }
      
      public function cameraAddSize(offX:int, offY:int) : void
      {
         var left:int = 0;
         var up:int = 0;
         var right:int = 0;
         var down:int = 0;
         var semiOffX:* = 0;
         var semiOffY:* = 0;
         var layer:DCLayer = null;
         if(offX != 0 || offY != 0)
         {
            left = this.mCameraBox.getLeft();
            up = this.mCameraBox.getTop();
            right = this.mCameraBox.getRight();
            down = this.mCameraBox.getBottom();
            semiOffX = offX >> 1;
            semiOffY = offY >> 1;
            this.mCameraBox.setCorners(left - semiOffX,up - semiOffY,right + semiOffX,down + semiOffY);
            this.cameraViewRender(true);
            for each(layer in mLayers)
            {
               if(layer.needCamera && layer.mScreenCamera != null)
               {
                  layer.screenChangeCamera();
               }
            }
         }
      }
      
      public function cameraMove(offX:int, offY:int) : void
      {
         var layer:DCLayer = null;
         if(offX != 0 || offY != 0)
         {
            this.mCameraBox.move(offX,offY);
            this.cameraViewRender();
            for each(layer in mLayers)
            {
               if(layer.needCamera && layer.mScreenCamera != null)
               {
                  layer.screenChangeCamera();
               }
            }
         }
      }
      
      public function cameraShakeStart(intensity:Number = 0.02, durationMS:int = 400) : void
      {
         this.cameraShakeStop();
         this.mCameraShakeIntensity = intensity;
         this.mCameraShakeTimer = durationMS;
      }
      
      public function cameraShakeStop() : void
      {
         this.mCameraShakeX = 0;
         this.mCameraShakeY = 0;
         this.mCameraShakeIntensity = 0;
         this.mCameraShakeTimer = 0;
      }
      
      private function cameraShakeLogicUpdate(dt:int) : void
      {
         if(this.mCameraShakeTimer > 0)
         {
            this.mCameraShakeTimer -= dt;
            if(this.mCameraShakeTimer <= 0)
            {
               this.mCameraShakeTimer = 0;
               this.mCameraShakeX = 0;
               this.mCameraShakeY = 0;
            }
            else
            {
               this.cameraShakeCalculateShake();
            }
            this.cameraShakeMoveCamera(this.mCameraShakeX,this.mCameraShakeY);
         }
      }
      
      protected function cameraShakeCalculateShake() : void
      {
      }
      
      protected function cameraShakeMoveCamera(shakeX:int, shakeY:int) : void
      {
      }
      
      public function worldToScreen(coor:DCCoordinate) : DCCoordinate
      {
         return coor;
      }
      
      public function addHighlightFromContainer(container:DisplayObjectContainer, useOwnOffset:Boolean = false, offsetX:int = 0, offsetY:int = 0, offsetW:int = 0, offsetH:int = 0, ignoreScale:Boolean = false, refreshIfExists:Boolean = true) : Highlight
      {
         if(useOwnOffset == false)
         {
            offsetX = container.width >> 1;
            offsetY = container.height >> 1;
            offsetW = container.width >> 1;
            offsetH = container.height >> 1;
         }
         var r:Rectangle = container.getBounds(container);
         r.x += offsetX;
         r.y += offsetY;
         r.width += offsetW;
         r.height += offsetH;
         var config:Object;
         (config = {})["box"] = r;
         config["highlightColour"] = "0x4bfdff";
         config["refreshIfExists"] = refreshIfExists;
         return this.addHighlightToContainer(config,container,ignoreScale);
      }
      
      public function addHighlightFromCoords(x:int, y:int, w:int, h:int) : Highlight
      {
         var r:Rectangle = new Rectangle(x,y,w,h);
         return this.addHighlightFromRectangle(r);
      }
      
      public function addHighlightFromRectangle(r:Rectangle) : Highlight
      {
         var config:Object = {};
         config["box"] = r;
         config["highlightColour"] = "0x4bfdff";
         return this.addHighlightToLayer(config);
      }
      
      private function addHighlightToLayer(highlightConfig:Object = null, layerId:String = null) : Highlight
      {
         var layer:* = this.getTutorialArrowLayerSku();
         if(layerId != null)
         {
            layer = layerId;
         }
         highlightConfig["layerSku"] = layer;
         var highlight:Highlight = new Highlight();
         highlight.init(highlightConfig);
         if(this.mHighlights == null)
         {
            this.mHighlights = new Vector.<Highlight>(0);
         }
         if(this.mHighlights.length == 1)
         {
            this.removeHighlight(0);
         }
         addChildToLayer(highlight,layer);
         this.mHighlights.push(highlight);
         return highlight;
      }
      
      private function addHighlightToContainer(config:Object, container:DisplayObjectContainer, ignoreScale:Boolean = false) : Highlight
      {
         var containerScaleX:Number = NaN;
         var containerScaleY:Number = NaN;
         var highlightScaleX:* = NaN;
         var highlightScaleY:* = NaN;
         if(config == null || container == null)
         {
            return null;
         }
         if(this.mHighlightsContainers == null)
         {
            this.mHighlightsContainers = new Dictionary();
         }
         if(this.mHighlightsContainers[container] != null)
         {
            if(!config["refreshIfExists"])
            {
               return this.mHighlightsContainers[container];
            }
            this.removeHighlightContainer(container);
         }
         var highlight:Highlight;
         (highlight = new Highlight()).init(config);
         if(ignoreScale)
         {
            containerScaleX = container.scaleX;
            containerScaleY = container.scaleY;
            highlightScaleX = containerScaleX;
            highlightScaleY = containerScaleY;
            highlight.scaleX += containerScaleX < 1 ? highlightScaleX : 0;
            highlight.scaleY += containerScaleY < 1 ? highlightScaleY : 0;
         }
         this.mHighlightsContainers[container] = highlight;
         container.addChild(highlight);
         return highlight;
      }
      
      private function removeHighlight(idx:int) : void
      {
         if(this.mHighlights == null)
         {
            return;
         }
         if(idx >= this.mHighlights.length)
         {
            return;
         }
         var h:Highlight = this.mHighlights.splice(idx,1)[0];
         if(contains(h))
         {
            removeChildFromLayer(h,h.getLayerSku());
         }
      }
      
      public function removeHighlightContainer(container:DisplayObjectContainer) : void
      {
         if((this.mHighlightsContainers != null && this.mHighlightsContainers[container] != null) == false)
         {
            return;
         }
         if(container.contains(this.mHighlightsContainers[container]) == true)
         {
            container.removeChild(this.mHighlightsContainers[container]);
         }
         this.mHighlightsContainers[container] = null;
      }
      
      public function removeAllHighlights() : void
      {
         var i:int = 0;
         var o:* = null;
         if(this.mHighlights != null)
         {
            for(i = this.mHighlights.length - 1; i >= 0; )
            {
               this.removeHighlight(i);
               i--;
            }
            this.mHighlights.length = 0;
            this.mHighlights = null;
         }
         if(this.mHighlightsContainers != null)
         {
            for(o in this.mHighlightsContainers)
            {
               this.removeHighlightContainer(o as DisplayObjectContainer);
            }
            this.mHighlightsContainers = null;
         }
      }
      
      public function removeHighlightObject(highlight:Highlight) : void
      {
         var index:int = 0;
         if(this.mHighlightsContainers != null && highlight.parent && highlight.parent in this.mHighlightsContainers)
         {
            this.removeHighlightContainer(highlight.parent);
         }
         if(this.mHighlights != null)
         {
            index = this.mHighlights.lastIndexOf(highlight);
            if(index >= 0)
            {
               this.removeHighlight(index);
            }
            highlight.destroy();
         }
      }
      
      public function getHighlightCount() : int
      {
         if(this.mHighlights == null)
         {
            return 0;
         }
         return this.mHighlights.length;
      }
      
      public function getHighlightFromContainer(container:DisplayObjectContainer) : Highlight
      {
         if(this.mHighlightsContainers != null)
         {
            return this.mHighlightsContainers[container];
         }
         return null;
      }
      
      private function fadeUnload() : void
      {
         this.fadeEnd();
         this.mFadeDO = null;
      }
      
      private function fadeResize(stageWidth:int, stageHeight:int) : void
      {
         if(this.mFadeIsEnabled)
         {
            this.fadeDrawRect(stageWidth,stageHeight);
         }
      }
      
      private function fadeChangeState(state:int, time:int = -1) : void
      {
         var layer:DCLayer = null;
         this.mFadeState = state;
         switch(this.mFadeState)
         {
            case 0:
               this.mFadeTime = time;
               this.mFadeIsEnabled = true;
               if(this.mFadeDO != null)
               {
                  this.mFadeDO.alpha = 1;
               }
               break;
            case 1:
               this.mFadeTime = time;
               break;
            case 2:
               if(this.mFadeIsEnabled)
               {
                  layer = this.fadeGetLayer();
                  if(layer != null)
                  {
                     layer.removeChild(this.mFadeDO);
                  }
                  this.mFadeTime = -1;
                  this.mFadeIsEnabled = false;
                  break;
               }
         }
      }
      
      private function fadeDrawRect(stageWidth:int, stageHeight:int) : void
      {
         var g:Graphics = this.mFadeDO.graphics;
         g.clear();
         g.beginFill(16777215);
         g.drawRect(0,0,stageWidth,stageHeight);
         g.endFill();
      }
      
      public function fadeEnable(color:uint, timeFull:int = 0) : void
      {
         var layer:DCLayer = null;
         if(this.mFadeDO == null)
         {
            this.mFadeDO = new Sprite();
         }
         if(mStage != null)
         {
            this.mFadeDO.alpha = 1;
            this.fadeDrawRect(mStage.getStageWidth(),mStage.getStageHeight());
            layer = this.fadeGetLayer();
            if(layer != null)
            {
               layer.addChild(this.mFadeDO);
            }
            this.fadeChangeState(0,timeFull);
         }
      }
      
      private function fadeEnd() : void
      {
         var layer:DCLayer = null;
         if(this.mFadeIsEnabled)
         {
            layer = this.fadeGetLayer();
            if(layer != null)
            {
               layer.removeChild(this.mFadeDO);
            }
            this.mFadeTime = -1;
            this.mFadeIsEnabled = false;
         }
      }
      
      public function fadeLogicUpdate(dt:int) : void
      {
         if(this.mFadeIsEnabled)
         {
            if(this.mFadeTime >= 0)
            {
               this.mFadeTime -= dt;
            }
            switch(this.mFadeState)
            {
               case 0:
                  if(this.mFadeTime <= 0)
                  {
                     this.fadeChangeState(1,1000);
                  }
                  break;
               case 1:
                  if(this.mFadeTime <= 0)
                  {
                     this.fadeChangeState(2);
                     break;
                  }
                  if(this.mFadeDO != null)
                  {
                     this.mFadeDO.alpha = this.mFadeTime / 1000;
                  }
                  break;
            }
         }
      }
      
      public function fadeIsEnabled() : Boolean
      {
         return this.mFadeIsEnabled;
      }
      
      private function fadeGetLayer() : DCLayer
      {
         var layerId:int = getLayerIdFromSku(this.fadeGetLayerSku());
         return mLayers[layerId];
      }
      
      protected function fadeGetLayerSku() : String
      {
         return "background";
      }
   }
}
