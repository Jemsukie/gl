package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupColonyBought extends ENotificationWithImage
   {
       
      
      private const IMAGES_CATALOG:Array = ["colonize_red","colonize_blue","colonize_green","colonize_white","colonize_violet","colonize_yellow"];
      
      private const TIDS_CATALOG:Array = [440,438,439,442,441,443];
      
      private var mStarType:String;
      
      private var mPlanetId:String;
      
      private var mPlanetSku:String;
      
      public function EPopupColonyBought()
      {
         super();
      }
      
      public function setupPopup() : void
      {
         var e:Object = getEvent();
         setEvent(e);
         this.mPlanetId = e.planetId;
         this.mPlanetSku = e.planetSku;
         setupBackground("PopM","pop_m");
         this.setupPlanetImage();
         this.setupButtons();
         this.setupBottom();
         setTitleText(DCTextMng.getText(2766));
      }
      
      override protected function setAreas() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutColonized");
         mImageArea = layoutFactory.getArea("img_pop_m");
         mBottomArea = layoutFactory.getArea("text_info");
      }
      
      private function setupButtons() : void
      {
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(143),0,"btn_accept");
         addButton("buttonVisit",button);
         button.eAddEventListener("click",this.onVisit);
      }
      
      private function setupBottom() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutColonized");
         var body:ESprite = getContent("body");
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_info"),"text_body");
         field.setText(DCTextMng.getText(this.TIDS_CATALOG[this.mStarType]));
         body.eAddChild(field);
         setContent("bottomText",field);
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
      
      private function onVisit(e:EEvent) : void
      {
         onCloseClick(null);
         var accId:String = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
         InstanceMng.getApplication().requestPlanet(accId,this.mPlanetId,0,this.mPlanetSku);
      }
   }
}
