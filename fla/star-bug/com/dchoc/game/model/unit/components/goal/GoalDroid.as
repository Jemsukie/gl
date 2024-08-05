package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class GoalDroid extends UnitComponentGoal
   {
       
      
      private var mItemTarget:WorldItemObject;
      
      private var mItemFrom:WorldItemObject;
      
      private var mReverse:Boolean;
      
      private var mEventPathCompleted:String;
      
      public function GoalDroid(unit:MyUnit, itemTarget:WorldItemObject, itemFrom:WorldItemObject, reverse:Boolean = false, eventPathCompleted:String = "unitEventPathEnded")
      {
         super(unit);
         this.mItemTarget = itemTarget;
         this.mItemFrom = itemFrom;
         this.mReverse = reverse;
         this.mEventPathCompleted = eventPathCompleted;
      }
      
      override public function activate() : void
      {
         super.activate();
         InstanceMng.getTrafficMng().droidsSetSpeed(mUnit);
         this.sendToTarget();
      }
      
      private function sendToTarget() : void
      {
         var tileIndex:int = 0;
         var hq:WorldItemObject = null;
         var viewMng:ViewMngPlanet = null;
         var tiles:Vector.<DCAStarNode> = null;
         var tile:TileData = null;
         var coor:DCCoordinate = MyUnit.smCoor;
         if(this.mReverse)
         {
            if(!mUnit.mSecureIsInScene.value)
            {
               if((tileIndex = InstanceMng.getWorldItemDefMng().getTileIndexToGo(this.mItemTarget)) > -1)
               {
                  InstanceMng.getViewMngPlanet().tileIndexToWorldViewPos(tileIndex,coor);
                  mUnit.setPositionInViewSpace(coor.x,coor.y);
               }
               else if(this.mItemTarget != null)
               {
                  mUnit.setPositionInViewSpace(this.mItemTarget.mViewCenterWorldX,this.mItemTarget.mViewCenterWorldY);
               }
            }
            this.mItemFrom = InstanceMng.getMapModel().mAstarStartItem;
         }
         else if(!mUnit.mSecureIsInScene.value)
         {
            hq = InstanceMng.getMapModel().mAstarStartItem;
            if(this.mItemFrom != null)
            {
               mUnit.setPositionInViewSpace(this.mItemFrom.mViewCenterWorldX,this.mItemFrom.mViewCenterWorldY);
            }
            else
            {
               viewMng = InstanceMng.getViewMngPlanet();
               tiles = hq.mPathTiles;
               tileIndex = DCMath.randBetween(0,tiles.length);
               tile = TileData(tiles[tileIndex]);
               coor.x = tile.mCol;
               coor.y = tile.mRow;
               viewMng.tileXYToWorldViewPos(coor,true);
               mUnit.setPositionInViewSpace(coor.x,coor.y);
            }
         }
         var movement:UnitComponentMovement;
         if((movement = mUnit.getMovementComponent()) != null)
         {
            movement.goToItem(this.mItemTarget,this.mItemFrom,this.mReverse,this.mEventPathCompleted);
         }
      }
      
      override public function moveFollowPath(hasArrivedTask:int = 2) : void
      {
         super.moveFollowPath(hasArrivedTask);
         if(!mUnit.mSecureIsInScene.value)
         {
            mUnit.enterSceneStart();
            InstanceMng.getUnitScene().sceneAddUnit(mUnit);
         }
      }
      
      override public function goToItem(itemTo:WorldItemObject, itemFrom:WorldItemObject = null, changeState:Boolean = true) : void
      {
         this.mItemTarget = itemTo;
         if(this.mItemTarget == InstanceMng.getMapModel().mAstarStartItem)
         {
            mUnit.goalSetCurrentId("unitGoalReturnToHQ");
         }
      }
      
      public function getItemTo() : WorldItemObject
      {
         return this.mItemTarget;
      }
      
      public function isReverse() : Boolean
      {
         return this.mReverse;
      }
   }
}
