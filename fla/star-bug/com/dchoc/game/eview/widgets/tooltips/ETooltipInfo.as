package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.model.world.ship.ShipDef;
   import esparragon.behaviors.EBehavior;
   import esparragon.display.ESprite;
   import flash.utils.Dictionary;
   
   public class ETooltipInfo
   {
      
      public static const ANCHOR_POINT_CENTER:String = "center";
      
      public static const ANCHOR_POINT_TOP_LEFT:String = "top_left";
      
      public static const TYPE_SIMPLE:int = 0;
      
      public static const TYPE_COMPLEX:int = 1;
      
      public static const TYPE_COMPLEX_WITH_ICONS:int = 2;
      
      public static const DEFAULT_HORIZONTAL_PADDING:int = 8;
      
      public static const DEFAULT_VERTICAL_PADDING:int = 8;
      
      public static const ELEMENT_TEXT:String = "text";
      
      public static const ELEMENT_ICON_TEXT:String = "iconText";
      
      public static const ELEMENT_ICON_TWO_TEXTS:String = "iconTwoTexts";
      
      public static const ELEMENT_FILLBAR_RESOURCES:String = "fillbarResources";
      
      public static const ELEMENT_FILLBAR_ICON:String = "fillbarIcon";
      
      public static const ELEMENT_FILLBAR_TIME:String = "fillbarTime";
      
      public static const ELEMENT_BUTTON:String = "button";
      
      public static const ELEMENT_ICON_UNIT:String = "iconUnit";
      
      public static const BLOCK_TYPE_ROW:String = "row";
      
      public static const BLOCK_TYPE_COLUMN:String = "column";
      
      public static const BLOCK_TYPE_COLUMN_SHIP:String = "ship_column";
       
      
      public var espriteRef:ESprite;
      
      public var type:int;
      
      public var text:String;
      
      public var textPropSku:String;
      
      public var title:String;
      
      public var anchorPoint:String;
      
      public var bkgPropSku:String;
      
      private var mParams:Dictionary;
      
      public var blockHorizontalPadding:int = 8;
      
      public var blockVerticalPadding:int = 8;
      
      private var mElements:Array;
      
      private var behaviors:Vector.<EBehavior>;
      
      private var mCurrentBlock:Array;
      
      public function ETooltipInfo()
      {
         super();
         this.mElements = [];
         this.behaviors = new Vector.<EBehavior>(0);
         this.mParams = new Dictionary();
         this.mCurrentBlock = null;
         this.bkgPropSku = "tooltip_bkg";
      }
      
      public function destroy() : void
      {
         this.espriteRef = null;
         this.behaviors = null;
         this.mElements = null;
         this.mParams = null;
         this.mCurrentBlock = null;
      }
      
      public function beginBlockOfElements(type:String) : void
      {
         if(this.mCurrentBlock)
         {
            throw new Error("ETooltipInfo:: Cannot begin a block while a block has already begun");
         }
         this.mCurrentBlock = [type];
      }
      
      public function endBlockOfElements() : void
      {
         if(!this.mCurrentBlock)
         {
            throw new Error("ETooltipInfo:: Cannot end a block that has not begun");
         }
         if(this.mCurrentBlock.length)
         {
            this.mElements.push(this.mCurrentBlock);
         }
         this.mCurrentBlock = null;
      }
      
      public function addElementText(text:String, propSku:String = null) : void
      {
         this.add({
            "type":"text",
            "text":text,
            "propSku":propSku
         });
      }
      
      public function addElementIconText(resource:String, text:String, propSku:String = null) : void
      {
         this.add({
            "type":"iconText",
            "resource":resource,
            "text":text,
            "propSku":propSku
         });
      }
      
      public function addElementIconTwoTexts(resource:String, topText:String, bottomText:String, propSku:String = null) : void
      {
         this.add({
            "type":"iconTwoTexts",
            "resource":resource,
            "topText":topText,
            "bottomText":bottomText,
            "topPropSku":"text_subheader_1",
            "bottomPropSku":propSku
         });
      }
      
      public function addElementFillbarResources(resource:String, value:Number, maxValue:Number) : void
      {
         this.add({
            "type":"fillbarResources",
            "resource":resource,
            "value":value,
            "maxValue":maxValue
         });
      }
      
      public function addElementFillbarIcon(resource:String, value:Number, maxValue:Number, topText:String = null, bottomText:String = null, layoutName:String = null) : void
      {
         if(layoutName == null)
         {
            layoutName = "IconBarXS";
         }
         this.add({
            "type":"fillbarIcon",
            "resource":resource,
            "value":value,
            "maxValue":maxValue,
            "topText":topText,
            "bottomText":bottomText,
            "layoutName":layoutName
         });
      }
      
      public function addElementFillbarTime(resource:String, onUpdateFunc:Function, onUpdateParams:Array) : void
      {
         this.add({
            "type":"fillbarTime",
            "updateFunction":onUpdateFunc,
            "updateParams":onUpdateParams,
            "resource":resource
         });
      }
      
      public function addElementButton(text:String, callback:Function) : void
      {
         this.add({
            "type":"button",
            "text":text,
            "callback":callback
         });
      }
      
      public function addElementIconUnit(sku:String, def:ShipDef, amount:int, size:int, customPadding:int = 0) : void
      {
         this.add({
            "type":"iconUnit",
            "sku":sku,
            "def":def,
            "amount":amount,
            "size":size,
            "customPadding":customPadding
         });
      }
      
      private function add(object:Object) : void
      {
         if(this.mCurrentBlock)
         {
            this.mCurrentBlock.push(object);
         }
         else
         {
            this.mElements.push(object);
         }
      }
      
      public function getElements() : Array
      {
         return this.mElements;
      }
      
      public function addBehavior(behavior:EBehavior) : void
      {
         this.behaviors.push(behavior);
      }
      
      public function getBehaviors() : Vector.<EBehavior>
      {
         return this.behaviors;
      }
      
      public function setParam(key:String, value:Object) : void
      {
         this.mParams[key] = value;
      }
      
      public function getParam(key:String) : Object
      {
         return this.mParams[key];
      }
      
      public function containsButton() : Boolean
      {
         for each(var elem in this.mElements)
         {
            if(elem.type == "button")
            {
               return true;
            }
         }
         return false;
      }
   }
}
