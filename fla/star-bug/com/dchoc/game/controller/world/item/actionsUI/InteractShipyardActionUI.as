package com.dchoc.game.controller.world.item.actionsUI
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class InteractShipyardActionUI extends ActionUI
   {
       
      
      public function InteractShipyardActionUI(actionId:int, eventTarget:DCComponent = null, eventOnClick:Object = null, tooltipType:String = null)
      {
         super(actionId,5,eventTarget,eventOnClick,tooltipType);
      }
      
      override public function getCursorId(item:WorldItemObject) : int
      {
         var shipyardToOpen:Shipyard = InstanceMng.getShipyardController().getShipyard(item.mSid);
         var shipyardOpened:Shipyard = InstanceMng.getShipyardController().getCurrentShipyard();
         if(shipyardToOpen == shipyardOpened)
         {
            return 6;
         }
         return 5;
      }
   }
}
