package com.dchoc.game.controller.gui.popups
{
   import com.dchoc.game.controller.ActionsLibrary;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.CustomizerMng;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.customizer.DCCustomizerButtonDef;
   import com.dchoc.toolkit.core.customizer.DCCustomizerPopupDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.events.EEvent;
   
   public class WelcomePopupsMng extends DCComponent
   {
      
      private static var smCustomizerMng:CustomizerMng;
      
      private static var smPopupMng:PopupMng;
       
      
      private var mHasPopupOpened:Boolean;
      
      private var mCheckStartNow:Boolean;
      
      private var mGUICurrentDef:DCCustomizerPopupDef;
      
      public function WelcomePopupsMng()
      {
         super();
         if(smCustomizerMng == null)
         {
            smCustomizerMng = InstanceMng.getCustomizerMng();
         }
         this.mCheckStartNow = Config.useStartNow();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function unloadDo() : void
      {
         smCustomizerMng = null;
         smPopupMng = null;
         this.guiUnload();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         super.buildDoSyncStep(step);
         if(smPopupMng == null)
         {
            smPopupMng = InstanceMng.getPopupMng();
         }
         if(smCustomizerMng.isBuilt() && smPopupMng.isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt() && !InstanceMng.getApplication().isLoading())
         {
            buildAdvanceSyncStep();
         }
      }
      
      public function hasPopupOpened() : Boolean
      {
         return this.mHasPopupOpened;
      }
      
      override protected function beginDo() : void
      {
         if(!InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted())
         {
            smCustomizerMng.skipWelcomePopups();
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(smCustomizerMng.amountWelcomePopups() > 0 && !this.mHasPopupOpened)
         {
            this.mHasPopupOpened = this.guiOpenWelcomePopup(smCustomizerMng.getNextWelcomePopup());
         }
         else if(this.mCheckStartNow && smCustomizerMng.amountWelcomePopups() == 0 && !this.mHasPopupOpened && this.haveToShowStartNowPopup())
         {
            InstanceMng.getNotificationsMng().guiOpenStartNowPopup();
         }
      }
      
      private function parseAction(action:String) : Function
      {
         var fn:Function = null;
         switch(action)
         {
            case "followLink":
               fn = this.followLink;
               break;
            case ActionsLibrary.ACTION_OPEN_FREE_GIFT:
            case ActionsLibrary.ACTION_OPEN_INVITE_TAB:
               fn = this.callTask;
               break;
            case "openChipsPopup":
            case "highlightAlliancesButton":
            case "goToContest":
               fn = this.doAction;
               break;
            case "openInventory":
               fn = InstanceMng.getItemsMng().guiOpenInventoryPopup;
               break;
            case "goToPremiumShop":
            case "goToShop":
               fn = this.openPremiumShop;
         }
         return fn;
      }
      
      private function doAction() : void
      {
         var action:String = this.getAction(this.mGUICurrentDef);
         if(action != null)
         {
            InstanceMng.getActionsLibrary().launchAction(action);
         }
      }
      
      private function followLink() : void
      {
         var buttonDef:DCCustomizerButtonDef = null;
         var url:String = null;
         var action:String = this.getAction(this.mGUICurrentDef);
         if(action != null)
         {
            buttonDef = this.getButtonDef(this.mGUICurrentDef);
            if(buttonDef != null)
            {
               url = buttonDef.getParam("url");
               InstanceMng.getActionsLibrary().launchAction(action,{"url":url});
            }
         }
      }
      
      private function callTask() : void
      {
         var pendingTask:* = null;
         var action:String = this.getAction(this.mGUICurrentDef);
         if(action != null)
         {
            pendingTask = action;
            InstanceMng.getActionsLibrary().launchAction(action,{"task":pendingTask});
         }
      }
      
      private function openPremiumShop() : void
      {
         var buttonDef:DCCustomizerButtonDef = null;
         var params:Object = null;
         var tabStr:String = null;
         var itemStr:String = null;
         var action:String = this.getAction(this.mGUICurrentDef);
         if(action != null)
         {
            buttonDef = this.getButtonDef(this.mGUICurrentDef);
            params = {};
            if(buttonDef != null)
            {
               tabStr = buttonDef.getParam("tab");
               if(tabStr != null)
               {
                  params.tab = tabStr;
               }
               if((itemStr = buttonDef.getParam("item")) != null)
               {
                  params.item = itemStr;
               }
            }
            InstanceMng.getActionsLibrary().launchAction(action,params);
         }
      }
      
      private function getButtonDef(def:DCCustomizerPopupDef) : DCCustomizerButtonDef
      {
         var returnValue:DCCustomizerButtonDef = null;
         if(def != null)
         {
            returnValue = def.getButton();
         }
         return returnValue;
      }
      
      private function getAction(def:DCCustomizerPopupDef) : String
      {
         var buttonDef:DCCustomizerButtonDef = null;
         var returnValue:String = null;
         if(def != null)
         {
            buttonDef = this.getButtonDef(def);
            if(buttonDef != null)
            {
               returnValue = buttonDef.getAction();
            }
         }
         return returnValue;
      }
      
      private function guiUnload() : void
      {
         this.mGUICurrentDef = null;
      }
      
      private function guiOpenWelcomePopup(def:DCCustomizerPopupDef) : Boolean
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         this.mGUICurrentDef = def;
         var returnValue:Boolean = false;
         if(this.mGUICurrentDef != null)
         {
            popup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getWelcomePopup(def,this.guiOnAccept,this.guiOnClose);
            popup.setIsStackable(true);
            popup.setPopupType("PopupWelcome");
            returnValue = uiFacade.enqueuePopup(popup,true,true,true,true);
         }
         return returnValue;
      }
      
      private function guiOnAccept(e:EEvent = null) : void
      {
         var action:String = null;
         var f:Function = null;
         if(this.mGUICurrentDef != null)
         {
            action = this.getAction(this.mGUICurrentDef);
            f = this.parseAction(action);
            if(f != null)
            {
               f();
            }
            this.guiOnClose();
         }
      }
      
      public function guiOnClose(e:EEvent = null) : void
      {
         InstanceMng.getPopupMng().closeCurrentPopup();
         this.mGUICurrentDef = null;
         this.mHasPopupOpened = false;
      }
      
      private function haveToShowStartNowPopup() : Boolean
      {
         var popupTimeOver:Number = NaN;
         var currentMS:Number = NaN;
         var nextTimeOver:Number = NaN;
         this.mCheckStartNow = false;
         var flashVars:Object = Star.getFlashVars();
         if(flashVars.hasOwnProperty("startNow") && flashVars["startNow"] == "true")
         {
            popupTimeOver = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetStartNowPopupTimeOver();
            currentMS = InstanceMng.getApplication().getCurrentServerTimeMillis();
            if(popupTimeOver <= currentMS)
            {
               nextTimeOver = currentMS + InstanceMng.getSettingsDefMng().getStartNowReminderRecurrenceTime();
               InstanceMng.getUserInfoMng().getProfileLogin().flagsSetStartNowPopupTimeOver(nextTimeOver);
               return popupTimeOver != 0;
            }
         }
         return false;
      }
   }
}
