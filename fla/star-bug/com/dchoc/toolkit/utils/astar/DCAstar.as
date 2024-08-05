package com.dchoc.toolkit.utils.astar
{
   public class DCAstar
   {
       
      
      private var mStartNode:DCAStarNode;
      
      private var mGoalNode:DCAStarNode;
      
      private var mClosed:Object;
      
      private var mAllowDiag:Boolean;
      
      private var mGrid:DCSearchable;
      
      private var mMaxSearchTime:Number;
      
      private var mCheckItems:Boolean;
      
      private var mItemStepable:Object;
      
      public function DCAstar(grid:DCSearchable)
      {
         super();
         this.mGrid = grid;
         this.setAllowDiag(true);
         this.setMaxSearchTime(10000);
      }
      
      public function unload() : void
      {
         this.mStartNode = null;
         this.mGoalNode = null;
         this.mClosed = null;
         this.mGrid = null;
      }
      
      public function search(start_node:DCAStarNode, goal_nodes:Vector.<DCAStarNode>, checkItems:Boolean = true, item:Object = null) : DCSearchResults
      {
         var now:Date = null;
         var p:DCPath = null;
         var lastNode:DCAStarNode = null;
         var neighbors:Vector.<DCAStarNode> = null;
         var i:int = 0;
         var t:DCAStarNode = null;
         var h:Number = NaN;
         var pp:DCPath = null;
         var cost:* = NaN;
         var costMultiplier:Number = NaN;
         this.mCheckItems = checkItems;
         this.mItemStepable = item;
         this.mStartNode = start_node;
         this.mGoalNode = goal_nodes[0];
         var results:DCSearchResults = new DCSearchResults();
         this.mClosed = {};
         var queue:DCPriorityQueue = new DCPriorityQueue();
         var path:DCPath;
         (path = new DCPath()).addNode(start_node);
         queue.enqueue(path);
         var diag:Number = Math.sqrt(2);
         var startTime:Date = new Date();
         while(queue.hasNextItem())
         {
            if((now = new Date()).valueOf() - startTime.valueOf() > this.mMaxSearchTime)
            {
               break;
            }
            lastNode = (p = queue.getNextItem()).getLastNode();
            if(!this.isInClosed(lastNode))
            {
               if(goal_nodes.indexOf(lastNode) > -1)
               {
                  results.setIsSuccess(true);
                  results.setPath(p);
                  break;
               }
               this.mClosed[lastNode.getNodeId()] = true;
               neighbors = this.getNeighbors(lastNode);
               for(i = 0; i < neighbors.length; )
               {
                  t = DCAStarNode(neighbors[i]);
                  h = Math.abs(lastNode.getCol() - t.getCol()) + Math.abs(lastNode.getRow() - t.getRow());
                  t.setHeuristic(h);
                  (pp = p.clone()).addNode(t);
                  if(t.getCol() == lastNode.getCol() || t.getRow() == lastNode.getRow())
                  {
                     cost = 1;
                  }
                  else
                  {
                     cost = diag;
                  }
                  costMultiplier = this.mGrid.getNodeTransitionCost(lastNode,t);
                  cost *= costMultiplier;
                  pp.incrementCost(cost);
                  queue.enqueue(pp);
                  i++;
               }
            }
         }
         return results;
      }
      
      public function setMaxSearchTime(maxSearchTime:Number) : void
      {
         this.mMaxSearchTime = maxSearchTime;
      }
      
      public function setAllowDiag(allowDiag:Boolean) : void
      {
         this.mAllowDiag = allowDiag;
      }
      
      private function getNeighbors(n:DCAStarNode) : Vector.<DCAStarNode>
      {
         var t:DCAStarNode = null;
         var arr:Vector.<DCAStarNode> = n.getNeighbors();
         var c:int = n.getCol();
         var r:int = n.getRow();
         var max_c:int = this.mGrid.getCols();
         var max_r:int = this.mGrid.getRows();
         if(arr == null)
         {
            arr = new Vector.<DCAStarNode>(0);
            if(c + 1 < max_c)
            {
               if((t = this.mGrid.getNode(c + 1,r)).canBeStepped(this.mCheckItems,this.mItemStepable))
               {
                  arr.push(t);
               }
            }
            if(r + 1 < max_r)
            {
               if((t = this.mGrid.getNode(c,r + 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
               {
                  arr.push(t);
               }
            }
            if(c - 1 >= 0)
            {
               if((t = this.mGrid.getNode(c - 1,r)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
               {
                  arr.push(t);
               }
            }
            if(r - 1 >= 0)
            {
               if((t = this.mGrid.getNode(c,r - 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
               {
                  arr.push(t);
               }
            }
            if(this.mAllowDiag)
            {
               if(c - 1 > 0 && r + 1 < max_r)
               {
                  if((t = this.mGrid.getNode(c - 1,r + 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
                  {
                     arr.push(t);
                  }
               }
               if(c + 1 < max_c && r + 1 < max_r)
               {
                  if((t = this.mGrid.getNode(c + 1,r + 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
                  {
                     arr.push(t);
                  }
               }
               if(c - 1 > 0 && r - 1 > 0)
               {
                  if((t = this.mGrid.getNode(c - 1,r - 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
                  {
                     arr.push(t);
                  }
               }
               if(c + 1 < max_c && r - 1 > 0)
               {
                  if((t = this.mGrid.getNode(c + 1,r - 1)) != null && t.canBeStepped(this.mCheckItems,this.mItemStepable))
                  {
                     arr.push(t);
                  }
               }
            }
            n.setNeighbors(arr);
         }
         return arr;
      }
      
      private function isInClosed(n:DCAStarNode) : Boolean
      {
         return this.mClosed[n.getNodeId()] != null;
      }
   }
}
