package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class AlliancesSettingsDefMng extends DCDefMng
   {
       
      
      private var mAlliancesSettingsDef:AlliancesSettingsDef;
      
      public function AlliancesSettingsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mAlliancesSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.mAlliancesSettingsDef = AlliancesSettingsDef(getDefBySku("1"));
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new AlliancesSettingsDef();
      }
      
      public function getCreateAlliancePrice() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getCreateAlliancePrice() : 0;
      }
      
      public function getCreateAllianceCurrency() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getCreateAllianceCurrency() : 0;
      }
      
      public function getEditAlliancePrice() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getEditAlliancePrice() : 0;
      }
      
      public function getEditAllianceCurrency() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getEditAllianceCurrency() : 0;
      }
      
      public function getWarDuration() : Number
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getWarDuration() : 0;
      }
      
      public function getMaxAllianceMembers() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getMaxMembers() : 0;
      }
      
      public function getAllianceWelcomeId() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getWelcomeId() : 0;
      }
      
      public function getRemindJoinTime() : int
      {
         return this.mAlliancesSettingsDef != null ? int(this.mAlliancesSettingsDef.getRemindJoinTime()) : 0;
      }
      
      public function getRemindInvitationTime() : int
      {
         return this.mAlliancesSettingsDef != null ? int(this.mAlliancesSettingsDef.getRemindInvitationTime()) : 0;
      }
      
      public function getMinimumPlayerLevel() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getMinimumPlayerLevel() : 0;
      }
      
      public function getMinimumHQLevel() : int
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getMinimumHQLevel() : 0;
      }
      
      public function getAllianceLooserPostWarShield() : Number
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getLooserShieldTime() : 0;
      }
      
      public function getAllianceWinnerPostWarShield() : Number
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getWinnerShieldTime() : 0;
      }
      
      public function getRefreshInfoTime() : Number
      {
         return this.mAlliancesSettingsDef != null ? this.mAlliancesSettingsDef.getRefreshInfoTime() : 0;
      }
      
      public function calculateWarPointsFromScore(attackScore:Number, scoreMax:Number, attackerHQLevel:int, defenderHQLevel:int) : int
      {
         var maxPointsForHQ:Number = Number(WarPointsPerHQDef(InstanceMng.getWarPointsPerHQDefMng().getDefBySku(String(defenderHQLevel))).getPoints());
         var hqDifferenceFactor:int = Math.pow(defenderHQLevel - attackerHQLevel,this.mAlliancesSettingsDef.getHQFactorExponent());
         var rawPoints:Number;
         var returnValue:int = rawPoints = attackScore / scoreMax * maxPointsForHQ;
         if(defenderHQLevel > attackerHQLevel + 1)
         {
            returnValue = rawPoints * (this.mAlliancesSettingsDef.getWPBonusAdjustment() + hqDifferenceFactor * this.mAlliancesSettingsDef.getWPBonusFactor());
         }
         else if(attackerHQLevel > defenderHQLevel + 1)
         {
            returnValue = rawPoints * (this.mAlliancesSettingsDef.getWPPenaltyAdjustment() + hqDifferenceFactor * this.mAlliancesSettingsDef.getWPPenaltyFactor());
         }
         return int(Math.floor(returnValue));
      }
   }
}
