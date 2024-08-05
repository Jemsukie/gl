package com.dchoc.game.eview.popups.offers
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupOneTimeOffer extends EGamePopup
   {
      
      protected static const BODY:String = "Body";
      
      private static const TEXT_INFO:String = "text_info";
      
      private static const TEXT_AVAILABLE:String = "text_time";
      
      private static const TEXT_UPGRADE:String = "text_upgrade";
      
      private static const AREA_CLOCK_BG_ID:String = "area_box";
      
      private static const AREA_CLOCK_ID:String = "icon_text_m";
      
      private static const SHINE_ID:String = "shine";
      
      private static const IMG_ID:String = "img";
      
      private static const IMG_UNIT_ID:String = "unit";
       
      
      protected var mLayoutName:String;
      
      protected var mLayoutAreaFactoryName:String;
      
      protected var mLayoutBackgroundResourceName:String;
      
      private var mShineLayout:ELayoutArea;
      
      private var mShineImage:EImage;
      
      private var mAssetArea:ELayoutArea;
      
      private var mAsset:EImage;
      
      private var mAssetUnit:EImage;
      
      private var mRemainingTime:Number;
      
      private var mTimerField:ETextField;
      
      public function EPopupOneTimeOffer()
      {
         super();
         this.mLayoutName = "PopupLayoutOneTimeOffer";
         this.mLayoutAreaFactoryName = "PopM";
         this.mLayoutBackgroundResourceName = "pop_m";
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mLayoutName = null;
         this.mLayoutAreaFactoryName = null;
         this.mLayoutBackgroundResourceName = null;
         if(this.mShineLayout != null)
         {
            this.mShineLayout.destroy();
            this.mShineLayout = null;
         }
         if(this.mShineImage != null)
         {
            this.mShineImage.destroy();
            this.mShineImage = null;
         }
         if(this.mAsset != null)
         {
            this.mAsset.destroy();
            this.mAsset = null;
         }
         if(this.mAssetUnit != null)
         {
            this.mAssetUnit.destroy();
            this.mAssetUnit = null;
         }
         this.mAssetArea = null;
         if(this.mTimerField != null)
         {
            this.mTimerField.destroy();
            this.mTimerField = null;
         }
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var textArea:ELayoutTextArea = null;
         var textField:ETextField = null;
         var button:EButton = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory(this.mLayoutName);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(this.mLayoutAreaFactoryName);
         var content:ESprite = viewFactory.getESprite(skinId);
         setFooterArea(layoutFactory.getArea("footer"));
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = viewFactory.getEImage(this.mLayoutBackgroundResourceName,mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var body:ESprite;
         (body = mViewFactory.getESprite(mSkinSku)).layoutApplyTransformations(layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("Body",body);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         setTitleText(DCTextMng.getText(484));
         bkg.eAddChild(getTitle());
         textArea = popupLayoutFactory.getTextArea("text_info");
         (textField = mViewFactory.getETextField(mSkinSku,textArea)).setText("DEFAULT_INFO_TEXT");
         textField.setVAlign("top");
         textField.applySkinProp(mSkinSku,"text_body");
         setContent("text_info",textField);
         content.eAddChild(textField);
         textArea = popupLayoutFactory.getTextArea("text_time");
         (textField = mViewFactory.getETextField(mSkinSku,textArea)).setText(DCTextMng.getText(489));
         textField.applySkinProp(mSkinSku,"text_body");
         setContent("text_time",textField);
         content.eAddChild(textField);
         var timerArea:ELayoutArea = popupLayoutFactory.getArea("icon_text_m");
         var clockContainer:ESpriteContainer = mViewFactory.getContentIconWithTextHorizontal("IconTextM","icon_clock",DCTextMng.convertTimeToStringColon(0),mSkinSku,null,true);
         var img:EImage = mViewFactory.getEImage("box_with_border",mSkinSku,false,popupLayoutFactory.getArea("area_box"));
         setContent("area_box",img);
         content.eAddChild(img);
         content.eAddChild(clockContainer);
         setContent("icon_text_m",clockContainer);
         textField = clockContainer.getContent("text") as ETextField;
         textField.width = textField.textWithMarginWidth;
         this.mTimerField = textField;
         this.mTimerField.applySkinProp(mSkinSku,"box_with_border");
         this.mTimerField.applySkinProp(mSkinSku,"text_title_1");
         mViewFactory.distributeSpritesInArea(timerArea,[clockContainer],1,1);
         clockContainer.logicLeft += timerArea.x;
         clockContainer.logicTop += timerArea.y;
         this.mAssetArea = popupLayoutFactory.getArea("img");
         this.mAsset = mViewFactory.getEImage("units_group",mSkinSku,true,this.mAssetArea);
         content.eAddChild(this.mAsset);
         this.mAssetArea = popupLayoutFactory.getArea("unit");
         this.mAssetUnit = mViewFactory.getEImage("pngs_shop/pngs_shop_soldiers/shop_bazooka_001",mSkinSku,true,this.mAssetArea);
         content.eAddChild(this.mAssetUnit);
         this.mShineLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(popupLayoutFactory.getArea("shine"));
         this.mShineLayout.pivotX = 0.5;
         this.mShineLayout.pivotY = 0.5;
         this.mShineImage = mViewFactory.getEImage("shine",mSkinSku,false,this.mShineLayout);
         this.mShineImage.setPivotLogicXY(0.5,0.5);
         content.eAddChild(this.mShineImage);
         textArea = popupLayoutFactory.getTextArea("text_upgrade");
         (textField = mViewFactory.getETextField(mSkinSku,textArea)).setText("DEFAULT_UPGRADE_TEXT");
         textField.applySkinProp(mSkinSku,"text_title_1");
         setContent("text_upgrade",textField);
         content.eAddChild(textField);
         body.eAddChild(content);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         button = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(456));
         addButton("btn_accept",button);
         button.eAddEventListener("click",this.onAcceptButton);
      }
      
      public function setUpgradeInfoText(string:String) : void
      {
         (getContent("text_info") as ETextField).setText(string);
      }
      
      public function setRemainingTime(value:Number) : void
      {
         this.mRemainingTime = value;
      }
      
      public function setUpgradeText(string:String) : void
      {
         (getContent("text_upgrade") as ETextField).setText(string);
      }
      
      public function setAsset(assetId:String) : void
      {
         mViewFactory.setTextureToImage(assetId,mSkinSku,this.mAsset);
      }
      
      public function setAssetPath(assetPath:String) : void
      {
         InstanceMng.getResourceMng().addImageResourceToLoad(this.mAsset,assetPath);
      }
      
      public function setForegroundAsset(assetId:String) : void
      {
         if(assetId)
         {
            mViewFactory.setTextureToImage(assetId,mSkinSku,this.mAssetUnit);
            this.mAssetUnit.visible = true;
         }
         else
         {
            this.mAssetUnit.visible = false;
         }
      }
      
      public function setForegroundAssetPath(assetPath:String) : void
      {
         InstanceMng.getResourceMng().addImageResourceToLoad(this.mAssetUnit,assetPath);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mShineImage)
         {
            this.mShineImage.rotation += dt / 30;
         }
         this.mRemainingTime -= dt;
         if(this.mRemainingTime > 0)
         {
            this.mTimerField.setText(DCTextMng.convertTimeToStringColon(this.mRemainingTime));
         }
         else
         {
            this.close();
         }
      }
      
      private function onAcceptButton(evt:EEvent) : void
      {
         super.notifyPopupMngClose(this);
         var notificationToSend:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyBuyGold",InstanceMng.getGUIController(),null,null);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),notificationToSend,true);
      }
   }
}
