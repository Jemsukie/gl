package esparragon.display
{
   import esparragon.behaviors.EBehavior;
   import esparragon.behaviors.EBehaviorsMng;
   import esparragon.core.Esparragon;
   import esparragon.events.EEvent;
   import esparragon.events.EEventFactory;
   import esparragon.layout.ELayoutArea;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class ESprite extends EAbstractSprite
   {
      
      private static var smIsAutomaticViewUpdateEnabled:Boolean = true;
       
      
      private var mEnabled:Boolean;
      
      protected var mFilters:Array;
      
      private var mPivotLogicX:Number = 0;
      
      private var mPivotLogicY:Number = 0;
      
      private var mPivotX:Number = 0;
      
      private var mPivotY:Number = 0;
      
      private var mX:Number = 0;
      
      private var mY:Number = 0;
      
      private var mIsXLeft:Boolean = true;
      
      private var mIsYTop:Boolean = true;
      
      private var mScaleAreaX:Number = 1;
      
      private var mScaleAreaY:Number = 1;
      
      private var mEventsListeners:Dictionary;
      
      private var mEventsBehaviors:Dictionary;
      
      private var mEventsIsMouseOver:Boolean;
      
      private var mLayoutArea:ELayoutArea;
      
      private var mIsMouseDown:Boolean = false;
      
      public var mLogicUpdateFrequency:int;
      
      public var mTimeSinceLastLogicUpdate:int;
      
      public function ESprite()
      {
         super();
         this.mEnabled = true;
      }
      
      public function setSkinSku(skinSku:String) : void
      {
         Esparragon.getSkinsMng().registerESprite(this,skinSku);
      }
      
      public function destroy() : void
      {
         destroyMask();
         this.poolReturn();
         this.eventsReset();
         resetColor();
         visible = true;
         alpha = 1;
         this.setPivotLogicXY(0,0);
         this.setScaleAreaXY(1,1);
         this.scaleX = 1;
         this.scaleY = 1;
         x = 0;
         y = 0;
         this.mIsXLeft = true;
         this.mIsYTop = true;
         this.mLayoutArea = null;
         Esparragon.getSkinsMng().unregisterESprite(this);
         this.mFilters = null;
         this.extendedDestroy();
      }
      
      protected function extendedDestroy() : void
      {
      }
      
      protected function poolReturn() : void
      {
         Esparragon.poolReturnESprite(this);
      }
      
      private function eventsReset() : void
      {
         this.eRemoveAllEventsListeners();
         this.eRemoveAllEventsBehaviors();
         this.mEventsIsMouseOver = false;
      }
      
      private function eAddEventStuff(type:String, stuffDictionary:Dictionary, stuff:Object, onFunc:Function = null) : void
      {
         if(stuffDictionary[type] == null)
         {
            stuffDictionary[type] = [];
         }
         var thisArray:Array;
         if((thisArray = stuffDictionary[type]).indexOf(stuff) == -1)
         {
            if(onFunc != null)
            {
               this.addEventListener(this.translateEToApiEventType(type),onFunc);
            }
            thisArray.push(stuff);
         }
      }
      
      private function eRemoveEventStuff(type:String, stuffArray:Array, stuff:Object, onFunc:Function = null) : void
      {
         var index:int = 0;
         if(stuffArray != null)
         {
            if((index = stuffArray.indexOf(stuff)) > -1)
            {
               stuffArray.splice(index,1);
               if(onFunc != null)
               {
                  this.removeEventListener(this.translateEToApiEventType(type),onFunc);
               }
            }
         }
      }
      
      public function eAddEventListener(type:String, listener:Function) : void
      {
         if(this.mEventsListeners == null)
         {
            this.mEventsListeners = new Dictionary();
         }
         this.eAddEventStuff(type,this.mEventsListeners,listener,this.onEventListener);
      }
      
      public function eRemoveEventListener(type:String, listener:Function) : void
      {
         var listenersList:Array = null;
         if(this.mEventsListeners != null)
         {
            listenersList = this.mEventsListeners[type];
            if(listenersList != null)
            {
               delete this.mEventsListeners[type];
               this.eRemoveEventStuff(type,listenersList,listener,this.onEventListener);
            }
         }
      }
      
      public function eRemoveAllEventListeners(type:String) : void
      {
         var listeners:Array = null;
         var eventListener:Function = null;
         if(this.mEventsListeners != null)
         {
            listeners = this.getEventListeners(type);
            if(listeners != null)
            {
               for each(eventListener in listeners)
               {
                  this.eRemoveEventListener(type,eventListener);
               }
            }
         }
      }
      
      public function eRemoveAllEventsListeners() : void
      {
         var k:* = null;
         var key:String = null;
         if(this.mEventsListeners != null)
         {
            for(k in this.mEventsListeners)
            {
               key = k;
               this.eRemoveAllEventListeners(key);
            }
         }
      }
      
      private function getEventListeners(type:String) : Array
      {
         return this.mEventsListeners == null ? null : this.mEventsListeners[type];
      }
      
      private function onEventListener(e:Object) : void
      {
         var eEvent:EEvent = null;
         var listeners:Array = null;
         var eventListener:Function = null;
         if(this.mEnabled)
         {
            if((eEvent = this.translateApiToEEvent(e)) != null)
            {
               listeners = this.getEventListeners(eEvent.getType());
               if(listeners != null)
               {
                  for each(eventListener in listeners)
                  {
                     eventListener(eEvent);
                  }
               }
            }
         }
      }
      
      public function eAddEventBehavior(type:String, behavior:EBehavior) : void
      {
         if(behavior != null)
         {
            if(this.mEventsBehaviors == null)
            {
               this.mEventsBehaviors = new Dictionary();
            }
            this.eAddEventStuff(type,this.mEventsBehaviors,behavior,this.onEventBehavior);
            if(type == "immediately")
            {
               behavior.perform(this,{});
            }
         }
      }
      
      public function eRemoveEventBehavior(type:String, behavior:EBehavior) : void
      {
         var behaviorsList:Array = null;
         var onFunc:Function = null;
         if(this.mEventsBehaviors != null)
         {
            behaviorsList = this.mEventsBehaviors[type];
            if(behaviorsList != null)
            {
               onFunc = behaviorsList.length == 1 ? this.onEventBehavior : null;
               this.eRemoveEventStuff(type,behaviorsList,behavior,onFunc);
            }
            if(type == "immediately")
            {
               behavior.unperform(this,{});
            }
         }
      }
      
      public function eRemoveAllEventBehaviors(type:String) : void
      {
         var behaviorsMng:EBehaviorsMng = null;
         var behaviors:Array = null;
         var eventBehavior:EBehavior = null;
         if(this.mEventsBehaviors != null)
         {
            behaviorsMng = Esparragon.getBehaviorsMng();
            behaviors = this.getEventBehaviors(type);
            if(behaviors != null)
            {
               for each(eventBehavior in behaviors)
               {
                  this.eRemoveEventBehavior(type,eventBehavior);
                  if(behaviorsMng != null)
                  {
                     behaviorsMng.poolReturnBehavior(eventBehavior);
                  }
               }
               delete this.mEventsBehaviors[type];
            }
         }
      }
      
      public function eRemoveAllEventsBehaviors() : void
      {
         var k:* = null;
         var key:String = null;
         if(this.mEventsBehaviors != null)
         {
            for(k in this.mEventsBehaviors)
            {
               key = k;
               this.eRemoveAllEventBehaviors(key);
            }
         }
      }
      
      private function getEventBehaviors(type:String) : Array
      {
         return this.mEventsBehaviors == null ? null : this.mEventsBehaviors[type];
      }
      
      private function onEventBehavior(e:Object) : void
      {
         var eEvent:EEvent = null;
         var behaviors:Array = null;
         var eventBehavior:EBehavior = null;
         if(this.mEnabled)
         {
            if((eEvent = this.translateApiToEEvent(e)) != null)
            {
               behaviors = this.getEventBehaviors(eEvent.getType());
               if(behaviors != null)
               {
                  for each(eventBehavior in behaviors)
                  {
                     eventBehavior.perform(this,eEvent);
                  }
               }
            }
         }
      }
      
      public function eventsGetIsMouseOver() : Boolean
      {
         return this.mEventsIsMouseOver;
      }
      
      public function eventsSetIsMouseOver(value:Boolean) : void
      {
         this.mEventsIsMouseOver = value;
      }
      
      private function translateEToApiEventType(type:String) : String
      {
         var eventFactory:EEventFactory = Esparragon.getEventFactory();
         return eventFactory.translateEToApiEventType(type);
      }
      
      private function translateApiToEEvent(event:Object) : EEvent
      {
         var eventFactory:EEventFactory = Esparragon.getEventFactory();
         return eventFactory.translateApiToEEvent(event,this);
      }
      
      public function onResizeUpdate() : void
      {
         smIsAutomaticViewUpdateEnabled = false;
         var wasXLeft:Boolean = this.mIsXLeft;
         var wasYTop:Boolean = this.mIsYTop;
         var myX:Number = this.x;
         var myY:Number = this.y;
         this.logicLeft = myX;
         this.logicTop = myY;
         this.mIsXLeft = wasXLeft;
         this.mIsYTop = wasYTop;
         if(!this.mIsXLeft)
         {
            this.mX = this.logicX + this.mPivotX;
         }
         if(!this.mIsYTop)
         {
            this.mY = this.logicY + this.mPivotY;
         }
         smIsAutomaticViewUpdateEnabled = true;
         this.updateView();
      }
      
      public function layoutApplyTransformations(area:ELayoutArea) : void
      {
         smIsAutomaticViewUpdateEnabled = false;
         if(area.isSetPositionEnabled)
         {
            this.logicX = area.x + area.pivotX * area.width;
            this.logicY = area.y + area.pivotY * area.height;
         }
         var scaleAreaX:Number = area.scaleX;
         var scaleAreaY:Number = area.scaleY;
         if(area.flipH)
         {
            scaleAreaX *= -1;
         }
         if(area.flipV)
         {
            scaleAreaY *= -1;
         }
         this.setScaleAreaXY(scaleAreaX,scaleAreaY);
         this.rotation = area.rotation;
         smIsAutomaticViewUpdateEnabled = true;
         this.updateView();
         area.performBehaviors(this);
      }
      
      public function setLayoutArea(area:ELayoutArea, apply:Boolean = false) : void
      {
         this.mLayoutArea = area;
         if(apply && this.mLayoutArea != null)
         {
            this.layoutApplyTransformations(this.mLayoutArea);
         }
      }
      
      public function getLayoutArea() : ELayoutArea
      {
         return this.mLayoutArea;
      }
      
      public function get logicX() : Number
      {
         if(this.mIsXLeft)
         {
            return this.mX + this.mPivotLogicX * this.getLogicWidth();
         }
         return this.mX;
      }
      
      public function get logicY() : Number
      {
         if(this.mIsYTop)
         {
            return this.mY + this.mPivotLogicY * this.getLogicHeight();
         }
         return this.mY;
      }
      
      public function set logicX(value:Number) : void
      {
         this.mX = value;
         this.mIsXLeft = false;
         this.updateView();
      }
      
      public function set logicY(value:Number) : void
      {
         this.mY = value;
         this.mIsYTop = false;
         this.updateView();
      }
      
      public function get logicLeft() : Number
      {
         if(this.mIsXLeft)
         {
            return this.mX;
         }
         return this.mX - this.mPivotLogicX * this.getLogicWidth();
      }
      
      public function set logicLeft(value:Number) : void
      {
         this.mIsXLeft = true;
         this.mX = value;
         this.updateView();
      }
      
      public function get logicTop() : Number
      {
         if(this.mIsYTop)
         {
            return this.mY;
         }
         return this.mY - this.mPivotLogicY * this.getLogicHeight();
      }
      
      public function set logicTop(value:Number) : void
      {
         this.mIsYTop = true;
         this.mY = value;
         this.updateView();
      }
      
      public function updateView() : void
      {
         var matrix:Matrix = null;
         var currentRotation:Number = NaN;
         var currentScaleX:Number = NaN;
         var currentScaleY:Number = NaN;
         var currentX:Number = NaN;
         var currentY:Number = NaN;
         if(smIsAutomaticViewUpdateEnabled)
         {
            smIsAutomaticViewUpdateEnabled = false;
            (matrix = this.transform.matrix).identity();
            currentRotation = rotation;
            currentScaleX = scaleX;
            currentScaleY = scaleY;
            this.rotation = 0;
            currentX = this.logicX;
            currentY = this.logicY;
            if(currentScaleX != 1 || currentScaleY != 1)
            {
               matrix.scale(currentScaleX,currentScaleY);
            }
            if(currentRotation != 0)
            {
               matrix.rotate(3.141592653589793 / 180 * currentRotation);
            }
            if(currentX != 0 || currentY != 0)
            {
               matrix.translate(currentX,currentY);
            }
            matrix.tx = currentX - matrix.a * this.mPivotX - matrix.c * this.mPivotY;
            matrix.ty = currentY - matrix.b * this.mPivotX - matrix.d * this.mPivotY;
            this.transform.matrix = matrix;
            smIsAutomaticViewUpdateEnabled = true;
         }
      }
      
      public function setPivotXY(x:Number, y:Number) : void
      {
         this.mPivotX = x;
         this.mPivotY = y;
         if(this.width != 0)
         {
            this.mPivotLogicX = this.mPivotX / this.width;
         }
         if(this.height != 0)
         {
            this.mPivotLogicY = this.mPivotY / this.height;
         }
         this.updateView();
      }
      
      public function get pivotX() : Number
      {
         return this.mPivotX;
      }
      
      public function get pivotY() : Number
      {
         return this.mPivotY;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         super.scaleY;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         super.scaleX;
      }
      
      public function setScaleAreaXY(x:Number, y:Number) : void
      {
         this.mScaleAreaX = x;
         this.mScaleAreaY = y;
         this.scaleLogicX = 1;
         this.scaleLogicY = 1;
      }
      
      public function set scaleLogicX(x:Number) : void
      {
         this.scaleX = x * this.mScaleAreaX;
      }
      
      public function set scaleLogicY(y:Number) : void
      {
         this.scaleY = y * this.mScaleAreaY;
      }
      
      public function get scaleLogicX() : Number
      {
         return scaleX / this.mScaleAreaX;
      }
      
      public function get scaleLogicY() : Number
      {
         return scaleY / this.mScaleAreaY;
      }
      
      override public function set scaleX(value:Number) : void
      {
         super.scaleX = value;
         this.updateView();
      }
      
      override public function set scaleY(value:Number) : void
      {
         super.scaleY = value;
         this.updateView();
      }
      
      override public function set rotation(value:Number) : void
      {
         super.rotation = value;
         this.updateView();
      }
      
      public function setPivotLogicXY(x:Number, y:Number) : void
      {
         this.mPivotLogicX = x;
         this.mPivotLogicY = y;
         this.applyPivotLogicXY();
      }
      
      public function get pivotLogicX() : Number
      {
         return this.mPivotLogicX;
      }
      
      public function get pivotLogicY() : Number
      {
         return this.mPivotLogicY;
      }
      
      public function set pivotLogicX(value:Number) : void
      {
         this.mPivotLogicX = value;
         this.applyPivotLogicXY();
      }
      
      public function set pivotLogicY(value:Number) : void
      {
         this.mPivotLogicY = value;
         this.applyPivotLogicXY();
      }
      
      protected function applyPivotLogicXY() : void
      {
         smIsAutomaticViewUpdateEnabled = false;
         var backRotation:Number = rotation;
         var backScaleX:Number = scaleX;
         var backScaleY:Number = scaleY;
         this.rotation = 0;
         this.scaleX = 1;
         this.scaleY = 1;
         this.setPivotXY(this.mPivotLogicX * this.width,this.mPivotLogicY * this.height);
         this.rotation = backRotation;
         this.scaleX = backScaleX;
         this.scaleY = backScaleY;
         smIsAutomaticViewUpdateEnabled = true;
         this.updateView();
      }
      
      public function getLogicWidth() : Number
      {
         var returnValue:Number = NaN;
         if(this.mLayoutArea != null)
         {
            returnValue = this.mLayoutArea.width * this.scaleLogicX;
         }
         else
         {
            returnValue = this.width;
         }
         return returnValue;
      }
      
      public function getLogicHeight() : Number
      {
         var returnValue:Number = NaN;
         if(this.mLayoutArea != null)
         {
            returnValue = this.mLayoutArea.height * this.scaleLogicY;
         }
         else
         {
            returnValue = this.height;
         }
         return returnValue;
      }
      
      public function get mostLeft() : Number
      {
         var i:int = 0;
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var mostLeft:Number = 1.7976931348623157e+308;
         for(i = 0; i < numChildren; )
         {
            if((child = getChildAt(i)) != null)
            {
               if(child is ESprite)
               {
                  eChild = child as ESprite;
                  if(eChild.logicLeft < mostLeft)
                  {
                     mostLeft = eChild.logicLeft;
                  }
               }
               else if(child.x < mostLeft)
               {
                  mostLeft = child.x;
               }
            }
            i++;
         }
         if(mostLeft == 1.7976931348623157e+308)
         {
            mostLeft = 0;
         }
         return this.logicLeft + mostLeft;
      }
      
      public function get mostRight() : Number
      {
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var value:Number = NaN;
         var i:int = 0;
         var mostRight:* = 0;
         if(this.mLayoutArea != null || numChildren < 2)
         {
            mostRight = this.getLogicWidth();
         }
         else
         {
            mostRight = -1.7976931348623157e+308;
            for(i = 0; i < numChildren; )
            {
               if((child = getChildAt(i)) != null)
               {
                  if(child is ESprite)
                  {
                     eChild = child as ESprite;
                     value = eChild.logicLeft + eChild.getLogicWidth();
                  }
                  else
                  {
                     value = child.x + child.width;
                  }
                  if(value > mostRight)
                  {
                     mostRight = value;
                  }
               }
               i++;
            }
            if(mostRight == -1.7976931348623157e+308)
            {
               mostRight = 0;
            }
         }
         return this.logicLeft + mostRight;
      }
      
      public function get mostTop() : Number
      {
         var i:int = 0;
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var mostTop:Number = 1.7976931348623157e+308;
         for(i = 0; i < numChildren; )
         {
            if((child = getChildAt(i)) != null)
            {
               if(child is ESprite)
               {
                  eChild = child as ESprite;
                  if(eChild.logicTop < mostTop)
                  {
                     mostTop = eChild.logicTop;
                  }
               }
               else if(child.y < mostTop)
               {
                  mostTop = child.y;
               }
            }
            i++;
         }
         if(mostTop == 1.7976931348623157e+308)
         {
            mostTop = 0;
         }
         return this.logicTop + mostTop;
      }
      
      public function get mostBottom() : Number
      {
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var value:Number = NaN;
         var i:int = 0;
         var mostBottom:* = 0;
         if(this.mLayoutArea != null || numChildren < 2)
         {
            mostBottom = this.getLogicHeight();
         }
         else
         {
            mostBottom = -1.7976931348623157e+308;
            for(i = 0; i < numChildren; )
            {
               if((child = getChildAt(i)) != null)
               {
                  if(child is ESprite)
                  {
                     eChild = child as ESprite;
                     value = eChild.logicTop + eChild.getLogicHeight();
                  }
                  else
                  {
                     value = child.y + child.height;
                  }
                  if(value > mostBottom)
                  {
                     mostBottom = value;
                  }
               }
               i++;
            }
            if(mostBottom == -1.7976931348623157e+308)
            {
               mostBottom = 0;
            }
         }
         return this.logicTop + mostBottom;
      }
      
      override public function get width() : Number
      {
         var i:int = 0;
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var left:Number = NaN;
         var right:Number = NaN;
         var mostLeft:* = 1.7976931348623157e+308;
         var mostRight:* = -1.7976931348623157e+308;
         for(i = 0; i < numChildren; )
         {
            if((child = getChildAt(i)) != null && child.visible && child.scaleX != 0)
            {
               if(child is ESprite)
               {
                  left = (eChild = child as ESprite).mostLeft;
                  right = eChild.mostRight;
               }
               else
               {
                  left = child.x;
                  right = left + child.width;
               }
               if(left < mostLeft)
               {
                  mostLeft = left;
               }
               if(right > mostRight)
               {
                  mostRight = right;
               }
            }
            i++;
         }
         if(mostLeft == 1.7976931348623157e+308 && mostRight == -1.7976931348623157e+308)
         {
            return super.width;
         }
         return Math.abs((mostRight - mostLeft) * scaleX);
      }
      
      override public function get height() : Number
      {
         var i:int = 0;
         var eChild:ESprite = null;
         var child:DisplayObject = null;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var mostTop:* = 1.7976931348623157e+308;
         var mostBottom:* = -1.7976931348623157e+308;
         for(i = 0; i < numChildren; )
         {
            if((child = getChildAt(i)) != null && child.visible && child.scaleY != 0)
            {
               if(child is ESprite)
               {
                  top = (eChild = child as ESprite).mostTop;
                  bottom = eChild.mostBottom;
               }
               else
               {
                  top = child.y;
                  bottom = top + child.height;
               }
               if(top < mostTop)
               {
                  mostTop = top;
               }
               if(bottom > mostBottom)
               {
                  mostBottom = bottom;
               }
            }
            i++;
         }
         if(mostTop == 1.7976931348623157e+308 && mostBottom == -1.7976931348623157e+308)
         {
            return super.height;
         }
         return Math.abs((mostBottom - mostTop) * scaleY);
      }
      
      final public function setFilters(value:Array) : void
      {
         this.mFilters = value;
         this.updateFilters();
      }
      
      protected function updateFilters() : void
      {
         this.filters = this.mFilters;
      }
      
      final public function getFilters() : Array
      {
         return this.mFilters;
      }
      
      public function addFilter(filter:Object) : void
      {
         var index:int = 0;
         var addFilterParam:* = true;
         if(this.mFilters != null)
         {
            index = this.mFilters.indexOf(filter);
            addFilterParam = index == -1;
         }
         if(addFilterParam)
         {
            if(this.mFilters == null)
            {
               this.mFilters = [];
            }
            this.mFilters.push(filter);
            this.updateFilters();
         }
      }
      
      public function removeFilter(filter:Object) : void
      {
         var index:int = 0;
         if(this.mFilters != null)
         {
            index = this.mFilters.indexOf(filter);
            if(index > -1)
            {
               this.mFilters.splice(index,1);
            }
            this.updateFilters();
         }
      }
      
      public function setIsEnabled(value:Boolean) : void
      {
         var listeners:Array = null;
         var listener:EBehavior = null;
         var type:String = null;
         if(value)
         {
            type = "Enable";
            this.mEnabled = value;
         }
         else
         {
            type = "Disable";
         }
         listeners = this.getEventBehaviors(type);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.perform(this,type);
            }
         }
         this.mEnabled = value;
         mouseEnabled = value;
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.mEnabled;
      }
      
      public function setIsMouseDown(value:Boolean) : void
      {
         this.mIsMouseDown = value;
      }
      
      public function getIsMouseDown() : Boolean
      {
         return this.mIsMouseDown;
      }
      
      public function applySkinProp(skinSku:String, propSku:String) : void
      {
         Esparragon.getSkinsMng().applyPropToSprite(skinSku,propSku,this);
      }
      
      public function unapplySkinProp(skinSku:String, propSku:String) : void
      {
         Esparragon.getSkinsMng().unapplyPropToSprite(skinSku,propSku,this);
      }
      
      public function logicUpdate(dt:int) : void
      {
         var k:* = null;
         var key:String = null;
         var eventBehavior:EBehavior = null;
         var behaviors:Array = null;
         if(this.mEventsBehaviors != null)
         {
            for(k in this.mEventsBehaviors)
            {
               key = k;
               behaviors = this.mEventsBehaviors[key];
               for each(eventBehavior in behaviors)
               {
                  eventBehavior.logicUpdate(dt);
               }
            }
         }
      }
   }
}
