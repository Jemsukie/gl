package com.dchoc.game.controller.role
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RoleSpy extends Role
   {
       
      
      public function RoleSpy()
      {
         super(2);
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
         return false;
      }
      
      override public function hudWorldNameProfileIdAllowed() : int
      {
         return 2;
      }
      
      override public function hudPlayerNameProfileIdAllowed() : int
      {
         return 2;
      }
      
      override public function hasToShowMissions() : Boolean
      {
         return false;
      }
      
      override public function wioShowCupola(item:WorldItemObject) : Boolean
      {
         return item.spyGetIsSpiable();
      }
   }
}
