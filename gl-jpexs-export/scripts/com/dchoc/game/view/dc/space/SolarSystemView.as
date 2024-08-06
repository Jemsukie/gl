package com.dchoc.game.view.dc.space
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class SolarSystemView extends ESpriteContainer
   {
      
      public static const STAR_NAME:String = "text_name";
      
      public static const COORDS_NAME:String = "text_parameters";
      
      public static const IMG_NAME:String = "icon_star";
       
      
      private var mSolarSystemId:Number;
      
      private var mSolarSystemName:String;
      
      private var mSolarSystemCoords:DCCoordinate;
      
      private var mSolarSystemType:int;
      
      private var mSolarSystemOccupiedPlanets:int;
      
      private var mViewFactory:ViewFactory;
      
      public function SolarSystemView()
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
      }
      
      public function setupView() : void
      {
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutSolarSystem");
         var img:EImage = this.mViewFactory.getEImage("solar_system_0",null,true,layoutFactory.getArea("icon_star"));
         eAddChild(img);
         setContent("icon_star",img);
         var field:ETextField = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),"text_title_3");
         setContent("text_name",field);
         eAddChild(field);
         field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text_parameters"),"text_title_3");
         setContent("text_parameters",field);
         eAddChild(field);
      }
      
      public function setSolarSystemId(value:Number) : void
      {
         this.mSolarSystemId = value;
      }
      
      public function setSolarSystemName(value:String) : void
      {
         this.mSolarSystemName = value;
      }
      
      public function setSolarSystemCoords(value:DCCoordinate) : void
      {
         this.mSolarSystemCoords = value;
      }
      
      public function setSolarSystemType(value:int) : void
      {
         this.mSolarSystemType = value;
      }
      
      public function setSolarSystemOccupiedPlanets(value:int) : void
      {
         this.mSolarSystemOccupiedPlanets = value;
      }
      
      public function setInfo(starId:Number, starName:String, starCoords:DCCoordinate, starType:int, occupiedPlanets:int = -1) : void
      {
         this.setSolarSystemId(starId);
         this.setSolarSystemName(starName);
         this.setSolarSystemCoords(starCoords);
         this.setSolarSystemType(starType);
         this.setSolarSystemOccupiedPlanets(occupiedPlanets);
         if(occupiedPlanets == -1)
         {
            this.setTextVisible("text_parameters",false);
         }
         else
         {
            this.setTextVisible("text_parameters",true);
         }
         this.checkColoredCoding();
         var img:EImage;
         if((img = getContentAsEImage("icon_star")) != null)
         {
            this.mViewFactory.setTextureToImage("solar_system_" + this.mSolarSystemType,null,img);
         }
      }
      
      public function setSolarSystemNameText(value:String, color:String) : void
      {
         this.setTextColoured("text_name",value,color);
      }
      
      public function setFreePlanetsText(color:String) : void
      {
         var freePlanetsText:String = String(this.mSolarSystemOccupiedPlanets) + "/" + "12";
         this.setTextColoured("text_parameters",freePlanetsText,color);
      }
      
      private function setTextVisible(sku:String, value:Boolean) : void
      {
         var field:ETextField = getContentAsETextField(sku);
         field.visible = value;
      }
      
      private function setTextColoured(sku:String, text:String, color:String) : void
      {
         var field:ETextField;
         (field = getContentAsETextField(sku)).setTextColor(parseInt(color,16));
         field.setText(text.toUpperCase());
      }
      
      public function getSolarSystemId() : Number
      {
         return this.mSolarSystemId;
      }
      
      public function getSolarSystemName() : String
      {
         return this.mSolarSystemName;
      }
      
      public function getSolarSystemCoords() : DCCoordinate
      {
         return this.mSolarSystemCoords;
      }
      
      public function getSolarSystemType() : int
      {
         return this.mSolarSystemType;
      }
      
      public function getSolarSystemFreePlanets() : int
      {
         return this.mSolarSystemOccupiedPlanets;
      }
      
      private function checkColoredCoding() : void
      {
         var uInfoLogin:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         var holdsUserPlanet:Boolean = uInfoLogin.checkIfStarHoldsAnyUserPlanet(this.mSolarSystemCoords);
         var solarSysName:String = this.mSolarSystemName;
         if(solarSysName == "")
         {
            solarSysName = "Star " + this.mSolarSystemCoords.x + "," + this.mSolarSystemCoords.y;
         }
         if(holdsUserPlanet == true)
         {
            this.setSolarSystemNameText(solarSysName,"0x32CD32");
            this.setFreePlanetsText("0x32CD32");
         }
         else
         {
            this.setSolarSystemNameText(solarSysName,"0xFFFFFF");
            this.setFreePlanetsText("0xFFFFFF");
         }
      }
   }
}
