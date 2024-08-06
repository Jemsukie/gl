package com.dchoc.game.core.utils.animations
{
   import com.dchoc.toolkit.utils.animations.DCAnimImpFilter;
   import com.dchoc.toolkit.utils.animations.DCAnimMng;
   import com.dchoc.toolkit.utils.animations.DCAnimType;
   import com.dchoc.toolkit.utils.animations.DCAnimTypeParticle;
   import com.dchoc.toolkit.utils.animations.DCAnimTypeSequence;
   import com.dchoc.toolkit.utils.math.DCMath;
   import flash.utils.Dictionary;
   
   public class AnimMng extends DCAnimMng
   {
      
      public static const TYPES_WIO_BASE_BUILDING_ID:int = 0;
      
      public static const TYPES_WIO_BASE_READY_ID:int = 1;
      
      public static const TYPES_WIO_SELECTED_NORMAL_ID:int = 2;
      
      public static const TYPES_WIO_SELECTED_DEFENSE_ID:int = 3;
      
      public static const TYPES_WIO_SELECTED_DEFENSE_SPY_ID:int = 4;
      
      public static const TYPES_WIO_SELECTED_DEFENSE_SPY_ADVANCED_ID:int = 5;
      
      public static const TYPES_WIO_SELECTED_INFLUENCED_BY_DECORATION_ID:int = 6;
      
      public static const TYPES_WIO_OUTLINE_WAITING_TO_BE_RECYCLED:int = 7;
      
      public static const TYPES_WIO_BASE_BROKEN_SMOKE_ID:int = 8;
      
      public static const TYPES_WIO_ICON_CONNECTED_ID:int = 9;
      
      public static const TYPES_WIO_ICON_BUILDING_END_ID:int = 10;
      
      public static const TYPES_WIO_ICON_COINS_RENT_PROGRESS_ID:int = 11;
      
      public static const TYPES_WIO_ICON_COINS_RENT_READY_ID:int = 12;
      
      public static const TYPES_WIO_ICON_COINS_RENT_COLLECTING_ID:int = 13;
      
      public static const TYPES_WIO_ICON_MINERALS_RENT_PROGRESS_ID:int = 14;
      
      public static const TYPES_WIO_ICON_MINERALS_RENT_READY_ID:int = 15;
      
      public static const TYPES_WIO_ICON_MINERALS_RENT_COLLECTING_ID:int = 16;
      
      public static const TYPES_WIO_ICON_DEMOLITION_END_ID:int = 17;
      
      public static const TYPES_WIO_ICON_SHIPYARD_WORKING_ID:int = 18;
      
      public static const TYPES_WIO_ICON_SHIPYARD_DEVELOPING_ID:int = 19;
      
      public static const TYPES_WIO_ICON_SHIPYARD_PAUSED_ID:int = 20;
      
      public static const TYPES_WIO_ICON_BONUS_DECORATION_ID:int = 21;
      
      public static const TYPES_WIO_ICON_BONUS_DEFENSE_ID:int = 22;
      
      public static const TYPES_WIO_BAR_DEMOLISH_ID:int = 23;
      
      public static const TYPES_WIO_BAR_DEMOLISH_OBSTACLE_ID:int = 24;
      
      public static const TYPES_WIO_PARTICLES_DROID_CONSTRUCTION_ID:int = 25;
      
      public static const TYPES_WIO_PLACE_ITEM_OK_ID:int = 26;
      
      public static const TYPES_WIO_PLACE_ITEM_NO_ID:int = 27;
      
      public static const TYPES_WIO_ICON_VISIT_FRIEND_ID:int = 28;
      
      public static const TYPES_WIO_ICON_VISIT_FRIEND_HELPED_ID:int = 29;
      
      public static const TYPES_WIO_JAIL_OPEN_ID:int = 30;
      
      public static const TYPES_WIO_GROUND_ID:int = 31;
      
      public static const TYPES_WIO_GROUND_BROKEN_ID:int = 32;
      
      public static const TYPES_WIO_GROUND_PEDESTAL_ID:int = 33;
      
      public static const TYPES_WIO_BASE_BUNKER_OPEN_DOORS_ID:int = 34;
      
      public static const TYPES_WIO_BASE_BUNKER_CLOSE_DOORS_ID:int = 35;
      
      public static const TYPES_WIO_BASE_BUNKER_GLOW_ID:int = 36;
      
      public static const TYPES_WIO_OBSERVATORY_HOLOGRAM_ID:int = 37;
      
      public static const TYPES_WIO_ANIM_ON_BASE_ID:int = 38;
      
      public static const TYPES_WIO_BASE_MINE_FLYING_ID:int = 39;
      
      public static const TYPES_WIO_OUTLINE_SHIPYARD_HIGHLIGHT:int = 40;
      
      public static const TYPES_WIO_OUTLINE_CAN_BE_SPIED:int = 41;
      
      public static const TYPES_WIO_PUMPKIN_MINE_READY:int = 42;
      
      public static const TYPES_WIO_PUMPKIN_MINE_EXPLOSION:int = 43;
      
      public static const TYPES_WIO_OUTLINE_UMBRELLA:int = 44;
      
      public static const TYPES_WIO_PLACE_ITEM_OK_BASE_ID:int = 45;
      
      public static const TYPES_WIO_ICON_REFINERY_FINISHED_ID:int = 46;
      
      private static const TYPES_COUNT:int = 47;
      
      public static const IMP_WIO_BASE_BUILDING_SWF:int = 0;
      
      public static const IMP_WIO_BASE_READY_SWF:int = 1;
      
      public static const IMP_WIO_BASE_UNIT_READY_SWF:int = 2;
      
      private static const IMP_WIO_BASE_MINE_FLYING_SWF:int = 3;
      
      private static const IMP_WIO_PUMPKIN_MINE:int = 4;
      
      public static const IMP_WIO_PUMPKIN_MINE_EXPLOSION:int = 5;
      
      private static const IMP_WIO_SELECTED_NORMAL_FILTER:int = 6;
      
      private static const IMP_WIO_SELECTED_INFLUENCED_BY_DECORATION_FILTER:int = 7;
      
      private static const IMP_WIO_WAITING_TO_BE_RECYCLED_FILTER:int = 8;
      
      private static const IMP_WIO_BASE_BROKEN_SMOKE_ID:int = 9;
      
      private static const IMP_WIO_ICON_CONNECTED_SWF:int = 10;
      
      private static const IMP_WIO_ICON_BUILDING_END_SWF:int = 11;
      
      private static const IMP_WIO_ICON_COINS_RENT_PROGRESS_SWF:int = 12;
      
      private static const IMP_WIO_ICON_COINS_RENT_READY_SWF:int = 13;
      
      private static const IMP_WIO_ICON_COINS_RENT_COLLECTING_SWF:int = 14;
      
      private static const IMP_WIO_ICON_MINERALS_RENT_PROGRESS_SWF:int = 15;
      
      private static const IMP_WIO_ICON_MINERALS_RENT_READY_SWF:int = 16;
      
      private static const IMP_WIO_ICON_MINERALS_RENT_COLLECTING_SWF:int = 17;
      
      private static const IMP_WIO_ICON_DEMOLITION_END_SWF:int = 11;
      
      private static const IMP_WIO_ANIM_ON_BASE:int = 18;
      
      private static const IMP_WIO_ANIM_ON_BASE_PULSE:int = 19;
      
      private static const IMP_WIO_ICON_SHIPYARD_WORKING_SWF:int = 20;
      
      private static const IMP_WIO_ICON_SHIPYARD_PAUSED_SWF:int = 21;
      
      private static const IMP_WIO_ICON_BONUS_DECORATION_SWF:int = 22;
      
      private static const IMP_WIO_ICON_BONUS_DEFENSE_SWF:int = 23;
      
      private static const IMP_WIO_DEFENSE_CUPOLA_OPENING_SWF:int = 24;
      
      private static const IMP_WIO_DEFENSE_CUPOLA_RUNNING_SWF:int = 25;
      
      private static const IMP_WIO_DEFENSE_SPY_CUPOLA_OPENING_SWF:int = 26;
      
      private static const IMP_WIO_DEFENSE_SPY_CUPOLA_RUNNING_SWF:int = 27;
      
      private static const IMP_WIO_BAR_DEMOLISH_ID:int = 28;
      
      private static const IMP_WIO_BAR_DEMOLISH_OBSTACLE_ID:int = 29;
      
      private static const IMP_WIO_PLACE_FILTER_OK:int = 30;
      
      private static const IMP_WIO_PLACE_FILTER_NO:int = 31;
      
      private static const IMP_WIO_GROUND_SWF:int = 32;
      
      public static const IMP_WIO_BASE_BUNKER_OPEN_DOORS_SWF:int = 33;
      
      public static const IMP_WIO_BASE_BUNKER_CLOSE_DOORS_SWF:int = 34;
      
      public static const IMP_WIO_BASE_BUNKER_GLOW_SWF:int = 35;
      
      private static const IMP_WIO_ICON_VISIT_FRIEND_SWF:int = 36;
      
      private static const IMP_WIO_ICON_VISIT_FRIEND_HELPED_SWF:int = 37;
      
      private static const IMP_WIO_JAIL_OPEN_SWF:int = 38;
      
      private static const IMP_WIO_OBSERVATORY_HOLOGRAM_SWF:int = 39;
      
      public static const IMP_WIO_ANIM_DECORATION_EMPTY:int = 40;
      
      public static const IMP_WIO_OUTLINE_SHIPYARD_HIGHLIGHT:int = 41;
      
      public static const IMP_WIO_OUTLINE_CAN_BE_SPIED:int = 42;
      
      public static const IMP_WIO_OUTLINE_UMBRELLA:int = 43;
      
      private static const IMP_WIO_PARTICLES_CONSTRUCTION_START_ID:int = 44;
      
      public static const IMP_WIO_TELEPORT_IN:int = 46;
      
      public static const IMP_WIO_TELEPORT_OUT:int = 46;
      
      public static const IMP_WIO_FLAT_SWF:int = 47;
      
      private static const IMP_WIO_PLACE_FILTER_OK_BASE:int = 48;
      
      public static const IMP_WIO_FLAT_UPGRADE:int = 49;
      
      private static const IMP_WIO_ICON_REFINERY_FINISHED_SWF:int = 50;
      
      private static const PARTICLES_CONSTRUCTION_COUNT:int = 4;
      
      private static const IMP_WIO_PARTICLES_CONSTRUCTION_END_ID:int = 54;
      
      private static const IMP_WIO_PARTICLES_DROID_CONSTRUCTION_START_ID:int = 54;
      
      private static const IMP_WIO_PARTICLES_DROID_CONSTRUCTION_END_ID:int = 58;
      
      public static const IMP_WIO_BASE_BROKEN_START_ID:int = 58;
      
      private static const BASE_BROKEN_COUNT:int = 1;
      
      public static const IMP_WIO_BASE_BROKEN_END_ID:int = 59;
      
      private static const IMP_COUNT:int = 60;
      
      private static const WIO_FORMAT_DEFAULT:int = 2;
      
      public static const ANIM_ON_BASE_KEY_FLAG:String = "flag";
      
      public static const ANIM_ON_BASE_KEY_PULSE:String = "pulse";
       
      
      private var mAnimOnBaseCatalog:Dictionary;
      
      private var mTypeToImpSelectedId:int;
      
      public function AnimMng()
      {
         super();
         this.mAnimOnBaseCatalog = new Dictionary();
         this.mAnimOnBaseCatalog["flag"] = 18;
         this.mAnimOnBaseCatalog["pulse"] = 19;
      }
      
      override protected function typesCatalogGetCount() : int
      {
         return 47;
      }
      
      override protected function typesCatalogPopulate() : void
      {
         mTypesCatalog[31] = new DCAnimType(31);
         mTypesCatalog[32] = new DCAnimType(32);
         mTypesCatalog[33] = new DCAnimType(33);
         mTypesCatalog[0] = new DCAnimType(0);
         mTypesCatalog[1] = new AnimTypeBaseReady(1,58,"brokenLevel");
         mTypesCatalog[2] = new DCAnimType(2);
         mTypesCatalog[3] = new DCAnimTypeSequence(3,new <int>[24,25],this);
         mTypesCatalog[4] = new DCAnimTypeSequence(4,new <int>[26,27],this);
         mTypesCatalog[6] = new DCAnimType(6);
         mTypesCatalog[7] = new DCAnimType(7);
         mTypesCatalog[40] = new DCAnimType(40);
         mTypesCatalog[41] = new DCAnimType(41);
         mTypesCatalog[44] = new DCAnimType(44);
         mTypesCatalog[8] = new DCAnimType(8);
         mTypesCatalog[9] = new DCAnimType(9);
         mTypesCatalog[10] = new DCAnimType(10);
         mTypesCatalog[11] = new DCAnimType(11);
         mTypesCatalog[12] = new DCAnimType(12);
         mTypesCatalog[13] = new DCAnimType(13);
         mTypesCatalog[14] = new DCAnimType(14);
         mTypesCatalog[15] = new DCAnimType(15);
         mTypesCatalog[16] = new DCAnimType(16);
         mTypesCatalog[17] = new DCAnimType(17);
         mTypesCatalog[18] = new DCAnimType(18);
         mTypesCatalog[19] = new DCAnimType(19);
         mTypesCatalog[20] = new DCAnimType(20);
         mTypesCatalog[46] = new DCAnimType(46);
         mTypesCatalog[21] = new DCAnimType(22);
         mTypesCatalog[22] = new DCAnimType(23);
         mTypesCatalog[28] = new DCAnimType(28);
         mTypesCatalog[29] = new DCAnimType(29);
         mTypesCatalog[30] = new DCAnimType(30);
         mTypesCatalog[23] = new DCAnimType(23);
         mTypesCatalog[24] = new DCAnimType(24);
         mTypesCatalog[25] = new DCAnimTypeParticle(25,65535,54,"currentParticleId");
         mTypesCatalog[26] = new DCAnimType(30);
         mTypesCatalog[45] = new DCAnimType(48);
         mTypesCatalog[27] = new DCAnimType(31);
         mTypesCatalog[34] = new DCAnimType(34);
         mTypesCatalog[35] = new DCAnimType(35);
         mTypesCatalog[36] = new DCAnimType(36);
         mTypesCatalog[37] = new DCAnimType(37);
         mTypesCatalog[38] = new AnimTypeAnimOnBase(38,this.mAnimOnBaseCatalog);
         mTypesCatalog[39] = new DCAnimType(39);
         mTypesCatalog[43] = new DCAnimType(43);
      }
      
      override protected function impCatalogGetCount() : int
      {
         return 60;
      }
      
      override protected function impCatalogPopulate() : void
      {
         var id:* = 0;
         var idStr:* = null;
         var i:int = 0;
         mImpCatalog[47] = new AnimImpSWFStar(47,0,null,null,null,true,true,true,0,null,2,0);
         mImpCatalog[49] = new AnimImpSWFFlatUpgrade(49,0,null,null,null,true,true,true,0,null,2,2);
         mImpCatalog[32] = new AnimImpSWFStar(32,0,null,null,null,true,true,true,0,null,3);
         mImpCatalog[0] = new AnimImpBaseBuilding(0,2);
         mImpCatalog[1] = new AnimImpSWFStar(0,1,null,"ready",null,true,true,true,0,null,2,1);
         mImpCatalog[2] = new AnimImpBaseUnitReady(0);
         mImpCatalog[40] = new AnimImpSWFStar(40,1,null,"empty",null,true,true,true,0,null,2,1);
         mImpCatalog[33] = new AnimImpSWFStar(33,1,null,"open",null,true,true,true,0,null,3,1,true,false);
         mImpCatalog[34] = new AnimImpSWFStar(34,1,null,"close",null,true,true,true,0,null,3,1,true,false);
         mImpCatalog[35] = new AnimImpSWFStar(35,1,null,"glow",null,true,true,true,0,null,3,1,true,false);
         mImpCatalog[39] = new AnimImpSWFStar(39,1,"assets/flash/world_items/buildings/observatory/observatory.swf","observatory_hologram",null,true,true,true,0,null,0,1,true);
         mImpCatalog[18] = new AnimImpSWFAnimOnBase(18,1);
         mImpCatalog[19] = new AnimImpSWFStar(19,1,null,"working",null,true,false,true,8500,this.animFunc,2,-99,false,true,true,true,0,{"func":DCMath.pulseGetValue});
         mImpCatalog[3] = new AnimImpSWFStar(3,1,null,"trap_lifting_up",null,true,true,true,0,null,0,1,true,false);
         mImpCatalog[5] = new AnimImpSWFStar(5,1,null,"trap_pumpkin_explosion",null,true,true,true,0,null,0,1,true,false);
         mImpCatalog[6] = new DCAnimImpFilter(6,GameConstants.FILTER_DROPSHADOW_YELLOW,-1,-1,1,"selectedLayerId");
         mImpCatalog[7] = new DCAnimImpFilter(7,GameConstants.FILTER_WAITING_FOR_DROID_FOR_RECYCLING_BLUE,1);
         mImpCatalog[8] = new DCAnimImpFilter(8,GameConstants.FILTER_WAITING_FOR_DROID_FOR_RECYCLING_BLUE,1);
         mImpCatalog[41] = new DCAnimImpFilter(41,GameConstants.FILTER_GLOW_SELECTED_SHIPYARD,1);
         mImpCatalog[42] = new DCAnimImpFilter(42,GameConstants.FILTER_GLOW_CAN_BE_SPIED,1);
         mImpCatalog[43] = new UmbrellaAnimImpFilter(43,GameConstants.FILTER_GLOW_CAN_BE_SPIED,1,-1,1,null,0.3,true);
         mImpCatalog[9] = new AnimImpSWFStar(9,-1,"assets/flash/world_items/buildings/bases/bases.swf","smoke","smoke_00",true,false,true,0,null,3);
         mImpCatalog[10] = new AnimImpSWFStar(10,-1,"assets/flash/world_items/common.swf","road_conected",null);
         mImpCatalog[11] = new AnimImpSWFStar(11,-1,"assets/flash/world_items/common.swf","construction_done",null);
         mImpCatalog[12] = new AnimImpSWFStar(12,-1,"assets/flash/world_items/common.swf","coin_rent_progress","collect",true);
         mImpCatalog[13] = new AnimImpSWFStar(13,-1,"assets/flash/world_items/common.swf","coin_collect","collect",true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[14] = new AnimImpSWFStar(14,-1,"assets/flash/world_items/common.swf","coin_collect_done","collect",true);
         mImpCatalog[15] = new AnimImpSWFStar(15,-1,"assets/flash/world_items/common.swf","resource_rent_progress","collect",true);
         mImpCatalog[16] = new AnimImpSWFStar(16,-1,"assets/flash/world_items/common.swf","resource_collect","collect",true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[17] = new AnimImpSWFStar(17,-1,"assets/flash/world_items/common.swf","resource_collect_done","collect");
         mImpCatalog[20] = new AnimImpSWFShipyards(20,3);
         mImpCatalog[21] = new AnimImpSWFStar(21,-1,"assets/flash/world_items/common.swf","full_hangar",null,true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[50] = new AnimImpSWFStar(50,-1,"assets/flash/world_items/common.swf","refinery_collect","collect",true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[22] = new AnimImpSWFWithTextFieldStar(22,-1,"assets/flash/world_items/common.swf","bonus_decoration","bonusDecoration",true);
         mImpCatalog[23] = new AnimImpSWFWithTextFieldStar(23,-1,"assets/flash/world_items/common.swf","bonus_defense","bonusDefense",true);
         mImpCatalog[24] = new AnimImpSWFStar(24,-1,"assets/flash/world_items/pngs_common/shield.png",null,null,true,false,true,400,null,2,1,false,true,true,false,1);
         mImpCatalog[25] = new AnimImpSWFStar(25,-1,"assets/flash/world_items/pngs_common/shield.png",null,null,true,false,true,2500,this.animFunc,2,1,false,true,true,false,0,{
            "func":DCMath.linearPulseGetValue,
            "min":0.45,
            "inverse":true
         });
         mImpCatalog[26] = new AnimImpSWFStar(26,-1,"assets/flash/world_items/pngs_common/shield.png",null,null,true,false,true,400,null,2,1,false,true,true,false,1);
         mImpCatalog[27] = new AnimImpSWFStar(26,-1,"assets/flash/world_items/pngs_common/shield.png",null,null,true,false,true,2500,this.animFunc,2,1,false,true,true,false,0,{
            "func":DCMath.linearPulseGetValue,
            "min":0.45,
            "inverse":true
         });
         mImpCatalog[36] = new AnimImpSWFStar(36,-1,"assets/flash/world_items/common.swf","icon_help","bar",true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[37] = new AnimImpSWFStar(37,-1,"assets/flash/world_items/common.swf","help_done","bar",true,false,true,0,null,-99,-99,false,true,false);
         mImpCatalog[38] = new AnimImpSWFStar(38,-1,"assets/flash/world_items/buildings/jail_001/jail_001.swf","jail_001_open");
         mImpCatalog[28] = new AnimImpSWFStar(28,-1,"assets/flash/_esparragon/gui/layouts/gui_old.swf","bar_recycle","bar");
         mImpCatalog[29] = new AnimImpSWFStar(29,-1,"assets/flash/_esparragon/gui/layouts/gui_old.swf","bar_destroy_obstacle","bar");
         mImpCatalog[30] = new DCAnimImpFilter(30,GameConstants.FILTER_AVAILABLE_BUILDING_GREEN,1,6422274,0.6);
         mImpCatalog[48] = new DCAnimImpFilter(48,GameConstants.FILTER_AVAILABLE_BUILDING_GREEN,0,6422274,0.6);
         mImpCatalog[31] = new DCAnimImpFilter(31,GameConstants.FILTER_UNAVAILABLE_BUILDING_RED,1,16711680,0.6);
         for(i = 0; i < 4; )
         {
            id = i + 1;
            idStr = i < 10 ? "0" + id : "" + id;
            mImpCatalog[54 + i] = new AnimImpSWFStar(54 + i,-1,"builder","working_" + idStr,"const_" + idStr,true,true,true,0,null);
            i++;
         }
         for(i = 0; i < 1; )
         {
            id = i;
            if(i == 0)
            {
               idStr = "";
            }
            else
            {
               idStr += "_";
               idStr = i < 10 ? "0" + id : "" + id;
            }
            mImpCatalog[58 + i] = new AnimImpSWFStar(58 + i,1,null,"broken" + idStr,null,true,true,true,0,null,2);
            i++;
         }
         mImpCatalog[46] = new AnimImpSWFStar(46,1,null,"in",null,true,true,true,0,null,2,1);
         mImpCatalog[46] = new AnimImpSWFStar(46,1,null,"out",null,true,true,true,0,null,2,1);
      }
      
      override protected function typeToImpPopulate() : void
      {
         typeToImpSet(31,32);
         typeToImpSet(32,32);
         typeToImpSet(33,32);
         typeToImpSet(0,0);
         typeToImpSet(1,1);
         typeToImpSet(39,3);
         typeToImpSet(43,5);
         this.mTypeToImpSelectedId = 6;
         typeToImpSet(2,this.mTypeToImpSelectedId);
         typeToImpSet(3,25);
         typeToImpSet(6,7);
         typeToImpSet(7,8);
         typeToImpSet(40,41);
         typeToImpSet(41,42);
         typeToImpSet(44,43);
         typeToImpSet(8,9);
         typeToImpSet(9,10);
         typeToImpSet(10,11);
         typeToImpSet(11,12);
         typeToImpSet(12,13);
         typeToImpSet(13,14);
         typeToImpSet(14,15);
         typeToImpSet(15,16);
         typeToImpSet(16,17);
         typeToImpSet(17,11);
         typeToImpSet(18,20);
         typeToImpSet(19,19);
         typeToImpSet(20,21);
         typeToImpSet(46,50);
         typeToImpSet(21,22);
         typeToImpSet(22,23);
         typeToImpSet(28,36);
         typeToImpSet(29,37);
         typeToImpSet(30,38);
         typeToImpSet(23,28);
         typeToImpSet(24,29);
         typeToImpSet(25,-1);
         typeToImpSet(26,30);
         typeToImpSet(45,48);
         typeToImpSet(27,31);
         typeToImpSet(34,33);
         typeToImpSet(35,34);
         typeToImpSet(36,35);
         typeToImpSet(37,39);
         typeToImpSet(38,18);
      }
      
      public function typeToImpChangeSelected() : void
      {
      }
      
      private function animFunc(currentTime:Number, totalTime:Number, params:Object) : Number
      {
         var func:Function = null;
         var min:Number = NaN;
         var inverse:Boolean = false;
         var returnValue:Number = 1;
         if(params != null)
         {
            func = params.func;
            min = 0;
            if(params.min != null)
            {
               min = Number(params.min);
            }
            inverse = false;
            if(params.inverse != null)
            {
               inverse = Boolean(params.inverse);
            }
            returnValue = func(currentTime,totalTime,min,inverse);
         }
         return returnValue;
      }
   }
}
