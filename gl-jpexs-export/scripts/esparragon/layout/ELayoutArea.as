package esparragon.layout
{
   import esparragon.display.ESprite;
   import esparragon.layout.behaviors.ELayoutBehavior;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class ELayoutArea
   {
      
      public static const COLLISION_BOX_COLOR_ADJUST:uint = 16711680;
      
      public static const COPY_TYPE_EVERYTHING:int = 0;
      
      public static const COPY_TYPE_ONLY_AREA_SIZE:int = 1;
      
      public static const COPY_TYPE_ONLY_AREA_POSITION:int = 2;
       
      
      public var name:String;
      
      public var x:int;
      
      public var y:int;
      
      private var originalWidth:int;
      
      public var width:int;
      
      public var height:int;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var pivotX:Number = 0;
      
      public var pivotY:Number = 0;
      
      public var flipH:Boolean;
      
      public var flipV:Boolean;
      
      public var rotation:Number = 0;
      
      public var rectangle:Rectangle;
      
      public var index:int;
      
      public var param:String;
      
      public var collBoxColor:uint;
      
      private var mBehaviors:Vector.<ELayoutBehavior>;
      
      private var mIsSetPositionEnabled:Boolean = true;
      
      public function ELayoutArea(area:ELayoutArea = null, copyType:int = 0)
      {
         super();
         if(area != null)
         {
            this.name = area.name;
            this.x = area.x;
            this.y = area.y;
            this.width = area.width;
            this.height = area.height;
            this.scaleX = area.scaleX;
            this.scaleY = area.scaleY;
            this.flipH = area.flipH;
            this.flipV = area.flipV;
            this.rotation = area.rotation;
            this.originalWidth = area.originalWidth;
            if(area.rectangle != null)
            {
               this.rectangle = new Rectangle(area.rectangle.x,area.rectangle.y,area.rectangle.width,area.rectangle.height);
            }
            this.isSetPositionEnabled = area.isSetPositionEnabled;
            this.index = area.index;
            this.copyBehaviors(area);
            switch(copyType - 1)
            {
               case 0:
                  this.x = 0;
                  this.y = 0;
                  this.scaleX = 1;
                  this.scaleY = 1;
                  this.rotation = 0;
                  this.flipH = false;
                  this.flipV = false;
                  break;
               case 1:
                  this.removeBehaviors();
            }
         }
      }
      
      public function destroy() : void
      {
         this.rectangle = null;
         if(this.mBehaviors != null)
         {
            this.mBehaviors = null;
         }
      }
      
      public function centerContent(content:ESprite) : void
      {
         if(content)
         {
            content.logicLeft = this.x + (this.width - content.getLogicWidth()) / 2;
            content.logicTop = this.y + (this.height - content.getLogicHeight()) / 2;
         }
      }
      
      public function centerContents(contents:Array, cols:int, rows:int, applyBodyPos:Boolean = false) : void
      {
         var boxCount:int = 0;
         var boxWidth:Number = NaN;
         var boxHeight:Number = NaN;
         var box:ESprite = null;
         var i:int = 0;
         var freeSpace:Number = NaN;
         var hSeparation:int = 0;
         var vSeparation:Number = NaN;
         var index:int = 0;
         var j:int = 0;
         if(contents != null)
         {
            boxCount = int(contents.length);
            boxWidth = 0;
            boxHeight = 0;
            for(i = 0; i < boxCount; )
            {
               box = contents[i];
               boxWidth = Math.max(boxWidth,box.getLogicWidth());
               boxHeight = Math.max(boxHeight,box.getLogicHeight());
               i++;
            }
            hSeparation = (freeSpace = this.width - boxWidth * cols) / (cols + 1);
            vSeparation = (freeSpace = this.height - boxHeight * rows) / (rows + 1);
            for(i = 0; i < rows; )
            {
               for(j = 0; j < cols; )
               {
                  if((index = i * cols + j) < boxCount)
                  {
                     (box = contents[index]).logicLeft = this.x + hSeparation + (boxWidth + hSeparation) * j;
                     box.logicTop = this.y + vSeparation + (boxHeight + vSeparation) * i;
                  }
                  j++;
               }
               i++;
            }
         }
      }
      
      public function getOriginalWidth() : int
      {
         return this.originalWidth;
      }
      
      public function setOriginalWidth(value:int) : void
      {
         this.originalWidth = value;
      }
      
      public function getOriginalHeight() : int
      {
         return this.height / this.scaleY;
      }
      
      public function getColor() : uint
      {
         return this.collBoxColor;
      }
      
      public function addBehavior(behavior:ELayoutBehavior) : void
      {
         if(behavior != null)
         {
            if(this.mBehaviors == null)
            {
               this.mBehaviors = new Vector.<ELayoutBehavior>(0);
            }
            this.mBehaviors.push(behavior);
         }
      }
      
      public function removeBehaviors() : void
      {
         this.mBehaviors = null;
      }
      
      public function hasBehavior(nameClass:Class) : Boolean
      {
         var behavior:ELayoutBehavior = null;
         var length:int = 0;
         var i:int = 0;
         var returnValue:Boolean = false;
         if(this.mBehaviors != null)
         {
            length = int(this.mBehaviors.length);
            i = 0;
            while(i < length && !returnValue)
            {
               returnValue = (behavior = this.mBehaviors[i]) != null && behavior is nameClass;
               i++;
            }
         }
         return returnValue;
      }
      
      public function performBehaviors(content:ESprite) : void
      {
         var behavior:ELayoutBehavior = null;
         if(this.mBehaviors != null)
         {
            for each(behavior in this.mBehaviors)
            {
               behavior.perform(content,this);
            }
         }
      }
      
      public function getBehaviors() : Vector.<ELayoutBehavior>
      {
         return this.mBehaviors;
      }
      
      private function copyBehaviors(area:ELayoutArea) : void
      {
         var count:int = 0;
         var i:int = 0;
         var behaviors:Vector.<ELayoutBehavior> = area.getBehaviors();
         if(behaviors != null)
         {
            count = int(behaviors.length);
            if(count > 0)
            {
               if(this.mBehaviors == null)
               {
                  this.mBehaviors = new Vector.<ELayoutBehavior>(count,true);
               }
               i = 0;
               while(i < count)
               {
                  this.mBehaviors[i] = behaviors[i];
                  i++;
               }
            }
         }
      }
      
      public function get isSetPositionEnabled() : Boolean
      {
         return this.mIsSetPositionEnabled;
      }
      
      public function set isSetPositionEnabled(value:Boolean) : void
      {
         this.mIsSetPositionEnabled = value;
      }
      
      public function parseFromDisplayObject(displayObject:DisplayObject, areaName:String) : void
      {
         var saveRotation:Number = displayObject.rotation;
         this.name = areaName;
         this.scaleX = Math.abs(displayObject.scaleX);
         this.scaleY = Math.abs(displayObject.scaleY);
         this.flipH = displayObject.transform.matrix.a < 0;
         this.flipV = displayObject.transform.matrix.d < 0;
         if(this.flipH)
         {
            this.rotation = EUtils.rad2Degree(-Math.atan(displayObject.transform.matrix.c / displayObject.transform.matrix.d));
         }
         else
         {
            this.rotation = displayObject.rotation;
         }
         displayObject.rotation = 0;
         this.index = -1;
         if(displayObject.parent != null)
         {
            this.index = displayObject.parent.getChildIndex(displayObject);
         }
         this.x = Math.floor(displayObject.x);
         this.y = Math.floor(displayObject.y);
         this.width = Math.floor(displayObject.width);
         this.height = Math.floor(displayObject.height);
         this.originalWidth = this.width / this.scaleX;
         this.rectangle = new Rectangle(this.x,this.y,this.width,this.height);
         displayObject.rotation = saveRotation;
         var aux:Array = displayObject.name.split("$");
         this.collBoxColor = displayObject.transform.colorTransform.color;
         this.param = aux[1];
      }
      
      public function getDebugString() : String
      {
         return this.width + "x" + this.height + " (" + this.x + "," + this.y + ")";
      }
   }
}
