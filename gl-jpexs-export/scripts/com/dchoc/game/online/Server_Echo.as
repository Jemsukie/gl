package com.dchoc.game.online
{
   import com.adobe.crypto.MD5;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.phoenix.crypto.ARC4;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class Server_Echo extends Server
   {
      
      private static var token:String = null;
      
      private static var bearer:String = null;
       
      
      private const TIME_OUT:int = 30000;
      
      private var uid:String;
      
      private var url:String;
      
      private var serverVersion:String;
      
      private var version:String;
      
      private var platform:String;
      
      private var site:String;
      
      private var useSignature:Boolean = true;
      
      private var mTimeoutId:int = -1;
      
      private var mCurrentLoader:URLLoader;
      
      private var mRequestPending:Boolean = false;
      
      private var arc4In:ARC4;
      
      private var arc4Out:ARC4;
      
      public function Server_Echo()
      {
         super();
         var flashVars:Object = Star.getFlashVars();
         if(token == null)
         {
            token = flashVars["token"];
         }
         if(bearer == null)
         {
            bearer = flashVars["bearer"];
         }
         this.uid = flashVars["accountId"];
         this.url = flashVars["server"];
         this.serverVersion = flashVars["game_version"];
         this.platform = flashVars["platform"];
         this.site = flashVars["site"];
         var dataURL:String = String(flashVars["data"]);
         if(dataURL != null && dataURL.length > 0)
         {
            Config.setRoot(dataURL);
         }
         this.version = Capabilities.version;
      }
      
      private static function calculateChk(string:String) : int
      {
         var i:int = 0;
         var h:int = 317;
         var len:int = string.length;
         for(i = 0; i < len; )
         {
            h = 23 * h + string.charCodeAt(i);
            i++;
         }
         return h;
      }
      
      public function setToken(newToken:String) : void
      {
         token = newToken;
      }
      
      public function setARC4InKey(key:String) : void
      {
         if(arc4In == null)
         {
         }
      }
      
      public function setARC4OutKey(key:String) : void
      {
         if(arc4Out == null)
         {
         }
      }
      
      override protected function uploadPacket(bodyJSon:String) : void
      {
         var dataBytes:ByteArray = null;
         var sig:String = null;
         var key:String = null;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         bodyJSon = DCUtils.makeLatin1(bodyJSon);
         if(Config.useEncriptation() && arc4Out == null)
         {
            bodyJSon = DCUtils.simpleStringEncrypt(bodyJSon);
         }
         else if(Config.useEncriptation() && arc4Out != null)
         {
            dataBytes = new ByteArray();
            dataBytes.writeUTFBytes(bodyJSon);
            arc4Out.encrypt(dataBytes);
            bodyJSon = dataBytes.readUTFBytes(dataBytes.length);
         }
         super.uploadPacket(bodyJSon);
         var params:Object;
         (params = {}).uid = this.uid;
         params.version = this.serverVersion;
         params.data = bodyJSon;
         params.flash_version = this.version;
         params.platform = this.platform;
         if(this.site != null)
         {
            params.site = this.site;
         }
         if(this.useSignature)
         {
            sig = this.createSignature(params);
         }
         else
         {
            sig = "pass";
         }
         var variables:URLVariables = new URLVariables();
         for(key in params)
         {
            variables[key] = params[key];
         }
         variables.sig = sig;
         (request = new URLRequest(this.url + "game")).requestHeaders = [];
         request.requestHeaders.push(new URLRequestHeader("Authorization","Bearer " + bearer));
         request.data = variables;
         request.method = "POST";
         loader = new URLLoader();
         this.mCurrentLoader = loader;
         this.listeners(loader,true);
         try
         {
            loader.load(request);
            this.mRequestPending = true;
         }
         catch(error:Error)
         {
            DCDebug.traceCh("SERVER","sendCommand: failed to send CMD to server: " + error);
            listeners(loader,false);
            downloadedCommands(null);
         }
      }
      
      private function listeners(loader:URLLoader, add:Boolean) : void
      {
         if(add)
         {
            loader.addEventListener("complete",this.completeHandler);
            if(isLogged())
            {
               loader.addEventListener("httpStatus",this.httpStatusHandler);
               loader.addEventListener("ioError",this.ioErrorHandler);
               this.mTimeoutId = setTimeout(this.requestTimeout,30000,loader);
            }
            else
            {
               setTimeout(this.loginTimeout,12000);
            }
         }
         else
         {
            clearTimeout(this.mTimeoutId);
            this.mTimeoutId = -1;
            loader.removeEventListener("httpStatus",this.httpStatusHandler);
            loader.removeEventListener("complete",this.completeHandler);
            loader.removeEventListener("ioError",this.ioErrorHandler);
         }
      }
      
      private function httpStatusHandler(event:HTTPStatusEvent) : void
      {
      }
      
      private function completeHandler(event:Event) : void
      {
         var dataBytes:ByteArray = null;
         var logoutResponse:Object = null;
         var loader:URLLoader = URLLoader(event.target);
         this.listeners(loader,false);
         if(loader != this.mCurrentLoader || this.mRequestPending == false)
         {
            return;
         }
         this.mRequestPending = false;
         var responseCode:int;
         var responseObj:Object;
         if((responseCode = int((responseObj = JSON.parse(loader.data))["response_code"])) != 0)
         {
            DCDebug.traceCh("SERVER","completeHandler: failed, responseCode: " + responseCode);
            if(responseCode == 3)
            {
               logoutResponse = {};
               logoutResponse["packetCount"] = -2;
               logoutResponse["list"] = [{
                  "cmdName":"logOut",
                  "cmdData":{
                     "type":"clientOutdated",
                     "text":"sync not match! Multiple browser tabs running game!"
                  }
               }];
               downloadedCommands(logoutResponse);
               return;
            }
            downloadedCommands(null);
            return;
         }
         var service:String;
         if((service = String(responseObj["service"])) != "GamePacket")
         {
            DCDebug.traceCh("SERVER","completeHandler: Received response for unknown service (response\'s attribute service): " + service);
            downloadedCommands(null);
            return;
         }
         var chkValue:int = int(responseObj["chk"]);
         if(!chk)
         {
            chk = chkValue != calculateChk(responseObj["data"]);
         }
         var data:String = String(responseObj["data"]);
         if(Config.useEncriptation() && arc4In == null)
         {
            data = DCUtils.simpleStringDecrypt(data);
         }
         else if(Config.useEncriptation() && arc4In != null)
         {
            dataBytes = new ByteArray();
            dataBytes.writeUTFBytes(data);
            arc4In.decrypt(dataBytes);
            data = dataBytes.readUTFBytes(dataBytes.length);
         }
         var cmdList:Object = JSON.parse(data);
         downloadedCommands(cmdList);
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         var loader:URLLoader = URLLoader(event.target);
         this.listeners(loader,false);
         if(loader != this.mCurrentLoader || this.mRequestPending == false)
         {
            return;
         }
         this.mRequestPending = false;
         downloadedCommands(null);
      }
      
      private function loginTimeout() : void
      {
         if(!isLogged())
         {
            this.mRequestPending = false;
            downloadedCommands(null);
         }
      }
      
      private function requestTimeout(loader:URLLoader) : void
      {
         this.listeners(loader,false);
         if(loader != this.mCurrentLoader || this.mRequestPending == false)
         {
            return;
         }
         this.mRequestPending = false;
         downloadedCommands(null);
      }
      
      private function hashCode(string:String) : int
      {
         var i:int = 0;
         var h:int = 0;
         var len:int = string.length;
         for(i = 0; i < len; )
         {
            h = 31 * h + string.charCodeAt(i);
            i++;
         }
         return h;
      }
      
      private function createSignature(params:Object) : String
      {
         var key:* = null;
         var i:int = 0;
         var keyValuePair:Object = null;
         var baseString:* = "";
         var keyArray:Array = [];
         for(key in params)
         {
            keyArray.push({
               "key":key,
               "value":params[key]
            });
         }
         keyArray.sortOn("key",1);
         i = 0;
         for each(keyValuePair in keyArray)
         {
            baseString = baseString + keyValuePair.key + "=" + keyValuePair.value;
            if(i < keyArray.length - 1)
            {
               baseString += "&";
            }
            i++;
         }
         baseString += token;
         baseString += "RnQmN8i2UH82kncscrnx";
         return MD5.hash(baseString);
      }
   }
}
