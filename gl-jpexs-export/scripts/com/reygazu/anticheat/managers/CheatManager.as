package com.reygazu.anticheat.managers
{
   import com.adobe.crypto.MD5;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.hurlant.util.Base64;
   import com.reygazu.anticheat.events.CheatManagerEvent;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class CheatManager extends EventDispatcher
   {
      
      private static const MOUSE_CLICK_MAX_INTERVALS:int = 12;
      
      private static const BASE_MATCH_CONFIDENCE:Number = 1;
      
      private static const MAX_CONFIDENCE:Number = 100;
      
      private static const CONFIDENCE_INCREMENT_INCREASE:Number = 1.08;
      
      private static const CONFIDENCE_INCREMENT_DECREASE:Number = 0.9;
      
      private static const BOUNDS_TO_CHECK:Vector.<Number> = new <Number>[0.93,1.07];
      
      private static const MAX_CLICKS_PER_CYCLE:int = 600;
      
      private static const HOP_TIMER:int = 60000;
      
      private static const MAX_CLICKS_CYCLE_TIMER:int = 120000;
      
      private static const FETCH_CLICKS_TIMER:int = 2000;
      
      protected static var _instance:CheatManager;
       
      
      private var _focusHop:Boolean;
      
      private var _secureVars:Array;
      
      private var _stage:Stage;
      
      private var mHopTimer:int;
      
      private var mFetchClicksTimer:int = 0;
      
      private var mMaxClicksTimer:int = 0;
      
      private var mNumClicks:int = 0;
      
      private var mStoredMouseClicks:Array;
      
      private var mMouseClickConfidence:Number = 1;
      
      private var mPreviousClick:Object;
      
      private var mIsWaitingForPersistedMouseClicks:Boolean = false;
      
      private var bClientData:ByteArray;
      
      public function CheatManager(caller:Function = null)
      {
         super();
         if(caller != CheatManager.getInstance)
         {
            throw new Error("CheatManager is a singleton class, use getInstance() instead");
         }
         if(CheatManager._instance != null)
         {
            throw new Error("Only one CheatManager instance should be instantiated");
         }
      }
      
      public static function getInstance() : CheatManager
      {
         if(_instance == null)
         {
            _instance = new CheatManager(arguments.callee);
         }
         return _instance;
      }
      
      private static function convertMouseClicksToString(input:Array) : String
      {
         var isFirstParam:Boolean = false;
         if(input == null)
         {
            return null;
         }
         var returnValue:String = "";
         var isFirstObj:Boolean = true;
         for each(var obj in input)
         {
            returnValue += isFirstObj ? "" : "|";
            isFirstParam = true;
            for(var param in obj)
            {
               returnValue = returnValue + (isFirstParam ? "" : ";") + param + "=" + obj[param];
               isFirstParam = false;
            }
            isFirstObj = false;
         }
         return returnValue;
      }
      
      private static function convertStringToMouseClicks(input:String) : Array
      {
         var currObj:Object = null;
         var params:Array = null;
         var tokens:Array = null;
         var key:String = null;
         var value:String = null;
         var finalValue:* = undefined;
         if(input == null || input == "")
         {
            return null;
         }
         var returnValue:Array = [];
         var objects:Array = input.split("|");
         for each(var obj in objects)
         {
            currObj = {};
            params = obj.split(";");
            for each(var param in params)
            {
               key = String((tokens = param.split("="))[0]);
               value = String(tokens[1]);
               finalValue = isNaN(Number(value)) ? value : Number(value);
               currObj[key] = finalValue;
            }
            if(currObj != null && currObj != {})
            {
               returnValue.push(currObj);
            }
         }
         return returnValue;
      }
      
      private static function combineAndTrimMouseClicks(oldArray:Array, newArray:Array) : Array
      {
         if(oldArray == null || oldArray.length == 0)
         {
            return newArray;
         }
         if(newArray == null || newArray.length == 0)
         {
            return oldArray;
         }
         var combined:Array = oldArray.concat(newArray);
         if(combined.length <= 12)
         {
            return combined;
         }
         return combined.slice(combined.length - 12);
      }
      
      public function init(stage:Stage) : void
      {
         this._secureVars = [];
         this._focusHop = false;
         this._stage = stage;
         this._stage.addEventListener("deactivate",this.onfocusHandler);
         this._stage.addEventListener("activate",this.onfocusHandler);
         this._stage.addEventListener("click",this.onMouseClickHandler);
         this.mHopTimer = 60000;
         this.mFetchClicksTimer = 2000;
         this.mMaxClicksTimer = 120000;
         this.mStoredMouseClicks = [];
         this.mIsWaitingForPersistedMouseClicks = true;
         var loader:URLLoader = new URLLoader();
         loader.dataFormat = "binary";
         loader.addEventListener("complete",onLoaderComplete);
         loader.load(new URLRequest(stage.loaderInfo.url));
      }
      
      private function onMouseClickHandler(evt:MouseEvent) : void
      {
         var w:int = this._stage.stageWidth;
         var h:int = this._stage.stageHeight;
         var event:CheatManagerEvent;
         (event = new CheatManagerEvent(CheatManagerEvent.INPUT_DETECTION)).data = {
            "type":"mouseClick",
            "x":evt.stageX,
            "y":evt.stageY,
            "w":w,
            "h":h,
            "time":InstanceMng.getUserDataMng().getServerCurrentTimemillis()
         };
         this.logEventData(event.data);
         this.mNumClicks += 1;
      }
      
      private function onMouseMoveHandler(evt:MouseEvent) : void
      {
         var w:int = this._stage.stageWidth;
         var h:int = this._stage.stageHeight;
         var event:CheatManagerEvent;
         (event = new CheatManagerEvent(CheatManagerEvent.INPUT_DETECTION)).data = {
            "type":"mouseMove",
            "x":evt.stageX,
            "y":evt.stageY,
            "w":w,
            "h":h,
            "time":InstanceMng.getUserDataMng().getServerCurrentTimemillis()
         };
         this.logEventData(event.data);
      }
      
      private function logEventData(data:Object) : void
      {
         var recalculateConfidence:Boolean = false;
         if(this.mPreviousClick != null)
         {
            if(this.mPreviousClick.time == data.time)
            {
               return;
            }
         }
         if(this.mStoredMouseClicks == null)
         {
            return;
         }
         if(this.mStoredMouseClicks.length == 12)
         {
            this.mStoredMouseClicks.shift();
            recalculateConfidence = true;
         }
         this.mStoredMouseClicks.push(data);
         if(recalculateConfidence)
         {
            this.calculateConfidence();
         }
         this.mPreviousClick = data;
      }
      
      private function calculateConfidence() : void
      {
         var i:int = 0;
         var data:Object = null;
         var interval:Number = 0;
         var timeIntervals:Vector.<Number> = new Vector.<Number>(0);
         for(i = 0; i < this.mStoredMouseClicks.length - 1; )
         {
            interval = Math.abs(this.mStoredMouseClicks[i].time - this.mStoredMouseClicks[i + 1].time);
            timeIntervals.push(interval);
            i++;
         }
         var newEntry:Number = timeIntervals[timeIntervals.length - 1];
         for each(interval in timeIntervals)
         {
            if(interval >= newEntry * BOUNDS_TO_CHECK[0] && interval <= newEntry * BOUNDS_TO_CHECK[1])
            {
               this.mMouseClickConfidence = Math.max(this.mMouseClickConfidence,1);
               this.mMouseClickConfidence *= 1.08;
            }
            else
            {
               this.mMouseClickConfidence *= 0.9;
            }
         }
         this.mMouseClickConfidence = Math.min(this.mMouseClickConfidence,100);
         if(this.mMouseClickConfidence >= 100)
         {
            data = {"mouseClicks":this.mStoredMouseClicks};
            InstanceMng.getUserDataMng().updateProfile_cheater("cheatMacro",data);
            this.resetMouseClickTelemetry();
         }
      }
      
      private function resetMouseClickTelemetry() : void
      {
         this.mMouseClickConfidence = 1;
         this.mStoredMouseClicks = [];
      }
      
      public function set enableFocusHop(value:Boolean) : void
      {
         this._focusHop = value;
      }
      
      private function onfocusHandler(evt:Event) : void
      {
         if(this._focusHop)
         {
            this.doHop();
         }
      }
      
      private function persistClicks() : void
      {
         var clicksFromPersist:String = InstanceMng.getUserInfoMng().getProfileLogin().getRecentClicks();
         if(clicksFromPersist.length > 0)
         {
            InstanceMng.getUserInfoMng().getProfileLogin().setRecentClicks(convertMouseClicksToString(combineAndTrimMouseClicks(convertStringToMouseClicks(clicksFromPersist),this.mStoredMouseClicks)));
         }
         else if(this.mStoredMouseClicks != null)
         {
            InstanceMng.getUserInfoMng().getProfileLogin().setRecentClicks(convertMouseClicksToString(this.mStoredMouseClicks));
         }
         InstanceMng.getUserInfoMng().getProfileLogin().setRecentClickConfidence(this.mMouseClickConfidence);
      }
      
      public function doHop() : void
      {
         this.dispatchEvent(new CheatManagerEvent(CheatManagerEvent.FORCE_HOP));
      }
      
      public function detectCheat(name:String, fakeValue:Object, realValue:Object) : void
      {
         var event:CheatManagerEvent;
         (event = new CheatManagerEvent(CheatManagerEvent.CHEAT_DETECTION)).data = {
            "variableName":name,
            "fakeValue":fakeValue,
            "realValue":realValue
         };
         CheatManager.getInstance().dispatchEvent(event);
      }
      
      public function logicUpdate(dt:int) : void
      {
         var data:Object = null;
         var userInfoMng:UserInfoMng = null;
         var persistedClicks:Array = null;
         var profile:Profile = null;
         this.mHopTimer -= dt;
         this.mFetchClicksTimer -= dt;
         this.mMaxClicksTimer -= dt;
         if(this.mHopTimer <= 0)
         {
            this.doHop();
            this.mHopTimer = 60000;
            if(!this.mIsWaitingForPersistedMouseClicks)
            {
               this.persistClicks();
            }
         }
         if(this.mMaxClicksTimer <= 0)
         {
            this.mMaxClicksTimer = 120000;
            if(this.mNumClicks >= 600)
            {
               data = {
                  "numClicks":this.mNumClicks,
                  "cycleTime":120000,
                  "time":InstanceMng.getUserDataMng().getServerCurrentTimemillis()
               };
               InstanceMng.getUserDataMng().updateProfile_cheater("cheatMacro",data);
            }
            this.mNumClicks = 0;
         }
         if(this.mFetchClicksTimer <= 0 && this.mIsWaitingForPersistedMouseClicks)
         {
            this.mFetchClicksTimer = 2000;
            userInfoMng = InstanceMng.getUserInfoMng();
            persistedClicks = null;
            profile = null;
            if(userInfoMng == null)
            {
               return;
            }
            profile = userInfoMng.getProfileLogin();
            if(profile == null)
            {
               return;
            }
            persistedClicks = convertStringToMouseClicks(profile.getRecentClicks());
            if(profile.getFlagsReaded() && (persistedClicks == null || persistedClicks.length == 0))
            {
               if(persistedClicks == null)
               {
                  persistedClicks = ["empty"];
               }
               else if(persistedClicks.length == 0)
               {
                  persistedClicks = ["empty"];
               }
            }
            if(persistedClicks == null)
            {
               return;
            }
            if(persistedClicks.length == 0)
            {
               return;
            }
            this.mIsWaitingForPersistedMouseClicks = false;
            if(persistedClicks[0] != "empty")
            {
               this.mStoredMouseClicks = persistedClicks;
               this.mMouseClickConfidence = profile.getRecentClickConfidence();
            }
         }
      }
      
      public function getClientData() : String
      {
         return Base64.encodeByteArray(bClientData);
      }
      
      public function calculateHash(position:Number, count:uint) : String
      {
         if(bClientData == null)
         {
            return "";
         }
         var data:ByteArray = new ByteArray();
         bClientData.readBytes(data,count * position,count);
         return MD5.hashBytes(data);
      }
      
      private function onLoaderComplete(event:Event) : void
      {
         bClientData = ByteArray(event.target.data);
      }
   }
}
