package com.dchoc.toolkit.utils.astar
{
   public interface DCAStarNode
   {
       
      
      function setHeuristic(param1:Number) : void;
      
      function getHeuristic() : Number;
      
      function getCol() : int;
      
      function getRow() : int;
      
      function setNeighbors(param1:Vector.<DCAStarNode>) : void;
      
      function getNodeId() : int;
      
      function getNeighbors() : Vector.<DCAStarNode>;
      
      function getNodeType() : String;
      
      function canBeStepped(param1:Boolean = true, param2:Object = null) : Boolean;
   }
}
