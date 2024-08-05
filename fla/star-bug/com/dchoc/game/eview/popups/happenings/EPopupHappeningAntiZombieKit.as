package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EInventoryItemView;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.happenings.EProgressBarHappening;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWave;
   import com.dchoc.game.model.happening.HappeningTypeWaveDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.waves.WaveSpawnDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupHappeningAntiZombieKit extends EGamePopup
   {
      
      public static const ADVISOR:String = "img";
      
      public static const TEXT_INFO_END:String = "text_end_info";
      
      public static const TEXT_INFO_END_COUNTER:String = "text_end_counter";
      
      public static const EVENT_TOTAL_FILL_BAR:String = "bar";
      
      public static const EVENT_TOTAL_TEXT_COUNTER:String = "text_title";
      
      public static const EVENT_TOTAL_ICON:String = "icon";
      
      public static const TEXT_INFO_UNITS:String = "text_info_units";
      
      public static const BOXES_CONTAINER:String = "area_items";
      
      public static const BOX_PREFIX:String = "box_";
      
      public static const AREA_SPEECH:String = "speech";
      
      public static const AREA_SPEECH_ARROW:String = "arrow";
      
      public static const AREA_SPEECH_TEXT_TOP:String = "text_info_shop";
      
      public static const AREA_SPEECH_TEXT_BOTTOM:String = "text_ready";
      
      public static const AREA_SPEECH_TEXT_NEXT_WAVE:String = "text_wave_info";
      
      public static const AREA_SPEECH_TEXT_NEXT_WAVE_COUNTER:String = "text_counter";
      
      public static const BUTTON_SHOP:String = "btn_shop";
      
      public static const BUTTON_WAVE:String = "btn_wave";
       
      
      private var mWaveCountdownTextField:ETextField;
      
      private var mHappeningCountdownTextField:ETextField;
      
      private var mHappeningDef:HappeningDef;
      
      private var mTimeOver:Number;
      
      private var mWaveTimeOver:Number;
      
      private var mWaveTimeLeft:Number;
      
      private var mSpeedUpTrans:Transaction;
      
      public function EPopupHappeningAntiZombieKit()
      {
         super();
      }
      
      public function setupHappening(happeningDef:HappeningDef) : void
      {
         var layoutAreaFactory:ELayoutAreaFactory = null;
         var textField:ETextField = null;
         var itemKitSku:Array = null;
         var shopButton:EButton = null;
         var itemSku:String = null;
         var itemAmount:String = null;
         var itemContainer:EInventoryItemView = null;
         var rewardObject:RewardObject = null;
         var currentItemAmount:int = 0;
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var happeningTypeWaveDef:HappeningTypeWaveDef = InstanceMng.getHappeningTypeDefMng().getDefBySku(happeningDef.getTypeSku()) as HappeningTypeWaveDef;
         layoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsAntiZombieKit");
         setupStructure("PopXL","pop_xl",happeningDef.getShopTextTitle(),body);
         this.mHappeningDef = happeningDef;
         var happening:Happening = InstanceMng.getHappeningMng().getHappening(this.mHappeningDef.mSku);
         this.mTimeOver = happening.getEndTime();
         this.mWaveTimeOver = HappeningTypeWave(happening.getHappeningType()).getTimeOver();
         this.mWaveTimeLeft = this.mWaveTimeOver - InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         var cash:Number;
         var textCash:String = !!(cash = this.getSpeedUpWavePrice()) ? DCTextMng.replaceParameters(DCTextMng.getText(3259),[cash]) : DCTextMng.getText(3260);
         var advisor:EImage = mViewFactory.getEImage(happeningTypeWaveDef.getShopAdvisorPath(),null,false,layoutAreaFactory.getArea("img"));
         setContent("img",advisor);
         body.eAddChild(advisor);
         var barArea:ELayoutArea = layoutAreaFactory.getArea("bar");
         var efillbar:EProgressBarHappening;
         (efillbar = new EProgressBarHappening()).setup(barArea,happening,false);
         body.setContent("bar",efillbar);
         body.eAddChild(efillbar);
         var progressInfo:ETextField;
         (progressInfo = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_title"),"text_title_3")).setText(DCTextMng.replaceParameters(TextIDs[happeningTypeWaveDef.getTidCounterCaption()],[happening.getCurrentProgress(),happening.getTarget()]));
         body.setContent("text_title",progressInfo);
         body.eAddChild(progressInfo);
         var progressTip:ETextField;
         (progressTip = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_info_units"),"text_body_2")).setText(DCTextMng.getText(3372));
         body.setContent("text_info_units",progressTip);
         body.eAddChild(progressTip);
         progressTip.visible = efillbar.getNumBarsFullLogic() > 0;
         var iconReward:EImage = mViewFactory.getEImage(this.mHappeningDef.getRewardIconImage(),mSkinSku,false,layoutAreaFactory.getArea("icon"));
         body.setContent("icon",iconReward);
         body.eAddChild(iconReward);
         var bubbleContent:ESpriteContainer = mViewFactory.getESpriteContainer();
         var arrow:EImage = mViewFactory.getEImage("speech_arrow",null,false,layoutAreaFactory.getArea("arrow"),"speech_color");
         body.setContent("arrow",arrow);
         var text:String = DCTextMng.checkTags(DCTextMng.getText(3373));
         (textField = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_info_shop"),"text_body_3")).setText(text);
         bubbleContent.setContent("text_info_shop",textField);
         bubbleContent.eAddChild(textField);
         text = DCTextMng.checkTags(DCTextMng.getText(3257));
         (textField = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_ready"),"text_body_3")).setText(text);
         bubbleContent.setContent("text_ready",textField);
         bubbleContent.eAddChild(textField);
         text = DCTextMng.checkTags(DCTextMng.getText(3258));
         (textField = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_wave_info"),"text_body_3")).setText(text);
         bubbleContent.setContent("text_wave_info",textField);
         bubbleContent.eAddChild(textField);
         text = "00:00:00";
         this.mWaveCountdownTextField = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text_counter"),"text_body_3");
         this.mWaveCountdownTextField.setText(text);
         bubbleContent.setContent("text_counter",this.mWaveCountdownTextField);
         bubbleContent.eAddChild(this.mWaveCountdownTextField);
         var button:EButton;
         (button = !!cash ? mViewFactory.getButtonChips(textCash,layoutAreaFactory.getArea("btn_wave"),mSkinSku) : mViewFactory.getButtonByTextWidth(textCash,0,"btn_common")).setLayoutArea(layoutAreaFactory.getArea("btn_wave"),true);
         button.eAddEventListener("click",this.onWaveButton);
         bubbleContent.setContent("btn_wave",button);
         bubbleContent.eAddChild(button);
         (button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(508),0,"btn_common")).setLayoutArea(layoutAreaFactory.getArea("btn_shop"),true);
         button.eAddEventListener("click",this.onShopButton);
         bubbleContent.setContent("btn_shop",button);
         bubbleContent.eAddChild(button);
         var speechBubble:ESprite = mViewFactory.getSpeechBubble(layoutAreaFactory.getArea("speech"),layoutAreaFactory.getArea("arrow"),null,null,"speech_color");
         body.setContent("speech",speechBubble);
         body.eAddChild(speechBubble);
         body.eAddChild(arrow);
         body.eAddChild(bubbleContent);
         var text_info:ETextField;
         (text_info = mViewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_end_info"),"text_body_3")).setText(this.mHappeningDef.getShopCountDownText());
         setContent("text_end_info",text_info);
         body.eAddChild(text_info);
         this.mHappeningCountdownTextField = mViewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_end_counter"),"text_body");
         this.mHappeningCountdownTextField.setText("==:==:==");
         setContent("text_end_counter",this.mHappeningCountdownTextField);
         body.eAddChild(this.mHappeningCountdownTextField);
         var waveSpawnDef:WaveSpawnDef;
         var itemSkus:Array = (waveSpawnDef = HappeningTypeWave(happening.getHappeningType()).getCurrentWave()).getReward();
         var boxes:Array = [];
         for each(itemKitSku in itemSkus)
         {
            itemSku = String(itemKitSku[0]);
            itemAmount = String(itemKitSku[1]);
            itemContainer = new EInventoryItemView();
            currentItemAmount = (rewardObject = InstanceMng.getRuleMng().createRewardObjectFromParams("item",parseInt(itemAmount),itemSku)).getItem().quantity;
            rewardObject.getItem().quantity = parseInt(itemAmount);
            itemContainer.build("BoxUnits");
            itemContainer.fillData(rewardObject.getItem());
            rewardObject.getItem().quantity = currentItemAmount;
            itemContainer.setActionButtonVisible(false);
            itemContainer.setCloseButtonVisible(false);
            body.setContent("box_" + boxes.length,itemContainer);
            body.eAddChild(itemContainer);
            boxes.push(itemContainer);
         }
         mViewFactory.distributeSpritesInArea(layoutAreaFactory.getArea("area_items"),boxes,1,1,-1,1,true);
         (shopButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(1271),0,"btn_common")).eAddEventListener("click",notifyPopupMngClose);
         addButton("TRAILER",shopButton);
         setCloseButtonVisible(true);
         getCloseButton().eAddEventListener("click",notifyPopupMngClose);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var time:String = DCTextMng.getCountdownTimeLeft(this.mTimeOver);
         this.mHappeningCountdownTextField.setText(time);
         time = DCTextMng.getCountdownTimeLeft(this.mWaveTimeOver);
         this.mWaveCountdownTextField.setText(time);
      }
      
      public function getSpeedUpWavePrice() : Number
      {
         this.mSpeedUpTrans = InstanceMng.getRuleMng().getTransactionSpeedUpWave(this.mWaveTimeLeft);
         return this.mSpeedUpTrans.getTransCashToPay();
      }
      
      private function onWaveButton(evt:EEvent) : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyHappeningTypeWaveSpeedUp");
         o.transaction = this.mSpeedUpTrans;
         o.timeLeft = this.mWaveTimeLeft;
         o.happeningSku = this.mHappeningDef.mSku;
         o.phase = "OUT";
         o.button = "EventYesButtonPressed";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
         notifyPopupMngClose(evt);
      }
      
      private function onShopButton(evt:EEvent) : void
      {
         notifyPopupMngClose(evt);
         var params:Dictionary = new Dictionary();
         params["tab"] = "specials";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
      }
      
      private function onTrailerButton(evt:EEvent) : void
      {
         InstanceMng.getUserDataMng().browserNavigateToUrl(this.mHappeningDef.getUrlTrailer());
      }
   }
}
