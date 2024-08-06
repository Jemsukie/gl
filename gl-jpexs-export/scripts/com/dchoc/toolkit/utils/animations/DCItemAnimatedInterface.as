package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.DisplayObjectContainer;
   
   public interface DCItemAnimatedInterface
   {
       
      
      function viewLoad() : void;
      
      function viewUnload() : void;
      
      function viewReset() : void;
      
      function viewGetLayersCount() : int;
      
      function viewLayersTypeRequiredGetAll() : Array;
      
      function viewLayersTypeRequiredGet(param1:int) : int;
      
      function viewLayersTypeRequiredSet(param1:int, param2:int) : void;
      
      function viewLayersTypeCurrentGetAll() : Array;
      
      function viewLayersTypeCurrentGet(param1:int) : int;
      
      function viewLayersTypeCurrentSet(param1:int, param2:int) : void;
      
      function viewLayersImpCurrentGetAll() : Array;
      
      function viewLayersImpCurrentGet(param1:int) : int;
      
      function viewLayersImpCurrentSet(param1:int, param2:int) : void;
      
      function viewLayersAnimGet(param1:int) : DCDisplayObject;
      
      function viewLayersAnimSet(param1:int, param2:DCDisplayObject) : void;
      
      function viewGetAnimSkus(param1:Vector.<String>, param2:int = -1) : void;
      
      function viewLayersAddToStage(param1:int) : void;
      
      function viewLayersRemoveFromStage(param1:int) : void;
      
      function viewLayersIsAllowedToBeDraw(param1:int) : Boolean;
      
      function viewIsAllowedToBeDraw() : Boolean;
      
      function viewGetWorldX() : int;
      
      function viewGetWorldY() : int;
      
      function viewGetWorldZ() : int;
      
      function viewSetWorldZ(param1:int) : void;
      
      function viewSetWorldX(param1:int) : void;
      
      function viewSetWorldY(param1:int) : void;
      
      function viewGetAnchorX() : int;
      
      function viewGetAnchorY() : int;
      
      function viewGetCollisionBoxPackageSku() : String;
      
      function viewLayersGetWorldXY(param1:int, param2:DCCoordinate, param3:int = -1) : void;
      
      function viewLayersGetScaleXY(param1:int, param2:DCCoordinate) : void;
      
      function viewIsLayerFlipped(param1:int) : Boolean;
      
      function viewLayersGetBoundingBox(param1:int) : DCBox;
      
      function viewLayersGetSortingBox(param1:int) : DCBox;
      
      function viewLayersGetAttribute(param1:int, param2:String) : Object;
      
      function viewLayersSetAttribute(param1:Object, param2:int, param3:String) : void;
      
      function viewLayersGetTimer(param1:int) : int;
      
      function viewLayersSetTimer(param1:int, param2:int) : void;
      
      function viewAddUIEvents(param1:int) : void;
      
      function viewRemoveUIEvents(param1:int) : void;
      
      function viewGetAttachedClip(param1:int) : Vector.<DisplayObjectContainer>;
      
      function viewMustApplyOffset() : Boolean;
      
      function setLayerDirty(param1:int, param2:Boolean) : void;
      
      function viewLayersCheckFilters(param1:int) : void;
      
      function viewGetImpId(param1:int) : int;
   }
}
