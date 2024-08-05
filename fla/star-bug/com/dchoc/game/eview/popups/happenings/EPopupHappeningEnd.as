package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupHappeningEnd extends EGamePopup
   {
      
      public static const USE_AS_SKIP_CONFIRM:int = 0;
      
      public static const USE_AS_END_EVENT:int = 1;
      
      public static const IMAGE:String = "img";
      
      public static const AREA_BOXES:String = "area_units";
      
      public static const TEXT_INFO:String = "text";
       
      
      private var mHappening:Happening;
      
      public function EPopupHappeningEnd()
      {
         super();
      }
      
      public function build(happening:Happening, boxes:Array, useAs:int, canShare:Boolean) : void
      {
         var i:int = 0;
         var startButton:EButton = null;
         var skipButton:EButton = null;
         var restartButton:EButton = null;
         var shopButton:EButton = null;
         var shareButton:EButton = null;
         this.mHappening = happening;
         var happeningDef:HappeningDef = this.mHappening.getHappeningDef();
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var layoutAreaFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsPopupEnd");
         setupStructure("PopL","pop_l",useAs == 1 ? DCTextMng.getText(TextIDs[happeningDef.getTidFinishTitle()]) : DCTextMng.getText(TextIDs[happeningDef.getTidSkipTitle()]),body);
         var image:EImage = mViewFactory.getEImage(happeningDef.getRewardImage(),mSkinSku,false,layoutAreaFactory.getArea("img"));
         body.eAddChild(image);
         body.setContent("img",image);
         for(i = 0; i < boxes.length; )
         {
            body.setContent("box_" + i,boxes[i]);
            body.eAddChild(boxes[i]);
            if(useAs == 1)
            {
               if(this.mHappening.getCurrentProgress() * boxes.length / this.mHappening.getTarget() < i + 1)
               {
                  boxes[i].getContent("img").applySkinProp(null,"disabled");
                  boxes[i].getContent("text").applySkinProp(null,"disabled");
               }
            }
            i++;
         }
         mViewFactory.distributeSpritesInArea(layoutAreaFactory.getArea("area_units"),boxes,1,1,-1,1,true);
         var tip:ETextField = mViewFactory.getETextField(mSkinSku,layoutAreaFactory.getTextArea("text"),"text_body");
         if(useAs == 1)
         {
            tip.setText(DCTextMng.getText(3373));
         }
         else
         {
            tip.setText(DCTextMng.getText(TextIDs[happeningDef.getTidSkipBody()]));
         }
         body.eAddChild(tip);
         body.setContent("text",tip);
         if(useAs == 0)
         {
            (startButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(78),0,"btn_common")).eAddEventListener("click",this.onCancelButton);
            addButton("CANCEL",startButton);
            (skipButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3166),0,"btn_cancel")).eAddEventListener("click",this.onSkipButton);
            addButton("SKIP",skipButton);
         }
         else
         {
            (restartButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(83),0,"btn_common")).eAddEventListener("click",this.onRestartButton);
            addButton("SKIP",restartButton);
            (shopButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(508),0,"btn_social")).eAddEventListener("click",this.onShopButton);
            addButton("SHOP",shopButton);
         }
         setCloseButtonVisible(true);
         getCloseButton().eAddEventListener("click",this.onCancelButton);
      }
      
      private function onCancelButton(evt:EEvent) : void
      {
         getEvent().button = "EventCloseButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
      
      private function onSkipButton(evt:EEvent) : void
      {
         getEvent().button = "EventYesButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
      
      private function onRestartButton(evt:EEvent) : void
      {
         getEvent().button = "EventYesButtonPressed";
         getEvent().popup = this;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),getEvent(),true);
      }
      
      private function onShopButton(evt:EEvent) : void
      {
         notifyPopupMngClose(evt);
         var params:Dictionary = new Dictionary();
         params["tab"] = "specials";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
      }
   }
}
