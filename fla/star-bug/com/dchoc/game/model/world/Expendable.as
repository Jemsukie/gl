package com.dchoc.game.model.world
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCBoxWithTiles;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class Expendable
   {
      
      private static const TIME_DEMOLISHING:int = 3000;
      
      private static const TIME_FADING_AWAY:int = 2000;
      
      private static const STATE_INIT:int = 0;
      
      private static const STATE_RUNNING:int = 1;
      
      private static const STATE_DEMOLISHING:int = 2;
      
      private static const STATE_FADING_AWAY:int = 3;
      
      private static const STATE_END:int = 4;
       
      
      private var mState:int;
      
      private var mSku:String;
      
      private var mWorldViewPosX:int;
      
      private var mWorldViewPosY:int;
      
      private var mTime:int;
      
      private var mDisplayObject:DCDisplayObject;
      
      private var mProgressBar:DCDisplayObject;
      
      private var mAddProgressBar:Boolean = false;
      
      private var mDisplayBoundingBox:DCBoxWithTiles;
      
      public function Expendable()
      {
         super();
      }
      
      public function build(sku:String, worldViewPosX:int, worldViewPosY:int) : void
      {
         this.mSku = sku;
         this.mWorldViewPosX = worldViewPosX;
         this.mWorldViewPosY = worldViewPosY;
         this.mDisplayObject = null;
         if(this.hasToApplyEffect())
         {
            this.applyEffect(true);
         }
         this.changeState(1);
      }
      
      public function unbuild() : void
      {
         this.removeDisplayObject();
         this.removeProgressBar();
         this.mDisplayBoundingBox = null;
         this.changeState(4);
         this.mSku = null;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var resourceMng:ResourceMng = null;
         var viewMngPlanet:ViewMngPlanet = null;
         var assetSku:String = null;
         var coor:DCCoordinate = null;
         var tileX:int = 0;
         var tileY:int = 0;
         var frameId:int = 0;
         if(this.mDisplayObject == null && this.mState != 4)
         {
            resourceMng = InstanceMng.getResourceMng();
            viewMngPlanet = InstanceMng.getViewMngPlanet();
            assetSku = this.getAssetSku();
            if(resourceMng.isResourceLoaded(assetSku))
            {
               this.mDisplayObject = resourceMng.getDCDisplayObject(assetSku,"");
               this.mDisplayObject.x = this.mWorldViewPosX - (this.mDisplayObject.getCurrentFrameWidth() >> 1);
               this.mDisplayObject.y = this.mWorldViewPosY - (this.mDisplayObject.getCurrentFrameHeight() >> 1);
               coor = MyUnit.smCoor;
               coor.x = this.mDisplayObject.x;
               coor.y = this.mDisplayObject.y;
               coor = InstanceMng.getViewMngPlanet().worldViewPosToTileXY(coor);
               tileX = coor.x;
               tileY = coor.y;
               this.mDisplayBoundingBox = new DCBoxWithTiles(this.mDisplayObject.x,this.mDisplayObject.y,this.mDisplayObject.getCurrentFrameWidth(),this.mDisplayObject.getCurrentFrameHeight(),coor.x,coor.y,this.getTilesWidth(),this.getTilesHeight());
               this.mDisplayObject.mBoundingBox = this.mDisplayBoundingBox;
               viewMngPlanet.addNukeCraterToStage(this.mDisplayObject);
            }
            else
            {
               resourceMng.requestResource(assetSku);
            }
         }
         if(this.mAddProgressBar)
         {
            if(this.mDisplayBoundingBox != null)
            {
               this.mProgressBar = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/_esparragon/gui/layouts/gui_old.swf","bar_clean_nuke");
               if(this.mProgressBar != null)
               {
                  this.mProgressBar.x = this.mWorldViewPosX;
                  this.mProgressBar.y = this.mWorldViewPosY;
                  if(this.mDisplayObject != null)
                  {
                     this.mProgressBar.y -= this.mDisplayObject.getCurrentFrameHeight() >> 1;
                  }
                  this.mProgressBar.mIsOnScreen = true;
                  this.mProgressBar.mBoundingBox = this.mDisplayBoundingBox;
                  InstanceMng.getViewMngPlanet().addNukeCraterProgressBarToStage(this.mProgressBar);
               }
               this.mAddProgressBar = false;
            }
         }
         switch(this.mState - 2)
         {
            case 0:
               this.mTime -= dt;
               if(this.mTime <= 0)
               {
                  this.changeState(3);
               }
               else if(this.mProgressBar != null)
               {
                  frameId = (3000 - this.mTime) * this.mProgressBar.totalFrames / 3000;
                  this.mProgressBar.gotoAndStop(frameId);
               }
               break;
            case 1:
               this.mTime -= dt;
               if(this.mTime <= 0)
               {
                  this.changeState(4);
                  break;
               }
               if(this.mDisplayObject != null)
               {
                  this.mDisplayObject.alpha = this.mTime / 2000;
               }
               break;
         }
      }
      
      public function getPersistenceString() : String
      {
         return this.mWorldViewPosX + ":" + this.mWorldViewPosY;
      }
      
      public function isOver() : Boolean
      {
         return this.mState == 4;
      }
      
      public function startDemolition() : void
      {
         this.changeState(2);
      }
      
      public function skipDemolition() : void
      {
         this.changeState(4);
      }
      
      private function changeState(newState:int) : void
      {
         switch(this.mState - 2)
         {
            case 0:
               this.removeProgressBar();
         }
         this.mState = newState;
         switch(this.mState - 2)
         {
            case 0:
               this.mTime = 3000;
               this.mAddProgressBar = true;
               break;
            case 1:
               this.mTime = 2000;
               break;
            case 2:
               this.removeDisplayObject();
               if(this.hasToApplyEffect())
               {
                  this.applyEffect(false);
                  break;
               }
         }
      }
      
      private function removeProgressBar() : void
      {
         if(this.mProgressBar != null)
         {
            InstanceMng.getViewMngPlanet().removeNukeCraterProgressBarFromStage(this.mProgressBar);
            this.mProgressBar = null;
         }
      }
      
      private function removeDisplayObject() : void
      {
         if(this.mDisplayObject != null)
         {
            InstanceMng.getViewMngPlanet().removeNukeCraterFromStage(this.mDisplayObject);
            this.mDisplayObject = null;
         }
      }
      
      private function applyEffect(enable:Boolean) : void
      {
         var coor:DCCoordinate = MyUnit.smCoor;
         coor.x = this.mWorldViewPosX;
         coor.y = this.mWorldViewPosY;
         coor = InstanceMng.getViewMngPlanet().worldViewPosToTileXY(coor);
         var tileX:int = coor.x;
         var tileY:int = coor.y;
         InstanceMng.getMapModel().tilesDataApplyFunc(tileX,tileY,this.getTilesWidth(),this.getTilesHeight(),true,this.applyEffectOnTile,enable);
      }
      
      private function applyEffectOnTile(tileData:TileData, args:Object) : void
      {
         var enable:Boolean = false;
         var base:WorldItemObject = null;
         var viewMng:ViewMngPlanet = null;
         var coor:DCCoordinate = null;
         var logicPosX:Number = NaN;
         var logicPosY:Number = NaN;
         var def:UnitDef = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var distance:Number = NaN;
         var sumRadius:Number = NaN;
         if(tileData != null && args != null)
         {
            enable = Boolean(args[0]);
            if((base = tileData.mBaseItem) != null && (!base.canBeBroken() || base.isCompletelyBroken()))
            {
               viewMng = InstanceMng.getViewMngPlanet();
               coor = MyUnit.smCoor;
               coor.x = this.mWorldViewPosX;
               coor.y = this.mWorldViewPosY;
               coor.z = 0;
               viewMng.viewPosToLogicPos(coor);
               logicPosX = coor.x;
               logicPosY = coor.y;
               coor.x = base.mViewCenterWorldX;
               coor.y = base.mViewCenterWorldY;
               coor.z = 0;
               viewMng.viewPosToLogicPos(coor);
               def = InstanceMng.getUnitScene().unitsGetDef("sa_nuke_01",3);
               dx = coor.x - logicPosX;
               dy = coor.y - logicPosY;
               distance = dx * dx + dy * dy;
               sumRadius = def.getBlastRadius() + base.mDef.getBoundingRadius();
               if(distance < sumRadius * sumRadius)
               {
                  base.itemOnTopSetIsEnabled(enable);
               }
            }
         }
      }
      
      private function getAssetSku() : String
      {
         return GameConstants.EXPENDABLES_ASSET_SKU[this.mSku];
      }
      
      private function getTilesWidth() : int
      {
         return GameConstants.EXPENDABLES_TILES_WIDTH[this.mSku];
      }
      
      private function getTilesHeight() : int
      {
         return GameConstants.EXPENDABLES_TILES_HEIGHT[this.mSku];
      }
      
      private function hasToApplyEffect() : Boolean
      {
         return GameConstants.EXPENDABLES_HAS_TO_APPLY_EFFECT[this.mSku];
      }
   }
}
