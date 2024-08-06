package com.dchoc.toolkit.view.map
{
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.perspective.DCMapPerspective;
   import com.dchoc.toolkit.view.map.perspective.DCMapPerspectiveIsometric;
   import com.dchoc.toolkit.view.map.perspective.DCMapPerspectiveTopDown;
   import esparragon.utils.EUtils;
   
   public class DCMapViewDef extends DCDef
   {
      
      public static const MAP_VIEW_ISO_ID:int = 0;
      
      public static const MAP_VIEW_TOPDOWN_ID:int = 1;
      
      public static const MAP_VIEW_ISO_SKU:String = "iso";
      
      public static const MAP_VIEW_TOPDOWN_SKU:String = "topDown";
      
      public static const MAP_VIEW_SKUS:Array = ["iso","topDown"];
       
      
      private var mDeclination:Number = 0;
      
      public var mTileViewWidth:int = 0;
      
      public var mTileViewHeight:int = 0;
      
      public var mTileLogicWidth:int = 0;
      
      public var mTileLogicHeight:int = 0;
      
      public var mTilesPerRow:int = 0;
      
      public var mPerspective:DCMapPerspective;
      
      private var mUseOnlyInDebug:Boolean = false;
      
      public function DCMapViewDef()
      {
         super();
      }
      
      public static function createMapViewDefaultDefinition(sku:String) : DCMapViewDef
      {
         var returnValue:DCMapViewDef = new DCMapViewDef();
         returnValue.mSku = sku;
         var tileViewWidth:int = 32;
         var tileViewHeight:int = 32;
         var _loc5_:* = sku;
         if("iso" === _loc5_)
         {
            tileViewWidth = 64;
            returnValue.setDeclination(30);
         }
         returnValue.setTileViewWidth(tileViewWidth);
         returnValue.setTileViewHeight(tileViewHeight);
         returnValue.build();
         return returnValue;
      }
      
      private function setDeclination(value:Number) : void
      {
         this.mDeclination = value;
      }
      
      private function setTileViewWidth(value:int) : void
      {
         this.mTileViewWidth = value;
      }
      
      private function setTileViewHeight(value:int) : void
      {
         this.mTileViewHeight = value;
      }
      
      private function setTileLogicWidth(value:int) : void
      {
         this.mTileLogicWidth = value;
      }
      
      private function setTileLogicHeight(value:int) : void
      {
         this.mTileLogicHeight = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "declination";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeclination(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "tilesPerRow";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mTilesPerRow = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "tileViewWidth";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTileViewWidth(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "tileViewHeight";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTileViewHeight(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "usesOnlyInDebug";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mUseOnlyInDebug = EUtils.xmlReadBoolean(info,attribute);
         }
         if(this.mUseOnlyInDebug && !Config.DEBUG_MODE)
         {
            mResourceName = null;
         }
      }
      
      override public function build() : void
      {
         var coor:DCCoordinate = null;
         switch(mSku)
         {
            case "iso":
               this.mPerspective = new DCMapPerspectiveIsometric(this.mDeclination);
               coor = new DCCoordinate();
               coor.x = this.mTileViewWidth;
               coor.y = 0;
               this.setTileLogicWidth(this.mPerspective.screenToMap(coor).z);
               coor.x = 0;
               coor.y = this.mTileViewHeight;
               this.setTileLogicHeight(-this.mPerspective.screenToMap(coor).z);
               break;
            case "topDown":
               this.mPerspective = new DCMapPerspectiveTopDown();
               this.setTileLogicWidth(this.mTileViewWidth);
               this.setTileLogicHeight(this.mTileViewHeight);
         }
      }
      
      override public function requestResources(resourceMng:DCResourceMng, directoryPath:String) : void
      {
         var fileName:String = null;
         if(mResourceName != null)
         {
            fileName = directoryPath + mResourceName;
            resourceMng.catalogAddTileset(mResourceName,fileName);
         }
      }
      
      public function needsToWaitForResource() : Boolean
      {
         return mResourceName != null;
      }
   }
}
