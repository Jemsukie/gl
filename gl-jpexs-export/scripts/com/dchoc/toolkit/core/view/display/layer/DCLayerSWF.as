package com.dchoc.toolkit.core.view.display.layer
{
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.ui.ContextMenu;
   
   public class DCLayerSWF extends DCLayer
   {
       
      
      protected var mLayer:Sprite;
      
      public function DCLayerSWF(needCamera:Boolean = false, needZoom:Boolean = false, screenCamera:DCViewMng = null)
      {
         super(needCamera,needZoom,screenCamera);
         this.mLayer = new Sprite();
         this.mLayer.contextMenu = new ContextMenu();
         this.mLayer.contextMenu.hideBuiltInItems();
      }
      
      override public function addChildToDisplayList(child:*, pos:int = -1) : void
      {
         var displayChild:DisplayObject = null;
         var pushChild:Boolean = false;
         var dcChild:DCDisplayObject = null;
         var childZ:int = 0;
         if(child is DCDisplayObject)
         {
            pushChild = true;
            dcChild = DCDisplayObject(child);
            childZ = dcChild.mZDepth;
            mChilds.push(child);
            displayChild = child.getDisplayObject();
         }
         else
         {
            mChilds.push(child);
            displayChild = child;
         }
         if(pos == -1)
         {
            this.mLayer.addChild(displayChild);
         }
         else
         {
            if(pos > this.mLayer.numChildren)
            {
               pos = this.mLayer.numChildren;
            }
            this.mLayer.addChildAt(displayChild,pos);
         }
      }
      
      override protected function removeChildFromDisplayList(child:*, pos:int = -1) : void
      {
         var childDO:DisplayObject = child is DCDisplayObject ? child.getDisplayObject() : child;
         if(this.mLayer.contains(childDO))
         {
            this.mLayer.removeChild(childDO);
         }
         super.removeChildFromDisplayList(child);
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mLayer;
      }
      
      override public function zoom(z:Number) : void
      {
         this.mLayer.scaleX = z;
         this.mLayer.scaleY = z;
      }
      
      override public function getScaleX() : Number
      {
         return this.mLayer.scaleX;
      }
      
      override public function getScaleY() : Number
      {
         return this.mLayer.scaleY;
      }
      
      override public function cameraSetXY(x:int, y:int) : void
      {
         super.cameraSetXY(x,y);
         this.mLayer.x = x;
         this.mLayer.y = y;
      }
      
      public function setMouseChildren(value:Boolean) : void
      {
         this.mLayer.mouseChildren = value;
         this.mLayer.mouseEnabled = value;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         super.logicUpdate(dt);
         var length:int = int(mChilds.length);
         for(i = 0; i < length; )
         {
            if(mChilds[i] is DCBitmapMovieClip)
            {
               DCBitmapMovieClip(mChilds[i]).update(dt);
            }
            i++;
         }
      }
   }
}
