package esparragon.widgets.paginator
{
   public class EPaginatorComponent
   {
       
      
      private var mView:EPaginatorView;
      
      private var mController:EPaginatorController;
      
      public function EPaginatorComponent()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.mView = null;
         this.mController = null;
      }
      
      public function init(view:EPaginatorView, controller:EPaginatorController) : void
      {
         this.mView = view;
         this.mController = controller;
      }
      
      public function setPageId(id:int) : void
      {
         this.mView.setPageId(id);
         this.mController.setPageId(this,id);
      }
   }
}
