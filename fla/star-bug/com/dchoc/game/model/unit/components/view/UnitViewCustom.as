package com.dchoc.game.model.unit.components.view
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.unit.BombTail;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.core.view.display.layer.DCLayer;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCBoxWithTiles;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   
   public class UnitViewCustom extends UnitComponentView
   {
      
      private static const SMOKE_TIME:int = 200;
      
      public static var smName:String = "";
      
      private static const SELECTED_SHAPE_WIDTH:int = 30;
      
      private static const SELECTED_SHAPE_HEIGHT:int = 15;
       
      
      public var mCustomRenderData:DCBitmapMovieClip;
      
      private var mEmotion:DCBitmapMovieClip;
      
      protected var mLastFrame:int;
      
      protected var mLastFrameTimer:int;
      
      private var mFrameSustain:int;
      
      private var mFrameDelay:int;
      
      protected var mPreviousRow:int;
      
      protected var mFrame:int;
      
      protected var mFrameInit:int;
      
      protected var mFrameEnd:int;
      
      protected var mForcedAnim:int;
      
      protected var mFrameCols:int;
      
      protected var mFrameCount:int;
      
      protected var mFrameRows:int;
      
      protected var mAngleCount:int;
      
      protected var mCurrentAnimation:Object;
      
      protected var mIsPlaying:Boolean;
      
      private var mLoop:Boolean;
      
      private var mHasMask:Boolean;
      
      protected var mTargetFrameInit:int;
      
      protected var mRotationDelay:int;
      
      protected var mFrameInitialized:Boolean;
      
      private var mLastEmoticon:int;
      
      private var mScale:Number;
      
      private var mFilters:Array;
      
      private var mShadow:DCBitmapMovieClip;
      
      private var mTail:BombTail;
      
      private var mSmokeTime:int;
      
      private var mHasSmoke:Boolean;
      
      private var mCollShootingId:int;
      
      private var mParticlesEnabled:Boolean;
      
      protected var mSelected:Boolean;
      
      protected var mSelectedDCClip:DCDisplayObject;
      
      public function UnitViewCustom(unit:MyUnit, headingComponentKey:int = -1, loop:Boolean = true)
      {
         super(unit,headingComponentKey);
         this.mLoop = loop;
         this.mScale = 1;
      }
      
      override public function unload() : void
      {
         this.mCustomRenderData = null;
         this.mEmotion = null;
      }
      
      private function getEnemyColor() : ColorMatrixFilter
      {
         return InstanceMng.getUnitScene().getEnemyColor(mUnit.mFaction);
      }
      
      private function getMyColor() : ColorMatrixFilter
      {
         return InstanceMng.getUnitScene().getMyColor();
      }
      
      override protected function buildDo(def:UnitDef, u:MyUnit) : void
      {
         var dispObj:DisplayObject = null;
         var anim:Object = null;
         var cmf:ColorMatrixFilter = null;
         mUnit = u;
         if(this.mCurrentAnimation == null)
         {
            this.mCurrentAnimation = def.getAnimation();
         }
         if(this.mCustomRenderData == null)
         {
            anim = def.getAnimation(def.getDefaultAnimationId());
            this.setRenderData(def.getAssetId() + smName,anim.className);
         }
         if(this.mCustomRenderData == null)
         {
            return;
         }
         if(this.mCustomRenderData != null && def.needsToBeSorted())
         {
            if(def.isABuilding())
            {
               this.mCustomRenderData.mBoundingBox = WorldItemObject(mUnit.mData[35]).mBoundingBox;
               if(mUnit.getWorldItemObject() != null)
               {
                  dispObj = this.mCustomRenderData.getDisplayObject();
                  if(dispObj != null)
                  {
                     dispObj.alpha = mUnit.getWorldItemObject().isFlatBed() ? 0 : 1;
                  }
               }
            }
            else
            {
               this.mCustomRenderData.mBoundingBox = new DCBoxWithTiles(0,0,22,22,0,0,1,1);
            }
         }
         if(mCurrentAnimationId != null)
         {
            this.setAnimationId(mCurrentAnimationId,this.mForcedAnim,this.mIsPlaying,true);
         }
         else
         {
            this.setAnimationId(def.getAnimationDef().mDefaultAnim);
            this.mForcedAnim = -1;
            this.mIsPlaying = true;
         }
         this.mFrameSustain = 25;
         super.buildDo(def,u);
         this.mFilters = [];
         if(!this.mHasMask && !def.belongsToGroup("noBreedColor"))
         {
            if(GameConstants.unitUseInversedRenderMode(mUnit.mFaction))
            {
               cmf = this.getEnemyColor();
            }
            else if(InstanceMng.getFlowState().getCurrentRoleId() == 0)
            {
               cmf = this.getMyColor();
            }
            if(cmf && u.mDef.getAnimationDefSku() != "sa_rocket" && u.mDef.getAnimationDefSku() != "sa_freeze")
            {
               this.mFilters.push(cmf);
            }
         }
         if(!mUnit.mDef.isAnUmbrellaShip())
         {
            if(!mUnit.mDef.isTerrainUnit() || u.mDef.mSku == "b_rock_001" || mUnit.mDef.belongsToGroup("floating"))
            {
               this.mShadow = InstanceMng.getEResourcesMng().getDCDisplayObject("units_effects","legacy","shadow",3) as DCBitmapMovieClip;
            }
         }
         this.mCustomRenderData.filters = this.mFilters;
      }
      
      override public function isBuilt() : Boolean
      {
         var returnValue:* = this.mCustomRenderData != null;
         if(returnValue && mUnit.mDef.needsToBeSorted())
         {
            returnValue = this.mCustomRenderData.mBoundingBox != null;
         }
         return returnValue;
      }
      
      override public function reset(u:MyUnit) : void
      {
         var defaultAlpha:Number = NaN;
         super.reset(u);
         this.mLastFrame = -1;
         this.mLastFrameTimer = 500;
         this.mFrameDelay = 40;
         this.mPreviousRow = -1;
         this.mFrame = 0;
         this.mLastFrame = 0;
         if(this.mCustomRenderData != null)
         {
            defaultAlpha = 1;
            if(mUnit.mDef.isABuilding() && mUnit.getWorldItemObject() != null && mUnit.getWorldItemObject().isFlatBed())
            {
               defaultAlpha = 0;
            }
            this.mCustomRenderData.alpha = defaultAlpha;
         }
      }
      
      override public function getCurrentRenderData() : DCBitmapMovieClip
      {
         return this.mCustomRenderData;
      }
      
      public function getCurrentFrame() : int
      {
         return this.mFrame;
      }
      
      public function getTotalFrames() : int
      {
         return this.mFrameEnd + 1;
      }
      
      override protected function render(dt:int, heading:Vector3D) : void
      {
         var angle:Number = NaN;
         if(heading == null || this.mCustomRenderData == null)
         {
            return;
         }
         angle = Math.atan2(heading.x,heading.y) + mUnit.mDef.getAnimAngleOffset();
         if(mUnit.mDef.isAnimated(mCurrentAnimationId))
         {
            this.renderAnimated(angle,dt);
         }
         else
         {
            this.renderNoAnimated(angle);
         }
         if(this.mRotationDelay >= 0)
         {
            this.mRotationDelay -= dt;
         }
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         super.logicUpdateDo(dt,u);
         this.mSmokeTime -= dt;
      }
      
      private function renderNoAnimated(angle:Number) : void
      {
         var def:UnitDef = mUnit.mDef;
         var incFrame:int = 360 / this.mAngleCount;
         var degrees:Number = this.radToDegrees(angle);
         this.mFrame = degrees / incFrame;
         this.mLastFrameTimer += 20;
         if(this.mFrame >= 0 && this.mFrame < this.mFrameCount)
         {
            if(this.mLastFrameTimer > 100 || Math.abs(this.mLastFrame - this.mFrame) > 1)
            {
               this.mCustomRenderData.gotoAndStop(this.mFrame + 1);
               if(this.mLastFrame != this.mFrame)
               {
                  this.mLastFrame = this.mFrame;
                  this.mLastFrameTimer = 0;
               }
            }
         }
         if(Config.DEBUG_MODE)
         {
            this.checkSort(def);
         }
         else
         {
            this.setViewPosition();
         }
      }
      
      private function radToDegrees(angle:Number) : Number
      {
         var degrees:Number = Math.round(180 * angle / 3.141592653589793);
         if(degrees < 0)
         {
            degrees += 360;
         }
         degrees += Math.round(360 / (this.mAngleCount << 1));
         return degrees % 360;
      }
      
      protected function renderAnimated(angle:Number, dt:int) : void
      {
         var def:UnitDef = null;
         var finalFrame:int = 0;
         var degrees:Number = NaN;
         var incFrame:int = 0;
         var row:int = 0;
         if(this.mIsPlaying)
         {
            def = mUnit.mDef;
            if(this.mForcedAnim == -1)
            {
               degrees = this.radToDegrees(angle);
               incFrame = 360 / this.mFrameRows;
               if((row = degrees / incFrame) < 0)
               {
                  row += this.mFrameRows;
               }
               this.mTargetFrameInit = row * this.mFrameCols;
               if((this.mPreviousRow != row || this.mTargetFrameInit != this.mFrameInit) && this.mRotationDelay < 0 || !this.mFrameInitialized)
               {
                  this.mTargetFrameInit = row * this.mFrameCols;
                  if(Math.abs(this.mFrameInit - this.mTargetFrameInit) < 2 || !this.mFrameInitialized)
                  {
                     this.mFrameInit = this.mTargetFrameInit;
                     this.mFrameInitialized = true;
                  }
                  else if(this.mTargetFrameInit - this.mFrameInit >= this.mFrameRows * this.mFrameCols / 2)
                  {
                     this.mFrameInit -= this.mFrameCols;
                     if(this.mFrameInit < 0)
                     {
                        this.mFrameInit = (this.mFrameRows - 1) * this.mFrameCols;
                     }
                  }
                  else if(this.mFrameInit - this.mTargetFrameInit >= this.mFrameRows * this.mFrameCols / 2)
                  {
                     this.mFrameInit += this.mFrameCols;
                     if(this.mFrameInit >= this.mFrameRows * this.mFrameCols)
                     {
                        this.mFrameInit = 0;
                     }
                  }
                  else
                  {
                     if(this.mTargetFrameInit > this.mFrameInit)
                     {
                        this.mFrameInit += this.mFrameCols;
                     }
                     if(this.mTargetFrameInit < this.mFrameInit)
                     {
                        this.mFrameInit -= this.mFrameCols;
                     }
                  }
                  row = this.mFrameInit / this.mFrameCols;
                  this.mFrameEnd = this.mFrameCols;
                  this.mPreviousRow = row;
                  this.mRotationDelay = (8 - Math.abs(this.mFrameInit - this.mTargetFrameInit)) * 30;
               }
            }
            if(this.mFrameDelay <= 0)
            {
               this.mFrame++;
               if(this.mFrame >= this.mFrameEnd)
               {
                  this.mFrame = 0;
                  if(!this.mLoop)
                  {
                     this.mIsPlaying = false;
                     this.mFrame = this.mFrameEnd - 1;
                  }
               }
               this.mFrameDelay = this.mFrameSustain / mUnit.slowDownGetCoef(0);
            }
            else
            {
               this.mFrameDelay -= dt;
            }
            if((finalFrame = this.mFrame + this.mFrameInit) >= 0 && finalFrame < this.mFrameCount)
            {
               this.mCustomRenderData.gotoAndStop(finalFrame + 1);
            }
            if(this.mLastEmoticon != mUnit.mEmoticon)
            {
               if(this.mEmotion == null)
               {
                  this.mEmotion = DCBitmapMovieClip(InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/common.swf","emoticons"));
                  this.mEmotion.mBoundingBox = this.mCustomRenderData.mBoundingBox;
                  this.mEmotion.visible = false;
                  this.mEmotion.gotoAndStop(1);
                  this.addEmotionToScene();
               }
               this.mEmotion.visible = mUnit.mEmoticon != 0;
               if(this.mEmotion.visible)
               {
                  this.mEmotion.alpha = 0.25;
               }
               this.mEmotion.gotoAndStop(mUnit.mEmoticon);
               this.mLastEmoticon = mUnit.mEmoticon;
            }
            if(this.mEmotion != null)
            {
               if(this.mEmotion.alpha != 1 && this.mEmotion.visible)
               {
                  this.mEmotion.alpha += 0.25;
               }
            }
            this.checkSort(def);
         }
         else
         {
            this.setViewPosition();
         }
      }
      
      override public function setLoopMode(value:Boolean) : void
      {
         this.mLoop = value;
      }
      
      override public function setFrameRate(time:int) : void
      {
         this.mFrameSustain = 40 * time;
      }
      
      override public function stop() : void
      {
         this.mIsPlaying = false;
      }
      
      override public function resume() : void
      {
         this.mIsPlaying = true;
      }
      
      public function gotoAndStop(frame:int) : void
      {
         this.gotoAndPlay(frame);
         this.mIsPlaying = false;
      }
      
      public function gotoAndPlay(frame:int) : void
      {
         if(frame > this.mFrameCount)
         {
            frame = this.mFrameCount - 1;
         }
         else if(frame < 0)
         {
            frame = 0;
         }
         this.mFrame = frame;
         this.mFrameInit = frame / this.mFrameRows;
         this.mTargetFrameInit = this.mFrameInit;
         this.mFrameEnd = this.mFrameInit + this.mFrameCols;
         this.mFrameDelay = this.mFrameSustain / mUnit.slowDownGetCoef(0);
         this.mFrameInitialized = false;
         if(this.mFrame >= 0)
         {
            this.mCustomRenderData.gotoAndStop(this.mFrame + 1);
         }
         this.mIsPlaying = true;
      }
      
      public function isPlaying() : Boolean
      {
         return this.mIsPlaying;
      }
      
      override public function setRenderData(sku:String, className:String) : void
      {
         var anims:* = null;
         var mask:Object = null;
         var animName:String = null;
         var bmp:Bitmap = null;
         var numFrames:int = 0;
         var bmps:Vector.<BitmapData> = null;
         var filters:Array = null;
         var bmpData:BitmapData = null;
         var animBmpData:BitmapData = null;
         var matrix:Matrix = null;
         var cmf:ColorMatrixFilter = null;
         var i:int = 0;
         var result:Object = null;
         var frame:int = 0;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         if(GameConstants.unitUseInversedRenderMode(mUnit.mFaction) || InstanceMng.getFlowState().getCurrentRoleId() == 0)
         {
            if((mask = resourceMng.getAnimation(sku,className + "_mask")) != null)
            {
               animName = "enemy_" + InstanceMng.getUnitScene().getEnemyColorName(mUnit.mFaction);
               if((anims = resourceMng.getAnimation(sku,className + animName)) == null)
               {
                  if((anims = resourceMng.getUnitAnimation(mUnit.mDef.getAnimationDef(),sku,className)) != null)
                  {
                     bmp = new Bitmap();
                     numFrames = int(anims.bmps.length);
                     bmps = new Vector.<BitmapData>(numFrames,true);
                     filters = [];
                     matrix = new Matrix();
                     if(GameConstants.unitUseInversedRenderMode(mUnit.mFaction))
                     {
                        cmf = this.getEnemyColor();
                     }
                     else
                     {
                        cmf = this.getMyColor();
                     }
                     if(cmf != null)
                     {
                        filters.push(cmf);
                     }
                     bmp.filters = filters;
                     for(i = 0; i < numFrames; )
                     {
                        bmp.bitmapData = mask.bmps[i];
                        animBmpData = anims.bmps[i];
                        (bmpData = new BitmapData(animBmpData.width,animBmpData.height,true,0)).draw(animBmpData);
                        matrix.identity();
                        matrix.translate(mask.bounds[i].x - anims.bounds[i].x,mask.bounds[i].y - anims.bounds[i].y);
                        bmpData.draw(bmp,matrix);
                        bmps[i] = bmpData;
                        i++;
                     }
                     (result = {}).bounds = anims.bounds;
                     result.collbox = anims.collbox;
                     result.rows = anims.rows;
                     result.cols = anims.cols;
                     result.frameCount = anims.frameCount;
                     result.anglesCount = anims.anglesCount;
                     result.labels = anims.labels;
                     result.bmps = bmps;
                     InstanceMng.getResourceMng().addBitmapAnimationToCatalog(sku + className + animName,result);
                     anims = result;
                     this.mHasMask = true;
                  }
               }
               else
               {
                  this.mHasMask = true;
               }
            }
         }
         if(anims == null)
         {
            anims = resourceMng.getUnitAnimation(mUnit.mDef.getAnimationDef(),sku,className);
         }
         if(this.mCustomRenderData == null && anims != null)
         {
            this.mCustomRenderData = new DCBitmapMovieClip();
         }
         if(this.mCustomRenderData != null && anims != null)
         {
            this.mCustomRenderData.setAnimation(anims);
            if(sku == "warSmallShips_001_003")
            {
               frame = Math.random() * this.mCustomRenderData.totalFrames + 1;
               this.mCustomRenderData.gotoAndPlay(frame);
            }
         }
         if(anims == null)
         {
            resourceMng.requestResource(sku);
         }
      }
      
      override public function setAnimationId(anim:String, frame:int = -1, play:Boolean = true, setAnim:Boolean = false, setCustomRenderData:Boolean = false, loop:Boolean = true) : void
      {
         var animObject:Object = null;
         this.mLoop = loop;
         this.mIsPlaying = play;
         this.mFrameInitialized = false;
         if(anim != null && anim.indexOf("death") > -1)
         {
            this.setSelected(false);
         }
         var goAhead:Boolean = this.mCustomRenderData != null || setCustomRenderData;
         if(this.mCustomRenderData == null || setCustomRenderData)
         {
            this.mCurrentAnimation = mUnit.mDef.getAnimation(anim);
            mCurrentAnimationId = anim;
            this.mForcedAnim = frame;
         }
         if(setCustomRenderData)
         {
            this.setRenderData(mUnit.mDef.getAssetId(),this.mCurrentAnimation.className);
         }
         if(goAhead)
         {
            if(setAnim || mCurrentAnimationId != anim)
            {
               this.mCollShootingId = 0;
               if(anim == "shooting" && this.mHasSmoke)
               {
                  this.mCollShootingId = 2;
               }
               mCurrentAnimationId = anim;
               this.mCurrentAnimation = mUnit.mDef.getAnimation(anim);
               this.mForcedAnim = frame;
               this.mPreviousRow = -1;
               animObject = this.mCustomRenderData.getAnimation();
               this.mFrameCols = animObject.cols;
               this.mFrameRows = animObject.rows;
               this.mAngleCount = animObject.anglesCount;
               this.mFrameCount = animObject.frameCount;
               if(setCustomRenderData && anim == "shooting")
               {
                  this.setFrameRate(1);
               }
               if(frame == -1)
               {
                  frame = 0;
               }
               this.mLastFrame = -2;
               this.mFrameInit = frame * this.mFrameCount;
               this.mFrame = 0;
               this.mFrameEnd = this.mFrameCols;
               this.mTargetFrameInit = this.mFrameInit;
               this.render(0,mUnit.getHeading(mHeadingComponentKey));
            }
         }
      }
      
      override public function getFrameWidth() : int
      {
         return this.mCustomRenderData != null ? this.mCustomRenderData.getCurrentFrameWidth() : 0;
      }
      
      override public function getFrameHeight() : int
      {
         return this.mCustomRenderData != null ? this.mCustomRenderData.getCurrentFrameHeight() : 0;
      }
      
      override public function isPlayingAnimId(anim:String) : Boolean
      {
         return mCurrentAnimationId == anim && this.mIsPlaying;
      }
      
      override public function isPlayingAnyDeadAnim() : Boolean
      {
         return super.isPlayingAnyDeadAnim() && this.mIsPlaying;
      }
      
      private function checkSort(def:UnitDef) : void
      {
         var b:DCBoxWithTiles = null;
         var sprite:Sprite = null;
         if(def.needsToBeSorted())
         {
            b = DCBoxWithTiles(this.mCustomRenderData.mBoundingBox);
            if(Config.DEBUG_MODE && b != null)
            {
               sprite = InstanceMng.getUnitScene().debugGetSprite(this,"debugLabelBBox");
               InstanceMng.getMapViewPlanet().drawPerspectiveRectTiles(sprite.graphics,b.mTileX,b.mTileY,b.mTilesWidth,b.mTilesHeight,16777215);
            }
         }
         this.setViewPosition();
      }
      
      private function setViewPosition() : void
      {
         var coord:DCCoordinate = null;
         var collX:Number = NaN;
         var collY:Number = NaN;
         var offset:int = 0;
         var viewX:int = mUnit.mPositionDrawX;
         var viewY:int = mUnit.mPositionDrawY;
         var z:Number = mUnit.mPosition.z;
         var mov:UnitComponentMovement;
         if((mov = mUnit.getMovementComponent()) != null && mov.mPositionZ > 0)
         {
            z = mov.mPositionZ;
            coord = MyUnit.smCoor;
            coord.z = z;
            coord = InstanceMng.getViewMngPlanet().logicPosToViewPos(coord);
            z = coord.x;
         }
         this.mCustomRenderData.setXY(viewX,viewY,z);
         if(this.mEmotion != null && this.mEmotion.visible)
         {
            this.mEmotion.setXY(viewX,viewY,z);
         }
         if(this.mTail != null)
         {
            collX = this.mCustomRenderData.getCollBoxX(this.mCollShootingId);
            collY = this.mCustomRenderData.getCollBoxY(this.mCollShootingId);
            this.mTail.addPoint(viewX + collX,viewY + z + collY);
         }
         if(this.mShadow != null)
         {
            offset = 0;
            if(mUnit.mDef.isAirUnit())
            {
               offset = 70;
            }
            else if(mUnit.mDef.belongsToGroup("floating"))
            {
               offset = 60;
            }
            this.mShadow.setXY(viewX,viewY + offset);
         }
         if(this.mParticlesEnabled && mov != null)
         {
            if(this.mHasSmoke && this.mSmokeTime <= 0 && mov.isOnFloor())
            {
               collX = this.mCustomRenderData.getCollBoxX(this.mCollShootingId);
               collY = this.mCustomRenderData.getCollBoxY(this.mCollShootingId);
               if(viewX + collX != mUnit.mPositionDrawX && viewY + collY != mUnit.mPositionDrawY)
               {
                  ParticleMng.addParticle(23,viewX + collX,viewY + collY,1);
               }
               collX = this.mCustomRenderData.getCollBoxX(this.mCollShootingId + 1);
               collY = this.mCustomRenderData.getCollBoxY(this.mCollShootingId + 1);
               if(viewX + collX != mUnit.mPositionDrawX && viewY + collY != mUnit.mPositionDrawY)
               {
                  ParticleMng.addParticle(23,viewX + collX,viewY + collY,1);
               }
               this.mSmokeTime = 200;
            }
            this.createUnitTails();
         }
         if(this.mSelected)
         {
            this.mSelectedDCClip.x = mUnit.mPositionDrawX - 30 / 2;
            this.mSelectedDCClip.y = mUnit.mPositionDrawY;
         }
      }
      
      override public function addToScene() : void
      {
         var viewMng:ViewMngPlanet = null;
         if(this.mCustomRenderData != null)
         {
            viewMng = InstanceMng.getViewMngPlanet();
            viewMng.unitAddToStage(mUnit,this.mCustomRenderData);
            if(this.mShadow != null)
            {
               viewMng.addChildToLayer(this.mShadow,"LayerShips");
            }
         }
      }
      
      private function addEmotionToScene() : void
      {
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.unitAddToStage(mUnit,this.mEmotion);
      }
      
      override public function removeFromScene() : void
      {
         var viewMng:ViewMngPlanet = null;
         if(Config.DEBUG_MODE)
         {
            InstanceMng.getUnitScene().debugRemoveSprite(this,"debugLabelBBox");
         }
         if(this.mCustomRenderData != null)
         {
            viewMng = InstanceMng.getViewMngPlanet();
            viewMng.unitRemoveFromStage(mUnit,this.mCustomRenderData);
            if(this.mEmotion != null)
            {
               viewMng.unitRemoveFromStage(mUnit,this.mEmotion);
            }
            if(this.mShadow != null)
            {
               viewMng.removeChildFromLayer(this.mShadow,"LayerShips");
            }
         }
         if(this.mTail != null)
         {
            this.mTail.deactivate();
            this.mTail = null;
         }
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mCustomRenderData != null ? this.mCustomRenderData.getDisplayObject() : null;
      }
      
      override public function getDCDisplayObject() : DCDisplayObject
      {
         return this.mCustomRenderData;
      }
      
      override public function isInScreen() : Boolean
      {
         var layer:DCLayer = null;
         var returnValue:Boolean = false;
         if(this.mCustomRenderData != null)
         {
            layer = this.mCustomRenderData.getLayerParent();
            if(layer != null)
            {
               returnValue = layer.screenIsInScreenWithCamera(InstanceMng.getViewMngGame().cameraGetBox(),this.mCustomRenderData);
            }
         }
         return returnValue;
      }
      
      override public function getBoundingBox() : DCBox
      {
         return this.mCustomRenderData == null ? null : this.mCustomRenderData.mBoundingBox;
      }
      
      override public function getSelected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function setSelected(value:Boolean) : void
      {
         var viewMng:ViewMngPlanet = null;
         var mSelectedClip:Shape = null;
         if(value != this.mSelected)
         {
            viewMng = InstanceMng.getViewMngPlanet();
            if(value && mUnit.getIsAlive())
            {
               if(this.mSelectedDCClip == null)
               {
                  mSelectedClip = new Shape();
                  mSelectedClip.graphics.beginFill(15773440,0.7);
                  mSelectedClip.graphics.drawEllipse(0,0,30,15);
                  mSelectedClip.graphics.endFill();
                  this.mSelectedDCClip = new DCDisplayObjectSWF(mSelectedClip);
               }
               this.mSelectedDCClip.visible = true;
               this.mSelectedDCClip.x = mUnit.mPositionDrawX - 30 / 2;
               this.mSelectedDCClip.y = mUnit.mPositionDrawY;
               viewMng.unitShadowAddToStage(this.mSelectedDCClip);
            }
            else
            {
               if(this.mSelectedDCClip != null)
               {
                  this.mSelectedDCClip.visible = false;
               }
               viewMng.unitShadowRemoveFromStage(this.mSelectedDCClip);
            }
            this.mSelected = value;
         }
      }
      
      private function createUnitTails() : void
      {
         var color:int = 0;
         var collX:Number = NaN;
         var collY:Number = NaN;
         var tailX:Number = NaN;
         var tailY:Number = NaN;
         var def:UnitDef = mUnit.mDef;
         var tailType:String = def.getTailColor();
         if(this.mTail == null && tailType != "" && !mUnit.getMovementComponent().isStopped())
         {
            if(tailType == "smoke")
            {
               this.mHasSmoke = true;
            }
            else
            {
               color = parseInt(tailType,16);
               collX = this.mCustomRenderData.getCollBoxX(this.mCollShootingId);
               collY = this.mCustomRenderData.getCollBoxY(this.mCollShootingId);
               tailX = this.mCustomRenderData.x + collX;
               tailY = this.mCustomRenderData.y + collY;
               this.mTail = ParticleMng.addParticleBombTail(tailX,tailY,color);
            }
         }
      }
      
      override public function setAreParticlesEnabled(value:Boolean) : void
      {
         this.mParticlesEnabled = value;
      }
   }
}
