package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.facade.WarBarSpecialFacade;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EWarBarSpecialBox extends ESpriteContainer
   {
       
      
      protected var mIconSize:String = "small";
      
      protected var mRewardObjectRef:RewardObject;
      
      private var mUseBtn:EButton;
      
      private var mPayBtn:EButton;
      
      private var mTextField:ETextField;
      
      public function EWarBarSpecialBox(rewardObjectRef:RewardObject)
      {
         super();
         this.mRewardObjectRef = rewardObjectRef;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var q:int = 0;
         super.logicUpdate(dt);
         if(this.mTextField)
         {
            q = this.mRewardObjectRef.getItem().quantity;
            this.mTextField.setText(q.toString());
            this.mUseBtn.visible = q > 0;
            this.mPayBtn.visible = q <= 0;
         }
      }
      
      public function build(layoutArea:ELayoutArea = null) : void
      {
         var container:ESpriteContainer = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerItemButtonIcon");
         var buttonArea:ELayoutArea = layoutFactory.getArea("ibtn");
         this.mPayBtn = viewFactory.getButtonPayment(buttonArea,EntryFactory.createCashSingleEntry(this.mRewardObjectRef.getSpecialAttackDef().getCash()),null,"XS");
         this.mUseBtn = viewFactory.getButtonByTextWidth(DCTextMng.getText(623),0,"btn_common",null,null,"XS",buttonArea);
         if(this.mIconSize == "small")
         {
            container = viewFactory.getContainerItemButtonIconSmall(this.mRewardObjectRef.getAssetId(),this.mPayBtn,this.mRewardObjectRef.getItem().quantity.toString());
         }
         else
         {
            container = viewFactory.getContainerItemButtonIconLarge(this.mRewardObjectRef.getAssetId(),this.mPayBtn,this.mRewardObjectRef.getItem().quantity.toString());
         }
         this.mUseBtn.logicLeft = this.mPayBtn.logicLeft + (this.mPayBtn.getLogicWidth() - this.mUseBtn.getLogicWidth()) / 2;
         this.mUseBtn.logicTop = this.mPayBtn.logicTop + (this.mPayBtn.getLogicHeight() - this.mUseBtn.getLogicHeight()) / 2;
         container.eAddChild(this.mUseBtn);
         container.setContent("useBtn",this.mUseBtn);
         this.name = this.mRewardObjectRef.getSpecialAttackDef().getSku();
         this.mTextField = container.getContentAsETextField("text");
         this.mPayBtn.eAddEventListener("click",this.onBuySpecialAttack);
         this.mUseBtn.eAddEventListener("click",this.onUseSpecialAttack);
         this.eAddEventListener("rollOver",this.onMouseOver);
         this.eAddEventListener("rollOut",this.onMouseOut);
         container.setLayoutArea(layoutArea,true);
         this.eAddChild(container);
         this.setContent("CONTENT",container);
         this.logicUpdate(0);
      }
      
      override public function setIsEnabled(value:Boolean) : void
      {
         this.mPayBtn.setIsEnabled(value);
         this.mUseBtn.setIsEnabled(value);
         this.mouseEnabled = value;
         this.mouseChildren = value;
      }
      
      private function onUseSpecialAttack(evt:EEvent) : void
      {
         InstanceMng.getToolsMng().setToolLaunchSpecialAttack(this.mRewardObjectRef.getSpecialAttackDef().getSku(),false);
         var wbs:WarBarSpecialFacade = InstanceMng.getUIFacade().getWarBarSpecial();
         wbs.popupShown = false;
         wbs.popupAccepted = false;
      }
      
      private function onBuySpecialAttack(evt:EEvent) : void
      {
         InstanceMng.getToolsMng().setToolLaunchSpecialAttack(this.mRewardObjectRef.getSpecialAttackDef().getSku(),true);
         var wbs:WarBarSpecialFacade = InstanceMng.getUIFacade().getWarBarSpecial();
         wbs.popupShown = false;
         wbs.popupAccepted = false;
      }
      
      private function onMouseOver(evt:EEvent) : void
      {
         ETooltipMng.getInstance().createTooltipInfoFromDef(this.mRewardObjectRef.getSpecialAttackDef(),this);
      }
      
      private function onMouseOut(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      public function emulateActionClicked() : void
      {
         var usedCash:Boolean = this.mPayBtn.visible;
         InstanceMng.getToolsMng().setToolLaunchSpecialAttack(this.mRewardObjectRef.getSpecialAttackDef().getSku(),usedCash);
         var wbs:WarBarSpecialFacade = InstanceMng.getUIFacade().getWarBarSpecial();
         wbs.popupShown = false;
         wbs.popupAccepted = false;
      }
   }
}
