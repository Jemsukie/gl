package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWave;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.userdata.Profile;
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
   import flash.utils.Dictionary;
   
   public class EPopupHappeningGiftProgress extends EGamePopup implements INotifyReceiver
   {
      
      private static const BUTTON_SHOP:String = "btn_shop";
      
      private static const IMAGE_GIFT_BAR:String = "gift_bar";
      
      private static const IMAGE_BANNER:String = "banner";
      
      private static const IMAGE_CHARACTER:String = "character";
      
      private static const IMAGE_SPEECH:String = "body_speech";
      
      private static const IMAGE_SPEECH_ARROW:String = "speech_arrow";
      
      private static const TEXT_BODY_STORY:String = "text_body_story";
      
      private static const TEXT_ITEM_COUNT:String = "text_item_count";
      
      private static const TEXT_COUNTDOWN_BODY:String = "text_countdown_body";
      
      private static const TEXT_COUNTDOWN_TIMER:String = "text_countdown_timer";
      
      private static const TEXT_COUNTDOWN_EVENT_TIMER:String = "text_countdown_event_timer";
      
      private static const TEXT_SHOP:String = "text_shop";
      
      private static const COUNT_TEXT_ID:String = "AURORA_COUNT";
      
      private static const BUTTON_SHOP_ID:String = "BUTTON_SHOP";
      
      private static const BUTTON_GIFT_ID:String = "BUTTON_GIFT_";
       
      
      private var mCountdownTextField:ETextField;
      
      private var mCountdownEventTextField:ETextField;
      
      private var mHappening:Happening;
      
      private var mHappeningDef:HappeningDef;
      
      private var mWaitingToOpenGiftSku:String = "";
      
      private var mGiftButtons:Array;
      
      private var mGiftBoxLayout:ELayoutArea;
      
      public function EPopupHappeningGiftProgress()
      {
         this.mLogicUpdateFrequency = 1000;
         super();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
      }
      
      public function getName() : String
      {
         return "EPopupHappeningGiftProgress";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["mysteryCubeOpened"];
      }
      
      public function setupHappening(happeningDef:HappeningDef) : void
      {
         var giftDef:ItemsDef = null;
         var chipText:String = null;
         var textField:ETextField = null;
         var sprite:ESprite = null;
         var button:EButton = null;
         var buttonBuyOne:EButton = null;
         var buttonShop:EButton = null;
         var i:int = 0;
         var boxes:Array = [];
         this.mHappeningDef = happeningDef;
         this.mHappening = InstanceMng.getHappeningMng().getHappening(this.mHappeningDef.mSku);
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsWinterProgress");
         setupStructure("PopXL","pop_xl",this.mHappeningDef.getShopTextTitle(),body);
         sprite = mViewFactory.getResourceAsESprite(this.mHappeningDef.getAdvisorId(),null,true,layoutFactory.getArea("character"));
         body.addChild(sprite);
         sprite = mViewFactory.getResourceAsESprite(this.mHappeningDef.getBannerId(),null,true,layoutFactory.getArea("banner"));
         body.addChild(sprite);
         sprite = mViewFactory.getResourceAsESprite(this.mHappeningDef.getGiftBarId(),null,true,layoutFactory.getArea("gift_bar"));
         body.addChild(sprite);
         var boxesLayout:ELayoutArea;
         (boxesLayout = ELayoutAreaFactory.createLayoutArea(318,85)).x = 189;
         boxesLayout.y = 255;
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            sprite = mViewFactory.getResourceAsESprite(this.mHappeningDef.getGiftFrameId(),mSkinSku);
            body.addChild(sprite);
            boxes.push(sprite);
            i++;
         }
         this.mGiftBoxLayout = ELayoutAreaFactory.createLayoutArea(84,84);
         mViewFactory.distributeSpritesInArea(boxesLayout,boxes,0,0,-1,1,true,0,false);
         var arrow:EImage = mViewFactory.getEImage("speech_arrow",null,false,layoutFactory.getArea("speech_arrow"),"speech_color");
         (textField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_body_story"),"text_body_3")).setText(this.mHappeningDef.getShopTextBody());
         var speechBubble:ESprite = mViewFactory.getSpeechBubble(layoutFactory.getArea("body_speech"),layoutFactory.getArea("speech_arrow"),textField,null,"speech_color");
         body.addChild(speechBubble);
         body.addChild(arrow);
         body.addChild(textField);
         var primaryItemDef:ItemsDef = InstanceMng.getItemsDefMng().getDefBySku(this.mHappeningDef.getPrimaryItemSku()) as ItemsDef;
         buttonBuyOne = mViewFactory.getButtonChips("" + primaryItemDef.getCash(),layoutFactory.getArea("btn_shop1"));
         body.addChild(buttonBuyOne);
         setContent("BUTTON_SHOP1",buttonBuyOne);
         buttonBuyOne.eAddEventListener("click",this.onBuyOneItemClicked);
         if(this.mHappeningDef.getShopItemsSku() != null && this.mHappeningDef.getShopItemsSku().length > 0)
         {
            buttonShop = mViewFactory.getButtonByTextWidth(DCTextMng.getText(508),0,"btn_common",null,null,null,layoutFactory.getArea("btn_shop2"));
            body.addChild(buttonShop);
            setContent("BUTTON_SHOP",buttonShop);
            buttonShop.eAddEventListener("click",this.onShopButtonClicked);
            (textField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_shop2"),"text_body_3")).setText(this.mHappeningDef.getShopTextButton2());
            body.addChild(textField);
         }
         this.mGiftButtons = [];
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            (button = mViewFactory.getButtonImage(this.mHappeningDef.getGiftAssetId() + (i + 1),mSkinSku,this.mGiftBoxLayout)).getBackground().onSetTextureLoaded = fixButtonIcon;
            body.addChild(button);
            setContent("BUTTON_GIFT_" + i,button);
            button.eAddEventListener("click",this.makeButtonHandler("BUTTON_GIFT_" + i));
            this.mGiftButtons.push(button);
            i++;
         }
         mViewFactory.distributeSpritesInArea(boxesLayout,this.mGiftButtons,0,0,-1,1,true,0,false);
         (textField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_item_count"),"text_title_0")).setText(DCTextMng.replaceParameters(this.mHappeningDef.getShopTidBody2Tid(),[this.getPrimaryItemAmount()]));
         body.addChild(textField);
         setContent("AURORA_COUNT",textField);
         var textLayout:ELayoutTextArea;
         (textLayout = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(layoutFactory.getTextArea("text_item_count"))).width = 150;
         textLayout.y += 50;
         this.mCountdownEventTextField = mViewFactory.getETextField(mSkinSku,textLayout,"text_title_0");
         this.mCountdownEventTextField.setText("00:00:00");
         body.addChild(this.mCountdownEventTextField);
         setContent("text_countdown_event_timer",this.mCountdownEventTextField);
         (textField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_countdown_body"),"text_title_0")).setText(this.mHappeningDef.getShopCountDownText());
         body.addChild(textField);
         setContent("text_countdown_body",textField);
         this.mCountdownTextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_countdown_timer"),"text_title_0");
         this.mCountdownTextField.setText("00:00:00");
         body.addChild(this.mCountdownTextField);
         var textsLayout:ELayoutArea;
         (textsLayout = ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(ELayoutAreaFactory.createLayoutArea(626,32))).x = 24;
         textsLayout.y = 300;
         boxes = [];
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            giftDef = InstanceMng.getItemsDefMng().getDefBySku(this.mHappeningDef.getGiftItemsSku()[i]) as ItemsDef;
            chipText = DCTextMng.replaceParameters(493,[giftDef.getCash()]);
            (textField = mViewFactory.getETextField(mSkinSku,null,"text_body_3")).setText(DCTextMng.getText(TextIDs[this.mHappeningDef.getGiftItemsPriceTids()[i]]) + " + " + chipText);
            body.addChild(textField);
            boxes.push(textField);
            i++;
         }
         mViewFactory.distributeSpritesInArea(textsLayout,boxes,1,1,-1,1,true,0,false);
         (textField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_shop1"),"text_body_3")).setText(this.mHappeningDef.getShopTextButton());
         body.addChild(textField);
         this.setGiftButtonsActive();
         setCloseButtonVisible(true);
         getCloseButton().eAddEventListener("click",this.onCloseClick);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var time:String = DCTextMng.getCountdownTimeLeft(HappeningTypeWave(this.mHappening.getHappeningType()).getTimeOver());
         this.mCountdownTextField.setText(time);
         time = DCTextMng.replaceParameters(218,[DCTextMng.getCountdownTimeLeft(this.mHappening.getEndTime())]);
         this.mCountdownEventTextField.setText(time);
      }
      
      private function fixButtonIcon(img:EImage) : void
      {
         if(!this.mGiftBoxLayout)
         {
            return;
         }
         img.width = this.mGiftBoxLayout.width;
         img.height = this.mGiftBoxLayout.height;
      }
      
      protected function setGiftButtonsActive() : void
      {
         var i:int = 0;
         var prices:Array = this.mHappeningDef.getGiftItemsPrice();
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            getContent("BUTTON_GIFT_" + i).setIsEnabled(this.getPrimaryItemAmount() >= parseInt(prices[i]));
            i++;
         }
      }
      
      private function updatePopupVisuals() : void
      {
         getContentAsETextField("AURORA_COUNT").setText(DCTextMng.replaceParameters(this.mHappeningDef.getShopTidBody2Tid(),[this.getPrimaryItemAmount()]));
         this.setGiftButtonsActive();
      }
      
      private function getPrimaryItemAmount() : int
      {
         return InstanceMng.getItemsMng().getItemObjectBySku(this.mHappeningDef.getPrimaryItemSku()).quantity;
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         var o:Object = null;
         MessageCenter.getInstance().unregisterObject(this);
         if(getEvent())
         {
            o = getEvent();
            o.button = "EventCloseButtonPressed";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
         }
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      protected function onBuyOneItemClicked(e:EEvent) : void
      {
         InstanceMng.getItemsMng().notifyItemBought(this.mHappeningDef.getPrimaryItemSku(),null,true,updatePopupVisuals);
      }
      
      protected function onShopButtonClicked(e:EEvent) : void
      {
         notifyPopupMngClose(e);
         var params:Dictionary = new Dictionary();
         params["tab"] = "specials";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
         getContent("BUTTON_SHOP").setIsEnabled(false);
      }
      
      private function makeButtonHandler(btnID:String) : Function
      {
         return function(e:EEvent):void
         {
            onGiftButtonClicked(btnID);
         };
      }
      
      private function removePrimaryItems(forGiftSku:String) : Boolean
      {
         var returnValue:Boolean = false;
         var amount:int = this.mHappeningDef.getGiftItemPriceBySku(forGiftSku);
         if(amount > 0)
         {
            InstanceMng.getItemsMng().addItemAmount(this.mHappeningDef.getPrimaryItemSku(),-amount);
            return true;
         }
         return returnValue;
      }
      
      private function lockGiftButtons() : void
      {
         var i:int = 0;
         var currBtnId:String = null;
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            currBtnId = "BUTTON_GIFT_" + i;
            getContent(currBtnId).setIsEnabled(false);
            i++;
         }
      }
      
      protected function onGiftButtonClicked(btnID:String) : void
      {
         var i:int = 0;
         var currBtnId:String = null;
         var itemObj:ItemObject = null;
         var giftSkus:Array = this.mHappeningDef.getGiftItemsSku();
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         for(i = 0; i < this.mHappeningDef.getNumGifts(); )
         {
            currBtnId = "BUTTON_GIFT_" + i;
            if(currBtnId == btnID)
            {
               itemObj = InstanceMng.getItemsMng().getItemObjectBySku(giftSkus[i]);
               if(profile.getCash() < itemObj.mDef.getCash() || this.getPrimaryItemAmount() < this.mHappeningDef.getGiftItemPriceBySku(giftSkus[i]))
               {
                  return;
               }
               if(this.removePrimaryItems(giftSkus[i]))
               {
                  this.lockGiftButtons();
                  this.mWaitingToOpenGiftSku = giftSkus[i];
                  InstanceMng.getItemsMng().notifyItemBought(this.mWaitingToOpenGiftSku);
               }
            }
            i++;
         }
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         var _loc3_:* = cmd;
         if("mysteryCubeOpened" === _loc3_)
         {
            if(this.mWaitingToOpenGiftSku != "" && this.mWaitingToOpenGiftSku == params["cubeSku"])
            {
               this.mWaitingToOpenGiftSku = "";
               this.updatePopupVisuals();
            }
         }
      }
   }
}
