package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.ShopBarFacade;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionSetDefaultShop extends DCAction
   {
       
      
      public function ActionSetDefaultShop()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var shop:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         shop = ShopBarFacade.getTabIdFromNameId(shop);
         InstanceMng.getBuildingsShopController().setShopTab(shop);
         return true;
      }
   }
}
