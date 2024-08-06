package com.dchoc.game.eview.popups.missions
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupMissionTargetBox extends ESpriteContainer
   {
      
      private static const BKG_ID:String = "bkg";
       
      
      private var mIcon:EImage;
      
      private var mTickIcon:EImage;
      
      private var mText:ETextField;
      
      private var mTextSecondary:ETextField;
      
      private var mProgress:ETextField;
      
      private var mActionButton:EButton;
      
      private var mBuyButton:EButton;
      
      private var mBkg:EImage;
      
      private var mSkinSku:String;
      
      private var mGotoTab:String;
      
      private var mFBCredits:Number = 0;
      
      private var mTargetDef:DCTargetDef;
      
      private var mParentRef:EPopupMissionProgress;
      
      private var mIndexInTarget:int;
      
      public function EPopupMissionTargetBox()
      {
         this.mLogicUpdateFrequency = 1000;
         super();
      }
      
      public function build(layout:ELayoutAreaFactory, skinSku:String, parentRef:EPopupMissionProgress) : void
      {
         this.mParentRef = parentRef;
         this.mSkinSku = skinSku;
         var viewFactory:ViewFactory;
         var bkg:EImage = (viewFactory = InstanceMng.getViewFactory()).getEImage("generic_box",this.mSkinSku,false,layout.getArea("container_mission"));
         setContent("bkg",bkg);
         eAddChild(bkg);
         this.mIcon = viewFactory.getEImage(null,this.mSkinSku,false,layout.getArea("icon"));
         this.mTickIcon = viewFactory.getEImage("icon_tick",this.mSkinSku,false,layout.getArea("area_tick"));
         this.mTickIcon.visible = false;
         this.mText = viewFactory.getETextField(this.mSkinSku,layout.getTextArea("text_info"));
         this.mText.setHAlign("left");
         this.mText.setVAlign("top");
         var tLayout:ELayoutTextArea;
         (tLayout = ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layout.getTextArea("text_number"))).width = bkg.getLogicWidth();
         tLayout.x = bkg.logicX;
         tLayout.y += 25;
         this.mTextSecondary = viewFactory.getETextField(this.mSkinSku,tLayout);
         this.mTextSecondary.setHAlign("right");
         this.mTextSecondary.setVAlign("top");
         this.mProgress = viewFactory.getETextField(this.mSkinSku,layout.getTextArea("text_number"));
         this.mActionButton = viewFactory.getButton("btn_accept",this.mSkinSku,"M","");
         this.mActionButton.setLayoutArea(layout.getArea("btn"),true);
         this.mBuyButton = viewFactory.getButton("btn_common",this.mSkinSku,"M","","icon_chip");
         this.mBuyButton.setLayoutArea(layout.getArea("ibtn"),true);
         this.mActionButton.visible = false;
         this.mBuyButton.visible = false;
         this.mText.applySkinProp(this.mSkinSku,"text_body_2");
         this.mTextSecondary.applySkinProp(this.mSkinSku,"text_body_2");
         this.mProgress.applySkinProp(this.mSkinSku,"text_body_2");
         eAddChild(this.mIcon);
         eAddChild(this.mBkg = InstanceMng.getViewFactory().getEImage("bar",this.mSkinSku,false,layout.getArea("area")));
         eAddChild(this.mTickIcon);
         eAddChild(this.mText);
         eAddChild(this.mTextSecondary);
         eAddChild(this.mProgress);
         eAddChild(this.mActionButton);
         eAddChild(this.mBuyButton);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mIcon.destroy();
         this.mTickIcon.destroy();
         this.mText.destroy();
         this.mTextSecondary.destroy();
         this.mProgress.destroy();
         this.mActionButton.destroy();
         this.mBuyButton.destroy();
         this.mBkg.destroy();
      }
      
      public function setText(text:String) : void
      {
         this.mText.setText(text);
      }
      
      public function setTextSecondary(text:String) : void
      {
         this.mTextSecondary.setText(text);
      }
      
      public function setProgressText(text:String) : void
      {
         this.mProgress.setText(text);
      }
      
      public function setIconInfo(text:String) : void
      {
         InstanceMng.getViewFactory().setTextureToImage("icon_mission_" + text,this.mSkinSku,this.mIcon);
      }
      
      public function setSecondaryRequirement(targetDef:DCTargetDef, index:int) : void
      {
         var requirement:int = targetDef.getMiniTargetAttackBound(index);
         if(requirement != 0)
         {
            this.setTextSecondary(DCTextMng.replaceParameters(4087,[requirement]));
         }
      }
      
      public function setupButtons(targetDef:DCTargetDef, index:int) : void
      {
         this.mTargetDef = targetDef;
         this.mGotoTab = targetDef.getMiniTargetGoToTab(index);
         this.mFBCredits = Number(targetDef.getMiniTargetFBCredits(index));
         var receiveAttack:Boolean = targetDef.getMiniTargetReceiveAttack(index);
         var sendAttack:Boolean = targetDef.getMiniTargetSendAttack(index);
         if(this.mFBCredits != 0)
         {
            this.mBuyButton.visible = true;
            this.mBuyButton.setText(DCTextMng.replaceParameters(200,[this.mFBCredits]));
            this.mBuyButton.eAddEventListener("click",this.setFBCreditsFunctionality);
         }
         if(this.mGotoTab != "" && this.mGotoTab != null)
         {
            this.mActionButton.visible = true;
            this.mActionButton.setText(DCTextMng.getText(612));
            this.mActionButton.eAddEventListener("click",this.setGotoTabFunctionality);
            this.mActionButton.setFunnelLabel("goToShop");
         }
         else if(receiveAttack == true)
         {
            this.mActionButton.visible = true;
            this.mActionButton.eAddEventListener("click",this.setReceiveAttackFunctionality);
            this.mActionButton.setText(DCTextMng.getText(265));
         }
         else if(sendAttack == true)
         {
            this.mActionButton.visible = true;
            this.mActionButton.eAddEventListener("click",this.setSendAttackFunctionality);
            this.mActionButton.setText(DCTextMng.getText(428));
         }
      }
      
      public function setMiniTargetIndexInTarget(i:int) : void
      {
         this.mIndexInTarget = i;
      }
      
      public function disableBuyButton() : void
      {
         this.mBuyButton.setIsEnabled(false);
      }
      
      private function setGotoTabFunctionality(e:EEvent) : void
      {
         InstanceMng.getPopupMng().closePopup(this.mParentRef);
         InstanceMng.getGUIControllerPlanet().openShopBar(this.mGotoTab + "_button");
      }
      
      private function setFBCreditsFunctionality(e:EEvent) : void
      {
         var t:Transaction = InstanceMng.getRuleMng().createSingleTransaction(true,this.mFBCredits,0,0,0,null,"NOTIFY_SKIP_TARGET_WITH_FB");
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_SKIP_TARGET_WITH_FB",InstanceMng.getGUIControllerPlanet());
         var target:DCTarget = InstanceMng.getTargetMng().getTargetById(this.mTargetDef.mSku);
         var neededAmount:int = this.mTargetDef.getMiniTargetAmount(this.mIndexInTarget);
         o.transaction = t;
         o.target = target;
         o.neededAmount = neededAmount;
         o.indexTarget = this.mIndexInTarget;
         o.miniTargetInfo = this;
         o.button = "EventYesButtonPressed";
         o.phase = "OUT";
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o);
      }
      
      private function setReceiveAttackFunctionality(e:EEvent) : void
      {
         InstanceMng.getPopupMng().closePopup("NotifyMissionProgress");
         var sku:String = this.mTargetDef.getMiniTargetSku(this.mIndexInTarget);
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         InstanceMng.getUnitScene().openShowIncomingAttackPopup(ruleMng.npcsGetAttack(sku),ruleMng.npcsGetNpcSku(sku),ruleMng.npcsGetDeployX(sku),ruleMng.npcsGetDeployY(sku),ruleMng.npcsGetDeployWay(sku),ruleMng.npcsGetDuration(sku));
      }
      
      private function setSendAttackFunctionality(e:EEvent) : void
      {
         InstanceMng.getPopupMng().closePopup("NotifyMissionProgress");
         var sku:String = this.mTargetDef.getMiniTargetNPC(this.mIndexInTarget);
         InstanceMng.getApplication().requestPlanet(sku,"-2",3);
      }
      
      public function setCompleted(complete:Boolean) : void
      {
         var alpha:Number = NaN;
         if(complete)
         {
            alpha = 0.6;
            this.setProgressText(DCTextMng.getText(263));
            this.setProgressText("");
            this.mActionButton.visible = false;
            this.mBuyButton.visible = false;
            this.mTickIcon.visible = true;
         }
         else
         {
            alpha = 1;
            this.mTickIcon.visible = false;
         }
         this.mText.alpha = alpha;
         this.mTextSecondary.alpha = alpha;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var currProgress:int = 0;
         var isComplete:* = false;
         super.logicUpdate(dt);
         if(this.mIcon != null)
         {
            this.mIcon.logicUpdate(dt);
         }
         if(this.mTickIcon != null)
         {
            this.mTickIcon.logicUpdate(dt);
         }
         if(this.mText != null)
         {
            this.mText.logicUpdate(dt);
         }
         if(this.mTextSecondary != null)
         {
            this.mTextSecondary.logicUpdate(dt);
         }
         if(this.mProgress != null)
         {
            this.mProgress.logicUpdate(dt);
         }
         if(this.mActionButton != null)
         {
            this.mActionButton.logicUpdate(dt);
         }
         if(this.mBuyButton != null)
         {
            this.mBuyButton.logicUpdate(dt);
         }
         if(this.mBkg != null)
         {
            this.mBkg.logicUpdate(dt);
         }
         if(this.mTargetDef != null && this.mIndexInTarget != -1 && visible)
         {
            currProgress = InstanceMng.getTargetMng().getProgress(this.mTargetDef.mSku,this.mIndexInTarget);
            isComplete = currProgress >= this.mTargetDef.getMiniTargetAmount(this.mIndexInTarget);
            if(isComplete == true)
            {
               this.setCompleted(isComplete);
            }
         }
      }
   }
}
