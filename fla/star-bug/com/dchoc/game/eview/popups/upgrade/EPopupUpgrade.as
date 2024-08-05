package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.DisplayObjectContainer;
   
   public class EPopupUpgrade extends EGamePopup
   {
      
      private static const BODY:String = "Body";
      
      public static const NOTIFY_LOAD_UNITS_SELECTION:String = "NotifyLoadUnitsSelection";
      
      public static const NOTIFY_UNIT_SELECTED:String = "NotifyUnitSelected";
      
      public static const NOTIFY_START_UPGRADE:String = "NotifyStartUpgrade";
       
      
      private var mBodyInfo:ELayoutArea;
      
      private var mBodySelectUnit:ELayoutArea;
      
      private var mHasToReloadUnits:Boolean;
      
      private var mHasToLoadInfoUnit:Boolean;
      
      private var mGameUnit:GameUnit;
      
      private var mTabsArea:ELayoutArea;
      
      public function EPopupUpgrade()
      {
         super();
      }
      
      public function setupUpgrade(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         setup(popupId,viewFactory,skinId);
         this.setupBkg();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mBodyInfo = null;
         this.mBodySelectUnit = null;
         this.mTabsArea = null;
      }
      
      protected function setupBkg() : void
      {
         var unit:GameUnit = null;
         var wio:WorldItemObject = null;
         var wioDef:WorldItemDef = null;
         var eventItemDef:Object = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         var bkg:EImage = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         setCloseButton(closeButton);
         bkg.eAddChild(closeButton);
         closeButton.eAddEventListener("click",this.onCloseButton);
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            mViewFactory.removeButtonBehaviors(closeButton);
         }
         var title:ETextField;
         (title = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_header")).setText(DCTextMng.getText(205));
         setTitle(title);
         bkg.eAddChild(title);
         this.mBodySelectUnit = layoutFactory.getArea("body");
         layoutFactory = mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter");
         this.mTabsArea = layoutFactory.getArea("tab");
         this.mBodyInfo = layoutFactory.getArea("body");
         var event:Object;
         if((event = getEvent()) != null)
         {
            if(event["unit"] != null)
            {
               unit = event["unit"];
            }
            if(event["item"] != null)
            {
               wio = event["item"];
            }
            if(event["itemDef"] != null)
            {
               if((eventItemDef = event["itemDef"]) is WorldItemDef)
               {
                  wioDef = eventItemDef as WorldItemDef;
               }
            }
         }
         if(unit != null)
         {
            this.loadUnitInfo(unit);
         }
         else if(wio != null)
         {
            this.loadBuildingInfo(wio);
         }
         else if(wioDef != null)
         {
            this.loadBuildingInfo(wioDef);
         }
         else
         {
            this.loadUnitsBody();
         }
      }
      
      public function loadUnitsBody() : void
      {
         var bkg:ESprite = getBackground();
         this.removeOldBody();
         var newBody:UpgradeBodySelectUnit = new UpgradeBodySelectUnit(this,mSkinSku,mViewFactory);
         newBody.setup();
         bkg.eAddChild(newBody);
         setContent("Body",newBody);
         newBody.layoutApplyTransformations(this.mBodySelectUnit);
      }
      
      public function loadUnitInfo(unit:GameUnit) : void
      {
         var bkg:ESprite = getBackground();
         this.removeOldBody();
         var newBody:UpgradeBodyInfoGameUnit = new UpgradeBodyInfoGameUnit(this,mViewFactory,mSkinSku);
         bkg.eAddChild(newBody);
         newBody.setup(unit);
         setContent("Body",newBody);
         newBody.layoutApplyTransformations(this.mBodyInfo);
      }
      
      public function loadBuildingInfo(wio:*) : void
      {
         var bkg:ESprite = getBackground();
         this.removeOldBody();
         var newBody:UpgradeBodyInfoWIO = new UpgradeBodyInfoWIO(this,mViewFactory,mSkinSku);
         bkg.eAddChild(newBody);
         newBody.setup(wio);
         setContent("Body",newBody);
         newBody.layoutApplyTransformations(this.mBodyInfo);
      }
      
      private function removeOldBody() : void
      {
         var unitsBody:ESprite = getContent("Body");
         var bkg:ESprite = getBackground();
         if(unitsBody != null)
         {
            if(bkg.contains(unitsBody))
            {
               bkg.eRemoveChild(unitsBody);
            }
            unitsBody.destroy();
            unitsBody = null;
            setContent("Body",null);
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var body:ESprite = null;
         switch(e.cmd)
         {
            case "NotifyLoadUnitsSelection":
               this.mHasToReloadUnits = true;
               return true;
            case "NotifyUnitSelected":
               this.mHasToLoadInfoUnit = true;
               this.mGameUnit = e.unit;
               return true;
            case "NotifyStartUpgrade":
               body = getContent("Body");
               UpgradeBodyInfoGameUnit(body).startUpgradeActivate(e.transaction);
               return true;
            default:
               super.notify(e);
               return false;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mHasToReloadUnits)
         {
            this.mHasToReloadUnits = false;
            this.loadUnitsBody();
         }
         if(this.mHasToLoadInfoUnit)
         {
            this.mHasToLoadInfoUnit = false;
            this.loadUnitInfo(this.mGameUnit);
         }
         var body:ESprite = getContent("Body");
         if(body != null)
         {
            body.logicUpdate(dt);
         }
      }
      
      public function getTabArea() : ELayoutArea
      {
         return this.mTabsArea;
      }
      
      public function getInstantBuildButton() : DisplayObjectContainer
      {
         var body:UpgradeBody = getContent("Body") as UpgradeBody;
         return body.getInstantBuildButton();
      }
      
      private function onCloseButton(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
         var event:Object = getEvent();
         if(event != null)
         {
            event.button = "EventCloseButtonPressed";
            event.phase = "OUT";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
         }
      }
   }
}
