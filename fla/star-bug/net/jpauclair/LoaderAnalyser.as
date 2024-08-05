package net.jpauclair
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLStream;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.jpauclair.data.LoaderData;
   
   public class LoaderAnalyser
   {
      
      private static var mInstance:LoaderAnalyser = null;
       
      
      private var mLoaderDict:Dictionary;
      
      private var mDisplayLoaderRef:Dictionary;
      
      private var mLoadersData:Array;
      
      public function LoaderAnalyser()
      {
         super();
         this.mLoadersData = new Array();
         this.mLoaderDict = new Dictionary(true);
         this.mDisplayLoaderRef = new Dictionary(true);
      }
      
      public static function GetInstance() : LoaderAnalyser
      {
         if(mInstance == null)
         {
            mInstance = new LoaderAnalyser();
         }
         return mInstance;
      }
      
      public function Update() : void
      {
         var obj:* = undefined;
         var li:LoaderInfo = null;
         var ld:LoaderData = null;
         for(obj in this.mDisplayLoaderRef)
         {
            if(obj != null)
            {
               li = obj.contentLoaderInfo;
               if(li != null)
               {
                  ld = this.mLoaderDict[li];
                  if(ld == null)
                  {
                  }
               }
            }
         }
      }
      
      public function GetLoadersData() : Array
      {
         return this.mLoadersData;
      }
      
      public function PushLoader(aLoader:*) : void
      {
         var o:LoaderData = null;
         var l:Loader = null;
         var ls:URLStream = null;
         var ll:URLLoader = null;
         if(aLoader == null)
         {
            return;
         }
         if(aLoader is Loader)
         {
            l = aLoader;
            if(l.contentLoaderInfo == null)
            {
               return;
            }
            o = this.mLoaderDict[l.contentLoaderInfo];
            if(o != null)
            {
               return;
            }
            this.mDisplayLoaderRef[aLoader] = true;
            o = new LoaderData();
            if(l.contentLoaderInfo.url != null)
            {
               o.mUrl = l.contentLoaderInfo.url;
            }
            this.mLoadersData.push(o);
            this.mLoaderDict[l.contentLoaderInfo] = o;
            o.mType = LoaderData.DISPLAY_LOADER;
            this.configureListeners(l.contentLoaderInfo);
         }
         else if(aLoader is URLStream)
         {
            o = this.mLoaderDict[aLoader];
            if(o != null)
            {
               return;
            }
            ls = aLoader;
            o = new LoaderData();
            this.mLoaderDict[aLoader] = o;
            this.mLoadersData.push(o);
            o.mType = LoaderData.URL_STREAM;
            this.configureListeners(aLoader);
         }
         else if(aLoader is URLLoader)
         {
            o = this.mLoaderDict[aLoader];
            if(o != null)
            {
               return;
            }
            ll = aLoader;
            o = new LoaderData();
            this.mLoadersData.push(o);
            this.mLoaderDict[aLoader] = o;
            o.mType = LoaderData.URL_LOADER;
            this.configureListeners(aLoader);
         }
      }
      
      private function configureListeners(dispatcher:IEventDispatcher) : void
      {
         var useCapture:Boolean = false;
         var useWeak:Boolean = true;
         var prio:int = int.MAX_VALUE;
         dispatcher.addEventListener(Event.COMPLETE,this.completeHandler,useCapture,prio,useWeak);
         dispatcher.addEventListener(Event.OPEN,this.openHandler,useCapture,prio,useWeak);
         dispatcher.addEventListener(ProgressEvent.PROGRESS,this.progressHandler,useCapture,prio,useWeak);
         dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.httpStatusHandler,useCapture,prio,useWeak);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler,useCapture,prio,useWeak);
         if(dispatcher is Loader)
         {
            dispatcher.addEventListener(Event.INIT,this.initHandler,useCapture,prio,useWeak);
            dispatcher.addEventListener(Event.UNLOAD,this.unLoadHandler,useCapture,prio,useWeak);
         }
         else if(dispatcher is URLLoader)
         {
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,useCapture,prio,useWeak);
         }
         else if(dispatcher is URLStream)
         {
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler,useCapture,prio,useWeak);
         }
      }
      
      private function completeHandler(event:Event) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            if(ld.mIsFinished)
            {
               ld = this.PreventReUse(ld,event.target);
            }
            ld.mProgress = 1;
            ld.mProgressText = LoaderData.LOADER_STATUS_COMPLETED;
            ld.mIsFinished = true;
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
            else if(event.target is URLStream)
            {
               ld.mUrl = "No Url: URLStream";
            }
            if(event.target is URLLoader)
            {
               ld.mUrl = "No Url: URLLoader";
            }
         }
      }
      
      private function PreventReUse(ld:LoaderData, aLoader:Object) : LoaderData
      {
         var ld2:LoaderData = new LoaderData();
         ld2.mFirstEvent = getTimer();
         ld2.mType = ld.mType;
         this.mLoadersData.push(ld2);
         this.mLoaderDict[aLoader] = ld2;
         return ld2;
      }
      
      private function httpStatusHandler(event:HTTPStatusEvent) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mHTTPStatusText = event.status.toString();
            ld.mStatus = event;
            if(ld.mUrl == null)
            {
            }
         }
      }
      
      private function initHandler(event:Event) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mProgressText = "Init";
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         var err:Array = null;
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mIOError = event;
            ld.mProgressText = "IO Error";
            if(ld.mUrl == null)
            {
               err = event.text.split("URL: ");
               if(err.length > 1)
               {
                  ld.mUrl = err[1];
               }
            }
         }
      }
      
      private function openHandler(event:Event) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         var tmpProgress:Number = NaN;
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            if(event.bytesTotal > 0)
            {
               tmpProgress = int(event.bytesLoaded / event.bytesTotal * 10000) / 100;
               if(ld.mProgress > event.bytesLoaded / event.bytesTotal)
               {
                  ld = this.PreventReUse(ld,event.target);
               }
               ld.mLoadedBytes = int(event.bytesLoaded);
               ld.mLoadedBytesText = String(int(event.bytesLoaded));
               ld.mProgress = event.bytesLoaded / event.bytesTotal;
               if(tmpProgress == 100)
               {
                  ld.mProgressText = LoaderData.LOADER_STATUS_COMPLETED;
               }
               else
               {
                  ld.mProgressText = tmpProgress.toString() + " %";
               }
            }
            else
            {
               if(ld.mProgress > event.bytesLoaded)
               {
                  ld = this.PreventReUse(ld,event.target);
               }
               ld.mLoadedBytes = int(event.bytesLoaded);
               ld.mLoadedBytesText = String(event.bytesLoaded);
               ld.mProgress = event.bytesLoaded;
               ld.mProgressText = int(ld.mProgress).toString();
            }
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
      }
      
      private function unLoadHandler(event:Event) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mProgressText = "Unload";
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mProgressText = "mClick";
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
         var loader:Loader = Loader(event.target);
         loader.unload();
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         var ld:LoaderData = this.mLoaderDict[event.target];
         if(ld != null)
         {
            if(ld.mFirstEvent == -1)
            {
               ld.mFirstEvent = getTimer();
            }
            ld.mSecurityError = event;
            ld.mProgressText = "Security Error";
            if(ld.mUrl == null && ld.mType == LoaderData.DISPLAY_LOADER)
            {
               ld.mUrl = event.target.url;
            }
         }
      }
   }
}
