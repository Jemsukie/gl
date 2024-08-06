package com.dchoc.toolkit.utils.astar
{
   public class DCPath
   {
       
      
      public var nodes:Array;
      
      private var cost:Number;
      
      private var lastNode:DCAStarNode;
      
      public function DCPath()
      {
         super();
         this.cost = 0;
         this.nodes = [];
      }
      
      public function clone() : DCPath
      {
         var p:DCPath = new DCPath();
         p.incrementCost(this.cost);
         p.setNodes(this.nodes.slice(0));
         return p;
      }
      
      public function getLastNode() : DCAStarNode
      {
         return this.lastNode;
      }
      
      public function getF() : Number
      {
         return this.getCost() + this.lastNode.getHeuristic();
      }
      
      public function getCost() : Number
      {
         return this.cost;
      }
      
      public function incrementCost(num:Number) : void
      {
         this.cost = this.getCost() + num;
      }
      
      public function setNodes(arr:Array) : void
      {
         this.nodes = arr;
      }
      
      public function addNode(n:DCAStarNode) : void
      {
         this.nodes.push(n);
         this.lastNode = n;
      }
      
      public function getNodes() : Array
      {
         return this.nodes;
      }
      
      public function getNodesCount() : int
      {
         return this.nodes.length;
      }
      
      public function containsNode(n:DCAStarNode) : Boolean
      {
         return this.nodes.indexOf(n) > -1;
      }
      
      public function toString() : String
      {
         var node:DCAStarNode = null;
         var msg:String = "";
         for each(node in this.nodes)
         {
            msg += node.getNodeId() + "(" + node.getCol() + "," + node.getRow() + "), ";
         }
         return msg;
      }
   }
}
