package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.WarBarFacade;
   import com.dchoc.game.eview.facade.WarBarSpecialFacade;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockButtonsOnAttack extends DCAction
   {
       
      
      public function ActionLockButtonsOnAttack()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentName:String = null;
         var bool:* = false;
         var warbar:WarBarFacade = null;
         var warSpecial:WarBarSpecialFacade = null;
         if(isPreaction)
         {
            componentName = target.getDef().getPreactionTargetSid();
         }
         else
         {
            componentName = target.getDef().getPostactionTargetSid();
         }
         if(componentName != "")
         {
            bool = componentName == "true";
            (warbar = InstanceMng.getGUIControllerPlanet().getWarBar()).lockWarboxes(bool);
            (warSpecial = InstanceMng.getGUIControllerPlanet().getWarBarSpecial()).lockWarboxes(true);
            warSpecial.lock();
         }
         return true;
      }
   }
}
