package com.dchoc.game.core.view.display.layer
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.layer.DCLayerSWF;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.math.geom.DCBoxWithTiles;
   
   public class LayerSWF extends DCLayerSWF
   {
       
      
      private var numChildLast:int;
      
      private var mRefresh:Boolean;
      
      private var framesFromLastUpdate:int;
      
      protected var sortChildrenByZRefreshCounter:int = 0;
      
      public function LayerSWF(needCamera:Boolean = false, needZoom:Boolean = false, screenCamera:DCViewMng = null)
      {
         super(needCamera,needZoom,screenCamera);
      }
      
      override public function onResize(w:Number, h:Number) : void
      {
         super.onResize(w,h);
         this.mRefresh = true;
      }
      
      override protected function screenInAddItem(item:DCDisplayObject) : void
      {
         mScreenItemsIn.push(item);
         addChildToDisplayList(item);
      }
      
      override protected function screenInRemoveItem(item:DCDisplayObject) : void
      {
         var pos:int = mScreenItemsIn.indexOf(item);
         if(pos > -1)
         {
            mScreenItemsIn.splice(pos,1);
            removeChildFromDisplayList(item);
         }
      }
      
      override protected function screenAddChild(child:DCDisplayObject) : void
      {
         child.mIsOnScreen = true;
         this.screenInAddItem(child);
         this.mRefresh = true;
      }
      
      private function sortChildrenByZ() : void
      {
         var i:int = 0;
         var resort:Boolean = false;
         var box:DCBoxWithTiles = null;
         var length:int = 0;
         var object:DCDisplayObject = null;
         var childList:Array = [];
         i = int(mScreenItemsIn.length);
         while(i--)
         {
            childList[i] = mScreenItemsIn[i];
            box = childList[i].getSortingBox();
            childList[i].mZDepth = (mScreenItemsIn[i].getSortingBox() as DCBoxWithTiles).isoOrder;
         }
         childList.sortOn("mZDepth",16);
         i = int(mScreenItemsIn.length);
         while(i--)
         {
            box = childList[i].getSortingBox();
            if(childList[i] != mScreenItemsIn[i])
            {
               resort = true;
               mScreenItemsIn.splice(mScreenItemsIn.indexOf(childList[i]),1);
               mScreenItemsIn.splice(i,0,childList[i]);
            }
         }
         if(resort)
         {
            length = int(mScreenItemsIn.length);
            for(i = 0; i < length; )
            {
               object = mScreenItemsIn[i];
               removeChildFromDisplayList(object);
               addChildToDisplayList(object);
               i++;
            }
         }
      }
      
      override public function childSetXY(child:DCDisplayObject, x:Number, y:Number) : void
      {
         if(x != child.x || y != child.y)
         {
            child.x = x;
            child.y = y;
            if(Config.FIX_UNIT_NOT_DRAWN_WHEN_ENTERING_IN_CAMERA && !mScreenCameraNeedsToBeUpdated && child.mIsOnScreen != screenIsInScreen(child))
            {
               mScreenCameraNeedsToBeUpdated = true;
            }
         }
      }
      
      override protected function screenLogicUpdate(dt:int) : void
      {
         var i:int = 0;
         super.screenLogicUpdate(dt);
         if(++this.framesFromLastUpdate >= 2 || this.mRefresh)
         {
            this.framesFromLastUpdate = 0;
            if(!Config.FIX_UNIT_NOT_DRAWN_WHEN_ENTERING_IN_CAMERA)
            {
               if(this.numChildLast != mScreenItemsIn.length)
               {
                  for(i = 0; i < mChilds.length; )
                  {
                     if(mScreenItemsIn.indexOf(mChilds[i]) == -1)
                     {
                        removeChildFromDisplayList(mChilds[i--]);
                     }
                     i++;
                  }
               }
            }
            if(mScreenItemsIn.length == 0)
            {
               return;
            }
            this.sortChildrenByZRefreshCounter += dt;
            if(this.sortChildrenByZRefreshCounter > (Config.USE_LAZY_LOGIC_UPDATES ? 700 : 0))
            {
               this.sortChildrenByZ();
               this.sortChildrenByZRefreshCounter = 0;
            }
            this.mRefresh = false;
            return;
         }
      }
   }
}
