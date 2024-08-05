package com.dchoc.game.view.facade
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class ENavigationBarFacade extends GUIComponent implements INotifyReceiver
   {
      
      public static const AREA_NAVIGATION:String = "area_navegation";
      
      public static const ARROW:String = "btn_arrow";
      
      public static const AREA_HUD_BOTTOM:String = "container_hud_bottom";
      
      public static const BUTTON_GO_HOME:String = "button_home";
      
      public static const HUD_PRIMARY_BUTTONS_GROUP:Array = ["button_home","button_galaxy","button_solar_system","button_planet"];
       
      
      private var mCanvasBottom:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mButtonBoxes:Vector.<EButton>;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mViewFactory:ViewFactory;
      
      private var mDropDownsRepositioned:Boolean;
      
      public function ENavigationBarFacade()
      {
         super("hud_navigation");
         this.mContentHolders = new Dictionary();
         this.mButtonBoxes = new Vector.<EButton>(0);
      }
      
      public function getName() : String
      {
         return "ENavigationBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["uiLockElement","uiUnlockElement","putTutorialCircle","colonyBought"];
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
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component,false,0,0,0,0,false,false);
               }
               break;
            case "uiLockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  component.mouseEnabled = false;
                  component.mouseChildren = false;
               }
               break;
            case "uiUnlockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  component.mouseEnabled = true;
                  component.mouseChildren = true;
               }
               break;
            case "colonyBought":
               this.reloadView();
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 3;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var content:ESpriteContainer = null;
         var buttons:Array = null;
         var skinSku:String = InstanceMng.getSkinsMng().getCurrentSkinSku();
         if(step == 0)
         {
            this.mViewFactory = InstanceMng.getViewFactory();
            this.mCanvasBottom = this.mViewFactory.getESpriteContainer();
            this.mCanvasBottom.eAddEventListener("rollOver",uiEnable);
            this.mCanvasBottom.eAddEventListener("rollOut",uiDisable);
            buildAdvanceSyncStep();
         }
         else if(step == 1)
         {
            this.createLayoutsView();
            this.buildView(step);
            buildAdvanceSyncStep();
         }
         else if(step == 2 && InstanceMng.getUserInfoMng().isBuilt() && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt())
         {
            buildAdvanceSyncStep();
            this.buildView(step);
         }
      }
      
      private function createLayoutsView() : void
      {
         this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(InstanceMng.getUIFacade().getHudBottomLayoutName());
      }
      
      private function buildView(step:int) : void
      {
         var s:ESprite = null;
         var role:int = InstanceMng.getFlowState().getCurrentRoleId();
         switch(role)
         {
            case 0:
            case 1:
            case 2:
            case 5:
               if(step == 1)
               {
                  this.buildBkg();
                  break;
               }
               if(step == 2)
               {
                  this.buildButtons();
               }
               break;
         }
      }
      
      private function buildBkg() : void
      {
         var s:ESprite = null;
         var resource:String = InstanceMng.getUIFacade().getHudBottomLayoutName() == "LayoutHudBottomSmall" ? "skin_ui_hud_area_bottom_small" : "skin_ui_hud_area_bottom";
         s = this.mViewFactory.getEImage(resource,null,false,this.mLayoutAreaFactory.getArea("container_hud_bottom"),null);
         this.addHudElement("container_hud_bottom",s,this.mCanvasBottom,false);
      }
      
      private function buildButtons() : void
      {
         var btn:EButton = null;
         var setButtonBehaviors:* = false;
         this.mButtonBoxes.length = 0;
         var navigationBar:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var s:ESprite = this.mViewFactory.getEImage("tab_bkg_hud",null,false,this.mLayoutAreaFactory.getArea("area_navegation"));
         s.name = "area_navegation";
         navigationBar.eAddChild(s);
         navigationBar.setContent("area_navegation",s);
         this.addHudElement("area_navegation",navigationBar,this.mCanvasBottom,false);
         var homeText:String = this.getColoniesButtonText();
         (btn = this.mViewFactory.getTextTabHeaderHud(homeText,null,"text_btn_common_hud")).name = "button_home";
         this.mButtonBoxes.push(btn);
         this.addHudElement("button_home",btn,navigationBar,false);
         setButtonBehaviors = InstanceMng.getApplication().viewGetMode() != 2;
         (btn = this.mViewFactory.getTextTabHeaderHud(DCTextMng.getText(2756),null)).name = "button_galaxy";
         if(setButtonBehaviors)
         {
            btn.eAddEventListener("click",this.onGoToGalaxyClick);
         }
         this.mButtonBoxes.push(btn);
         this.addHudElement("button_galaxy",btn,navigationBar,setButtonBehaviors);
         setButtonBehaviors = InstanceMng.getApplication().viewGetMode() == 0;
         (btn = this.mViewFactory.getTextTabHeaderHud(this.getSolarSystemButtonText(),null)).name = "button_solar_system";
         if(setButtonBehaviors)
         {
            btn.eAddEventListener("click",this.onGoToSolarSystemClick);
         }
         this.mButtonBoxes.push(btn);
         this.addHudElement("button_solar_system",btn,navigationBar,setButtonBehaviors);
         (btn = this.mViewFactory.getTextTabHeaderHud(this.getPlanetButtonText(),null)).name = "button_planet";
         this.mButtonBoxes.push(btn);
         this.addHudElement("button_planet",btn,navigationBar,false);
         this.distributeButtons();
         this.createNavigationButton();
      }
      
      private function createNavigationButton() : ESprite
      {
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var content:ESpriteContainer = this.mViewFactory.getColoniesForDropDown(this.onColonyViewClick,userInfo,userInfo.getCurrentPlanet());
         var btn:EButton = this.getHudElement("button_home") as EButton;
         var dropdownButton:EDropDownButton;
         (dropdownButton = this.mViewFactory.getDropDownButtonFromContent(null,content,btn,userInfo.getPlanetsAmount() > 1 ? null : this.onColoniesClick)).name = "button_home";
         this.addHudElement("button_home",dropdownButton,this.mCanvasBottom,userInfo.getPlanetsAmount() != 1 || (InstanceMng.getApplication().viewGetMode() != 0 || InstanceMng.getFlowState().getCurrentRoleId() != 0));
         this.mDropDownsRepositioned = false;
         return dropdownButton;
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
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      override protected function beginDo() : void
      {
         MessageCenter.getInstance().registerObject(this);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         this.mCanvasBottom.logicY = this.mCanvasBottom.logicY;
         setVisible(true);
         if(!InstanceMng.getFlowStatePlanet().isFirstTargetDone())
         {
            this.moveDisappearUpToDown(0.1);
         }
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
         var sc:ESpriteContainer = null;
         var lastLeft:Number = NaN;
         var diff:Number = NaN;
         var elements:Array = null;
         var element:String = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
         if(!this.mDropDownsRepositioned)
         {
            elements = ["button_home"];
            for each(element in elements)
            {
               if(this.getHudElement(element))
               {
                  sc = EDropDownButton(this.getHudElement(element)).getDropDown();
                  lastLeft = sc.logicLeft;
                  InstanceMng.getViewFactory().arrangeToFitInMinimumScreen(sc);
                  diff = sc.logicLeft - lastLeft;
                  sc.getContent("arrow").logicX = sc.getContent("arrow").logicX - diff;
               }
            }
            this.mDropDownsRepositioned = true;
         }
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      public function reloadView() : void
      {
         this.getHudElement("area_navegation").destroy();
         this.getHudElement("button_home").destroy();
         this.getHudElement("button_galaxy").destroy();
         this.getHudElement("button_solar_system").destroy();
         this.getHudElement("button_planet").destroy();
         this.buildButtons();
      }
      
      override public function addMouseEvents() : void
      {
         var name:String = null;
         var s:ESprite = null;
         for each(name in HUD_PRIMARY_BUTTONS_GROUP)
         {
            s = this.getHudElement(name);
            if(s)
            {
               s.mouseChildren = true;
               s.mouseEnabled = true;
            }
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var name:String = null;
         var s:ESprite = null;
         for each(name in HUD_PRIMARY_BUTTONS_GROUP)
         {
            s = this.getHudElement(name);
            if(s)
            {
               s.mouseChildren = false;
               s.mouseEnabled = false;
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
               s.mouseChildren = false;
               s.mouseEnabled = false;
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.removeMouseEvents();
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
            tween.onComplete = function(t:GTween):void
            {
               setVisible(false);
            };
            this.hideNavigationBar();
         }
      }
      
      private function hideNavigationBar() : void
      {
         var btn:EDropDownButton = null;
         var values:Object = {"scaleLogicY":0};
         var tween:GTween = new GTween(this.getHudElement("area_navegation"),0.5,values);
         tween.autoPlay = true;
         btn = this.getHudElement("button_home") as EDropDownButton;
         if(btn)
         {
            btn.close();
         }
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(!isVisible())
         {
            values = {"pivotLogicY":this.mCanvasBottom.pivotLogicY + 1};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(true);
            };
            this.showNavigationBar();
         }
      }
      
      private function showNavigationBar() : void
      {
         var values:Object = {"scaleLogicY":1};
         var tween:GTween = new GTween(this.getHudElement("area_navegation"),0.5,values);
         tween.autoPlay = true;
      }
      
      public function setNavigationButtonVisibility(id:String, visible:Boolean) : void
      {
         if(this.getHudElement(id))
         {
            this.getHudElement(id).visible = visible;
         }
      }
      
      private function distributeButtons() : void
      {
         if(this.mButtonBoxes.length)
         {
            this.mViewFactory.distributeButtons(this.mButtonBoxes,this.mLayoutAreaFactory.getArea("area_navegation"),false);
         }
      }
      
      public function setButtonTexts(starName:String, coords:DCCoordinate) : void
      {
         var solarSystemNameCoords:* = null;
         if(!starName || !coords)
         {
            solarSystemNameCoords = this.getSolarSystemButtonText();
         }
         else
         {
            solarSystemNameCoords = starName;
            if(!InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
            {
               solarSystemNameCoords += " " + coords.toString(true);
            }
         }
         if(solarSystemNameCoords && this.getHudElement("button_solar_system"))
         {
            (this.getHudElement("button_solar_system") as EButton).setText(solarSystemNameCoords);
            (this.getHudElement("button_planet") as EButton).setText(this.getPlanetButtonText());
            this.distributeButtons();
         }
      }
      
      private function getColoniesButtonText() : String
      {
         var homeText:String = DCTextMng.getText(583);
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj();
         if(InstanceMng.getFlowState().getCurrentRoleId() == 0 && InstanceMng.getApplication().viewGetMode() == 0)
         {
            if(userInfo.getPlanetsAmount() > 1)
            {
               homeText = DCTextMng.getText(635);
            }
            else
            {
               homeText = DCTextMng.getText(629);
            }
         }
         return homeText;
      }
      
      private function getSolarSystemButtonText() : String
      {
         var returnValue:* = null;
         var starName:String = InstanceMng.getApplication().goToGetCurrentStarName();
         var starCoord:DCCoordinate = InstanceMng.getApplication().goToGetCurrentStarCoors();
         if(starName && starCoord)
         {
            returnValue = starName;
            if(!InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
            {
               returnValue = returnValue + " " + starCoord.toString(true);
            }
         }
         return returnValue;
      }
      
      private function getPlanetButtonText() : String
      {
         var returnValue:String = "";
         var currentPlanetId:String = InstanceMng.getApplication().goToGetCurrentPlanetId();
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj();
         var planet:Planet = userInfo.getPlanetById(currentPlanetId);
         if(!userInfo.mIsNPC.value)
         {
            planet.setInfoFromVars(userInfo.getAccountId(),currentPlanetId,planet.getSku(),planet.getHQLevel());
         }
         var planetStr:String = planet == null ? "" : planet.getStringId();
         var userNameStr:String;
         if((userNameStr = userInfo.getPlayerFirstName()) != null && planetStr != null)
         {
            returnValue = DCTextMng.replaceParameters(2739,[userNameStr,planetStr]);
         }
         return returnValue;
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
      
      private function onArrowClicked(evt:EEvent) : void
      {
      }
      
      private function onColoniesClick(e:EEvent) : void
      {
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         if(userInfo.getPlanetsAmount() == 1 && (InstanceMng.getApplication().viewGetMode() != 0 || InstanceMng.getFlowState().getCurrentRoleId() != 0))
         {
            InstanceMng.getApplication().goToHomePlanet();
         }
      }
      
      private function onGoToGalaxyClick(e:EEvent) : void
      {
         var coords:DCCoordinate = InstanceMng.getApplication().goToGetCurrentStarCoors();
         InstanceMng.getApplication().goToGalaxyCenteredByStarCoord(coords);
      }
      
      private function onGoToSolarSystemClick(e:EEvent) : void
      {
         InstanceMng.getApplication().goToCurrentStar();
      }
      
      private function onGoToPlanetClick(e:EEvent) : void
      {
         InstanceMng.getApplication().goToHomePlanet();
      }
      
      private function onColonyViewClick(evt:EEvent) : void
      {
         var profile:Profile = null;
         var userInfo:UserInfo = null;
         var planetId:String = null;
         var planet:Planet = null;
         if(evt.getTarget())
         {
            userInfo = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj();
            planetId = String(evt.getTarget().name);
            planet = userInfo.getPlanetById(planetId);
            if(planet)
            {
               InstanceMng.getUserInfoMng().getProfileLogin().setCurrentPlanetId(planetId);
               InstanceMng.getApplication().goToSetCurrentDestinationInfo(planetId,userInfo);
               InstanceMng.getApplication().requestPlanet(userInfo.mAccountId,planetId,0,planet.getSku());
            }
         }
      }
   }
}
