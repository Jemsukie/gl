package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   
   public class AnimImpSWFShipyards extends AnimImpSWFStar
   {
      
      private static const ANIM_NAME:String = "training";
       
      
      private var mBarracksCount:int;
      
      public function AnimImpSWFShipyards(id:int, layerId:int)
      {
         super(id,layerId,null,"training",null,true,false,true,0,null,3,1,true,false);
         this.mBarracksCount = 0;
      }
      
      override public function itemAddToStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         var wio:WorldItemObject;
         var def:WorldItemDef = (wio = WorldItemObject(item)).mDef;
         if(def.getShipsFiles() == "groundUnits")
         {
            this.mBarracksCount++;
         }
         super.itemAddToStage(layerId,item);
      }
      
      override public function itemRemoveFromStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         var wio:WorldItemObject;
         var def:WorldItemDef = (wio = WorldItemObject(item)).mDef;
         if(def.getShipsFiles() == "groundUnits")
         {
            this.mBarracksCount--;
         }
         super.itemRemoveFromStage(layerId,item);
      }
      
      override public function itemCalculateSkus(item:DCItemAnimatedInterface) : Vector.<String>
      {
         var off:int = 0;
         var wio:WorldItemObject = WorldItemObject(item);
         var def:WorldItemDef = wio.mDef;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(def.getShipsFiles())
         {
            case "groundUnits":
               off = this.mBarracksCount % 2 + 1;
               mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,"","barracks_001",mFormat,true,true);
               mItemSkus[1] = "training_0" + off;
               break;
            case "mecaUnits":
               mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,"","meca_factory_001",mFormat,true,true);
               mItemSkus[1] = "training";
               break;
            case "warSmallShips":
               off = wio.mUpgradeId + 1;
               mItemSkus[0] = resourceMng.getWorldItemObjectFileName(def,"","shipyard_001",mFormat,true,true);
               mItemSkus[1] = "training_0" + off;
         }
         return mItemSkus;
      }
   }
}
