package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.media.SoundManager;
   import flash.display.MovieClip;
   
   public class Nuke extends SpecialAttack
   {
      
      private static const ASSET_NUKE:String = "nuke";
       
      
      private var mExplosionPlayed:SecureBoolean;
      
      public function Nuke(time:int, launchX:int, launchY:int, specialAttackDef:SpecialAttacksDef = null)
      {
         mExplosionPlayed = new SecureBoolean();
         super("nuke",time,launchX,launchY,specialAttackDef,1);
      }
      
      override protected function enterState(state:int) : void
      {
         switch(state - 102)
         {
            case 0:
               this.dropMeetingTheGround();
         }
         super.enterState(state);
      }
      
      override protected function dropCraterGetExpendableSku() : String
      {
         return "nuke";
      }
      
      protected function dropMeetingTheGround() : void
      {
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.fadeEnable(16777215,900);
      }
      
      override protected function onEnterStateSoundFX(state:int) : void
      {
         var exceptionsArr:Array = null;
         switch(state)
         {
            case 100:
               SoundManager.getInstance().fadeMusic(1,0,6);
               break;
            case 101:
               SoundManager.getInstance().playSound("nuke_falling.mp3",0.6);
               this.mExplosionPlayed.value = false;
               break;
            case 102:
               SoundManager.getInstance().playSound("nuke_mushroom.mp3",1);
               SoundManager.getInstance().playDelayedSound("nuke_beep.mp3",1,0,0,2000);
               exceptionsArr = ["nuke_explosion.mp3","nuke_mushroom.mp3","nuke_beep.mp3"];
               SoundManager.getInstance().setExceptionSounds(exceptionsArr);
               SoundManager.getInstance().fadeAllSFX(0,1,15);
               break;
            case 2:
               SoundManager.getInstance().fadeMusic(0,1,7);
               SoundManager.getInstance().setExceptionSounds(null);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var mc:MovieClip = null;
         var playExplosion:Boolean = false;
         super.logicUpdate(dt);
         if(mState.value == 101 && !this.mExplosionPlayed.value)
         {
            if(mDropAnim != null)
            {
               mc = mDropAnim.getDisplayObject() as MovieClip;
               playExplosion = mc != null && mc.currentFrame >= InstanceMng.getResourceMng().labelsGetFrameByLabel(dropFallingGetResourceSku(),dropFallingGetClipSku(),"sfx");
               if(playExplosion)
               {
                  this.mExplosionPlayed.value = true;
                  SoundManager.getInstance().playSound("nuke_explosion.mp3");
               }
            }
         }
      }
   }
}
