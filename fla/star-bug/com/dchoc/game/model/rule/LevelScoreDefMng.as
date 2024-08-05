package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class LevelScoreDefMng extends DCDefMng
   {
       
      
      public function LevelScoreDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new LevelScoreDef();
      }
      
      override protected function buildDefs() : void
      {
         var i:int = 0;
         var levelDefObj:LevelScoreDef = null;
         var levelDefObjAux:LevelScoreDef = null;
         for(var levelDefVector:Vector.<DCDef>,i = (levelDefVector = getDefs()).length - 1; i > 0; )
         {
            levelDefObj = LevelScoreDef(levelDefVector[i]);
            levelDefObjAux = LevelScoreDef(levelDefVector[i - 1]);
            levelDefObj.setMinXp(levelDefObjAux.getMaxXp());
            i--;
         }
      }
      
      public function getLevelFromValue(value:Number) : String
      {
         var levelDefObj:LevelScoreDef = null;
         for each(levelDefObj in getDefs())
         {
            if(levelDefObj.getMinXp() <= value && value < levelDefObj.getMaxXp())
            {
               return levelDefObj.getSku();
            }
         }
         return levelDefObj == null ? "1" : levelDefObj.getSku();
      }
      
      public function checkValidAttack(score1:Number, score2:Number) : Boolean
      {
         var level1Def:LevelScoreDef = getDefBySku(this.getLevelFromValue(score1)) as LevelScoreDef;
         var level2:int;
         return (level2 = parseInt(this.getLevelFromValue(score2))) >= level1Def.getMinLevelCanAttack();
      }
      
      public function checkValidAttackWithLevel(level1:Number, level2:Number) : Boolean
      {
         var level1Def:LevelScoreDef = getDefBySku(level1.toString()) as LevelScoreDef;
         return level2 >= level1Def.getMinLevelCanAttack();
      }
      
      public function guiOpenLevelUpPopup(e:Object) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getLevelUpPopup(e);
         uiFacade.enqueuePopup(popup,true,true,false,true);
         return popup;
      }
   }
}
