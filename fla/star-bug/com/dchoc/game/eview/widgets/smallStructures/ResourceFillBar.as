package com.dchoc.game.eview.widgets.smallStructures
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
   
   public class ResourceFillBar extends ESpriteContainer
   {
      
      private static const AREA_ICON:String = "icon";
      
      private static const AREA_BAR:String = "bar";
      
      private static const AREA_VALUE:String = "text";
       
      
      private var ICON_ID:String = "icon";
      
      private var FILL_BAR_BASE_ID:String = "fillBarBase";
      
      private var FILL_BAR_ID:String = "fillBar";
      
      private var TEXTFIELD_ID:String = "textField";
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      public function ResourceFillBar(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
      }
      
      public function setup(maxValue:Number, value:Number, icon:String, color:String, textColor:String, animated:Boolean = false, timeAnim:Number = 0) : void
      {
         var BAR_MARGIN:int = 0;
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("ProductionBar");
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
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text");
         var textField:ETextField = this.mViewFactory.getETextField(this.mSkinSku,textArea);
         setContent(this.TEXTFIELD_ID,textField);
         textField.setText(DCTextMng.convertNumberToString(value,2,8));
         eAddChild(textField);
         if(textColor != null)
         {
            textField.applySkinProp(this.mSkinSku,textColor);
         }
         var iconImg:EImage = this.mViewFactory.getEImage(icon,this.mSkinSku,true,layoutFactory.getArea("icon"));
         setContent(this.ICON_ID,iconImg);
         eAddChild(iconImg);
      }
   }
}
