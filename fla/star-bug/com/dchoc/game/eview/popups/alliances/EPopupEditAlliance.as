package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   public class EPopupEditAlliance extends EPopupCreateAlliance
   {
      
      private static const CHANGE_BUTTON:String = "changeButton";
      
      private static const COST_LABEL:String = "CostLabel";
      
      private static const COST_VALUE:String = "CostValue";
       
      
      private var mCurrentLogo:Array;
      
      private var mAlliance:Alliance;
      
      private var mLogoChanged:Boolean;
      
      private var mDescriptionChanged:Boolean;
      
      private var mOriginalDesc:String;
      
      public function EPopupEditAlliance()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         if(mDescriptionInput != null)
         {
            mDescriptionInput.getTextField().addEventListener("click",this.clearField);
            mDescriptionInput.getTextField().addEventListener("focusOut",this.onFieldOut);
         }
         super.extendedDestroy();
      }
      
      override protected function getLayoutFactory() : ELayoutAreaFactory
      {
         return mViewFactory.getLayoutAreaFactory("LayoutPopupEditAlliance");
      }
      
      override protected function setupBody() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         this.mAlliance = mAllianceController.getMyAlliance();
         this.mCurrentLogo = this.mAlliance.getLogo();
         setTitleText(DCTextMng.getText(2779));
         var body:ESprite = getContent("Body");
         layoutFactory = this.getLayoutFactory();
         var img:EImage = mViewFactory.getEImage("box_simple",mSkinSku,false,layoutFactory.getArea("area_description"),"color_blue_box");
         body.eAddChild(img);
         setContent("bkgDescription",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title_description"),"text_subheader");
         body.eAddChild(field);
         setContent("descriptionTitle",field);
         field.setText(DCTextMng.getText(2782));
         this.mOriginalDesc = this.mAlliance.getDescription();
         if(this.mOriginalDesc == null || this.mOriginalDesc == "")
         {
            this.mOriginalDesc = DCTextMng.getText(2783);
         }
         mDescriptionInput = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_description"),"text_body");
         body.eAddChild(mDescriptionInput);
         mDescriptionInput.setVAlign("top");
         mDescriptionInput.setEditable(true);
         mDescriptionInput.setText(this.mOriginalDesc);
         mDescriptionInput.setMaxChars(57);
         mDescriptionInput.getTextField().addEventListener("click",this.clearField);
         mDescriptionInput.getTextField().addEventListener("focusOut",this.onFieldOut);
         mDescriptionInput.setWordWrap(true);
         setContent("description",mDescriptionInput);
         setupFlagPart();
         this.initFlag();
         var container:ESpriteContainer = mAllianceController.getAllianceFlag(this.mCurrentLogo[0],this.mCurrentLogo[1],this.mCurrentLogo[2],layoutFactory.getArea("current_flag"));
         body.eAddChild(container);
         setContent("currentFlag",container);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_aliance_name"),"text_subheader")).setText(this.mAlliance.getName());
         body.eAddChild(field);
         setContent("AllianceName",field);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_recruitment"),"text_body");
         body.eAddChild(field);
         setContent("checkText",field);
         field.setText(DCTextMng.getText(2809));
         var check:ESpriteContainer = mViewFactory.getCheckBox(layoutFactory.getArea("tick"));
         body.eAddChild(check);
         setContent("checkBox",check);
         mViewFactory.setChecked(getContentAsESpriteContainer("checkBox"),this.mAlliance.getIsPublic());
         var bkg:EImage = getBackground() as EImage;
         var button:EButton = mViewFactory.getButtonChips(InstanceMng.getAlliancesSettingsDefMng().getEditAlliancePrice().toString(),null,mSkinSku);
         button.eAddEventListener("click",this.onEditAlliancePaying);
         bkg.eAddChild(button);
         setContent("chipsButton",button);
         mFooterArea.centerContent(button);
         button.visible = false;
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(6),0,"btn_accept");
         button.eAddEventListener("click",this.onEditAllianceNoPaying);
         bkg.eAddChild(button);
         setContent("changeButton",button);
         mFooterArea.centerContent(button);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_cost"),"text_subheader")).setText(DCTextMng.getText(626));
         setContent("CostLabel",field);
         body.eAddChild(field);
         field.visible = false;
         field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),"text_body");
         var value:String = DCTextMng.replaceParameters(493,[InstanceMng.getAlliancesSettingsDefMng().getEditAlliancePrice().toString()]);
         field.setText(DCTextMng.getText(value));
         setContent("CostValue",field);
         body.eAddChild(field);
         field.visible = false;
      }
      
      private function getCheckBox(checkboxName:String) : ESpriteContainer
      {
         return getContentAsESpriteContainer(checkboxName).getContentAsESpriteContainer("check");
      }
      
      private function initFlag() : void
      {
         var t:int = 0;
         var type:String = null;
         mCurrentSelection["base"] = this.mCurrentLogo[0];
         mCurrentSelection["pattern"] = this.mCurrentLogo[1];
         mCurrentSelection["emblem"] = this.mCurrentLogo[2];
         var types:Array = ["base","emblem","pattern"];
         for(t = 0; t < types.length; )
         {
            type = String(types[t]);
            if(mCurrentSelection[type] < 4)
            {
               mBoxSelectedId[type] = mCurrentSelection[type];
               mScrollId[type] = 0;
            }
            else
            {
               mBoxSelectedId[type] = 4 - 1;
               mScrollId[type] = mCurrentSelection[type] - 4 + 1;
            }
            t++;
         }
         selectType(getContentAsEButton("button_emblem"));
         createFinalFlag();
      }
      
      private function checkLogoChanged() : Boolean
      {
         return mCurrentSelection["base"] != this.mCurrentLogo[0] || mCurrentSelection["pattern"] != this.mCurrentLogo[1] || mCurrentSelection["emblem"] != this.mCurrentLogo[2];
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var payButton:EButton = getContentAsEButton("chipsButton");
         var changeButton:EButton = getContentAsEButton("changeButton");
         var cost:ETextField = getContentAsETextField("CostLabel");
         var value:ETextField = getContentAsETextField("CostValue");
         if(!payButton.visible && this.checkLogoChanged())
         {
            payButton.visible = true;
            changeButton.visible = false;
            this.mLogoChanged = true;
            cost.visible = true;
            value.visible = true;
         }
         else if(payButton.visible && !this.checkLogoChanged())
         {
            payButton.visible = false;
            changeButton.visible = true;
            this.mLogoChanged = false;
            cost.visible = false;
            value.visible = false;
         }
      }
      
      private function onEditAlliancePaying(e:EEvent) : void
      {
         var description:String = mDescriptionInput.getText();
         if(description == DCTextMng.getText(2783))
         {
            description = "";
         }
         if(InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= InstanceMng.getAlliancesSettingsDefMng().getEditAlliancePrice())
         {
            mAllianceController.editMyAlliance(selectionToLogo(mCurrentSelection),description,mViewFactory.isCheckBoxChecked(getContentAsESpriteContainer("checkBox")),this.onEditAllianceSuccess,this.onFail,InstanceMng.getRuleMng().getTransactionEditAlliance(null),true);
         }
      }
      
      private function onEditAllianceNoPaying(e:EEvent) : void
      {
         var description:String = mDescriptionInput.getText();
         if(description == DCTextMng.getText(2783))
         {
            description = "";
         }
         mAllianceController.editMyAlliance(selectionToLogo(mCurrentSelection),description,mViewFactory.isCheckBoxChecked(getContentAsESpriteContainer("checkBox")),this.onEditAllianceSuccess,this.onFail,null,true);
      }
      
      private function onEditAllianceSuccess(e:AlliancesAPIEvent) : void
      {
         if(this.mLogoChanged)
         {
            this.createTransaction(InstanceMng.getAlliancesSettingsDefMng().getEditAlliancePrice(),"NotifyEditAlliance");
         }
         var title:String = DCTextMng.getText(2779);
         InstanceMng.getNotificationsMng().guiOpenMessagePopup("editSuccess",title,DCTextMng.getText(2951),"alliance_council_happy",this.closeAction);
         onCloseClick(null);
      }
      
      override protected function closeAction(e:EEvent) : void
      {
         var popup:EPopupAlliances = mAllianceController.getPopupAlliance() as EPopupAlliances;
         popup.setTabPage(0);
      }
      
      private function onFail(e:AlliancesAPIEvent) : void
      {
         mAllianceController.throwErrorMessage(e.getErrorTitle(),e.getErrorMsg());
      }
      
      private function createTransaction(price:int, cmd:String) : void
      {
         var o:Object = null;
         o = InstanceMng.getGUIController().createNotifyEvent("EventPopup",cmd);
         o.phase = "OUT";
         o.button = "EventYesButtonPressed";
         o.fbPrice = price;
         o.transaction = InstanceMng.getRuleMng().getTransactionPack(o);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
      }
      
      override protected function clearField(e:MouseEvent) : void
      {
         InstanceMng.getApplication().setToWindowedMode();
         if(mDescriptionInput.getText() == this.mOriginalDesc)
         {
            mDescriptionInput.getTextField().text = "";
         }
      }
      
      override protected function onFieldOut(e:FocusEvent) : void
      {
         if(mDescriptionInput.getText() == "")
         {
            mDescriptionInput.setText(this.mOriginalDesc);
         }
      }
   }
}
