package com.dchoc.toolkit.utils.popup
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import flash.utils.Dictionary;
   
   public class DCPopupEffects extends DCComponent
   {
       
      
      protected var mEffects:Dictionary;
      
      protected var mToBeRemoved:Vector.<DCIPopup>;
      
      public function DCPopupEffects()
      {
         super();
      }
      
      protected function register(popup:DCIPopup, effect:DCPopupEffect) : void
      {
         if(this.mEffects == null)
         {
            this.mEffects = new Dictionary();
         }
         var isFirst:Boolean = false;
         if(this.mEffects[popup] == null)
         {
            this.mEffects[popup] = new Vector.<DCPopupEffect>(0);
            isFirst = true;
         }
         (this.mEffects[popup] as Vector.<DCPopupEffect>).push(effect);
         effect.setPopup(popup);
         if(isFirst)
         {
            effect.initialize();
         }
      }
      
      private function markToBeRemoved(popup:DCIPopup) : void
      {
         if(this.mToBeRemoved == null)
         {
            this.mToBeRemoved = new Vector.<DCIPopup>(0);
         }
         if(this.mToBeRemoved.indexOf(popup) == -1)
         {
            this.mToBeRemoved.push(popup);
         }
      }
      
      private function removeMarked() : void
      {
         var popup:DCIPopup = null;
         if((this.mToBeRemoved != null && this.mToBeRemoved.length > 0) == false)
         {
            return;
         }
         for each(popup in this.mToBeRemoved)
         {
            if(this.mEffects[popup] != null)
            {
               this.popupRemoved(popup);
               this.mEffects[popup] = null;
               delete this.mEffects[popup];
            }
         }
         this.mToBeRemoved.length = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var key:* = null;
         var popup:DCIPopup = null;
         var effects:Vector.<DCPopupEffect> = null;
         var effect:DCPopupEffect = null;
         if(this.mEffects == null)
         {
            return;
         }
         for(key in this.mEffects)
         {
            popup = key as DCIPopup;
            if(popup.isPopupBeingShown() == false)
            {
               this.markToBeRemoved(popup);
            }
            else
            {
               effects = this.mEffects[popup];
               if((effects != null && effects.length > 0) == false)
               {
                  this.markToBeRemoved(popup);
               }
               else
               {
                  (effect = effects[0]).logicUpdate(dt);
                  if(effect.hasEnded())
                  {
                     effects.shift();
                     if(effects.length > 0)
                     {
                        effects[0].initialize();
                     }
                  }
               }
            }
         }
         this.removeMarked();
      }
      
      protected function popupRemoved(popup:DCIPopup) : void
      {
      }
      
      public function contains(popup:DCIPopup) : Boolean
      {
         return this.mEffects[popup] != null;
      }
   }
}
