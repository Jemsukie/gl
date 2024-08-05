package com.dchoc.game.model.unit.effects
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.DCUtils;
   
   public class Burn extends UnitEffect
   {
      
      private static const TIME_BETWEEN_TICKS:int = 500;
      
      private static const SINGLE_FLAME_DURATION:int = 4000;
      
      private static const TEMPERATURE_GAIN_ON_NEW_FLAME:Number = 1;
      
      private static const TEMPERATURE_DEGRADATION_PER_TICK:Number = 1;
       
      
      private var mMinTemperature:SecureInt;
      
      private var mMaxTemperature:SecureInt;
      
      private var mMaxDuration:SecureInt;
      
      private var mUnit:MyUnit;
      
      private var mAttacker:MyUnit;
      
      private var mAttackerInfo:Object;
      
      private var mTimeRemaining:SecureInt;
      
      private var mTimeSinceLastTick:SecureInt;
      
      private var mTemperature:SecureNumber;
      
      public function Burn(effectType:int, unitRef:MyUnit, attacker:MyUnit)
      {
         mMinTemperature = new SecureInt("Burn.mMinTemperature");
         mMaxTemperature = new SecureInt("Burn.mMaxTemperature");
         mMaxDuration = new SecureInt("Burn.mMaxDuration");
         mTimeRemaining = new SecureInt("Burn.mTimeRemaining");
         mTimeSinceLastTick = new SecureInt("Burn.mTimeSinceLastTick");
         mTemperature = new SecureNumber("Burn.mTemperature");
         super(effectType);
         this.mUnit = unitRef;
         this.mAttacker = attacker;
         this.mMinTemperature.value = this.mAttacker.mDef.shotEffectsGetBurnMinTemperature();
         this.mMaxTemperature.value = this.mAttacker.mDef.shotEffectsGetBurnMaxTemperature();
         this.mMaxDuration.value = this.mAttacker.mDef.shotEffectsGetBurnMaxDuration();
         this.mTimeRemaining.value = 4000;
         this.mTimeSinceLastTick.value = 0;
         this.mTemperature.value = this.mMinTemperature.value;
      }
      
      public function getColorFromTemperature(temp:Number = NaN) : uint
      {
         if(isNaN(temp))
         {
            temp = this.mTemperature.value;
         }
         temp = Math.max(temp,this.mMinTemperature.value);
         temp = Math.min(temp,this.mMaxTemperature.value);
         var greenStart:int = 150;
         var greenEnd:int = 0;
         var tempScale:Number = (temp - this.mMinTemperature.value) / (this.mMaxTemperature.value - this.mMinTemperature.value);
         var green:int = Math.max(0,greenStart + tempScale * (greenEnd - greenStart));
         return DCUtils.getUIntColorFromRGB(255,green,0);
      }
      
      public function applyNewFlame(extraParams:Object) : void
      {
         var attackerDef:UnitDef = null;
         var attacker:MyUnit = extraParams["attacker"];
         if(attacker != null)
         {
            attackerDef = attacker.mDef;
            if(attackerDef.shotEffectsGetBurnMaxTemperature() > this.mAttacker.mDef.shotEffectsGetBurnMaxTemperature())
            {
               this.mAttacker = attacker;
               this.mMinTemperature.value = attackerDef.shotEffectsGetBurnMinTemperature();
               this.mMaxTemperature.value = attackerDef.shotEffectsGetBurnMaxTemperature();
               this.mMaxDuration.value = attackerDef.shotEffectsGetBurnMaxDuration();
            }
         }
         if(this.mTemperature.value < this.mMaxTemperature.value)
         {
            this.mTimeRemaining.value = Math.min(this.mTimeRemaining.value + 500 + 1,this.mMaxDuration.value);
            this.mTemperature.value += 1;
         }
      }
      
      override public function isBuilt() : Boolean
      {
         return this.mIsBuilt;
      }
      
      override public function getEffectNeedsDisplayObject() : Boolean
      {
         return false;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var damage:int = 0;
         if(!this.isBuilt() || !InstanceMng.getUnitScene().actualBattleIsRunning())
         {
            return;
         }
         this.mTimeRemaining.value -= dt;
         this.mTimeSinceLastTick.value += dt;
         if(this.mTimeRemaining.value <= 0 || !this.mUnit.getIsAlive())
         {
            this.setNeedsToBeRemovedFromStage(true);
            return;
         }
         if(this.mTimeSinceLastTick.value >= 500)
         {
            this.mTimeSinceLastTick.value -= 500;
            this.mTemperature.value = Math.min(this.mTemperature.value,this.mMaxTemperature.value);
            if(this.mAttacker != null && this.mAttacker.getIsAlive())
            {
               this.mAttackerInfo = MyUnit.shotCreateUnitInfoObject(this.mAttacker);
            }
            this.mUnit.applyBurnFilter(this.getColorFromTemperature());
            damage = Math.floor(this.mTemperature.value);
            this.mUnit.shotHit(damage,this.mAttackerInfo,false,"death006");
            ParticleMng.launchParticle(10,-damage,this.mUnit.mData[35],1,0,0,false,true,getColorFromTemperature());
            this.mTemperature.value = Math.max(this.mTemperature.value - 1,this.mMinTemperature.value);
         }
      }
   }
}
