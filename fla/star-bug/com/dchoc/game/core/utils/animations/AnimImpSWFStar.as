package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.animations.DCAnimImpSWF;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.DisplayObject;
   
   public class AnimImpSWFStar extends DCAnimImpSWF
   {
      
      private static const COLLISION_BAR:String = "bar";
      
      public static const ANIM_TYPE_ALPHA_ID:int = 0;
      
      public static const ANIM_TYPE_SCALE_ID:int = 1;
       
      
      private var mLayerId:int;
      
      private var mCoor:DCCoordinate;
      
      protected var mCollisionSku:String;
      
      private var mCalculateScale:Boolean;
      
      private var mAnimTypeId:int;
      
      private var mAnimTimer:int;
      
      private var mAlphaAnimFunc:Function;
      
      protected var mFormat:int;
      
      private var mAnchorPoint:int;
      
      private var mCreateNameAsPNG:Boolean;
      
      private var mAddAssetId:Boolean;
      
      private var mIsAllowedToBeFlipped:Boolean;
      
      private var mCheckFlip:Boolean;
      
      private var mAnimParams:Object;
      
      protected var mItemSkus:Vector.<String>;
      
      public function AnimImpSWFStar(id:int, layerId:int, fileSku:String, animSku:String, collisionSku:String = null, calculatePosition:Boolean = true, needsZSorting:Boolean = false, calculateScale:Boolean = true, animTimer:int = 0, alphaAnimFunc:Function = null, format:int = -99, anchorPoint:int = -99, createNameAsPNG:Boolean = false, addAssetId:Boolean = true, isAllowedToBeFlipped:Boolean = true, checkFlip:Boolean = true, animTypeId:int = 0, animParams:Object = null)
      {
         this.mItemSkus = new Vector.<String>(2);
         super(id);
         if(format == -99)
         {
            format = 3;
         }
         if(anchorPoint == -99)
         {
            anchorPoint = 1;
         }
         this.mLayerId = layerId;
         mFileSku = fileSku;
         mAnimSku = animSku;
         this.mCollisionSku = collisionSku;
         mCalculatePosition = calculatePosition;
         this.mCalculateScale = calculateScale;
         mNeedsZSorting = needsZSorting;
         this.mAnimTimer = animTimer;
         this.mAlphaAnimFunc = alphaAnimFunc;
         this.mFormat = format;
         this.mAnchorPoint = anchorPoint;
         this.mCreateNameAsPNG = createNameAsPNG;
         this.mAddAssetId = addAssetId;
         this.mIsAllowedToBeFlipped = isAllowedToBeFlipped;
         this.mCheckFlip = checkFlip;
         this.mAnimTypeId = animTypeId;
         this.mAnimParams = animParams;
      }
      
      override public function unload() : void
      {
         super.unload();
         mFileSku = null;
         mAnimSku = null;
         this.mItemSkus = null;
         this.mCoor = null;
      }
      
      override public function logicUpdate(item:DCItemAnimatedInterface, layerId:int, dt:int) : void
      {
         var baseAlpha:Number = NaN;
         var baseLayer:DCDisplayObject = null;
         var anim:DCDisplayObject = null;
         var time:int = 0;
         var x:int = 0;
         var y:int = 0;
         var worldItem:WorldItemObject = null;
         var centerX:int = 0;
         var centerY:int = 0;
         var maxScaleX:Number = NaN;
         var maxScaleY:Number = NaN;
         if(this.mAnimTimer > 0)
         {
            anim = item.viewLayersAnimGet(layerId);
            if((time = item.viewLayersGetTimer(layerId)) <= 0)
            {
               if(this.mAnimTypeId == 1)
               {
                  time = 0;
               }
               else
               {
                  time = this.mAnimTimer;
               }
               item.viewLayersSetTimer(layerId,time);
            }
            if(anim != null)
            {
               switch(this.mAnimTypeId)
               {
                  case 0:
                     baseAlpha = 1;
                     if((baseLayer = item.viewLayersAnimGet(1)) != null)
                     {
                        baseAlpha = baseLayer.alpha;
                     }
                     anim.alpha = baseAlpha * this.mAlphaAnimFunc(time,this.mAnimTimer,this.mAnimParams);
                     break;
                  case 1:
                     this.mCoor = this.itemGetLogicPosition(item,layerId);
                     x = this.mCoor.x;
                     y = this.mCoor.y;
                     centerX = (worldItem = WorldItemObject(item)).viewGetWorldX();
                     centerY = worldItem.viewGetWorldY();
                     this.mCoor = this.calculateScale(item,layerId);
                     maxScaleX = this.mCoor.x;
                     maxScaleY = this.mCoor.y;
                     if(anim.scaleX != maxScaleX)
                     {
                        if(time <= 0)
                        {
                           anim.scaleX = maxScaleX;
                        }
                        else
                        {
                           anim.scaleX = maxScaleX * (this.mAnimTimer - time) / this.mAnimTimer;
                        }
                     }
                     if(anim.scaleY != maxScaleY)
                     {
                        if(time <= 0)
                        {
                           anim.scaleY = maxScaleY;
                        }
                        else
                        {
                           anim.scaleY = maxScaleY * (this.mAnimTimer - time) / this.mAnimTimer;
                        }
                     }
                     this.mCoor.x = centerX - anim.scaleX / maxScaleX * (centerX - x);
                     this.mCoor.y = centerY - anim.scaleY / maxScaleY * (centerY - y);
                     this.itemCalculatePosition(item,layerId,this.mCoor);
               }
            }
         }
      }
      
      override public function animIsReady() : Boolean
      {
         return DCInstanceMng.getInstance().getPoolMng().animIsReady(mFileSku,mAnimSku);
      }
      
      override public function animGet() : DCDisplayObject
      {
         return DCInstanceMng.getInstance().getPoolMng().animGet(mFileSku,mAnimSku);
      }
      
      override public function animRelease(d:DCDisplayObject) : void
      {
         DCInstanceMng.getInstance().getPoolMng().animRelease(mFileSku,mAnimSku,d);
      }
      
      override public function animHasEnded(item:DCItemAnimatedInterface, layerId:int) : Boolean
      {
         var anim:DCDisplayObject = null;
         var returnValue:Boolean = super.animHasEnded(item,layerId);
         if(this.mAnimTypeId == 1 && returnValue)
         {
            anim = item.viewLayersAnimGet(layerId);
            this.mCoor = this.calculateScale(item,layerId);
            returnValue = Math.abs(anim.scaleX - this.mCoor.x) < 0.00001 && Math.abs(anim.scaleY - this.mCoor.y) < 0.00001;
         }
         return returnValue;
      }
      
      override public function itemAddToStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         var cData:Object = null;
         var anim:DCDisplayObject = item.viewLayersAnimGet(layerId);
         this.itemProcessAnim(layerId,item,anim);
         if(this.mCoor == null)
         {
            this.mCoor = new DCCoordinate();
         }
         if(this.mCalculateScale)
         {
            if(this.mAnimTypeId == 1)
            {
               anim.scaleX = 0;
               anim.scaleY = 0;
            }
            else
            {
               this.calculateScale(item,layerId);
               anim.scaleX = this.mCoor.x;
               anim.scaleY = this.mCoor.y;
            }
         }
         if(mCalculatePosition)
         {
            this.itemCalculatePosition(item,layerId);
         }
         if(mNeedsZSorting)
         {
            anim.mBoundingBox = item.viewLayersGetSortingBox(layerId);
         }
         else
         {
            anim.mBoundingBox = item.viewLayersGetBoundingBox(layerId);
         }
         if(this.mCollisionSku != null)
         {
            if((cData = DCInstanceMng.getInstance().getCollisionBoxMng().getCollisionBoxByName(item.viewGetCollisionBoxPackageSku(),this.mCollisionSku)) != null)
            {
               anim.x += cData.x;
               anim.y += cData.y;
            }
            else if(this.mCollisionSku == "bar")
            {
               anim.y -= anim.getCurrentFrameHeight() >> 1;
            }
         }
         item.viewLayersAddToStage(layerId);
         this.applyFilters(anim.getDisplayObject());
         if(this.mAnimTimer > 0)
         {
            item.viewLayersSetTimer(layerId,this.mAnimTimer);
            this.logicUpdate(item,layerId,0);
         }
      }
      
      private function calculateScale(item:DCItemAnimatedInterface, layerId:int) : DCCoordinate
      {
         item.viewLayersGetScaleXY(layerId,this.mCoor);
         if(!this.mIsAllowedToBeFlipped && this.mCoor.x < 0)
         {
            this.mCoor.x = -this.mCoor.x;
         }
         return this.mCoor;
      }
      
      protected function itemProcessAnim(layerId:int, item:DCItemAnimatedInterface, anim:DCDisplayObject) : void
      {
      }
      
      override public function itemRemoveFromStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         item.viewLayersRemoveFromStage(layerId);
      }
      
      protected function applyFilters(clip:DisplayObject) : void
      {
      }
      
      protected function itemGetDef(worldItem:WorldItemObject) : WorldItemDef
      {
         if(worldItem.mServerStateId == 2 && worldItem.getNextDef().showsNormalWhenUpgradingInBattle())
         {
            return worldItem.isBrokenState() ? worldItem.mDef : worldItem.mDef;
         }
         return worldItem.isBrokenState() ? worldItem.mDef : worldItem.getNextDef();
      }
      
      public function itemCalculateSkus(item:DCItemAnimatedInterface) : Vector.<String>
      {
         var def:WorldItemDef = null;
         var resourceMng:ResourceMng = null;
         var flatBed:Boolean = false;
         var format:int = 0;
         var animSku:String = null;
         var worldItem:WorldItemObject = WorldItemObject(item);
         if(worldItem != null && mFileSku == null)
         {
            def = this.itemGetDef(worldItem);
            resourceMng = InstanceMng.getResourceMng();
            flatBed = worldItem.isFlatBed() && mId == 47;
            if(this.mLayerId == 0 && !flatBed)
            {
               worldItem.viewGetGroundAnimSkus(this.mItemSkus);
            }
            else
            {
               format = def.getFormat();
               animSku = mAnimSku;
               if(flatBed)
               {
                  format = 2;
                  animSku = "ready";
               }
               if(format == -1)
               {
                  format = this.mFormat;
               }
               if(format == 2)
               {
                  this.mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,animSku,null,2,true,false,flatBed);
               }
               else
               {
                  this.mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,"",null,format,true,this.mCreateNameAsPNG);
                  if(this.mAddAssetId)
                  {
                     this.mItemSkus[1] = def.getAssetId() + "_" + mAnimSku;
                  }
                  else
                  {
                     this.mItemSkus[1] = mAnimSku;
                  }
               }
            }
            if(mId == 5)
            {
               this.mItemSkus[1] = def.getAssetId() + "_explosion";
            }
         }
         else if(mFileSku == null)
         {
            this.mItemSkus[1] = mAnimSku;
            item.viewGetAnimSkus(this.mItemSkus,this.mLayerId);
         }
         else
         {
            this.mItemSkus[0] = mFileSku;
            this.mItemSkus[1] = mAnimSku;
         }
         return this.mItemSkus;
      }
      
      override public function itemIsAnimReady(item:DCItemAnimatedInterface) : Boolean
      {
         var cData:Object = null;
         var returnValue:Boolean = true;
         if(this.mCollisionSku != null)
         {
            cData = DCInstanceMng.getInstance().getCollisionBoxMng().getCollisionBoxByName(item.viewGetCollisionBoxPackageSku(),this.mCollisionSku);
            returnValue = cData != null || this.mCollisionSku == "bar";
         }
         if(returnValue)
         {
            this.itemCalculateSkus(item);
            returnValue = DCInstanceMng.getInstance().getPoolMng().animIsReady(this.mItemSkus[0],this.mItemSkus[1]);
         }
         return returnValue;
      }
      
      override public function itemGetAnim(item:DCItemAnimatedInterface) : DCDisplayObject
      {
         this.itemCalculateSkus(item);
         return DCInstanceMng.getInstance().getPoolMng().animGet(this.mItemSkus[0],this.mItemSkus[1]);
      }
      
      override public function itemCalculatePosition(item:DCItemAnimatedInterface, layerId:int, coor:DCCoordinate = null) : void
      {
         var anim:DCDisplayObject;
         if((anim = item.viewLayersAnimGet(layerId)) == null)
         {
            return;
         }
         var format:int = 0;
         var worldItem:WorldItemObject = null;
         var sign:int = 0;
         var anchorPoint:int = 0;
         if(coor == null)
         {
            this.mCoor = this.itemGetLogicPosition(item,layerId);
         }
         else
         {
            this.mCoor = coor;
         }
         format = this.getFormat(item);
         worldItem = WorldItemObject(item);
         if((format == 2 || format == 3 && mId == 47) && worldItem != null)
         {
            sign = this.mCheckFlip && worldItem.mIsFlipped ? -1 : 1;
            this.mCoor.x -= anim.getCurrentFrameWidth() / 2 * sign;
            if((anchorPoint = this.getAnchorPoint(item)) == 0)
            {
               this.mCoor.y -= anim.getCurrentFrameHeight() / 2;
            }
            else
            {
               this.mCoor.y -= anim.getCurrentFrameHeight();
            }
         }
         anim.x = this.mCoor.x;
         anim.y = this.mCoor.y;
      }
      
      private function getFormat(item:DCItemAnimatedInterface) : int
      {
         var worldItem:WorldItemObject = WorldItemObject(item);
         var format:int = this.mFormat;
         if(worldItem != null)
         {
            format = worldItem.mDef.getFormat();
            if(format == -1)
            {
               format = this.mFormat;
            }
         }
         return format;
      }
      
      private function getAnchorPoint(item:DCItemAnimatedInterface) : int
      {
         var anchorPoint:int = this.mAnchorPoint;
         var format:int = this.getFormat(item);
         var worldItem:WorldItemObject = WorldItemObject(item);
         if(worldItem != null)
         {
            if(anchorPoint == -1)
            {
               if(format != 2)
               {
                  anchorPoint = 0;
               }
               else
               {
                  anchorPoint = 1;
               }
            }
         }
         return anchorPoint;
      }
      
      private function itemGetLogicPosition(item:DCItemAnimatedInterface, layerId:int) : DCCoordinate
      {
         if(this.mCoor == null)
         {
            this.mCoor = new DCCoordinate();
         }
         var thisLayerId:int = this.mLayerId == 1 ? this.mLayerId : layerId;
         item.viewLayersGetWorldXY(thisLayerId,this.mCoor,this.getAnchorPoint(item));
         return this.mCoor;
      }
   }
}
