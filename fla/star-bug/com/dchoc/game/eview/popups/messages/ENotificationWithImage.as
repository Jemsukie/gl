package com.dchoc.game.eview.popups.messages
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.Shape;
   
   public class ENotificationWithImage extends EGamePopup
   {
       
      
      protected const BODY:String = "body";
      
      protected const BIG_IMAGE:String = "bigImage";
      
      protected var mBottomArea:ELayoutArea;
      
      protected var mImageArea:ELayoutArea;
      
      public function ENotificationWithImage()
      {
         super();
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
         this.setAreas();
      }
      
      protected function setAreas() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopNotificaionFeedBack");
         this.mBottomArea = layoutFactory.getArea("area_info");
         this.mImageArea = layoutFactory.getArea("img");
      }
      
      protected function setupImage(image:String, area:ELayoutArea) : void
      {
         var img:ESprite = null;
         var body:ESprite = getContent("body");
         if(area.pivotX == 0 && area.pivotY == 0)
         {
            img = mViewFactory.getResourceAsESprite(image,null,true,null,this.centerImage);
         }
         else
         {
            img = mViewFactory.getResourceAsESprite(image,null,true,area);
         }
         setContent("bigImage",img);
         body.eAddChild(img);
         var sp:Shape;
         (sp = new Shape()).graphics.beginFill(16711935,0);
         sp.graphics.drawRect(0,0,area.width,area.height);
         body.addChild(sp);
         img.setMask(sp);
         sp.x = area.x;
         sp.y = area.y;
      }
      
      private function centerImage(sp:ESprite) : void
      {
         this.mImageArea.centerContent(sp);
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         var o:Object = null;
         if(getEvent())
         {
            o = getEvent();
            o.button = "EventCloseButtonPressed";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
         }
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
