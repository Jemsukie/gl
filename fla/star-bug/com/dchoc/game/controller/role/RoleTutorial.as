package com.dchoc.game.controller.role
{
   public class RoleTutorial extends Role
   {
       
      
      public function RoleTutorial()
      {
         super(5);
      }
      
      override public function hasToShowMissions() : Boolean
      {
         return false;
      }
   }
}
