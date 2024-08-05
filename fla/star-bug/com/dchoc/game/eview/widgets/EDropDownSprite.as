package com.dchoc.game.eview.widgets
{
   import com.dchoc.game.controller.tools.ToolSpy;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   
   public class EDropDownSprite extends ESpriteContainer
   {
      
      public static const DIRECTION_VERTICAL:int = 1;
      
      public static const DIRECTION_HORIZONTAL:int = 2;
      
      public static const DURATION:Number = 0.3;
      
      private static const MAX_OPEN_TTL:int = 3000;
       
      
      private var mTween:GTween;
      
      private var mScaleDirection:int;
      
      private var mMaxTTL:int;
      
      private var mOpenTTL:int = 0;
      
      private var mIsMouseIn:Boolean;
      
      private var mContentArea:ELayoutArea;
      
      private var mContentSprites:Array;
      
      private var mContentDirty:Boolean;
      
      public function EDropDownSprite(direction:int = 1)
      {
         super();
         this.mMaxTTL = 3000;
         this.mScaleDirection = direction;
         this.mContentSprites = [];
         eAddEventListener("rollOver",this.onMouseOver);
         eAddEventListener("rollOut",this.onMouseOut);
         this.mContentDirty = false;
      }
      
      override public function destroy() : void
      {
         if(this.mTween)
         {
            this.mTween.end();
            this.mTween = null;
         }
         super.destroy();
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(!this.mIsMouseIn && this.mOpenTTL > 0 && this.mMaxTTL > 0)
         {
            this.mOpenTTL -= dt;
            if(this.mOpenTTL <= 0)
            {
               this.close(true);
            }
         }
         if(this.mContentDirty)
         {
            this.updateContent();
         }
      }
      
      public function open(animated:Boolean = true) : void
      {
         if(this.mTween)
         {
            this.mTween.end();
         }
         this.mTween = this.createTweenOpenDo();
         if(!animated)
         {
            this.mTween.end();
         }
         this.mOpenTTL = 3000;
      }
      
      public function close(animated:Boolean = true) : void
      {
         this.mOpenTTL = 0;
         if(this.mTween)
         {
            this.mTween.end();
         }
         this.mTween = this.createTweenCloseDo();
         if(!animated)
         {
            this.mTween.end();
         }
      }
      
      public function setCloseTimeMs(value:Number) : void
      {
         this.mMaxTTL = value;
      }
      
      public function isOpen() : Boolean
      {
         return this.mOpenTTL > 0;
      }
      
      protected function createTweenOpenDo() : GTween
      {
         return this.createTweenOpen(this);
      }
      
      protected function createTweenCloseDo() : GTween
      {
         return this.createTweenClose(this);
      }
      
      protected function createTweenOpen(_do:ESprite) : GTween
      {
         var tween:GTween = new GTween(_do,0.3);
         tween.autoPlay = true;
         if(this.mScaleDirection == 2)
         {
            tween.setValue("scaleLogicX",1);
         }
         if(this.mScaleDirection == 1)
         {
            tween.setValue("scaleLogicY",1);
         }
         return tween;
      }
      
      protected function createTweenClose(_do:ESprite) : GTween
      {
         var tween:GTween = new GTween(_do,0.3);
         tween.autoPlay = true;
         if(this.mScaleDirection & 2)
         {
            tween.setValue("scaleLogicX",0);
         }
         if(this.mScaleDirection & 1)
         {
            tween.setValue("scaleLogicY",0);
         }
         return tween;
      }
      
      public function setContentArea(area:ELayoutArea) : void
      {
         this.mContentArea = area;
         this.mContentDirty = true;
      }
      
      public function resetContent() : void
      {
         this.mContentSprites.length = 0;
         this.mContentDirty = true;
      }
      
      public function addContent(content:ESprite) : void
      {
         this.mContentSprites.push(content);
         this.mContentDirty = true;
         this.addContentDo(content);
      }
      
      public function removeContent(content:ESprite) : void
      {
         var index:int = this.mContentSprites.lastIndexOf(content);
         if(index >= 0)
         {
            this.mContentSprites.splice(index,1);
            this.mContentDirty = true;
            this.removeContentDo(content);
         }
      }
      
      protected function addContentDo(content:ESprite) : void
      {
         this.eAddChild(content);
      }
      
      protected function removeContentDo(content:ESprite) : void
      {
         this.eRemoveChild(content);
      }
      
      public function getContentLength() : int
      {
         return this.mContentSprites.length;
      }
      
      protected function updateContent() : void
      {
         this.mContentDirty = false;
         if(this.mContentArea)
         {
            InstanceMng.getViewFactory().distributeSpritesInArea(this.mContentArea,this.mContentSprites,1,1,1);
         }
      }
      
      public function onMouseOver(evt:EEvent) : void
      {
         var toolSpy:ToolSpy = null;
         this.mIsMouseIn = true;
         if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 2)
         {
            toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy;
            toolSpy.dropCapsuleEnable(false);
            toolSpy.spySetEnable(false);
            toolSpy.dropDownHovering = true;
         }
      }
      
      public function onMouseOut(evt:EEvent) : void
      {
         var toolSpy:ToolSpy = null;
         this.mIsMouseIn = false;
         if(this.isOpen())
         {
            this.mOpenTTL = this.mMaxTTL;
         }
         if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 2)
         {
            toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy;
            toolSpy.dropDownHovering = false;
         }
      }
   }
}
