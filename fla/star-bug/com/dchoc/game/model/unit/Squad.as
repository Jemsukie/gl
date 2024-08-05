package com.dchoc.game.model.unit
{
   public class Squad
   {
       
      
      private var mUnits:Vector.<MyUnit>;
      
      private var mUnitCaptain:MyUnit;
      
      public function Squad()
      {
         super();
      }
      
      public function unload() : void
      {
         this.mUnits = null;
         this.mUnitCaptain = null;
      }
      
      public function getIsAlive() : Boolean
      {
         return this.mUnitCaptain != null && this.mUnitCaptain.getIsAlive();
      }
      
      public function joinUnits(units:Vector.<MyUnit>, shotPriorityTarget:String = null) : void
      {
         var u:MyUnit = null;
         if(units != null)
         {
            this.mUnits = units.concat();
            for each(u in this.mUnits)
            {
               if(this.mUnitCaptain == null)
               {
                  this.mUnitCaptain = u;
                  if(shotPriorityTarget != null && shotPriorityTarget != "")
                  {
                     this.mUnitCaptain.setShotPriorityTarget(shotPriorityTarget);
                  }
               }
               else
               {
                  u.setCaptain(this.mUnitCaptain);
               }
            }
         }
      }
      
      public function releaseUnits() : void
      {
         var u:MyUnit = null;
         for each(u in this.mUnits)
         {
            if(u != this.mUnitCaptain && u.getIsAlive())
            {
               u.setCaptain(null);
            }
         }
      }
      
      public function getUnits() : Vector.<MyUnit>
      {
         return this.mUnits;
      }
   }
}
