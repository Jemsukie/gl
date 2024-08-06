package esparragon.layout
{
   import esparragon.core.Esparragon;
   import esparragon.layout.behaviors.ELayoutBehavior;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public final class ELayoutAreaFactory
   {
       
      
      private var mAreaCollection:Dictionary;
      
      protected var mContainer:DisplayObjectContainer;
      
      private var mColorsToBehaviors:Dictionary;
      
      public function ELayoutAreaFactory(container:DisplayObjectContainer, colorsToBehaviors:Dictionary)
      {
         super();
         this.mContainer = container;
         this.mAreaCollection = new Dictionary();
         this.mColorsToBehaviors = colorsToBehaviors;
      }
      
      public static function createLayoutArea(width:int = 0, height:int = 0) : ELayoutArea
      {
         var returnValue:ELayoutArea = new ELayoutArea();
         returnValue.width = width;
         returnValue.height = height;
         return returnValue;
      }
      
      public static function createLayoutAreaFromLayoutArea(area:ELayoutArea, copyType:int = -1) : ELayoutArea
      {
         if(copyType == -1)
         {
            copyType = 0;
         }
         return new ELayoutArea(area,copyType);
      }
      
      public static function createLayoutTextAreaFromLayoutTextArea(area:ELayoutTextArea) : ELayoutTextArea
      {
         return new ELayoutTextArea(area);
      }
      
      public static function createLayoutTextAreaFromLayoutArea(area:ELayoutArea, newAreaName:String = "name") : ELayoutTextArea
      {
         var textArea:ELayoutTextArea = new ELayoutTextArea();
         textArea.width = area.width;
         textArea.height = area.height;
         textArea.x = area.x;
         textArea.y = area.y;
         textArea.name = newAreaName;
         return textArea;
      }
      
      public function destroy() : void
      {
         var k:* = null;
         var area:ELayoutArea = null;
         this.mContainer = null;
         for(k in this.mAreaCollection)
         {
            area = this.mAreaCollection[k] as ELayoutArea;
            area.destroy();
            delete this.mAreaCollection[k];
         }
         this.mAreaCollection = null;
         this.mColorsToBehaviors = null;
      }
      
      public function getDisplayObjectContainer() : DisplayObjectContainer
      {
         return this.mContainer;
      }
      
      public function areaExist(name:String) : Boolean
      {
         return this.mContainer.getChildByName(name) != null;
      }
      
      public function getAreaWrapper() : ELayoutArea
      {
         var mostLeft:Number = NaN;
         var mostRight:* = NaN;
         var mostTop:Number = NaN;
         var mostBottom:* = NaN;
         var value:Number = NaN;
         var child:DisplayObject = null;
         var numChildren:int = 0;
         var i:int = 0;
         var width:int = 0;
         var height:int = 0;
         if(this.mContainer != null)
         {
            mostLeft = 1.7976931348623157e+308;
            mostRight = -Number.MIN_VALUE;
            mostTop = 1.7976931348623157e+308;
            mostBottom = -Number.MIN_VALUE;
            numChildren = this.mContainer.numChildren;
            for(i = 0; i < numChildren; )
            {
               if((child = this.mContainer.getChildAt(i)) != null)
               {
                  if(child.x < mostLeft)
                  {
                     mostLeft = child.x;
                  }
                  if(child.y < mostTop)
                  {
                     mostTop = child.y;
                  }
                  if((value = child.x + child.width) > mostRight)
                  {
                     mostRight = value;
                  }
                  if((value = child.y + child.height) > mostBottom)
                  {
                     mostBottom = value;
                  }
               }
               i++;
            }
            if(mostLeft != 1.7976931348623157e+308 && mostRight != -Number.MIN_VALUE)
            {
               width = mostRight - mostLeft;
            }
            if(mostTop != 1.7976931348623157e+308 && mostBottom != -Number.MIN_VALUE)
            {
               height = mostBottom - mostTop;
            }
         }
         return createLayoutArea(width,height);
      }
      
      public function getArea(name:String) : ELayoutArea
      {
         var displayObject:DisplayObject = null;
         var area:ELayoutArea = this.mAreaCollection[name] as ELayoutArea;
         if(area == null)
         {
            displayObject = this.getChildByStartingName(name);
            if(displayObject == null)
            {
               Esparragon.traceMsg("[ELayoutAreaFactorySWF] area \'" + name + "\' doesn\'t exist in the container \'" + this.mContainer.name + "\'","E_ERROR");
               return null;
            }
            area = this.createAreaFromDisplayObject(displayObject,name);
            this.mAreaCollection[name] = area;
         }
         return area;
      }
      
      public function getTextArea(name:String) : ELayoutTextArea
      {
         var displayObject:TextField = null;
         var area:ELayoutTextArea = this.mAreaCollection[name] as ELayoutTextArea;
         if(area == null)
         {
            displayObject = this.getChildByStartingName(name) as TextField;
            if(displayObject == null)
            {
               Esparragon.traceMsg("[ELayoutAreaFactorySWF] area \'" + name + "\' doesn\'t exist in the container \'" + this.mContainer.name + "\'","E_ERROR");
               return null;
            }
            area = new ELayoutTextArea();
            area.parseFromDisplayObject(displayObject,name);
            this.mAreaCollection[name] = area;
         }
         return area;
      }
      
      private function getChildByStartingName(name:String) : DisplayObject
      {
         var i:int = 0;
         var child:DisplayObject = null;
         var numChild:int = this.mContainer.numChildren;
         for(i = 0; i < numChild; )
         {
            if((child = this.mContainer.getChildAt(i)).name.split("$")[0] == name)
            {
               return child;
            }
            i++;
         }
         return null;
      }
      
      public function getAreaCollection() : Dictionary
      {
         return this.mAreaCollection;
      }
      
      public function getContainerLayoutArea() : ELayoutArea
      {
         var name:String = "factoryContainer";
         var area:ELayoutArea = this.mAreaCollection[name] as ELayoutArea;
         if(area == null)
         {
            area = this.createAreaFromDisplayObject(this.mContainer,name);
            this.mAreaCollection[name] = area;
         }
         return area;
      }
      
      private function createAreaFromDisplayObject(displayObject:DisplayObject, name:String) : ELayoutArea
      {
         var behavior:ELayoutBehavior = null;
         var area:ELayoutArea = createLayoutArea();
         area.parseFromDisplayObject(displayObject,name);
         var color:uint = area.getColor();
         if(this.mColorsToBehaviors[color] != null)
         {
            behavior = this.mColorsToBehaviors[color];
         }
         if(behavior != null)
         {
            area.addBehavior(behavior);
         }
         return area;
      }
   }
}
