package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupHangarEmpty extends EGamePopup
   {
      
      private static const AREA_BAR:String = "container_bar_l";
      
      private static const IMAGE:String = "container_buildings";
      
      private static const IMAGE_CHARACTER:String = "character";
      
      private static const AREA_SPEECH:String = "area_speech";
      
      private static const AREA_SPEECH_ARROW:String = "speech_arrow";
      
      private static const TEXT_INFO:String = "text_info";
      
      private static const BARRACK_BUILDING:String = "barrackBuilding";
      
      private static const FACTORY_BUILDING:String = "factoryBuilding";
      
      private static const STARPORT_BUILDING:String = "starportBuilding";
       
      
      public function EPopupHangarEmpty()
      {
         super();
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String, maxCapacity:int) : void
      {
         var textField:ETextField = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutHangarEmpty");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopL");
         var content:ESprite = mViewFactory.getESprite(skinId);
         setFooterArea(layoutFactory.getArea("footer"));
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = mViewFactory.getEImage("pop_l",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         setTitleText(DCTextMng.getText(163));
         bkg.eAddChild(getTitle());
         var mCapacityBar:IconBar;
         (mCapacityBar = new IconBar()).setup("IconBarL",0,10,"color_capacity","icon_hangar");
         mCapacityBar.updateText("0/" + maxCapacity);
         mCapacityBar.updateTopText(DCTextMng.getText(610));
         mCapacityBar.logicUpdate(0);
         mCapacityBar.layoutApplyTransformations(popupLayoutFactory.getArea("container_bar_l"));
         content.eAddChild(mCapacityBar);
         setContent("container_bar_l",mCapacityBar);
         var image:ESprite = mViewFactory.getESprite(mSkinSku,popupLayoutFactory.getArea("container_buildings"));
         content.eAddChild(image);
         setContent("container_buildings",image);
         var building:EImage;
         (building = mViewFactory.getEImage("barrack",mSkinSku,false)).onSetTextureLoaded = this.onBuildingImageLoaded;
         setContent("barrackBuilding",building);
         image.eAddChild(building);
         (building = mViewFactory.getEImage("factory",mSkinSku,false)).onSetTextureLoaded = this.onBuildingImageLoaded;
         setContent("factoryBuilding",building);
         image.eAddChild(building);
         (building = mViewFactory.getEImage("shipyard",mSkinSku,false)).onSetTextureLoaded = this.onBuildingImageLoaded;
         setContent("starportBuilding",building);
         image.eAddChild(building);
         var speechArrow:EImage = mViewFactory.getEImage("speech_arrow",mSkinSku,false,popupLayoutFactory.getArea("speech_arrow"),"speech_color");
         var advisor:EImage = mViewFactory.getEImage("captain_normal",mSkinSku,true,popupLayoutFactory.getArea("character"));
         content.eAddChild(speechArrow);
         content.eAddChild(advisor);
         var speechBox:ESprite = mViewFactory.getSpeechBubble(popupLayoutFactory.getArea("area_speech"),popupLayoutFactory.getArea("speech_arrow"),null,mSkinSku,"speech_color",false);
         content.eAddChild(speechBox);
         setContent("speech_arrow",speechArrow);
         setContent("area_speech",speechBox);
         setContent("character",advisor);
         (textField = mViewFactory.getETextField(mSkinSku,popupLayoutFactory.getTextArea("text_info"))).setText(DCTextMng.getText(148));
         textField.applySkinProp(mSkinSku,"text_body");
         content.eAddChild(textField);
         setContent("text_info",textField);
         bkg.eAddChild(content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         setContent("CONTENT",content);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
      }
      
      private function onBuildingImageLoaded(img:EImage) : void
      {
         var maxHeight:int = 0;
         var image:ESprite = null;
         var barrack:EImage = getContentAsEImage("barrackBuilding");
         var factory:EImage = getContentAsEImage("factoryBuilding");
         var starport:EImage;
         if((starport = getContentAsEImage("starportBuilding")).isTextureLoaded() && factory.isTextureLoaded() && barrack.isTextureLoaded())
         {
            factory.logicLeft = barrack.logicLeft + barrack.width;
            starport.logicLeft = factory.logicLeft + factory.width;
            maxHeight = Math.max(starport.height,Math.max(factory.height,starport.height));
            barrack.logicTop = (maxHeight - barrack.height) / 2;
            factory.logicTop = (maxHeight - factory.height) / 2;
            starport.logicTop = (maxHeight - starport.height) / 2;
            image = getContent("container_buildings") as ESprite;
            image.layoutApplyTransformations(image.getLayoutArea());
         }
      }
   }
}
