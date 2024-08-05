package com.dchoc.toolkit.services.metrics
{
   import com.dchoc.game.services.GameMetrics;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.utils.Dictionary;
   
   public class DCMetrics
   {
      
      private static const DEBUG_METRICS:Boolean = true;
      
      private static const PARAMS_COUNT:int = 4;
      
      public static const METRICS_CRM:int = 0;
      
      public static const METRICS_GA:int = 1;
      
      public static const METRICS_BA:int = 2;
      
      public static const ENV_DEV:int = 0;
      
      public static const ENV_STAGE:int = 1;
      
      public static const ENV_PRODUCTION:int = 2;
      
      private static var eventHash:Dictionary;
      
      private static var mPremiumCurrencySpent:int = 0;
      
      private static var mGameTime:Number = 0;
      
      private static var mGameProgressValue:int = 0;
       
      
      public function DCMetrics()
      {
         super();
      }
      
      public static function subscribeEvent(eventID:String, services:Array) : void
      {
         if(!eventHash)
         {
            eventHash = new Dictionary();
         }
         eventHash[eventID] = services;
      }
      
      public static function sendMetric(event:String, label:String = null, product:String = null, product_detail:String = null, params:Object = null, coinsSpentForThis:int = 0, cashSpentForThis:int = 0, group:String = null) : void
      {
         sendMetricCRM(event,label,product,product_detail,params,coinsSpentForThis,cashSpentForThis,group);
      }
      
      private static function sendMetricCRM(event:String, label:String = null, product:String = null, product_detail:String = null, params:Object = null, coinsSpentForThis:int = 0, cashSpentForThis:int = 0, group:String = null) : void
      {
         var unique_tracking_tag:String = null;
         var recipient_uids:String = null;
         var i:int = 0;
         var metrics:CRMMetrics = new CRMMetrics();
         var flashVars:Object;
         var fuid:String = String((flashVars = Star.getFlashVars()).uid);
         var wcrmEnv:int = int(flashVars.wcrm_env);
         var src:String = null;
         var ref:String = String(flashVars.wcrm_ref);
         var version:String = String(flashVars.game_version);
         var project_id:int = int(flashVars.wcrm_project_id);
         var isFan:int = GameMetrics.getIsFan();
         var level:int = GameMetrics.getLevel();
         var coins:int = GameMetrics.getGameCurrency(product);
         var friendsCount:int = GameMetrics.getFriendsCount();
         var friendsApplication:int = GameMetrics.getApplicationFriendsCount();
         var neighbors:int = GameMetrics.getNeighborsCount();
         var access_token:String = String(flashVars.oauth_token);
         var client_ip:String = String(flashVars.client_ip);
         var cash:int = GameMetrics.getPremiumCurrency();
         var value:int = 0;
         if(label == null)
         {
            label = "Confirmed";
         }
         if(group == null)
         {
            group = GameMetrics.getGroupFromEvent(event);
         }
         if(true)
         {
            DCDebug.trace("-------------------------");
            DCDebug.trace("1.group: " + group);
            DCDebug.trace("1.type: " + event);
            DCDebug.trace("1.label: " + label);
            DCDebug.trace("1.product: " + product);
            DCDebug.trace("1.product_detail: " + product_detail);
            DCDebug.trace("money: " + coinsSpentForThis);
            DCDebug.trace("cash: " + cashSpentForThis);
         }
         var p:Array = new Array(4);
         if(params != null)
         {
            p[0] = params.p1;
            p[1] = params.p2;
            p[2] = params.p3;
            p[3] = params.p4;
            for(i = 0; i < 4; )
            {
               if(p[i] == undefined)
               {
                  p[i] = null;
               }
               i++;
            }
            if(params.hasOwnProperty("unique_tracking_tag"))
            {
               unique_tracking_tag = String(params.unique_tracking_tag);
            }
            if(params.hasOwnProperty("recipient_uids"))
            {
               recipient_uids = String(params.recipient_uids);
            }
            if(params.hasOwnProperty("value"))
            {
               value = int(params.value);
            }
         }
      }
      
      public static function envGetEnvironment() : int
      {
         return 0;
      }
      
      public static function envIsProduction() : Boolean
      {
         return envGetEnvironment() == 2;
      }
      
      private static function plainString(input:String) : String
      {
         var j:int = 0;
         var newString:* = "";
         for(j = 0; j < input.length; )
         {
            if(input.charAt(j) != " " && input.charAt(j) != "." && input.charAt(j) != ":")
            {
               newString += input.charAt(j);
            }
            else
            {
               newString += "_";
            }
            j++;
         }
         return newString;
      }
      
      public static function addTime(dt:int) : void
      {
         mGameTime += dt;
      }
      
      public static function getAccumulatedTime() : int
      {
         return mGameTime / 1000;
      }
      
      public static function addPremiumCurrencySpent(value:int) : void
      {
         mPremiumCurrencySpent += value;
      }
      
      public static function getPremiumCurrencySpent() : int
      {
         return mPremiumCurrencySpent;
      }
      
      public static function addGameProgressValue(value:int) : void
      {
         mGameProgressValue += value;
      }
      
      public static function getGameProgressValue() : int
      {
         return mGameProgressValue;
      }
   }
}
