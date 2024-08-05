package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class GoalSoldierDefending extends GoalTerrainUnit
   {
       
      
      private var mIsReturningToBunker:Boolean = false;
      
      private var mBunker:Bunker;
      
      public function GoalSoldierDefending(unit:MyUnit)
      {
         super(unit,true,100,"running");
      }
      
      public function setBunker(value:Bunker) : void
      {
         this.mBunker = value;
      }
      
      public function isReturningToBunker() : Boolean
      {
         return this.mIsReturningToBunker;
      }
      
      override protected function enterState(state:int) : void
      {
         var bunker:Bunker = null;
         var itemFrom:WorldItemObject = null;
         super.enterState(state);
         switch(state - 1)
         {
            case 0:
               if(this.mIsReturningToBunker)
               {
                  askPathToItem(this.mBunker.getWIO());
                  break;
               }
               if(mUnit.mData != null)
               {
                  bunker = mUnit.mData[34];
                  if(bunker != null)
                  {
                     itemFrom = bunker != null ? bunker.getWIO() : null;
                     askPathToUnit(MyUnit(mUnit.mData[13]),itemFrom);
                  }
               }
               break;
         }
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var target:MyUnit = null;
         super.logicUpdateDoDo(dt,u);
         var data:Array = u.mData;
         switch(mCurrentState)
         {
            case 0:
               if(this.mIsReturningToBunker)
               {
                  changeState(1);
               }
               else if((target = data[3] != null ? data[3] : data[1]) != null)
               {
                  data[13] = target;
                  changeState(1);
               }
               break;
            case 1:
               if(data[13] == data[1] && data[1] != data[3] && data[3] != null)
               {
                  data[13] = data[3];
                  break;
               }
         }
      }
      
      override protected function tasksPerform(id:int) : void
      {
         switch(id - 100)
         {
            case 0:
               if(this.mIsReturningToBunker)
               {
                  this.mBunker.battleUnitHasReturned(mUnit,true);
               }
               break;
            default:
               super.tasksPerform(id);
         }
      }
      
      override public function notify(e:Object) : void
      {
         switch(e.cmd)
         {
            case "unitEventDefendBunker":
               this.mIsReturningToBunker = false;
               mShotIsEnabled = true;
               break;
            case "unitEventReturnToBunker":
               this.mBunker = e.bunker;
               this.mIsReturningToBunker = true;
               mShotIsEnabled = false;
               changeState(0);
         }
      }
   }
}
