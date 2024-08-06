package com.dchoc.game.model.items
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.utils.def.DCDef;
   
   public class AlliancesRewardDefMng extends RewardsDefMng
   {
       
      
      public function AlliancesRewardDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new AlliancesRewardDef();
      }
      
      public function isPlayerEligibleForReward(sku:String) : Boolean
      {
         var userAlliance:AlliancesUser = null;
         var currentWarPoints:int = 0;
         var allianceRewardDef:AlliancesRewardDef = null;
         var warPointsRequired:int = 0;
         var battlesWonRequired:int = 0;
         var conditionsSetInReward:Boolean = false;
         var returnValue:Boolean = false;
         var alliance:Alliance = InstanceMng.getAlliancesController().getMyAlliance();
         var currentBattlesWon:int = -1;
         if(alliance != null)
         {
            currentBattlesWon = alliance.getWarsWon();
            userAlliance = InstanceMng.getAlliancesController().getMyUser();
            currentWarPoints = -1;
            if(userAlliance != null)
            {
               currentWarPoints = userAlliance.getScore();
            }
            if((allianceRewardDef = AlliancesRewardDef(getDefBySku(sku))) != null)
            {
               warPointsRequired = allianceRewardDef.getConditionAmountBySku("warPoints");
               battlesWonRequired = allianceRewardDef.getConditionAmountBySku("alliancesBattlesWon");
               returnValue = (conditionsSetInReward = warPointsRequired != -1 && battlesWonRequired != -1) && (currentWarPoints >= warPointsRequired && currentBattlesWon >= battlesWonRequired);
            }
         }
         return returnValue;
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
