package com.dchoc.game.eview.widgets.bet
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EFillBar;
   
   public class BetResultsResourceFillBar extends ESpriteContainer
   {
      
      private static const AREA_ICON:String = "icon";
      
      private static const AREA_ICON_ENEMY:String = "icon_enemy";
      
      private static const AREA_BAR:String = "bar";
      
      private static const AREA_BAR_RIVAL:String = "bar_rival";
      
      private static const AREA_VALUE:String = "text";
      
      private static const AREA_VALUE_RIVAL:String = "text_rival";
       
      
      private var ICON_ID:String = "icon";
      
      private var ICON_ENEMY_ID:String = "icon_enemy";
      
      private var FILL_BAR_BASE_ID:String = "fillBarBase";
      
      private var FILL_BAR_ID:String = "fillBar";
      
      private var TEXTFIELD_ID:String = "textField";
      
      private var FILL_BAR_BASE_ENEMY_ID:String = "fillBarBaseEnemy";
      
      private var FILL_BAR_ENEMY_ID:String = "fillBarEnemy";
      
      private var TEXTFIELD_ENEMY_ID:String = "textFieldEnemy";
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      public function BetResultsResourceFillBar(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mViewFactory = null;
      }
      
      public function setup(maxValue:Number, value:Number, enemyMaxValue:Number, enemyValue:Number, icon:String, color:String, textColor:String, animated:Boolean = false, timeAnim:Number = 0) : void
      {
         var BAR_MARGIN:int = 0;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("BetResultsVictoryBar");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var OFFSET:int = (BAR_MARGIN = 4) * 2;
         var fillBarArea:ELayoutArea = layoutFactory.getArea("bar");
         var fillBarBase:EFillBar = this.mViewFactory.createFillBar(0,fillBarArea.width,fillBarArea.height,0,"color_fill_bkg");
         setContent(this.FILL_BAR_BASE_ID,fillBarBase);
         fillBarBase.logicLeft = fillBarArea.x;
         fillBarBase.logicTop = fillBarArea.y;
         eAddChild(fillBarBase);
         var fillBar:EFillBar = this.mViewFactory.createFillBar(1,fillBarArea.width - OFFSET,fillBarArea.height - OFFSET,maxValue,color);
         setContent(this.FILL_BAR_ID,fillBar);
         fillBar.logicLeft = fillBarArea.x + BAR_MARGIN;
         fillBar.logicTop = fillBarArea.y + BAR_MARGIN;
         if(animated)
         {
            fillBar.setValueAnimated(0,value,timeAnim);
         }
         else
         {
            fillBar.setValue(value);
         }
         eAddChild(fillBar);
         fillBarArea = layoutFactory.getArea("bar_rival");
         var fillBarBaseEnemy:EFillBar = this.mViewFactory.createFillBar(0,fillBarArea.width,fillBarArea.height,0,"color_fill_bkg");
         setContent(this.FILL_BAR_BASE_ENEMY_ID,fillBarBaseEnemy);
         fillBarBaseEnemy.logicLeft = fillBarArea.x;
         fillBarBaseEnemy.logicTop = fillBarArea.y;
         eAddChild(fillBarBaseEnemy);
         var fillBarEnemy:EFillBar = this.mViewFactory.createFillBar(1,fillBarArea.width - OFFSET,fillBarArea.height - OFFSET,enemyMaxValue,color);
         setContent(this.FILL_BAR_ENEMY_ID,fillBarEnemy);
         fillBarEnemy.logicLeft = fillBarArea.x + BAR_MARGIN;
         fillBarEnemy.logicTop = fillBarArea.y + BAR_MARGIN;
         if(animated)
         {
            fillBarEnemy.setValueAnimated(0,enemyValue,timeAnim);
         }
         else
         {
            fillBarEnemy.setValue(enemyValue);
         }
         eAddChild(fillBarEnemy);
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text");
         var textField:ETextField = this.mViewFactory.getETextField(this.mSkinSku,textArea);
         setContent(this.TEXTFIELD_ID,textField);
         textField.setText(DCTextMng.convertNumberToString(0,2,8));
         eAddChild(textField);
         textArea = layoutFactory.getTextArea("text_rival");
         var textFieldEnemy:ETextField = this.mViewFactory.getETextField(this.mSkinSku,textArea);
         setContent(this.TEXTFIELD_ENEMY_ID,textFieldEnemy);
         textFieldEnemy.setText(DCTextMng.convertNumberToString(0,2,8));
         eAddChild(textFieldEnemy);
         if(textColor != null)
         {
            textField.applySkinProp(this.mSkinSku,textColor);
            textFieldEnemy.applySkinProp(this.mSkinSku,textColor);
         }
         var iconImg:EImage = this.mViewFactory.getEImage(icon,this.mSkinSku,true,layoutFactory.getArea("icon"));
         setContent(this.ICON_ID,iconImg);
         this.eAddChild(iconImg);
         iconImg = this.mViewFactory.getEImage(icon,this.mSkinSku,true,layoutFactory.getArea("icon_enemy"));
         setContent(this.ICON_ENEMY_ID,iconImg);
         this.eAddChild(iconImg);
      }
      
      private function getFillBar() : EFillBar
      {
         return getContent(this.FILL_BAR_ID) as EFillBar;
      }
      
      private function getTextField() : ETextField
      {
         return getContent(this.TEXTFIELD_ID) as ETextField;
      }
      
      private function getFillBarEnemy() : EFillBar
      {
         return getContent(this.FILL_BAR_ENEMY_ID) as EFillBar;
      }
      
      private function getTextFieldEnemy() : ETextField
      {
         return getContent(this.TEXTFIELD_ENEMY_ID) as ETextField;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var fillBar:EFillBar = this.getFillBar();
         var fillBarEnemy:EFillBar = this.getFillBarEnemy();
         var textField:ETextField;
         (textField = this.getTextField()).setText(DCTextMng.convertNumberToString(fillBar.getCurrentValue(),2,8));
         var textFieldEnemy:ETextField = this.getTextFieldEnemy();
         textFieldEnemy.setText(DCTextMng.convertNumberToString(fillBarEnemy.getCurrentValue(),2,8));
      }
      
      public function setMyValue(myValue:Number) : void
      {
         this.getFillBar().setValue(myValue);
         this.getTextField().setText(DCTextMng.convertNumberToString(myValue,2,8));
      }
      
      public function setHisValue(hisValue:Number) : void
      {
         this.getFillBarEnemy().setValue(hisValue);
         this.getTextFieldEnemy().setText(DCTextMng.convertNumberToString(hisValue,2,8));
      }
   }
}
