package com.dchoc.toolkit.utils.astar
{
   public class DCSearchResults
   {
       
      
      private var isSuccess:Boolean;
      
      private var path:DCPath;
      
      public function DCSearchResults()
      {
         super();
      }
      
      public function setPath(p:DCPath) : void
      {
         this.path = p;
      }
      
      public function getPath() : DCPath
      {
         return this.path;
      }
      
      public function getIsSuccess() : Boolean
      {
         return this.isSuccess;
      }
      
      public function setIsSuccess(val:Boolean) : void
      {
         this.isSuccess = val;
      }
   }
}
