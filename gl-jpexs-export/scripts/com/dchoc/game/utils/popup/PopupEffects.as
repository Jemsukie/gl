package com.dchoc.game.utils.popup
{
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.utils.popup.DCPopupEffect;
   import com.dchoc.toolkit.utils.popup.DCPopupEffects;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.motion.GTween;
   import flash.display.DisplayObjectContainer;
   
   public class PopupEffects extends DCPopupEffects
   {
      
      public static const NOTIFY_EFFECT_END:String = "NOTIFY_EFFECT_END";
      
      private static const NOTIFY_END_OBJECT:Object = {"cmd":"NOTIFY_EFFECT_END"};
       
      
      public function PopupEffects()
      {
         super();
      }
      
      override protected function popupRemoved(popup:DCIPopup) : void
      {
         popup.notify(NOTIFY_END_OBJECT);
      }
      
      public function hasEffect(popup:DCIPopup) : Boolean
      {
         return mEffects != null && mEffects[popup] != null;
      }
      
      public function removeEffects(popup:DCIPopup, instant:Boolean = false) : void
      {
         var amountEnded:int = 0;
         var effect:DCPopupEffect = null;
         if(mEffects != null)
         {
            amountEnded = 0;
            for each(effect in mEffects[popup])
            {
               effect.endEffect();
               amountEnded++;
            }
            if(instant && amountEnded > 0)
            {
               logicUpdateDo(0);
            }
         }
      }
      
      public function addEffectMoveFromPointToPoint(popup:DCIPopup, pointA:DCCoordinate, pointB:DCCoordinate, time:Number, hasToDisappear:Boolean, viewMngLayer:String, viewMngLayerPos:int = -1) : void
      {
         var effect:PopupEffectMoveFromPointToPoint = new PopupEffectMoveFromPointToPoint(pointA,pointB,time,hasToDisappear,viewMngLayer,viewMngLayerPos);
         register(popup,effect);
      }
      
      public function addEffectFading(popup:DCIPopup, fadeout:Boolean, time:Number, hasToDisappear:Boolean, layerName:String) : void
      {
         var effect:PopupEffectMoveFading = new PopupEffectMoveFading(fadeout,time,hasToDisappear,layerName);
         register(popup,effect);
      }
      
      public function addTween(type:int, mode:int, popup:DCIPopup, callback:Function = null) : GTween
      {
         var effect:PopupEffectTween = null;
         var form:DisplayObjectContainer = popup.getForm();
         switch(type)
         {
            case 0:
               effect = new PopupEffectTween(TweenEffectsFactory.createZoom(mode,form),callback);
               break;
            case 1:
               effect = new PopupEffectTween(TweenEffectsFactory.createAccordionVertical(mode,form),callback);
               break;
            case 2:
               effect = new PopupEffectTween(TweenEffectsFactory.createAccordionHorizontal(mode,form),callback);
               break;
            case 3:
               effect = new PopupEffectTween(TweenEffectsFactory.createTranslationLeft(mode,form),callback);
               break;
            case 4:
               effect = new PopupEffectTween(TweenEffectsFactory.createTranslationRight(mode,form),callback);
         }
         if(effect != null)
         {
            register(popup,effect);
            return effect.getTween();
         }
         return null;
      }
   }
}
