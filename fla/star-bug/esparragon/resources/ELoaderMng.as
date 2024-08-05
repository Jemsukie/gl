package esparragon.resources
{
   import esparragon.core.Esparragon;
   import esparragon.utils.EUtils;
   import esparragon.utils.debug.EError;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class ELoaderMng
   {
      
      private static const CHANNEL_LOADER:String = "E_LOADER";
      
      private static const CHANNEL_LOADER_ERROR:String = "E_LOADER_ERROR";
      
      public static const TYPE_ATLAS:String = "ATLAS";
      
      public static const TYPE_XML:String = "XML";
      
      public static const TYPE_TXT:String = "TXT";
      
      public static const TYPE_PNG:String = "PNG";
      
      public static const TYPE_JPG:String = "JPG";
      
      public static const TYPE_SWF:String = "SWF";
      
      public static const TYPE_BYTE_ARRAY:String = "BYTE_ARRAY";
      
      public static const LUT_TABLE:String = "lutTable";
      
      public static const RESOURCES_QUEUE:String = "resources_queue.xml";
      
      public static const RESOURCES_QUEUE_WITH_BRACKETS:String = EUtils.getNameInBrackets("resources_queue.xml");
      
      public static const GROUP_DEFAULT_ID:String = "default";
      
      public static const LOAD_PRIORITY_MAX:int = 0;
      
      public static const LOAD_PRIORITY_HIGH:int = 1;
      
      public static const LOAD_PRIORITY_LOW:int = 2;
      
      public static const LOAD_PRIORITY_COUNT:int = 3;
      
      public static const ERROR_CHANNEL:String = "resources_queue.xml";
       
      
      private var mIsReady:Boolean;
      
      private var mOnReadyCallback:Function;
      
      private var mFilesBaseUrl:String;
      
      private var mTimeAccumulated:Number;
      
      private var mGroups:Dictionary;
      
      private var mAssets:Dictionary;
      
      private const REQUEST_URL_STATE_NONE:int = 0;
      
      private const REQUEST_URL_STATE_REQUESTED:int = 1;
      
      private const REQUEST_URL_STATE_LOADED:int = 2;
      
      private const REQUEST_URL_STATE_ERROR:int = 3;
      
      private var mRequestsToRequestByPriority:Vector.<Vector.<EAssetRequest>>;
      
      private var mRequestsRequestedAmountByPriority:Vector.<int>;
      
      private var mRequestsCompletedAmountByPriority:Vector.<int>;
      
      private var mRequests:Dictionary;
      
      private var mLoadersToUrlRequests:Dictionary;
      
      private var mUrlsToLoaders:Dictionary;
      
      private var mRequestsData:Dictionary;
      
      private var mRequestsDebug:Dictionary;
      
      private var mRequestsTimer:Dictionary;
      
      private var mRequestsDebugUrlsInRequestedOrder:Vector.<String>;
      
      private var mRequestsDataCropped:Dictionary;
      
      private var mRequestsUrlState:Dictionary;
      
      private var mRequestsUrlRequests:Dictionary;
      
      private var mRequestsUrlUsages:Dictionary;
      
      private var mRequestsCurrentlyBeingProcessed:int;
      
      private var mRequestsMaxAmountAllowedSimultaneously:int;
      
      private var mLutIsEnabled:Boolean = false;
      
      private var mLutUrl:String;
      
      private var mLutTable:Dictionary;
      
      private var mResourcesQueueFileUrl:String;
      
      private var mResourcesQueueIsRequested:Boolean = false;
      
      private var mResourcesQueueAssets:Dictionary;
      
      private var mErrorLogsByGroupId:Dictionary;
      
      public function ELoaderMng(filesBaseUrl:String, lutUrl:String, onReadyCallback:Function = null, maxRequestsAllowedSimultaneously:int = 2147483647)
      {
         super();
         this.mTimeAccumulated = 0;
         this.mIsReady = false;
         this.mFilesBaseUrl = filesBaseUrl;
         this.mOnReadyCallback = onReadyCallback;
         this.requestsLoad(maxRequestsAllowedSimultaneously);
         this.resourcesQueueLoad();
         Esparragon.traceMsg("lutUrl = " + lutUrl + " filesBaseUrl = " + filesBaseUrl,"E_LOADER");
         if(lutUrl != null)
         {
            this.lutLoad(lutUrl);
         }
         else
         {
            this.resourcesQueueRequestFile();
         }
      }
      
      public function destroy() : void
      {
         this.mIsReady = false;
         this.mFilesBaseUrl = null;
         this.mOnReadyCallback = null;
         this.groupsDestroy();
         this.assetsDestroy();
         this.requestsDestroy();
         this.lutDestroy();
         this.errorDestroy();
         this.mTimeAccumulated = 0;
      }
      
      public function logicUpdate(dt:int) : void
      {
         this.mTimeAccumulated += dt;
         if(this.mIsReady)
         {
            this.requestsUpdate();
         }
      }
      
      public function isReady() : Boolean
      {
         return this.mIsReady;
      }
      
      public function getAssetCheckingElseGroups(assetId:String, groupId:String) : EAsset
      {
         var group:EGroup = null;
         var returnValue:EAsset = this.assetsGetAsset(assetId,groupId);
         if(returnValue == null)
         {
            if((group = this.groupsGetGroup(groupId)) != null && group.hasElseGroup())
            {
               returnValue = this.getAssetCheckingElseGroups(assetId,group.getElseGroupId());
            }
         }
         return returnValue;
      }
      
      public function loadAsset(assetId:String, groupId:String, priority:int = 2, completeFunc:Function = null, errorFunc:Function = null, atlasId:String = null) : void
      {
         if(EGroup.atlasIsIdValid(atlasId))
         {
            this.loadAssetFromAtlas(assetId,groupId,atlasId,priority,completeFunc,errorFunc);
         }
         else
         {
            this.loadSimpleAsset(assetId,groupId,priority,completeFunc,errorFunc);
         }
      }
      
      private function loadSimpleAsset(assetId:String, groupId:String, priority:int = 2, completeFunc:Function = null, errorFunc:Function = null, checkAtlas:Boolean = false) : void
      {
         var asset:EAsset = null;
         var doRequest:* = true;
         if(this.mIsReady)
         {
            if((asset = this.assetsGetAsset(assetId,groupId)) == null)
            {
               if((asset = this.getAssetCheckingElseGroups(assetId,groupId)) == null)
               {
                  this.errorLogAssetNotDefinedInGroup(groupId,assetId);
               }
               else
               {
                  asset = this.assetsAddAssetFromAsset(assetId,groupId,asset);
               }
            }
            if(doRequest = asset != null)
            {
               if(asset.isEmbedded())
               {
                  this.mRequestsData[asset.getUrl()] = EmbeddedAssets[asset.getEmbeddedSku()];
                  this.requestsUrlSetState(asset.getUrl(),2);
                  if(completeFunc != null)
                  {
                     completeFunc(assetId,groupId);
                  }
                  doRequest = false;
               }
            }
         }
         if(doRequest)
         {
            this.requestsAddRequest(assetId,groupId,completeFunc,errorFunc,priority);
         }
      }
      
      private function loadAssetFromAtlas(assetId:String, groupId:String, atlasId:String, priority:int = 2, completeFunc:Function = null, errorFunc:Function = null) : void
      {
         var group:EGroup = null;
         if(atlasId != null)
         {
            if((group = this.groupsGetGroup(groupId)) != null)
            {
               group.atlasAddAssetIdToAtlas(assetId,atlasId,priority,completeFunc,errorFunc);
            }
         }
      }
      
      public function unloadAsset(assetId:String, groupId:String) : void
      {
         var url:String = null;
         var r:EAssetRequest = null;
         var j:int = 0;
         var i:int = 0;
         var requestsByPriority:Vector.<EAssetRequest> = null;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            if(this.isAssetLoaded(assetId,groupId))
            {
               url = asset.getUrl();
               this.requestsUrlRemoveUsage(url,asset);
               if(this.requestsUrlGetUsage(url) == 0)
               {
                  delete this.mRequestsData[url];
                  this.mRequestsUrlState[url] = 0;
               }
            }
         }
         else
         {
            if(this.mRequestsToRequestByPriority != null)
            {
               for(j = 0; j < 3; )
               {
                  for(i = (requestsByPriority = this.mRequestsToRequestByPriority[j]).length - 1; i > -1; )
                  {
                     r = requestsByPriority[i];
                     if(r.getAssetId() == assetId && r.getGroupId() == groupId)
                     {
                        requestsByPriority.splice(i,1);
                        break;
                     }
                     i--;
                  }
                  j++;
               }
            }
            r = this.requestsGetRequest(assetId,groupId);
            if(r != null)
            {
               this.requestsRemoveRequest(assetId,groupId);
               delete this.mRequestsData[groupId][assetId];
            }
         }
      }
      
      public function isAssetPriorityAllowedToLoad(priority:int) : Boolean
      {
         var i:int = 0;
         var returnValue:Boolean = true;
         i = 0;
         while(returnValue && i < priority - 1)
         {
            if(this.mRequestsRequestedAmountByPriority[i] > this.mRequestsCompletedAmountByPriority[i] || this.mRequestsToRequestByPriority[i].length > 0)
            {
               returnValue = false;
            }
            i++;
         }
         return returnValue;
      }
      
      public function isAssetLoaded(assetId:String, groupId:String) : Boolean
      {
         var returnValue:* = false;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            returnValue = this.requestsUrlGetState(asset.getUrl()) == 2;
         }
         return returnValue;
      }
      
      public function isAssetError(assetId:String, groupId:String) : Boolean
      {
         var returnValue:* = false;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            returnValue = this.requestsUrlGetState(asset.getUrl()) == 3;
         }
         return returnValue;
      }
      
      public function getAssetData(assetId:String, groupId:String) : Object
      {
         var url:String = null;
         var rawBitmap:Bitmap = null;
         var bitmap:Bitmap = null;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null && asset.getType() == "ATLAS")
         {
            assetId = EGroup.atlasGetPngId(assetId);
            asset = this.assetsGetAsset(assetId,groupId);
         }
         var returnValue:Object = null;
         if(this.isAssetLoaded(assetId,groupId))
         {
            url = asset.getUrl();
            returnValue = this.mRequestsData[url];
            if(asset.needsToBeCropped())
            {
               if(this.mRequestsDataCropped == null)
               {
                  this.mRequestsDataCropped = new Dictionary(true);
               }
               if(this.mRequestsDataCropped[url] == null)
               {
                  rawBitmap = returnValue as Bitmap;
                  bitmap = new Bitmap(EUtils.cropBitmapData(rawBitmap.bitmapData));
                  this.mRequestsDataCropped[url] = bitmap;
               }
               returnValue = this.mRequestsDataCropped[url];
            }
         }
         return returnValue;
      }
      
      public function getAssetXML(assetId:String, groupId:String) : XML
      {
         var returnValue:XML = null;
         var data:Object;
         if((data = this.getAssetData(assetId,groupId)) != null)
         {
            returnValue = new XML(data);
         }
         return returnValue;
      }
      
      public function getAssetString(assetId:String, groupId:String) : String
      {
         var returnValue:String = null;
         var data:Object;
         if((data = this.getAssetData(assetId,groupId)) != null)
         {
            returnValue = data as String;
         }
         return returnValue;
      }
      
      public function getAssetByteArray(assetId:String, groupId:String) : ByteArray
      {
         var returnValue:ByteArray = null;
         var data:Object;
         if((data = this.getAssetData(assetId,groupId)) != null)
         {
            returnValue = data as ByteArray;
         }
         return returnValue;
      }
      
      public function getAssetSWF(assetId:String, groupId:String, className:String) : Class
      {
         var app:ApplicationDomain = null;
         var returnValue:Class = null;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            if(asset.isEmbedded())
            {
               returnValue = this.getAssetData(assetId,groupId) as Class;
            }
            else if((app = this.getLoadedSWFAppDomain(assetId,groupId)) != null && app.hasDefinition(className))
            {
               returnValue = Class(app.getDefinition(className));
            }
         }
         return returnValue;
      }
      
      public function getAssetBitmap(assetId:String, groupId:String) : Bitmap
      {
         var returnValue:Bitmap = null;
         var data:Object;
         if((data = this.getAssetData(assetId,groupId)) != null)
         {
            returnValue = data as Bitmap;
         }
         return returnValue;
      }
      
      public function getAssetBitmapData(assetId:String, groupId:String) : BitmapData
      {
         var returnValue:BitmapData = null;
         var data:Object;
         if((data = this.getAssetData(assetId,groupId)) != null)
         {
            returnValue = (data as Bitmap).bitmapData;
         }
         return returnValue;
      }
      
      private function getLoadedSWFAppDomain(assetId:String, groupId:String) : ApplicationDomain
      {
         var loader:Loader = null;
         var returnValue:ApplicationDomain = null;
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            if((loader = this.requestsGetLoaderByUrl(asset.getUrl())) != null)
            {
               returnValue = loader.contentLoaderInfo.applicationDomain;
            }
         }
         return returnValue;
      }
      
      private function groupsDestroy() : void
      {
         var k:* = null;
         var group:EGroup = null;
         for(k in this.mGroups)
         {
            group = this.mGroups[k];
            group.destroy();
            delete this.mGroups[k];
         }
         this.mGroups = null;
      }
      
      public function groupsGetGroup(groupId:String) : EGroup
      {
         return this.mGroups != null ? this.mGroups[groupId] : null;
      }
      
      private function groupsAddGroup(xml:XML) : void
      {
         var assetXml:XML = null;
         var asset:EAsset = null;
         var assetId:String = null;
         var assetSrc:String = null;
         if(this.mGroups == null)
         {
            this.mGroups = new Dictionary();
         }
         var group:EGroup;
         (group = new EGroup()).fromXml(xml);
         var groupId:String = group.getId();
         if(this.mGroups[groupId] == null)
         {
            this.mGroups[groupId] = group;
            for each(assetXml in EUtils.xmlGetChildrenList(xml,"asset"))
            {
               assetId = EUtils.xmlReadString(assetXml,"id");
               if(this.mResourcesQueueAssets[assetId] != null)
               {
                  this.errorLogDuplicatedAssetInGroup(groupId,assetId);
               }
               else
               {
                  assetSrc = EUtils.xmlReadString(assetXml,"src");
                  if((asset = this.assetsAddAssetFromXml(assetId,groupId,assetXml)).getType() == "ATLAS")
                  {
                     asset.setUrl(assetSrc);
                  }
                  else
                  {
                     asset.setUrl(this.getFileURL(assetSrc,this.mLutIsEnabled));
                  }
               }
            }
         }
         else
         {
            this.errorLogDuplicatedGroup(groupId);
         }
      }
      
      private function assetsDestroy() : void
      {
         var j:* = null;
         var k:* = null;
         var d:Dictionary = null;
         var groupId:String = null;
         var asset:EAsset = null;
         if(this.mAssets != null)
         {
            for(j in this.mAssets)
            {
               groupId = j as String;
               d = this.mAssets[groupId];
               for(k in d)
               {
                  if((asset = d[k]) != null)
                  {
                     asset.destroy();
                  }
                  delete d[k];
               }
               delete this.mAssets[groupId];
            }
            this.mAssets = null;
         }
      }
      
      private function assetsAddAsset(asset:EAsset) : EAsset
      {
         var returnValue:* = null;
         if(this.mAssets == null)
         {
            this.mAssets = new Dictionary();
         }
         var assetId:String = asset.getId();
         var groupId:String = asset.getGroupId();
         if(this.mAssets[groupId] == null)
         {
            this.mAssets[groupId] = new Dictionary();
         }
         if(this.mAssets[groupId][assetId] == null)
         {
            this.mAssets[groupId][assetId] = asset;
            returnValue = asset;
         }
         else
         {
            this.errorLogDuplicatedAssetInGroup(groupId,assetId);
         }
         return returnValue;
      }
      
      private function assetsAddAssetFromAsset(assetId:String, groupId:String, asset:EAsset) : EAsset
      {
         var returnValue:EAsset;
         (returnValue = new EAsset(assetId,groupId)).clone(asset);
         returnValue.setGroupId(groupId);
         return this.assetsAddAsset(returnValue);
      }
      
      public function assetsAddAssetFromXml(assetId:String, groupId:String, xml:XML = null) : EAsset
      {
         var returnValue:EAsset = new EAsset(assetId,groupId);
         if(xml != null)
         {
            returnValue.fromXml(xml,groupId,this);
         }
         returnValue.setGroupId(groupId);
         return this.assetsAddAsset(returnValue);
      }
      
      public function assetsGetAsset(assetId:String, groupId:String) : EAsset
      {
         return this.mAssets != null && this.mAssets[groupId] != null ? this.mAssets[groupId][assetId] : null;
      }
      
      public function assetsGetAssetThroughGroups(assetId:String, groupId:String) : EAsset
      {
         var asset:EAsset = this.assetsGetAsset(assetId,groupId);
         if(asset == null)
         {
            asset = this.getAssetCheckingElseGroups(assetId,groupId);
            if(asset == null)
            {
               this.errorLogAssetNotDefinedInGroup(groupId,assetId);
            }
            else
            {
               asset = this.assetsAddAssetFromAsset(assetId,groupId,asset);
            }
         }
         return asset;
      }
      
      public function assetsGetAssets() : Dictionary
      {
         return this.mAssets;
      }
      
      private function requestsLoad(maxRequestsAllowedSimultaneously:int) : void
      {
         var i:int = 0;
         this.mRequestsCurrentlyBeingProcessed = 0;
         this.mRequestsMaxAmountAllowedSimultaneously = maxRequestsAllowedSimultaneously;
         this.mRequestsToRequestByPriority = new Vector.<Vector.<EAssetRequest>>(3);
         this.mRequestsRequestedAmountByPriority = new Vector.<int>(3);
         this.mRequestsCompletedAmountByPriority = new Vector.<int>(3);
         for(i = 0; i < 3; )
         {
            this.mRequestsToRequestByPriority[i] = new Vector.<EAssetRequest>(0);
            this.mRequestsRequestedAmountByPriority[i] = 0;
            this.mRequestsCompletedAmountByPriority[i] = 0;
            i++;
         }
      }
      
      private function requestsDestroy() : void
      {
         var j:* = null;
         var k:* = null;
         var d:Dictionary = null;
         var groupId:String = null;
         var r:EAssetRequest = null;
         var urlRequest:EUrlRequest = null;
         if(this.mRequests != null)
         {
            for(j in this.mRequests)
            {
               groupId = j as String;
               d = this.mRequests[k];
               for(k in d)
               {
                  this.requestsRemoveRequest(k as String,groupId);
               }
               delete this.mRequests[j];
            }
            this.mRequests = null;
         }
         if(this.mRequestsData != null)
         {
            for(j in this.mRequestsData)
            {
               groupId = j as String;
               d = this.mRequestsData[k];
               for(k in d)
               {
                  delete this.mRequestsData[groupId][k];
               }
               delete this.mRequestsData[j];
            }
            this.mRequestsData = null;
         }
         if(this.mRequestsDebug != null)
         {
            for(k in this.mRequestsDebug)
            {
               delete this.mRequestsDebug[k];
            }
            this.mRequestsDebug = null;
         }
         if(this.mRequestsTimer != null)
         {
            for(k in this.mRequestsTimer)
            {
               delete this.mRequestsTimer[k];
            }
            this.mRequestsTimer = null;
         }
         if(this.mRequestsDebugUrlsInRequestedOrder != null)
         {
            for(k in this.mRequestsDebugUrlsInRequestedOrder)
            {
               delete this.mRequestsDebugUrlsInRequestedOrder[k];
            }
            this.mRequestsDebugUrlsInRequestedOrder = null;
         }
         if(this.mRequestsDataCropped != null)
         {
            for(j in this.mRequestsDataCropped)
            {
               groupId = j as String;
               d = this.mRequestsDataCropped[k];
               for(k in d)
               {
                  delete this.mRequestsDataCropped[groupId][k];
               }
               delete this.mRequestsDataCropped[j];
            }
            this.mRequestsDataCropped = null;
         }
         this.mRequestsToRequestByPriority = null;
         this.mRequestsRequestedAmountByPriority = null;
         this.mRequestsCompletedAmountByPriority = null;
         if(this.mLoadersToUrlRequests != null)
         {
            for(k in this.mLoadersToUrlRequests)
            {
               delete this.mLoadersToUrlRequests[k];
            }
            this.mLoadersToUrlRequests = null;
         }
         if(this.mUrlsToLoaders != null)
         {
            for(k in this.mUrlsToLoaders)
            {
               delete this.mUrlsToLoaders[k];
            }
            this.mUrlsToLoaders = null;
         }
         if(this.mRequestsUrlState != null)
         {
            for(k in this.mRequestsUrlState)
            {
               delete this.mRequestsUrlState[k];
            }
            this.mRequestsUrlState = null;
         }
         if(this.mRequestsUrlRequests != null)
         {
            for(k in this.mRequestsUrlRequests)
            {
               urlRequest = this.mRequestsUrlRequests[k];
               urlRequest.destroy();
               delete this.mRequestsUrlRequests[k];
            }
            this.mRequestsUrlRequests = null;
         }
         if(this.mRequestsUrlUsages != null)
         {
            for(j in this.mRequestsUrlUsages)
            {
               for(k in this.mRequestsUrlUsages[j])
               {
                  delete this.mRequestsUrlUsages[j][k];
               }
               delete this.mRequestsUrlUsages[j];
            }
            this.mRequestsUrlUsages = null;
         }
         this.mRequestsCurrentlyBeingProcessed = 0;
      }
      
      private function requestsUrlGetState(url:String) : int
      {
         return this.mRequestsUrlState == null || this.mRequestsUrlState[url] == null ? 0 : int(this.mRequestsUrlState[url]);
      }
      
      private function requestsUrlSetState(url:String, state:int) : void
      {
         var eUrlRequest:EUrlRequest = null;
         if(this.mRequestsUrlState == null)
         {
            this.mRequestsUrlState = new Dictionary();
         }
         this.mRequestsUrlState[url] = state;
         if(state == 2 || state == 3)
         {
            eUrlRequest = this.requestsUrlGetRequest(url);
            if(eUrlRequest != null)
            {
               this.mRequestsCompletedAmountByPriority[eUrlRequest.getPriority()]++;
            }
         }
      }
      
      private function requestsGetLoaderByUrl(url:String) : Loader
      {
         var returnValue:Loader = null;
         if(this.mUrlsToLoaders != null && this.mUrlsToLoaders[url] != null)
         {
            returnValue = this.mUrlsToLoaders[url] as Loader;
         }
         return returnValue;
      }
      
      private function requestsUrlGetRequest(url:String) : EUrlRequest
      {
         return this.mRequestsUrlRequests != null ? this.mRequestsUrlRequests[url] : null;
      }
      
      private function requestsUrlGetType(urlRequest:EUrlRequest) : String
      {
         var request:EAssetRequest = null;
         var asset:EAsset = null;
         var returnValue:String = null;
         var requests:Vector.<EAssetRequest>;
         if((requests = urlRequest.getRequests()) != null)
         {
            request = requests[0];
            if(request != null)
            {
               if((asset = this.assetsGetAsset(request.getAssetId(),request.getGroupId())) != null)
               {
                  returnValue = asset.getType();
               }
            }
         }
         return returnValue;
      }
      
      private function requestsUrlAddRequest(url:String, request:EAssetRequest) : EUrlRequest
      {
         var urlRequest:EUrlRequest = this.requestsUrlGetRequest(url);
         if(urlRequest == null)
         {
            if(this.mRequestsUrlRequests == null)
            {
               this.mRequestsUrlRequests = new Dictionary();
            }
            urlRequest = new EUrlRequest(url,request);
            this.mRequestsUrlRequests[url] = urlRequest;
         }
         else
         {
            urlRequest.addRequest(request);
         }
         return urlRequest;
      }
      
      private function requestsUrlRemoveRequest(url:String) : void
      {
         var urlRequest:EUrlRequest = null;
         if(this.mRequestsUrlRequests != null)
         {
            if(this.mRequestsUrlRequests[url] != null)
            {
               urlRequest = this.mRequestsUrlRequests[url];
               this.requestsRemoveLoader(urlRequest);
               urlRequest.destroy();
               delete this.mRequestsUrlRequests[url];
            }
         }
      }
      
      private function requestsUrlDoRequest(url:String, request:EAssetRequest, addRandom:Boolean = false) : void
      {
         var eUrlRequest:EUrlRequest = null;
         var urlRequest:URLRequest = null;
         var type:String = null;
         var urlLoader:URLLoader = null;
         var loaderContext:LoaderContext = null;
         var loader:Loader = null;
         var assetId:String = request.getAssetId();
         var groupId:String = request.getGroupId();
         var asset:EAsset = this.assetsGetAsset(assetId,groupId);
         switch(this.requestsUrlGetState(url))
         {
            case 0:
               if(Config.DEBUG_MODE)
               {
                  Esparragon.traceMsg("************* [" + request.getPriority() + "] Request File in " + url,"E_LOADER");
               }
               this.mRequestsCurrentlyBeingProcessed++;
               if(this.mLoadersToUrlRequests == null)
               {
                  this.mRequestsData = new Dictionary();
                  this.mLoadersToUrlRequests = new Dictionary();
               }
               this.requestsUrlSetState(url,1);
               this.mRequestsData[url] = null;
               this.requestsAddDebug(url,"Requested");
               eUrlRequest = this.requestsUrlAddRequest(url,request);
               this.mRequestsRequestedAmountByPriority[eUrlRequest.getPriority()]++;
               if(addRandom)
               {
                  url += "?t=" + new Date().getUTCMilliseconds();
               }
               urlRequest = new URLRequest(url);
               switch(type = asset.getType())
               {
                  case "BYTE_ARRAY":
                  case "TXT":
                  case "XML":
                     urlLoader = new URLLoader();
                     if(type == "BYTE_ARRAY")
                     {
                        urlLoader.dataFormat = "binary";
                     }
                     else
                     {
                        urlLoader.dataFormat = "text";
                     }
                     this.requestsAddLoader(eUrlRequest,urlLoader);
                     urlLoader.load(urlRequest);
                     break;
                  case "SWF":
                  case "PNG":
                  case "JPG":
                     loaderContext = null;
                     loader = new Loader();
                     (loaderContext = new LoaderContext(true)).applicationDomain = new ApplicationDomain();
                     if(Security.sandboxType == "remote")
                     {
                        loaderContext.securityDomain = SecurityDomain.currentDomain;
                     }
                     this.requestsAddLoader(eUrlRequest,loader);
                     loader.load(urlRequest,loaderContext);
               }
               break;
            case 1:
               this.requestsUrlAddRequest(url,request);
               break;
            case 2:
               this.requestsUrlAddUsageFromRequest(url,request);
               request.success();
               break;
            case 3:
               request.error();
         }
      }
      
      private function requestsUrlAddUsageFromRequest(url:String, request:EAssetRequest) : void
      {
         var asset:EAsset = this.assetsGetAsset(request.getAssetId(),request.getGroupId());
         if(asset != null)
         {
            this.requestsUrlAddUsage(url,asset);
         }
      }
      
      private function requestsUrlAddUsage(url:String, asset:EAsset) : void
      {
         if(this.mRequestsUrlUsages == null)
         {
            this.mRequestsUrlUsages = new Dictionary();
         }
         if(this.mRequestsUrlUsages[url] == null)
         {
            this.mRequestsUrlUsages[url] = new Dictionary();
         }
         if(this.mRequestsUrlUsages[url][asset] == null)
         {
            this.mRequestsUrlUsages[url][asset] = 0;
         }
         this.mRequestsUrlUsages[url][asset]++;
      }
      
      private function requestsUrlRemoveUsage(url:String, asset:EAsset) : void
      {
         var value:int = 0;
         var errorMessage:* = null;
         if(this.mRequestsUrlUsages != null && this.mRequestsUrlUsages[url] != null && this.mRequestsUrlUsages[url][asset] != null)
         {
            if((value = int(this.mRequestsUrlUsages[url][asset])) > 0)
            {
               value--;
               this.mRequestsUrlUsages[url][asset] = value;
            }
            else
            {
               errorMessage = "Class [ELoaderMng].requestsUrlRemoveUsage() negative usage for url <" + url + " and assetId <" + asset.getId() + " groupId <" + asset.getGroupId() + ".>";
            }
            if(value == 0)
            {
               delete this.mRequestsUrlUsages[url][asset];
            }
            if(this.requestsUrlGetUsage(url) == 0)
            {
               delete this.mRequestsUrlUsages[url];
            }
         }
         else
         {
            errorMessage = "Class [ELoaderMng].requestsUrlRemoveUsage() not defined usage for url <" + url + " and assetId <" + asset.getId() + " groupId <" + asset.getGroupId() + ".>";
         }
         if(errorMessage != null)
         {
            Esparragon.traceMsg(errorMessage,"E_LOADER_ERROR");
         }
      }
      
      private function requestsUrlGetUsage(url:String) : int
      {
         var k:* = null;
         var returnValue:int = 0;
         if(this.mRequestsUrlUsages != null && this.mRequestsUrlUsages[url] != null)
         {
            for(k in this.mRequestsUrlUsages[url])
            {
               returnValue = int(this.mRequestsUrlUsages[url][k]);
            }
         }
         return returnValue;
      }
      
      private function requestsGetRequest(assetId:String, groupId:String) : EAssetRequest
      {
         return this.mRequests != null && this.mRequests[groupId] != null ? this.mRequests[groupId][assetId] : null;
      }
      
      private function requestsAddRequest(assetId:String, groupId:String, completeFunc:Function, errorFunc:Function, priority:int) : void
      {
         var r:EAssetRequest;
         if((r = this.requestsGetRequest(assetId,groupId)) == null)
         {
            this.requestsAddPending(assetId,groupId,completeFunc,errorFunc,priority);
         }
         else
         {
            r.addRequest(completeFunc,errorFunc);
         }
      }
      
      private function requestsAddPending(assetId:String, groupId:String, completeFunc:Function, errorFunc:Function, priority:int) : void
      {
         if(this.mRequests == null)
         {
            this.mRequests = new Dictionary();
         }
         if(this.mRequests[groupId] == null)
         {
            this.mRequests[groupId] = new Dictionary();
         }
         var request:EAssetRequest = new EAssetRequest(assetId,groupId,priority,completeFunc,errorFunc);
         this.mRequests[groupId][assetId] = request;
         if(priority == 0)
         {
            this.requestDoRequest(request);
         }
         else
         {
            this.mRequestsToRequestByPriority[priority].push(request);
         }
      }
      
      private function requestsRemoveRequest(assetId:String, groupId:String) : void
      {
         var r:EAssetRequest = this.requestsGetRequest(assetId,groupId);
         if(r != null)
         {
            delete this.mRequests[groupId][assetId];
         }
         else
         {
            this.errorLogRequestNotFound(groupId,assetId);
         }
      }
      
      private function requestsUpdate() : void
      {
         var i:int = 0;
         var requestsThisPriority:Vector.<EAssetRequest> = null;
         var request:EAssetRequest = null;
         var priority:* = -1;
         i = 0;
         while(i < 3 && priority == -1)
         {
            if(this.mRequestsRequestedAmountByPriority[i] > this.mRequestsCompletedAmountByPriority[i] || this.mRequestsToRequestByPriority[i].length > 0)
            {
               priority = i;
            }
            i++;
         }
         if(priority > -1)
         {
            requestsThisPriority = this.mRequestsToRequestByPriority[priority];
            while(requestsThisPriority.length > 0 && this.mRequestsCurrentlyBeingProcessed < this.mRequestsMaxAmountAllowedSimultaneously)
            {
               request = requestsThisPriority.shift();
               this.requestDoRequest(request);
            }
         }
      }
      
      private function requestDoRequest(request:EAssetRequest) : void
      {
         var msg:String = null;
         var url:String = null;
         request.doRequest();
         var assetId:String = request.getAssetId();
         var groupId:String = request.getGroupId();
         var asset:EAsset;
         if((asset = this.assetsGetAsset(assetId,groupId)) != null)
         {
            url = asset.getUrl();
            this.requestsUrlDoRequest(url,request,asset.getIsGenerated());
            this.requestsRemoveRequest(assetId,groupId);
         }
         else
         {
            this.errorLogAssetNotDefinedInGroup(groupId,assetId);
         }
      }
      
      private function requestsAddLoader(request:EUrlRequest, loader:Object) : void
      {
         var urlLoader:URLLoader = null;
         var thisLoader:Loader = null;
         if(loader is URLLoader)
         {
            urlLoader = loader as URLLoader;
            urlLoader.addEventListener("complete",this.requestsOnSuccess,false,0,true);
            urlLoader.addEventListener("ioError",this.requestsOnError,false,0,true);
         }
         else
         {
            thisLoader = loader as Loader;
            loader.contentLoaderInfo.addEventListener("complete",this.requestsOnSuccess);
            loader.contentLoaderInfo.addEventListener("ioError",this.requestsOnError);
         }
         this.mLoadersToUrlRequests[loader] = request;
         request.setLoader(loader);
      }
      
      private function requestsRemoveLoader(request:EUrlRequest) : void
      {
         var urlLoader:URLLoader = null;
         var thisLoader:Loader = null;
         var loader:Object = request.getLoader();
         if(loader != null)
         {
            if(loader is URLLoader)
            {
               urlLoader = loader as URLLoader;
               urlLoader.removeEventListener("complete",this.requestsOnSuccess);
               urlLoader.removeEventListener("ioError",this.requestsOnError);
            }
            else
            {
               (thisLoader = loader as Loader).contentLoaderInfo.removeEventListener("complete",this.requestsOnSuccess);
               thisLoader.contentLoaderInfo.removeEventListener("ioError",this.requestsOnError);
            }
            delete this.mLoadersToUrlRequests[loader];
         }
      }
      
      private function requestsProcessEvent(event:Event, func:Function) : void
      {
         var data:Object = null;
         var request:EUrlRequest = null;
         event.target.removeEventListener("complete",this.requestsOnSuccess);
         event.target.removeEventListener("ioError",this.requestsOnError);
         var key:Object;
         if((key = event.target) is LoaderInfo)
         {
            key = key.loader;
            data = event.target.content;
         }
         else
         {
            data = event.target.data;
         }
         if(this.mLoadersToUrlRequests != null)
         {
            request = this.mLoadersToUrlRequests[key];
            if(request != null)
            {
               func(request,data);
               this.requestsUrlRemoveRequest(request.getUrl());
            }
            else
            {
               Esparragon.traceMsg("Class [ELoaderMng].requestsProcessEvent() request not found.","E_LOADER_ERROR");
            }
            delete this.mLoadersToUrlRequests[key];
         }
      }
      
      private function requestsOnSuccess(event:Event) : void
      {
         this.requestsProcessEvent(event,this.requestsOnDoSuccess);
         this.mRequestsCurrentlyBeingProcessed--;
      }
      
      private function requestsOnDoSuccess(urlRequest:EUrlRequest, data:Object) : void
      {
         var request:EAssetRequest = null;
         var url:String = urlRequest.getUrl();
         this.requestsAddDebug(url,"Success");
         if(Config.DEBUG_MODE)
         {
            Esparragon.traceMsg("************* " + url + " Loaded!","E_LOADER");
         }
         this.mRequestsData[url] = data;
         this.requestsUrlSetState(url,2);
         var requests:Vector.<EAssetRequest> = urlRequest.getRequests();
         for each(request in requests)
         {
            this.requestsUrlAddUsageFromRequest(url,request);
         }
         if(this.mUrlsToLoaders == null)
         {
            this.mUrlsToLoaders = new Dictionary(true);
         }
         this.mUrlsToLoaders[url] = urlRequest.getLoader();
         urlRequest.success();
         this.requestsUrlRemoveRequest(url);
      }
      
      private function requestsOnError(event:IOErrorEvent) : void
      {
         Esparragon.traceMsg("Class [ELoaderMng].requestsOnError() event error " + event);
         this.requestsProcessEvent(event,this.requestsOnDoError);
         this.mRequestsCurrentlyBeingProcessed--;
      }
      
      private function requestsOnDoError(request:EUrlRequest, data:Object) : void
      {
         var url:String = request.getUrl();
         this.requestsAddDebug(url,"Error");
         Esparragon.traceMsg("Class [ELoaderMng].requestsOnDoError() file for " + url + " not found.","E_LOADER_ERROR");
         if(this.mRequestsData != null)
         {
            this.mRequestsData[url] = null;
            this.requestsUrlSetState(url,3);
            request.error();
            this.requestsUrlRemoveRequest(url);
         }
      }
      
      private function requestsAddDebug(url:String, text:String) : void
      {
         var milliseconds:Number = NaN;
         var oldMilliseconds:Number = NaN;
         var diff:Number = NaN;
         if(Esparragon.isDebugModeEnabled())
         {
            if(this.mRequestsDebug == null)
            {
               this.mRequestsDebug = new Dictionary(true);
            }
            if(this.mRequestsTimer == null)
            {
               this.mRequestsTimer = new Dictionary(true);
            }
            if(this.mRequestsDebugUrlsInRequestedOrder == null)
            {
               this.mRequestsDebugUrlsInRequestedOrder = new Vector.<String>(0);
            }
            if(this.mRequestsDebug[url] == null)
            {
               this.mRequestsDebug[url] = "";
               if(this.mRequestsDebugUrlsInRequestedOrder.indexOf(url) == -1)
               {
                  this.mRequestsDebugUrlsInRequestedOrder.push(url);
               }
            }
            if(this.mRequestsTimer[url] == null)
            {
               this.mRequestsTimer[url] = this.mTimeAccumulated;
            }
            milliseconds = this.mTimeAccumulated;
            oldMilliseconds = Number(this.mRequestsTimer[url]);
            diff = milliseconds - oldMilliseconds;
            this.mRequestsTimer[url] = milliseconds;
            this.mRequestsDebug[url] += text + " at " + milliseconds + " (" + diff + ") ";
         }
      }
      
      public function requestsTraceDebug() : void
      {
         var url:String = null;
         var urlMessage:String = null;
         var str:* = "------------------\n";
         str += "LOADER DEBUG INFO: maxRequestsAllowedSimultaneously: " + this.mRequestsMaxAmountAllowedSimultaneously + "\n";
         str += "------------------\n";
         if(this.mRequestsDebug != null)
         {
            for each(url in this.mRequestsDebugUrlsInRequestedOrder)
            {
               urlMessage = String(this.mRequestsDebug[url]);
               str += url + "-> " + urlMessage + "\n";
            }
         }
         Esparragon.traceMsg(str,"E_LOADER");
      }
      
      private function lutLoad(lutUrl:String) : void
      {
         this.mLutUrl = lutUrl;
         this.mLutIsEnabled = lutUrl != null;
         if(this.mLutIsEnabled)
         {
            this.mLutTable = new Dictionary();
            this.lutRequestFile();
         }
      }
      
      private function lutDestroy() : void
      {
         this.mLutTable = null;
         this.mLutUrl = null;
         this.mLutIsEnabled = false;
      }
      
      private function lutRequestFile() : void
      {
         var assetId:String = "lutTable";
         var asset:EAsset = this.assetsAddAssetFromXml(assetId,"default");
         asset.setUrl(this.mLutUrl);
         asset.setType("TXT");
         this.loadAsset(assetId,"default",0,this.lutOnComplete,this.lutOnError);
      }
      
      private function lutOnComplete(assetId:String, groupId:String) : void
      {
         var d:Object = null;
         var data:Object = this.getAssetData("lutTable","default");
         var json:Object = JSON.parse(data as String);
         var resourcesQueueFileUrl:String = null;
         for each(d in json)
         {
            if(Config.DEBUG_MODE)
            {
               Esparragon.traceMsg("uri: " + d.uri + " | path: " + d.path,"E_LOADER");
            }
            if(d.uri == "resources_queue.xml" && this.mLutIsEnabled)
            {
               Esparragon.traceMsg("resources-queue found! path: " + d.path,"E_LOADER");
               resourcesQueueFileUrl = String(d.path);
            }
            this.mLutTable[String(d.uri)] = String(d.path);
         }
         this.resourcesQueueRequestFile(resourcesQueueFileUrl);
      }
      
      private function lutOnError(assetId:String, groupId:String) : void
      {
         Esparragon.traceMsg("ERROR loading AssetsLUT from: " + this.mLutUrl,"E_LOADER_ERROR");
         this.resourcesQueueRequestFile();
      }
      
      private function resourcesQueueLoad() : void
      {
         this.mResourcesQueueAssets = new Dictionary();
      }
      
      private function resourcesQueueDestroy() : void
      {
         this.mResourcesQueueFileUrl = null;
         this.mResourcesQueueIsRequested = false;
         this.mResourcesQueueAssets = null;
      }
      
      private function resourcesQueueRequestFile(url:String = null) : void
      {
         var assetId:String = null;
         var asset:EAsset = null;
         if(!this.mResourcesQueueIsRequested)
         {
            assetId = "resources_queue.xml";
            if(url == null)
            {
               this.mResourcesQueueFileUrl = this.mFilesBaseUrl + assetId;
            }
            else
            {
               this.mResourcesQueueFileUrl = url;
            }
            asset = this.assetsAddAssetFromXml(assetId,"default");
            asset.setUrl(this.getFileURL(assetId,this.mLutIsEnabled));
            asset.setType("TXT");
            this.loadAsset(assetId,"default",0,this.resourcesQueueOnSuccess,this.resourcesQueueOnError);
            this.mResourcesQueueIsRequested = true;
         }
      }
      
      private function resourcesQueueOnSuccess(assetId:String, groupId:String) : void
      {
         var msg:String = null;
         var groupXml:XML = null;
         Esparragon.traceMsg("Loading resources-queue.xml OK from: " + this.mResourcesQueueFileUrl,"E_LOADER");
         var data:XML = this.getAssetXML("resources_queue.xml","default");
         for each(groupXml in EUtils.xmlGetChildrenList(data,"group"))
         {
            this.groupsAddGroup(groupXml);
         }
         this.mIsReady = true;
         if(this.mOnReadyCallback != null)
         {
            this.mOnReadyCallback();
         }
      }
      
      private function resourcesQueueOnError(assetId:String, groupId:String) : void
      {
         Esparragon.throwError("Loading resources_queue.xml from: " + this.mResourcesQueueFileUrl + " has failed. Impossible to continue.","E_LOADER_ERROR");
      }
      
      public function getFileURL(_filePath:String, useAssetsLUT:Boolean) : String
      {
         var fullURL:String = null;
         var channel:String = "E_LOADER_URL";
         if(this.mLutTable && this.mLutTable[_filePath] != null && useAssetsLUT)
         {
            fullURL = String(this.mLutTable[_filePath]);
         }
         else
         {
            if(!this.mLutTable)
            {
               Esparragon.traceMsg("\t LUT Assets Table is null",channel);
            }
            else if(this.mLutTable[_filePath] == null)
            {
               Esparragon.traceMsg("\t The asset <" + _filePath + "> is not on the LUT table",channel);
            }
            fullURL = this.mFilesBaseUrl + _filePath;
         }
         if(Config.DEBUG_MODE)
         {
            Esparragon.traceMsg("\t Final URL: " + fullURL,channel);
         }
         return fullURL;
      }
      
      private function errorDestroy() : void
      {
         var k:* = null;
         var groupId:String = null;
         var errors:Vector.<EError> = null;
         var error:EError = null;
         if(this.mErrorLogsByGroupId != null)
         {
            for(k in this.mErrorLogsByGroupId)
            {
               groupId = k as String;
               if((errors = this.mErrorLogsByGroupId[groupId]) != null)
               {
                  while(errors.length > 0)
                  {
                     error = errors.shift();
                     error.destroy();
                  }
               }
               delete this.mErrorLogsByGroupId[groupId];
            }
         }
      }
      
      private function errorNeedsDebugToStoreLogs() : Boolean
      {
         return Esparragon.needsDebugToStoreLogs();
      }
      
      private function errorAddLogToGroup(groupId:String, error:EError) : void
      {
         if(this.mErrorLogsByGroupId == null)
         {
            this.mErrorLogsByGroupId = new Dictionary(true);
         }
         var errors:Vector.<EError> = this.mErrorLogsByGroupId[groupId];
         if(errors == null)
         {
            errors = new Vector.<EError>();
            this.mErrorLogsByGroupId[groupId] = errors;
         }
         errors.push(error);
      }
      
      private function errorShowMsg(groupId:String, gravity:int, msg:String) : void
      {
         var error:EError = null;
         if(this.errorNeedsDebugToStoreLogs())
         {
            error = new EError(gravity,msg);
            this.errorAddLogToGroup(groupId,error);
         }
         else
         {
            Esparragon.traceMsg(msg,"E_LOADER_ERROR",gravity == 10,gravity);
         }
      }
      
      private function errorLogDuplicatedGroup(groupId:String) : void
      {
         var msg:String = "Group <" + groupId + "> has been defined twice in " + RESOURCES_QUEUE_WITH_BRACKETS;
         this.errorShowMsg(groupId,10,msg);
      }
      
      private function errorLogAssetNotDefinedInGroup(groupId:String, assetId:String) : void
      {
         var msg:String = "AssetId <" + assetId + "> hasn\'t been defined in group <" + groupId + "> in " + RESOURCES_QUEUE_WITH_BRACKETS;
         this.errorShowMsg(groupId,10,msg);
      }
      
      private function errorLogDuplicatedAssetInGroup(groupId:String, assetId:String) : void
      {
         var msg:String = "AssetId <" + assetId + "> has been defined twice in group <" + groupId + " in " + RESOURCES_QUEUE_WITH_BRACKETS;
         this.errorShowMsg(groupId,10,msg);
      }
      
      public function errorLogAssetMandatoryAttributesMissingInGroup(groupId:String, assetId:String, mandatoryAttributes:String) : void
      {
         var msg:String = "AssetId <" + assetId + "> in group <" + groupId + "> doesn\'t have the following mandatory attributes: " + mandatoryAttributes;
         this.errorShowMsg(groupId,10,msg);
      }
      
      public function errorLogAssetAttributesNotSupportedInGroup(groupId:String, assetId:String, attributes:String) : void
      {
         var msg:String = "AssetId <" + assetId + "> in group <" + groupId + "> doesn\'t support the following attributes: " + attributes;
         this.errorShowMsg(groupId,8,msg);
      }
      
      public function errorLogRequestNotFound(groupId:String, assetId:String) : void
      {
         var msg:* = "Request for assetId <" + assetId + "> and group <" + groupId + "> not found.";
         this.errorShowMsg(groupId,10,msg);
      }
      
      public function errorLogUrlNotValid(groupId:String, assetId:String, url:String = null) : void
      {
         var asset:EAsset = null;
         if(url == null)
         {
            if((asset = this.assetsGetAsset(assetId,groupId)) != null)
            {
               url = asset.getUrl();
            }
         }
         var msg:String = "Url for assetId <" + assetId + "> in group <" + groupId + "> not valid: " + url;
         this.errorShowMsg(groupId,9,msg);
      }
      
      public function errorPrintErrors() : void
      {
         var k:* = null;
         var groupId:String = null;
         var errors:Vector.<EError> = null;
         var error:EError = null;
         var i:int = 0;
         var length:int = 0;
         var gravity:int = 0;
         var msg:String = null;
         if(this.mErrorLogsByGroupId != null)
         {
            for(k in this.mErrorLogsByGroupId)
            {
               groupId = k as String;
               if((errors = this.mErrorLogsByGroupId[groupId]) != null)
               {
                  Esparragon.traceMsg("\ngroup " + groupId + ":","resources_queue.xml",false,2);
                  length = int(errors.length);
                  for(i = 0; i < length; )
                  {
                     gravity = (error = errors[i]).getGravity();
                     msg = error.getMsg();
                     msg = i + ")" + msg;
                     Esparragon.traceMsg(msg,"resources_queue.xml",gravity == 10,gravity);
                     i++;
                  }
               }
               delete this.mErrorLogsByGroupId[groupId];
            }
         }
      }
   }
}
