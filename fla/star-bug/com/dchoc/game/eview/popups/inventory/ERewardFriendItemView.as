package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.events.EEvent;
   import flash.utils.Dictionary;
   
   public class ERewardFriendItemView extends ERewardItemView
   {
       
      
      protected var mFriendAccountId:String;
      
      public function ERewardFriendItemView(friendAccountId:String)
      {
         super();
         mActionButtonTextId = 249;
         mLayoutName = "ContainerItemButtonIconSmall";
         this.mFriendAccountId = friendAccountId;
         this.eAddEventBehavior("Disable",InstanceMng.getBehaviorsMng().getMouseBehavior("Disable"));
         this.eAddEventBehavior("Enable",InstanceMng.getBehaviorsMng().getMouseBehavior("Enable"));
      }
      
      override protected function createBkg() : void
      {
      }
      
      override protected function createText() : void
      {
      }
      
      override protected function onUseThis(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["friendAccountId"] = this.mFriendAccountId;
         params["itemSku"] = mItemObject.mDef.getSku();
         MessageCenter.getInstance().sendMessage("friendBoxWishlistClicked",params);
         this.wishlistCheckItem();
      }
      
      public function wishlistCheckItem() : void
      {
         if(mItemObject)
         {
            setIsEnabled(mItemObject.quantity > 0 && mItemObject.mDef.isInWishList() && !InstanceMng.getApplication().getSendingWishlistItem(this.mFriendAccountId + mItemObject.mDef.mSku));
            mouseChildren = getIsEnabled();
         }
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
      }
   }
}
