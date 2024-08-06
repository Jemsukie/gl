package com.dchoc.toolkit.services.advertising
{
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   
   public class DCAdsManager extends DCComponent
   {
      
      public static const VIDEO_COMPLETED:String = "videoAdCompleted";
      
      public static const VIDEO_CANCELLED:String = "videoAdCancelled";
      
      public static const VIDEO_PLAY:String = "videoAdPlay";
      
      public static const VIDEO_READY:String = "videoAdReady";
      
      public static const VIDEO_REMOVE_ICON:String = "videoRemoveIcon";
      
      public static const CHECK_INGAME_AD:String = "checkInGameAd";
      
      protected static var mAllowInstance:Boolean;
      
      private static var mInstance:DCAdsManager = null;
       
      
      protected var mSubscribers:Vector.<DCComponent>;
      
      protected var adIconOnClickFunctionName:String;
      
      private var SPIL_AD_ENABLED:Boolean;
      
      private var mSpilAdIsOn:Boolean;
      
      private var mSpilAdNeedsToRequestAd:Boolean = false;
      
      private var mSpilAdAPIReady:Boolean = false;
      
      public function DCAdsManager()
      {
         this.mSubscribers = new Vector.<DCComponent>(0);
         this.SPIL_AD_ENABLED = Config.useSpilAd();
         super();
         if(!DCAdsManager.mAllowInstance)
         {
            throw new Error("ERROR: DCAdsManager Error: Instantiation failed: Use DCAdsManager.getInstance() instead of new.");
         }
      }
      
      public static function getInstance() : DCAdsManager
      {
         if(mInstance == null)
         {
            mAllowInstance = true;
            mInstance = new DCAdsManager();
            mAllowInstance = false;
         }
         return mInstance;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.spilAdLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         mInstance = null;
         if(this.mSubscribers != null)
         {
            this.mSubscribers.length = 0;
         }
         this.adIconOnClickFunctionName = null;
         mAllowInstance = false;
         this.spilAdUnload();
      }
      
      public function adsReady(ready:Boolean, functionName:String) : void
      {
         var i:int = 0;
         DCDebug.traceCh("ad","adsReady " + ready + " functionName = " + functionName);
         var message:Object;
         (message = {}).message = ready ? "videoAdReady" : "videoRemoveIcon";
         message.enable = ready ? true : false;
         this.adIconOnClickFunctionName = functionName;
         for(i = 0; i < this.mSubscribers.length; )
         {
            this.mSubscribers[i].notify(message);
            i++;
         }
         var params:Dictionary;
         (params = new Dictionary())["enable"] = ready;
         if(ready)
         {
            MessageCenter.getInstance().sendMessage("videoReady",params);
         }
         else
         {
            MessageCenter.getInstance().sendMessage("videoRemoveIcon",params);
         }
      }
      
      public function videoCancelled() : void
      {
         var i:int = 0;
         DCDebug.traceCh("ad","videoCancelled");
         for(i = 0; i < this.mSubscribers.length; )
         {
            this.mSubscribers[i].notify({"message":"videoAdCancelled"});
            i++;
         }
         MessageCenter.getInstance().sendMessage("videoCancelled");
         ExternalInterface.call("checkInGameAd");
      }
      
      public function callVideoAd(e:Event) : void
      {
         var message:Object = null;
         var i:int = 0;
         if(this.adIconOnClickFunctionName != null && ExternalInterface.available)
         {
            message = {};
            message.message = "videoAdPlay";
            for(i = 0; i < this.mSubscribers.length; )
            {
               this.mSubscribers[i].notify(message);
               i++;
            }
            ExternalInterface.call(this.adIconOnClickFunctionName);
         }
      }
      
      public function videoCompleted(sku:String = "") : void
      {
         var i:int = 0;
         if(sku == null || sku == "")
         {
            sku = "3";
         }
         DCDebug.traceCh("ad","videoCompleted");
         for(i = 0; i < this.mSubscribers.length; )
         {
            this.mSubscribers[i].notify({
               "message":"videoAdCompleted",
               "itemSku":sku
            });
            i++;
         }
         MessageCenter.getInstance().sendMessage("videoCompleted");
         ExternalInterface.call("checkInGameAd");
      }
      
      public function subscribe(object:DCComponent) : void
      {
         DCDebug.traceCh("ad","subscribe " + object);
         if(this.mSubscribers.lastIndexOf(object) == -1)
         {
            this.mSubscribers.push(object);
         }
      }
      
      public function unsubscribe(object:DCComponent) : void
      {
         DCDebug.traceCh("ad","unsubscribe " + object);
         var index:int = this.mSubscribers.lastIndexOf(object);
         if(index != -1)
         {
            this.mSubscribers.splice(index,1);
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         return false;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         DCDebug.traceCh("ad","DCAdsManager::buildDoSyncStep - Step: " + step + " available = " + ExternalInterface.available);
         if(ExternalInterface.available)
         {
            DCDebug.traceCh("ad","ExternalInterface Available");
            ExternalInterface.addCallback("videoAdAvailableResponse",this.adsReady);
            ExternalInterface.addCallback("videoAdCompleteResponse",this.videoCompleted);
            ExternalInterface.addCallback("videoAdIncompleteResponse",this.videoCancelled);
         }
         buildAdvanceSyncStep();
      }
      
      override protected function unbuildDo() : void
      {
         DCDebug.traceCh("ad","DCAdsManager::unbuildDo");
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("videoAdAvailableResponse",null);
            ExternalInterface.addCallback("videoAdCompleteResponse",null);
            ExternalInterface.addCallback("videoAdIncompleteResponse",null);
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mSpilAdAPIReady && this.mSpilAdNeedsToRequestAd)
         {
            DCDebug.traceCh("ad","Checking if game is ready for ad...");
            if(this.isTheGameReadyForAnAd() && !InstanceMng.getApplication().isLoading())
            {
               this.spilAdRequestAd();
               this.spilAdSetNeedsToRequestAd(false);
            }
         }
      }
      
      public function isTheGameReadyForAnAd() : Boolean
      {
         return DCInstanceMng.getInstance().getApplication().isTutorialCompleted() && !InstanceMng.getUnitScene().battleIsRunning() && !InstanceMng.getUIFacade().blackStripsAreActive();
      }
      
      private function spilAdSetEnabled(value:Boolean) : void
      {
         this.SPIL_AD_ENABLED = value;
      }
      
      private function spilAdUnload() : void
      {
         var stage:Stage = null;
         if(this.mSpilAdIsOn)
         {
            stage = InstanceMng.getApplication().stageGetStage().getImplementation();
            this.mSpilAdIsOn = false;
         }
         this.spilAdSetNeedsToRequestAd(false);
      }
      
      private function spilAdLoad() : void
      {
         var thisStage:Stage = null;
         this.mSpilAdIsOn = this.SPIL_AD_ENABLED;
         this.mSpilAdAPIReady = false;
         if(this.mSpilAdIsOn)
         {
            DCDebug.traceCh("spilAd","loading API...");
            this.mSpilAdIsOn = true;
            thisStage = InstanceMng.getApplication().stageGetStage().getImplementation();
            ExternalInterface.call("initializeAds");
            this.spilAdOnAPIReady(null);
         }
      }
      
      public function spilAdSetNeedsToRequestAd(value:Boolean) : void
      {
         if(value)
         {
            if(this.spilAdIsAllowedInCurrentGameMode())
            {
               if(!this.mSpilAdIsOn)
               {
                  DCDebug.traceCh("spilAd","forcing load API...");
                  this.spilAdSetEnabled(true);
                  this.spilAdLoad();
               }
               DCDebug.traceCh("spilAd","needs to request...");
            }
            else
            {
               value = false;
            }
         }
         this.mSpilAdNeedsToRequestAd = value;
      }
      
      private function spilAdOnAPIReady(e:Event) : void
      {
         DCDebug.traceCh("spilAd","API is ready...");
         this.mSpilAdAPIReady = true;
      }
      
      private function spilAdRequestAd() : void
      {
         DCDebug.traceCh("spilAd","requesting ad...");
      }
      
      private function spilAdPauseGame() : void
      {
         var str:* = "spilAdPauseGame:";
         str += " ad available so pause game...";
         InstanceMng.getApplication().setToWindowedMode();
         InstanceMng.getApplication().pauseGame();
         DCDebug.traceCh("spilAd",str);
      }
      
      private function spilAdResumeGame() : void
      {
         DCDebug.traceCh("spilAd","spilAdResumeGame...");
         InstanceMng.getApplication().resumeGame();
      }
      
      private function spilAdIsAllowedInCurrentGameMode() : Boolean
      {
         var role:Role = InstanceMng.getRole();
         return role != null && role.mId == 0 && InstanceMng.getApplication().viewGetMode() == 0;
      }
   }
}
