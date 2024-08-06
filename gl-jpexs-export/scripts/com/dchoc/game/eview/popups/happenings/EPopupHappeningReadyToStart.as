package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWave;
   import com.dchoc.game.model.happening.HappeningTypeWaveDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupHappeningReadyToStart extends EGamePopup
   {
      
      public static const ADVISOR:String = "img";
      
      public static const AREA_SPEECH:String = "speech";
      
      public static const AREA_SPEECH_ARROW:String = "arrow";
      
      public static const AREA_SPEECH_TEXT:String = "text";
      
      public static const AREA_UNITS:String = "area_units";
       
      
      public function EPopupHappeningReadyToStart()
      {
         super();
      }
      
      public function setupHappening(happening:Happening, waveSprites:Array, canSkip:Boolean) : void
      {
         var box:ESprite = null;
         var startButton:EButton = null;
         var canDelay1:* = false;
         var canDelay2:Boolean = false;
         var delayButton:EButton = null;
         var skipButton:EButton = null;
         var happeningDef:HappeningDef = happening.getHappeningDef();
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var happeningTypeWaveDef:HappeningTypeWaveDef = InstanceMng.getHappeningTypeDefMng().getDefBySku(happeningDef.getTypeSku()) as HappeningTypeWaveDef;
         var layoutAreaFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsPopupAttack");
         setupStructure("PopM","pop_m",happeningDef.getShopTextTitle(),body);
         var advisor:EImage = mViewFactory.getEImage(happeningTypeWaveDef.getEnemyAdvisorPath(),null,false,layoutAreaFactory.getArea("img"));
         setContent("img",advisor);
         body.eAddChild(advisor);
         var arrow:EImage = mViewFactory.getEImage("speech_arrow",null,false,layoutAreaFactory.getArea("arrow"),"speech_color");
         body.setContent("arrow",arrow);
         var text:String = DCTextMng.checkTags(DCTextMng.getText(TextIDs[happeningTypeWaveDef.getTidAttackBody()]));
         var textContent:ESpriteContainer;
         (textContent = mViewFactory.getContentOneText("ContainerTextField",text,"text_body",null)).layoutApplyTransformations(layoutAreaFactory.getTextArea("text"));
         body.setContent("text",textContent);
         var speechBubble:ESprite = mViewFactory.getSpeechBubble(layoutAreaFactory.getArea("speech"),layoutAreaFactory.getArea("arrow"),textContent,null,"speech_color");
         body.setContent("speech",speechBubble);
         body.eAddChild(speechBubble);
         body.eAddChild(arrow);
         body.eAddChild(textContent);
         mViewFactory.distributeSpritesInArea(layoutAreaFactory.getArea("area_units"),waveSprites,1,1,-1,1,true);
         var i:int = 0;
         for each(box in waveSprites)
         {
            body.eAddChild(box);
            body.setContent("BOX" + i,box);
            i++;
         }
         (startButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(TextIDs[happeningTypeWaveDef.getTidAttackBtnStart()]),0,"btn_common")).eAddEventListener("click",this.onStartButton);
         addButton("START",startButton);
         canDelay1 = HappeningTypeWave(happening.getHappeningType()).getCurrentWaveDelayed() == 0;
         canDelay2 = Boolean(HappeningTypeWave(happening.getHappeningType()).checkDelayWave());
         if(canDelay1 && canDelay2)
         {
            (delayButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(TextIDs[happeningTypeWaveDef.getTidAttackBtnDelay()]),0,"btn_common")).eAddEventListener("click",this.onDelayButton);
            addButton("DELAY",delayButton);
         }
         if(canSkip)
         {
            (skipButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(TextIDs[happeningTypeWaveDef.getTidAttackBtnSkip()]),0,"btn_cancel")).eAddEventListener("click",this.onSkipButton);
            addButton("SKIP",skipButton);
         }
         setCloseButtonVisible(false);
      }
      
      private function onStartButton(evt:EEvent) : void
      {
         getEvent().button = "EventYesButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
      
      private function onDelayButton(evt:EEvent) : void
      {
         getEvent().button = "EventCancelButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
      
      private function onSkipButton(evt:EEvent) : void
      {
         getEvent().button = "EVENT_BUTTON_LEFT_PRESSED";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
   }
}
