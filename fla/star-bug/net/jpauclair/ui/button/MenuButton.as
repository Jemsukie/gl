package net.jpauclair.ui.button
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.jpauclair.FlashPreloadProfiler;
   import net.jpauclair.Options;
   import net.jpauclair.data.InternalEventEntry;
   import net.jpauclair.data.LoaderData;
   import net.jpauclair.event.ChangeToolEvent;
   import net.jpauclair.ui.ToolTip;
   import net.jpauclair.window.PerformanceProfiler;
   
   public class MenuButton extends Sprite
   {
       
      
      private var mIconOver:Bitmap;
      
      private var mIconSelected:Bitmap;
      
      private var mIconOut:Bitmap;
      
      private var mToolTipText:String;
      
      private var mToggleText:String;
      
      private var mToggleEventName:String;
      
      public var mIsSelected:Boolean = false;
      
      public var mTool:Class = null;
      
      private var mIsToggle:Boolean = true;
      
      public var mInternalEvent:InternalEventEntry = null;
      
      public var mUrl:String = null;
      
      public var mLD:LoaderData = null;
      
      public function MenuButton(posX:int, posY:int, iconOut:Class, iconSelected:Class, iconOver:Class, toggleEventName:String, aTool:Class, tooltipText:String, aIsToggle:Boolean = true, aToggleText:String = null)
      {
         super();
         this.mIconOut = new iconOut() as Bitmap;
         this.mIconSelected = new iconSelected() as Bitmap;
         this.mIconSelected.visible = false;
         this.mToggleText = aToggleText;
         this.mIsToggle = aIsToggle;
         this.mTool = aTool;
         this.mouseChildren = false;
         addChild(this.mIconOut);
         addChild(this.mIconSelected);
         this.mToggleEventName = toggleEventName;
         this.mToolTipText = tooltipText;
         x = posX;
         y = posY;
         addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.OnMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut,false,0,true);
         addEventListener(MouseEvent.CLICK,this.OnClick,false,0,true);
      }
      
      private function OnMouseMove(e:MouseEvent) : void
      {
         ToolTip.SetPosition(e.stageX + 12,e.stageY + 6);
         e.stopPropagation();
         e.stopImmediatePropagation();
      }
      
      public function OnClick(e:MouseEvent) : void
      {
         var e2:Event = null;
         var e3:Event = null;
         var e4:Event = null;
         if(e != null)
         {
            e.stopPropagation();
            e.stopImmediatePropagation();
         }
         this.mIconSelected.visible = true;
         if(this.mIsSelected)
         {
            this.mIsSelected = false;
            if(this.mToggleText != null)
            {
               this.SetToolTipText(this.mToolTipText);
            }
            if(this.mToggleEventName == Options.SAVE_RECORDING_EVENT)
            {
               e2 = new Event(Options.SAVE_RECORDING_EVENT,true);
               dispatchEvent(e2);
            }
            return;
         }
         if(this.mIsToggle)
         {
            this.mIsSelected = true;
            if(this.mIsSelected && this.mToggleText != null)
            {
               ToolTip.Text = this.mToggleText;
            }
         }
         if(this.mToggleEventName != null)
         {
            if(this.mToggleEventName == ChangeToolEvent.CHANGE_TOOL_EVENT)
            {
               FlashPreloadProfiler.StaticChangeTool(this);
            }
            else if(this.mToggleEventName != Options.SAVE_RECORDING_EVENT)
            {
               if(this.mToggleEventName == Options.SAVE_SNAPSHOT_EVENT)
               {
                  e3 = new Event(Options.SAVE_SNAPSHOT_EVENT,true);
                  dispatchEvent(e3);
               }
               else if(this.mToggleEventName == PerformanceProfiler.SAVE_FUNCTION_STACK_EVENT)
               {
                  e4 = new Event(PerformanceProfiler.SAVE_FUNCTION_STACK_EVENT,true);
                  dispatchEvent(e4);
               }
               else
               {
                  FlashPreloadProfiler.StaticChangeTool(null);
               }
            }
         }
      }
      
      public function OnMouseOver(e:MouseEvent) : void
      {
         e.stopPropagation();
         e.stopImmediatePropagation();
         this.mIconSelected.visible = true;
         if(this.mIsSelected && this.mToggleText != null)
         {
            ToolTip.Text = this.mToggleText;
         }
         else
         {
            ToolTip.Text = this.mToolTipText;
         }
         ToolTip.Visible = true;
      }
      
      public function SetToolTipText(text:String) : void
      {
         this.mToolTipText = text;
         if(this.mIconSelected.visible)
         {
            ToolTip.Text = text;
         }
      }
      
      public function OnMouseOut(e:MouseEvent) : void
      {
         e.stopPropagation();
         e.stopImmediatePropagation();
         ToolTip.Visible = false;
         if(this.mIsSelected)
         {
            return;
         }
         if(this.mIconSelected != null)
         {
            this.mIconSelected.visible = false;
         }
      }
      
      public function Reset() : void
      {
         this.mIsSelected = false;
         this.mIconSelected.visible = false;
      }
      
      public function Dispose() : void
      {
         if(this.mIconOver != null)
         {
            if(this.mIconOver.bitmapData != null)
            {
               this.mIconOver.bitmapData.dispose();
            }
            this.mIconOver = null;
         }
         if(this.mIconSelected != null)
         {
            if(this.mIconSelected.bitmapData != null)
            {
               this.mIconSelected.bitmapData.dispose();
            }
            this.mIconSelected = null;
         }
         if(this.mIconOut != null)
         {
            if(this.mIconOut.bitmapData != null)
            {
               this.mIconOut.bitmapData.dispose();
            }
            this.mIconOut = null;
         }
         this.mToolTipText = null;
         this.mToggleEventName = null;
         this.mTool = null;
         this.mInternalEvent = null;
      }
   }
}
