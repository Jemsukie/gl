package com.dchoc.game.model.happening
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class HappeningMng extends DCComponent
   {
      
      public static const HAPPENING_CBOX:String = "cbox_happening";
       
      
      private var mHappeningsDict:Dictionary;
      
      private var mTestChangeToRunning:Boolean = false;
      
      private var mCurrentHappeningInHud:String;
      
      public function HappeningMng()
      {
         super();
         this.mCurrentHappeningInHud = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mHappeningsDict = new Dictionary(true);
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mHappeningsDict = null;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var h:XML = null;
         var happeningDefMng:HappeningDefMng = null;
         var happeningDef:HappeningDef = null;
         var happening:Happening = null;
         var key:* = null;
         var happeningXml:XML = null;
         var happeningStr:* = null;
         var found:Boolean = false;
         if(step == 0)
         {
            if(mPersistenceData != null && InstanceMng.getTopHudFacade().isBuilt() && InstanceMng.getWorld().isBuilt())
            {
               happeningDefMng = InstanceMng.getHappeningDefMng();
               for each(h in EUtils.xmlGetChildrenList(mPersistenceData,"Happening"))
               {
                  (happening = new Happening()).build(h);
                  key = EUtils.xmlReadString(h,"sku");
                  this.mHappeningsDict[key] = happening;
               }
               for each(happeningDef in happeningDefMng.getDefs())
               {
                  found = false;
                  for(key in this.mHappeningsDict)
                  {
                     if(key == happeningDef.getSku())
                     {
                        found = true;
                        break;
                     }
                  }
                  if(!found)
                  {
                     if(happeningDef.checkIsOver(InstanceMng.getApplication().getCurrentServerTimeMillis()) == false)
                     {
                        happeningStr = "<Happening sku=\"" + happeningDef.getSku() + "\" state=\"-1\" />";
                        happeningXml = EUtils.stringToXML(happeningStr);
                        (happening = new Happening()).build(happeningXml);
                        key = happeningDef.getSku();
                        this.mHappeningsDict[key] = happening;
                     }
                  }
               }
               this.hudUpdateHappeningInHud();
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         var h:Happening = null;
         if(this.mHappeningsDict != null)
         {
            for each(h in this.mHappeningsDict)
            {
               h.unbuild();
            }
            this.mHappeningsDict.length = 0;
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var happening:Happening = null;
         if(this.isRunning())
         {
            if(this.mHappeningsDict != null)
            {
               for each(happening in this.mHappeningsDict)
               {
                  happening.logicUpdate(dt);
               }
            }
         }
      }
      
      public function isActive() : Boolean
      {
         return InstanceMng.getApplication().isTutorialCompleted() && InstanceMng.getFlowState().getCurrentRoleId() == 0 && InstanceMng.getApplication().viewGetMode() == 0 && !InstanceMng.getUnitScene().battleIsRunning() && !InstanceMng.getApplication().fsmGetCurrentState().isALoadingState();
      }
      
      override public function isRunning() : Boolean
      {
         return this.isActive() && !InstanceMng.getWorld().needsToWaitForRepairingToStart();
      }
      
      public function isHappeningSkuOver(sku:String) : Boolean
      {
         var returnValue:Boolean = true;
         var happening:Happening = this.getHappening(sku);
         if(happening != null)
         {
            returnValue = happening.isOver() || happening.isCompleted();
         }
         return returnValue;
      }
      
      override public function persistenceGetData() : XML
      {
         var h:Happening = null;
         var happeningXML:XML = null;
         var XMLHappenings:XML = <Happenings/>;
         if(this.mHappeningsDict != null)
         {
            for each(h in this.mHappeningsDict)
            {
               if(h.getHappeningDef() != null)
               {
                  happeningXML = <Happening sku="{h.getHappeningDef().mSku}" state="{h.getState()}"/>;
                  if(h.getHappeningType() != null)
                  {
                     happeningXML.appendChild(h.getHappeningType().persistenceGetData());
                  }
                  XMLHappenings.appendChild(happeningXML);
               }
            }
         }
         return XMLHappenings;
      }
      
      public function isHappeningInHud(happeningSku:String) : Boolean
      {
         if(this.mCurrentHappeningInHud == null)
         {
            return true;
         }
         return this.mCurrentHappeningInHud == happeningSku;
      }
      
      public function getHappeningInHud() : Happening
      {
         if(this.mCurrentHappeningInHud)
         {
            return this.mHappeningsDict[this.mCurrentHappeningInHud];
         }
         return null;
      }
      
      public function getHappeningInHudSku() : String
      {
         return this.mCurrentHappeningInHud;
      }
      
      public function getHappeningInHudDef() : HappeningDef
      {
         if(this.mCurrentHappeningInHud)
         {
            return this.mHappeningsDict[this.mCurrentHappeningInHud].getHappeningDef();
         }
         return null;
      }
      
      private function hudUpdateHappeningInHud() : void
      {
         var min:Number = NaN;
         var def:HappeningDef = null;
         var h:Happening = null;
         if(this.mHappeningsDict != null)
         {
            min = 1.7976931348623157e+308;
            for each(h in this.mHappeningsDict)
            {
               def = h.getHappeningDef();
               if(h.getState() != 4 && (h.getState() != -1 || InstanceMng.getFlowStatePlanet().isTutorialRunning()) && h.getState() != 6 && def != null && def.validDateGetStartMillis() < min)
               {
                  min = def.validDateGetStartMillis();
                  this.mCurrentHappeningInHud = def.mSku;
               }
            }
         }
      }
      
      public function hudRemoveCurrentHappening() : void
      {
         this.mCurrentHappeningInHud = null;
         this.hudUpdateHappeningInHud();
         if(this.mCurrentHappeningInHud != null)
         {
            this.getHappening(this.mCurrentHappeningInHud).viewEnterState();
         }
      }
      
      public function hudSetHappeningIcon(happeningSku:String) : void
      {
         this.mCurrentHappeningInHud = happeningSku;
         InstanceMng.getUIFacade().showHappeningIcon();
         if(happeningSku.indexOf("winter") > -1)
         {
            InstanceMng.getTopHudFacade().showHudElement("happening_hud_mask");
         }
         InstanceMng.getTopHudFacade().updateContestToolButtonIcon();
      }
      
      public function hudRemoveHappeningIcon() : void
      {
         InstanceMng.getUIFacade().hideHappeningIcon();
      }
      
      public function guiOpenHalloweenPopup() : DCIPopup
      {
         var giftTypes:Array = null;
         var o:Object = null;
         var notification:String = null;
         var happeningState:int;
         var currentHappening:Happening;
         switch(happeningState = (currentHappening = this.mHappeningsDict[this.mCurrentHappeningInHud]).getState())
         {
            case 0:
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningCountdown");
               break;
            case 1:
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningStartIntro");
               break;
            case 2:
               giftTypes = ["birthday","winter"];
               if(currentHappening.getHappeningType().getState() == 0 || giftTypes.indexOf(currentHappening.getHappeningDef().getType()) > -1)
               {
                  notification = "NotifyHappeningTypeWaveCountdown";
               }
               else
               {
                  notification = "NotifyHappeningEnterRunning";
               }
               (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup",notification)).happeningSku = this.mCurrentHappeningInHud;
               o.happeningTypeDef = currentHappening.getHappeningType().getHappeningTypeDef();
               break;
            case 3:
               (o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningShowFinalReward")).happeningSku = this.mCurrentHappeningInHud;
               o.canShare = false;
               break;
            default:
               return null;
         }
         var eventSku:String = InstanceMng.getHappeningMng().getHappeningInHudSku();
         o.happeningDef = InstanceMng.getHappeningDefMng().getDefBySku(eventSku);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,false);
         return null;
      }
      
      public function guiOpenHappeningInitialKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningInitialKitPopup(happeningDef);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenHappeningAntiZombieKitPopup(happeningDef:HappeningDef) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningAntiZombieKitPopup(happeningDef);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenHappeningReadyToStartPopup(happening:Happening, e:Object) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningReadyToStartPopup(happening,e.waves,e.canSkipHappening);
         popup.setEvent(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenHappeningWaveResultPopup(happening:Happening, e:Object) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningWaveResultPopup(happening);
         popup.setEvent(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenHappeningSkipHappeningPopup(happening:Happening, e:Object) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningSkipEventPopup(happening);
         popup.setEvent(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenHappeningEndEventPopup(happening:Happening, e:Object) : DCIPopup
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHappeningEndEventPopup(happening,e.canShare);
         popup.setEvent(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
         return popup;
      }
      
      public function getHappening(happeningSku:String) : Happening
      {
         if(this.mHappeningsDict != null)
         {
            return this.mHappeningsDict[happeningSku];
         }
         return null;
      }
      
      public function createHappeningTooltip(dsp:*, title:String, text:String, text2:String) : void
      {
         var tooltipText:String = text + "\n\n" + text2;
      }
   }
}
