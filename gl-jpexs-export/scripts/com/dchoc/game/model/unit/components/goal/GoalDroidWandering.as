package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.astar.DCAStarNode;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class GoalDroidWandering extends UnitComponentGoal
   {
      
      private static const STATE_START:int = 0;
      
      private static const STATE_AVOID_COLLISION:int = 1;
      
      private static const MAX_DISTANCE:int = 10;
      
      private static const MIN_DISTANCE:int = 5;
       
      
      private var mPreviousState:int;
      
      private var mCoor:DCCoordinate;
      
      private var mHqPos:Vector3D;
      
      private var mDestinyViewPos:Vector3D;
      
      private var mOldTile:int;
      
      private var mTileIndex:int;
      
      public function GoalDroidWandering(unit:MyUnit, tileIndex:int)
      {
         super(unit);
         this.mDestinyViewPos = new Vector3D();
         this.mTileIndex = tileIndex;
      }
      
      override public function activate() : void
      {
         var viewMng:ViewMngPlanet = null;
         var tiles:Vector.<DCAStarNode> = null;
         var tile:TileData = null;
         super.activate();
         var mapModel:MapModel = InstanceMng.getMapModel();
         var headquarter:WorldItemObject;
         if((headquarter = mapModel.mAstarStartItem) == null)
         {
            mUnit.markToBeReleasedFromScene();
         }
         else
         {
            this.mHqPos = new Vector3D(headquarter.mViewCenterWorldX,headquarter.mViewCenterWorldY,0);
            InstanceMng.getTrafficMng().droidsSetSpeed(mUnit);
            mUnit.mCanBeATarget = false;
            if(!mUnit.mSecureIsInScene.value && headquarter != null)
            {
               viewMng = InstanceMng.getViewMngPlanet();
               tiles = headquarter.mPathTiles;
               tile = TileData(tiles[this.mTileIndex]);
               this.mCoor = MyUnit.smCoor;
               this.mCoor.x = tile.mCol;
               this.mCoor.y = tile.mRow;
               viewMng.tileXYToWorldViewPos(this.mCoor,true);
               mUnit.setPositionInViewSpace(this.mCoor.x,this.mCoor.y);
               mUnit.enterSceneStart(2);
               MyUnit.smUnitScene.sceneAddUnit(mUnit);
            }
            this.setNewDestiny();
         }
      }
      
      private function setNewDestiny() : void
      {
         this.getDestiny();
         var movement:UnitComponentMovement = mUnit.getMovementComponent();
         if(movement != null)
         {
            movement.goToWorldPosition(this.mDestinyViewPos,"unitEventPathEnded");
         }
      }
      
      private function getDestiny() : void
      {
         var newTile:int = 0;
         var distance:Number = NaN;
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         var newTilePos:Vector3D = new Vector3D();
         var maxDistance:int = 10 * InstanceMng.getMapViewPlanet().getTileViewHeight();
         var minDistance:int = 5 * InstanceMng.getMapViewPlanet().getTileViewHeight();
         var coor:DCCoordinate = MyUnit.smCoor;
         do
         {
            newTile = Math.random() * mapController.mTilesCount;
            InstanceMng.getViewMngPlanet().tileIndexToWorldViewPos(newTile,coor,true);
            newTilePos.x = coor.x;
            newTilePos.y = coor.y;
            distance = newTilePos.subtract(this.mHqPos).length;
         }
         while(distance < minDistance || distance > maxDistance || this.mOldTile == newTile);
         
         this.mDestinyViewPos.x = coor.x;
         this.mDestinyViewPos.y = coor.y;
         this.mOldTile = newTile;
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         if(mUnit.getMovementComponent().isStopped())
         {
            mUnit.getMovementComponent().resume();
            this.setNewDestiny();
         }
      }
   }
}
