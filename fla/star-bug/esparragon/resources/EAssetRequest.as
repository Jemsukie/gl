package esparragon.resources
{
   public class EAssetRequest
   {
      
      private static const STATE_NONE:int = 0;
      
      private static const STATE_PENDING_TO_REQUEST:int = 1;
      
      private static const STATE_REQUESTED:int = 2;
       
      
      private var mState:int;
      
      private var mAssetId:String;
      
      private var mGroupId:String;
      
      private var mPriority:int;
      
      private var mSuccessFuncs:Vector.<Function>;
      
      private var mErrorFuncs:Vector.<Function>;
      
      public function EAssetRequest(assetId:String, groupId:String, priority:int, completeFunc:Function, errorFunc:Function)
      {
         super();
         this.mAssetId = assetId;
         this.mGroupId = groupId;
         this.mPriority = priority;
         this.addRequest(completeFunc,errorFunc);
         this.changeState(1);
      }
      
      public function destroy() : void
      {
         this.mAssetId = null;
         this.mGroupId = null;
         this.removeSuccessFuncs();
         this.removeErrorFuncs();
      }
      
      public function getAssetId() : String
      {
         return this.mAssetId;
      }
      
      public function getGroupId() : String
      {
         return this.mGroupId;
      }
      
      public function getPriority() : int
      {
         return this.mPriority;
      }
      
      public function addRequest(completeFunc:Function, errorFunc:Function) : void
      {
         if(completeFunc != null)
         {
            if(this.mSuccessFuncs == null)
            {
               this.mSuccessFuncs = new Vector.<Function>(0);
            }
            this.mSuccessFuncs.push(completeFunc);
         }
         if(errorFunc != null)
         {
            if(this.mErrorFuncs == null)
            {
               this.mErrorFuncs = new Vector.<Function>(0);
            }
            this.mErrorFuncs.push(errorFunc);
         }
      }
      
      public function doRequest() : void
      {
         this.changeState(2);
      }
      
      public function success(assetLoadedId:String = null) : void
      {
         var id:String = null;
         var func:Function = null;
         if(this.mSuccessFuncs != null)
         {
            id = assetLoadedId == null ? this.mAssetId : assetLoadedId;
            while(this.mSuccessFuncs.length > 0)
            {
               func = this.mSuccessFuncs.shift();
               func(id,this.mGroupId);
            }
            this.mSuccessFuncs = null;
         }
         this.removeErrorFuncs();
      }
      
      public function error(assetLoadedId:String = null) : void
      {
         var id:String = null;
         var func:Function = null;
         if(this.mErrorFuncs != null)
         {
            id = assetLoadedId == null ? this.mAssetId : assetLoadedId;
            while(this.mErrorFuncs.length > 0)
            {
               func = this.mErrorFuncs.shift();
               func(id,this.mGroupId);
            }
            this.mErrorFuncs = null;
         }
         this.removeSuccessFuncs();
      }
      
      private function removeSuccessFuncs() : void
      {
         if(this.mSuccessFuncs != null)
         {
            this.mSuccessFuncs.length = 0;
            this.mSuccessFuncs = null;
         }
      }
      
      private function removeErrorFuncs() : void
      {
         if(this.mErrorFuncs != null)
         {
            this.mErrorFuncs.length = 0;
            this.mErrorFuncs = null;
         }
      }
      
      private function changeState(newState:int) : void
      {
         this.mState = newState;
      }
   }
}
