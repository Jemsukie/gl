package com.dchoc.game.controller.role
{
   public class RoleVisitor extends Role
   {
       
      
      public function RoleVisitor()
      {
         super(1);
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
         return 1;
      }
      
      override public function hudPlayerNameProfileIdAllowed() : int
      {
         return 1;
      }
      
      override public function hasToShowMissions() : Boolean
      {
         return false;
      }
   }
}
