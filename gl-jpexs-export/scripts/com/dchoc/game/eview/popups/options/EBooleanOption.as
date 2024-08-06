package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EBooleanOption extends ESpriteContainer
   {
      
      private static const BUTTON_SIZE:int = 30;
       
      
      private var mOptionLayout:ELayoutArea;
      
      private var mCheckBox:ESpriteContainer;
      
      private var mTitleTid:int;
      
      private var mTooltipTid:int;
      
      private var mOnSelectAction:Function;
      
      public function EBooleanOption(titleTid:int, onSelectAction:Function, tooltipTid:int = -1)
      {
         super();
         this.mTitleTid = titleTid;
         this.mOnSelectAction = onSelectAction;
         this.mTooltipTid = tooltipTid;
      }
      
      public function init(layoutArea:ELayoutArea) : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         this.mOptionLayout = layoutArea;
         var middleLayout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutArea);
         middleLayout.width = middleLayout.width - 30;
         var fieldBkg:EImage = viewFactory.getEImage("generic_box",null,false,middleLayout);
         setContent("optionBkg",fieldBkg);
         eAddChild(fieldBkg);
         var titleField:ETextField;
         (titleField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(middleLayout),"text_title_3")).setText(DCTextMng.getText(this.mTitleTid));
         titleField.setHAlign("center");
         titleField.setVAlign("center");
         setContent("optionTitle",titleField);
         eAddChild(titleField);
         var layoutButton:ELayoutArea = ELayoutAreaFactory.createLayoutArea(30,30);
         layoutButton.x = layoutArea.width - 30;
         layoutButton.y = (layoutArea.height - 30) / 2;
         this.mCheckBox = viewFactory.getCheckBox(layoutButton,null,true);
         this.mCheckBox.eAddEventListener("click",this.onCheckboxClicked);
         setContent("checkbox",this.mCheckBox);
         eAddChild(this.mCheckBox);
         if(this.mTooltipTid != -1)
         {
            ETooltipMng.getInstance().createTooltipForStarDisplayObject(DCTextMng.getText(this.mTooltipTid),this,true,false);
         }
      }
      
      public function setCheckboxValue(value:Boolean) : void
      {
         InstanceMng.getViewFactory().setChecked(this.mCheckBox,value);
      }
      
      private function onCheckboxClicked(evt:EEvent) : void
      {
         var value:Boolean = InstanceMng.getViewFactory().isCheckBoxChecked(this.mCheckBox);
         if(this.mOnSelectAction != null)
         {
            this.mOnSelectAction(value);
         }
      }
   }
}
