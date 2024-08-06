package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionHaveItem extends Condition
   {
       
      
      public function ConditionHaveItem()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var itemObject:ItemObject = null;
         var currAmount:int = 0;
         var craftingGroup:Array = null;
         var collectionGroup:Array = null;
         var i:int = 0;
         if(target.State <= 1)
         {
            return false;
         }
         if(target.getProgress(index) >= target.getDef().getMiniTargetAmount(index))
         {
            super.check(target,index);
            return true;
         }
         var items:Vector.<ItemObject> = InstanceMng.getItemsMng().getInventoryItems();
         var neededAmount:int = target.getDef().getMiniTargetAmount(index);
         var storedInServerAmount:int = target.getProgress(index);
         if(items != null)
         {
            for each(itemObject in items)
            {
               if(itemObject.mDef.getSku() == target.getDef().getMiniTargetSku(index) && itemObject.quantity >= neededAmount)
               {
                  super.check(target,index);
                  currAmount = itemObject.quantity;
                  if(storedInServerAmount < currAmount)
                  {
                     target.updateProgress("possess",neededAmount,"","",1,true,[index]);
                  }
                  return true;
               }
            }
         }
         var craftingGroups:Vector.<Array> = InstanceMng.getItemsMng().getCraftingGroups();
         for each(craftingGroup in craftingGroups)
         {
            for(i = 1; i < craftingGroup.length; )
            {
               if((itemObject = craftingGroup[i]).mDef.getSku() == target.getDef().getMiniTargetSku(index) && itemObject.quantity >= neededAmount)
               {
                  super.check(target,index);
                  currAmount = itemObject.quantity;
                  if(storedInServerAmount < currAmount)
                  {
                     target.updateProgress("possess",neededAmount,"","",1,true,[index]);
                  }
                  return true;
               }
               i++;
            }
         }
         var collectionGroups:Vector.<Array> = InstanceMng.getItemsMng().getCollections();
         for each(collectionGroup in collectionGroups)
         {
            for(i = 1; i < collectionGroup.length; )
            {
               if((itemObject = collectionGroup[i]).mDef.getSku() == target.getDef().getMiniTargetSku(index) && itemObject.quantity >= neededAmount)
               {
                  super.check(target,index);
                  currAmount = itemObject.quantity;
                  if(storedInServerAmount < currAmount)
                  {
                     target.updateProgress("possess",neededAmount,"","",1,true,[index]);
                  }
                  return true;
               }
               i++;
            }
         }
         return false;
      }
   }
}
