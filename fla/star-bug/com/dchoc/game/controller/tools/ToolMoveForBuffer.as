package com.dchoc.game.controller.tools
{
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class ToolMoveForBuffer extends ToolPlaceItem
   {
       
      
      public function ToolMoveForBuffer(id:int)
      {
         super(id,9,1,"MoveItem",true);
      }
      
      override public function getToolActionId(item:WorldItemObject) : int
      {
         var returnValue:int = super.getToolActionId(item);
         if(InstanceMng.getRole().mId == 0 && item.mServerStateId == 1 && InstanceMng.getBuildingsBufferController().isBufferOpen())
         {
            if(item.mDef.isAnObstacle())
            {
               returnValue = 7;
            }
            else
            {
               returnValue = 1;
            }
         }
         return returnValue;
      }
      
      override protected function uiMouseUpItem(item:WorldItemObject) : void
      {
         var wioController:WorldItemObjectController = null;
         var e:Object = null;
         var notificationsMng:NotificationsMng = null;
         if(item == null)
         {
            return;
         }
         if(item.mDef.isAnObstacle())
         {
            if(item.actionUIIsAllowed(this.getToolActionId(item)))
            {
               wioController = InstanceMng.getWorldItemObjectController();
               e = InstanceMng.getGUIController().createNotifyEvent(1,"WIOEventDemolitionStart",wioController);
               e.item = item;
               e.tileIndex = -1;
               InstanceMng.getNotifyMng().addEvent(wioController,e,true);
            }
         }
         else if(item.moveCanBeMoved())
         {
            super.moveBegin(item);
         }
         else
         {
            notificationsMng = InstanceMng.getNotificationsMng();
            notificationsMng.guiOpenNotificationMessage(notificationsMng.createNotificationWIOCantBeMoved());
         }
      }
   }
}
