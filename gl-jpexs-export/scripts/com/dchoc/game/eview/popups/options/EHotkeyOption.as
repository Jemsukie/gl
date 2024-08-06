package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.hotkey.HotkeyMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class EHotkeyOption extends ESpriteContainer
   {
      
      private static const CHECKBOX_SIZE:int = 30;
      
      private static const PADDING:int = 3;
      
      private static const CHECK_BOX_TOOLTIP_TIDS:Vector.<int> = new <int>[4305,4306,4307];
       
      
      private var mChoiceKeyCode:uint = 0;
      
      private var mInitialChoiceKeyCode:uint = 0;
      
      private var mLayout:ELayoutArea;
      
      private var mField:ETextField;
      
      private var mModifierCheckBoxes:Vector.<ESpriteContainer>;
      
      private var mSku:String;
      
      private var mTitleText:String;
      
      private var mCheckBoxTooltips:Dictionary;
      
      private var mCurrentTooltip:ETooltip;
      
      private var mOnValueChangedCallback:Function;
      
      public function EHotkeyOption(sku:String, titleText:String, onValueChangedCallback:Function)
      {
         mModifierCheckBoxes = new Vector.<ESpriteContainer>(HotkeyMng.NUM_MODIFIERS);
         super();
         this.mSku = sku;
         this.mTitleText = titleText;
         this.mOnValueChangedCallback = onValueChangedCallback;
      }
      
      public function init(layout:ELayoutArea, initialKey:uint, initialModifiers:Vector.<Boolean>) : void
      {
         var checkBoxLayout:ELayoutArea = null;
         var checkBox:ESpriteContainer = null;
         var i:int = 0;
         this.mLayout = layout;
         this.mChoiceKeyCode = initialKey;
         this.mInitialChoiceKeyCode = initialKey;
         this.mCheckBoxTooltips = new Dictionary();
         setLayoutArea(this.mLayout,true);
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var titleWidth:int = this.mLayout.width * 0.4;
         var titleArea:ELayoutArea = ELayoutAreaFactory.createLayoutArea(titleWidth,this.mLayout.height);
         var titleField:ETextField;
         (titleField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(titleArea),"text_title_3")).setText(this.mTitleText);
         titleField.setFontSize(14);
         setContent("titleField",titleField);
         eAddChild(titleField);
         var fieldLayout:ELayoutArea;
         (fieldLayout = ELayoutAreaFactory.createLayoutArea(this.mLayout.width - titleWidth - (30 + 3) * this.mModifierCheckBoxes.length,this.mLayout.height)).x = titleWidth;
         fieldLayout.y = 0;
         var fieldBkg:EImage;
         (fieldBkg = viewFactory.getEImage("box_simple",null,false,fieldLayout,"color_blue_box")).mouseEnabled = false;
         fieldBkg.mouseChildren = false;
         setContent("primaryFieldBkg",fieldBkg);
         eAddChild(fieldBkg);
         this.mField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(fieldLayout),"text_title_3");
         var text:String = this.mChoiceKeyCode == 0 ? DCTextMng.getText(4304) : this.keyCodeToString(this.mChoiceKeyCode);
         this.mField.setText(text);
         this.mField.setEditable(true);
         this.mField.setMaxChars(1);
         this.mField.getTextField().addEventListener("keyDown",this.onFieldKeyDown);
         this.mField.getTextField().addEventListener("click",this.onFieldIn);
         this.mField.getTextField().addEventListener("focusOut",this.onFieldOut);
         this.mField.setFontSize(14);
         setContent("primaryField",this.mField);
         eAddChild(this.mField);
         for(i = 0; i < this.mModifierCheckBoxes.length; )
         {
            (checkBoxLayout = ELayoutAreaFactory.createLayoutArea(30,30)).x = this.mField.x + this.mField.width + (30 + 3) * i;
            checkBoxLayout.y = this.mLayout.y;
            checkBox = viewFactory.getCheckBox(checkBoxLayout,null,true);
            viewFactory.setChecked(checkBox,initialModifiers[i]);
            checkBox.name = "" + i;
            checkBox.eAddEventListener("rollOver",this.onMouseOverCheckBox);
            checkBox.eAddEventListener("rollOut",this.onMouseOutCheckBox);
            checkBox.eAddEventListener("click",this.onClickCheckBox);
            this.mModifierCheckBoxes[i] = checkBox;
            setContent("checkBox-" + i,checkBox);
            eAddChild(checkBox);
            this.mCheckBoxTooltips[checkBox.name] = ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(CHECK_BOX_TOOLTIP_TIDS[i]),checkBox);
            i++;
         }
      }
      
      private function onFieldKeyDown(e:KeyboardEvent) : void
      {
         var key:uint = e.keyCode;
         if(InstanceMng.getHotkeyMng().isKeyCodeValid(key))
         {
            this.mChoiceKeyCode = key;
            this.mField.setText(this.keyCodeToString(this.mChoiceKeyCode));
            this.mOnValueChangedCallback();
            return;
         }
         this.mField.setText(DCTextMng.getText(4304));
      }
      
      private function onFieldIn(e:MouseEvent) : void
      {
         this.mField.setText("");
      }
      
      private function onFieldOut(e:FocusEvent) : void
      {
         if(this.mChoiceKeyCode == 0 || this.mField.getText() == "")
         {
            this.mField.setText(DCTextMng.getText(4304));
            this.mChoiceKeyCode = 0;
            this.mOnValueChangedCallback();
         }
         this.mField.applySkinProp(null,"text_title_3");
      }
      
      private function onMouseOverCheckBox(e:EEvent) : void
      {
         var btnId:String = String(e.getTarget().name);
         this.mCurrentTooltip = ETooltipMng.getInstance().showTooltip(this.mCheckBoxTooltips[btnId]);
      }
      
      private function onMouseOutCheckBox(e:EEvent) : void
      {
         ETooltipMng.getInstance().removeTooltip(this.mCurrentTooltip);
      }
      
      private function onClickCheckBox(e:EEvent) : void
      {
         this.mOnValueChangedCallback();
      }
      
      private function keyCodeToString(input:uint) : String
      {
         return InstanceMng.getHotkeyMng().keyCodeToString(input);
      }
      
      public function getObjectForCheckConflicts() : Object
      {
         var i:int = 0;
         var returnValue:Object = {};
         returnValue["value"] = this.mChoiceKeyCode;
         for(i = 0; i < this.mModifierCheckBoxes.length; )
         {
            returnValue["modifier-" + i] = InstanceMng.getViewFactory().isCheckBoxChecked(this.mModifierCheckBoxes[i]);
            i++;
         }
         return returnValue;
      }
      
      public function getDataString() : String
      {
         var returnValue:String = this.mSku + "=" + this.mChoiceKeyCode + "/";
         for each(var checkBox in this.mModifierCheckBoxes)
         {
            returnValue += InstanceMng.getViewFactory().isCheckBoxChecked(checkBox) ? "1" : "0";
         }
         return returnValue;
      }
      
      public function reset() : void
      {
         var i:int = 0;
         this.mChoiceKeyCode = InstanceMng.getHotkeyMng().getHotkeyDefaultValue(this.mSku);
         this.mField.setText(this.keyCodeToString(this.mChoiceKeyCode));
         var defaultModifiers:Vector.<Boolean> = InstanceMng.getHotkeyMng().getHotkeyDefaultModifiers(this.mSku);
         for(i = 0; i < this.mModifierCheckBoxes.length; )
         {
            InstanceMng.getViewFactory().setChecked(this.mModifierCheckBoxes[i],defaultModifiers[i]);
            i++;
         }
      }
   }
}
