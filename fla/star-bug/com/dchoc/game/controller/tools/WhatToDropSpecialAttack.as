package com.dchoc.game.controller.tools
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Sprite;
   
   public class WhatToDropSpecialAttack extends WhatToDrop
   {
       
      
      private var mDef:SpecialAttacksDef;
      
      private var mPayedWithCash:Boolean;
      
      private var mIconRenderData:DCDisplayObject;
      
      public function WhatToDropSpecialAttack()
      {
         super();
      }
      
      public function setupParams(def:SpecialAttacksDef, payedWithCash:Boolean) : void
      {
         this.mDef = def;
         this.mPayedWithCash = payedWithCash;
         super.setup();
      }
      
      override protected function unbuildDo() : void
      {
         this.mDef = null;
         this.mIconRenderData = null;
      }
      
      override public function drop(tileX:int, tileY:int) : void
      {
         InstanceMng.getUnitScene().attacksPaySpecialAttack(this.mDef.mSku,tileX,tileY,this.mPayedWithCash,true);
      }
      
      override protected function iconAskForRenderData() : void
      {
         var sprite:Sprite = null;
         if(this.mDef.getType() == "mercenaries")
         {
            sprite = new Sprite();
            InstanceMng.getResourceMng().addImageResourceToLoad(sprite,InstanceMng.getResourceMng().getCommonResourceFullPath(this.mDef.getSpecialAttackIcon()));
            iconSetRenderData(new DCDisplayObjectSWF(sprite));
         }
      }
   }
}
