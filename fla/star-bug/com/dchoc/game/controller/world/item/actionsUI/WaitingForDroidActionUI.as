package com.dchoc.game.controller.world.item.actionsUI
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class WaitingForDroidActionUI extends ActionUI
   {
       
      
      public function WaitingForDroidActionUI(actionId:int, cursorId:int, eventTarget:DCComponent = null, eventOnClick:Object = null, tooltipType:String = null)
      {
         super(actionId,cursorId,eventTarget,eventOnClick,tooltipType);
      }
      
      override public function getActionId(item:WorldItemObject) : int
      {
         return item.labourGetId() == 2 ? 25 : mActionId;
      }
   }
}
