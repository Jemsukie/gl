package com.dchoc.game.model.unit
{
   import flash.geom.Vector3D;
   
   public class WarpGateMng
   {
       
      
      private const RADIUS_COLLISION:Number = 50;
      
      private const MAX_GATES:int = 20;
      
      private const WARPGATE_TIMER:int = 500;
      
      private var mWarpGates:Vector.<WarpGate>;
      
      private var mWarpGatesToClose:Vector.<int>;
      
      private var mWarpGatesTimer:Vector.<int>;
      
      private var mPos1:Vector3D;
      
      private var mPos2:Vector3D;
      
      private var mSubtract:Vector3D;
      
      public function WarpGateMng()
      {
         var i:int = 0;
         super();
         this.mWarpGates = new Vector.<WarpGate>(20,true);
         this.mWarpGatesToClose = new Vector.<int>(20,true);
         this.mWarpGatesTimer = new Vector.<int>(20,true);
         this.mPos1 = new Vector3D();
         this.mPos2 = new Vector3D();
         this.mSubtract = new Vector3D();
         for(i = 0; i < 20; )
         {
            this.mWarpGatesTimer[i] = 0;
            this.mWarpGatesToClose[i] = 0;
            i++;
         }
      }
      
      public function unBuild() : void
      {
         var i:int = 0;
         var length:int = int(this.mWarpGates.length);
         for(i = 0; i < length; )
         {
            if(this.mWarpGates[i] != null)
            {
               this.mWarpGates[i].unbuild();
               this.mWarpGates[i] = null;
            }
            i++;
         }
         this.mWarpGates = null;
         this.mWarpGatesToClose = null;
      }
      
      public function openWarpGate(x:Number, y:Number) : int
      {
         var i:int = 0;
         var gate:WarpGate = null;
         for(i = 0; i < 20; )
         {
            if((gate = this.mWarpGates[i]) != null && gate.mState >= 0 && gate.mState <= 2 && this.checkColl(x,y,gate))
            {
               this.mWarpGatesToClose[i]++;
               this.mWarpGatesTimer[i] += 100;
               return i;
            }
            i++;
         }
         for(i = 0; i < 20; )
         {
            if((gate = this.mWarpGates[i]) == null)
            {
               (gate = new WarpGate()).open(x,y);
               this.mWarpGates[i] = gate;
               this.mWarpGatesToClose[i] = 1;
               this.mWarpGatesTimer[i] += 500;
               return i;
            }
            i++;
         }
         return -1;
      }
      
      public function closeWarpGate(index:int) : void
      {
         var gate:WarpGate = null;
         if(index >= 0 && this.mWarpGatesToClose[index] > 0)
         {
            this.mWarpGatesToClose[index]--;
            if(this.mWarpGatesToClose[index] == 0)
            {
               gate = this.mWarpGates[index];
               gate.changeState(3);
            }
         }
      }
      
      private function checkColl(x:Number, y:Number, gate:WarpGate) : Boolean
      {
         this.mPos1.x = x;
         this.mPos1.y = y;
         this.mPos2.x = gate.mX;
         this.mPos2.y = gate.mY;
         this.mSubtract = this.mPos2.subtract(this.mPos1);
         return this.mSubtract.length < 50;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         var gate:WarpGate = null;
         for(i = 0; i < 20; )
         {
            gate = this.mWarpGates[i];
            if(gate != null)
            {
               gate.logicUpdate();
               if(gate.mState == 2)
               {
                  this.mWarpGatesTimer[i] -= dt;
                  if(this.mWarpGatesTimer[i] <= 0)
                  {
                     this.mWarpGatesTimer[i] = 0;
                     gate.changeState(3);
                  }
               }
               if(gate.mState == 0)
               {
                  gate = null;
                  this.mWarpGates[i] = null;
               }
            }
            i++;
         }
      }
      
      public function getWarpGateState(index:int) : int
      {
         if(index < 0 || this.mWarpGates[index] == null)
         {
            return 0;
         }
         return this.mWarpGates[index].mState;
      }
   }
}
