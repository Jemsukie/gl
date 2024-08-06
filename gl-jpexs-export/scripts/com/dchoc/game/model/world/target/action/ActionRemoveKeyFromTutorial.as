package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionRemoveKeyFromTutorial extends DCAction
   {
       
      
      public function ActionRemoveKeyFromTutorial()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var key:ItemObject = InstanceMng.getItemsMng().getItemObjectBySku("1000");
         InstanceMng.getItemsMng().removeItemFromInventory(key,false);
         return true;
      }
   }
}
