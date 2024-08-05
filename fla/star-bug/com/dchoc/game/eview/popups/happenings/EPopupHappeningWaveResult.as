package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EInventoryItemView;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.happenings.EProgressBarHappening;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWave;
   import com.dchoc.game.model.happening.HappeningTypeWaveDef;
   import com.dchoc.game.model.items.RewardObject;
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
   
   public class EPopupHappeningWaveResult extends EGamePopup
   {
      
      public static const ADVISOR:String = "img";
      
      public static const AREA_SPEECH:String = "speech";
      
      public static const AREA_SPEECH_ARROW:String = "arrow";
      
      public static const AREA_SPEECH_TEXT:String = "text";
      
      public static const EVENT_TOTAL_FILL_BAR:String = "bar";
      
      public static const EVENT_TOTAL_TEXT_COUNTER:String = "text_title";
      
      public static const EVENT_TOTAL_ICON:String = "icon";
      
      public static const TEXT_INFO_UNITS:String = "text_info_units";
      
      public static const AREA_REWARDS:String = "area_rewards";
      
      public static const BOX_PREFIX:String = "box_";
       
      
      private var mHappeningDef:HappeningDef;
      
      public function EPopupHappeningWaveResult()
      {
         super();
      }
      
      public function setupHappening(happening:Happening) : void
      {
         var itemKitSku:Array = null;
         var shopButton:EButton = null;
         var itemSku:String = null;
         var itemAmount:String = null;
         var itemContainer:EInventoryItemView = null;
         var rewardObject:RewardObject = null;
         var currentItemAmount:int = 0;
         this.mHappeningDef = happening.getHappeningDef();
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var happeningTypeWaveDef:HappeningTypeWaveDef = InstanceMng.getHappeningTypeDefMng().getDefBySku(this.mHappeningDef.getTypeSku()) as HappeningTypeWaveDef;
         var layoutAreaFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsPopupAttack");
         setupStructure("PopM","pop_m",this.mHappeningDef.getShopTextTitle(),body);
         var advisor:EImage = mViewFactory.getEImage(happeningTypeWaveDef.getEnemyAdvisorPath(),null,false,layoutAreaFactory.getArea("img"));
         setContent("img",advisor);
         body.eAddChild(advisor);
         var barArea:ELayoutArea = layoutAreaFactory.getArea("bar");
         var efillbar:EProgressBarHappening;
         (efillbar = new EProgressBarHappening()).setup(barArea,happening,true);
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
         var maloMaloso:EImage = mViewFactory.getEImage(this.mHappeningDef.getRewardIconImage(),mSkinSku,false,layoutAreaFactory.getArea("icon"));
         body.setContent("icon",maloMaloso);
         body.eAddChild(maloMaloso);
         var arrow:EImage = mViewFactory.getEImage("speech_arrow",null,false,layoutAreaFactory.getArea("arrow"),"speech_color");
         body.setContent("arrow",arrow);
         var text:String = DCTextMng.checkTags(DCTextMng.getText(TextIDs[happeningTypeWaveDef.getTidWaveCompletedBody1()]));
         var textContent:ESpriteContainer;
         (textContent = mViewFactory.getContentOneText("ContainerTextField",text,"text_body",null)).layoutApplyTransformations(layoutAreaFactory.getTextArea("text"));
         body.setContent("text",textContent);
         var speechBubble:ESprite = mViewFactory.getSpeechBubble(layoutAreaFactory.getArea("speech"),layoutAreaFactory.getArea("arrow"),null,null,"speech_color");
         body.setContent("speech",speechBubble);
         body.eAddChild(speechBubble);
         body.eAddChild(arrow);
         body.eAddChild(textContent);
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
         mViewFactory.distributeSpritesInArea(layoutAreaFactory.getArea("area_rewards"),boxes,1,1,-1,1,true);
         (shopButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(0),0,"btn_common")).eAddEventListener("click",this.onCloseButton);
         addButton("TRAILER",shopButton);
         setCloseButtonVisible(true);
         getCloseButton().eAddEventListener("click",this.onCloseButton);
      }
      
      private function onCloseButton(e:EEvent) : void
      {
         getEvent().button = "EventYesButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
   }
}
