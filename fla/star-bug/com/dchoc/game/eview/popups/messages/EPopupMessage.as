package com.dchoc.game.eview.popups.messages
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.DisplayObjectContainer;
   
   public class EPopupMessage extends EGamePopup
   {
      
      private static const DEBUG_BG:Boolean = false;
      
      private static const DEBUG_BODY:Boolean = false;
      
      protected static const BODY:String = "Body";
      
      protected static const SPEECH_ARROW:String = "Speech_Arrow";
      
      protected static const SPEECH_BOX:String = "Speech_box";
      
      protected static const SPEECH_CONTENT:String = "Speech_content";
      
      protected static const ADVISOR:String = "Advisor";
       
      
      protected var mLayoutName:String;
      
      protected var mLayoutAreaFactoryName:String;
      
      protected var mLayoutBackgroundResourceName:String;
      
      protected var mAdvisorArea:ELayoutArea;
      
      protected var mSpeechArea:ELayoutArea;
      
      protected var mArrowArea:ELayoutArea;
      
      protected var mSpeechColor:uint;
      
      public function EPopupMessage(layoutName:String = null, layoutAreaFactoryName:String = null, layoutBackgroundResourceName:String = null)
      {
         super();
         if(layoutName == null)
         {
            layoutName = "PopNotifications";
         }
         if(layoutAreaFactoryName == null)
         {
            layoutAreaFactoryName = "PopS";
         }
         if(layoutBackgroundResourceName == null)
         {
            layoutBackgroundResourceName = "pop_s";
         }
         this.mLayoutName = layoutName;
         this.mLayoutAreaFactoryName = layoutAreaFactoryName;
         this.mLayoutBackgroundResourceName = layoutBackgroundResourceName;
      }
      
      protected function setupLayout() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(this.mLayoutAreaFactoryName);
         var doc:DisplayObjectContainer = layoutFactory.getDisplayObjectContainer();
         addChild(doc);
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinSku:String) : void
      {
         var displayObjectContainer:DisplayObjectContainer = null;
         super.setup(popupId,viewFactory,skinSku);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(this.mLayoutAreaFactoryName);
         setFooterArea(layoutFactory.getArea("footer"));
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = viewFactory.getEImage(this.mLayoutBackgroundResourceName,mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var body:ESprite;
         (body = mViewFactory.getESprite(skinSku)).layoutApplyTransformations(layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("Body",body);
         var title:ETextField = mViewFactory.getETextField(skinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(false);
         if(false)
         {
            if((displayObjectContainer = layoutFactory.getDisplayObjectContainer()) != null)
            {
               addChild(displayObjectContainer);
            }
         }
         layoutFactory = mViewFactory.getLayoutAreaFactory(this.mLayoutName);
         if(false)
         {
            if((displayObjectContainer = layoutFactory.getDisplayObjectContainer()) != null)
            {
               body.addChild(displayObjectContainer);
            }
         }
         this.mArrowArea = layoutFactory.getArea("arrow");
         var speechArrow:EImage = mViewFactory.getEImage("speech_arrow",skinSku,false,this.mArrowArea,"speech_color");
         setContent("Speech_Arrow",speechArrow);
         this.mAdvisorArea = layoutFactory.getArea("cbox_img");
         this.mSpeechArea = layoutFactory.getArea("area_speech");
      }
      
      public function setupPopup(advisor:String, title:String, content:ESprite) : void
      {
         var advisorImg:EImage = null;
         var speechBox:ESprite = null;
         var body:ESprite = null;
         var bkg:ESprite = getBackground();
         if(advisor != null)
         {
            advisorImg = mViewFactory.getEImage(advisor,mSkinSku,true,this.mAdvisorArea);
            this.setImage(advisorImg);
         }
         if(title != null)
         {
            setTitleText(title);
            bkg.eAddChild(getTitle());
         }
         if(content != null)
         {
            speechBox = mViewFactory.getSpeechBubble(this.mSpeechArea,this.mArrowArea,content,mSkinSku,"speech_color",false);
            body = getContent("Body");
            setContent("Speech_box",speechBox);
            setContent("Speech_content",content);
            body.eAddChild(speechBox);
            body.eAddChild(getContent("Speech_Arrow"));
            body.eAddChild(content);
         }
      }
      
      public function setImage(value:EImage) : void
      {
         value.setLayoutArea(this.mAdvisorArea,true);
         setContent("Advisor",value);
         getContent("Body").eAddChild(value);
      }
   }
}
