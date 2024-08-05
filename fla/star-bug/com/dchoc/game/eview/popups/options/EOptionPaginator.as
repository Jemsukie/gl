package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.PaginatorViewSimple;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class EOptionPaginator extends ESpriteContainer implements EPaginatorController
   {
      
      private static const BUTTON_SIZE:int = 30;
       
      
      private var mPaginatorAsset:ESpriteContainer;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mPaginatorView:PaginatorViewSimple;
      
      private var mOptionField:ETextField;
      
      private var mSetButton:EButton;
      
      private var mTitleTid:int;
      
      private var mOptionsSkus:Vector.<String>;
      
      private var mOptionsTextTids:Vector.<int>;
      
      private var mNumOptions:int;
      
      private var mOnSelectAction:Function;
      
      private var mConditionToDisableCurrent:Function;
      
      public function EOptionPaginator(titleTid:int, optionsSkus:Vector.<String>, optionsTextTids:Vector.<int>, onSelectAction:Function, conditionToDisableCurrent:Function)
      {
         super();
         this.mTitleTid = titleTid;
         this.mOptionsSkus = optionsSkus;
         this.mOptionsTextTids = optionsTextTids;
         this.mNumOptions = mOptionsTextTids.length;
         this.mOnSelectAction = onSelectAction;
         this.mConditionToDisableCurrent = conditionToDisableCurrent;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         if(this.mSetButton != null)
         {
            this.mSetButton.eRemoveEventListener("click",onSetButtonClicked);
            this.mSetButton.destroy();
            this.mSetButton = null;
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.fillOptionData(id,true);
         this.mPaginatorView.setPageId(id);
         this.updateSetButton();
      }
      
      public function init(spriteReference:ESpriteContainer, layoutArea:ELayoutArea) : void
      {
         var viewFactory:ViewFactory;
         var middleContainer:ESpriteContainer = (viewFactory = InstanceMng.getViewFactory()).getESpriteContainer();
         var middleLayout:ELayoutArea;
         (middleLayout = ELayoutAreaFactory.createLayoutArea(layoutArea.width - 30 * 2,layoutArea.height / 3)).x = 30;
         middleLayout.y = 0;
         middleLayout.isSetPositionEnabled = false;
         middleContainer.setLayoutArea(middleLayout,true);
         this.mPaginatorAsset = viewFactory.getPaginatorAssetSimple(middleLayout,"BtnImgM");
         middleContainer.eAddChild(this.mPaginatorAsset);
         this.mPaginatorView = new PaginatorViewSimple(this.mPaginatorAsset,0);
         this.mPaginatorComponent = new EPaginatorComponent();
         this.mPaginatorComponent.init(this.mPaginatorView,this);
         this.mPaginatorView.setPaginatorComponent(this.mPaginatorComponent);
         var fieldBkg:EImage = viewFactory.getEImage("generic_box",null,false,middleLayout);
         middleContainer.setContent("optionBkg",fieldBkg);
         middleContainer.eAddChild(fieldBkg);
         var titleField:ETextField;
         (titleField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(middleLayout),"text_title_3")).setMultiline(false);
         titleField.getTextField().multiline = false;
         titleField.setText(DCTextMng.getText(this.mTitleTid));
         titleField.setFontSize(16);
         titleField.setHAlign("center");
         titleField.setVAlign("center");
         setContent("optionTitle",titleField);
         eAddChild(titleField);
         this.mSetButton = viewFactory.getButtonSocial(null,middleLayout,DCTextMng.getText(15));
         this.mSetButton.eAddEventListener("click",onSetButtonClicked);
         setContent("optionSelectBtn",this.mSetButton);
         eAddChild(this.mSetButton);
         var optionFieldLayout:ELayoutArea;
         (optionFieldLayout = ELayoutAreaFactory.createLayoutArea(middleLayout.width,middleLayout.height)).x = 0;
         optionFieldLayout.y = 0;
         this.mOptionField = viewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(optionFieldLayout),"text_title_3");
         this.mOptionField.setFontSize(16);
         this.mOptionField.setHAlign("center");
         this.mOptionField.setVAlign("center");
         middleContainer.setContent("optionTextField",this.mOptionField);
         middleContainer.eAddChild(this.mOptionField);
         eAddChild(middleContainer);
         viewFactory.distributeSpritesInArea(layoutArea,[titleField,middleContainer,this.mSetButton],1,1,1,-1,true);
         this.fillOptionData(0,true);
         this.updateSetButton();
      }
      
      private function fillOptionData(index:int, rebuild:Boolean) : void
      {
         this.mPaginatorView.setTotalPages(this.mNumOptions);
         if(rebuild)
         {
            this.mOptionField.setText(DCTextMng.getText(this.mOptionsTextTids[index]));
         }
      }
      
      private function updateSetButton() : void
      {
         if(this.mSetButton)
         {
            this.mSetButton.setIsEnabled(!this.mConditionToDisableCurrent(this.mOptionsSkus[this.mPaginatorView.getCurrentPage()]));
         }
      }
      
      private function onSetButtonClicked(evt:EEvent) : void
      {
         this.mOnSelectAction(this.mOptionsSkus[this.mPaginatorView.getCurrentPage()]);
         this.updateSetButton();
      }
   }
}
