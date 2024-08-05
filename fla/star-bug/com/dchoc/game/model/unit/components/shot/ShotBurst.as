package com.dchoc.game.model.unit.components.shot
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.defs.UnitDef;
   
   public class ShotBurst extends UnitComponentShot
   {
       
      
      private var mBullets:Vector.<Bullet>;
      
      private var mBulletCount:int;
      
      private var mTarget:MyUnit;
      
      private var mSku:String;
      
      public function ShotBurst(sku:String, waitForAnim:Boolean = false)
      {
         this.mSku = sku;
         super(waitForAnim);
      }
      
      override public function build(def:UnitDef, u:MyUnit) : void
      {
         this.mBullets = new Vector.<Bullet>(0);
         if(u.mDef.isABuilding())
         {
            mWaitForAnim = false;
         }
      }
      
      override public function unbuild(u:MyUnit) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mBullets.length; )
         {
            this.mBullets[i] = null;
            i++;
         }
         this.mBullets = null;
      }
      
      override protected function shootDo(u:MyUnit, target:MyUnit = null) : void
      {
         var bullet:Bullet = null;
         var collId:int = 0;
         var bulletDef:UnitDef = null;
         if(target != null && target.mIsAlive)
         {
            collId = this.mBulletCount % 2;
            bulletDef = InstanceMng.getUnitDefMng().getDefBySku(this.mSku) as UnitDef;
            if(this.mSku == "b_burst_001" || bulletDef != null && bulletDef.belongsToGroup("sniper"))
            {
               if(bulletDef == null)
               {
                  bulletDef = InstanceMng.getUnitDefMng().getDefBySku("b_sniper_001") as UnitDef;
               }
               bullet = new BulletSniper(u,target,collId,bulletDef);
               setWaitTimeToShot(u);
            }
            else if(bulletDef != null && bulletDef.belongsToGroup("freeze"))
            {
               bullet = new BulletFreeze(u,target,collId);
               setWaitTimeToShot(u);
            }
            else
            {
               bullet = new BulletSniper(u,target,collId,bulletDef);
            }
            this.mBullets.push(bullet);
            this.mBulletCount++;
         }
      }
      
      override public function logicUpdate(dt:int, u:MyUnit) : void
      {
         var length:int = 0;
         var i:int = 0;
         if(this.mBullets != null)
         {
            length = int(this.mBullets.length);
            for(i = 0; i < length; )
            {
               this.mBullets[i].logicUpdate(dt);
               if(!this.mBullets[i].mAlive)
               {
                  this.mBullets[i].unbuild();
                  this.mBullets[i] = null;
                  this.mBullets.splice(i,1);
                  i--;
                  length--;
               }
               i++;
            }
         }
      }
      
      override public function stopShot() : void
      {
         var length:int = 0;
         var i:int = 0;
         if(this.mBullets != null)
         {
            length = int(this.mBullets.length);
            for(i = 0; i < length; )
            {
               this.mBullets[i].unbuild();
               this.mBullets[i] = null;
               this.mBullets.splice(i,1);
               i--;
               length--;
               i++;
            }
         }
      }
   }
}
