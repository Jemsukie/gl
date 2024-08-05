package com.dchoc.toolkit.utils.math.geom
{
   public class DCBox
   {
      
      public static const VIEW_TYPE_TOPDOWN:int = 0;
      
      public static const VIEW_TYPE_ISOMETRIC:int = 1;
       
      
      public var id:int;
      
      public var mX:int;
      
      public var mY:int;
      
      public var mZ:int;
      
      public var mWidth:int;
      
      public var mHeight:int;
      
      private var mViewType:int;
      
      public function DCBox(x:int = 0, y:int = 0, width:int = 0, height:int = 0, viewType:int = 1)
      {
         super();
         this.mX = x;
         this.mY = y;
         this.mZ = 0;
         this.mWidth = width;
         this.mHeight = height;
         this.mViewType = viewType;
      }
      
      public function setCorners(left:int, up:int, right:int, down:int) : void
      {
         this.mX = left;
         this.mY = up;
         this.mWidth = right - left;
         this.mHeight = down - up;
      }
      
      public function move(offX:int, offY:int) : void
      {
         this.mX += offX;
         this.mY += offY;
      }
      
      public function getLeft() : Number
      {
         return this.mX;
      }
      
      public function getRight() : Number
      {
         return this.mX + this.mWidth;
      }
      
      public function getTop() : Number
      {
         return this.mY;
      }
      
      public function getBottom() : Number
      {
         return this.mY + this.mHeight;
      }
      
      public function setXY(x:int, y:int) : void
      {
         this.mX = x;
         this.mY = y;
      }
      
      public function setSize(width:int, height:int) : void
      {
         this.mWidth = width;
         this.mHeight = height;
      }
      
      public function getWidth() : int
      {
         return this.mWidth;
      }
      
      public function getHeight() : int
      {
         return this.mHeight;
      }
      
      public function collides(b:DCBox, scaleX:Number = 1, scaleY:Number = 1) : Boolean
      {
         var returnValue:* = false;
         if(b != null)
         {
            returnValue = !(b.mX * scaleX > this.mX + this.mWidth || (b.mX + b.mWidth) * scaleX < this.mX || b.mY * scaleY > this.mY + this.mHeight || (b.mY + b.mHeight) * scaleY < this.mY);
         }
         return returnValue;
      }
      
      public function isBehind(b:DCBox) : Boolean
      {
         var right:Number = NaN;
         var bRight:Number = NaN;
         var returnValue:* = false;
         if(b != null)
         {
            switch(this.mViewType)
            {
               case 0:
                  returnValue = this.mZ <= b.mZ;
                  if(returnValue)
                  {
                     returnValue &&= this.getBottom() < b.getBottom();
                  }
                  break;
               case 1:
                  returnValue = this.mZ <= b.mZ;
                  if(returnValue && this.mZ == b.mZ)
                  {
                     right = this.getRight();
                     bRight = b.getRight();
                     returnValue = right < bRight;
                     if(!returnValue)
                     {
                        returnValue = right == bRight && this.getBottom() <= b.getBottom();
                     }
                  }
            }
         }
         return returnValue;
      }
      
      public function clone(copy:DCBox) : DCBox
      {
         if(copy == null)
         {
            copy = new DCBox(this.mX,this.mY,this.mWidth,this.mHeight,this.mViewType);
         }
         else
         {
            copy.mX = this.mX;
            copy.mY = this.mY;
            copy.mWidth = this.mWidth;
            copy.mHeight = this.mHeight;
            copy.mViewType = this.mViewType;
         }
         copy.mZ = this.mZ;
         return copy;
      }
   }
}
