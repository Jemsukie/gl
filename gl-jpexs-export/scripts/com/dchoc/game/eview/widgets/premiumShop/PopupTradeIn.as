package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.messages.EPopupMessage;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class PopupTradeIn extends EPopupMessage
   {
      
      private static const TITLE_ID:String = "text_info";
      
      private static const BODY_ID:String = "text_value";
      
      private static const BODY_NOTITLE_ID:String = "text_value";
      
      private static const IMAGE_ID:String = "icon";
      
      private static const SHINE_ID:String = "shine";
      
      private static const ITEM_AMOUNT_TEXT_ID:String = "text";
      
      private static const DEFAULT_TEXT:String = "TEXT_NOT_SET";
      
      public static const BUTTON_ACCEPT:String = "btn_accept";
      
      public static const BUTTON_SHARE:String = "btn_share";
      
      private static const ITEM_SCALE_AMOUNT:Number = 0.05;
       
      
      private var mItemLayout:ELayoutArea;
      
      private var mRaysLayout:ELayoutArea;
      
      private var mItemImage:EImage;
      
      private var mRaysImage:EImage;
      
      private var mAssetId:String;
      
      private var mBubbleTitleTF:ETextField;
      
      private var mBubbleBodyTF:ETextField;
      
      private var mBubbleBodyNoTitleTF:ETextField;
      
      private var mItemAmountTF:ETextField;
      
      private var mUpdateDtAccumulated:Number;
      
      private var mItemScaleX:Number;
      
      private var mItemScaleY:Number;
      
      public function PopupTradeIn(assetId:String)
      {
         super();
         mLayoutName = "PopNotificationsMedium";
         mLayoutAreaFactoryName = "PopM";
         mLayoutBackgroundResourceName = "pop_m";
         this.mAssetId = assetId;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         if(this.mItemLayout != null)
         {
            this.mItemLayout.destroy();
            this.mItemLayout = null;
         }
         if(this.mItemImage != null)
         {
            this.mItemImage.destroy();
            this.mItemImage = null;
         }
         if(this.mRaysLayout != null)
         {
            this.mRaysLayout.destroy();
            this.mRaysLayout = null;
         }
         if(this.mRaysImage != null)
         {
            this.mRaysImage.destroy();
            this.mRaysImage = null;
         }
         this.mAssetId = null;
         if(this.mBubbleTitleTF != null)
         {
            this.mBubbleTitleTF.destroy();
            this.mBubbleTitleTF = null;
         }
         if(this.mBubbleBodyTF != null)
         {
            this.mBubbleBodyTF.destroy();
            this.mBubbleBodyTF = null;
         }
         if(this.mBubbleBodyNoTitleTF != null)
         {
            this.mBubbleBodyNoTitleTF.destroy();
            this.mBubbleBodyNoTitleTF = null;
         }
         if(this.mItemAmountTF != null)
         {
            this.mItemAmountTF.destroy();
            this.mItemAmountTF = null;
         }
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinSku:String) : void
      {
         this.setupTradeIn(popupId,viewFactory,skinSku);
      }
      
      public function setupTradeIn(popupId:String, viewFactory:ViewFactory, skinSku:String, useShare:Boolean = false, advisor:String = null) : void
      {
         var textArea:ELayoutTextArea = null;
         var button:EButton = null;
         var body:ESprite = null;
         super.setup(popupId,viewFactory,skinSku);
         var popupLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory(mLayoutName);
         var contentLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("ContainerTextField3");
         var content:ESprite = viewFactory.getESprite(skinSku);
         textArea = contentLayoutFactory.getTextArea("text_info");
         this.mBubbleTitleTF = mViewFactory.getETextField(skinSku,textArea);
         setContent("text_info",this.mBubbleTitleTF);
         this.mBubbleTitleTF.setText("TEXT_NOT_SET");
         this.mBubbleTitleTF.applySkinProp(skinSku,"text_body");
         content.eAddChild(this.mBubbleTitleTF);
         textArea = contentLayoutFactory.getTextArea("text_value");
         this.mBubbleBodyTF = mViewFactory.getETextField(skinSku,textArea);
         setContent("text_value",this.mBubbleBodyTF);
         this.mBubbleBodyTF.setText("TEXT_NOT_SET");
         this.mBubbleBodyTF.applySkinProp(skinSku,"text_body");
         content.eAddChild(this.mBubbleBodyTF);
         if(this.mAssetId)
         {
            body = getContent("Body");
            this.mRaysLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(popupLayoutFactory.getArea("shine"));
            this.mRaysLayout.pivotX = 0.5;
            this.mRaysLayout.pivotY = 0.5;
            this.mRaysImage = mViewFactory.getEImage("shine",skinSku,false,this.mRaysLayout);
            this.mRaysImage.setPivotLogicXY(0.5,0.5);
            body.eAddChild(this.mRaysImage);
            this.mItemLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(popupLayoutFactory.getArea("icon"));
            this.mItemLayout.pivotX = 0.5;
            this.mItemLayout.pivotY = 0.5;
            this.mItemImage = mViewFactory.getEImage(this.mAssetId,skinSku,true,this.mItemLayout);
            body.eAddChild(this.mItemImage);
            this.mItemScaleX = this.mItemImage.scaleLogicX;
            this.mItemScaleY = this.mItemImage.scaleLogicY;
         }
         textArea = popupLayoutFactory.getTextArea("text");
         this.mItemAmountTF = mViewFactory.getETextField(skinSku,textArea);
         setContent("text",this.mItemAmountTF);
         this.mItemAmountTF.setText("TEXT_NOT_SET");
         this.mItemAmountTF.applySkinProp(skinSku,"text_title_1");
         body.eAddChild(this.mItemAmountTF);
         button = mViewFactory.getButton("btn_accept",skinSku,"M",DCTextMng.getText(5));
         addButton("btn_accept",button);
         button.eAddEventListener("click",notifyPopupMngClose);
         super.setupPopup(advisor == null ? "scientist_happy" : advisor,"hola",content);
         this.mUpdateDtAccumulated = 0;
      }
      
      public function setTitleSpeechBubble(text:String) : void
      {
         this.mBubbleTitleTF.setText(text);
      }
      
      public function setBodySpeechBubble(text:String) : void
      {
         this.mBubbleBodyTF.setText(text);
      }
      
      public function setAmountTextField(amount:int) : void
      {
         this.mItemAmountTF.setText("x" + amount);
      }
      
      public function setAmountTextFieldVisible(value:Boolean) : void
      {
         this.mItemAmountTF.visible = value;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var scaleDiff:Number = NaN;
         super.logicUpdate(dt);
         this.mUpdateDtAccumulated += dt;
         if(this.mRaysImage)
         {
            this.mRaysImage.rotation += dt / 30;
         }
         if(this.mItemImage)
         {
            scaleDiff = -(0.05 * Math.cos(this.mUpdateDtAccumulated / 400));
            this.mItemImage.scaleLogicX = 1.025 + scaleDiff * this.mItemScaleX;
            this.mItemImage.scaleLogicY = 1.025 + scaleDiff * this.mItemScaleY;
         }
      }
   }
}
