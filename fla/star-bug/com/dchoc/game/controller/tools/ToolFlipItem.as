package com.dchoc.game.controller.tools
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class ToolFlipItem extends ToolPlaceItem
   {
       
      
      public function ToolFlipItem(id:int, cursorId:int, actionUIId:int, eventSubcmd:String, itemSelectedIsAllowed:Boolean = false)
      {
         super(id,cursorId,actionUIId,eventSubcmd,itemSelectedIsAllowed,false);
      }
      
      override protected function onItemAssignedToCursor(item:WorldItemObject) : void
      {
         item.flip();
      }
   }
}
