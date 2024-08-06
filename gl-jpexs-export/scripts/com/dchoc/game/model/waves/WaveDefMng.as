package com.dchoc.game.model.waves
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class WaveDefMng extends DCDefMng
   {
       
      
      public function WaveDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new WaveDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
