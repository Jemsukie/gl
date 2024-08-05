package com.dchoc.game.model.waves
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class WaveSpawnDefMng extends DCDefMng
   {
       
      
      public function WaveSpawnDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new WaveSpawnDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
      
      public function getWaveSpawnDefsByGroupAndLevel(group:String, HQLevel:int) : Vector.<WaveSpawnDef>
      {
         var def:DCDef = null;
         var waveSpawnDef:WaveSpawnDef = null;
         var defs:Vector.<DCDef> = getDefs();
         var vecWaveSpawnDef:Vector.<WaveSpawnDef> = new Vector.<WaveSpawnDef>(0);
         for each(def in defs)
         {
            if((waveSpawnDef = def as WaveSpawnDef).belongsToGroup(group) && waveSpawnDef.isBetweenHQLevel(HQLevel))
            {
               vecWaveSpawnDef.push(waveSpawnDef);
            }
         }
         return vecWaveSpawnDef;
      }
      
      public function getCurrentWave(group:String, HQLevel:int, currentWaveIdx:int) : WaveSpawnDef
      {
         var def:DCDef = null;
         var i:int = 0;
         var waveSpawnDef:WaveSpawnDef = null;
         var defs:Vector.<DCDef> = getDefsInGroup(group);
         var wavesVec:Vector.<WaveSpawnDef> = new Vector.<WaveSpawnDef>(0);
         for each(def in defs)
         {
            if((waveSpawnDef = def as WaveSpawnDef).isBetweenHQLevel(HQLevel))
            {
               wavesVec.push(waveSpawnDef);
            }
         }
         i = 0;
         for each(waveSpawnDef in wavesVec)
         {
            if(i == currentWaveIdx)
            {
               return waveSpawnDef;
            }
            i++;
         }
         return null;
      }
      
      public function isLastWave(group:String, HQLevel:int, currentWaveIdx:int) : Boolean
      {
         var def:DCDef = null;
         var i:int = 0;
         var waveSpawnDef:WaveSpawnDef = null;
         var defs:Vector.<DCDef> = getDefsInGroup(group);
         var wavesVec:Vector.<WaveSpawnDef> = new Vector.<WaveSpawnDef>(0);
         for each(def in defs)
         {
            if((waveSpawnDef = def as WaveSpawnDef).isBetweenHQLevel(HQLevel))
            {
               wavesVec.push(waveSpawnDef);
            }
         }
         i = 0;
         for each(waveSpawnDef in wavesVec)
         {
            if(i == currentWaveIdx && i == wavesVec.length - 1)
            {
               return true;
            }
            i++;
         }
         return false;
      }
   }
}
