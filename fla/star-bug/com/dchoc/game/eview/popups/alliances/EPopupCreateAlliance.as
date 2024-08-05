package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.text.DCStringUtils;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   import esparragon.widgets.EButton;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class EPopupCreateAlliance extends EGamePopup
   {
       
      
      protected const TYPE_BASE:String = "base";
      
      protected const TYPE_EMBLEM:String = "emblem";
      
      protected const TYPE_PATTERN:String = "pattern";
      
      protected const MINIMUM_NAME_LENGTH:int = 3;
      
      protected const MAXIMUM_NAME_LENGTH:int = 18;
      
      protected const MAXIMUM_DESC_LENGTH:int = 57;
      
      protected const SELECTION_BOX_SIZE:int = 50;
      
      protected const NUM_BOXES:int = 4;
      
      protected const BODY:String = "Body";
      
      protected const CHIPS_BUTTON:String = "chipsButton";
      
      protected const BUTTON_EMBLEM:String = "button_emblem";
      
      protected const BUTTON_BASE:String = "button_base";
      
      protected const BUTTON_PATTERN:String = "button_pattern";
      
      protected const FLAG_IMAGES:int = 4;
      
      protected const FLAG_IMG:String = "flagImg";
      
      protected const CHECK_BOX:String = "checkBox";
      
      protected var mAllianceController:AlliancesControllerStar;
      
      private var mNameInput:ETextField;
      
      protected var mDescriptionInput:ETextField;
      
      protected var mBoxSelectedId:Array;
      
      protected var mScrollId:Array;
      
      protected var mCurrentSelection:Array;
      
      protected var mFlagImagesArea:ELayoutArea;
      
      protected var mFlagImages:Array;
      
      protected var mBoxSelected:ESprite;
      
      protected var mCurrentType:String;
      
      protected var mCurrentButton:EButton;
      
      protected var mImagesCount:int;
      
      protected var mTotalImagesCount:int;
      
      protected var mBigFlagArea:ELayoutArea;
      
      public function EPopupCreateAlliance()
      {
         this.mBoxSelectedId = [];
         this.mScrollId = [];
         this.mCurrentSelection = [];
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.setupBackground();
         this.setupBody();
      }
      
      override protected function extendedDestroy() : void
      {
         if(this.mNameInput != null)
         {
            this.mNameInput.getTextField().removeEventListener("click",this.clearField);
            this.mNameInput.getTextField().removeEventListener("focusOut",this.onFieldOut);
            this.mNameInput.destroy();
            this.mNameInput = null;
         }
         this.mDescriptionInput.getTextField().removeEventListener("click",this.clearField);
         this.mDescriptionInput.getTextField().removeEventListener("focusOut",this.onFieldOut);
         this.mDescriptionInput.destroy();
         this.mDescriptionInput = null;
         var button:EButton = getContentAsEButton("buttonRandom");
         if(button != null)
         {
            ETooltipMng.getInstance().destroyTooltipFromContainer(button);
         }
         super.extendedDestroy();
         this.mFlagImagesArea = null;
         this.destroyFlagImages();
      }
      
      protected function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopM");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage("pop_m",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(img);
         setBackground(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         img.eAddChild(field);
         setTitle(field);
         field.setText(DCTextMng.getText(2778));
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         img.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         img.eAddChild(body);
         setContent("Body",body);
         mFooterArea = layoutFactory.getArea("footer");
         button = mViewFactory.getButtonChips(InstanceMng.getAlliancesSettingsDefMng().getCreateAlliancePrice().toString(),null,mSkinSku);
         button.eAddEventListener("click",this.onCreateAlliance);
         img.eAddChild(button);
         setContent("chipsButton",button);
         mFooterArea.centerContent(button);
      }
      
      protected function getLayoutFactory() : ELayoutAreaFactory
      {
         return mViewFactory.getLayoutAreaFactory("LayoutPopupCreateAlliance");
      }
      
      protected function setupBody() : void
      {
         var body:ESprite = getContent("Body");
         var layoutFactory:ELayoutAreaFactory = this.getLayoutFactory();
         var img:EImage = mViewFactory.getEImage("box_simple",mSkinSku,false,layoutFactory.getArea("area_name"),"color_blue_box");
         body.eAddChild(img);
         setContent("bkgName",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title_name"),"text_subheader");
         body.eAddChild(field);
         setContent("nameTitle",field);
         field.setText(DCTextMng.getText(2780));
         this.mNameInput = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_name"),"text_body");
         body.eAddChild(this.mNameInput);
         this.mNameInput.setVAlign("top");
         this.mNameInput.setEditable(true);
         this.mNameInput.setText(DCTextMng.getText(2781));
         this.mNameInput.setMaxChars(18);
         this.mNameInput.getTextField().addEventListener("click",this.clearField);
         this.mNameInput.getTextField().addEventListener("focusOut",this.onFieldOut);
         setContent("nameInput",this.mNameInput);
         img = mViewFactory.getEImage("box_simple",mSkinSku,false,layoutFactory.getArea("area_description"),"color_blue_box");
         body.eAddChild(img);
         setContent("bkgDescription",img);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title_description"),"text_subheader");
         body.eAddChild(field);
         setContent("descriptionTitle",field);
         field.setText(DCTextMng.getText(2782));
         this.mDescriptionInput = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_description"),"text_body");
         body.eAddChild(this.mDescriptionInput);
         this.mDescriptionInput.setVAlign("top");
         this.mDescriptionInput.setEditable(true);
         this.mDescriptionInput.setText(DCTextMng.getText(2783));
         this.mDescriptionInput.setMaxChars(57);
         this.mDescriptionInput.getTextField().addEventListener("click",this.clearField);
         this.mDescriptionInput.getTextField().addEventListener("focusOut",this.onFieldOut);
         this.mDescriptionInput.setWordWrap(true);
         this.mDescriptionInput.setMultiline(true);
         setContent("descriptionInput",this.mDescriptionInput);
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_recruitment"),"text_body");
         body.eAddChild(field);
         setContent("checkText",field);
         field.setText(DCTextMng.getText(2809));
         var check:ESpriteContainer = mViewFactory.getCheckBox(layoutFactory.getArea("tick"));
         body.eAddChild(check);
         setContent("checkBox",check);
         this.setupFlagPart();
         var button:EButton = mViewFactory.getButtonImage("btn_shuffle",mSkinSku,layoutFactory.getArea("btn_random"));
         body.eAddChild(button);
         setContent("buttonRandom",button);
         button.eAddEventListener("click",this.onRandom);
         ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(2788),button,null,true,false);
         this.onRandom(null);
      }
      
      protected function setupFlagPart() : void
      {
         var body:ESprite = getContent("Body");
         var layoutFactory:ELayoutAreaFactory = this.getLayoutFactory();
         this.mBigFlagArea = layoutFactory.getArea("area_flag");
         var img:EImage = mViewFactory.getEImage("area_timer",mSkinSku,false,this.mBigFlagArea,"color_blue_box");
         body.eAddChild(img);
         setContent("flagBkg",img);
         this.mFlagImagesArea = layoutFactory.getArea("area_flags");
         img = mViewFactory.getEImage("area_timer",mSkinSku,false,this.mFlagImagesArea,"color_blue_box");
         body.eAddChild(img);
         setContent("area_flags",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title_flag"),"text_subheader");
         body.eAddChild(field);
         setContent("flagTitle",field);
         field.setText(DCTextMng.getText(2784));
         var button:EButton = mViewFactory.getButtonImage("btn_arrow",mSkinSku,layoutFactory.getArea("btn_arrow_flip"));
         body.eAddChild(button);
         setContent("leftArrow",button);
         button.eAddEventListener("click",this.onLeftClick);
         button = mViewFactory.getButtonImage("btn_arrow",mSkinSku,layoutFactory.getArea("btn_arrow"));
         body.eAddChild(button);
         setContent("RightArrow",button);
         button.eAddEventListener("click",this.onRightClick);
         var buttonArea:ELayoutArea = layoutFactory.getArea("area_btns");
         var buttons:Vector.<EButton> = new Vector.<EButton>(0);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(2787),buttonArea.width,"btn_accept",null,null,"XS");
         body.eAddChild(button);
         setContent("button_emblem",button);
         button.eAddEventListener("click",this.onChangeType);
         buttons.push(button);
         this.mCurrentType = "emblem";
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(2785),buttonArea.width,"btn_accept",null,null,"XS");
         body.eAddChild(button);
         setContent("button_base",button);
         buttons.push(button);
         button.eAddEventListener("click",this.onChangeType);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(2786),buttonArea.width,"btn_accept",null,null,"XS");
         body.eAddChild(button);
         setContent("button_pattern",button);
         buttons.push(button);
         button.eAddEventListener("click",this.onChangeType);
         mViewFactory.distributeButtons(buttons,buttonArea,true);
      }
      
      protected function createFinalFlag() : void
      {
         var flag:ESpriteContainer = getContentAsESpriteContainer("flagImg");
         var body:ESprite = getContent("Body");
         if(flag != null)
         {
            body.eRemoveChild(flag);
            flag.destroy();
            flag = null;
         }
         flag = this.mAllianceController.getAllianceFlag(this.mCurrentSelection["base"],this.mCurrentSelection["pattern"],this.mCurrentSelection["emblem"],this.mBigFlagArea);
         body.eAddChildAt(flag,body.numChildren - 2);
         setContent("flagImg",flag);
      }
      
      private function destroyFlagImages() : void
      {
         var count:int = 0;
         var flag:ESprite = null;
         var i:int = 0;
         if(this.mFlagImages != null)
         {
            count = int(this.mFlagImages.length);
            for(i = 0; i < count; )
            {
               flag = this.mFlagImages[i];
               flag.destroy();
               flag = null;
               i++;
            }
            this.mFlagImages = null;
         }
      }
      
      private function getFlagImages() : void
      {
         var i:* = 0;
         var img:ESprite = null;
         var FLAG_SIZE:int = 50;
         this.destroyFlagImages();
         this.mFlagImages = [];
         this.mImagesCount = Math.floor(this.mFlagImagesArea.width / FLAG_SIZE);
         var body:ESprite = getContent("Body");
         var internalArea:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         internalArea.addBehavior(new ELayoutBehaviorCenterAndScale());
         internalArea.isSetPositionEnabled = false;
         var start:int = int(this.mScrollId[this.mCurrentType]);
         for(i = start; i < start + this.mImagesCount; )
         {
            if(this.mCurrentType == "pattern")
            {
               img = this.mAllianceController.getAlliancePattern(this.mCurrentSelection["base"],i,internalArea);
            }
            else
            {
               img = mViewFactory.getEImage("flag_" + this.mCurrentType + "_" + i,null,false,internalArea);
            }
            setContent("flagImg" + (i - start),img);
            body.eAddChild(img);
            img.eAddEventListener("click",this.onClickBox);
            img.buttonMode = true;
            this.mFlagImages.push(img);
            i++;
         }
         mViewFactory.distributeSpritesInArea(this.mFlagImagesArea,this.mFlagImages,1,1,-1,1,true);
         img = this.mFlagImages[this.mBoxSelectedId[this.mCurrentType]];
         img.applySkinProp(null,"mouse_over_button");
         this.mBoxSelected = img;
      }
      
      protected function selectType(button:EButton) : void
      {
         var type:String = null;
         if(this.mCurrentButton != button)
         {
            if(this.mCurrentButton != null)
            {
               this.mCurrentButton.unapplySkinProp(null,"mouse_over_button");
            }
            switch(button)
            {
               case getContentAsEButton("button_emblem"):
                  type = "emblem";
                  break;
               case getContentAsEButton("button_base"):
                  type = "base";
                  break;
               case getContentAsEButton("button_pattern"):
                  type = "pattern";
            }
            this.mCurrentType = type;
            this.mTotalImagesCount = InstanceMng.getFlagImagesDefMng().getDefsByType(this.mCurrentType).length;
            this.mCurrentButton = button;
            this.mCurrentButton.applySkinProp(null,"mouse_over_button");
         }
         this.getFlagImages();
      }
      
      private function selectFlagImg(img:ESprite) : void
      {
         if(this.mBoxSelected != null)
         {
            this.mBoxSelected.unapplySkinProp(null,"mouse_over_button");
         }
         this.mBoxSelected = img;
         this.mBoxSelected.applySkinProp(null,"mouse_over_button");
         this.mBoxSelectedId[this.mCurrentType] = this.mFlagImages.indexOf(this.mBoxSelected);
         this.mCurrentSelection[this.mCurrentType] = this.mBoxSelectedId[this.mCurrentType] + this.mScrollId[this.mCurrentType];
         this.createFinalFlag();
      }
      
      protected function selectionToLogo(selection:Array) : Array
      {
         var logo:Array = [];
         logo[0] = selection["base"];
         logo[1] = selection["pattern"];
         logo[2] = selection["emblem"];
         return logo;
      }
      
      private function logoToSelection(logo:Array) : Array
      {
         var selection:Array = [];
         selection["base"] = logo[0];
         selection["pattern"] = logo[1];
         selection["emblem"] = logo[2];
         return selection;
      }
      
      private function isFieldValid(value:String, minLength:int) : Boolean
      {
         var returnValue:Boolean = false;
         var valueLength:int;
         var lengthOK:* = (valueLength = value.length) >= minLength;
         var notBlankSpaces:int;
         var fieldWithoutBlankSpaces:String;
         var emptySpacesOK:* = (notBlankSpaces = (fieldWithoutBlankSpaces = DCStringUtils.removeExtraWhitespace(value)).length) >= minLength;
         return lengthOK && emptySpacesOK;
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onLeftClick(e:EEvent) : void
      {
         var box:int = int(this.mBoxSelectedId[this.mCurrentType]);
         var scroll:int = int(this.mScrollId[this.mCurrentType]);
         if(box > 0)
         {
            box--;
            this.mBoxSelectedId[this.mCurrentType] = box;
         }
         else if(scroll > 0)
         {
            scroll--;
            this.mScrollId[this.mCurrentType] = scroll;
            this.getFlagImages();
         }
         this.mCurrentSelection[this.mCurrentType] = box + scroll;
         this.selectFlagImg(this.mFlagImages[box]);
      }
      
      private function onRightClick(e:EEvent) : void
      {
         var box:int = int(this.mBoxSelectedId[this.mCurrentType]);
         var scroll:int = int(this.mScrollId[this.mCurrentType]);
         if(box < this.mImagesCount - 1)
         {
            box++;
            this.mBoxSelectedId[this.mCurrentType] = box;
         }
         else if(scroll + box < this.mTotalImagesCount - 1)
         {
            scroll++;
            this.mScrollId[this.mCurrentType] = scroll;
            this.getFlagImages();
         }
         this.mCurrentSelection[this.mCurrentType] = box + scroll;
         this.selectFlagImg(this.mFlagImages[box]);
      }
      
      private function onClickBox(e:EEvent) : void
      {
         this.selectFlagImg(e.getTarget() as ESprite);
      }
      
      private function onChangeType(e:EEvent) : void
      {
         this.selectType(e.getTarget() as EButton);
      }
      
      private function onRandom(e:EEvent) : void
      {
         var t:int = 0;
         var type:String = null;
         var types:Array = ["base","emblem","pattern"];
         for(t = 0; t < types.length; )
         {
            type = String(types[t]);
            this.mCurrentSelection[type] = Math.floor(InstanceMng.getFlagImagesDefMng().getDefsByType(type).length * Math.random());
            if(this.mCurrentSelection[type] < 4)
            {
               this.mBoxSelectedId[type] = this.mCurrentSelection[type];
               this.mScrollId[type] = 0;
            }
            else
            {
               this.mBoxSelectedId[type] = 4 - 1;
               this.mScrollId[type] = this.mCurrentSelection[type] - 4 + 1;
            }
            t++;
         }
         this.selectType(getContentAsEButton("button_emblem"));
         this.createFinalFlag();
      }
      
      private function onCreateAlliance(e:EEvent) : void
      {
         var notification:Notification = null;
         var pop:EPopupAlliances = null;
         var notificationToSend:Object = null;
         var openCredits:Boolean = false;
         var description:String;
         if((description = this.mDescriptionInput.getText()) == DCTextMng.getText(2783))
         {
            description = "";
         }
         var name:String;
         if((name = this.mNameInput.getText()) == DCTextMng.getText(2781))
         {
            name = "";
         }
         if(this.isFieldValid(name,3))
         {
            if(InstanceMng.getUserInfoMng().getProfileLogin().getCash() >= InstanceMng.getAlliancesSettingsDefMng().getCreateAlliancePrice())
            {
               this.mAllianceController.createAlliance(name,description,this.selectionToLogo(this.mCurrentSelection),mViewFactory.isCheckBoxChecked(getContentAsESpriteContainer("checkBox")),this.onAllianceCreateSuccess,this.onFail,InstanceMng.getRuleMng().getTransactionCreateAlliance(null),true);
            }
            else
            {
               openCredits = true;
            }
         }
         else
         {
            notification = this.mAllianceController.createNotificationIncorrectAllianceName();
            InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notification,false,true);
         }
         if(openCredits)
         {
            this.onCloseClick(null);
            pop = this.mAllianceController.getPopupAlliance() as EPopupAlliances;
            InstanceMng.getUIFacade().closePopup(pop);
            notificationToSend = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyBuyGold",InstanceMng.getGUIController(),null,null);
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),notificationToSend);
         }
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
      
      private function onAllianceCreateSuccess(e:AlliancesAPIEvent) : void
      {
         var button:EButton = null;
         this.createTransaction(InstanceMng.getAlliancesSettingsDefMng().getCreateAlliancePrice(),"NotifyCreateAlliance");
         var title:String = DCTextMng.getText(3002);
         var body:String = DCTextMng.getText(2950);
         button = mViewFactory.getButtonSocial(mSkinSku,null,DCTextMng.getText(0));
         InstanceMng.getNotificationsMng().guiOpenMessagePopupWithButton("alliancecreated",title,body,button,"alliance_council_happy",this.closeAction,false);
         this.onCloseClick(null);
      }
      
      private function onFail(e:AlliancesAPIEvent) : void
      {
         this.mAllianceController.throwErrorMessage(e.getErrorTitle(),e.getErrorMsg());
      }
      
      protected function closeAction(e:EEvent) : void
      {
         var popup:EPopupAlliances = this.mAllianceController.getPopupAlliance() as EPopupAlliances;
         popup.reloadPopup();
      }
      
      protected function clearField(e:MouseEvent) : void
      {
         var field:TextField = e.target as TextField;
         InstanceMng.getApplication().setToWindowedMode();
         if(field.text == DCTextMng.getText(2781) || field.text == DCTextMng.getText(2783))
         {
            field.text = "";
         }
      }
      
      protected function onFieldOut(e:FocusEvent) : void
      {
         var text:String = null;
         var field:TextField = e.target as TextField;
         if(field.text == "")
         {
            if(field.parent == this.mNameInput)
            {
               text = DCTextMng.getText(2781);
            }
            else if(field.parent == this.mDescriptionInput)
            {
               text = DCTextMng.getText(2783);
            }
            field.text = text;
         }
      }
   }
}
