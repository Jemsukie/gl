package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class ERewardItemView extends ESpriteContainer
   {
      
      protected static const AREA_ITEMS:String = "area_items";
      
      protected static const IMAGE:String = "icon";
      
      protected static const TEXT_NAME:String = "text_title";
      
      protected static const BUTTON:String = "ibtn_xs";
       
      
      protected var mLayout:ELayoutAreaFactory;
      
      protected var mLayoutName:String;
      
      protected var mSkinSku:String;
      
      protected var mViewFactory:ViewFactory;
      
      protected var mItemObject:ItemObject;
      
      protected var mCurrentTooltip:ETooltip;
      
      protected var mActionButtonTextId:int;
      
      public function ERewardItemView()
      {
         super();
         this.mActionButtonTextId = 619;
         this.mLayoutName = "BoxCrafting";
      }
      
      public function build() : void
      {
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mSkinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         this.mLayout = this.mViewFactory.getLayoutAreaFactory(this.mLayoutName);
         this.createBkg();
         this.createImage();
         this.createText();
         this.createActionButton();
      }
      
      protected function createBkg() : void
      {
         var image:EImage = this.mViewFactory.getEImage("img_crafting",this.mSkinSku,true,this.mLayout.getArea("area_items"));
         eAddChild(image);
         setContent("area_items",image);
      }
      
      protected function createImage() : void
      {
         var image:EImage = this.mViewFactory.getEImage(null,this.mSkinSku,true,this.mLayout.getArea("icon"));
         image.eAddEventListener("rollOver",this.onMouseOver);
         image.eAddEventListener("rollOut",this.onMouseOut);
         eAddChild(image);
         setContent("icon",image);
      }
      
      protected function createText() : void
      {
         var name:ETextField = this.mViewFactory.getETextField(this.mSkinSku,this.mLayout.getTextArea("text_title"));
         name.setText("...");
         name.applySkinProp(this.mSkinSku,"text_title_3");
         eAddChild(name);
         setContent("text_title",name);
      }
      
      protected function createActionButton() : void
      {
         var actionButton:EButton = this.mViewFactory.getButton("btn_accept",this.mSkinSku,"XS",DCTextMng.getText(this.mActionButtonTextId));
         actionButton.eAddEventListener("click",this.onUseThis);
         actionButton.layoutApplyTransformations(this.mLayout.getArea("ibtn_xs"));
         eAddChild(actionButton);
         setContent("ibtn_xs",actionButton);
      }
      
      public function setActionButtonActive(value:Boolean) : void
      {
         if(getContent("ibtn_xs"))
         {
            (getContent("ibtn_xs") as EButton).setIsEnabled(value);
         }
      }
      
      public function fillData(object:ItemObject) : void
      {
         this.mItemObject = object;
         var tf:ETextField = getContent("text_title") as ETextField;
         if(tf)
         {
            tf.setText(this.mItemObject.mDef.getNameToDisplay());
         }
         var image:EImage = getContent("icon") as EImage;
         if(image)
         {
            InstanceMng.getViewFactory().setTextureToImage(this.mItemObject.mDef.getAssetId(),null,image);
         }
      }
      
      protected function onUseThis(evt:EEvent) : void
      {
         var isCollection:* = false;
         var collectionOrCraftingSku:String = null;
         var i:int = 0;
         var itemsMng:ItemsMng = InstanceMng.getItemsMng();
         var rewardSku:String = this.mItemObject.mDef.getSku();
         var params:Dictionary;
         (params = new Dictionary())["rewardSku"] = rewardSku;
         var amt:int = 1;
         if(InstanceMng.getHotkeyMng().isShiftPressed())
         {
            isCollection = itemsMng.getCollectionIdByCollectableRewardSku(rewardSku) != null;
            collectionOrCraftingSku = isCollection ? itemsMng.getCollectionIdByCollectableRewardSku(rewardSku) : itemsMng.getCraftingIdByItemRewardSku(rewardSku);
            amt = isCollection ? itemsMng.getCollectionBulkAmount(collectionOrCraftingSku) : itemsMng.getCraftingBulkAmount(collectionOrCraftingSku);
         }
         i = 0;
         while(i < amt)
         {
            if(i == amt - 1)
            {
               params["showPopup"] = true;
               params["forceAmountText"] = amt;
            }
            else
            {
               params["showPopup"] = false;
            }
            MessageCenter.getInstance().sendMessage("tradeCollection",params);
            i++;
         }
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
      
      protected function onMouseOver(evt:EEvent) : void
      {
         var info:ETooltipInfo = null;
         if(this.mItemObject)
         {
            info = ETooltipMng.getInstance().createTooltipInfoFromDef(this.mItemObject.mDef,this);
            this.mCurrentTooltip = ETooltipMng.getInstance().showTooltip(info);
         }
      }
      
      protected function onMouseOut(evt:EEvent) : void
      {
         if(this.mCurrentTooltip)
         {
            ETooltipMng.getInstance().removeTooltip(this.mCurrentTooltip);
         }
      }
   }
}
