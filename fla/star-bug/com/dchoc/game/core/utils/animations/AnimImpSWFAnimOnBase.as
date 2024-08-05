package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.display.DisplayObject;
   
   public class AnimImpSWFAnimOnBase extends AnimImpSWFStar
   {
       
      
      public function AnimImpSWFAnimOnBase(id:int, layerId:int)
      {
         super(id,layerId,null,null,null,true,false,true,0,null,0);
      }
      
      override public function itemCalculateSkus(item:DCItemAnimatedInterface) : Vector.<String>
      {
         var resourceMng:ResourceMng = null;
         var asset:String = null;
         var path:String = null;
         var worldItem:WorldItemObject = WorldItemObject(item);
         var def:WorldItemDef;
         var assetId:String = (def = worldItem.mDef).getAssetId();
         mItemSkus[0] = InstanceMng.getResourceMng().getWorldItemObjectFileName(def,"","headquarter_001",mFormat,true,true);
         var tokens:Array = assetId.split("_");
         if(!InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isCurrentPlanetCapital())
         {
            resourceMng = InstanceMng.getResourceMng();
            asset = "assets/flash/world_items/" + def.getFlaFolderByKey("colony") + tokens.slice(0,2).join("_") + ".swf";
            path = DCResourceMng.getFileName("assets/flash/world_items/" + def.getFlaFolderByKey("colony") + "headquarter_001.swf");
            resourceMng.catalogAddResource(asset,path);
            mItemSkus[0] = asset;
         }
         var levelId:String = "00";
         if(tokens.length == 3)
         {
            levelId = String(tokens[2]);
         }
         mItemSkus[1] = "flag_" + levelId;
         return mItemSkus;
      }
      
      override protected function applyFilters(clip:DisplayObject) : void
      {
         var alliancesController:AlliancesController = null;
         var alliance:Alliance = null;
         var logo:Array = null;
         if(Config.useAlliances())
         {
            if((alliancesController = InstanceMng.getAlliancesController()) != null)
            {
               alliance = alliancesController.getWorldAlliance();
               if(alliance != null)
               {
                  logo = alliance.getLogo();
                  if(logo != null && !InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().mIsNPC.value)
                  {
                     InstanceMng.getResourceMng().applyFlagFilter(clip,logo);
                  }
               }
            }
         }
      }
   }
}
