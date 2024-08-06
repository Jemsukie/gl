package com.dchoc.game.model.happening
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import esparragon.utils.EUtils;
   
   public class HappeningType
   {
      
      public static const STATE_NONE:int = -1;
      
      public static const STATE_COUNTDOWN:int = 0;
      
      public static const STATE_READY_TO_START:int = 1;
      
      public static const STATE_RUNNING:int = 2;
      
      public static const STATE_COMPLETED:int = 3;
      
      public static const STATE_FORCE_COMPLETED:int = 4;
       
      
      protected var mHappeningTypeDef:HappeningTypeDef;
      
      private var mHappening:Happening;
      
      protected var mState:int = -1;
      
      public function HappeningType()
      {
         super();
      }
      
      public function setHappeningTypeDef(value:HappeningTypeDef) : void
      {
         this.mHappeningTypeDef = value;
      }
      
      private function setHappening(value:Happening) : void
      {
         this.mHappening = value;
      }
      
      protected function getHappening() : Happening
      {
         return this.mHappening;
      }
      
      protected function getHappeningSku() : String
      {
         return this.mHappening != null ? this.mHappening.getHappeningDef().mSku : null;
      }
      
      public function getHappeningTypeDef() : HappeningTypeDef
      {
         return this.mHappeningTypeDef;
      }
      
      public function build(happening:Happening, xml:XML, changeState:Boolean = true) : void
      {
         this.setHappening(happening);
      }
      
      public function unbuild() : void
      {
         this.setHappeningTypeDef(null);
         this.setHappening(null);
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
      
      public function getState() : int
      {
         return this.mState;
      }
      
      public function stateChangeState(newState:int, notifyServer:Boolean) : void
      {
      }
      
      public function persistenceGetData() : XML
      {
         return EUtils.stringToXML("<Type/>");
      }
      
      public function addProgress(value:int) : void
      {
      }
      
      public function getCurrentProgress() : int
      {
         DCDebug.traceCh("ASSERT","This method must be implemented on the subclass");
         return 0;
      }
      
      public function getTarget() : int
      {
         DCDebug.traceCh("ASSERT","This method must be implemented on the subclass");
         return 0;
      }
      
      public function getCurrentWaveMaxEnemies() : int
      {
         return 0;
      }
      
      public function getCurrentWaveProgress() : int
      {
         return 0;
      }
      
      public function setShopOffers(value:Boolean) : void
      {
      }
   }
}
