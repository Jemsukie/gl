package com.dchoc.game.eview.widgets.bet
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.bet.BetDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class BetBox extends ESpriteContainer
   {
      
      private static const BKG_SKU:String = "bkg";
      
      private static const SHINE_SKU:String = "shine";
      
      private static const ICON_SKU:String = "icon";
      
      private static const PRIZE_VALUE_SKU:String = "prizeValue";
      
      private static const TITLE_SKU:String = "title";
      
      private static const BUTTON_SKU:String = "button";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mBetSku:String;
      
      public function BetBox(viewFactory:ViewFactory)
      {
         super();
         this.mViewFactory = viewFactory;
      }
      
      public function setup(betSku:String) : void
      {
         var button:EButton = null;
         this.mBetSku = betSku;
         name = this.mBetSku;
         var skinSku:String = null;
         var betDef:BetDef = InstanceMng.getBetDefMng().getDefBySku(betSku) as BetDef;
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("BetBox")).getArea("box");
         var bkg:EImage = this.mViewFactory.getEImage("box_with_border",null,false,area);
         setContent("bkg",bkg);
         eAddChild(bkg);
         var shine:EImage = this.mViewFactory.getEImage("shine_base",null,false,area);
         setContent("shine",shine);
         eAddChild(shine);
         var title:ETextField = this.mViewFactory.getETextField(skinSku,layoutFactory.getTextArea("text_win"));
         setContent("title",title);
         title.setText(DCTextMng.getText(338));
         eAddChild(title);
         title.applySkinProp(skinSku,"text_title_1");
         var icon:EImage = this.mViewFactory.getEImage(betDef.getAssetId(),skinSku,true,layoutFactory.getArea("icon_betting"));
         setContent("icon",icon);
         eAddChild(icon);
         var prizeValue:ETextField = this.mViewFactory.getETextField(skinSku,layoutFactory.getTextArea("text_value"));
         setContent("prizeValue",prizeValue);
         var transReward:Transaction = InstanceMng.getBetMng().getTransactionRewardFromSku(this.mBetSku);
         prizeValue.setText(DCTextMng.convertNumberToString(transReward.getTransCash(),1,7));
         eAddChild(prizeValue);
         prizeValue.applySkinProp(skinSku,"text_title_1");
         var transPrice:Transaction;
         if((transPrice = InstanceMng.getBetMng().getTransactionBetFromSku(this.mBetSku)) == null)
         {
            (button = this.mViewFactory.getButton("btn_accept",skinSku,"L")).setText(DCTextMng.getText(397));
         }
         else
         {
            (button = this.mViewFactory.getButton("btn_common",skinSku,"L","chips","icon_chip")).setText(DCTextMng.convertNumberToString(transPrice.getTransCashToPay(),1,7));
         }
         setContent("button",button);
         var buttonArea:ELayoutArea = layoutFactory.getArea("area_button");
         this.mViewFactory.distributeSpritesInArea(buttonArea,[button],1,1);
         button.logicLeft += buttonArea.x;
         button.logicTop += buttonArea.y;
         this.mViewFactory.removeButtonBehaviors(button);
         eAddChild(button);
         eAddEventBehavior("click",InstanceMng.getBehaviorsMng().getBehaviorSelectBet(this.mBetSku));
      }
   }
}
