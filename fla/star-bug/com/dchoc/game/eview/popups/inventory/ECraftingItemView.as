package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.userdata.Profile;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class ECraftingItemView extends EInventoryItemView
   {
       
      
      private var mGroupSku:String;
      
      public function ECraftingItemView()
      {
         super();
      }
      
      public function setGroupSku(sku:String) : void
      {
         this.mGroupSku = sku;
      }
      
      override public function fillData(object:ItemObject) : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var levelRequirement:int = InstanceMng.getSettingsDefMng().mSettingsDef.getPremiumShopUnlockLevel();
         mItemObject = object;
         var tf:ETextField = getContent("text") as ETextField;
         if(object.mDef.hasMaxAmountInventory())
         {
            tf.setText(object.quantity + "/" + object.mDef.getMaxAmountInventory());
         }
         else
         {
            tf.setText("x" + object.quantity);
         }
         var bkgImage:EImage = getContent("container_box") as EImage;
         var buyBtn:EButton = getContent("ibtn_xs") as EButton;
         InstanceMng.getViewFactory().setTextureToImage("box_inventory",InstanceMng.getSkinsMng().getCurrentSkinSku(),bkgImage);
         buyBtn.visible = object.quantity == 0;
         if(profile.getLevel() < levelRequirement)
         {
            buyBtn.visible = false;
         }
         if(Config.DEBUG_ITEMS)
         {
            buyBtn.visible = true;
         }
         buyBtn.setText("" + object.mDef.getChipsCost());
         var wishBtn:EButton;
         (wishBtn = getContent("icon") as EButton).visible = object.mDef.isInWishList();
         var image:EImage = getContent("img") as EImage;
         InstanceMng.getViewFactory().setTextureToImage(object.mDef.getAssetId(),InstanceMng.getSkinsMng().getCurrentSkinSku(),image);
         getContent("btn_close").visible = false;
      }
      
      override protected function createActionButton() : void
      {
         var buyButton:EButton = mViewFactory.getButtonChips("XXXX",mLayout.getArea("ibtn_xs"),mSkinSku);
         buyButton.eAddEventListener("click",this.onUseThis);
         buyButton.layoutApplyTransformations(mLayout.getArea("ibtn_xs"));
         eAddChild(buyButton);
         setContent("ibtn_xs",buyButton);
      }
      
      override protected function onUseThis(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["rewardSku"] = mItemObject.mDef.getSku();
         InstanceMng.getItemsMng().notifyItemBought(mItemObject.mDef.mSku,null,true);
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
   }
}
