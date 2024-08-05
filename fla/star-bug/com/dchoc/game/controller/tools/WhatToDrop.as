package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class WhatToDrop
   {
       
      
      protected var mTransaction:Transaction;
      
      protected var mIconDO:DCDisplayObject;
      
      public function WhatToDrop()
      {
         super();
      }
      
      protected function setup() : void
      {
         this.iconReset();
      }
      
      public function unbuild() : void
      {
         this.unbuildDo();
         this.mIconDO = null;
         this.mTransaction = null;
      }
      
      protected function unbuildDo() : void
      {
      }
      
      public function move(viewPosX:int, viewPosY:int) : void
      {
         if(this.mIconDO != null)
         {
            this.mIconDO.x = viewPosX;
            this.mIconDO.y = viewPosY;
         }
      }
      
      public function uiEnable() : void
      {
         if(this.mIconDO != null)
         {
            InstanceMng.getViewMngPlanet().cursorToolDropAddToStage(this.mIconDO.getDisplayObjectContent());
         }
      }
      
      public function uiDisable() : void
      {
         if(this.mIconDO != null)
         {
            InstanceMng.getViewMngPlanet().cursorToolDropRemoveFromStage(this.mIconDO.getDisplayObjectContent());
         }
      }
      
      public function drop(tileX:int, tileY:int) : void
      {
      }
      
      public function logicUpdate() : void
      {
         if(this.mIconDO == null)
         {
            this.iconAskForRenderData();
            if(this.mIconDO != null)
            {
               InstanceMng.getViewMngPlanet().cursorToolDropAddToStage(this.mIconDO.getDisplayObjectContent());
            }
         }
      }
      
      public function setTransaction(value:Transaction) : void
      {
         this.mTransaction = value;
      }
      
      public function iconReset() : void
      {
         if(this.mIconDO != null)
         {
            InstanceMng.getViewMngPlanet().cursorToolDropRemoveFromStage(this.mIconDO.getDisplayObjectContent());
            this.mIconDO = null;
         }
      }
      
      protected function iconAskForRenderData() : void
      {
      }
      
      protected function iconSetRenderData(value:DCDisplayObject) : void
      {
         this.mIconDO = value;
         if(this.mIconDO != null)
         {
            this.mIconDO.alpha = 0.85;
         }
      }
   }
}
