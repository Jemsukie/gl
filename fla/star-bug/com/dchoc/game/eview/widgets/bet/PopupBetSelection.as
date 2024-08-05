package com.dchoc.game.eview.widgets.bet
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class PopupBetSelection extends EGamePopup
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const INFO_TEXT_SKU:String = "infoText";
      
      private static const ADVISOR_SKU:String = "advisor";
      
      private static const ARROW_IMAGE_SKU:String = "arrowImage";
      
      private static const SPEECH_BABBLE_SKU:String = "speechBubble";
      
      private static const SPEECH_TEXT_SKU:String = "speechText";
      
      private static const CLOSE_BUTTON_SKU:String = "closeButton";
      
      private static const BET_BOX_SKU:String = "betBox";
      
      private static const BET_BOXES_CONTAINER:String = "betBoxesContainer";
      
      private static const INFO_ICONS_CONTAINER_SKU:String = "infoIconsContainer";
      
      private static const INFO_TIME_SKU:String = "infoTime";
      
      private static const INFO_SCORE_SKU:String = "infoScore";
      
      private static const SPEECH_CONTENT_SKU:String = "speechContent";
       
      
      public function PopupBetSelection()
      {
         super();
      }
      
      public function setupPopup(viewFactory:ViewFactory) : void
      {
         var i:int = 0;
         var areaBoxes:ELayoutArea = null;
         var betBox:BetBox = null;
         mViewFactory = viewFactory;
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = viewFactory.getLayoutAreaFactory("PopXL")).getArea("bg");
         setLayoutArea(area);
         var bkg:ESprite = viewFactory.getEImage("pop_xl",mSkinSku,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text_title");
         var title:ETextField = viewFactory.getETextField(mSkinSku,textArea,"text_title_0");
         setTitle(title);
         bkg.eAddChild(title);
         title.setText(DCTextMng.getText(332));
         var areaBody:ELayoutArea = layoutFactory.getArea("body");
         var body:ESprite = viewFactory.getESprite(mSkinSku);
         setContent("body",body);
         body.layoutApplyTransformations(areaBody);
         bkg.eAddChild(body);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku);
         setContent("closeButton",closeButton);
         closeButton.layoutApplyTransformations(layoutFactory.getArea("btn_close"));
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         bkg.eAddChild(closeButton);
         layoutFactory = viewFactory.getLayoutAreaFactory("PopBetting");
         var infoText:ETextField = viewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"));
         setContent("infoText",infoText);
         infoText.setText(DCTextMng.getText(333));
         body.eAddChild(infoText);
         infoText.applySkinProp(mSkinSku,"text_title_1");
         var arrowArea:ELayoutArea = layoutFactory.getArea("arrow");
         var arrowImage:EImage = viewFactory.getEImage("speech_arrow",mSkinSku,false,arrowArea,"speech_color");
         setContent("arrowImage",arrowImage);
         body.eAddChild(arrowImage);
         var speechContent:ESpriteContainer = viewFactory.getESpriteContainer();
         setContent("speechContent",speechContent);
         var speechTextArea:ELayoutTextArea = layoutFactory.getTextArea("text_speech");
         var speechText:ETextField = viewFactory.getETextField(mSkinSku,speechTextArea);
         speechText.logicLeft = 0;
         speechText.logicTop = 0;
         speechContent.setContent("speechText",speechText);
         if(InstanceMng.getBetMng().getBetsCount() == 0)
         {
            speechText.setText(DCTextMng.getText(334));
         }
         else
         {
            speechText.setText(DCTextMng.getText(335));
         }
         speechContent.eAddChild(speechText);
         speechText.applySkinProp(mSkinSku,"text_body");
         area = layoutFactory.getArea("container_icon_text");
         var contents:Array = [];
         var infoIconsContainer:ESpriteContainer = viewFactory.getESpriteContainer();
         setContent("infoIconsContainer",infoIconsContainer);
         var content:ESpriteContainer = mViewFactory.getContentIconWithTextHorizontal("IconTextLLarge",null,DCTextMng.getText(336),mSkinSku,"text_title_1");
         infoIconsContainer.setContent("infoScore",content);
         contents.push(content);
         infoIconsContainer.eAddChild(content);
         var field1:ETextField = content.getContentAsETextField("text");
         content = mViewFactory.getContentIconWithTextHorizontal("IconTextLLarge",null,DCTextMng.getText(337),mSkinSku,"text_title_1");
         infoIconsContainer.setContent("infoTime",content);
         contents.push(content);
         infoIconsContainer.eAddChild(content);
         var field2:ETextField = content.getContentAsETextField("text");
         var size:Number;
         if((size = field1.getFontSizeAfterScale()) > field2.getFontSizeAfterScale())
         {
            size = field2.getFontSizeAfterScale();
         }
         field1.setFontSize(size);
         field2.setFontSize(size);
         var offY:int = 0;
         for(i = 0; i < contents.length; )
         {
            (content = contents[i]).logicLeft = 0;
            content.logicTop = offY;
            offY += content.height;
            i++;
         }
         infoIconsContainer.setLayoutArea(area,true);
         infoIconsContainer.logicTop = speechText.height;
         infoIconsContainer.logicLeft -= area.x;
         speechContent.eAddChild(infoIconsContainer);
         var speechBubble:ESprite = viewFactory.getSpeechBubble(layoutFactory.getArea("area_speech"),arrowArea,null,mSkinSku,"speech_color");
         setContent("speechBubble",speechBubble);
         body.eAddChild(speechBubble);
         body.eAddChild(speechContent);
         speechContent.logicLeft = speechTextArea.x;
         speechContent.logicTop = speechTextArea.y;
         area = layoutFactory.getArea("cbox_img");
         var advisor:EImage = viewFactory.getEImage("captain_happy",mSkinSku,true,area);
         body.eAddChild(advisor);
         setContent("advisor",advisor);
         areaBoxes = layoutFactory.getArea("container_box");
         var betBoxes:Array = [];
         var betDefs:Vector.<DCDef> = InstanceMng.getBetDefMng().getDefs();
         var betsCount:int = int(betDefs.length);
         var betBoxesContainer:ESprite = new ESprite();
         for(i = 0; i < betsCount; )
         {
            betBox = new BetBox(mViewFactory);
            setContent("betBox" + i,betBox);
            mViewFactory.setButtonBehaviors(betBox);
            betBox.setup(betDefs[i].mSku);
            betBoxesContainer.eAddChild(betBox);
            betBoxes.push(betBox);
            i++;
         }
         body.eAddChild(betBoxesContainer);
         mViewFactory.distributeSpritesInArea(areaBoxes,betBoxes,0,1);
         betBoxesContainer.logicLeft = areaBoxes.x;
         betBoxesContainer.logicTop = areaBoxes.y;
         setContent("betBoxesContainer",betBoxesContainer);
         betBoxes.length = 0;
         betBoxes = null;
      }
   }
}
