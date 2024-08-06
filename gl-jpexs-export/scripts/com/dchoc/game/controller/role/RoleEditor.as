package com.dchoc.game.controller.role
{
   import com.dchoc.game.model.world.item.WorldItemDef;
   
   public class RoleEditor extends Role
   {
       
      
      public function RoleEditor()
      {
         super(4);
      }
      
      override public function toolSetTileIsAllowed(typeToolId:int, typeTileId:int) : Boolean
      {
         return true;
      }
      
      override protected function actionUIIsAllowedOnTile(actionId:int, typeTileId:int) : Boolean
      {
         return super.actionUIIsAllowedOnTile(actionId,typeTileId) || typeTileId == 2 || typeTileId == 1;
      }
      
      override public function moveMapIsAllowed() : Boolean
      {
         return true;
      }
      
      override public function isTutorialCompletedUpdateable() : Boolean
      {
         return false;
      }
      
      override public function toolPlaceIsAllowedToKeepUsing(def:WorldItemDef) : Boolean
      {
         return true;
      }
      
      override public function hasToBeChargedOnTransactions() : Boolean
      {
         if(Config.DEBUG_MODE == true)
         {
            return false;
         }
         return true;
      }
      
      override public function hasToShowMissions() : Boolean
      {
         return false;
      }
   }
}
