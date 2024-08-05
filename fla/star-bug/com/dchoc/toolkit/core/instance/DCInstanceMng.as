package com.dchoc.toolkit.core.instance
{
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.flow.DCApplication;
   import com.dchoc.toolkit.core.notify.DCNotifyMng;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.animations.DCAnimMng;
   import com.dchoc.toolkit.utils.collisionboxes.DCCollisionBoxMng;
   import com.dchoc.toolkit.utils.memory.DCPoolMng;
   import com.dchoc.toolkit.view.conf.DCGUIDefMng;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   import flash.utils.Dictionary;
   
   public class DCInstanceMng
   {
      
      private static const SKU_ACCELERATOR_DEF_MNG:String = "AcceleratorDefMng";
      
      private static const SKU_ANIM_MNG:String = "AnimMng";
      
      private static const SKU_APPLICATION:String = "Application";
      
      private static const SKU_NOTIFY_MNG:String = "NotifyMng";
      
      private static const SKU_RESOURCE_MNG:String = "ResourceMng";
      
      private static const SKU_LOGGER_MNG:String = "LoggerMng";
      
      private static const SKU_ROLE:String = "Role";
      
      private static const SKU_RULE_MNG:String = "RuleMng";
      
      private static const SKU_VIEW_MNG:String = "ViewMng";
      
      private static const SKU_POPUP_MNG:String = "PopupMng";
      
      private static const SKU_POOL_MNG:String = "PoolMng";
      
      private static const SKU_SELECT_CIRCLE_MNG:String = "SelectionCircleMng";
      
      private static const SKU_GUI_CONTROLLER:String = "GUIController";
      
      private static const SKU_COLLISION_BOX_MNG:String = "CollisionBoxMng";
      
      private static const SKU_GUIDEF_MNG:String = "GUIDefMng";
      
      protected static var smInstance:DCInstanceMng;
       
      
      protected var mCatalog:Dictionary;
      
      public function DCInstanceMng()
      {
         super();
         if(smInstance == null)
         {
            this.mCatalog = new Dictionary(true);
            smInstance = this;
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","WARNING in DCInstanceMgr.DCInstanceMgr(): Only one instance is allowed",1);
         }
      }
      
      public static function getInstance() : DCInstanceMng
      {
         return smInstance;
      }
      
      public function unload() : void
      {
         this.mCatalog = null;
         smInstance = null;
      }
      
      public function registerInstance(sku:String, i:DCComponent) : void
      {
         this.mCatalog[sku] = i;
      }
      
      protected function unregisterInstance(sku:String) : void
      {
         if(this.mCatalog[sku] != null)
         {
            delete this.mCatalog[sku];
         }
      }
      
      public function getInstance(sku:String) : Object
      {
         return this.mCatalog[sku];
      }
      
      public function registerData(sku:String, i:*) : void
      {
         this.mCatalog[sku] = i;
      }
      
      public function getData(sku:String) : *
      {
         return this.mCatalog[sku];
      }
      
      public function registerAnimMng(i:DCAnimMng) : void
      {
         this.mCatalog["AnimMng"] = i;
      }
      
      public function getAnimMng() : DCAnimMng
      {
         return this.mCatalog["AnimMng"];
      }
      
      public function registerApplication(i:DCApplication) : void
      {
         this.mCatalog["Application"] = i;
      }
      
      public function getApplication() : DCApplication
      {
         return this.mCatalog["Application"];
      }
      
      public function registerNotifyMng(i:DCNotifyMng) : void
      {
         this.mCatalog["NotifyMng"] = i;
      }
      
      public function getNotifyMng() : DCNotifyMng
      {
         return this.mCatalog["NotifyMng"];
      }
      
      public function getSelectionCircleMng() : DCNotifyMng
      {
         return this.mCatalog["SelectionCircleMng"];
      }
      
      public function registerResourceMng(i:DCResourceMng) : void
      {
         this.mCatalog["ResourceMng"] = i;
      }
      
      public function getResourceMng() : DCResourceMng
      {
         return this.mCatalog["ResourceMng"];
      }
      
      public function registerRuleMng(i:DCRuleMng) : void
      {
         this.mCatalog["RuleMng"] = i;
      }
      
      public function getRuleMng() : DCRuleMng
      {
         return this.mCatalog["RuleMng"];
      }
      
      public function registerViewMng(i:DCViewMng) : void
      {
         this.mCatalog["ViewMng"] = i;
      }
      
      public function getViewMng() : DCViewMng
      {
         return this.mCatalog["ViewMng"];
      }
      
      public function registerPopupMng(i:DCPopupMng) : void
      {
         this.mCatalog["PopupMng"] = i;
      }
      
      public function getPopupMng() : DCPopupMng
      {
         return this.mCatalog["PopupMng"];
      }
      
      public function registerPoolMng(i:DCPoolMng) : void
      {
         this.mCatalog["PoolMng"] = i;
      }
      
      public function getPoolMng() : DCPoolMng
      {
         return this.mCatalog["PoolMng"];
      }
      
      public function registerCollisionBoxMng(i:DCCollisionBoxMng) : void
      {
         this.mCatalog["CollisionBoxMng"] = i;
      }
      
      public function getCollisionBoxMng() : DCCollisionBoxMng
      {
         return this.mCatalog["CollisionBoxMng"];
      }
      
      public function registerGUIDefMng(i:DCGUIDefMng) : void
      {
         this.mCatalog["GUIDefMng"] = i;
      }
      
      public function getGUIDefMng() : DCGUIDefMng
      {
         return this.mCatalog["GUIDefMng"];
      }
   }
}
