package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class PopupRewardObtained extends EGamePopup
   {
      
      protected static const SUBTITLE:String = "subtitle";
      
      protected static const SUBTITLE_ICON:String = "container_icon_text";
      
      protected static const SHARE_BUTTON:String = "shareButton";
      
      protected static const BODY:String = "body";
      
      protected static const ILLUSTRATION:String = "illustration";
      
      protected static const TEXT_POSITION:String = "textPosition";
      
      protected static const REWARD_BOX:String = "rewardBox";
      
      protected static const UNIT_IMAGE:String = "units_unlocked";
      
      protected static const REWARD_UNIT_BOX:String = "box_units_unlocked";
      
      private static const DEFAULT_TEXT:String = "DEFAULT_TEXT_INFO";
       
      
      private var mImageID:String;
      
      protected var mRaysImage:EImage;
      
      protected var mRewardArea:ELayoutArea;
      
      private var mSubtitleLayoutArea:ELayoutArea;
      
      protected var mImageUnitArea:ELayoutArea;
      
      protected var mBoxUnitArea:ELayoutArea;
      
      private var mSubtitleIconBoxLayoutArea:ELayoutArea;
      
      private var mTopTextLayoutArea:ELayoutArea;
      
      public function PopupRewardObtained()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mImageID = null;
         this.mRaysImage = null;
         this.mRewardArea = null;
         this.mSubtitleLayoutArea = null;
         this.mImageUnitArea = null;
         this.mBoxUnitArea = null;
         if(this.mSubtitleIconBoxLayoutArea != null)
         {
            this.mSubtitleIconBoxLayoutArea.destroy();
            this.mSubtitleIconBoxLayoutArea = null;
         }
         if(this.mTopTextLayoutArea != null)
         {
            this.mTopTextLayoutArea.destroy();
            this.mTopTextLayoutArea = null;
         }
      }
      
      protected function setTopText(value:String) : void
      {
         var body:ESprite = getContent("body");
         var box:ESprite = getContent("subtitle_bkg");
         if(box)
         {
            body.eRemoveChild(box);
         }
         var textField:ETextField;
         (textField = getContent("subtitle") as ETextField).setText(value);
         this.mTopTextLayoutArea = ELayoutAreaFactory.createLayoutArea();
         this.mTopTextLayoutArea.height = textField.textWithMarginHeight / textField.scaleLogicY;
         this.mTopTextLayoutArea.width = textField.textWithMarginWidth / textField.scaleLogicX;
         this.mTopTextLayoutArea.x = (textField.width - this.mTopTextLayoutArea.width) / 2;
         this.mTopTextLayoutArea.y = (textField.height - this.mTopTextLayoutArea.height) / 2;
         box = this.createBgBox(this.mTopTextLayoutArea,"mission_box",10,10);
         var index:int = body.getChildIndex(textField);
         body.eAddChildAt(box,index);
         setContent("subtitle_bkg",box);
      }
      
      protected function setBottomText(value:String) : void
      {
         var textField:ETextField = getContent("textPosition") as ETextField;
         textField.setText(value);
      }
      
      protected function setIllustration(imageID:String) : void
      {
         var image:EImage = getContent("illustration") as EImage;
         mViewFactory.setTextureToImage(imageID,mSkinSku,image);
      }
      
      protected function createRewardBox(entryStr:String, textureSku:String, createShine:Boolean = true) : void
      {
         var body:ESprite = getContent("body");
         var reward:ESpriteContainer;
         if(reward = getContent("rewardBox") as ESpriteContainer)
         {
            reward.destroy();
            body.eRemoveChild(reward);
         }
         reward = mViewFactory.getRewardBox(entryStr,textureSku,mSkinSku);
         body.eAddChild(reward);
         setContent("rewardBox",reward);
         this.mRewardArea.centerContent(reward);
         if(createShine)
         {
            this.mRaysImage = mViewFactory.getEImage("shine",mSkinSku,false);
            this.mRaysImage.onSetTextureLoaded = this.centerRays;
            this.mRaysImage.logicX = reward.width / 2;
            this.mRaysImage.logicY = reward.height / 2;
            this.mRaysImage.setPivotLogicXY(0.5,0.5);
            reward.eAddChildAt(this.mRaysImage,1);
            setContent("shine",this.mRaysImage);
         }
      }
      
      protected function centerRays(image:EImage) : void
      {
         this.mRaysImage.setPivotLogicXY(0.5,0.5);
      }
      
      protected function createSubtitleIconBox(text:String) : void
      {
         var body:ESprite = getContent("body");
         var subtitle:ESpriteContainer = getContent("container_icon_text") as ESpriteContainer;
         if(subtitle)
         {
            body.eRemoveChild(subtitle);
         }
         subtitle = mViewFactory.getContentIconWithTextHorizontal("IconTextXL","icon_score_level",text,mSkinSku,"text_title_3");
         this.mSubtitleIconBoxLayoutArea = ELayoutAreaFactory.createLayoutArea();
         this.mSubtitleIconBoxLayoutArea.height = subtitle.height / subtitle.scaleLogicY;
         this.mSubtitleIconBoxLayoutArea.width = subtitle.width / subtitle.scaleLogicX;
         var box:ESprite = this.createBgBox(this.mSubtitleIconBoxLayoutArea,"mission_box",10,0);
         subtitle.eAddChildAt(box,0);
         subtitle.setContent("container_icon_text_bkg",box);
         subtitle.layoutApplyTransformations(this.mSubtitleLayoutArea);
         body.eAddChild(subtitle);
         setContent("container_icon_text",subtitle);
         this.mSubtitleLayoutArea.centerContent(subtitle);
      }
      
      private function createBgBox(layout:ELayoutArea, boxSku:String, paddingH:int, paddingV:int) : ESprite
      {
         layout.x -= paddingH;
         layout.y -= paddingV;
         layout.width += 2 * paddingH;
         layout.height += 2 * paddingV;
         return mViewFactory.getEImage(boxSku,mSkinSku,false,layout);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mRaysImage)
         {
            this.mRaysImage.rotation += dt / 30;
         }
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var area:ELayoutArea = null;
         var button:EButton = null;
         super.setup(popupId,viewFactory,skinId);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopM");
         var bkg:EImage = mViewFactory.getEImage("pop_m",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(bkg);
         setBackground(bkg);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         bkg.eAddChild(field);
         setTitle(field);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(0),0,"btn_accept");
         bkg.eAddChild(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         (area = layoutFactory.getArea("footer")).centerContent(button);
         button = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         var body:ESprite = mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         body = getContent("body");
         layoutFactory = mViewFactory.getLayoutAreaFactory("PopMissionComplete");
         var img:EImage = mViewFactory.getEImage(null,mSkinSku,true,layoutFactory.getArea("box_ilustration"));
         body.eAddChild(img);
         setContent("illustration",img);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_congrats"));
         body.eAddChild(field);
         setContent("subtitle",field);
         field.applySkinProp(mSkinSku,"text_title_1");
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"));
         body.eAddChild(field);
         setContent("textPosition",field);
         field.applySkinProp(mSkinSku,"text_body");
         this.mRewardArea = layoutFactory.getArea("container_rewards");
         this.mSubtitleLayoutArea = layoutFactory.getArea("container_icon_text");
         this.mImageUnitArea = layoutFactory.getArea("units_unlocked");
         this.mBoxUnitArea = layoutFactory.getArea("box_units_unlocked");
      }
   }
}
