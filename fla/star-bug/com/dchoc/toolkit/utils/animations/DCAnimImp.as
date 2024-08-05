package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class DCAnimImp
   {
       
      
      public var mId:int;
      
      public function DCAnimImp(id:int)
      {
         super();
         this.mId = id;
      }
      
      public function unload() : void
      {
      }
      
      public function logicUpdate(item:DCItemAnimatedInterface, layerId:int, dt:int) : void
      {
      }
      
      public function animIsReady() : Boolean
      {
         return true;
      }
      
      public function animGet() : DCDisplayObject
      {
         return null;
      }
      
      public function animRelease(d:DCDisplayObject) : void
      {
      }
      
      public function animHasEnded(item:DCItemAnimatedInterface, layerId:int) : Boolean
      {
         var anim:DCDisplayObject = item.viewLayersAnimGet(layerId);
         return anim != null && anim.hasEnded();
      }
      
      public function itemGetAnim(item:DCItemAnimatedInterface) : DCDisplayObject
      {
         return this.animGet();
      }
      
      public function itemIsAnimReady(item:DCItemAnimatedInterface) : Boolean
      {
         return this.animIsReady();
      }
      
      public function itemAddToStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
      }
      
      public function itemRemoveFromStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
      }
      
      public function itemCalculatePosition(item:DCItemAnimatedInterface, layerId:int, coor:DCCoordinate = null) : void
      {
      }
   }
}
