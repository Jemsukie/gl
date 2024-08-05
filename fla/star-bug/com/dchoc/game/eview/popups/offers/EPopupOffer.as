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
   
   public class EPopupOffer extends EGamePopup
   {
      
      protected static const BODY:String = "Body";
      
      private static const TEXT_INFO:String = "text_info";
      
      private static const IMG_ID:String = "img";
      
      private static const IMG_ICON_ID:String = "icon";
       
      
      protected var mLayoutName:String;
      
      protected var mLayoutAreaFactoryName:String;
      
      protected var mLayoutBackgroundResourceName:String;
      
      protected var mAssetId:String;
      
      protected var mNumItems:String;
      
      private var mInfoTextfield:ETextField;
      
      private var mEntryStr:String;
      
      private var mOrigin:String;
      
      public function EPopupOffer(entryStr:String, assetId:String, numItems:String)
      {
         super();
         this.mLayoutName = "PopupLayoutOffer";
         this.mLayoutAreaFactoryName = "PopM";
         this.mLayoutBackgroundResourceName = "pop_m";
         this.mAssetId = assetId;
         this.mNumItems = numItems;
         this.setEntry(entryStr);
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var textArea:ELayoutTextArea = null;
         var img:ESpriteContainer = null;
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
         this.mInfoTextfield = mViewFactory.getETextField(mSkinSku,textArea);
         this.mInfoTextfield.setText("DEFAULT_INFO_TEXT");
         this.mInfoTextfield.setVAlign("top");
         this.mInfoTextfield.applySkinProp(mSkinSku,"text_body");
         setContent("text_info",this.mInfoTextfield);
         content.eAddChild(this.mInfoTextfield);
         var imageArea:ELayoutArea = popupLayoutFactory.getArea("img");
         var image:EImage = mViewFactory.getEImage("offer_starlings",mSkinSku,true,imageArea);
         content.eAddChild(image);
         (img = mViewFactory.getContentIconWithTextVertical("ContainerItem",this.mAssetId,"x" + this.mNumItems,mSkinSku,"text_title_1",true)).setLayoutArea(popupLayoutFactory.getArea("icon"),true);
         img.filters = [GameConstants.FILTER_GLOW_BLUE_ITEMS];
         img.name = "iconImage";
         content.eAddChild(img);
         body.eAddChild(content);
         var closeButton:EButton;
         (closeButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"))).eAddEventListener("click",notifyPopupMngClose);
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         button = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(658));
         addButton("btn_accept",button);
         button.eAddEventListener("click",this.onAcceptClose);
      }
      
      public function setText(text:String) : void
      {
         this.mInfoTextfield.setText(text);
      }
      
      public function setOrigin(origin:String) : void
      {
         this.mOrigin = origin;
      }
      
      public function setEntry(entry:String) : void
      {
         this.mEntryStr = entry;
      }
      
      private function onAcceptClose(event:EEvent) : void
      {
         super.notifyPopupMngClose(null);
         InstanceMng.getUserDataMng().notifyPurchasePromotion(this.mEntryStr,this.mOrigin);
      }
   }
}
