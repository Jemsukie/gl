package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   
   public class WhatToDropUnit extends WhatToDrop
   {
       
      
      private var mUnitDef:UnitDef;
      
      public function WhatToDropUnit()
      {
         super();
      }
      
      public function setupSetUnitSku(unitSku:String) : void
      {
         var unitDef:UnitDef = InstanceMng.getUnitScene().unitsGetUnitDefFromUniqueSku(unitSku) as UnitDef;
         if(unitDef != this.mUnitDef)
         {
            this.mUnitDef = unitDef;
            setup();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mUnitDef = null;
      }
      
      override public function drop(tileX:int, tileY:int) : void
      {
         var o:Object = InstanceMng.getGUIControllerPlanet().createNotifyEvent(5,"NOTIFY_WAR_CLICK_ON_MAP_DEPLOY_UNITS");
         o.spawnTileX = tileX;
         o.spawnTileY = tileY;
         o.unitSku = this.mUnitDef.mSku;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
      }
      
      override protected function iconAskForRenderData() : void
      {
         var anim:Object = null;
         var sku:String = null;
         var className:String = null;
         var anims:Object = null;
         var resourceMng:ResourceMng = null;
         var renderData:DCBitmapMovieClip = null;
         var angle:int = 0;
         if(this.mUnitDef != null)
         {
            anim = this.mUnitDef.getAnimation(this.mUnitDef.getDefaultAnimationId());
            sku = this.mUnitDef.getAssetId();
            className = String(anim.className);
            resourceMng = InstanceMng.getResourceMng();
            if(anims == null)
            {
               anims = resourceMng.getAnimation(sku,className);
            }
            if(anims == null)
            {
               resourceMng.requestResource(sku);
            }
            else
            {
               if(mIconDO == null)
               {
                  renderData = new DCBitmapMovieClip();
                  iconSetRenderData(renderData);
               }
               else
               {
                  renderData = DCBitmapMovieClip(mIconDO);
               }
               renderData.setAnimation(anims);
               angle = 270 * renderData.totalFrames / 360;
               renderData.gotoAndStop(angle + 1);
            }
         }
      }
   }
}
