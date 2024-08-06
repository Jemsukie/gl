package com.dchoc.game.controller.role
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RoleAttacking extends Role
   {
       
      
      public function RoleAttacking()
      {
         super(3);
      }
      
      override public function isDestroyToolAllowed() : Boolean
      {
         return false;
      }
      
      override public function isBuildToolAllowed() : Boolean
      {
         return false;
      }
      
      override public function isAttackingAllowed() : Boolean
      {
         return true;
      }
      
      override public function hasToShowMissions() : Boolean
      {
         return false;
      }
      
      override public function wioShowCupola(item:WorldItemObject) : Boolean
      {
         return !InstanceMng.getUnitScene().actualBattleIsRunning();
      }
   }
}
