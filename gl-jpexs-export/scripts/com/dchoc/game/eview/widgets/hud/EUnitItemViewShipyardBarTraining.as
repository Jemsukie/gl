package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.view.dc.gui.components.ShipyardQueuedElement;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EUnitItemViewShipyardBarTraining extends EUnitItemView
   {
      
      protected static const TEXT_NUMBER_UNITS:String = "text_number_units";
      
      protected static const TEXT_TIMER:String = "text_timer";
      
      protected static const BUTTON_PAY:String = "btn";
      
      private static const USE_AUTO_DECREMENT:Boolean = true;
       
      
      private var mQueuedElement:ShipyardQueuedElement;
      
      public function EUnitItemViewShipyardBarTraining()
      {
         super();
         mLayoutName = "BoxUnitsButtonsSmall";
         mCloseBtnProp = null;
      }
      
      override protected function setupText() : void
      {
         super.setupText();
         var txt:ETextField = mViewFactory.getETextField(mSkinSku,mLayout.getTextArea("text_timer"),"text_title_3");
         txt.setText("...");
         this.eAddChild(txt);
         this.setContent("text_timer",txt);
         txt = mViewFactory.getETextField(mSkinSku,mLayout.getTextArea("text_number_units"),"text_title_3");
         txt.setText("...");
         this.eAddChild(txt);
         this.setContent("text_number_units",txt);
      }
      
      override protected function setupButtons() : void
      {
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,mLayout.getArea("btn_close"));
         closeButton.applySkinProp(mSkinSku,mCloseBtnProp);
         if(true)
         {
            closeButton.eAddEventListener("mouseDown",this.onStartCancelUnit);
            closeButton.eAddEventListener("mouseUp",this.onEndCancelUnit);
            closeButton.eAddEventListener("rollOut",this.onEndCancelUnit);
         }
         else
         {
            closeButton.eAddEventListener("click",this.onRemoveThis);
         }
         this.eAddChild(closeButton);
         this.setContent("btn_close",closeButton);
         var btn:EButton = mViewFactory.getButtonPayment(mLayout.getArea("btn"),EntryFactory.createCashSingleEntry(100),mSkinSku,"XS");
         btn.name = "btn";
         btn.eAddEventListener("click",this.onButtonClick);
         eAddChild(btn);
         setContent("btn",btn);
      }
      
      override public function fillData(object:Array) : void
      {
         var isProducing:Boolean = false;
         this.mQueuedElement = object[0];
         var state:int = this.mQueuedElement.getState();
         if(this.mQueuedElement.getSlotId() == 0)
         {
            isProducing = state == 1 || 0;
            this.visible = isProducing;
            getContent("btn_close").visible = false;
            if(isProducing)
            {
               getContent("btn_close").visible = false;
               mViewFactory.setTextureToImage("icon_accelerate",mSkinSku,getContentAsEImage("img"));
               getContentAsEButton("btn").setText(InstanceMng.getShipyardController().getSpeedUpPrice().toString());
               getContentAsETextField("text_timer").setText(DCTextMng.convertTimeToStringColon(InstanceMng.getShipyardController().getCurrentShipyard().getShipTotalTimeLeft()));
            }
            getContent("text_number_units").visible = false;
         }
         else
         {
            switch(state)
            {
               case 0:
               case 1:
                  break;
               case 2:
                  getContentAsETextField("text").setText("x" + this.mQueuedElement.getQueuedElementsAmount());
                  getContent("text").visible = true;
                  getContent("img").visible = true;
                  mViewFactory.setTextureToImage(this.mQueuedElement.getInfoIcon(),mSkinSku,getContentAsEImage("img"));
                  getContent("btn_close").visible = true;
                  getContent("text_number_units").visible = false;
                  getContent("btn").visible = false;
                  getContent("text_timer").visible = false;
                  break;
               case 3:
                  getContentAsETextField("text_number_units").setText("x" + this.mQueuedElement.getSlotCapacity());
                  getContent("text_number_units").visible = true;
                  getContent("text").visible = false;
                  getContent("btn").visible = false;
                  getContent("btn_close").visible = false;
                  getContent("img").visible = false;
                  getContent("text_timer").visible = false;
                  break;
               case 4:
                  getContentAsETextField("text_number_units").setText("x" + this.mQueuedElement.getSlotCapacity());
                  getContent("text_number_units").visible = true;
                  getContentAsEButton("btn").setText(this.mQueuedElement.getSlotUnlockPrice().toString());
                  getContent("btn").visible = true;
                  getContent("text").visible = false;
                  getContent("btn_close").visible = false;
                  getContent("img").visible = false;
                  getContent("text_timer").visible = false;
            }
         }
         this.setLayoutArea(this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomShop").getArea(this.name),true);
      }
      
      private function onButtonClick(evt:EEvent) : void
      {
         var params:Dictionary = null;
         if(this.mQueuedElement.getSlotId() == 0)
         {
            MessageCenter.getInstance().sendMessage("hudShipyardBarTrainingSpeedupClicked");
         }
         else
         {
            params = new Dictionary();
            params["slotId"] = this.mQueuedElement.getSlotId();
            MessageCenter.getInstance().sendMessage("hudShipyardBarTrainingBuySlotClicked",params);
         }
      }
      
      override protected function onRemoveThis(evt:EEvent) : void
      {
         if(this.mQueuedElement)
         {
            this.mQueuedElement.onRemoveUnit();
         }
      }
      
      private function onStartCancelUnit(evt:EEvent) : void
      {
         this.mQueuedElement.onStartCancelUnit();
      }
      
      private function onEndCancelUnit(evt:EEvent) : void
      {
         this.mQueuedElement.onEndCancelUnit();
      }
   }
}
