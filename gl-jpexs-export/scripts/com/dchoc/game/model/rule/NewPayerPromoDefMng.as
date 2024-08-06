package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class NewPayerPromoDefMng extends DCDefMng
   {
       
      
      private var mCurrNewPayerPromoDef:NewPayerPromoDef = null;
      
      public function NewPayerPromoDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new NewPayerPromoDef();
      }
      
      public function checkOfferForUpgradeHQ(newLevel:int) : Boolean
      {
         var def:DCDef = null;
         var newPayerPromoDef:NewPayerPromoDef = null;
         var defs:Vector.<DCDef> = getDefs();
         for each(def in defs)
         {
            if((newPayerPromoDef = def as NewPayerPromoDef).getAction() == "upgrade" && newPayerPromoDef.getTarget() == "wonders_headquarters" && newPayerPromoDef.getLevel() == newLevel)
            {
               this.mCurrNewPayerPromoDef = newPayerPromoDef;
               return true;
            }
         }
         return false;
      }
      
      public function areThereMissingItems(WIODef:WorldItemDef) : int
      {
         var i:int = 0;
         var reward:String = null;
         var rewardSku:String = null;
         var j:int = 0;
         if(this.mCurrNewPayerPromoDef == null)
         {
            return -1;
         }
         i = 0;
         while(i < this.mCurrNewPayerPromoDef.getRewardsVector().length)
         {
            reward = this.mCurrNewPayerPromoDef.getRewardsVector()[i];
            if(((rewardSku = String(reward.split(":")[0])) == "coins" || rewardSku == "5007") && InstanceMng.getUserInfoMng().getProfileLogin().getCoins() < WIODef.getConstructionCoins())
            {
               return i;
            }
            j = 0;
            while(j < WIODef.getUpgradeItemsNeeded().length)
            {
               if(rewardSku == WIODef.getUpgradeItemsNeededSku(j) && InstanceMng.getItemsMng().getItemObjectBySku(rewardSku).quantity < WIODef.getUpgradeItemsNeededAmount(j))
               {
                  return i;
               }
               j++;
            }
            i++;
         }
         return -1;
      }
      
      public function getCurrPromoDef() : NewPayerPromoDef
      {
         return this.mCurrNewPayerPromoDef;
      }
      
      public function resetCurrPromoDef() : void
      {
         this.mCurrNewPayerPromoDef = null;
      }
   }
}
