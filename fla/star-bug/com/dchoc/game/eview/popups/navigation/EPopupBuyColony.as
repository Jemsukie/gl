package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.PlanetDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   
   public class EPopupBuyColony extends ENotificationWithImage
   {
      
      public static const ONLY_COLONIZE:int = 1;
      
      public static const ONLY_MOVE:int = 2;
      
      public static const COLONIZE_AND_MOVE:int = 3;
       
      
      private const IMAGES_CATALOG:Array = ["to_colonize_red","to_colonize_blue","to_colonize_green","to_colonize_white","to_colonize_violet","to_colonize_yellow"];
      
      private var mStarType:String;
      
      private var mColonizeOption:int;
      
      private var mPlanetSku:String;
      
      private var mCoinsAmount:Number;
      
      private var mMineralsAmount:Number;
      
      private var mPlanetDef:PlanetDef;
      
      public function EPopupBuyColony()
      {
         super();
      }
      
      public function setupPopup() : void
      {
         setupBackground("PopL","pop_l");
         this.setupPlanetImage();
         this.setPlanetSku(getEvent()["planetSku"]);
         this.setupButtons();
         this.setupBottom();
      }
      
      private function setupPlanetImage() : void
      {
         var planet:Planet = InstanceMng.getMapViewGalaxy().getEmptyPlanetClicked();
         if(planet != null)
         {
            this.mStarType = String(planet.getParentStarType());
         }
         else
         {
            this.mStarType = String(InstanceMng.getMapViewSolarSystem().getStarType());
         }
         setupImage(this.IMAGES_CATALOG[this.mStarType],mImageArea);
      }
      
      private function setupBottom() : void
      {
         var content:ESpriteContainer = null;
         var text:String = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutContainerColonizeRequirements");
         var boxes:Array = [];
         var body:ESprite = getContent("body");
         switch(this.mColonizeOption - 1)
         {
            case 0:
               setTitleText(DCTextMng.getText(2760));
               content = this.setupRequirements(layoutFactory.getArea("area_requirements"),layoutFactory.getTextArea("text_title_requirements"));
               body.eAddChild(content);
               setContent("requirements",content);
               boxes.push(content);
               break;
            case 1:
               setTitleText(DCTextMng.getText(3161));
               text = DCTextMng.getText(3155) + "\n\n" + DCTextMng.getText(3162);
               content = this.setColonyText(text,mBottomArea);
               body.eAddChild(content);
               setContent("move",content);
               boxes.push(content);
               break;
            case 2:
               setTitleText(DCTextMng.getText(3156));
               content = this.setupRequirements(layoutFactory.getArea("area_requirements"),layoutFactory.getTextArea("text_title_requirements"));
               body.eAddChild(content);
               setContent("requirements",content);
               boxes.push(content);
               text = DCTextMng.getText(3155);
               content = this.setColonyText(text,layoutFactory.getArea("area_move"),layoutFactory.getTextArea("text_title_move"));
               body.eAddChild(content);
               setContent("moveBox",content);
               boxes.push(content);
         }
         mViewFactory.distributeSpritesInArea(mBottomArea,boxes,1,1,boxes.length,1,true);
      }
      
      private function setupButtons() : void
      {
         var button:EButton = null;
         this.mColonizeOption = getEvent()["colonizeOptions"];
         switch(this.mColonizeOption - 1)
         {
            case 0:
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3160),0,"btn_accept");
               button.eAddEventListener("click",this.onColonize);
               addButton("colonizeButton",button);
               break;
            case 1:
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3157),0,"btn_common");
               button.eAddEventListener("click",this.onMove);
               addButton("moveButton",button);
               break;
            case 2:
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3160),0,"btn_accept");
               button.eAddEventListener("click",this.onColonize);
               addButton("colonizeButton",button);
               button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3157),0,"btn_common");
               button.eAddEventListener("click",this.onMove);
               addButton("moveButton",button);
         }
      }
      
      private function setupRequirements(area:ELayoutArea, titleArea:ELayoutTextArea) : ESpriteContainer
      {
         var textProp:String = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var layout:String = "ContainerItemVerticalM";
         var planetsAmount:int;
         var nextPlanetNumber:int = (planetsAmount = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount()) + 1;
         this.mPlanetDef = PlanetDef(InstanceMng.getPlanetDefMng().getDefBySku(nextPlanetNumber.toString()));
         var levelNeeded:int = parseInt(this.mPlanetDef.getBuyRequirement());
         var coinsText:String = DCTextMng.convertNumberToString(this.mCoinsAmount,-1,-1);
         var mineralsText:String = DCTextMng.convertNumberToString(this.mMineralsAmount,-1,-1);
         var img:EImage = mViewFactory.getEImage("generic_box",null,false,area);
         container.eAddChild(img);
         container.setContent("background",img);
         img.logicLeft = 0;
         img.logicTop = 0;
         var field:ETextField = mViewFactory.getETextField(null,titleArea,"text_subheader");
         container.eAddChild(field);
         setContent("titleRequirements",field);
         field.setText(DCTextMng.getText(598));
         field.logicLeft -= area.x;
         field.logicTop -= area.y;
         var boxes:Array = [];
         var observatoryDef:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId("labs_observatory",levelNeeded - 1);
         var text:String = DCTextMng.replaceParameters(599,[levelNeeded]);
         if(levelNeeded <= InstanceMng.getWorld().itemsGetObservatoryLevel() + 1)
         {
            textProp = "text_subheader";
         }
         else
         {
            textProp = "text_negative";
         }
         var content:ESpriteContainer = mViewFactory.getContentIconWithTextVertical(layout,observatoryDef.getAssetId() + "_ready",text,null,textProp);
         container.eAddChild(content);
         container.setContent("observatory",content);
         mViewFactory.readjustContentIconWithTextVertical(content);
         boxes.push(content);
         var profile:Profile;
         if((profile = InstanceMng.getUserInfoMng().getProfileLogin()).getCoins() > this.mCoinsAmount)
         {
            textProp = "text_coins";
         }
         else
         {
            textProp = "text_negative";
         }
         content = mViewFactory.getContentIconWithTextVertical(layout,"icon_coins",coinsText,null,textProp);
         container.eAddChild(content);
         container.setContent("coins",content);
         mViewFactory.readjustContentIconWithTextVertical(content);
         boxes.push(content);
         if(profile.getMinerals() > this.mMineralsAmount)
         {
            textProp = "text_minerals";
         }
         else
         {
            textProp = "text_negative";
         }
         content = mViewFactory.getContentIconWithTextVertical(layout,"icon_minerals",mineralsText,null,textProp);
         container.eAddChild(content);
         container.setContent("minerals",content);
         mViewFactory.readjustContentIconWithTextVertical(content);
         boxes.push(content);
         mViewFactory.distributeSpritesInArea(area,boxes,1,1,boxes.length,1,false);
         return container;
      }
      
      protected function setColonyText(text:String, area:ELayoutArea, titleArea:ELayoutTextArea = null) : ESpriteContainer
      {
         var field:ETextField = null;
         var container:ESpriteContainer = new ESpriteContainer();
         var img:EImage = mViewFactory.getEImage("generic_box",null,false,area);
         container.eAddChild(img);
         container.setContent("background",img);
         img.logicTop = 0;
         img.logicLeft = 0;
         if(titleArea != null)
         {
            (field = mViewFactory.getETextField(null,titleArea,"text_subheader")).setText("~hola");
            container.eAddChild(field);
            container.setContent("moveTitle",field);
            field.logicTop -= area.y;
            field.logicLeft -= area.x;
            field.visible = false;
         }
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerTextField");
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body_2")).setText(text);
         var MARGIN:int = 4;
         field.width = area.width - MARGIN * 2;
         field.height = area.height - MARGIN * 2;
         field.logicTop = MARGIN;
         field.logicLeft = MARGIN;
         container.eAddChild(field);
         container.setContent("field",field);
         return container;
      }
      
      public function setPlanetSku(planetSku:String) : void
      {
         var distance:Number = NaN;
         var resource:Number = NaN;
         this.mStarType = String(InstanceMng.getMapViewSolarSystem().getStarType());
         this.mPlanetSku = planetSku;
         var planet:Planet;
         if((planet = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetClosestTo(this.mPlanetSku)) != null)
         {
            distance = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(planetSku,planet.getSku()));
            resource = InstanceMng.getRuleMng().getColonizeCostByDistance(distance);
            this.mCoinsAmount = resource;
            this.mMineralsAmount = resource;
         }
      }
      
      private function setupEventBeforeSending(event:Object) : void
      {
         event["action"] = null;
         event["popup"] = this;
         event["planetDef"] = this.mPlanetDef;
         event["coinsAmount"] = this.mCoinsAmount;
         event["mineralsAmount"] = this.mMineralsAmount;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      private function onColonize(e:EEvent) : void
      {
         var event:Object = EUtils.cloneObject(getEvent());
         if(event == null)
         {
            InstanceMng.getPopupMng().closePopup(this);
            return;
         }
         event["phase"] = "OUT";
         event["button"] = "EventYesButtonPressed";
         this.setupEventBeforeSending(event);
         if(Config.USE_METRICS)
         {
            DCMetrics.sendMetric("Colony","Colonize Planet","Buy");
         }
      }
      
      private function onMove(e:EEvent) : void
      {
         var event:Object = EUtils.cloneObject(getEvent());
         if(event == null)
         {
            InstanceMng.getPopupMng().closePopup(this);
            return;
         }
         event["phase"] = "OUT";
         event["button"] = "EVENT_BUTTON_RIGHT_PRESSED";
         event["newPlanetSku"] = this.mPlanetSku;
         this.setupEventBeforeSending(event);
         if(Config.USE_METRICS)
         {
            DCMetrics.sendMetric("Colony","Colonize Planet","Move");
         }
      }
   }
}
