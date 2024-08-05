package com.dchoc.toolkit.core.view.display.layer
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCStage;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import flash.display.DisplayObject;
   
   public class DCLayer
   {
      
      private static const DEBUG_ADD_CHILD_ALLOWED:Boolean = true;
       
      
      protected var mChilds:Array;
      
      public var mMustDraw:Boolean;
      
      private var mNeedCamera:Boolean;
      
      private var mNeedZoom:Boolean;
      
      protected var mCameraX:int;
      
      protected var mCameraY:int;
      
      protected var mScreenItemsIn:Vector.<DCDisplayObject>;
      
      private var mScreenItemsOut:Vector.<DCDisplayObject>;
      
      public var mScreenCamera:DCViewMng;
      
      protected var mScreenCameraNeedsToBeUpdated:Boolean;
      
      private var mScreenItemsOutTemp:Vector.<DCDisplayObject>;
      
      public function DCLayer(needCamera:Boolean = false, needZoom:Boolean = false, screenCamera:DCViewMng = null)
      {
         super();
         this.mChilds = [];
         this.mMustDraw = true;
         this.mNeedCamera = needCamera;
         this.mNeedZoom = needZoom;
         this.mScreenCamera = screenCamera;
         if(this.mScreenCamera != null)
         {
            this.screenLoad();
         }
      }
      
      public function clear() : void
      {
         var c:* = undefined;
         if(this.mScreenCamera != null)
         {
            for each(c in this.mScreenItemsIn)
            {
               this.removeChildFromDisplayList(c);
            }
            if(this.mScreenItemsIn != null)
            {
               this.mScreenItemsIn.length = 0;
            }
            if(this.mScreenItemsOut != null)
            {
               this.mScreenItemsOut.length = 0;
            }
         }
         else
         {
            for each(c in this.mChilds)
            {
               this.removeChildFromDisplayList(c);
            }
         }
         this.mChilds.length = 0;
      }
      
      public function build(width:int = 0, height:int = 0) : void
      {
      }
      
      public function unbuild() : void
      {
         this.clear();
      }
      
      public function unload() : void
      {
         if(this.mScreenCamera != null)
         {
            this.screenUnload();
         }
      }
      
      public function addChild(child:*, pos:int = -1) : void
      {
         if(true)
         {
            if(this.mScreenCamera != null && child is DCDisplayObject)
            {
               this.screenAddChild(child);
            }
            else
            {
               this.addChildToDisplayList(child,pos);
            }
         }
      }
      
      public function addChildToDisplayList(child:*, pos:int = -1) : void
      {
         if(true)
         {
            this.mChilds.push(child);
         }
      }
      
      public function removeChild(child:*) : void
      {
         var pos:int = 0;
         if(child != null)
         {
            pos = this.mChilds.indexOf(child);
            if(this.mScreenCamera != null && child is DCDisplayObject)
            {
               this.screenRemoveChild(child);
            }
            else
            {
               this.removeChildFromDisplayList(child,pos);
            }
         }
      }
      
      protected function removeChildFromDisplayList(child:*, pos:int = -1) : void
      {
         if(pos == -1)
         {
            pos = this.mChilds.indexOf(child);
         }
         if(pos > -1)
         {
            this.mChilds.splice(pos,1);
         }
      }
      
      public function addToStage(stage:DCStage) : void
      {
         stage.addChild(this.getDisplayObject());
      }
      
      public function removeFromStage(stage:DCStage) : void
      {
         stage.removeChild(this.getDisplayObject());
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return null;
      }
      
      public function logicUpdate(dt:int) : void
      {
         if(this.mScreenCamera != null)
         {
            this.screenLogicUpdate(dt);
         }
      }
      
      public function zoom(z:Number) : void
      {
         if(this.mScreenCamera != null)
         {
            this.mScreenCameraNeedsToBeUpdated = true;
         }
      }
      
      public function getScaleX() : Number
      {
         return 1;
      }
      
      public function getScaleY() : Number
      {
         return 1;
      }
      
      public function contains(d:*) : Boolean
      {
         return this.mChilds.indexOf(d) > -1;
      }
      
      public function cameraSetXY(x:int, y:int) : void
      {
         this.mCameraX = x;
         this.mCameraY = y;
         if(this.mScreenCamera != null)
         {
            this.mScreenCameraNeedsToBeUpdated = true;
         }
      }
      
      public function get cameraX() : int
      {
         return this.mCameraX;
      }
      
      public function get cameraY() : int
      {
         return this.mCameraY;
      }
      
      public function onResize(w:Number, h:Number) : void
      {
      }
      
      public function get needCamera() : Boolean
      {
         return this.mNeedCamera;
      }
      
      public function get needZoom() : Boolean
      {
         return this.mNeedZoom;
      }
      
      private function screenLoad() : void
      {
         this.mScreenItemsIn = new Vector.<DCDisplayObject>(0);
         this.mScreenItemsOut = new Vector.<DCDisplayObject>(0);
         this.mScreenItemsOutTemp = new Vector.<DCDisplayObject>(0);
      }
      
      private function screenUnload() : void
      {
         this.mScreenItemsIn = null;
         this.mScreenItemsOut = null;
         this.mScreenItemsOutTemp = null;
      }
      
      public function screenIsInScreen(child:DCDisplayObject) : Boolean
      {
         return this.mScreenCamera.cameraGetBox().collides(child.mBoundingBox,this.getScaleX(),this.getScaleY());
      }
      
      public function screenIsInScreenWithCamera(cameraBox:DCBox, child:DCDisplayObject) : Boolean
      {
         return cameraBox.collides(child.mBoundingBox,this.getScaleX(),this.getScaleY());
      }
      
      public function screenChangeCamera() : void
      {
         var i:int = 0;
         var d:DCDisplayObject = null;
         var length:int = 0;
         if(this.mScreenCamera != null)
         {
            this.mScreenItemsOutTemp.length = 0;
            length = int(this.mScreenItemsIn.length);
            for(i = 0; i < length; )
            {
               d = this.mScreenItemsIn[i];
               if(this.screenIsInScreen(d))
               {
                  i++;
               }
               else
               {
                  d.mIsOnScreen = false;
                  this.mScreenItemsOutTemp.push(d);
                  this.screenInRemoveItem(d);
                  length = int(this.mScreenItemsIn.length);
               }
            }
            length = int(this.mScreenItemsOut.length);
            for(i = 0; i < length; )
            {
               d = this.mScreenItemsOut[i];
               if(this.screenIsInScreen(d))
               {
                  d.mIsOnScreen = true;
                  this.mScreenItemsOut.splice(i,1);
                  length = int(this.mScreenItemsOut.length);
                  this.screenInAddItem(d);
               }
               else
               {
                  i++;
               }
            }
            length = int(this.mScreenItemsOutTemp.length);
            for(i = 0; i < length; )
            {
               this.mScreenItemsOut.push(this.mScreenItemsOutTemp[i]);
               i++;
            }
         }
      }
      
      public function screenRefresh() : void
      {
         if(this.mScreenCamera != null)
         {
            this.mScreenCameraNeedsToBeUpdated = true;
            this.screenLogicUpdate(0);
         }
      }
      
      protected function screenLogicUpdate(dt:int) : void
      {
         if(this.mScreenCameraNeedsToBeUpdated)
         {
            this.screenChangeCamera();
            this.mScreenCameraNeedsToBeUpdated = false;
         }
      }
      
      protected function screenAddChild(child:DCDisplayObject) : void
      {
         child.mIsOnScreen = this.screenIsInScreen(child);
         if(child.mIsOnScreen)
         {
            this.screenInAddItem(child);
         }
         else
         {
            this.screenOutAddItem(child);
         }
      }
      
      private function screenRemoveChild(child:DCDisplayObject) : void
      {
         if(child.mIsOnScreen)
         {
            this.screenInRemoveItem(child);
         }
         else
         {
            this.screenOutRemoveItem(child);
         }
      }
      
      protected function screenInAddItem(item:DCDisplayObject) : void
      {
         var i:int = 0;
         var length:int = 0;
         var thisBox:DCBox = null;
         var itemBox:DCBox = item.getSortingBox();
         var needsToPush:Boolean = true;
         var index:* = -1;
         if(itemBox != null)
         {
            length = int(this.mScreenItemsIn.length);
            for(i = 0; i < length; )
            {
               thisBox = this.mScreenItemsIn[i].getSortingBox();
               if(itemBox.isBehind(thisBox))
               {
                  this.mScreenItemsIn.splice(i,0,item);
                  needsToPush = false;
                  index = i;
                  break;
               }
               i++;
            }
         }
         if(needsToPush)
         {
            this.mScreenItemsIn.push(item);
         }
         this.addChildToDisplayList(item,index);
      }
      
      protected function screenInRemoveItem(item:DCDisplayObject) : void
      {
         var pos:int = this.mScreenItemsIn.indexOf(item);
         if(pos > -1)
         {
            this.mScreenItemsIn.splice(pos,1);
            this.removeChildFromDisplayList(item);
         }
      }
      
      private function screenOutAddItem(item:DCDisplayObject) : void
      {
         this.mScreenItemsOut.push(item);
      }
      
      private function screenOutRemoveItem(item:DCDisplayObject) : void
      {
         var pos:int = this.mScreenItemsOut.indexOf(item);
         if(pos > -1)
         {
            this.mScreenItemsOut.splice(pos,1);
         }
      }
      
      public function childSetXY(child:DCDisplayObject, x:Number, y:Number) : void
      {
         var wasInScreen:Boolean = false;
         if(child.x != x || child.y != y)
         {
            if(this.mScreenCamera != null)
            {
               if(wasInScreen = child.mIsOnScreen)
               {
                  this.screenInRemoveItem(child);
               }
            }
            child.x = x;
            child.y = y;
            if(this.mScreenCamera != null)
            {
               child.mIsOnScreen = this.screenIsInScreen(child);
               if(!wasInScreen && child.mIsOnScreen)
               {
                  this.screenOutRemoveItem(child);
               }
               if(child.mIsOnScreen)
               {
                  this.screenInAddItem(child);
               }
               else if(wasInScreen)
               {
                  this.screenOutAddItem(child);
               }
            }
         }
      }
   }
}
