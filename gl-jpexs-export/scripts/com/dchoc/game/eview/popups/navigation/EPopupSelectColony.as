package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupSelectColony extends EGamePopup
   {
       
      
      private const BODY:String = "body";
      
      private const BKG:String = "bkg";
      
      private const PLANET:String = "planet";
      
      private const PAY_BUTTON:String = "pay_button";
      
      private var mCurrentPlanet:Planet;
      
      private var mCurrentPlanetId:int;
      
      private var mNewPlanetSku:String;
      
      private var mPlanetBoxes:Array;
      
      private var mPlanets:Vector.<Planet>;
      
      private var mPlanetsCount:int;
      
      private var mNewStarType:String;
      
      public function EPopupSelectColony()
      {
         super();
      }
      
      public function setupPopup(newPlanetSku:String) : void
      {
         this.mNewPlanetSku = newPlanetSku;
         var planet:Planet = InstanceMng.getMapViewGalaxy().getEmptyPlanetClicked();
         if(planet != null)
         {
            this.mNewStarType = String(planet.getParentStarType());
         }
         else
         {
            this.mNewStarType = String(InstanceMng.getMapViewSolarSystem().getStarType());
         }
         this.setupBackground("PopS","pop_s");
         setTitleText(DCTextMng.getText(3157));
         this.setupButtons();
         this.setupPlanets();
         this.mCurrentPlanetId = -1;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mPlanetBoxes = null;
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupButtons() : void
      {
         var text:String = DCTextMng.replaceParameters(3159,[InstanceMng.getSettingsDefMng().getMoveColonyCostPC().toString()]);
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var icon:String = "icon_chip";
         if(profile.getFreeColonyMoves() > 0)
         {
            text = DCTextMng.replaceParameters(3685,[profile.getFreeColonyMoves().toString()]);
            icon = null;
         }
         var button:EButton = mViewFactory.getButtonByTextWidth(text,0,"btn_common",icon);
         addButton("pay_button",button);
         button.eAddEventListener("click",this.onMoveColony);
         button.setIsEnabled(false);
      }
      
      private function setupPlanets() : void
      {
         var i:int = 0;
         var planetBox:ESpriteContainer = null;
         var MAX_COLONIES:int = 12;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutMoveColonies");
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var body:ESprite = getContent("body");
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body");
         var text:String = DCTextMng.replaceParameters(3158,[DCTextMng.getPlanetText(this.mNewStarType)]);
         field.setText(text);
         body.eAddChild(field);
         setContent("message",field);
         this.mPlanets = userInfo.getPlanets();
         this.mPlanetsCount = this.mPlanets.length;
         planetBox = mViewFactory.getColonyViewSmall(this.mPlanets[0]);
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(planetBox.width,planetBox.height);
         this.mPlanetBoxes = [];
         for(i = 0; i < MAX_COLONIES; )
         {
            planetBox = this.getPlanetBox(i,area);
            setContent("planet" + i,planetBox);
            body.eAddChild(planetBox);
            this.mPlanetBoxes.push(planetBox);
            i++;
         }
         mViewFactory.distributeSpritesInArea(layoutFactory.getArea("area_planets"),this.mPlanetBoxes,1,1,6,2,true);
      }
      
      private function getPlanetBox(index:int, area:ELayoutArea) : ESpriteContainer
      {
         var planetView:ESpriteContainer = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,area,"color_blue_box");
         container.setContent("bkg",img);
         container.eAddChild(img);
         if(index < this.mPlanetsCount)
         {
            planetView = mViewFactory.getColonyViewSmall(this.mPlanets[index]);
            container.eAddChild(planetView);
            container.setContent("planet",planetView);
            if(index > 0)
            {
               container.buttonMode = true;
               container.mouseChildren = false;
               container.eAddEventListener("click",this.onClickPlanet);
               container.eAddEventListener("rollOver",this.onMouseOver);
               container.eAddEventListener("rollOut",this.onMouseOut);
            }
            else
            {
               container.applySkinProp(null,"disabled");
            }
         }
         return container;
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      protected function onMoveColony(e:EEvent) : void
      {
         var event:Object = null;
         if(this.mCurrentPlanet != null)
         {
            event = getEvent();
            if(event != null)
            {
               event.planetId = this.mCurrentPlanet.getPlanetId();
               event.button = "EventYesButtonPressed";
               event.transaction = InstanceMng.getRuleMng().getTransactionPack(event);
               this.setupEventBeforeSending();
            }
         }
      }
      
      private function setupEventBeforeSending() : void
      {
         var event:Object = getEvent();
         event.popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      private function onClickPlanet(e:EEvent) : void
      {
         var bkg:ESprite = null;
         var box:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var index:int = this.mPlanetBoxes.indexOf(box);
         if(index > -1 && index != this.mCurrentPlanetId)
         {
            if(this.mCurrentPlanetId > -1)
            {
               box = this.mPlanetBoxes[this.mCurrentPlanetId];
               if((bkg = box.getContent("planet")) != null)
               {
                  bkg.unapplySkinProp(null,"glow_green_high");
               }
            }
            this.mCurrentPlanetId = index;
            this.mCurrentPlanet = this.mPlanets[index];
            box = this.mPlanetBoxes[this.mCurrentPlanetId];
            if((bkg = box.getContent("planet")) != null)
            {
               bkg.applySkinProp(null,"glow_green_high");
            }
            getContentAsEButton("pay_button").setIsEnabled(true);
         }
      }
      
      private function onMouseOver(e:EEvent) : void
      {
         var box:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var planet:ESprite = box.getContent("planet");
         if(planet != null)
         {
            planet.applySkinProp(null,"glow_yellow_high");
         }
      }
      
      private function onMouseOut(e:EEvent) : void
      {
         var box:ESpriteContainer = e.getTarget() as ESpriteContainer;
         var planet:ESprite = box.getContent("planet");
         if(planet != null)
         {
            planet.unapplySkinProp(null,"glow_yellow_high");
         }
      }
   }
}
