package com.dchoc.game.view.dc.gui.highlights
{
   import com.dchoc.game.core.instance.InstanceMng;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   
   public class Highlight extends Sprite
   {
      
      public static const DEFAULT_HLIGHT_WIDTH:Number = 117;
      
      public static const DEFAULT_HLIGHT_HEIGHT:Number = 90;
      
      private static const DEFAULT_HLIGHT_DURATION:Number = 2;
      
      private static const DEFAULT_HLIGHT_PAUSE:Number = 1;
      
      private static const HIGHLIGHT_ASSET:String = "highlight";
      
      private static const HIGHLIGHT_GLOW:Array = [new GlowFilter(16773120,0.4,5,5,4)];
       
      
      private var mAsset:MovieClip;
      
      private var mLayerSku:String;
      
      public function Highlight()
      {
         super();
      }
      
      public function init(highlightConfig:Object = null) : void
      {
         var filters:Array = null;
         var boxRect:Rectangle = null;
         if(highlightConfig != null && "baseDO" in highlightConfig)
         {
            if(highlightConfig is DisplayObject)
            {
               boxRect = highlightConfig["baseDO"].getBounds(highlightConfig["baseDO"].stage);
            }
         }
         else if(highlightConfig != null && "box" in highlightConfig)
         {
            boxRect = highlightConfig["box"];
         }
         else
         {
            boxRect = new Rectangle(0,0,117,90);
         }
         if(highlightConfig != null && "layerSku" in highlightConfig)
         {
            this.mLayerSku = highlightConfig["layerSku"];
         }
         var assetId:String = "highlight";
         if(highlightConfig != null && "assetId" in highlightConfig)
         {
            assetId = String(highlightConfig["assetId"]);
         }
         var highlightColour:int = 65535;
         if(highlightConfig != null && "highlightColour" in highlightConfig)
         {
            highlightColour = parseInt(highlightConfig["highlightColour"],16);
         }
         var assetClass:Class;
         if((assetClass = InstanceMng.getResourceMng().getSWFClass("assets/flash/_esparragon/gui/layouts/gui_old.swf",assetId)) != null)
         {
            this.mAsset = new assetClass() as MovieClip;
            filters = [new GlowFilter(highlightColour,1,15,15,4),new BlurFilter(2,2)];
            this.mAsset.filters = filters;
            this.mAsset.x = boxRect.x;
            this.mAsset.y = boxRect.y;
         }
         this.mAsset.gotoAndStop(this.mAsset.totalFrames);
         this.mAsset.scaleX = this.mAsset.width != 0 ? boxRect.width / this.mAsset.width : 1;
         this.mAsset.scaleY = this.mAsset.height != 0 ? boxRect.height / this.mAsset.height : 1;
         this.mAsset.gotoAndStop(1);
         this.mAsset.play();
         addChild(this.mAsset);
      }
      
      public function destroy() : void
      {
         if(this.mAsset != null && this.mAsset.parent == this)
         {
            this.mAsset.filters = [];
            removeChild(this.mAsset);
         }
      }
      
      public function getLayerSku() : String
      {
         return this.mLayerSku;
      }
   }
}
