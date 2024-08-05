package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   
   public class AnimImpSWFFlatUpgrade extends AnimImpSWFStar
   {
       
      
      private var showCanUpgrade:Array;
      
      public function AnimImpSWFFlatUpgrade(id:int, layerId:int, fileSku:String, animSku:String, collisionSku:String = null, calculatePosition:Boolean = true, needsZSorting:Boolean = false, calculateScale:Boolean = true, animTimer:int = 0, alphaAnimFunc:Function = null, format:int = -99, anchorPoint:int = -99, createNameAsPNG:Boolean = false, addAssetId:Boolean = true, isAllowedToBeFlipped:Boolean = true, checkFlip:Boolean = true, animTypeId:int = 0, animParams:Object = null)
      {
         this.showCanUpgrade = [];
         super(id,layerId,fileSku,animSku,collisionSku,calculatePosition,needsZSorting,calculateScale,animTimer,alphaAnimFunc,format,anchorPoint,createNameAsPNG,addAssetId,isAllowedToBeFlipped,checkFlip,animTypeId,animParams);
      }
      
      override public function logicUpdate(item:DCItemAnimatedInterface, layerId:int, dt:int) : void
      {
         super.logicUpdate(item,layerId,dt);
         var worldItem:WorldItemObject = WorldItemObject(item);
         var def:WorldItemDef;
         if(!(def = itemGetDef(worldItem)).isHeadQuarters() && this.showCanUpgrade[parseInt(worldItem.mSid)] != (worldItem.canBeUpgradedAtCurrentHQLevel() && worldItem.canBeUpgraded()))
         {
            InstanceMng.getAnimMng().itemReleaseAnim(item,layerId);
         }
      }
      
      override public function itemCalculateSkus(item:DCItemAnimatedInterface) : Vector.<String>
      {
         var def:WorldItemDef = null;
         var resourceMng:ResourceMng = null;
         var animSku:String = null;
         var assetId:String = null;
         var worldItem:WorldItemObject = WorldItemObject(item);
         if(worldItem != null && mFileSku == null && worldItem.isFlatBed())
         {
            def = itemGetDef(worldItem);
            resourceMng = InstanceMng.getResourceMng();
            animSku = "flatUpgrade";
            assetId = null;
            this.showCanUpgrade[parseInt(worldItem.mSid)] = worldItem.canBeUpgradedAtCurrentHQLevel() && worldItem.canBeUpgraded();
            assetId = !!this.showCanUpgrade[parseInt(worldItem.mSid)] ? "yes" : "no";
            mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,animSku,assetId,2,true,false,true);
         }
         return mItemSkus;
      }
   }
}
