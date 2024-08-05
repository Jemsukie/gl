package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.toolkit.core.media.SoundManager;
   
   public class Capsule extends SpecialAttack
   {
       
      
      private var mUnits:Vector.<MyUnit>;
      
      public function Capsule(time:int, launchX:int, launchY:int, specialAttackDef:SpecialAttacksDef = null)
      {
         super("capsule",time,launchX,launchY,specialAttackDef,1);
      }
      
      override public function getUnits() : Vector.<MyUnit>
      {
         return this.mUnits;
      }
      
      override public function setUnits(value:Vector.<MyUnit>) : void
      {
         this.mUnits = value;
      }
      
      override protected function dropCraterGetExpendableSku() : String
      {
         return "capsule";
      }
      
      override protected function dropCheckIfCraterHasToBePlacedDo() : Boolean
      {
         var frame:int = 0;
         var returnValue:* = false;
         if(mDropAnim != null)
         {
            frame = InstanceMng.getResourceMng().labelsGetFrameByLabel(dropPostFallingGetResourceSku(),dropPostFallingGetClipSku(),"crater");
            returnValue = mDropAnim.currentFrame >= frame;
         }
         return returnValue;
      }
      
      override protected function dropAddCrater() : void
      {
         super.dropAddCrater();
         SoundManager.getInstance().playSound("capsule_opening.mp3");
      }
      
      override protected function onEnterStateSoundFX(state:int) : void
      {
         var soundMng:SoundManager = SoundManager.getInstance();
         switch(state - 101)
         {
            case 0:
               soundMng.playSound("nuke_falling.mp3");
               break;
            case 1:
               soundMng.stopSound("nuke_falling.mp3");
               soundMng.playSound("nuke_explosion.mp3");
         }
      }
      
      override protected function launchUnits() : Vector.<MyUnit>
      {
         var unitScene:UnitScene = InstanceMng.getUnitScene();
         unitScene.waveAddToScene(this.mUnits,0);
         return this.mUnits;
      }
   }
}
