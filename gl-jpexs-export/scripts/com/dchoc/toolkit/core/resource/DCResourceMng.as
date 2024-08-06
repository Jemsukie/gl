package com.dchoc.toolkit.core.resource
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.EResourceDefLoaded;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.animations.AnimationsReader;
   import com.dchoc.toolkit.utils.math.DCMath;
   import esparragon.resources.EResourcesMng;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class DCResourceMng extends DCComponent
   {
      
      public static var smMemoryUsed:Number;
      
      public static const FORMAT_SWF:int = 0;
      
      public static const FORMAT_PNG:int = 2;
      
      public static const FORMAT_BITMAP:int = 3;
      
      public static const FORMAT_DEFAULT:int = 0;
      
      public static const POINT_ZERO:Point = new Point();
      
      protected static var smAssetsTable:Dictionary;
      
      private static const RESOURCES_LOADING_QUEUE_ENABLED:Boolean = false;
      
      private static const RESOURCES_LOADING_QUEUE_SIMULTANEOUSLY:int = 1;
       
      
      protected var mCatalog:Dictionary;
      
      protected var mImageCatalog:Dictionary;
      
      protected var mBitmapsPerSku:Dictionary;
      
      protected var mBitmapsCatalog:Dictionary;
      
      protected var mCorCatalog:Dictionary;
      
      private var mSkusImmediate:Vector.<String>;
      
      private var mEmptyBitmapData:BitmapData;
      
      private var mEmptyRect:Rectangle;
      
      private var mEResourcesMng:EResourcesMng;
      
      private var mRequestsPending:Vector.<String>;
      
      private var mProgressAllFilesRequested:Boolean;
      
      private var mProgressAllImmediateFilesRequested:Boolean;
      
      private var mProgressImmediateCurrentFiles:int;
      
      private var mProgressImmediateTotalFiles:int;
      
      private var mProgressDelayedList:Vector.<DCResourceDef>;
      
      private var mProgressDelayedCurrentFiles:int;
      
      private var mProgressDelayedTotalFiles:int;
      
      private var mResourcesLoadingQueue:Vector.<DCResourceDef>;
      
      private var mProfilingDownloadedAmount:Number = 0;
      
      private var mLabelsDictionary:Dictionary;
      
      public function DCResourceMng()
      {
         super();
         if(Config.DEBUG_MODE)
         {
            this.mSkusImmediate = new Vector.<String>(0);
         }
         updateMemory(true);
         this.mCatalog = new Dictionary(true);
         this.mImageCatalog = new Dictionary(true);
         this.mBitmapsCatalog = new Dictionary(true);
         this.mCorCatalog = new Dictionary(true);
         smAssetsTable = new Dictionary(true);
         this.progressLoad();
         updateMemory(true);
      }
      
      public static function formatToExtension(format:int) : String
      {
         var returnValue:String = null;
         switch(format)
         {
            case 0:
            case 3:
               returnValue = ".swf";
               break;
            case 2:
               returnValue = ".png";
         }
         return returnValue;
      }
      
      public static function updateMemory(print:Boolean = false) : Number
      {
         var oldMem:Number = smMemoryUsed;
         smMemoryUsed = DCDebug.getMemoryUsed("k");
         if(Config.DEBUG_MEMORY && print)
         {
            DCDebug.traceCh("MEMORY","Memory Step: " + (smMemoryUsed - oldMem));
         }
         return smMemoryUsed - oldMem;
      }
      
      public static function getFileName(id:String) : String
      {
         if(smAssetsTable && smAssetsTable[id] != undefined)
         {
            return smAssetsTable[id];
         }
         return Config.getRoot() + id;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         this.resourcesLoadingQueueLoad();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         switch(step)
         {
            case 0:
               this.mEResourcesMng = InstanceMng.getEResourcesMng();
               if(this.mEResourcesMng.isReady())
               {
                  this.buildAssetsTable(this.mEResourcesMng.getAssetString("lutTable","default"));
                  this.catalogPopulate();
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override protected function unloadDo() : void
      {
         this.progressUnload();
         this.resourcesLoadingQueueUnload();
         this.mCatalog = null;
         if(Config.DEBUG_MODE)
         {
            this.mSkusImmediate = null;
         }
         this.bitmapsUnload();
         this.labelsUnload();
         this.mRequestsPending = null;
         this.mEResourcesMng = null;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var currentLoading:int = 0;
         var i:int = 0;
         var length:int = 0;
         var def:DCResourceDef = null;
         var sku:String = null;
         if(false)
         {
            currentLoading = 0;
            length = int(this.mResourcesLoadingQueue.length);
            for(i = 0; i < length; )
            {
               def = this.mResourcesLoadingQueue[i];
               if(def.isLoaded())
               {
                  this.mResourcesLoadingQueue.splice(i,1);
                  length--;
               }
               else
               {
                  if(def.hasBeenRequested())
                  {
                     currentLoading++;
                  }
                  else if(currentLoading < 1)
                  {
                     currentLoading++;
                     def.request();
                  }
                  i++;
               }
            }
         }
         if(this.mRequestsPending != null)
         {
            if(this.mEResourcesMng.isAssetPriorityAllowedToLoad(2))
            {
               while(this.mRequestsPending.length > 0)
               {
                  sku = this.mRequestsPending.shift();
                  this.doRequestResource(sku);
               }
            }
         }
      }
      
      protected function catalogPopulate() : void
      {
      }
      
      public function catalogAddResource(sku:String, path:String, type:String = ".swf", format:int = 0, immediate:Boolean = true) : void
      {
         if(this.mCatalog[sku] == null)
         {
            this.mCatalog[sku] = new DCResourceDefLoaded(sku,path,type,format,false,immediate);
            if(immediate)
            {
               this.requestResource(sku);
            }
         }
      }
      
      public function catalogAddTileset(sku:String, path:String, format:int = 0, immediate:Boolean = true) : void
      {
         var fileName:String = DCResourceMng.getFileName(path + ".png");
         this.catalogAddResource(sku + "_png",fileName,".png",format,immediate);
         fileName = DCResourceMng.getFileName(path + ".cor");
         this.catalogAddResource(sku + "_cor",fileName,"ByteArray",format,immediate);
      }
      
      public function requestResource(sku:String) : void
      {
         var resourceDef:DCResourceDef = this.getResourceDef(sku);
         if(resourceDef != null)
         {
            if(resourceDef is EResourceDefLoaded)
            {
               resourceDef.request();
            }
            else
            {
               if(this.mRequestsPending == null)
               {
                  this.mRequestsPending = new Vector.<String>(0);
               }
               if(this.mRequestsPending.indexOf(sku) == -1)
               {
                  this.mRequestsPending.push(sku);
               }
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","WARNING in DCResourceMng.requestResource sku <" + sku + "> requested but not defined",1);
         }
      }
      
      private function doRequestResource(sku:String) : void
      {
         var resourceDef:DCResourceDef = this.getResourceDef(sku);
         if(resourceDef != null && !resourceDef.hasBeenRequested())
         {
            if(resourceDef.isImmediate())
            {
               this.progressAddImmediate(resourceDef);
            }
            else
            {
               this.progressAddDelayed(resourceDef);
               resourceDef.setHasBeenRequested(true);
            }
         }
      }
      
      public function getResource(sku:String, type:String = null, decode:Boolean = false) : *
      {
         var resourceDef:DCResourceDef;
         return (resourceDef = this.getResourceDef(sku)) == null ? null : resourceDef.getResource(type,decode);
      }
      
      public function isResourceLoaded(sku:String) : Boolean
      {
         var resourceDef:DCResourceDef = null;
         var returnValue:Boolean = this.mBitmapsPerSku != null && this.mBitmapsPerSku[sku] != null;
         if(!returnValue)
         {
            resourceDef = this.getResourceDef(sku);
            returnValue = resourceDef != null && resourceDef.isLoaded();
         }
         return returnValue;
      }
      
      public function unloadResource(sku:String, clearBitmaps:Boolean = true) : void
      {
         var resourceDef:DCResourceDef = this.getResourceDef(sku);
         if(resourceDef != null)
         {
            if(resourceDef.isLoaded())
            {
               resourceDef.unload();
               if(clearBitmaps)
               {
                  this.bitmapsReleaseResource(sku);
               }
            }
            else if(Config.DEBUG_ASSERTS)
            {
               DCDebug.traceCh("TOOLKIT","WARNING in DCResourceMng.unloadResource sku <" + sku + "> asked for unloading but it\'s not loaded",1);
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","WARNING in DCResourceMng.unloadResource sku <" + sku + "> asked for unloading but not defined",1);
         }
      }
      
      protected function getResourceDef(sku:String) : DCResourceDef
      {
         return this.mCatalog[sku];
      }
      
      public function getSWFClass(sku:String, className:String) : Class
      {
         var resourceDef:DCResourceDefLoaded = this.getResourceDef(sku) as DCResourceDefLoaded;
         return resourceDef != null ? resourceDef.getSWFClass(className) : null;
      }
      
      public function getDCDisplayObject(sku:String, className:String, storeLabels:Boolean = false, format:int = -1) : DCDisplayObject
      {
         var returnValue:DCDisplayObject = null;
         var resourceDef:DCResourceDefLoaded;
         if((resourceDef = this.getResourceDef(sku) as DCResourceDefLoaded) != null)
         {
            if((returnValue = resourceDef.getDCDisplayObject(className,format)) != null && storeLabels)
            {
               this.labelsLoadAnim(sku,className,returnValue);
            }
         }
         return returnValue;
      }
      
      public function notifyResourceLoaded(def:DCResourceDef, effective:Boolean = true) : void
      {
         var pos:int = 0;
         if(Config.DEBUG_MODE && effective)
         {
            DCDebug.traceCh("TOOLKIT","DCResourcesMng: <" + def.getSku() + "> has been loaded successfully (" + updateMemory() + "Ks)");
         }
         if(def.isImmediate())
         {
            this.mProgressImmediateCurrentFiles++;
            if(Config.DEBUG_MODE)
            {
               pos = this.mSkusImmediate.indexOf(def.getSku());
               if(pos > -1)
               {
                  this.mSkusImmediate.splice(pos,1);
               }
            }
         }
      }
      
      public function notifyResourceFailed(def:DCResourceDef) : void
      {
         var instanceMng:DCInstanceMng = null;
         var e:Object = null;
         if(Config.DEBUG_MODE)
         {
            DCDebug.traceCh("TOOLKIT","DCResourcesMng: <" + def.getSku() + "> has failed to load");
         }
         if(def.isBlocker())
         {
            instanceMng = DCInstanceMng.getInstance();
            e = {
               "cmd":"eventAbortApplication",
               "msg":"Blocker resource <" + def.getSku() + "> has failed to load"
            };
            instanceMng.getNotifyMng().addEvent(DCInstanceMng.getInstance().getApplication(),e);
         }
         else
         {
            this.notifyResourceLoaded(def,false);
         }
      }
      
      public function getImageFromCatalog(sku:String, extra:Object = null) : BitmapData
      {
         var bmp:BitmapData = null;
         if(this.mImageCatalog[sku] == null)
         {
            if(extra != null)
            {
               bmp = BitmapData(DCInstanceMng.getInstance().getResourceMng().getResource(extra.origin)).clone();
               var _loc4_:* = extra.action;
               if("alpha" === _loc4_)
               {
                  bmp.colorTransform(new Rectangle(0,0,bmp.width,bmp.height),new ColorTransform(1,1,1,extra.value,0,0,0,0));
               }
               this.mImageCatalog[sku] = bmp;
            }
            else
            {
               this.mImageCatalog[sku] = DCInstanceMng.getInstance().getResourceMng().getResource(sku) as BitmapData;
            }
         }
         return this.mImageCatalog[sku];
      }
      
      public function addImageToCatalog(sku:String, bmp:BitmapData) : void
      {
         this.mImageCatalog[sku] = bmp;
      }
      
      public function addBitmapAnimationToCatalog(sku:String, anims:Object) : void
      {
         this.mBitmapsCatalog[sku] = anims;
      }
      
      public function getBitmapAnimationFromCatalog(sku:String, className:String) : Object
      {
         return this.mBitmapsCatalog[sku + className];
      }
      
      private function releaseBitmapAnimationFromCatalog(sku:String, className:String) : void
      {
         var bmps:Vector.<BitmapData> = null;
         var bmp:BitmapData = null;
         var key:String = sku + className;
         var anims:Object;
         if((anims = this.mBitmapsCatalog[key]) != null)
         {
            bmps = anims.bmps;
            if(bmps != null)
            {
               for each(bmp in bmps)
               {
                  bmp.dispose();
               }
               anims.bmps = null;
            }
            this.mBitmapsCatalog[key] = null;
         }
      }
      
      public function generateBitmapFromMovieclip(sku:String, className:String, localClass:Class = null) : Object
      {
         var anims:Object = null;
         var mc:MovieClip = null;
         var bmp:BitmapData = null;
         var bmp2:BitmapData = null;
         var rect2:Rectangle = null;
         var matrix:Matrix = null;
         var bounds:Rectangle = null;
         var bmps:Vector.<BitmapData> = null;
         var boundsVector:Vector.<Rectangle> = null;
         var collboxes:Vector.<Vector.<Point>> = null;
         var currentCollBox:Vector.<Point> = null;
         var labels:Vector.<String> = null;
         var collbox:DisplayObject = null;
         var collboxPos:Point = null;
         var w:int = 0;
         var h:int = 0;
         var boundx:int = 0;
         var boundy:int = 0;
         var collBoxCount:int = 0;
         var i:int = 0;
         var cols:* = 0;
         var rows:int = 0;
         var bmpsCount:int = 0;
         var anglesCount:* = 0;
         var checkCols:Boolean = false;
         var endFrame:int = 0;
         var endTag:String = null;
         var j:int = 0;
         var bound2x:int = 0;
         var bound2y:int = 0;
         var w2:int = 0;
         var h2:int = 0;
         var stage:Stage;
         var quality:String = (stage = DCInstanceMng.getInstance().getViewMng().getStage().getImplementation()).quality;
         if(localClass == null)
         {
            localClass = DCInstanceMng.getInstance().getResourceMng().getSWFClass(sku,className);
         }
         var OFFSET:int = 30;
         if(localClass != null)
         {
            mc = new localClass();
            matrix = new Matrix();
            bmps = new Vector.<BitmapData>(mc.totalFrames,true);
            boundsVector = new Vector.<Rectangle>(mc.totalFrames,true);
            collboxes = new Vector.<Vector.<Point>>(mc.totalFrames,true);
            labels = new Vector.<String>(mc.totalFrames,true);
            stage.quality = "best";
            for(i = 0; i < mc.totalFrames; )
            {
               this.stopAnim(mc,i);
               mc.cacheAsBitmap = true;
               bounds = mc.getBounds(mc);
               boundx = Math.round(bounds.x);
               boundy = Math.round(bounds.y);
               collBoxCount = 0;
               for(j = 0; j < mc.numChildren; )
               {
                  if((collbox = mc.getChildAt(j)) != null && collbox.name.indexOf("collision") > -1)
                  {
                     collBoxCount++;
                  }
                  j++;
               }
               if(collBoxCount > 0)
               {
                  currentCollBox = new Vector.<Point>(collBoxCount,true);
                  for(j = 0; j < collBoxCount; )
                  {
                     if((collbox = mc.getChildByName("collision" + (j + 1))) != null)
                     {
                        collboxPos = new Point(collbox.x,collbox.y);
                        currentCollBox[j] = collboxPos;
                     }
                     j++;
                  }
                  collboxes[i] = currentCollBox;
               }
               labels[i] = mc.currentFrameLabel;
               if((w = Math.round(bounds.width)) == 0)
               {
                  w = 1;
               }
               if((h = Math.round(bounds.height)) == 0)
               {
                  h = 1;
               }
               if(h > 1 && w > 1)
               {
                  bmp = new BitmapData(w + OFFSET,h + OFFSET,true,16777215);
                  matrix.identity();
                  matrix.translate(-boundx + OFFSET,-boundy + OFFSET);
                  bmp.draw(mc,matrix);
                  rect2 = bmp.getColorBoundsRect(4278190080,0,false);
                  bound2x = Math.round(rect2.x);
                  bound2y = Math.round(rect2.y);
                  w2 = Math.round(rect2.width);
                  h2 = Math.round(rect2.height);
                  if(w2 > 1 && h2 > 0)
                  {
                     bmp2 = new BitmapData(w2,h2,true,16777215);
                     matrix.identity();
                     matrix.translate(-bound2x,-bound2y);
                     bmp2.draw(bmp,matrix);
                     bmps[i] = bmp2;
                     boundsVector[i] = new Rectangle(boundx - OFFSET + bound2x,boundy - OFFSET + bound2y,w2,h2);
                  }
                  else
                  {
                     this.setEmptyBmp(bmps,boundsVector,i);
                  }
               }
               else
               {
                  this.setEmptyBmp(bmps,boundsVector,i);
               }
               i++;
            }
            stage.quality = "low";
            cols = 0;
            rows = 0;
            bmpsCount = int(bmps.length);
            anglesCount = 0;
            endFrame = 1;
            for(i = 0; i < mc.currentLabels.length; )
            {
               if(mc.currentLabels[i].name.indexOf("01_end") > -1)
               {
                  checkCols = true;
                  endFrame = int(mc.currentLabels[i].frame);
                  endTag = String(mc.currentLabels[i].name);
                  break;
               }
               i++;
            }
            if(checkCols)
            {
               if(endTag != null)
               {
                  mc.gotoAndStop(endTag);
                  cols = endFrame;
               }
            }
            else
            {
               cols = mc.totalFrames;
            }
            anglesCount = rows = bmpsCount / cols;
            mc = null;
            anims = {
               "bmps":bmps,
               "bounds":boundsVector,
               "collbox":collboxes,
               "rows":rows,
               "cols":cols,
               "frameCount":bmpsCount,
               "anglesCount":anglesCount,
               "labels":labels
            };
            this.addBitmapAnimationToCatalog(sku + className,anims);
            this.bitmapsAddAnims(sku,className);
            stage.quality = quality;
         }
         return anims;
      }
      
      private function stopAnim(an:DisplayObjectContainer, frame:int) : void
      {
         var i:int = 0;
         var child:DisplayObjectContainer = null;
         var myFrame:int = 0;
         for(i = 0; i < an.numChildren; )
         {
            if((child = an.getChildAt(i) as DisplayObjectContainer) != null)
            {
               if(child is MovieClip)
               {
                  myFrame = frame % MovieClip(child).totalFrames + 1;
                  MovieClip(child).gotoAndStop(myFrame);
               }
               this.stopAnim(child,frame);
            }
            i++;
         }
         if(an is MovieClip)
         {
            myFrame = frame % MovieClip(an).totalFrames + 1;
            MovieClip(an).gotoAndStop(myFrame);
         }
      }
      
      private function bitmapsAddAnims(sku:String, className:String) : void
      {
         if(this.mBitmapsPerSku == null)
         {
            this.mBitmapsPerSku = new Dictionary();
         }
         if(this.mBitmapsPerSku[sku] == null)
         {
            this.mBitmapsPerSku[sku] = new Vector.<String>(0);
         }
         var v:Vector.<String> = this.mBitmapsPerSku[sku];
         v.push(className);
      }
      
      private function bitmapsReleaseResource(sku:String) : void
      {
         var list:Vector.<String> = null;
         var className:String = null;
         if(this.mBitmapsPerSku != null)
         {
            list = this.mBitmapsPerSku[sku];
            if(list != null)
            {
               while(list.length > 0)
               {
                  className = list.shift();
                  this.releaseBitmapAnimationFromCatalog(sku,className);
               }
               this.mBitmapsPerSku[sku] = null;
            }
         }
      }
      
      private function bitmapsUnload() : void
      {
         var k:* = null;
         var sku:String = null;
         if(this.mBitmapsPerSku != null)
         {
            for(k in this.mBitmapsPerSku)
            {
               sku = k;
               this.bitmapsReleaseResource(sku);
            }
            this.mBitmapsPerSku = null;
         }
      }
      
      private function movieClipHasLabel(movieClip:MovieClip, labelName:String) : Boolean
      {
         var k:int = 0;
         var i:int = 0;
         var label:FrameLabel = null;
         for(k = int(movieClip.currentLabels.length); i < k; )
         {
            if((label = movieClip.currentLabels[i]).name.indexOf(labelName) > -1)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      private function setEmptyBmp(bmps:Vector.<BitmapData>, boundsVector:Vector.<Rectangle>, index:int) : void
      {
         if(this.mEmptyBitmapData == null)
         {
            this.mEmptyBitmapData = new BitmapData(1,1,true,16777215);
            this.mEmptyRect = new Rectangle(0,0,1,1);
         }
         bmps[index] = this.mEmptyBitmapData;
         boundsVector[index] = this.mEmptyRect;
      }
      
      public function generateBitmapFromPng(sku:String) : Object
      {
         var anims:Object = null;
         var bmp:BitmapData = null;
         var cor:Vector.<int> = null;
         var length:int = 0;
         var sizeX:int = 0;
         var sizeY:int = 0;
         var destX:int = 0;
         var destY:int = 0;
         var sourX:int = 0;
         var sourY:int = 0;
         var frame:int = 0;
         var rect:Rectangle = null;
         var matrix:Matrix = null;
         var point:Point = null;
         var i:int = 0;
         var BYTES_PER_FRAME:int = 6;
         var data:ByteArray;
         if((data = this.getResource(this.mCorCatalog[sku])) != null)
         {
            cor = AnimationsReader.getCor(data);
         }
         var bmps:Vector.<BitmapData> = new Vector.<BitmapData>();
         var boundsVector:Vector.<Rectangle> = new Vector.<Rectangle>();
         var bmpOrigin:BitmapData = DCInstanceMng.getInstance().getResourceMng().getImageFromCatalog(sku);
         if(cor != null)
         {
            length = cor.length / BYTES_PER_FRAME;
            rect = new Rectangle();
            matrix = new Matrix();
            point = new Point();
            for(i = 0; i < length; )
            {
               frame = i * BYTES_PER_FRAME;
               destX = cor[frame++];
               destY = cor[frame++];
               if((sizeX = cor[frame++]) > 0)
               {
                  sizeY = cor[frame++];
                  sourX = cor[frame++];
                  sourY = cor[frame++];
                  rect.x = sourX;
                  rect.y = sourY;
                  rect.width = sizeX;
                  rect.height = sizeY;
                  bmp = new BitmapData(sizeX,sizeY,true,16777215);
                  bmp.copyPixels(bmpOrigin,rect,point);
                  bmps.push(bmp);
                  boundsVector.push(new Rectangle(destX,destY,sizeX,sizeY));
               }
               i++;
            }
         }
         else
         {
            bmps.push(bmpOrigin);
            boundsVector.push(bmpOrigin.rect);
         }
         anims = {
            "bmps":bmps,
            "bounds":boundsVector
         };
         this.addBitmapAnimationToCatalog(sku,anims);
         return anims;
      }
      
      private function progressLoad() : void
      {
         this.mProgressDelayedList = new Vector.<DCResourceDef>();
      }
      
      private function progressUnload() : void
      {
         if(this.mProgressDelayedList != null)
         {
            this.progressReset();
            this.mProgressDelayedList = null;
         }
      }
      
      public function progressReset() : void
      {
         if(this.mProgressDelayedList != null)
         {
            while(this.mProgressDelayedList.length)
            {
               this.mProgressDelayedList.shift();
            }
            this.mProgressAllFilesRequested = false;
            this.mProgressAllImmediateFilesRequested = false;
            this.mProgressImmediateCurrentFiles = 0;
            this.mProgressImmediateTotalFiles = 0;
            this.mProgressDelayedCurrentFiles = 0;
            this.mProgressDelayedTotalFiles = 0;
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","WARNING in DCResourceMng.progressReset: progressLoad() must be called before calling progressReset()",1);
         }
      }
      
      private function progressAddDelayed(def:DCResourceDef) : void
      {
         this.mProgressDelayedList.push(def);
         this.mProgressDelayedTotalFiles++;
      }
      
      private function progressAddImmediate(def:DCResourceDef) : void
      {
         if(!def.hasBeenRequested() && !def.isLoaded())
         {
            if(Config.DEBUG_MODE)
            {
               this.mSkusImmediate.push(def.getSku());
            }
            this.mProgressImmediateTotalFiles++;
            if(def.canBeEnqueued())
            {
               this.resourcesLoadingQueueAddRequest(def);
            }
            else
            {
               def.request();
            }
         }
      }
      
      public function progressSetAsImmediate(sku:String) : void
      {
         var def:DCResourceDef = this.getResourceDef(sku);
         if(def != null)
         {
            this.progressRemoveDelayed(sku);
            def.setIsImmediate(true);
            this.progressAddImmediate(def);
         }
      }
      
      public function progressRemoveDelayed(sku:String) : void
      {
         var pos:int = 0;
         var def:DCResourceDef = this.getResourceDef(sku);
         if(def != null)
         {
            pos = this.mProgressDelayedList.indexOf(def);
            if(pos > -1)
            {
               this.mProgressDelayedList.splice(pos,1);
               this.mProgressImmediateTotalFiles--;
               if(Config.DEBUG_MODE)
               {
                  pos = this.mSkusImmediate.indexOf(def.getSku());
                  if(pos > -1)
                  {
                     this.mSkusImmediate.splice(pos,1);
                  }
               }
            }
         }
      }
      
      public function progressNotifyAllFilesRequested() : void
      {
         this.mProgressAllFilesRequested = true;
      }
      
      public function progressNotifyAllImmediateFilesRequested() : void
      {
         this.mProgressAllImmediateFilesRequested = true;
      }
      
      public function progressGetImmediateCompletePercent(actualPercent:Boolean = false) : int
      {
         var extraFiles:int = 0;
         var returnValue:int = 0;
         if(!actualPercent && !this.mProgressAllFilesRequested)
         {
            returnValue = 0;
         }
         else
         {
            extraFiles = int(this.mProgressAllImmediateFilesRequested ? 0 : this.mProgressDelayedTotalFiles);
            returnValue = DCMath.ruleOf3(this.mProgressImmediateCurrentFiles,this.mProgressImmediateTotalFiles + extraFiles,100);
            if(returnValue > 100)
            {
               returnValue = 100;
               if(Config.DEBUG_MODE && !Config.DEBUG_SHORTEN_NOISY)
               {
                  DCDebug.trace("mProgressImmediateCurrentFiles > mProgressImmediateTotalFiles + extraFiles !!  " + this.mProgressImmediateCurrentFiles + " > " + this.mProgressImmediateTotalFiles + " + " + extraFiles,1);
               }
            }
         }
         return returnValue;
      }
      
      private function buildAssetsTable(jsonString:String) : void
      {
         var rawData:Object = null;
         var row:Object = null;
         if(jsonString)
         {
            rawData = JSON.parse(jsonString);
            for each(row in rawData)
            {
               smAssetsTable[row["uri"]] = row["path"];
            }
         }
      }
      
      public function printResourcesNotLoadedYet() : void
      {
         var sku:String = null;
         var countRequested:int = 0;
         var msg:String = "Resources requested but not loaded:";
         for each(sku in this.mSkusImmediate)
         {
            msg += sku + ",";
         }
         DCDebug.traceCh("LOADING",msg);
      }
      
      private function resourcesLoadingQueueLoad() : void
      {
         if(false)
         {
            this.mResourcesLoadingQueue = new Vector.<DCResourceDef>();
         }
      }
      
      private function resourcesLoadingQueueUnload() : void
      {
         if(false)
         {
            this.mResourcesLoadingQueue = null;
         }
      }
      
      private function resourcesLoadingQueueAddRequest(def:DCResourceDef) : void
      {
         if(!def.hasBeenEnqueued())
         {
            if(false)
            {
               def.setHasBeenEnqueued(true);
               this.mResourcesLoadingQueue.push(def);
            }
            else
            {
               def.request();
            }
         }
      }
      
      public function profilingAddDownloadedAmount(fileSize:Number) : void
      {
         this.mProfilingDownloadedAmount += fileSize;
      }
      
      public function profilingGetDownloadedAmount() : Number
      {
         return this.mProfilingDownloadedAmount;
      }
      
      public function profilingPrintDownloadedAmount() : void
      {
         var sizeKbs:Number = this.mProfilingDownloadedAmount / 1024;
         var sizeMbs:Number = sizeKbs / 1024;
         DCDebug.traceCh("PROFILING"," data size downloaded = " + sizeMbs + " Mbs");
      }
      
      private function labelsUnload() : void
      {
         this.mLabelsDictionary = null;
      }
      
      public function labelsLoadAnim(skuSwf:String, skuClip:String, dsp:DCDisplayObject = null) : void
      {
         var d:Dictionary = null;
         var label:String = null;
         var currentFrame:int = 0;
         if(this.mLabelsDictionary == null)
         {
            this.mLabelsDictionary = new Dictionary();
         }
         var sku:String = skuSwf + skuClip;
         if(this.mLabelsDictionary[sku] == null)
         {
            if(dsp == null)
            {
               dsp = this.getDCDisplayObject(skuSwf,skuClip);
            }
            if(dsp != null)
            {
               this.mLabelsDictionary[sku] = new Dictionary();
               d = this.mLabelsDictionary[sku];
               currentFrame = dsp.currentFrame;
               dsp.gotoAndStop(1);
               while(dsp.currentFrame < dsp.totalFrames)
               {
                  if((label = dsp.currentFrameLabel) != null)
                  {
                     d[label] = dsp.currentFrame;
                  }
                  dsp.nextFrame();
               }
               dsp.gotoAndPlay(currentFrame);
            }
         }
      }
      
      public function labelsGetFrameByLabel(skuSwf:String, skuClip:String, label:String) : int
      {
         var sku:String = null;
         var returnValue:int = -1;
         if(this.mLabelsDictionary != null)
         {
            sku = skuSwf + skuClip;
            if(this.mLabelsDictionary[sku] != null)
            {
               if(this.mLabelsDictionary[sku][label] != null)
               {
                  returnValue = int(this.mLabelsDictionary[sku][label]);
               }
            }
         }
         return returnValue;
      }
   }
}
