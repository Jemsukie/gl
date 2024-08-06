package com.dchoc.game.model.unit.defs
{
   public class CivilDef extends UnitDef
   {
       
      
      public function CivilDef()
      {
         super();
         setAnimAngleOffset(-1.5707963267948966);
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         setUnitTypeId(1);
      }
   }
}
