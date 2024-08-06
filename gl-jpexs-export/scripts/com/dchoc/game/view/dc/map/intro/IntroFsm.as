package com.dchoc.game.view.dc.map.intro
{
   public class IntroFsm
   {
       
      
      protected var mState:int;
      
      public function IntroFsm()
      {
         super();
      }
      
      public function setState(state:int) : void
      {
         this.exitState(this.mState);
         this.mState = state;
         this.enterState(this.mState);
      }
      
      protected function exitState(state:int) : void
      {
      }
      
      protected function enterState(state:int) : void
      {
      }
      
      public function logicUpdate(dt:int) : Boolean
      {
         return false;
      }
   }
}
