package com.dchoc.game.view.dc.mng
{
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   
   public class ViewMngSpace extends ViewMngrGame
   {
      
      private static const LAYER_HUD_SKU:String = "Hud";
      
      private static const LAYER_POPUP_SKU:String = "Popup";
      
      private static const LAYER_TOOLTIP_SKU:String = "Tooltip";
      
      private static const LAYER_CURSOR_SKU:String = "Cursor";
      
      private static const LAYER_PORTAL_SKU:String = "Portal";
      
      private static const LAYER_HUD:int = 1;
      
      private static const LAYER_POPUP:int = 2;
      
      private static const LAYER_TOOLTIP:int = 3;
      
      private static const LAYER_CURSOR:int = 4;
      
      private static const LAYER_PORTAL:int = 5;
       
      
      public function ViewMngSpace()
      {
         super();
      }
      
      override protected function layersPopulate() : void
      {
         mLayers[2] = new DCLayerSWF();
         mLayers[1] = new DCLayerSWF();
         mLayers[3] = new DCLayerSWF();
         DCLayerSWF(mLayers[3]).setMouseChildren(false);
         mLayers[4] = new DCLayerSWF();
         mLayers[5] = new DCLayerSWF();
         mLayerDictionary["Popup"] = 2;
         mLayerDictionary["Hud"] = 1;
         mLayerDictionary["Tooltip"] = 3;
         mLayerDictionary["Cursor"] = 4;
         mLayerDictionary["Portal"] = 5;
      }
      
      override public function getCursorLayerSku() : String
      {
         return "Cursor";
      }
      
      override public function getHudLayerSku() : String
      {
         return "Hud";
      }
      
      override public function getPopupLayerSku() : String
      {
         return "Popup";
      }
      
      override public function getPortalLayerSku() : String
      {
         return "Portal";
      }
      
      override public function getTooltipLayerSku() : String
      {
         return "Tooltip";
      }
   }
}
