package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.animations.DCAnimImpFilter;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.filters.BitmapFilter;
   
   public class UmbrellaAnimImpFilter extends DCAnimImpFilter
   {
       
      
      public function UmbrellaAnimImpFilter(id:int, filter:BitmapFilter, layerBaseId:int, color:int = -1, alpha:Number = 1, attributeSku:String = null, colorAlpha:Number = 0.3, needsToWaitForAnim:Boolean = false)
      {
         super(id,filter,layerBaseId,color,alpha,attributeSku,colorAlpha,needsToWaitForAnim);
      }
      
      override public function logicUpdate(item:DCItemAnimatedInterface, layerId:int, dt:int) : void
      {
         var intensity:Number = NaN;
         var wio:WorldItemObject = item as WorldItemObject;
         var baseAnim:DCDisplayObject;
         if((baseAnim = item.viewLayersAnimGet(mLayerBaseId)) != null)
         {
            if(wio.absorbImpactIsOn())
            {
               intensity = wio.absorbImpactGetIntensity();
               this.doEffect(baseAnim,intensity);
            }
            else if(baseAnim.filters != mFilterArray)
            {
               baseAnim.filters = mFilterArray;
            }
         }
      }
      
      private function doEffect(baseAnim:DCDisplayObject, intensity:Number) : void
      {
         if(intensity > 0.6)
         {
            if(baseAnim.filters != mFilterArray)
            {
               baseAnim.filters = mFilterArray;
            }
         }
         else if(baseAnim.filters != null)
         {
            baseAnim.filters = null;
         }
      }
   }
}
