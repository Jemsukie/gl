package com.dchoc.game.view.dc.gui.components
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCContent;
   import flash.display.DisplayObjectContainer;
   import flash.utils.describeType;
   
   public class GUIBar extends GUIComponent
   {
       
      
      protected var mElements:Array;
      
      protected var mNumElements:int;
      
      public function GUIBar(assetName:String)
      {
         super(assetName);
      }
      
      override protected function uiEnableDoDo() : void
      {
         var element:DCContent = null;
         for each(element in this.mElements)
         {
            element.addMouseEvents();
         }
      }
      
      override protected function uiDisableDoDo() : void
      {
         var element:DCContent = null;
         for each(element in this.mElements)
         {
            element.removeMouseEvents();
         }
      }
      
      override public function addMouseEvents() : void
      {
         var element:DCContent = null;
         for each(element in this.mElements)
         {
            element.addMouseEvents();
         }
         super.addMouseEvents();
      }
      
      override public function removeMouseEvents() : void
      {
         var element:DCContent = null;
         for each(element in this.mElements)
         {
            element.removeMouseEvents();
         }
         super.removeMouseEvents();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mElements = [];
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mElements = null;
      }
      
      override protected function unbuildDo() : void
      {
         var elem:DCContent = null;
         for each(elem in this.mElements)
         {
            if(mBox.contains(elem.getForm()))
            {
               mBox.removeChild(elem.getForm());
            }
         }
         this.mElements.length = 0;
      }
      
      override public function fillInfo(contentInfo:*, firstResource:int = 0) : void
      {
         var def:DCDef = null;
         var elem:DCContent = null;
         var i:* = 0;
         var childBox:DisplayObjectContainer = null;
         var vectorResourcesInfo:Vector.<DCDef>;
         var vectorLength:int = int((vectorResourcesInfo = contentInfo).length);
         var elementLength:int = int(this.mElements.length);
         for(var max:int,i = (max = Math.min(vectorLength - firstResource,elementLength)) - 1; i >= 0; )
         {
            def = vectorResourcesInfo[firstResource + i];
            elem = this.mElements[i];
            elem.fillInfo(def);
            childBox = elem.getForm();
            if(!mBox.contains(childBox))
            {
               mBox.addChild(childBox);
            }
            i--;
         }
         for(i = max; i < elementLength; )
         {
            elem = this.mElements[i];
            childBox = elem.getForm();
            if(mBox.contains(childBox))
            {
               mBox.removeChild(childBox);
            }
            i++;
         }
      }
      
      override public function removeViewElements() : void
      {
         var elem:DCContent = null;
         for each(elem in this.mElements)
         {
            elem.removeViewElements();
         }
      }
      
      public function setResourcesButtonVisibility(tag:String, value:Boolean) : void
      {
         var elem:DCContent = null;
         var displ:DisplayObjectContainer = null;
         for each(elem in this.mElements)
         {
            if(displ = elem.getForm().getChildByName(tag) as DisplayObjectContainer)
            {
               displ.visible = value;
            }
         }
      }
      
      public function getElementByName(className:String, nth:int = 0) : DCContent
      {
         var elem:DCContent = null;
         var elemClassName:String = null;
         var i:int = 0;
         for each(elem in this.mElements)
         {
            if((elemClassName = describeType(elem.getForm()).@name) == className)
            {
               if(nth == i++)
               {
                  return elem;
               }
            }
         }
         return null;
      }
   }
}
