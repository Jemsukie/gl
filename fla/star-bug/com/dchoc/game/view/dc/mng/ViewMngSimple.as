package com.dchoc.game.view.dc.mng
{
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   import com.dchoc.toolkit.core.view.mng.DCViewMngSimple;
   
   public class ViewMngSimple extends DCViewMngSimple
   {
      
      private static const LAYER_POPUP:int = 1;
      
      private static const LAYER_POPUP_SKU:String = "LayerPopup";
       
      
      public function ViewMngSimple(numLayers:int)
      {
         super(numLayers);
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         super.buildDoAsyncStep(step);
         if(step == 0)
         {
            this.layersPopulate();
         }
      }
      
      protected function layersPopulate() : void
      {
         mLayers[1] = new DCLayerSWF();
         mLayerDictionary["LayerPopup"] = 1;
      }
      
      override public function addPopup(d:*, pos:int = -1) : void
      {
         addChildToLayer(d,"LayerPopup",pos);
      }
      
      override public function removePopup(d:*) : void
      {
         removeChildFromLayer(d,"LayerPopup");
      }
   }
}
