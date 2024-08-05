package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EHudBuyTimeDropDown extends EDropDownSprite
   {
       
      
      private var mCurrentSpecialAttackDefinition:SpecialAttacksDef;
      
      public function EHudBuyTimeDropDown()
      {
         super(2);
      }
      
      public function build(viewFactory:ViewFactory, layout:ELayoutAreaFactory) : void
      {
         var bkg:EImage = viewFactory.getEImage("tooltip_bkg",null,false,layout.getArea("area_buy_time"));
         this.eAddChild(bkg);
         this.setContent("area_buy_time",bkg);
         var arrowLayout:ELayoutArea = layout.getArea("arrow");
         var arrow:EImage = viewFactory.getEImage("tooltip_arrow",null,false,arrowLayout);
         arrow.setPivotLogicXY(0.5,0.5);
         arrow.logicLeft = arrowLayout.x;
         arrow.logicTop = arrowLayout.y;
         arrow.applySkinProp(null,"rotation_right");
         this.eAddChild(arrow);
         this.setContent("arrow",arrow);
         var textField:ETextField;
         (textField = viewFactory.getETextField(null,layout.getTextArea("text_buy_time"),"text_title_3")).setText(DCTextMng.getText(3153));
         this.eAddChild(textField);
         this.setContent("text_buy_time",textField);
         var btn:EButton;
         (btn = viewFactory.getButtonPayment(layout.getArea("ibtn_xs"),EntryFactory.createCashSingleEntry(0),null,"XS")).eAddEventListener("click",this.onBuyClicked);
         this.eAddChild(btn);
         this.setContent("btn",btn);
         this.setPivotXY(arrow.x + arrow.getLogicWidth(),arrow.y + arrow.getLogicHeight() / 2);
         this.logicX = this.logicX;
         this.logicY = this.logicY;
      }
      
      public function setDefinition(rewardObject:RewardObject) : void
      {
         this.mCurrentSpecialAttackDefinition = rewardObject.getSpecialAttackDef();
         var btn:EButton;
         (btn = getContentAsEButton("btn")).setText(this.mCurrentSpecialAttackDefinition.getCash().toString());
         var minutes:int = this.mCurrentSpecialAttackDefinition.getAmount();
         var tf:ETextField = getContentAsETextField("text_buy_time");
         tf.setText(DCTextMng.replaceParameters(3154,[minutes.toString(),DCTextMng.getText(minutes > 1 ? 40 : 39)]).toUpperCase());
      }
      
      private function onBuyClicked(evt:EEvent) : void
      {
         if(this.mCurrentSpecialAttackDefinition == null)
         {
            return;
         }
         var params:Dictionary = new Dictionary();
         params["sku"] = this.mCurrentSpecialAttackDefinition.mSku;
         MessageCenter.getInstance().sendMessage("buyTimeButtonClicked",params);
      }
      
      override public function logicUpdate(dt:int) : void
      {
      }
   }
}
