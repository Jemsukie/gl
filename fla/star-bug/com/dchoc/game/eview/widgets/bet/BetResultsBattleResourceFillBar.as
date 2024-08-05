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
   
   public class BetResultsBattleResourceFillBar extends ESpriteContainer
   {
      
      private static const AREA_ICON:String = "icon";
      
      private static const AREA_BAR:String = "bar";
      
      private static const AREA_VALUE:String = "text";
      
      private static const ICON_ID:String = "icon";
      
      private static const FILL_BAR_BASE_ID:String = "fillBarBase";
      
      private static const FILL_BAR_ID:String = "fillBar";
      
      private static const TEXTFIELD_ID:String = "textField";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinId:String;
      
      public function BetResultsBattleResourceFillBar(viewFactory:ViewFactory, skinId:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinId = skinId;
      }
      
      public function setup(maxValue:Number, value:Number, icon:String, color:String, textColor:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var BAR_MARGIN:int = 0;
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("BetResultsBattleBar");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var OFFSET:int = (BAR_MARGIN = 4) * 2;
         var fillBarArea:ELayoutArea = layoutFactory.getArea("bar");
         var fillBarBase:EFillBar = this.mViewFactory.createFillBar(0,fillBarArea.width,fillBarArea.height,0,"color_fill_bkg");
         setContent("fillBarBase",fillBarBase);
         fillBarBase.logicLeft = fillBarArea.x;
         fillBarBase.logicTop = fillBarArea.y;
         eAddChild(fillBarBase);
         var fillBar:EFillBar = this.mViewFactory.createFillBar(1,fillBarArea.width - OFFSET,fillBarArea.height - OFFSET,maxValue,color);
         setContent("fillBar",fillBar);
         fillBar.logicLeft = fillBarArea.x + BAR_MARGIN;
         fillBar.logicTop = fillBarArea.y + BAR_MARGIN;
         fillBar.setValue(value);
         eAddChild(fillBar);
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text");
         var textField:ETextField = this.mViewFactory.getETextField(this.mSkinId,textArea);
         setContent("textField",textField);
         textField.setText(DCTextMng.convertNumberToString(value,2,8));
         eAddChild(textField);
         if(textColor != null)
         {
            textField.applySkinProp(this.mSkinId,textColor);
         }
         var iconImg:EImage = this.mViewFactory.getEImage(icon,null,true,layoutFactory.getArea("icon"));
         setContent("icon",iconImg);
         this.eAddChild(iconImg);
      }
   }
}
