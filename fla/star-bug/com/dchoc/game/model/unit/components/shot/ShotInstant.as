package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.core.media.SoundManager;
   
   public class ShotInstant extends UnitComponentShot
   {
       
      
      public function ShotInstant()
      {
         super();
      }
      
      override protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
         var def:UnitDef = null;
         var snd:String = null;
         if(target != null)
         {
            def = u.mDef;
            target.shotHit(u.mDef.getShotDamage(),MyUnit.shotCreateUnitInfoObject(u),true,def.getDeathType());
            if(!def.belongsToGroup("melee"))
            {
               if(def.getAmmoSku() == "b_loot_001" && target.mIsAlive)
               {
                  ParticleMng.addParticle(17,u.mPositionDrawX + u.getViewComponent().getCurrentRenderData().getCollBoxX(),u.mPositionDrawY + u.getViewComponent().getCurrentRenderData().getCollBoxY());
               }
               else
               {
                  if((snd = def.getSndShot()) == null)
                  {
                     snd = "laser.mp3";
                  }
                  SoundManager.getInstance().playSound(snd);
               }
            }
         }
      }
   }
}
