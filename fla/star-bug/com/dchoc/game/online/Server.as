package com.dchoc.game.online
{
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import flash.events.EventDispatcher;
   
   public class Server extends EventDispatcher
   {
      
      private static const CACHE_UPDATES_MIN_TIME:int = 3000;
      
      private static const CACHE_UPDATES_MAX_TIME:int = 12000;
      
      private static const MAX_CMDS_IN_ONE_PACKET:int = 100;
      
      private static const PACKET_RETRY_TIMEOUT:int = 60000;
      
      private static const PACKET_NO_RESPONSE_TIMEOUT:int = 120000;
      
      private static const RETRY_COUNTS_TO_PAUSE_GAMEPLAY:int = 2;
      
      private static const RETRY_COUNTS_TO_LOGOUT_GAMEPLAY:int = 2;
      
      private static const LOGIN_RETRY_TIMEOUT:int = 5000;
      
      private static const PING_UPDATES_TIME:int = 7500;
      
      private static const PING_UPDATES_ENABLED:Boolean = true;
      
      private static const PERMANENT_UPDATES_ENABLED:Boolean = false;
      
      private static const PERMANENT_UPDATES_TIME:int = 10000;
       
      
      private var mCache:Array;
      
      private var mCacheUpdatesMinTimer:int = 0;
      
      private var mCacheUpdatesMaxTimer:int = 0;
      
      private var mPacketCmdList:Object;
      
      private var mPermanentUpdatesTimer:int = 0;
      
      private var mRetriesCount:int = 0;
      
      private var mRetryUploadPacket:Boolean = false;
      
      private var mPacketNoResponseTimer:int = 0;
      
      private var mLoginRetryTimer:int = 0;
      
      private var mLoginRetriesCount:int = 0;
      
      private var mPingUpdatesTimer:int = 0;
      
      private var mPingUpdatesCount:int = 0;
      
      private var mLogged:Boolean;
      
      private var mLogoutDone:Boolean;
      
      private var messageCnt:int = 0;
      
      private var mStartTime:Number;
      
      private var mSync:int;
      
      private var mServerVersion:String = "";
      
      private var mCommandCount:int = 1;
      
      public var mForceSendAllNow:Boolean = false;
      
      public var mForceSendAllNowEvenWhileWaiting:Boolean = false;
      
      public var mFlushAllCommandsNow:Boolean = false;
      
      private var mNick:String;
      
      private var mPass:String;
      
      protected var chk:Boolean = false;
      
      public function Server()
      {
         this.mCache = [];
         super();
         this.mLogged = false;
         var flashVars:Object = Star.getFlashVars();
      }
      
      public static function XMLToObject(xml:XML) : Object
      {
         var index:* = 0;
         var nameStr:String = null;
         var valueStr:String = null;
         var codeName:String = String(xml.name());
         var outputObj:Object = {};
         var xmlMain:XMLList = xml.attributes();
         for(index = 0; index < xmlMain.length(); )
         {
            nameStr = String(xmlMain[index].name());
            valueStr = String(xmlMain[index].valueOf());
            outputObj[nameStr] = valueStr;
            index++;
         }
         var xmlChildren:XMLList = xml.elements();
         outputObj[codeName] = XMLToObjectGetChildren(xmlChildren);
         return outputObj;
      }
      
      public static function XMLToObjectGetChildren(xmlChildren:XMLList) : Array
      {
         var index:* = 0;
         var codeName:String = null;
         var outputObj:Object = null;
         var xmlChild:XMLList = null;
         var indexAttr:uint = 0;
         var nameStr:String = null;
         var valueStr:String = null;
         var outputArr:Array = [];
         for(index = 0; index < xmlChildren.length(); )
         {
            codeName = String(xmlChildren[index].name());
            outputObj = {};
            xmlChild = xmlChildren[index].attributes();
            for(indexAttr = 0; indexAttr < xmlChild.length(); )
            {
               nameStr = String(xmlChild[indexAttr].name());
               valueStr = String(xmlChild[indexAttr].valueOf());
               outputObj[nameStr] = valueStr;
               indexAttr++;
            }
            if(xmlChildren.elements().length() > 0)
            {
               outputObj[codeName] = XMLToObjectGetChildren(xmlChildren[index].elements());
            }
            else
            {
               outputObj[codeName] = [];
            }
            outputArr.push(outputObj);
            index++;
         }
         return outputArr;
      }
      
      public static function objectToXML(obj:Object) : XML
      {
         return new XML(objectToXMLString(obj));
      }
      
      public static function objectToXMLString(obj:Object) : String
      {
         var objName:String = null;
         var output:String = null;
         var outputChild:String = null;
         var isEmpty:Boolean = false;
         var param:* = null;
         var count:uint = 0;
         var index:uint = 0;
         var value:String = null;
         if(obj is Object)
         {
            objName = "Name";
            output = "";
            outputChild = "";
            isEmpty = true;
            for(param in obj)
            {
               isEmpty = false;
               if(obj[param] is Array)
               {
                  objName = param;
                  count = uint(obj[param].length);
                  for(index = 0; index < count; )
                  {
                     outputChild += objectToXMLString(obj[param][index]);
                     index++;
                  }
               }
               else
               {
                  value = String(obj[param]);
                  output += " " + param + "=\"" + value + "\"";
               }
            }
            if(!isEmpty)
            {
               if(outputChild.length > 0)
               {
                  return "<" + objName + output + ">\n" + outputChild + "\n</" + objName + ">";
               }
               return "<" + objName + output + "/>";
            }
         }
         return "";
      }
      
      public function login(nick:String, pass:String, init:String, retry:Boolean = false) : void
      {
         this.mNick = nick;
         this.mPass = pass;
         this.mLogged = false;
         DCDebug.traceCh("SERVER",">>>>>>>>>>> Sending LOGIN...");
         var bodyObj:Object = {
            "packetType":"login",
            "packetData":{
               "nick":nick,
               "pass":pass,
               "init":init,
               "platform":InstanceMng.getPlatformSettingsDefMng().getCurrentPlatformSku(),
               "language":Star.getFlashVars().lang
            }
         };
         this.mForceSendAllNow = true;
         this.mLoginRetryTimer = 0;
         mCacheUpdatesMinTimer = 0;
         mCacheUpdatesMaxTimer = 0;
         this.uploadPacket(JSON.stringify(bodyObj));
      }
      
      public function logout() : void
      {
         this.mLogoutDone = true;
         this.mLogged = false;
      }
      
      public function isLogged() : Boolean
      {
         return this.mLogged;
      }
      
      public function flushAllCommandsNow() : void
      {
         this.mFlushAllCommandsNow = true;
         this.mForceSendAllNow = true;
      }
      
      public function sendCommandNow(commandName:String, commandData:Object) : void
      {
         this.sendCommand(commandName,commandData);
         this.mForceSendAllNow = true;
      }
      
      public function forceSendAllCommandsDangerously() : void
      {
         this.mForceSendAllNowEvenWhileWaiting = true;
      }
      
      public function sendCommand(commandName:String, commandData:Object) : void
      {
         var omitStr:* = null;
         InstanceMng.getUserDataMng().addRequestTaskReceived(commandName);
         var cmdObj:Object = {};
         cmdObj["cmdName"] = commandName;
         cmdObj["cmdData"] = commandData;
         cmdObj["cmdCount"] = this.mCommandCount++;
         cmdObj["cmdMls"] = InstanceMng.getUserDataMng().getGameCurrentTimemillis();
         if(this.mCache.length == 0 && this.mCacheUpdatesMinTimer == 0)
         {
            this.mCacheUpdatesMinTimer = 3000;
            this.mCacheUpdatesMaxTimer = 12000;
         }
         else if(this.mCacheUpdatesMaxTimer > 0)
         {
            this.mCacheUpdatesMinTimer = Math.max(this.mCacheUpdatesMinTimer,3000);
         }
         if(!Config.DEBUG_SHORTEN_NOISY || Config.DEBUG_SHORTEN_NOISY_CMDS.indexOf(commandName) == -1 && cmdObj.cmdData != null && Config.DEBUG_SHORTEN_NOISY_ACTIONS.indexOf(cmdObj.cmdData.action) == -1)
         {
            DCDebug.traceCh("SERVER","---------------------------=>");
            DCDebug.traceChObject("SERVER",cmdObj);
         }
         else
         {
            omitStr = commandName;
            if(cmdObj.cmdData != null && cmdObj.cmdData.action != null)
            {
               omitStr = omitStr + "/" + cmdObj.cmdData.action;
            }
            DCDebug.traceCh("SERVER","--=> " + omitStr + " info omitted");
         }
         this.mCache.push(cmdObj);
      }
      
      public function serverIsBusy() : int
      {
         var returnValue:int = 0;
         if(this.mCache.length == 0)
         {
            if(this.mPacketCmdList == null)
            {
               returnValue = 2;
            }
            else
            {
               returnValue = 1;
            }
         }
         return returnValue;
      }
      
      public function logicUpdate(deltaTime:int) : void
      {
         var paramObj:Object = null;
         if(InstanceMng.getApplication().idleHasBeenToldToOpen() || InstanceMng.getApplication().hasBeenToldToLogout())
         {
            return;
         }
         if(this.mLoginRetryTimer > 0 && (this.mLoginRetryTimer = this.mLoginRetryTimer - deltaTime) <= 0)
         {
            this.mLoginRetryTimer = 0;
            this.login(this.mNick,this.mPass,"init");
            return;
         }
         if(this.mCacheUpdatesMaxTimer > 0 && (this.mCacheUpdatesMaxTimer = this.mCacheUpdatesMaxTimer - deltaTime) <= 0)
         {
            this.mCacheUpdatesMaxTimer = 0;
         }
         if(this.mCacheUpdatesMinTimer > 0 && (this.mCacheUpdatesMinTimer = this.mCacheUpdatesMinTimer - deltaTime) <= 0)
         {
            this.mCacheUpdatesMinTimer = 0;
            this.mForceSendAllNow = true;
         }
         if(true)
         {
            this.mPingUpdatesTimer -= deltaTime;
            if(this.mPingUpdatesTimer <= 0)
            {
               paramObj = {};
               paramObj["time"] = new Date().toUTCString();
               this.sendCommandNow("ping",paramObj);
               this.mPingUpdatesTimer = 7500;
            }
         }
         if(false)
         {
            this.mPermanentUpdatesTimer -= deltaTime;
            if(this.mPermanentUpdatesTimer <= 0)
            {
               this.mPermanentUpdatesTimer = 10000;
               this.mForceSendAllNow = true;
            }
         }
         if(this.mForceSendAllNow)
         {
            this.mForceSendAllNow = false;
            if(this.mPacketCmdList != null && !this.mRetryUploadPacket && !this.mForceSendAllNowEvenWhileWaiting)
            {
               this.mCacheUpdatesMinTimer = Math.max(this.mCacheUpdatesMinTimer,3000);
               return;
            }
            this.mForceSendAllNowEvenWhileWaiting = false;
            this.sendPacketNow();
            if(this.mCache.length == 0)
            {
               this.mCacheUpdatesMinTimer = 0;
            }
            else
            {
               this.mCacheUpdatesMinTimer = Math.max(this.mCacheUpdatesMinTimer,3000);
            }
            if(false)
            {
               this.mPermanentUpdatesTimer = 10000;
            }
         }
         if(this.mPacketNoResponseTimer > 0 && (this.mPacketNoResponseTimer = this.mPacketNoResponseTimer - deltaTime) <= 0)
         {
            this.mPacketNoResponseTimer = 0;
            DCDebug.traceCh("SERVER","*** Server not responded in a long time ***");
            InstanceMng.getUserDataMng().updateProfile_crash("NoResponse",{});
            this.logout();
            Application.externalNotification(1);
         }
         if(this.chk)
         {
            this.chk = false;
            DCDebug.traceCh("SERVER","*** chk dont match ***");
            InstanceMng.getUserDataMng().updateProfile_crash("ChkMismatch",{});
            this.logout();
            Application.externalNotification(1);
         }
      }
      
      private function sendPacketNow() : void
      {
         var cmdArray:Array = null;
         var cmdLimit:int = 0;
         var bodyObj:Object = null;
         var cmdObj:Object = null;
         if(this.mLogged)
         {
            if(this.mCache.length == 0 && this.mPacketCmdList == null)
            {
               if(true)
               {
                  return;
               }
               cmdObj = {};
               cmdObj["cmdName"] = "empty";
               cmdObj["cmdData"] = {};
               cmdObj["cmdCount"] = this.mCommandCount++;
               cmdObj["cmdMls"] = InstanceMng.getUserDataMng().getGameCurrentTimemillis();
               this.mCache.push(cmdObj);
            }
            this.mRetryUploadPacket = false;
            DCDebug.traceCh("SERVER","** Server Request (" + this.messageCnt + ") >>>>");
            cmdArray = null;
            if(this.mPacketCmdList == null)
            {
               this.mPacketCmdList = {};
               cmdArray = [];
            }
            else
            {
               cmdArray = this.mPacketCmdList["cmdList"];
               if(this.mCache.length > 0)
               {
                  this.mPacketCmdList["retry"] = this.mCache[0]["cmdCount"];
               }
               else
               {
                  this.mPacketCmdList["retry"] = 0;
               }
            }
            cmdLimit = 100;
            while(this.mCache.length > 0)
            {
               cmdArray.push(this.mCache.shift());
               if(!this.mFlushAllCommandsNow && cmdLimit <= 0)
               {
                  break;
               }
            }
            this.mFlushAllCommandsNow = false;
            this.mPacketCmdList["cmdList"] = cmdArray;
            this.mPacketCmdList["packetCount"] = this.messageCnt;
            this.mPacketCmdList["packetMls"] = InstanceMng.getUserDataMng().getGameCurrentTimemillis();
            this.mPacketCmdList["sync"] = this.mSync;
            this.mPacketCmdList["version"] = this.mServerVersion;
            if(InstanceMng.getRole() != null)
            {
               this.mPacketCmdList["role"] = InstanceMng.getRole().mId;
            }
            bodyObj = {
               "packetType":"cmdList",
               "packetData":this.mPacketCmdList
            };
            this.uploadPacket(JSON.stringify(bodyObj));
            this.mStartTime = DCTimerUtil.currentTimeMillis();
         }
      }
      
      protected function uploadPacket(bodyJSon:String) : void
      {
         this.mPacketNoResponseTimer = 120000;
      }
      
      protected function downloadedCommands(cmdList:Object) : void
      {
         var logInfo:Object = null;
         var msgCnt:int = 0;
         var responseList:* = null;
         var response:Object = null;
         var serverEvt:ServerEvent = null;
         var elapsedTime:int = 120000 - this.mPacketNoResponseTimer;
         this.mPacketNoResponseTimer = 0;
         if(cmdList != null)
         {
            if(!((msgCnt = int(cmdList["packetCount"])) == this.messageCnt || msgCnt < 0))
            {
               DCDebug.traceCh("SERVER","Server Command Response NOT MATCH (" + msgCnt + ") instead of " + this.messageCnt);
               logInfo = {
                  "cmdList":cmdList,
                  "expected":this.messageCnt,
                  "received":msgCnt
               };
               InstanceMng.getUserDataMng().updateProfile_crash("BadResponse",logInfo);
               this.logout();
               Application.externalNotification(1);
               return;
            }
            this.mPacketCmdList = null;
            DCDebug.traceCh("SERVER","** Server Response (" + msgCnt + ") " + (DCTimerUtil.currentTimeMillis() - this.mStartTime) + " <<<<");
            responseList = cmdList;
            for each(response in responseList["list"])
            {
               this.processCommand(response);
               serverEvt = new ServerEvent("onServerResponse",response);
               dispatchEvent(serverEvt);
            }
            if(this.mLogged && this.mRetriesCount >= 2)
            {
               Application.externalNotification(18,{"resume":true});
            }
            this.mRetriesCount = 0;
         }
         else
         {
            DCDebug.traceCh("SERVER","** Server Response (" + this.messageCnt + ") " + (DCTimerUtil.currentTimeMillis() - this.mStartTime) + " <<xx FAILED");
            if(!this.mLogged && !this.mLogoutDone)
            {
               if(Config.IGNORE_LOGOUT)
               {
                  return;
               }
               Application.externalNotification(33,null);
               DCDebug.traceCh("SERVER","** impossible to login with server **");
               this.mLoginRetryTimer = 0;
               return;
            }
            this.mRetriesCount++;
            if(this.mRetriesCount == 2)
            {
               Application.externalNotification(17);
            }
            else if(this.mRetriesCount > 2)
            {
               InstanceMng.getUserDataMng().updateProfile_crash("ConnectionLost",{"retries":this.mRetriesCount});
               this.logout();
               Application.externalNotification(18,{"resume":false});
               Application.externalNotification(1,{"type":"connectionLost"});
               return;
            }
            this.mRetryUploadPacket = true;
            this.mCacheUpdatesMinTimer = Math.max(1,60000 - elapsedTime);
            DCDebug.traceCh("SERVER","** going to retry: " + this.mRetriesCount + " in " + this.mCacheUpdatesMinTimer + " milliseconds");
         }
         if(this.messageCnt > 2147483647 - 1)
         {
            this.messageCnt = 0;
         }
         this.messageCnt++;
      }
      
      private function processCommand(responseObj:Object) : void
      {
         var cmd:String = String(responseObj["cmdName"]);
         var data:Object = responseObj["cmdData"];
         if(cmd == "logOK")
         {
            DCDebug.traceCh("SERVER",">>>>>>>>>>>>>>>> Login OK <<<<<<<<<<<<<<");
            this.mSync = data["sync"];
            this.mServerVersion = data["version"];
            this.mLogged = true;
         }
         else if(cmd == "logKO")
         {
            DCDebug.traceCh("SERVER",">>>>>>>>>>>>>>>> Login FAILED <<<<<<<<<<<<<<");
            this.mLogged = false;
         }
         else if(cmd == "logOut")
         {
            DCDebug.traceCh("SERVER",">>>>>>>>>>>>>>>> LogOut from Server <<<<<<<<<<<<<<");
            this.mLogged = false;
         }
      }
   }
}
