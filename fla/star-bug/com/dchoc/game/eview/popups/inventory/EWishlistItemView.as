package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.events.EEvent;
   
   public class EWishlistItemView extends EInventoryItemView
   {
       
      
      protected var mContentVisibility:Boolean;
      
      public function EWishlistItemView()
      {
         super();
         this.mContentVisibility = true;
      }
      
      override protected function isWishlistSlot() : Boolean
      {
         return true;
      }
      
      override public function build(layoutName:String = null) : void
      {
         super.build(layoutName);
         getContent("icon").visible = false;
         getContent("ibtn_xs").visible = false;
         getContent("text").visible = false;
      }
      
      public function setContentVisibility(value:Boolean) : void
      {
         if(this.mContentVisibility != value)
         {
            this.mContentVisibility = value;
            getContent("img").visible = value;
            getContent("btn_close").visible = value;
            if(this.mContentVisibility)
            {
               unapplySkinProp(null,"unit_locked");
            }
            else
            {
               applySkinProp(null,"unit_locked");
            }
         }
      }
      
      override protected function onRemoveThis(evt:EEvent) : void
      {
         if(mItemObject)
         {
            InstanceMng.getItemsMng().removeItemFromWishList(mItemObject);
         }
         MessageCenter.getInstance().sendMessage("reloadInventory");
      }
   }
}
