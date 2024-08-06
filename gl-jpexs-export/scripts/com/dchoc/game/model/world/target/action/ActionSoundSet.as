package com.dchoc.game.model.world.target.action
{
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionSoundSet extends DCAction
   {
      
      private static const MUSIC_BATTLE:String = "BattleMusic";
      
      private static const MUSIC_HOME:String = "HomeMusic";
       
      
      public function ActionSoundSet()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var soundType:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSku();
         var soundName:String = null;
         var volume:int = 1;
         var startTime:int = 0;
         var loop:int = -1;
         if(soundType == "BattleMusic")
         {
            soundName = "music_battle.mp3";
         }
         else if(soundType == "HomeMusic")
         {
            soundName = "music_main.mp3";
         }
         if(soundName != null)
         {
            SoundManager.getInstance().stopAll(true);
            SoundManager.getInstance().playSound(soundName,volume,startTime,loop,0);
         }
         return true;
      }
   }
}
