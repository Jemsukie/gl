package com.dchoc.game.model.unit.components
{
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import flash.geom.Vector3D;
   
   public class UnitComponent
   {
      
      private static const TIMER_UPDATE_MS:int = 0;
       
      
      protected var mUnit:MyUnit;
      
      private var mTimerUpdate:int;
      
      private var mCurrentTime:int;
      
      private var mIsBuilt:Boolean;
      
      public function UnitComponent(unit:MyUnit, timerUpdate:int = 0)
      {
         super();
         this.mUnit = unit;
         this.mTimerUpdate = timerUpdate;
         this.load();
      }
      
      protected function load() : void
      {
      }
      
      public function unload() : void
      {
      }
      
      public function build(def:UnitDef, u:MyUnit) : void
      {
         if(!this.isBuilt())
         {
            this.buildDo(def,u);
            this.mIsBuilt = true;
         }
      }
      
      protected function buildDo(def:UnitDef, u:MyUnit) : void
      {
         this.reset(u);
      }
      
      public function unbuild(u:MyUnit) : void
      {
         if(this.isBuilt())
         {
            this.unbuildDo(u);
            this.mIsBuilt = false;
         }
      }
      
      protected function unbuildDo(u:MyUnit) : void
      {
         this.reset(u);
      }
      
      public function isBuilt() : Boolean
      {
         return this.mIsBuilt;
      }
      
      public function reset(u:MyUnit) : void
      {
      }
      
      public function logicUpdate(dt:int, u:MyUnit) : void
      {
         if(this.mCurrentTime < 2147483647)
         {
            if(this.mTimerUpdate > 0)
            {
               this.mCurrentTime -= dt;
               if(this.mCurrentTime >= 0)
               {
                  return;
               }
               this.mCurrentTime += 0;
            }
            this.logicUpdateDo(dt,u);
         }
      }
      
      protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
      }
      
      public function notify(e:Object) : void
      {
      }
      
      public function addToScene() : void
      {
         this.mCurrentTime = 0;
      }
      
      public function removeFromScene() : void
      {
         this.mCurrentTime = 2147483647;
      }
      
      public function getHeading() : Vector3D
      {
         return null;
      }
   }
}
