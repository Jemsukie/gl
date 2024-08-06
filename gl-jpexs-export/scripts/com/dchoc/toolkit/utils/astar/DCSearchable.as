package com.dchoc.toolkit.utils.astar
{
   public interface DCSearchable
   {
       
      
      function getCols() : int;
      
      function getRows() : int;
      
      function getNode(param1:int, param2:int) : DCAStarNode;
      
      function getNodeTransitionCost(param1:DCAStarNode, param2:DCAStarNode) : Number;
   }
}
