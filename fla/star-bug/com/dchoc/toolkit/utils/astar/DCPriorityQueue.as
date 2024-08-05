package com.dchoc.toolkit.utils.astar
{
   public class DCPriorityQueue
   {
       
      
      private var items:Array;
      
      public function DCPriorityQueue()
      {
         super();
         this.items = [];
      }
      
      public function getNextItem() : DCPath
      {
         return DCPath(this.items.shift());
      }
      
      public function hasNextItem() : Boolean
      {
         return this.items.length > 0;
      }
      
      public function enqueue(p:DCPath) : void
      {
         var i:int = 0;
         var curr:DCPath = null;
         var val:Number = p.getF();
         var added:Boolean = false;
         for(i = 0; i < this.items.length; )
         {
            curr = DCPath(this.items[i]);
            if(val < curr.getF())
            {
               this.items.splice(i,0,p);
               added = true;
               break;
            }
            i++;
         }
         if(!added)
         {
            this.items.push(p);
         }
      }
   }
}
