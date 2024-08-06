package com.dchoc.toolkit.utils.popup
{
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class DCPopupEffect
   {
       
      
      private var mHasEnded:Boolean;
      
      protected var mPopup:DCIPopup;
      
      public function DCPopupEffect()
      {
         super();
      }
      
      public function setPopup(popup:DCIPopup) : void
      {
         this.mPopup = popup;
      }
      
      public function initialize() : void
      {
      }
      
      public function endEffect() : void
      {
      }
      
      protected function securityChecks() : Boolean
      {
         if(this.mPopup == null)
         {
            return false;
         }
         return !this.hasEnded();
      }
      
      public function hasEnded() : Boolean
      {
         return this.mHasEnded;
      }
      
      protected function setHasEnded(value:Boolean) : void
      {
         this.mHasEnded = value;
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
   }
}
