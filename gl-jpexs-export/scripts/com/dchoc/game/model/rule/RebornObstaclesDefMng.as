package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class RebornObstaclesDefMng extends DCDefMng
   {
       
      
      private const DEFAULT_OBSTACLES_AMOUNT_FOR_NEW_COLONIES:int = 120;
      
      public function RebornObstaclesDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new RebornObstaclesDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return true;
      }
      
      override protected function sortCompareFunction(a:DCDef, b:DCDef) : Number
      {
         var aReborn:RebornObstaclesDef = a as RebornObstaclesDef;
         var bReborn:RebornObstaclesDef = b as RebornObstaclesDef;
         var returnValue:Number = 0;
         if(aReborn.getTime() > bReborn.getTime())
         {
            returnValue = 1;
         }
         else if(aReborn.getTime() < bReborn.getTime())
         {
            returnValue = -1;
         }
         return returnValue;
      }
      
      public function getObstaclesCount(time:Number) : int
      {
         var i:int = 0;
         var rebornDefMin:RebornObstaclesDef = null;
         var rebornDefMax:RebornObstaclesDef = null;
         var rebornDefs:Vector.<DCDef>;
         var rebornCount:int = int((rebornDefs = getDefs()).length);
         var min:int = DCTimerUtil.msToMin(time);
         var returnValue:int = 0;
         if(time == 0)
         {
            return 120;
         }
         i = 1;
         while(i < rebornCount)
         {
            rebornDefMin = rebornDefs[i - 1] as RebornObstaclesDef;
            rebornDefMax = rebornDefs[i] as RebornObstaclesDef;
            if(min >= rebornDefMin.getTime() && min < rebornDefMax.getTime())
            {
               returnValue = rebornDefMin.getObstaclesCount();
               break;
            }
            i++;
         }
         if(i == rebornCount && returnValue == 0 && min >= rebornDefMax.getTime())
         {
            returnValue = rebornDefMax.getObstaclesCount();
         }
         return returnValue;
      }
   }
}
