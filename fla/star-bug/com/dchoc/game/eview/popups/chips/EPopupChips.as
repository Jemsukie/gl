package com.dchoc.game.eview.popups.chips
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   
   public class EPopupChips extends EGamePopup
   {
      
      private static const BODY:String = "Body";
      
      private static const CLOCK_BKG:String = "ClockBkg";
      
      private static const CLOCK:String = "Clock";
      
      private static const BUTTON_MOBILE:String = "button_mobile";
      
      private static const BUTTON_BACK:String = "button_back";
      
      private static const BUTTON_OFFER:String = "button_offer";
      
      private static const BOX_SKU:String = "box";
      
      private static const TAB_BUTTON_SKU:String = "tab_button_";
      
      private static const TOTAL_BOXES:int = 6;
      
      private static const TAB_TITLE_IDS:Vector.<String> = new <String>["chips","packs","subscriptions"];
       
      
      private var mTabHeader:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mBody:ESprite;
      
      private var mClockField:ETextField;
      
      private var mMobileButton:EButton;
      
      private var mBackButton:EButton;
      
      private var mOfferButton:EButton;
      
      private var mPayments:EImage;
      
      private var mMobilePaymentsActive:Boolean;
      
      private var mClockBoxVisible:Boolean;
      
      private var mBoxesArea:ELayoutArea;
      
      private var mBoxes:Array;
      
      public function EPopupChips()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground();
         this.setupBody();
         this.loadBoxes();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mClockField = null;
         this.mMobileButton = null;
         this.mBackButton = null;
         this.mOfferButton = null;
         this.mBoxesArea = null;
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXLNoTabsNoFooter");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,layoutFactory.getArea("bg"));
         setBackground(img);
         eAddChild(img);
         this.mBody = mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         setContent("Body",this.mBody);
         img.eAddChild(this.mBody);
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         img.eAddChild(button);
         button.eAddEventListener("click",this.onClosePopup);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(field);
         field.setText(DCTextMng.getText(506));
         img.eAddChild(field);
      }
      
      private function setupBody() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupChipsShop");
         var scale:Number = 1;
         var area:ELayoutArea = layoutFactory.getArea("area_clock");
         var img:EImage = mViewFactory.getEImage("area_timer",mSkinSku,false,area);
         setContent("ClockBkg",img);
         this.mBody.eAddChild(img);
         var content:ESpriteContainer;
         if((content = mViewFactory.getContentIconWithTextHorizontal("IconTextL","icon_clock","00:00:00",mSkinSku,"text_title_1")).height > area.height)
         {
            scale = area.height / content.height;
            content.scaleLogicX = scale;
            content.scaleLogicY = scale;
         }
         setContent("Clock",content);
         this.mBody.eAddChild(content);
         area.centerContent(content);
         this.setClockVisible(InstanceMng.getCustomizerMng().needsOfferToShowTimer());
         area = layoutFactory.getArea("base");
         this.mMobileButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(454),area.width,"btn_common","icon_mobile");
         setContent("button_mobile",this.mMobileButton);
         this.mBody.eAddChild(this.mMobileButton);
         area.centerContent(this.mMobileButton);
         this.mMobileButton.visible = InstanceMng.getPlatformSettingsDefMng().getUseMobilePayments() || InstanceMng.getCreditsMng().mobilePaymentsGetGUIData() != null;
         this.mMobileButton.eAddEventListener("click",this.onMobileClick);
         this.mBackButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(19),area.width,"btn_common");
         setContent("button_back",this.mBackButton);
         this.mBody.eAddChild(this.mBackButton);
         area.centerContent(this.mBackButton);
         this.mBackButton.visible = false;
         this.mBackButton.eAddEventListener("click",this.onBackClick);
         if(InstanceMng.getSettingsDefMng().mSettingsDef.getShowFreeOffers())
         {
            area = layoutFactory.getArea("btn");
            this.mOfferButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(102),area.width,"btn_social");
            this.mBody.eAddChild(this.mOfferButton);
            setContent("button_offer",this.mOfferButton);
            area.centerContent(this.mOfferButton);
            this.mOfferButton.eAddEventListener("click",this.onOfferButton);
         }
         this.mPayments = mViewFactory.getEImage("icon_payment",mSkinSku,true,layoutFactory.getArea("payment"));
         this.mBody.eAddChild(this.mPayments);
         setContent("payment",this.mPayments);
         this.mBoxesArea = layoutFactory.getArea("area_chips");
      }
      
      private function setClockVisible(value:Boolean) : void
      {
         var sp:ESprite = getContent("ClockBkg");
         sp.visible = value;
         sp = getContent("Clock");
         sp.visible = value;
         this.mClockBoxVisible = value;
      }
      
      private function updateClock(time:String) : void
      {
         var content:ESpriteContainer = getContentAsESpriteContainer("Clock");
         if(this.mClockField == null)
         {
            this.mClockField = content.getContentAsETextField("text");
         }
         this.mClockField.setText(time);
         this.mClockField.setVAlign("top");
         this.mClockField.logicTop = content.getLogicHeight() - this.mClockField.getLogicHeight() / 2;
      }
      
      public function loadBoxes() : void
      {
         var numBoxes:int = 0;
         var box:ChipsBox = null;
         var chipsIcon:String = null;
         var i:int = 0;
         var mobilePayments:Array = null;
         var credits:Vector.<DCDef> = null;
         if(this.mBoxes != null)
         {
            numBoxes = int(this.mBoxes.length);
            for(i = 0; i < numBoxes; )
            {
               box = this.mBoxes[i];
               if(this.mBody.contains(box))
               {
                  this.mBody.eRemoveChild(box);
               }
               box.destroy();
               box = null;
               i++;
            }
            this.mBoxes = null;
         }
         this.mBoxes = [];
         if(this.mMobilePaymentsActive)
         {
            mobilePayments = InstanceMng.getCreditsMng().mobilePaymentsGetGUIData();
            numBoxes = int(mobilePayments.length);
         }
         else
         {
            numBoxes = int((credits = InstanceMng.getCreditsMng().getDefs()).length);
         }
         i = 0;
         while(i < numBoxes && i < 6)
         {
            box = new ChipsBox(mViewFactory);
            chipsIcon = "chips0" + (i + 1);
            if(this.mMobilePaymentsActive)
            {
               box.setup(mobilePayments[i],chipsIcon,this);
            }
            else
            {
               box.setup(credits[i],chipsIcon,this);
            }
            this.mBoxes.push(box);
            this.mBody.eAddChild(box);
            setContent("box" + i,box);
            i++;
         }
         numBoxes = 6 - numBoxes;
         for(i = 0; i < numBoxes; )
         {
            (box = new ChipsBox(mViewFactory)).setup(null,null,this);
            this.mBoxes.push(box);
            i++;
         }
         mViewFactory.distributeSpritesInArea(this.mBoxesArea,this.mBoxes,1,1,3,2,true);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         var box:ESprite = null;
         if(this.mClockBoxVisible)
         {
            this.updateClock(InstanceMng.getCustomizerMng().getOfferTimeLeft());
            if(!InstanceMng.getCustomizerMng().needsOfferToShowTimer())
            {
               this.setClockVisible(false);
            }
         }
         if(!InstanceMng.getPlatformSettingsDefMng().getUseMobilePayments())
         {
            this.mMobileButton.visible = InstanceMng.getCreditsMng().mobilePaymentsGetGUIData() != null && !this.mMobilePaymentsActive;
         }
         var boxesCount:int = int(this.mBoxes.length);
         for(i = 0; i < boxesCount; )
         {
            box = this.mBoxes[i];
            if(box != null)
            {
               box.logicUpdate(dt);
            }
            i++;
         }
      }
      
      private function onMobileClick(e:EEvent) : void
      {
         if(InstanceMng.getPlatformSettingsDefMng().getUseMobilePayments())
         {
            InstanceMng.getApplication().setToWindowedMode();
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_PURCHASE_MOBILE_PAYMENTS);
            this.onClosePopup(null);
         }
         else
         {
            this.mMobilePaymentsActive = true;
            this.mBackButton.visible = true;
            this.mMobileButton.visible = false;
            this.loadBoxes();
            this.mPayments.visible = false;
         }
      }
      
      private function onBackClick(e:EEvent) : void
      {
         this.mMobilePaymentsActive = false;
         this.mBackButton.visible = false;
         this.mMobileButton.visible = true;
         this.loadBoxes();
         this.mPayments.visible = true;
      }
      
      private function onClosePopup(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onOfferButton(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OFFER_CREDITS);
      }
   }
}
