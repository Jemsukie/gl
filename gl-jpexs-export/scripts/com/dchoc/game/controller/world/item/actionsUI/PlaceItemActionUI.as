package com.dchoc.game.controller.world.item.actionsUI
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   
   public class PlaceItemActionUI extends ActionUI
   {
       
      
      public function PlaceItemActionUI(actionId:int, cursorId:int, eventTarget:DCComponent = null, eventOnClick:Object = null, tooltipType:String = null)
      {
         super(actionId,cursorId,eventTarget,eventOnClick,tooltipType);
      }
      
      override public function getCursorId(item:WorldItemObject) : int
      {
         return InstanceMng.getMapControllerPlanet().uiGetTool().getCursorId();
      }
      
      override protected function isAllowedOnItem(item:WorldItemObject) : Boolean
      {
         return item.moveCanBeMoved();
      }
   }
}
