package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.messages.EPopupMessageIcons;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupWishlistError extends EPopupMessageIcons implements INotifyReceiver
   {
       
      
      public function EPopupWishlistError()
      {
         super();
      }
      
      public function build(tid:int) : void
      {
         var item:ItemObject = null;
         var button:EButton = null;
         var view:EWishlistItemView = null;
         var speechContent:ESprite = mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(tid),"text_body",mSkinSku);
         setupPopup("inventory_normal",DCTextMng.getText(191),speechContent);
         var icons:Array = [];
         var wishList:Vector.<ItemObject> = InstanceMng.getItemsMng().getWishList();
         for each(item in wishList)
         {
            (view = new EWishlistItemView()).build();
            view.fillData(item);
            icons.push(view);
         }
         setupIcons(icons);
         button = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(0));
         addButton("btn_accept",button);
         button.eAddEventListener("click",notifyPopupMngClose);
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      public function getName() : String
      {
         return "PopupWishlistError";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["reloadInventory"];
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         var _loc3_:* = cmd;
         if("reloadInventory" === _loc3_)
         {
            notifyPopupMngClose(null);
         }
      }
   }
}
