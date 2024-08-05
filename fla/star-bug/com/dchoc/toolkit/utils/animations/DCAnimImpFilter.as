package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCUtils;
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.geom.ColorTransform;
   
   public class DCAnimImpFilter extends DCAnimImp
   {
       
      
      protected var mFilter:BitmapFilter;
      
      protected var mFilterArray:Array;
      
      protected var mLayerBaseId:int = -1;
      
      private var mColorTransForm:ColorTransform;
      
      private var mColorToApply:int;
      
      private var mAlpha:Number;
      
      private var mColorAlpha:Number;
      
      private var mAttributeSku:String;
      
      private var mArray:Array;
      
      private var mNeedsToWaitForAnim:Boolean;
      
      public function DCAnimImpFilter(id:int, filter:BitmapFilter, layerBaseId:int, color:int = -1, alpha:Number = 1, attributeSku:String = null, colorAlpha:Number = 0.3, needsToWaitForAnim:Boolean = false)
      {
         super(id);
         this.mFilter = filter;
         this.mFilterArray = [];
         this.mFilterArray.push(this.mFilter);
         this.mLayerBaseId = layerBaseId;
         this.mAttributeSku = attributeSku;
         if(color > -1)
         {
            this.mColorTransForm = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         this.mColorToApply = color;
         this.mAlpha = alpha;
         this.mColorAlpha = colorAlpha;
         this.mNeedsToWaitForAnim = needsToWaitForAnim;
      }
      
      override public function unload() : void
      {
         this.mArray = null;
         this.mFilterArray = null;
      }
      
      override public function itemIsAnimReady(item:DCItemAnimatedInterface) : Boolean
      {
         var baseAnim:DCDisplayObject = null;
         var returnValue:* = super.itemIsAnimReady(item);
         if(returnValue && this.mNeedsToWaitForAnim)
         {
            baseAnim = item.viewLayersAnimGet(this.mLayerBaseId);
            returnValue = baseAnim != null;
         }
         return returnValue;
      }
      
      override public function itemAddToStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         this.doAction(item,this.applyFilter);
      }
      
      override public function itemRemoveFromStage(layerId:int, item:DCItemAnimatedInterface) : void
      {
         this.doAction(item,this.unapplyFilter);
      }
      
      private function getArray() : Array
      {
         if(this.mArray == null)
         {
            this.mArray = [];
         }
         else
         {
            this.mArray.length = 0;
         }
         return this.mArray;
      }
      
      private function doAction(item:DCItemAnimatedInterface, f:Function) : void
      {
         var layersIds:Array = null;
         var l:int = 0;
         var layer:Object = null;
         var baseAnim:DCDisplayObject = null;
         if(this.mAttributeSku != null)
         {
            if((layer = item.viewLayersGetAttribute(-1,this.mAttributeSku)) is Array)
            {
               layersIds = layer as Array;
            }
            else
            {
               (layersIds = this.getArray()).push(int(layer));
            }
         }
         else
         {
            (layersIds = this.getArray()).push(this.mLayerBaseId);
         }
         for each(l in layersIds)
         {
            baseAnim = item.viewLayersAnimGet(l);
            if(baseAnim != null)
            {
               f(baseAnim);
            }
         }
      }
      
      private function applyFilter(baseAnim:DCDisplayObject) : void
      {
         var shape:DisplayObject = baseAnim.getDisplayObject();
         baseAnim.resetFilters();
         if(this.mColorToApply > -1)
         {
            baseAnim.alpha = this.mAlpha;
            shape.transform.colorTransform = DCUtils.setInk(shape.transform.colorTransform,this.mColorToApply,this.mColorAlpha);
         }
         baseAnim.filters = this.mFilterArray;
      }
      
      private function unapplyFilter(baseAnim:DCDisplayObject) : void
      {
         var shape:DisplayObject = baseAnim.getDisplayObject();
         if(this.mColorToApply > -1)
         {
            shape.transform.colorTransform = this.mColorTransForm;
         }
         baseAnim.filters = null;
      }
   }
}
