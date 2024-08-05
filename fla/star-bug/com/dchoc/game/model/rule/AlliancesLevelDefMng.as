package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class AlliancesLevelDefMng extends DCDefMng
   {
       
      
      public function AlliancesLevelDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new AlliancesLevelDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var alliancesLevelDefObj:AlliancesLevelDef = null;
         var alliancesLevelDefObjAux:AlliancesLevelDef = null;
         var alliancesLevelDefVector:Vector.<DCDef> = getDefs();
         for(i = alliancesLevelDefVector.length - 1; i > 0; )
         {
            alliancesLevelDefObj = AlliancesLevelDef(alliancesLevelDefVector[i]);
            alliancesLevelDefObjAux = AlliancesLevelDef(alliancesLevelDefVector[i - 1]);
            alliancesLevelDefObj.setMinScore(alliancesLevelDefObjAux.getMaxScore());
            i--;
         }
      }
      
      public function getLevelFromScore(score:Number) : String
      {
         var levelDefObj:AlliancesLevelDef = null;
         for each(levelDefObj in getDefs())
         {
            if(score >= levelDefObj.getMinScore() && score < levelDefObj.getMaxScore())
            {
               return levelDefObj.getSku();
            }
         }
         return levelDefObj == null ? "1" : levelDefObj.getSku();
      }
      
      public function checkValidAttack(score1:Number, score2:Number) : Boolean
      {
         var level1Def:AlliancesLevelDef = getDefBySku(this.getLevelFromScore(score1)) as AlliancesLevelDef;
         var level2:int;
         return (level2 = parseInt(this.getLevelFromScore(score2))) >= level1Def.getMinLevelCanAttack();
      }
      
      public function getMaxScoreByScore(score:Number) : Number
      {
         var levelDefObj:AlliancesLevelDef = null;
         for each(levelDefObj in getDefs())
         {
            if(score >= levelDefObj.getMinScore() && score < levelDefObj.getMaxScore())
            {
               return levelDefObj.getMaxScore();
            }
         }
         return levelDefObj == null ? 1 : levelDefObj.getMaxScore();
      }
      
      public function getMaxBadgesFromScore(score:Number) : Number
      {
         var levelDefObj:AlliancesLevelDef = null;
         for each(levelDefObj in getDefs())
         {
            if(score >= levelDefObj.getMinScore() && score < levelDefObj.getMaxScore())
            {
               return levelDefObj.getMaxBadges();
            }
         }
         return 0;
      }
   }
}
