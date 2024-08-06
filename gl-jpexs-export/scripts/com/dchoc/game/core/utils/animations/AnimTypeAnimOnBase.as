package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.animations.DCAnimType;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.utils.Dictionary;
   
   public class AnimTypeAnimOnBase extends DCAnimType
   {
       
      
      private var mCatalog:Dictionary;
      
      public function AnimTypeAnimOnBase(id:int, catalog:Dictionary)
      {
         super(id);
         this.mCatalog = catalog;
      }
      
      override public function getImpId(item:DCItemAnimatedInterface, layerId:int) : int
      {
         var worldItem:WorldItemObject = item as WorldItemObject;
         return this.mCatalog[worldItem.mDef.getAnimOnBase()] != null ? int(this.mCatalog[worldItem.mDef.getAnimOnBase()]) : -1;
      }
   }
}
