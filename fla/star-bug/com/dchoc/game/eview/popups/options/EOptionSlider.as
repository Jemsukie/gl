package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   
   public class EOptionSlider extends ESpriteContainer
   {
      
      private static const ARROW_INCREMENT_AMOUNT:int = 5;
      
      private static const BUTTON_SIZE:int = 30;
       
      
      private var mMinValue:int = 0;
      
      private var mMaxValue:int = 100;
      
      private var mHasCheckbox:Boolean;
      
      private var mOptionLayout:ELayoutArea;
      
      private var mBarLayout:ELayoutArea;
      
      private var mValue:int = -1;
      
      private var mBar:EFillBar;
      
      private var mCheckBox:ESpriteContainer;
      
      private var mTextField:ETextField;
      
      private var mDownArrow:EButton;
      
      private var mUpArrow:EButton;
      
      private var mSku:String;
      
      private var mTitleTid:int;
      
      private var mOnValueChangedAction:Function;
      
      private var mOnToggledAction:Function;
      
      public function EOptionSlider(sku:String, titleTid:int, onValueChangeAction:Function, onToggledAction:Function = null)
      {
         super();
         this.mSku = sku;
         this.mTitleTid = titleTid;
         this.mOnValueChangedAction = onValueChangeAction;
         this.mOnToggledAction = onToggledAction;
         this.mHasCheckbox = this.mOnToggledAction != null;
      }
      
      public function init(layoutArea:ELayoutArea) : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         this.mOptionLayout = layoutArea;
         this.mBarLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mOptionLayout);
         var titleLayout:ELayoutArea = ELayoutAreaFactory.createLayoutArea(layoutArea.width,30);
         if(this.mHasCheckbox)
         {
            titleLayout.width -= 30;
         }
         titleLayout.x = 0;
         titleLayout.y = 0;
         var titleField:ETextField;
         (titleField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(titleLayout),"text_title_3")).setText(DCTextMng.getText(this.mTitleTid));
         titleField.autoSize(false);
         titleField.setFontSize(16);
         titleField.setHAlign("center");
         titleField.setVAlign("center");
         setContent("optionTitle",titleField);
         eAddChild(titleField);
         var marginForButtons:int = 30 * (this.mHasCheckbox ? 3 : 2);
         var barLayout:ELayoutArea;
         (barLayout = ELayoutAreaFactory.createLayoutArea(layoutArea.width - marginForButtons,layoutArea.height - titleLayout.height)).x = 30;
         barLayout.y = titleLayout.height;
         var bar:ESpriteContainer = this.getBar(barLayout);
         setContent("bar",bar);
         eAddChildAt(bar,0);
         this.mBar = bar.getContent("fillbar") as EFillBar;
         this.mBar.mouseEnabled = false;
         this.mBar.mouseChildren = false;
         var barBkg:ESpriteContainer;
         (barBkg = bar.getContentAsESpriteContainer("fillbarBkg")).mouseEnabled = false;
         barBkg.mouseChildren = false;
         var hitboxMask:EFillBar;
         (hitboxMask = viewFactory.createFillBar(0,barLayout.width,barLayout.height,0,"color_fill_bkg")).layoutApplyTransformations(barLayout);
         hitboxMask.alpha = 0;
         hitboxMask.eAddEventListener("click",this.onBarClicked);
         setContent("hitboxMask",hitboxMask);
         eAddChild(hitboxMask);
         this.mTextField = viewFactory.getETextField(null,null,"text_title_3");
         this.mTextField.autoSize(false);
         this.mTextField.setFontSize(20);
         this.mTextField.setText("" + this.mValue);
         barLayout.centerContent(this.mTextField);
         this.mTextField.y -= 2;
         this.mTextField.mouseEnabled = false;
         this.mTextField.mouseChildren = false;
         bar.setContent("textField",this.mTextField);
         bar.eAddChild(this.mTextField);
         bar.name = "bar";
         var buttonLayoutArea:ELayoutArea;
         (buttonLayoutArea = ELayoutAreaFactory.createLayoutArea(30,30)).x = 30;
         buttonLayoutArea.y = barLayout.y;
         this.mDownArrow = viewFactory.getButtonImage("btn_arrow",null);
         this.mDownArrow.setLayoutArea(buttonLayoutArea,true);
         this.mDownArrow.eAddEventListener("click",this.onDownArrowClicked);
         this.mDownArrow.scaleLogicX = -1;
         bar.setContent("downArrow",this.mDownArrow);
         bar.eAddChild(this.mDownArrow);
         buttonLayoutArea.x = 30 + barLayout.width;
         this.mUpArrow = viewFactory.getButtonImage("btn_arrow",null);
         this.mUpArrow.setLayoutArea(buttonLayoutArea,true);
         this.mUpArrow.eAddEventListener("click",this.onUpArrowClicked);
         bar.setContent("upArrow",this.mUpArrow);
         bar.eAddChild(this.mUpArrow);
         if(this.mHasCheckbox)
         {
            buttonLayoutArea.x += 30;
            buttonLayoutArea.width = 30;
            buttonLayoutArea.height = 30;
            this.mCheckBox = viewFactory.getCheckBox(buttonLayoutArea,null,true);
            eAddChild(this.mCheckBox);
            setContent("checkbox",this.mCheckBox);
            this.mCheckBox.eAddEventListener("click",this.onCheckboxClicked);
         }
         this.setValue(0,false);
      }
      
      public function setBounds(min:int, max:int) : void
      {
         this.mMinValue = min;
         this.mMaxValue = max;
      }
      
      private function getBar(fillbarArea:ELayoutArea) : ESpriteContainer
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var OFFSET:int = 6;
         var container:ESpriteContainer = viewFactory.getESpriteContainer();
         var fillbar:EFillBar = viewFactory.createFillBar(0,fillbarArea.width,fillbarArea.height,0,"color_fill_bkg");
         container.setContent("fillbarBkg",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         var deltaTotal:int = this.mMaxValue - this.mMinValue;
         fillbar = viewFactory.createFillBar(1,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,deltaTotal,"color_score");
         container.setContent("fillbar",fillbar);
         container.eAddChild(fillbar);
         fillbarArea.centerContent(fillbar);
         return container;
      }
      
      private function onDownArrowClicked(evt:EEvent) : void
      {
         this.setValue(Math.max(this.mMinValue,this.mValue - 5));
      }
      
      private function onUpArrowClicked(evt:EEvent) : void
      {
         this.setValue(Math.min(this.mMaxValue,this.mValue + 5));
      }
      
      private function onBarClicked(evt:EEvent) : void
      {
         var value:int = this.mMinValue + (this.mMaxValue - this.mMinValue) * (evt.localX - 2) / this.mBar.width;
         if(this.isCheckBoxEnabled())
         {
            this.setValue(value);
         }
      }
      
      private function onCheckboxClicked(evt:EEvent) : void
      {
         this.updateElements();
         this.mOnToggledAction(this.mSku,this.isCheckBoxEnabled());
      }
      
      private function isCheckBoxEnabled() : Boolean
      {
         return InstanceMng.getViewFactory().isCheckBoxChecked(this.mCheckBox) || !this.mHasCheckbox;
      }
      
      private function updateElements() : void
      {
         var isEnabled:Boolean = this.isCheckBoxEnabled();
         this.mBar.setValue(this.mValue - this.mMinValue);
         this.mBar.setIsEnabled(isEnabled);
         this.mBar.unapplySkinProp(null,"color_score");
         this.mBar.unapplySkinProp(null,"disabled");
         this.mBar.applySkinProp(null,isEnabled ? "color_score" : "disabled");
         this.mTextField.unapplySkinProp(null,"disabled");
         if(!isEnabled)
         {
            this.mTextField.applySkinProp(null,"disabled");
         }
         this.mTextField.setText("" + this.mValue);
         this.mDownArrow.setIsEnabled(isEnabled && this.mValue > this.mMinValue);
         this.mUpArrow.setIsEnabled(isEnabled && this.mValue < this.mMaxValue);
      }
      
      public function setValue(value:int, doAction:Boolean = true) : void
      {
         if(value != this.mValue && value >= this.mMinValue && value <= this.mMaxValue)
         {
            this.mValue = value;
            this.updateElements();
            if(doAction)
            {
               this.mOnValueChangedAction(this.mSku,value);
            }
         }
      }
      
      public function getValue() : int
      {
         return this.mValue;
      }
      
      public function setToggled(value:Boolean) : void
      {
         if(this.mHasCheckbox)
         {
            if(value != this.isCheckBoxEnabled())
            {
               InstanceMng.getViewFactory().setChecked(this.mCheckBox,value);
            }
         }
         this.updateElements();
      }
   }
}
