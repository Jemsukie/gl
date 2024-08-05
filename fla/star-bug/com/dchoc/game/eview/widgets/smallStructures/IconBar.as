package com.dchoc.game.eview.widgets.smallStructures
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EFillBar;
   
   public class IconBar extends ESpriteContainer
   {
      
      protected static const ICON_ID:String = "icon";
      
      protected static const BAR_BASE_ID:String = "bar";
      
      protected static const BAR_FILL_ID:String = "barFill";
      
      protected static const TEXT_ID:String = "text_value";
      
      protected static const TEXT_TOP_ID:String = "text_title";
       
      
      protected const BAR_MARGIN:int = 4;
      
      protected const BAR_OFFSET:int = 8;
      
      private var mLayoutSku:String;
      
      protected var mIconSku:String;
      
      protected var mBarCurrent:Number;
      
      protected var mBarMax:Number;
      
      protected var mBarNeedsToBeUpdated:Boolean;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mLastTextSkinProp:String;
      
      private var mLastTopTextSkinProp:String;
      
      private var mLastBarSkinProp:String;
      
      public function IconBar()
      {
         this.mLogicUpdateFrequency = 150;
         super();
         this.reset();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mLayoutAreaFactory = null;
         this.mLayoutSku = null;
         this.reset();
      }
      
      protected function reset() : void
      {
         this.mBarCurrent = -1;
         this.mBarMax = -1;
         this.mBarNeedsToBeUpdated = false;
      }
      
      public function setup(layoutSku:String, barCurrent:int, barMax:int, barFillColor:String, iconSku:String = null) : void
      {
         var layoutAreaFactory:ELayoutAreaFactory = null;
         var image:EImage = null;
         this.mLayoutSku = layoutSku;
         this.mIconSku = iconSku;
         this.setBarCurrentValue(barCurrent);
         this.setBarMaxValue(barMax);
         this.mLastBarSkinProp = barFillColor;
         setLayoutArea(this.getLayoutAreaFactory().getContainerLayoutArea());
         if(this.mIconSku != null)
         {
            layoutAreaFactory = this.getLayoutAreaFactory();
            image = InstanceMng.getViewFactory().getEImage(this.mIconSku,null,true,layoutAreaFactory.getArea("icon"),null);
            setContent("icon",image);
            eAddChild(image);
         }
         mouseChildren = false;
      }
      
      protected function getLayoutAreaFactory() : ELayoutAreaFactory
      {
         if(this.mLayoutAreaFactory == null)
         {
            this.mLayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory(this.mLayoutSku);
         }
         return this.mLayoutAreaFactory;
      }
      
      protected function getText(textFieldID:String, skinProp:String) : ETextField
      {
         var text:ETextField = getContentAsETextField(textFieldID);
         if(text == null)
         {
            text = InstanceMng.getViewFactory().getETextField(null,this.getLayoutAreaFactory().getTextArea(textFieldID));
            text.applySkinProp(null,skinProp);
            setContent(textFieldID,text);
            eAddChild(text);
         }
         return text;
      }
      
      public function haxGetText() : ETextField
      {
         if(!this.mLastTextSkinProp)
         {
            this.mLastTextSkinProp = "text_title_3";
         }
         return this.getText("text_value",this.mLastTextSkinProp);
      }
      
      public function updateText(text:String, skinProp:String = null) : void
      {
         if(!skinProp)
         {
            skinProp = "text_title_3";
         }
         var eTextField:ETextField = this.getText("text_value",skinProp);
         if(eTextField != null)
         {
            eTextField.setText(text);
            if(skinProp != this.mLastTextSkinProp)
            {
               eTextField.unapplySkinProp(null,this.mLastTextSkinProp);
               this.mLastTextSkinProp = skinProp;
               eTextField.applySkinProp(null,this.mLastTextSkinProp);
            }
         }
      }
      
      public function updateTopText(text:String, skinProp:String = null) : void
      {
         if(!skinProp)
         {
            skinProp = "text_title_bar";
         }
         var eTextField:ETextField = this.getText("text_title",skinProp);
         if(eTextField != null)
         {
            eTextField.setText(text);
            if(skinProp != this.mLastTopTextSkinProp)
            {
               eTextField.unapplySkinProp(null,this.mLastTopTextSkinProp);
               this.mLastTopTextSkinProp = skinProp;
               eTextField.applySkinProp(null,this.mLastTopTextSkinProp);
            }
         }
      }
      
      protected function updateBar() : void
      {
         var viewFactory:ViewFactory = null;
         var layoutAreaFactory:ELayoutAreaFactory = null;
         var area:ELayoutArea = null;
         var bar:EFillBar = null;
         var barColor:String = this.getBarFillColor();
         var fillBar:EFillBar;
         if((fillBar = getContent("barFill") as EFillBar) == null)
         {
            viewFactory = InstanceMng.getViewFactory();
            layoutAreaFactory = this.getLayoutAreaFactory();
            area = layoutAreaFactory.getArea("bar");
            bar = viewFactory.createFillBar(0,area.width,area.height,0,"color_fill_bkg");
            setContent("bar",bar);
            eAddChildAt(bar,0);
            bar.logicLeft = area.x;
            bar.logicTop = area.y;
            fillBar = viewFactory.createFillBar(1,area.width - 8,area.height - 8,this.mBarMax,barColor);
            setContent("barFill",fillBar);
            eAddChildAt(fillBar,1);
            fillBar.logicLeft = area.x + 4;
            fillBar.logicTop = area.y + 4;
            fillBar.setValue(this.mBarCurrent);
         }
         else
         {
            if(this.mLastBarSkinProp != barColor)
            {
               fillBar.applySkinProp(InstanceMng.getSkinsMng().getCurrentSkinSku(),this.mLastBarSkinProp);
               this.mLastBarSkinProp = this.mLastBarSkinProp;
               fillBar.applySkinProp(InstanceMng.getSkinsMng().getCurrentSkinSku(),this.mLastBarSkinProp);
            }
            fillBar.setMaxValue(this.mBarMax);
            fillBar.setValue(this.mBarCurrent);
         }
         this.mBarNeedsToBeUpdated = false;
      }
      
      protected function getBarFillColor() : String
      {
         return this.mLastBarSkinProp;
      }
      
      public function setBarCurrentValue(value:Number) : void
      {
         if(value != this.mBarCurrent)
         {
            this.mBarCurrent = value;
            this.mBarNeedsToBeUpdated = true;
         }
      }
      
      public function setBarMaxValue(value:Number) : void
      {
         if(value != this.mBarMax)
         {
            this.mBarMax = value;
            this.mBarNeedsToBeUpdated = true;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mBarNeedsToBeUpdated)
         {
            this.updateBar();
         }
      }
   }
}
