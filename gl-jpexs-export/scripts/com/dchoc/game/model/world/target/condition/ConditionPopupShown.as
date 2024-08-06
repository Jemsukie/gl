package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   
   public class ConditionPopupShown extends Condition
   {
       
      
      public function ConditionPopupShown()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var popupType:String = null;
         if(DCPopupMng.smIsPopupActive == false)
         {
            return false;
         }
         var returnValue:Boolean = false;
         var currPopupShown:DCIPopup;
         if((currPopupShown = InstanceMng.getPopupMng().getPopupBeingShown()) != null)
         {
            popupType = target.getDef().getHideArrowConditionParameter();
            if(popupType == null)
            {
               popupType = target.getDef().getConditionParameterSku();
            }
            if(popupType == null)
            {
               returnValue = true;
            }
            else
            {
               popupType = InstanceMng.getUIFacade().getPopupFactory().translateLogicTypeToCurrentType(popupType);
               returnValue = currPopupShown.getPopupType() == popupType && InstanceMng.getPopupEffects().hasEffect(currPopupShown) == false;
            }
         }
         return returnValue;
      }
   }
}
