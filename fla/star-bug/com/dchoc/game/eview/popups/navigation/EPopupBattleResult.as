package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.ENotificationWithImage;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupBattleResult extends ENotificationWithImage
   {
       
      
      private var mLootedCoins:Number;
      
      private var mLootedMinerals:Number;
      
      private var mScoreGained:Number;
      
      private var mAllianceScore:Number;
      
      private var mShowAllianceScore:Boolean;
      
      private var mSubtitleArea:ELayoutTextArea;
      
      public function EPopupBattleResult()
      {
         super();
      }
      
      public function setupPopup(lootCoins:Number, lootMinerals:Number, scoreGained:Number, allianceScore:Number, showAllianceScore:Boolean) : void
      {
         var imageName:String = null;
         this.mLootedCoins = lootCoins;
         this.mLootedMinerals = lootMinerals;
         this.mScoreGained = scoreGained;
         this.mAllianceScore = allianceScore;
         if(!showAllianceScore)
         {
            this.mAllianceScore = 0;
         }
         this.mShowAllianceScore = showAllianceScore;
         setupBackground("PopM","pop_m");
         if(lootCoins > 0 || lootMinerals > 0 || scoreGained > 0)
         {
            if(showAllianceScore)
            {
               imageName = "win_alliance";
            }
            else
            {
               imageName = "win";
            }
         }
         else if(showAllianceScore)
         {
            imageName = "lose_alliance";
         }
         else
         {
            imageName = "lose";
         }
         setupImage(imageName,mImageArea);
         setTitleText(DCTextMng.getText(577));
         this.setupBottom();
         this.setupButtons();
      }
      
      override protected function setAreas() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         layoutFactory = mViewFactory.getLayoutAreaFactory("LayoutBattleSummary");
         mImageArea = layoutFactory.getArea("box_ilustration");
         mBottomArea = layoutFactory.getArea("container_loot");
         this.mSubtitleArea = layoutFactory.getTextArea("text_loot");
      }
      
      private function setupBottom() : void
      {
         var body:ESprite = getContent("body");
         var boxes:Array = [];
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,mBottomArea,"color_blue_box");
         body.eAddChild(img);
         setContent("bottomBkg",img);
         var points:String = DCTextMng.convertNumberToString(this.mLootedCoins,-1,-1);
         var container:ESpriteContainer = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_coin",points,null,"text_coins");
         body.eAddChild(container);
         setContent("lootedCoins",container);
         boxes.push(container);
         points = DCTextMng.convertNumberToString(this.mLootedMinerals,-1,-1);
         container = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_minerals",points,null,"text_minerals");
         body.eAddChild(container);
         setContent("lootedMinerals",container);
         boxes.push(container);
         points = DCTextMng.convertNumberToString(this.mScoreGained,-1,-1);
         container = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_score",points,null,"text_score");
         body.eAddChild(container);
         setContent("score",container);
         boxes.push(container);
         points = DCTextMng.convertNumberToString(this.mAllianceScore,-1,-1);
         container = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",points,null,"text_title_3");
         body.eAddChild(container);
         setContent("allianceScore",container);
         boxes.push(container);
         if(!this.mShowAllianceScore)
         {
            container.alpha = 0.5;
         }
         mViewFactory.distributeSpritesInArea(mBottomArea,boxes,1,1,boxes.length,1,true);
         var field:ETextField;
         (field = mViewFactory.getETextField(null,this.mSubtitleArea,"text_header")).setText(DCTextMng.getText(580));
         body.eAddChild(field);
         setContent("subtitle",field);
      }
      
      private function setupButtons() : void
      {
         var button:EButton = null;
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(583),0,"btn_social");
         addButton("publishButton",button);
         button.eAddEventListener("click",onCloseClick);
      }
      
      override protected function onCloseClick(e:EEvent) : void
      {
         super.onCloseClick(e);
         InstanceMng.getUnitScene().battleResultClose();
      }
   }
}
