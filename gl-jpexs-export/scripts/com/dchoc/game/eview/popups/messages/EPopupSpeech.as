package com.dchoc.game.eview.popups.messages
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.utils.text.DCTextTyped;
   import com.dchoc.toolkit.view.gui.popups.DCIPopupSpeech;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import flash.text.TextField;
   
   public class EPopupSpeech extends EGamePopup implements DCIPopupSpeech
   {
      
      private static const ADVISOR_SKU:String = "advisor";
      
      private static const CONTAINER_SKU:String = "container";
      
      private static const CONTENT_SKU:String = "content";
      
      private static const SPEECH_SKU:String = "speech";
      
      private static const SPEECH_ARROW_SKU:String = "speechArrow";
      
      private static const SPEECH_TITLE_SKU:String = "speechTitle";
      
      private static const SPEECH_BODY_SKU:String = "speechBody";
      
      private static const BUTTON_SKU:String = "button";
      
      public static const ALIGN_V_CENTER:int = 0;
      
      public static const ALIGN_V_BOTTOM:int = 1;
      
      public static const ALIGN_V_TOP:int = 2;
       
      
      private var mLayoutFactory:ELayoutAreaFactory;
      
      private var mVAlign:int;
      
      private var mUseBubble:Boolean;
      
      private var mNeedsToPlayAnim:Boolean;
      
      private var mAdvisorOnRightSide:Boolean;
      
      private var mTextTyped:DCTextTyped;
      
      public function EPopupSpeech()
      {
         super();
         this.reset();
      }
      
      private function reset() : void
      {
         this.mAdvisorOnRightSide = false;
         this.mUseBubble = false;
         this.mNeedsToPlayAnim = false;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mLayoutFactory = null;
         this.mTextTyped = null;
      }
      
      private function getLayoutFactory() : ELayoutAreaFactory
      {
         var areaName:String = null;
         var area:ELayoutArea = null;
         if(this.mLayoutFactory == null)
         {
            areaName = this.mAdvisorOnRightSide ? "PopSpeechRight" : "PopSpeech";
            this.mLayoutFactory = mViewFactory.getLayoutAreaFactory(areaName);
            area = this.mLayoutFactory.getContainerLayoutArea();
            setLayoutArea(area);
         }
         return this.mLayoutFactory;
      }
      
      private function setupAdvisor(advisorId:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = this.getLayoutFactory();
         var advisor:EImage = mViewFactory.getEImage(advisorId,mSkinSku,true,layoutFactory.getArea("img"));
         setContent("advisor",advisor);
         this.eAddChild(advisor);
      }
      
      private function setupButton(button:EButton) : void
      {
         var speech:ESprite = null;
         var layoutFactory:ELayoutAreaFactory;
         var speechArea:ELayoutArea = (layoutFactory = this.getLayoutFactory()).getArea("area_speech");
         setContent("button",button);
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("btn"));
         speech = this.getSpeech();
         area.x -= speechArea.x;
         area.y = speech.getLogicHeight() - button.getLogicHeight() / 2;
         button.layoutApplyTransformations(area);
         speech.eAddChild(button);
      }
      
      public function setupTextSpeech(title:String, body:String, advisorOnRightSide:Boolean = false) : void
      {
         this.mAdvisorOnRightSide = advisorOnRightSide;
         var layoutFactory:ELayoutAreaFactory;
         var speechArea:ELayoutArea = (layoutFactory = this.getLayoutFactory()).getArea("area_speech");
         var container:ESprite = mViewFactory.getESprite(mSkinSku);
         setContent("content",container);
         var bodyArea:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(layoutFactory.getTextArea("text"));
         bodyArea.x -= speechArea.x;
         bodyArea.y = 0;
         var eBody:ETextField;
         (eBody = mViewFactory.getETextField(mSkinSku,bodyArea)).setText(body);
         eBody.applySkinProp(mSkinSku,"text_body");
         setContent("speechBody",eBody);
         container.eAddChild(eBody);
         this.setupESpriteSpeech(container,advisorOnRightSide);
         var speech:ESprite = this.getSpeech();
         var titleArea:ELayoutTextArea = layoutFactory.getTextArea("text_title");
         var eTitle:ETextField = mViewFactory.getETextField(mSkinSku,titleArea);
         setContent("speechTitle",eTitle);
         eTitle.applySkinProp(mSkinSku,"text_subheader");
         eTitle.x -= speechArea.x;
         eTitle.y -= speechArea.y;
         eTitle.setText(title);
         speech.eAddChild(eTitle);
      }
      
      public function setupESpriteSpeech(content:ESprite, advisorOnRightSide:Boolean = false) : void
      {
         this.mAdvisorOnRightSide = advisorOnRightSide;
         var container:ESprite = mViewFactory.getESprite(mSkinSku);
         setContent("container",container);
         var layoutFactory:ELayoutAreaFactory = this.getLayoutFactory();
         var speechArea:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("area_speech"));
         var origSpeechX:int = 0;
         if(this.mAdvisorOnRightSide)
         {
            origSpeechX = speechArea.x;
            speechArea.x += speechArea.width;
         }
         var btnArea:ELayoutArea = layoutFactory.getArea("btn");
         var speech:ESprite = mViewFactory.getSpeechBubble(speechArea,layoutFactory.getArea("arrow"),content,mSkinSku,null,false,"box_with_border",btnArea.height / 2);
         if(this.mAdvisorOnRightSide)
         {
            speech.setPivotLogicXY(1,0);
         }
         setContent("speech",speech);
         var arrowArea:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("arrow"));
         arrowArea.x -= origSpeechX;
         arrowArea.y = speech.logicTop + (speech.getLogicHeight() - arrowArea.height) / 2;
         var speechArrow:EImage = mViewFactory.getEImage("speech_arrow_1",mSkinSku,false,arrowArea);
         setContent("speechArrow",speechArrow);
         container.eAddChild(speech);
         container.eAddChild(speechArrow);
         container.eAddChild(content);
         if(this.mAdvisorOnRightSide)
         {
            content.logicX -= speech.logicX;
         }
         this.eAddChild(container);
      }
      
      public function setupCommon(advisorId:String, button:EButton = null, useBubble:Boolean = false, vAlign:int = 0, needsToPlayAnim:Boolean = true) : void
      {
         var eBody:ETextField = null;
         this.setupAdvisor(advisorId);
         if(button != null)
         {
            this.setupButton(button);
         }
         this.mUseBubble = useBubble;
         this.mVAlign = vAlign;
         this.mNeedsToPlayAnim = needsToPlayAnim;
         if(this.mNeedsToPlayAnim)
         {
            this.getContainer().visible = false;
            if((eBody = getContentAsETextField("speechBody")) != null)
            {
               eBody.setHAlign("left");
               eBody.visible = false;
            }
         }
      }
      
      public function isTyping() : Boolean
      {
         if(this.mTextTyped == null)
         {
            return false;
         }
         return this.mTextTyped.isTyping();
      }
      
      public function usesBubble() : Boolean
      {
         return this.mUseBubble;
      }
      
      override public function resize() : void
      {
         super.resize();
         var stageH:int = InstanceMng.getApplication().stageGetHeight();
         switch(this.mVAlign - 1)
         {
            case 0:
               y = stageH - getLogicHeight();
               break;
            case 1:
               y = 0;
         }
      }
      
      private function getContainer() : ESprite
      {
         return getContent("container");
      }
      
      private function getSpeech() : ESprite
      {
         return getContent("speech");
      }
      
      override public function notify(e:Object) : Boolean
      {
         var container:ESprite = null;
         var _loc3_:* = e.cmd;
         if("NOTIFY_EFFECT_END" === _loc3_)
         {
            if(mOpening && this.mNeedsToPlayAnim)
            {
               container = this.getContainer();
               if(container != null)
               {
                  container.visible = true;
                  TweenEffectsFactory.createAccordionHorizontal(0,this.getSpeech(),this.onTweenOpeningComplete);
               }
            }
         }
         return super.notify(e);
      }
      
      private function onTweenOpeningComplete(e:Object) : void
      {
         this.startTypingAnim();
      }
      
      private function startTypingAnim() : void
      {
         var textField:TextField = null;
         var htmlText:String = null;
         var eBody:ETextField = getContentAsETextField("speechBody");
         if(eBody != null)
         {
            textField = eBody.getTextField();
            htmlText = textField.htmlText;
            eBody.visible = true;
            this.mTextTyped = new DCTextTyped(textField);
            this.mTextTyped.type(htmlText,null,22);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mTextTyped != null)
         {
            this.mTextTyped.update(dt);
         }
      }
   }
}
