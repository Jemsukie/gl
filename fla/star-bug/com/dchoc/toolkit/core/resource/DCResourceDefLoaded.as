package com.dchoc.toolkit.core.resource
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.DCUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   
   public class DCResourceDefLoaded extends DCResourceDef
   {
      
      private static const DEBUG:Boolean = true;
      
      private static const USE_CONTEXT:Boolean = true;
       
      
      private var mPath:String;
      
      private var mType:String;
      
      private var mFormat:int;
      
      private var mAttemptsCount:int;
      
      private var mLoader:Object;
      
      private var mUnloader:Object;
      
      private var mCanBeEnqueued:Boolean;
      
      public function DCResourceDefLoaded(sku:String, path:String, type:String = "", format:int = 0, isBlocker:Boolean = true, isImmediate:Boolean = true, canBeEnqueued:Boolean = true)
      {
         super(sku,isBlocker,isImmediate);
         this.mPath = path;
         this.mType = type;
         this.mFormat = format;
         this.mAttemptsCount = 0;
         this.mCanBeEnqueued = canBeEnqueued;
      }
      
      override public function request() : void
      {
         super.request();
         if(this.mAttemptsCount < 3)
         {
            this.mAttemptsCount++;
            this.loadFromFile(this.mPath,this.mType);
         }
         else
         {
            markAsFailed();
         }
      }
      
      private function loadFromFile(path:String, returnType:String = "") : void
      {
         var url:URLRequest = null;
         var extIndex:int = 0;
         var urlLoader:URLLoader = null;
         var loader:Loader = null;
         var loaderContext:LoaderContext = null;
         if(returnType == "")
         {
            if((extIndex = path.lastIndexOf(".")) != -1)
            {
               returnType = path.substring(extIndex);
            }
         }
         this.mType = returnType;
         switch(returnType)
         {
            case ".csv":
            case ".txt":
            case ".xml":
               break;
            default:
               url = new URLRequest(path);
               if(returnType == "ByteArray")
               {
                  urlLoader = new URLLoader();
                  urlLoader.dataFormat = "binary";
                  if(Config.ENABLE_PROFILING)
                  {
                     urlLoader.addEventListener("progress",this.onLoadProgress);
                  }
                  urlLoader.addEventListener("complete",this.onCompleteLoad,false,0,true);
                  urlLoader.addEventListener("ioError",this.onErrorLoad,false,0,true);
                  urlLoader.load(url);
                  this.mLoader = urlLoader;
                  this.mUnloader = urlLoader;
               }
               else
               {
                  loader = new Loader();
                  if(Config.ENABLE_PROFILING)
                  {
                     loader.contentLoaderInfo.addEventListener("progress",this.onLoadProgress);
                  }
                  loader.contentLoaderInfo.addEventListener("complete",this.onCompleteLoad,false,0,true);
                  loader.contentLoaderInfo.addEventListener("ioError",this.onErrorLoad,false,0,true);
                  this.mLoader = loader;
                  this.mUnloader = loader;
                  (loaderContext = new LoaderContext(true)).applicationDomain = new ApplicationDomain();
                  if(Security.sandboxType == "remote")
                  {
                     loaderContext.securityDomain = SecurityDomain.currentDomain;
                  }
                  loader.load(url,loaderContext);
               }
               return;
         }
         this.loadTextFile(path,returnType);
      }
      
      private function loadTextFile(path:String, returnType:String = "") : void
      {
         var url:URLRequest = new URLRequest(path);
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = "text";
         loader.load(url);
         this.mLoader = loader;
         this.mUnloader = loader;
         loader.addEventListener("complete",this.onCompleteTextLoad,false,0,true);
         loader.addEventListener("ioError",this.onErrorLoad,false,0,true);
      }
      
      private function getLoadedSWFAppDomain() : ApplicationDomain
      {
         return this.mLoader == null ? null : (this.mLoader as Loader).contentLoaderInfo.applicationDomain;
      }
      
      public function getSWFClass(className:String) : Class
      {
         var c:Class = null;
         var app:ApplicationDomain = this.getLoadedSWFAppDomain();
         if(app != null && app.hasDefinition(className))
         {
            c = Class(app.getDefinition(className));
            if(Config.DEBUG_MEMORY)
            {
               DCDebug.traceCh("MEMORY","Class " + className + " (" + DCResourceMng.updateMemory(false) + "Ks)");
            }
            return c;
         }
         return null;
      }
      
      public function getDCDisplayObject(animSku:String, format:int = -1) : DCDisplayObject
      {
         var anim:Object = null;
         var dcMc:DCBitmapMovieClip = null;
         var thisClass:Class = null;
         var resourceMng:DCResourceMng = DCInstanceMng.getInstance().getResourceMng();
         var returnValue:DCDisplayObject = null;
         if(format == -1)
         {
            format = this.mFormat;
         }
         switch(format)
         {
            case 0:
               thisClass = this.getSWFClass(animSku);
               if(thisClass != null)
               {
                  returnValue = new DCDisplayObjectSWF(new thisClass());
               }
               break;
            case 2:
               if(resourceMng.isResourceLoaded(mSku))
               {
                  if((anim = DCInstanceMng.getInstance().getResourceMng().getBitmapAnimationFromCatalog(mSku,"")) == null)
                  {
                     anim = DCInstanceMng.getInstance().getResourceMng().generateBitmapFromPng(mSku);
                  }
                  if(anim != null)
                  {
                     (dcMc = new DCBitmapMovieClip()).setAnimation(anim);
                     returnValue = dcMc;
                  }
                  break;
               }
               resourceMng.requestResource(mSku);
               break;
            case 3:
               if(resourceMng.isResourceLoaded(mSku))
               {
                  if((anim = DCInstanceMng.getInstance().getResourceMng().getBitmapAnimationFromCatalog(mSku,animSku)) == null)
                  {
                     anim = DCInstanceMng.getInstance().getResourceMng().generateBitmapFromMovieclip(mSku,animSku);
                  }
                  if(anim != null)
                  {
                     (dcMc = new DCBitmapMovieClip()).setAnimation(anim);
                     dcMc.getDisplayObject().name = animSku;
                     returnValue = dcMc;
                  }
               }
               else
               {
                  resourceMng.requestResource(mSku);
               }
         }
         return returnValue;
      }
      
      override public function getResource(type:String = null, decode:Boolean = false) : *
      {
         var bitmapData:BitmapData = null;
         var sprite:Sprite = null;
         var content:String = null;
         var content2:String = null;
         if(!mIsLoaded)
         {
            return null;
         }
         if(type == null)
         {
            type = this.mType;
         }
         switch(type)
         {
            case ".swf":
            case "MovieClip":
               return mResource as MovieClip;
            case ".jpg":
            case "jpeg":
            case ".gif":
            case ".png":
            case "BitmapData":
               break;
            case "Sprite":
               bitmapData = Bitmap(mResource).bitmapData;
               (sprite = new Sprite()).addChild(new Bitmap(bitmapData));
               sprite.scaleX = 0.5;
               sprite.scaleY = 0.5;
               return sprite;
            case "Bitmap":
               bitmapData = Bitmap(mResource).bitmapData;
               return new Bitmap(bitmapData);
            case ".xml":
               content = String(decode && Config.useRulesEncriptation() ? DCUtils.simpleStringDecrypt(mResource as String) : mResource);
               return new XML(content);
            case ".txt":
            case ".csv":
               return String(decode && Config.useRulesEncriptation() ? DCUtils.simpleStringDecrypt(mResource as String) : mResource);
            case "ByteArray":
               return mResource as ByteArray;
            default:
               return null;
         }
         return Bitmap(mResource).bitmapData;
      }
      
      override public function unload() : void
      {
         super.unload();
         switch(this.mType)
         {
            case ".swf":
               break;
            case "Bitmap":
            case "BitmapData":
            case ".jpg":
            case "jpeg":
            case ".gif":
            case ".png":
               Bitmap(mResource).bitmapData.dispose();
               break;
            case "MovieClip":
            case "Sprite":
         }
         var unloader:Loader = this.mLoader as Loader;
         if(unloader != null && unloader.numChildren > 0)
         {
            unloader.unload();
         }
         this.mLoader = null;
         this.mAttemptsCount = 0;
      }
      
      private function onLoadProgress(event:ProgressEvent) : void
      {
         DCInstanceMng.getInstance().getResourceMng().profilingAddDownloadedAmount(event.bytesTotal);
         event.target.removeEventListener("complete",this.onLoadProgress);
      }
      
      private function onCompleteLoad(event:Event) : void
      {
         var thisArray:ByteArray = null;
         if(Config.ENABLE_PROFILING)
         {
            event.target.removeEventListener("complete",this.onLoadProgress);
         }
         event.target.removeEventListener("complete",this.onCompleteLoad);
         event.target.removeEventListener("ioError",this.onErrorLoad);
         if(this.mType == "ByteArray")
         {
            thisArray = event.target.data as ByteArray;
            setResource(event.target.data);
            this.mUnloader = event.target;
         }
         else
         {
            setResource(event.target.content);
            this.mUnloader = event.target.loader;
         }
         this.mAttemptsCount = 0;
      }
      
      private function onCompleteTextLoad(event:Event) : void
      {
         var l:URLLoader = URLLoader(event.target);
         l.removeEventListener("complete",this.onCompleteTextLoad);
         l.removeEventListener("ioError",this.onErrorLoad);
         setResource(l.data);
         this.mUnloader = l;
      }
      
      private function onErrorLoad(event:IOErrorEvent) : void
      {
         if(true)
         {
            DCDebug.traceCh("TOOLKIT","ERROR: DCResourceDefLoaded:onErrorLoad: " + this.mPath + " loading error: " + event,3);
         }
         this.request();
      }
      
      override public function canBeEnqueued() : Boolean
      {
         return this.mCanBeEnqueued;
      }
   }
}
