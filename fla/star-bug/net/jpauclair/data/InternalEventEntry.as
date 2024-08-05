package net.jpauclair.data
{
   public class InternalEventEntry
   {
       
      
      public var qName:String = null;
      
      public var mStack:String = null;
      
      public var mStackFrame:Array = null;
      
      public var entryCount:int;
      
      public var entryCountTotal:int;
      
      public var entryTime:int;
      
      public var entryTimeTotal:int;
      
      public function InternalEventEntry()
      {
         super();
      }
      
      public function SetStack(aStack:Array) : void
      {
         var j:int = 0;
         this.mStackFrame = aStack;
         this.mStack = "";
         for(var i:int = aStack.length - 1; i >= 0; i--)
         {
            this.mStack += "-" + aStack[i].name;
            if(i > 0)
            {
               this.mStack += "\n";
               for(j = aStack.length - 1; j >= i; j--)
               {
                  this.mStack += "\t";
               }
            }
         }
      }
      
      public function Add(time:Number) : void
      {
         ++this.entryCount;
         ++this.entryCountTotal;
         this.entryTime += time;
         this.entryTimeTotal += time;
      }
      
      public function AddParentTime(time:Number) : void
      {
         this.entryTimeTotal += time;
      }
      
      public function Reset() : void
      {
         this.entryTime = 0;
         this.entryCount = 0;
      }
      
      public function Clear() : void
      {
         this.entryCount = 0;
         this.entryCountTotal = 0;
         this.entryTime = 0;
         this.entryTimeTotal = 0;
      }
   }
}
