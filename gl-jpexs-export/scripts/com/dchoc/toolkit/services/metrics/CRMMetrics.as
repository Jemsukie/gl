package com.dchoc.toolkit.services.metrics
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   import flash.xml.XMLDocument;
   
   public class CRMMetrics
   {
       
      
      private var m_crossPromotionCallback:Function;
      
      public function CRMMetrics()
      {
         super();
      }
      
      public function wcrmTrackEventFbUserId(project_id:int, event:String, label:String, group:String, env:int, product:String, product_detail:String, src:String, ref:String, fbUserId:String, ref_uid:String, access_token:String, client_ip:String, level:int, game_currency_delta:int, game_currency_balance:int, paid_currency_delta:int, paid_currency_balance:int, real_currency_delta:int, friends_total:int, app_friends_total:int, app_neighbors:int, isfan:int, version:String, unique_tracking_tag:String, recipient_uids:String, sender:String, has_app_installed:int, session_count:int, value:int, p1:String, p2:String, p3:String, p4:String) : void
      {
         var params:String = (params = (params = (params = (params = (params = "") + "idsite=1") + "&rec=1") + ("&event=" + event)) + ("&action_name=" + group)) + ("&uid=" + fbUserId);
         if(label != null)
         {
            params += "&e_c=" + label;
         }
         if(p1 != null)
         {
            params += "&p1=" + p1;
         }
         if(p2 != null)
         {
            params += "&p2=" + p2;
         }
         if(p3 != null)
         {
            params += "&p3=" + p3;
         }
         if(p4 != null)
         {
            params += "&p4=" + p4;
         }
         if(src != null)
         {
            params += "&src=" + src;
         }
         if(ref != null)
         {
            params += "&ref=" + ref;
         }
         if(ref_uid != null)
         {
            params += "&ref_uid=" + ref_uid;
         }
         if(product != null)
         {
            params += "&e_a=" + product;
         }
         if(product_detail != null)
         {
            params += "&e_n=" + product_detail;
         }
         if(version != null)
         {
            params += "&version=" + version;
         }
         params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params = (params += "&level=" + level) + ("&game_currency_delta=" + game_currency_delta)) + ("&game_currency_balance=" + game_currency_balance)) + ("&paid_currency_delta=" + paid_currency_delta)) + ("&paid_currency_balance=" + paid_currency_balance)) + ("&real_currency_delta=" + real_currency_delta)) + ("&friends_total=" + friends_total)) + ("&application_friends_total=" + app_friends_total)) + ("&app_neighbors=" + app_neighbors)) + ("&is_fan=" + isfan)) + ("&session_count=" + session_count)) + ("&value=" + value)) + ("&has_app_installed=" + has_app_installed)) + ("&access_token=" + access_token)) + ("&client_ip=" + client_ip)) + ("&recipient_uids=" + recipient_uids)) + ("&unique_tracking_tag=" + unique_tracking_tag)) + ("&sender=" + sender)) + ("&rand=" + int(getTimer() / 1000));
         var loader:URLLoader = new URLLoader();
         configureListeners(loader);
         var request:URLRequest = new URLRequest("https://analytics.phoenixnetwork.net/matomo.php?" + params);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      public function wcrmSendCrossPromotionSplashRequest(facebookId:String, projectId:String, signature:String, callBack:Function) : void
      {
         m_crossPromotionCallback = callBack;
         var loader:URLLoader;
         (loader = new URLLoader()).addEventListener("complete",onCrossPromotionSplashComplete);
         loader.addEventListener("open",openHandler);
         loader.addEventListener("progress",progressHandler);
         loader.addEventListener("securityError",securityErrorHandler);
         loader.addEventListener("httpStatus",httpStatusHandler);
         loader.addEventListener("ioError",ioErrorHandler);
         var request:URLRequest = new URLRequest("http://crm.digitalchocolate.com/user_projects/ingame_xp?project_id=" + projectId + "&fb_user_id=" + facebookId + "&sig=" + signature);
         try
         {
            loader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load requested document.");
         }
      }
      
      private function onCrossPromotionSplashComplete(event:Event) : void
      {
         var t_xml:XMLDocument = null;
         var loader:URLLoader = URLLoader(event.target);
         trace("completeHandler: " + loader.data);
         if(m_crossPromotionCallback != null)
         {
            t_xml = new XMLDocument(loader.data);
            m_crossPromotionCallback(t_xml);
            m_crossPromotionCallback = null;
         }
      }
      
      private function configureListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener("complete",completeHandler);
         dispatcher.addEventListener("open",openHandler);
         dispatcher.addEventListener("progress",progressHandler);
         dispatcher.addEventListener("securityError",securityErrorHandler);
         dispatcher.addEventListener("httpStatus",httpStatusHandler);
         dispatcher.addEventListener("ioError",ioErrorHandler);
      }
      
      private function completeHandler(event:Event) : void
      {
         var loader:URLLoader = URLLoader(event.target);
         trace("completeHandler: " + loader.data);
      }
      
      private function openHandler(event:Event) : void
      {
         trace("openHandler: " + event);
      }
      
      private function progressHandler(event:ProgressEvent) : void
      {
         trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
      }
      
      private function securityErrorHandler(event:SecurityErrorEvent) : void
      {
         trace("securityErrorHandler: " + event);
      }
      
      private function httpStatusHandler(event:HTTPStatusEvent) : void
      {
         trace("httpStatusHandler: " + event);
      }
      
      private function ioErrorHandler(event:IOErrorEvent) : void
      {
         trace("ioErrorHandler: " + event);
      }
   }
}
