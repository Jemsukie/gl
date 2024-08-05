package com.dchoc.toolkit.core.view.mng
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.core.view.display.layer.DCLayer;
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import esparragon.display.ESprite;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class DCViewMng extends DCComponent
   {
      
      public static const LAYER_BACKGROUND_SKU:String = "background";
      
      public static const LAYER_BACKGROUND:int = 0;
      
      public static const ALIGN_NONE:int = 0;
      
      public static const ALIGN_TOP_LEFT:int = 1;
      
      public static const ALIGN_TOP_CENTER:int = 2;
      
      public static const ALIGN_TOP_RIGHT:int = 3;
      
      public static const ALIGN_LEFT:int = 4;
      
      public static const ALIGN_CENTER:int = 5;
      
      public static const ALIGN_RIGHT:int = 6;
      
      public static const ALIGN_BOTTOM_LEFT:int = 7;
      
      public static const ALIGN_BOTTOM_CENTER:int = 8;
      
      public static const ALIGN_BOTTOM_RIGHT:int = 9;
      
      private static const ALIGN_AREAS_COUNT:int = 10;
       
      
      protected var mStage:DCStage;
      
      private var mStageWidth:int;
      
      private var mStageHeight:int;
      
      protected var mLayers:Array;
      
      protected var mLayerDictionary:Dictionary;
      
      private var mBackground:Shape;
      
      private var mAlignDOsPerArea:Vector.<Vector.<DisplayObject>>;
      
      private var mAlignAreaPerDOs:Dictionary;
      
      public function DCViewMng()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var layer:DCLayerSWF = null;
         var disp:DCDisplayObject = null;
         if(step == 0)
         {
            this.mLayers = [];
            layer = new DCLayerSWF();
            this.mBackground = new Shape();
            disp = new DCDisplayObjectSWF(this.mBackground);
            layer.addChild(disp);
            this.mLayers[0] = layer;
            this.mLayerDictionary = new Dictionary();
            this.mLayerDictionary["background"] = 0;
            this.alignLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         var layer:DCLayer = null;
         if(this.mLayers != null)
         {
            while(this.mLayers.length > 0)
            {
               layer = this.mLayers.pop();
               layer.unload();
            }
         }
         this.mLayers = null;
         this.alignUnload();
      }
      
      override protected function unbuildDo() : void
      {
         var layer:DCLayer = null;
         for each(layer in this.mLayers)
         {
            layer.unbuild();
         }
         this.alignUnbuild();
      }
      
      override protected function beginDo() : void
      {
         if(this.mStage != null)
         {
            this.addToStageDo(this.mStage);
         }
      }
      
      override protected function endDo() : void
      {
         if(this.mStage != null)
         {
            this.removeFromStage();
         }
      }
      
      public function getTopLayerId() : int
      {
         return this.mLayers != null ? this.mLayers.length - 1 : 0;
      }
      
      public function getLayerIdFromSku(sku:String) : int
      {
         return this.mLayerDictionary[sku];
      }
      
      public function addToStage(stage:DCStage) : void
      {
         this.mStage = stage;
         this.mStageWidth = this.getStageWidth();
         this.mStageHeight = this.getStageHeight();
      }
      
      protected function addToStageDo(stage:DCStage) : void
      {
         var layer:DCLayer = null;
         for each(layer in this.mLayers)
         {
            layer.addToStage(stage);
         }
      }
      
      public function removeFromStage() : void
      {
         this.removeFromStageDo();
         this.mStage = null;
      }
      
      protected function removeFromStageDo() : void
      {
         var layer:DCLayer = null;
         for each(layer in this.mLayers)
         {
            layer.removeFromStage(this.mStage);
         }
      }
      
      public function getStageWidth() : int
      {
         return this.mStage == null ? 0 : this.mStage.getStageWidth();
      }
      
      public function getStageHeight() : int
      {
         return this.mStage == null ? 0 : this.mStage.getStageHeight();
      }
      
      public function getStage() : DCStage
      {
         return this.mStage;
      }
      
      public function setBackgroundColor(color:uint) : void
      {
         this.mBackground.graphics.clear();
         this.mBackground.graphics.beginFill(color);
         this.mBackground.graphics.drawRect(0,0,this.mStage.getStageWidth(),this.mStage.getStageHeight());
         this.mBackground.graphics.endFill();
      }
      
      public function addESpriteToLayer(child:ESprite, layer:String, areaId:int = 1) : void
      {
         var dclayer:DCLayer;
         (dclayer = this.mLayers[this.mLayerDictionary[layer]]).addChild(child);
         this.alignAddChild(child,areaId);
         ESprite(child).onResizeUpdate();
      }
      
      public function removeESpriteFromLayer(child:ESprite, layer:String) : void
      {
         var dclayer:DCLayer = null;
         if(child != null)
         {
            dclayer = this.mLayers[this.mLayerDictionary[layer]];
            dclayer.removeChild(child);
            this.alignRemoveChild(child,this.alignGetAreaId(child));
         }
      }
      
      public function addChildToLayer(d:*, layer:String, pos:int = -1, updateLayer:Boolean = false) : void
      {
         var dclayer:DCLayer;
         (dclayer = this.mLayers[this.mLayerDictionary[layer]]).addChild(d,pos);
         if(d is DCDisplayObject)
         {
            DCDisplayObject(d).setLayerParent(dclayer);
         }
         if(updateLayer)
         {
            dclayer.screenRefresh();
         }
      }
      
      public function removeChildFromLayer(d:*, layer:String) : void
      {
         var dclayer:DCLayer = null;
         if(d != null)
         {
            dclayer = this.mLayers[this.mLayerDictionary[layer]];
            dclayer.removeChild(d);
            if(d is DCDisplayObject)
            {
               DCDisplayObject(d).setLayerParent(null);
            }
         }
      }
      
      public function addTooltip(d:*) : void
      {
      }
      
      public function removeTooltip(d:*) : void
      {
      }
      
      public function addPopup(d:*, pos:int = -1) : void
      {
      }
      
      public function removePopup(d:*) : void
      {
      }
      
      protected function zoomLayer(zoom:Number, layer:String) : void
      {
         var dclayer:DCLayer = this.mLayers[this.mLayerDictionary[layer]];
         dclayer.zoom(zoom);
      }
      
      public function contains(d:*) : Boolean
      {
         var layer:DCLayer = null;
         for each(layer in this.mLayers)
         {
            if(layer.contains(d))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getLayerDisPlayObjectFromSku(sku:String) : DCDisplayObject
      {
         return this.mLayers[this.mLayerDictionary[sku]];
      }
      
      public function onResize(stageWidth:int, stageHeight:int) : void
      {
         var layer:DCLayer = null;
         for each(layer in this.mLayers)
         {
            layer.onResize(stageWidth,stageHeight);
         }
         this.alignResize(stageWidth - this.mStageWidth,stageHeight - this.mStageHeight);
      }
      
      public function cameraGetBox() : DCBox
      {
         return null;
      }
      
      public function cameraCollision(x:Number, y:Number, width:Number, height:Number) : Boolean
      {
         return false;
      }
      
      public function takeScreenShot(layer:int, scale:Number = 1, cameraX:int = -1, cameraY:int = -1) : BitmapData
      {
         var w:int = 0;
         var h:int = 0;
         var bmp:BitmapData = null;
         var matrix:Matrix = null;
         var dsp:DisplayObject = null;
         var layerObj:DCLayer = null;
         var i:int = 0;
         if(this.getStage() != null && this.getStage().getImplementation() != null)
         {
            w = this.getStage().getImplementation().stageWidth * scale;
            h = this.getStage().getImplementation().stageHeight * scale;
            bmp = new BitmapData(w,h,true,4294967295);
            matrix = new Matrix();
            for(i = 0; i <= layer; )
            {
               if((layerObj = this.mLayers[i]) != null)
               {
                  dsp = layerObj.getDisplayObject();
                  matrix.identity();
                  matrix.scale(scale,scale);
                  if(cameraX == -1 || cameraY == -1)
                  {
                     matrix.translate(layerObj.cameraX * scale,layerObj.cameraY * scale);
                  }
                  else
                  {
                     matrix.translate(cameraX * scale,cameraY * scale);
                  }
                  bmp.draw(dsp,matrix);
               }
               i++;
            }
            return bmp;
         }
         return null;
      }
      
      private function alignLoad() : void
      {
         var i:int = 0;
         this.mAlignDOsPerArea = new Vector.<Vector.<DisplayObject>>(10);
         for(i = 0; i < 10; )
         {
            this.mAlignDOsPerArea[i] = new Vector.<DisplayObject>(0);
            i++;
         }
      }
      
      private function alignUnload() : void
      {
         this.mAlignDOsPerArea = null;
         this.mAlignAreaPerDOs = null;
      }
      
      private function alignUnbuild() : void
      {
         var dosList:Vector.<DisplayObject> = null;
         if(this.mAlignDOsPerArea != null)
         {
            for each(dosList in this.mAlignDOsPerArea)
            {
               dosList.length = 0;
            }
         }
         if(this.mAlignAreaPerDOs == null)
         {
            this.mAlignAreaPerDOs = null;
         }
      }
      
      private function alignGetAreaId(child:DisplayObject) : int
      {
         var returnValue:int = 0;
         if(this.mAlignAreaPerDOs != null && this.mAlignAreaPerDOs != null)
         {
            returnValue = int(this.mAlignAreaPerDOs[child]);
         }
         return returnValue;
      }
      
      private function alignAddChild(child:DisplayObject, areaId:int) : void
      {
         if(this.mAlignAreaPerDOs == null)
         {
            this.mAlignAreaPerDOs = new Dictionary(true);
         }
         var currentAreaId:int = this.alignGetAreaId(child);
         if(currentAreaId != areaId)
         {
            if(currentAreaId != 0)
            {
               this.alignRemoveChild(child,this.mAlignAreaPerDOs[child]);
            }
            this.mAlignAreaPerDOs[child] = areaId;
            (this.mAlignDOsPerArea[areaId] as Vector.<DisplayObject>).push(child);
            this.alignChild(child,areaId,this.mStageWidth,this.mStageHeight);
         }
      }
      
      private function alignRemoveChild(child:DisplayObject, areaId:int) : void
      {
         var dosList:Vector.<DisplayObject> = null;
         var index:int = 0;
         if(this.mAlignAreaPerDOs != null)
         {
            if(this.mAlignAreaPerDOs[child] != null)
            {
               delete this.mAlignAreaPerDOs[child];
               dosList = this.mAlignDOsPerArea[areaId] as Vector.<DisplayObject>;
               if((index = dosList.indexOf(child)) > -1)
               {
                  dosList.splice(index,1);
               }
            }
         }
      }
      
      private function alignChild(element:DisplayObject, areaId:int, dWidth:Number, dHeight:Number) : void
      {
         switch(areaId - 1)
         {
            case 0:
               break;
            case 1:
               element.x += dWidth / 2;
               break;
            case 2:
               element.x += dWidth;
               break;
            case 3:
               element.y += dHeight / 2;
               break;
            case 4:
               element.x += dWidth / 2;
               element.y += dHeight / 2;
               break;
            case 5:
               element.x += dWidth;
               element.y += dHeight / 2;
               break;
            case 6:
               element.y += dHeight;
               break;
            case 7:
               element.x += dWidth / 2;
               element.y += dHeight;
               break;
            case 8:
               element.x += dWidth;
               element.y += dHeight;
         }
      }
      
      private function alignResize(dWidth:Number, dHeight:Number) : void
      {
         var i:int = 0;
         var j:int = 0;
         var length:int = 0;
         var child:DisplayObject = null;
         this.mStageWidth += dWidth;
         this.mStageHeight += dHeight;
         for(i = 0; i < 10; )
         {
            length = int(this.mAlignDOsPerArea[i].length);
            for(j = 0; j < length; )
            {
               child = this.mAlignDOsPerArea[i][j];
               this.alignChild(this.mAlignDOsPerArea[i][j],i,dWidth,dHeight);
               if(child is ESprite)
               {
                  ESprite(child).onResizeUpdate();
               }
               j++;
            }
            i++;
         }
      }
   }
}
