package com.dchoc.game.model.powerups
{
   public class PowerUp
   {
      
      public static const STATE_NONE:int = -1;
      
      public static const STATE_RUNNING:int = 1;
      
      public static const STATE_EXPIRED:int = 2;
       
      
      private var mState:int;
      
      private var mDef:PowerUpDef;
      
      private var mTimeOver:Number;
      
      private var mTimeLeftOrig:Number;
      
      public function PowerUp()
      {
         super();
      }
      
      public function build(powerUpDef:PowerUpDef, timeOver:Number, timeLeft:Number) : void
      {
         this.mDef = powerUpDef;
         this.mTimeOver = timeOver;
         this.mTimeLeftOrig = timeLeft;
         this.setState(-1);
      }
      
      public function unbuild() : void
      {
         this.mDef = null;
      }
      
      public function getDef() : PowerUpDef
      {
         return this.mDef;
      }
      
      public function getTimeOver() : Number
      {
         return this.mTimeOver;
      }
      
      public function getTimeLeftOrig() : Number
      {
         return this.mTimeLeftOrig;
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      private function setState(state:int) : void
      {
         this.mState = state;
      }
      
      public function logicUpdate(currentTime:Number, checkTime:Boolean) : int
      {
         var newState:int = this.mState;
         switch(this.mState - -1)
         {
            case 0:
               if(checkTime)
               {
                  newState = currentTime < this.mTimeOver ? 1 : 2;
               }
               else
               {
                  newState = 1;
               }
               break;
            case 2:
               if(checkTime && currentTime >= this.mTimeOver)
               {
                  newState = 2;
                  break;
               }
         }
         if(this.mState != newState)
         {
            this.setState(newState);
         }
         return this.mState;
      }
   }
}
