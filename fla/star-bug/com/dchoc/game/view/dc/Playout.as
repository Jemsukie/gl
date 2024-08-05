package com.dchoc.game.view.dc
{
   import esparragon.display.ESprite;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   import flash.geom.Rectangle;
   
   public class Playout
   {
       
      
      private var area:Rectangle;
      
      private var amount:Number;
      
      private var children:Array;
      
      private var debugEnabled:Boolean;
      
      public var parent:Playout;
      
      public var name:String;
      
      public function Playout(area:Rectangle, parent:Playout = null)
      {
         super();
         this.area = area;
         this.parent = parent;
         this.amount = 0;
         this.children = [];
         this.name = "";
         this.debugEnabled = false;
      }
      
      public function enableDebug() : Playout
      {
         this.debugEnabled = true;
         return this;
      }
      
      public function fractionWidth(fraction:Number) : Playout
      {
         this.amount = this.area.width * fraction;
         return this;
      }
      
      public function fractionHeight(fraction:Number) : Playout
      {
         this.amount = this.area.height * fraction;
         return this;
      }
      
      public function pixels(pixels:Number) : Playout
      {
         this.amount = pixels;
         return this;
      }
      
      private function checkHeight() : void
      {
         if(this.amount > this.area.height)
         {
            throw "Invalid state";
         }
      }
      
      public function top() : Playout
      {
         this.checkHeight();
         var result:Playout = new Playout(new Rectangle(this.area.x,this.area.y,this.area.width,this.amount),this);
         this.children.push(result);
         this.area.y += this.amount;
         this.area.height -= this.amount;
         return result;
      }
      
      public function bottom() : Playout
      {
         this.checkHeight();
         var result:Playout = new Playout(new Rectangle(this.area.x,this.area.y + this.area.height - this.amount,this.area.width,this.amount),this);
         this.children.push(result);
         this.area.height -= this.amount;
         return result;
      }
      
      private function checkWidth() : void
      {
         if(this.amount > this.area.width)
         {
            throw "Invalid state";
         }
      }
      
      public function left() : Playout
      {
         this.checkWidth();
         var result:Playout = new Playout(new Rectangle(this.area.x,this.area.y,this.amount,this.area.height),this);
         this.children.push(result);
         this.area.x += this.amount;
         this.area.width -= this.amount;
         return result;
      }
      
      public function right() : Playout
      {
         this.checkWidth();
         var result:Playout = new Playout(new Rectangle(this.area.x + this.area.width - this.amount,this.area.y,this.amount,this.area.height),this);
         this.children.push(result);
         this.area.width -= this.amount;
         return result;
      }
      
      public function setName(name:String) : Playout
      {
         this.name = name;
         return this;
      }
      
      public function middle() : Playout
      {
         var result:Playout = this.dup();
         this.area.width = 0;
         this.area.height = 0;
         return result;
      }
      
      public function dup() : Playout
      {
         var result:Playout = new Playout(new Rectangle(this.area.x,this.area.y,this.area.width,this.area.height),this);
         this.children.push(result);
         return result;
      }
      
      public function margin() : Playout
      {
         return this.top().parent.bottom().parent.left().parent.right().parent.middle();
      }
      
      public function find(name:String) : Playout
      {
         var child:Playout = null;
         var resultChild:Playout = null;
         if(this.name == name)
         {
            return this;
         }
         for each(child in this.children)
         {
            resultChild = child.find(name);
            if(resultChild != null)
            {
               return resultChild;
            }
         }
         return null;
      }
      
      public function asArea(centerAndScale:Boolean = false) : ELayoutArea
      {
         var result:ELayoutArea = new ELayoutArea();
         result.x = this.area.x;
         result.y = this.area.y;
         result.width = this.area.width;
         result.height = this.area.height;
         if(centerAndScale)
         {
            result.addBehavior(new ELayoutBehaviorCenterAndScale());
         }
         return result;
      }
      
      public function asTextArea() : ELayoutTextArea
      {
         var result:ELayoutTextArea = new ELayoutTextArea();
         result.name = this.name;
         if(result.name == null)
         {
            result.name = "default";
         }
         result.hAlign = "center";
         result.vAlign = "center";
         result.autoScale = true;
         result.bold = true;
         result.fontSize = 16;
         result.fontColor = 16777215;
         result.fontName = "Komika Axis";
         result.scaleX = 1;
         result.scaleY = 1;
         result.x = this.area.x;
         result.y = this.area.y;
         result.width = this.area.width;
         result.height = this.area.height;
         return result;
      }
      
      public function asRectangle() : Rectangle
      {
         return new Rectangle(this.area.x,this.area.y,this.area.width,this.area.height);
      }
      
      public function root() : Playout
      {
         if(this.parent == null)
         {
            return this;
         }
         return this.parent.root();
      }
      
      public function debug(container:ESprite, color:int = 16777215) : Playout
      {
         var test:ESprite = null;
         if(this.root().debugEnabled)
         {
            test = new ESprite();
            test.graphics.clear();
            test.graphics.beginFill(0,0.1);
            test.graphics.lineStyle(1,color);
            test.graphics.drawRect(this.area.x,this.area.y,this.area.width,this.area.height);
            test.graphics.endFill();
            container.eAddChild(test);
         }
         return this;
      }
      
      public function translate(dx:Number, dy:Number) : Playout
      {
         this.area.x += dx;
         this.area.y += dy;
         return this;
      }
      
      public function scale(sx:Number, sy:Number) : Playout
      {
         var amountX:Number = (sx - 1) * this.area.width;
         var amountY:Number = (sy - 1) * this.area.height;
         this.area.x -= amountX / 2;
         this.area.y -= amountY / 2;
         this.area.width += amountX;
         this.area.height += amountY;
         return this;
      }
      
      public function dump(indent:int = 0) : Playout
      {
         throw "No dump";
      }
   }
}
