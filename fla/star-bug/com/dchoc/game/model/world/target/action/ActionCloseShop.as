package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionCloseShop extends DCAction
   {
       
      
      public function ActionCloseShop()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         InstanceMng.getGUIControllerPlanet().notify({"cmd":"NOTIFY_CLOSESHOP"});
         return true;
      }
   }
}
