package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EUnitItemShipyardBarView;
   import com.dchoc.game.eview.widgets.hud.EUnitItemViewShipyardBarTraining;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.game.view.dc.gui.components.ShipyardQueuedElement;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.gskinner.motion.GTween;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import flash.utils.Dictionary;
   
   public class ShipyardBarFacade extends GUIBar implements INotifyReceiver
   {
      
      private static const NUM_ITEMS:int = 6;
      
      private static const NUM_TRAINING_SLOTS:int = 5;
      
      private static const AREA_BKG:String = "container_hud_bottom";
      
      private static const AREA_BKG_TRAINING:String = "area_training";
      
      private static const BUTTON_CLOSE:String = "btn_close";
      
      private static const ARROW_LEFT:String = "btn_arrow_left";
      
      private static const ARROW_RIGHT:String = "btn_arrow_right";
      
      private static const ARROW_LEFT_BUILDING:String = "btn_arrow_left_building";
      
      private static const ARROW_RIGHT_BUILDING:String = "btn_arrow_right_building";
      
      private static const AREA_UNIT_SHIP_PREFIX:String = "area_";
      
      private static const AREA_UNIT_TRAIN_PREFIX:String = "container_train_";
      
      private static const TEXT_TRAIN_MORE_UNITS:String = "text_title";
      
      private static const AREA_C0_BGK:String = "container_trainning";
      
      private static const BTN_CURRENT_UNIT_CANCEL:String = "btn_close_s";
      
      private static const BAR_CURRENT_UNIT:String = "bar";
      
      private static const TXT_CURRENT_UNIT_TIME_LEFT:String = "text_timer";
      
      private static const WARNING_BOX:String = "warning_stripe";
      
      private static const USE_AUTO_DECREMENT:Boolean = true;
       
      
      private var mResourcesInfo:Vector.<DCDef>;
      
      private var mShipyardQueuedElements:Vector.<ShipyardQueuedElement>;
      
      private var mShipyardControllerRef:ShipyardController;
      
      private var mPage:int;
      
      private var mViewFactory:ViewFactory;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mCanvasBottom:ESpriteContainer;
      
      private var mWarningText:ETextField;
      
      private var mContentHolders:Dictionary;
      
      private var mIsTransitioning:Boolean = false;
      
      public function ShipyardBarFacade()
      {
         super("shop_ships_menu");
         this.mContentHolders = new Dictionary();
      }
      
      public function getName() : String
      {
         return "EShipBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["uiUnlockElement","uiLockElement","putTutorialCircle"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var name:String = null;
         var component:ESprite = null;
         switch(task)
         {
            case "putTutorialCircle":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
               }
               break;
            case "uiUnlockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  this.setComponentMouseEvents(component,true);
               }
               break;
            case "uiLockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  this.setComponentMouseEvents(component,false);
               }
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 5;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var s:ESprite = null;
         var btn:EButton = null;
         var i:int = 0;
         var barArea:ELayoutArea = null;
         var txt:ETextField = null;
         var shipUnitView:EUnitItemShipyardBarView = null;
         var trainingUnitView:EUnitItemViewShipyardBarTraining = null;
         switch(step)
         {
            case 0:
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvasBottom = this.mViewFactory.getESpriteContainer();
               this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomShop");
               this.mShipyardControllerRef = InstanceMng.getShipyardController();
               buildAdvanceSyncStep();
               break;
            case 1:
               s = this.mViewFactory.getEImage("skin_ui_hud_area_bottom",null,false,this.mLayoutAreaFactory.getArea("container_hud_bottom"));
               s.name = "container_hud_bottom";
               this.addHudElement("container_hud_bottom",s,this.mCanvasBottom,false);
               s = this.mViewFactory.getEImage("tab_bkg_hud",null,false,this.mLayoutAreaFactory.getArea("area_training"));
               s.name = "area_training";
               this.addHudElement("area_training",s,this.mCanvasBottom,false);
               (btn = this.mViewFactory.getButtonClose(null,this.mLayoutAreaFactory.getArea("btn_close"))).name = "btn_close";
               btn.eAddEventListener("click",this.onCloseClick);
               this.addHudElement("btn_close",btn,this.mCanvasBottom,true);
               buildAdvanceSyncStep();
               break;
            case 2:
               this.addArrowButton("btn_arrow_left","btn_arrow",this.onLeftClick);
               this.addArrowButton("btn_arrow_right","btn_arrow",this.onRightClick);
               this.addArrowButton("btn_arrow_left_building","btn_building_arrow",this.onLeftClickBuilding);
               this.addArrowButton("btn_arrow_right_building","btn_building_arrow",this.onRightClickBuilding);
               for(i = 0; i < 6; )
               {
                  (shipUnitView = new EUnitItemShipyardBarView()).build();
                  shipUnitView.name = "area_" + i;
                  shipUnitView.setLayoutArea(this.mLayoutAreaFactory.getArea("area_" + i),true);
                  this.addHudElement("area_" + i,shipUnitView,this.mCanvasBottom,true);
                  i++;
               }
               buildAdvanceSyncStep();
               break;
            case 3:
               s = this.mViewFactory.getEImage("circle",null,false,this.mLayoutAreaFactory.getArea("container_trainning"));
               this.addHudElement("container_trainning_BKG",s,this.mCanvasBottom,false);
               s = this.mViewFactory.getEImage("no_texture",null,false,this.mLayoutAreaFactory.getArea("container_trainning"));
               this.addHudElement("container_trainning",s,this.mCanvasBottom,false);
               barArea = this.mLayoutAreaFactory.getArea("bar");
               s = this.mViewFactory.createFillBar(0,barArea.width,barArea.height,0,"color_fill_bkg");
               s.setLayoutArea(barArea,true);
               this.addHudElement("bar_BKG",s,this.mCanvasBottom,false);
               s = this.mViewFactory.createFillBar(1,barArea.width,barArea.height,100,"color_score");
               s.setLayoutArea(barArea,true);
               this.addHudElement("bar",s,this.mCanvasBottom,false);
               txt = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_timer"),"text_title_3");
               txt.setText("00.00.00");
               this.addHudElement("text_timer",txt,this.mCanvasBottom,false);
               for(i = 0; i < 5; )
               {
                  (trainingUnitView = new EUnitItemViewShipyardBarTraining()).build();
                  trainingUnitView.name = "container_train_" + i;
                  trainingUnitView.setLayoutArea(this.mLayoutAreaFactory.getArea(trainingUnitView.name),true);
                  this.addHudElement(trainingUnitView.name,trainingUnitView,this.mCanvasBottom,false);
                  i++;
               }
               btn = this.mViewFactory.getButtonClose(null,this.mLayoutAreaFactory.getArea("btn_close_s"));
               if(true)
               {
                  btn.eAddEventListener("mouseDown",this.onStartCancelUnit);
                  btn.eAddEventListener("mouseUp",this.onEndCancelUnit);
                  btn.eAddEventListener("rollOut",this.onEndCancelUnit);
               }
               else
               {
                  btn.eAddEventListener("click",this.onCurrentCancelClicked);
               }
               this.addHudElement("btn_close_s",btn,this.mCanvasBottom,false);
               buildAdvanceSyncStep();
               break;
            case 4:
               txt = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_title"),"text_title_3");
               txt.setText(DCTextMng.getText(692));
               this.addHudElement("text_title",txt,this.mCanvasBottom,false);
               s = this.mViewFactory.getWarningStripe(null,"icon_warning","box_negative","...","text_light_negative",this.mLayoutAreaFactory.getArea("warning_stripe"));
               this.mWarningText = ESpriteContainer(s).getContentAsETextField("text_info");
               this.addHudElement("warning_stripe",s,this.mCanvasBottom,false);
               buildAdvanceSyncStep();
         }
      }
      
      private function addArrowButton(layoutId:String, resourceId:String, fun:Function) : void
      {
         var btn:EButton;
         (btn = this.mViewFactory.getButtonImage(resourceId,null,this.mLayoutAreaFactory.getArea(layoutId))).name = layoutId;
         if(fun != null)
         {
            btn.eAddEventListener("click",fun);
         }
         this.addHudElement(layoutId,btn,this.mCanvasBottom,true);
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
            s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
            s.eAddEventListener("rollOver",this.onMouseOverBtn);
            s.eAddEventListener("rollOut",this.onMouseOutBtn);
         }
         s.eAddEventListener("rollOver",uiEnable);
         s.eAddEventListener("rollOut",uiDisable);
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      override protected function beginDo() : void
      {
         MessageCenter.getInstance().registerObject(this);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         this.mCanvasBottom.logicY = this.mCanvasBottom.logicY;
         setVisible(true);
         this.moveDisappearUpToDown(0.01);
      }
      
      override protected function unbuildDo() : void
      {
         var id:* = null;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mCanvasBottom.destroy();
      }
      
      override protected function endDo() : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
         MessageCenter.getInstance().unregisterObject(this);
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
         if(isVisible() && this.mShipyardControllerRef)
         {
            this.reloadLayoutView();
         }
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      public function reload() : void
      {
         this.openShipyardBar();
      }
      
      public function openShipyardBar() : void
      {
         this.mResourcesInfo = this.mShipyardControllerRef.getShipsInfo();
         this.mShipyardQueuedElements = this.mShipyardControllerRef.getCurrentShipyard().getQueuedElements();
         this.reloadLayoutView();
         this.reloadView();
         this.reloadQueuedElements();
      }
      
      private function loadResources(page:int) : void
      {
         this.mPage = page;
         this.reloadView();
      }
      
      private function reloadLayoutView() : void
      {
         var element:ShipyardQueuedElement = null;
         var timeLeft:Number = NaN;
         var totalTime:Number = NaN;
         if(this.mShipyardControllerRef.getCurrentShipyard() && this.mShipyardControllerRef.getCurrentShipyard().isProducing())
         {
            element = this.mShipyardQueuedElements[0];
            timeLeft = element.getTimeLeft();
            if(timeLeft < 0)
            {
               timeLeft = 0;
            }
            totalTime = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(element.getElementSku()).mDef.getConstructionTime();
            this.mViewFactory.setTextureToImage(element.getInfoIcon(),null,this.getHudElement("container_trainning") as EImage);
            this.getHudElement("container_trainning").visible = true;
            this.getHudElement("container_trainning_BKG").visible = true;
            this.getHudElement("bar_BKG").visible = true;
            this.getHudElement("btn_close_s").visible = true;
            this.getHudElement("bar").visible = true;
            (this.getHudElement("bar") as EFillBar).setMaxValue(totalTime);
            (this.getHudElement("bar") as EFillBar).setValue(totalTime - timeLeft);
            this.getHudElement("text_timer").visible = true;
            (this.getHudElement("text_timer") as ETextField).setText(DCTextMng.convertTimeToStringColon(timeLeft).toString());
            this.getHudElement("text_title").visible = false;
         }
         else
         {
            this.getHudElement("btn_close_s").visible = false;
            this.getHudElement("container_trainning").visible = false;
            this.getHudElement("bar").visible = false;
            this.getHudElement("container_trainning_BKG").visible = false;
            this.getHudElement("bar_BKG").visible = false;
            this.getHudElement("text_timer").visible = false;
            this.getHudElement("text_title").visible = true;
         }
      }
      
      private function reloadView() : void
      {
         var i:int = 0;
         this.checkArrows();
         if(this.mResourcesInfo != null)
         {
            i = 0;
            while(i < 6 && i + this.mPage * 6 < this.mResourcesInfo.length)
            {
               (this.getHudElement("area_" + i) as EUnitItemShipyardBarView).fillData([this.mResourcesInfo[this.mPage * 6 + i]]);
               this.getHudElement("area_" + i).visible = true;
               i++;
            }
            while(i < 6)
            {
               this.getHudElement("area_" + i).visible = false;
               i++;
            }
         }
      }
      
      private function reloadQueuedElements() : void
      {
         var i:int = 0;
         var element:EUnitItemViewShipyardBarTraining = null;
         for(i = 0; i < this.mShipyardQueuedElements.length; )
         {
            element = this.getHudElement("container_train_" + i) as EUnitItemViewShipyardBarTraining;
            element.fillData([this.mShipyardQueuedElements[i]]);
            i++;
         }
      }
      
      private function checkArrows() : void
      {
         this.setEnabledAndVisible("btn_arrow_left",this.mPage > 0);
         this.setEnabledAndVisible("btn_arrow_right",(this.mPage + 1) * 6 < this.mResourcesInfo.length - 1);
         var canCycleBuildings:* = InstanceMng.getShipyardController().getAllShipyardIds().length > 1;
         this.setEnabledAndVisible("btn_arrow_left_building",canCycleBuildings);
         this.setEnabledAndVisible("btn_arrow_right_building",canCycleBuildings);
      }
      
      private function setEnabledAndVisible(areaName:String, val:Boolean) : void
      {
         var btn:EButton = this.getHudElement(areaName) as EButton;
         btn.setIsEnabled(val);
         btn.visible = val;
      }
      
      public function setVisibleWarningBox(value:Boolean, textId:int = -1) : void
      {
         var stripe:ESprite = this.getHudElement("warning_stripe");
         stripe.visible = value;
         if(value == true)
         {
            if(textId == -1)
            {
               textId = 146;
            }
            this.mWarningText.setText(DCTextMng.getText(textId));
         }
      }
      
      public function shipyardQueuedElementUpdate(id:int) : void
      {
         this.mShipyardQueuedElements = this.mShipyardControllerRef.getCurrentShipyard().getQueuedElements();
         var element:EUnitItemViewShipyardBarTraining = this.getHudElement("container_train_" + id) as EUnitItemViewShipyardBarTraining;
         element.fillData([this.mShipyardQueuedElements[id]]);
         element = this.getHudElement("container_train_0") as EUnitItemViewShipyardBarTraining;
         element.fillData([this.mShipyardQueuedElements[0]]);
      }
      
      public function shipyardQueuedElementShowBuySlotTooltip(id:int) : void
      {
         var tooltip:ETooltipInfo = null;
         var esprite:ESprite = this.getHudElement("container_train_" + id);
         this.shipyardQueuedElementHideBuySlotTooltip();
         if(esprite)
         {
            tooltip = ETooltipMng.getInstance().createTooltipInfoFromTexts(DCTextMng.getText(664),DCTextMng.getText(665),esprite,null,false,true);
         }
      }
      
      public function shipyardQueuedElementHideBuySlotTooltip() : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      override public function addMouseEvents() : void
      {
         var s:* = null;
         var esprite:ESprite = null;
         for(s in this.mContentHolders)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               this.setComponentMouseEvents(esprite,true);
            }
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var s:* = null;
         var esprite:ESprite = null;
         for(s in this.mContentHolders)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               this.setComponentMouseEvents(esprite,false);
            }
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var s:ESprite = null;
         super.unlock();
         this.addMouseEvents();
         if(exception)
         {
            s = this.getHudElement(exception.toString());
            if(s)
            {
               this.setComponentMouseEvents(s,false);
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.removeMouseEvents();
      }
      
      private function setComponentMouseEvents(s:ESprite, value:Boolean) : void
      {
         s.mouseEnabled = value;
         s.mouseChildren = value;
      }
      
      public function get IsTransitioning() : Boolean
      {
         return this.mIsTransitioning;
      }
      
      override public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(isVisible())
         {
            values = {"pivotLogicY":-1};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            this.mIsTransitioning = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(false);
               mIsTransitioning = false;
            };
         }
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(!isVisible())
         {
            values = {"pivotLogicY":0};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            this.mIsTransitioning = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(true);
               mIsTransitioning = false;
            };
         }
      }
      
      private function onMouseOverBtn(evt:EEvent) : void
      {
         var buttonName:String = null;
         var guiDef:DCGUIDef = null;
         var tooltipInfo:ETooltipInfo = null;
         if(evt.getTarget())
         {
            buttonName = String(evt.getTarget().name);
            if(guiDef = InstanceMng.getGUIDefMng().getDefBySku(buttonName) as DCGUIDef)
            {
               tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(TextIDs[guiDef.getTidTitleTooltip()]),evt.getTarget());
            }
         }
      }
      
      private function onMouseOutBtn(evt:EEvent) : void
      {
         if(evt.getTarget())
         {
            ETooltipMng.getInstance().removeCurrentTooltip();
         }
      }
      
      private function onCloseClick(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hideShipbar");
      }
      
      private function onCurrentCancelClicked(evt:EEvent) : void
      {
         var element:ShipyardQueuedElement = this.mShipyardQueuedElements[0];
         element.onRemoveUnit();
      }
      
      private function onStartCancelUnit(evt:EEvent) : void
      {
         var element:ShipyardQueuedElement = this.mShipyardQueuedElements[0];
         element.onStartCancelUnit();
      }
      
      private function onEndCancelUnit(evt:EEvent) : void
      {
         var element:ShipyardQueuedElement = this.mShipyardQueuedElements[0];
         element.onEndCancelUnit();
      }
      
      private function onLeftClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage - 1);
      }
      
      private function onRightClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage + 1);
      }
      
      private function onLeftClickBuilding(evt:EEvent) : void
      {
         InstanceMng.getGUIControllerPlanet().openPreviousShipyard();
      }
      
      private function onRightClickBuilding(evt:EEvent) : void
      {
         InstanceMng.getGUIControllerPlanet().openNextShipyard();
      }
   }
}
