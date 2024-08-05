package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipComplex;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EAbstractSprite;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   import esparragon.widgets.EButton;
   
   public class EInventoryItemView extends ESpriteContainer
   {
      
      protected static const AREA_ITEMS:String = "container_box";
      
      protected static const AREA_ITEMS_SKIN:String = "container_box_skin";
      
      protected static const IMAGE:String = "img";
      
      protected static const IMAGE_SKIN:String = "img_skin";
      
      protected static const ICON_WISHLIST:String = "icon";
      
      protected static const ICON_CLOSE:String = "btn_close";
      
      protected static const TEXT_NAME:String = "text";
      
      protected static const BUTTON:String = "ibtn_xs";
      
      protected static const TIMER:String = "container_icon_text_xs";
       
      
      protected var mLayout:ELayoutAreaFactory;
      
      protected var mSkinSku:String;
      
      protected var mViewFactory:ViewFactory;
      
      protected var mItemObject:ItemObject;
      
      protected var mCurrentTooltip:ETooltip;
      
      protected var mRaysImage:EImage;
      
      private var mRaysArea:ELayoutArea;
      
      private var mIsShowingTimeLeft:Boolean;
      
      private var mIsNewItemApplied:Boolean = false;
      
      public function EInventoryItemView()
      {
         this.mLogicUpdateFrequency = 1000;
         super();
      }
      
      protected function isWishlistSlot() : Boolean
      {
         return false;
      }
      
      override protected function extendedDestroy() : void
      {
         this.mLayout = null;
         this.mSkinSku = null;
         this.mViewFactory = null;
         this.mItemObject = null;
         this.mCurrentTooltip = null;
         this.mRaysImage = null;
         if(this.mRaysArea != null)
         {
            this.mRaysArea.destroy();
            this.mRaysArea = null;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         this.updateTimer();
      }
      
      public function build(layoutName:String = null) : void
      {
         if(layoutName == null)
         {
            layoutName = "BoxInventory";
         }
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mSkinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         this.mLayout = this.mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(this.mLayout.getAreaWrapper());
         this.createBkg();
         this.createImage();
         this.createText();
         this.createActionButton();
         this.createWishlistButton();
         this.createCloseButton();
      }
      
      protected function createBkg() : void
      {
         var image:EImage = this.mViewFactory.getEImage("box_inventory",this.mSkinSku,true,this.mLayout.getArea("container_box"));
         eAddChild(image);
         setContent("container_box",image);
      }
      
      protected function createRays() : void
      {
         var area:ELayoutArea = this.mLayout.getArea("container_box");
         this.mRaysArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
         this.mRaysArea.addBehavior(new ELayoutBehaviorCenterAndScale());
         this.mRaysImage = this.mViewFactory.getEImage("captain_normal",this.mSkinSku,false,this.mRaysArea);
         eAddChildAt(this.mRaysImage,1);
         setContent("shine",this.mRaysImage);
      }
      
      protected function createImage() : void
      {
         var image:EImage = this.mViewFactory.getEImage(null,this.mSkinSku,true,this.mLayout.getArea("img"));
         image.eAddEventListener("rollOver",this.onMouseOver);
         image.eAddEventListener("rollOut",this.onMouseOut);
         eAddChild(image);
         setContent("img",image);
      }
      
      protected function createText() : void
      {
         var name:ETextField = this.mViewFactory.getETextField(this.mSkinSku,this.mLayout.getTextArea("text"));
         name.setText("...");
         name.applySkinProp(this.mSkinSku,"text_title_3");
         eAddChild(name);
         setContent("text",name);
      }
      
      protected function createActionButton() : void
      {
         var actionButton:EButton = null;
         if(this.mLayout.areaExist("ibtn_xs"))
         {
            actionButton = this.mViewFactory.getButton("btn_accept",this.mSkinSku,"XS","...");
            actionButton.eAddEventListener("click",this.onUseThis);
            actionButton.layoutApplyTransformations(this.mLayout.getArea("ibtn_xs"));
            eAddChild(actionButton);
            setContent("ibtn_xs",actionButton);
         }
      }
      
      protected function createCloseButton() : void
      {
         var closeButton:EButton = this.mViewFactory.getButtonClose(this.mSkinSku,this.mLayout.getArea("btn_close"));
         closeButton.eAddEventListener("click",this.onRemoveThis);
         eAddChild(closeButton);
         setContent("btn_close",closeButton);
      }
      
      protected function createWishlistButton() : void
      {
         var wishlistButton:EButton = this.mViewFactory.getButtonImage("icon_wish",this.mSkinSku,this.mLayout.getArea("icon"));
         wishlistButton.eAddEventListener("click",this.onAddThisToWishlist);
         eAddChild(wishlistButton);
         setContent("icon",wishlistButton);
      }
      
      protected function createTimer() : void
      {
         var content:ESprite = null;
         if(this.mLayout.areaExist("container_icon_text_xs"))
         {
            content = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS","icon_clock",DCTextMng.convertTimeToStringColon(0),this.mSkinSku,"text_title_1");
            content.setLayoutArea(this.mLayout.getArea("container_icon_text_xs"),true);
            eAddChild(content);
            setContent("container_icon_text_xs",content);
         }
      }
      
      public function setCloseButtonVisible(value:Boolean) : void
      {
         var content:ESprite = getContent("btn_close");
         if(content != null)
         {
            content.visible = value;
         }
      }
      
      public function setActionButtonVisible(value:Boolean) : void
      {
         var content:ESprite = getContent("ibtn_xs");
         if(content != null)
         {
            content.visible = value;
         }
      }
      
      public function setCloseButtonActive(value:Boolean) : void
      {
         if(getContentAsEButton("btn_close") != null)
         {
            getContentAsEButton("btn_close").setIsEnabled(value);
         }
      }
      
      public function setActionButtonActive(value:Boolean) : void
      {
         if(getContentAsEButton("ibtn_xs") != null)
         {
            getContentAsEButton("ibtn_xs").setIsEnabled(value);
         }
      }
      
      private function getTimer() : ESpriteContainer
      {
         var content:ESpriteContainer = getContentAsESpriteContainer("container_icon_text_xs");
         if(content == null)
         {
            this.createTimer();
            content = getContentAsESpriteContainer("container_icon_text_xs");
         }
         return content;
      }
      
      private function setTimerVisible(value:Boolean) : void
      {
         var content:ESprite = getContent("container_icon_text_xs");
         if(content != null)
         {
            content.visible = value;
         }
      }
      
      protected function setTimerValue(time:Number) : void
      {
         var field:ETextField = null;
         var content:ESpriteContainer = this.getTimer();
         if(content)
         {
            field = content.getContent("text") as ETextField;
            field.setText(DCTextMng.convertTimeToStringColon(time));
         }
      }
      
      private function updateTimer() : void
      {
         if(this.mItemObject == null)
         {
            return;
         }
         var timeLeft:Number = NaN;
         var timer:ESprite = getContent("container_icon_text_xs");
         if(this.mItemObject.hasRunningTimeLeft())
         {
            timeLeft = this.mItemObject.getRunningTimeLeft();
            if(timeLeft > 0)
            {
               if(!this.mIsShowingTimeLeft)
               {
                  this.setIsShowingTimeLeft(true);
               }
               this.setTimerValue(timeLeft);
            }
            else
            {
               if(this.mIsShowingTimeLeft || timer != null && timer.visible)
               {
                  this.setIsShowingTimeLeft(false);
               }
               if(InstanceMng.getPowerUpMng().isAnyPowerUpActive(1))
               {
                  this.setActionButtonActive(false);
               }
            }
         }
         else if(timer != null && timer.visible)
         {
            this.setIsShowingTimeLeft(false);
         }
      }
      
      private function showAsDisabled(value:Boolean) : void
      {
         var thisAlpha:Number = value ? 0.6 : 1;
         var content:ESprite = getContent("img");
         if(content != null)
         {
            content.alpha = thisAlpha;
         }
      }
      
      private function setIsShowingTimeLeft(value:Boolean) : void
      {
         this.mIsShowingTimeLeft = value;
         if(this.mCurrentTooltip != null)
         {
            this.setTooltipBodyTextForItemDef();
         }
         if(this.mIsShowingTimeLeft)
         {
            if(this.mItemObject.quantity == 0)
            {
               this.showAsDisabled(true);
            }
            this.setTimerVisible(true);
            this.setActionButtonVisible(false);
            this.setCloseButtonVisible(false);
         }
         else
         {
            this.showAsDisabled(false);
            this.setTimerVisible(false);
            this.setActionButtonVisible(true);
            this.setCloseButtonVisible(true);
            if(this.mItemObject.quantity == 0)
            {
               MessageCenter.getInstance().sendMessage("reloadInventory");
            }
         }
      }
      
      public function setIsNewItem(value:Boolean) : void
      {
         if(value && !this.mIsNewItemApplied)
         {
            this.applySkinProp(null,"glow_red_high");
         }
         else if(!value && this.mIsNewItemApplied)
         {
            this.unapplySkinProp(null,"glow_red_high");
         }
         this.mIsNewItemApplied = value;
      }
      
      public function fillData(object:ItemObject) : void
      {
         this.onMouseOut(null);
         this.mItemObject = object;
         var tf:ETextField = getContent("text") as ETextField;
         if(tf != null)
         {
            if(this.mItemObject.mDef.getMaxAmountInventory() > 0)
            {
               tf.setText(this.mItemObject.quantity + "/" + this.mItemObject.mDef.getMaxAmountInventory());
            }
            else
            {
               tf.setText("x" + this.mItemObject.quantity);
            }
         }
         var image:EImage = getContent("img") as EImage;
         if(image != null)
         {
            InstanceMng.getViewFactory().setTextureToImage(this.mItemObject.mDef.getAssetId(),InstanceMng.getSkinsMng().getCurrentSkinSku(),image);
         }
         var closeBtn:EButton;
         if((closeBtn = getContent("btn_close") as EButton) != null)
         {
            closeBtn.visible = this.mItemObject.mDef.isRemovableFromInventory() || this.isWishlistSlot();
         }
         var wishBtn:EButton;
         if((wishBtn = getContent("icon") as EButton) != null)
         {
            wishBtn.visible = this.mItemObject.mDef.isInWishList() && !this.isWishlistSlot();
         }
         var useBtn:EButton;
         if((useBtn = getContent("ibtn_xs") as EButton) != null)
         {
            useBtn.visible = this.mItemObject.mDef.isUsableFromInventory() && !this.isWishlistSlot();
            useBtn.setText(this.getButtonTextForItem());
         }
         this.mIsShowingTimeLeft = false;
         this.logicUpdate(0);
      }
      
      protected function onRemoveThis(evt:EEvent) : void
      {
         var itemMng:ItemsMng = InstanceMng.getItemsMng();
         var thisItem:ItemObject = this.mItemObject;
         InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmInventoryDelete",DCTextMng.getText(3063),DCTextMng.getText(3679),"orange_normal",DCTextMng.getText(1),null,function():void
         {
            itemMng.removeItemFromInventory(thisItem,false);
            MessageCenter.getInstance().sendMessage("reloadInventory");
         },null);
      }
      
      protected function onAddThisToWishlist(evt:EEvent) : void
      {
         InstanceMng.getItemsMng().addItemToWishList(this.mItemObject);
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
      
      protected function onUseThis(evt:EEvent) : void
      {
         var popup:DCIPopup = null;
         if(InstanceMng.getItemsMng().isUseMultipleApplicable(this.mItemObject))
         {
            popup = InstanceMng.getUIFacade().getPopupFactory().getPopupUseResources(this.mItemObject);
            InstanceMng.getUIFacade().enqueuePopup(popup);
         }
         else
         {
            InstanceMng.getItemsMng().useItemFromInventory(this.mItemObject,evt.getTarget() as EAbstractSprite,"inventory",1);
         }
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
      
      protected function onMouseOver(evt:EEvent) : void
      {
         var info:ETooltipInfo = null;
         if(this.mCurrentTooltip)
         {
            ETooltipMng.getInstance().removeTooltip(this.mCurrentTooltip);
         }
         if(this.mItemObject)
         {
            info = ETooltipMng.getInstance().createTooltipInfoFromDef(this.mItemObject.mDef,this,null,false,false);
            this.mCurrentTooltip = ETooltipMng.getInstance().showTooltip(info);
            this.setTooltipBodyTextForItemDef();
         }
      }
      
      protected function onMouseOut(evt:EEvent) : void
      {
         if(this.mCurrentTooltip != null)
         {
            ETooltipMng.getInstance().removeTooltip(this.mCurrentTooltip);
         }
      }
      
      private function getButtonTextForItem() : String
      {
         var useDroids:int = 0;
         var tid:int = 623;
         var returnValue:String = "";
         var _loc4_:* = this.mItemObject.mDef.getInventoryBoxType();
         if("worldItem" !== _loc4_)
         {
            returnValue = DCTextMng.getText(tid);
         }
         else
         {
            useDroids = this.mItemObject.mDef.getUseDroidsFromInventory();
            returnValue = useDroids != 0 ? DCTextMng.getText(16) : DCTextMng.getText(tid);
         }
         return returnValue;
      }
      
      private function setTooltipBodyTextForItemDef() : void
      {
         var text:String = ETooltipMng.getTooltipBodyForItemDef(this.mItemObject.mDef);
         if(this.mItemObject.isRunningTimeLeft())
         {
            text = DCTextMng.getText(673) + "\n\n" + text;
         }
         if(this.mCurrentTooltip && this.mCurrentTooltip as ETooltipComplex)
         {
            ETooltipComplex(this.mCurrentTooltip).setText(text);
         }
      }
   }
}
