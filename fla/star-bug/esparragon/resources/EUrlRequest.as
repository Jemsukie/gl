package esparragon.resources
{
   public class EUrlRequest
   {
       
      
      private var mUrl:String;
      
      private var mRequests:Vector.<EAssetRequest>;
      
      private var mLoader:Object;
      
      private var mPriority:int;
      
      public function EUrlRequest(url:String, request:EAssetRequest)
      {
         super();
         this.mUrl = url;
         if(request != null)
         {
            this.addRequest(request);
         }
      }
      
      public function destroy() : void
      {
         var request:EAssetRequest = null;
         this.mUrl = null;
         if(this.mRequests != null)
         {
            while(this.mRequests.length > 0)
            {
               request = this.mRequests.shift();
               request.destroy();
            }
            this.mRequests = null;
         }
         this.mLoader = null;
      }
      
      public function getUrl() : String
      {
         return this.mUrl;
      }
      
      public function getPriority() : int
      {
         return this.mPriority;
      }
      
      public function getLoader() : Object
      {
         return this.mLoader;
      }
      
      public function setLoader(value:Object) : void
      {
         this.mLoader = value;
      }
      
      public function getRequests() : Vector.<EAssetRequest>
      {
         return this.mRequests;
      }
      
      public function addRequest(value:EAssetRequest) : void
      {
         if(this.mRequests == null)
         {
            this.mRequests = new Vector.<EAssetRequest>(0);
            this.mPriority = value.getPriority();
         }
         this.mRequests.push(value);
      }
      
      public function success() : void
      {
         var request:EAssetRequest = null;
         if(this.mRequests != null)
         {
            while(this.mRequests.length > 0)
            {
               request = this.mRequests.shift();
               request.success();
               request.destroy();
            }
         }
      }
      
      public function error() : void
      {
         var request:EAssetRequest = null;
         if(this.mRequests != null)
         {
            while(this.mRequests.length > 0)
            {
               request = this.mRequests.shift();
               request.error();
               request.destroy();
            }
         }
      }
   }
}
