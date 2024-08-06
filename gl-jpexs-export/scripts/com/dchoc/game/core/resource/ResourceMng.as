package com.dchoc.game.core.resource
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.AnimationsDef;
   import com.dchoc.game.model.rule.FlagImagesDef;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.resource.DCResourceDef;
   import com.dchoc.toolkit.core.resource.DCResourceDefLoaded;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class ResourceMng extends DCResourceMng
   {
      
      public static const DIR_DATA:String = "";
      
      public static const UNIVERSE_OWNER_NAME:String = "universe.xml";
      
      public static const UNIVERSE_FRIEND_NAME:String = "universeFriend.xml";
      
      public static const UNIVERSE_FRIEND_2_NAME:String = "universeFriend2.xml";
      
      public static const UNIVERSE_COLONY_NAME:String = "universeColony.xml";
      
      public static const DIR_DATA_USERDATA:String = "userdata/";
      
      public static const USERDATA_UNIVERSE_TUTORIAL:String = "userdata/universe.xml";
      
      public static const USERDATA_UNIVERSE_OWNER:String = "userdata/universe.xml";
      
      public static const USERDATA_UNIVERSE_FRIEND:String = "userdata/universeFriend.xml";
      
      public static const USERDATA_UNIVERSE_FRIEND_2:String = "userdata/universeFriend2.xml";
      
      public static const USERDATA_UNIVERSE_COLONY:String = "userdata/universeColony.xml";
      
      public static const USERDATA_UNIVERSE_NPC_BASE_INI:String = "userdata/universe_";
      
      public static const USERDATA_UNIVERSE_NPC_BASE_END:String = "0.xml";
      
      public static const USERDATA_GALAXY_LIST:String = "userdata/galaxyWindow.xml";
      
      public static const USERDATA_STAR_PLANETS_LIST:String = "userdata/starPlanetsWindow.xml";
      
      public static const USERDATA_NEIGHBOR_INFO:String = "userdata/neighborInfo.xml";
      
      public static const USERDATA_FRIENDS_LIST:String = "userdata/friendsList.xml";
      
      public static const USERDATA_NEIGHBOR_LIST:String = "userdata/neighborList.xml";
      
      public static const USERDATA_NPC_LIST:String = "userdata/npcList.xml";
      
      public static const USERDATA_ATTACKER_LIST:String = "userdata/attackerList.xml";
      
      public static const USERDATA_ITEMS_LIST:String = "userdata/itemsList.xml";
      
      public static const USERDATA_ACTIONS_PERFORMED_BY_FRIENDS_LIST:String = "userdata/actionsPerformedByFriendsList.xml";
      
      public static const USERDATA_SPECIAL_ATTACKS_LIST:String = "userdata/specialAttacksList.xml";
      
      public static const USERDATA_HANGARS_HELP_LIST:String = "userdata/hangarsHelpList.xml";
      
      public static const USERDATA_HANGAR_UPDATED:String = "userdata/hangarUpdated.xml";
      
      public static const USERDATA_BOOKMARKS_LIST:String = "userdata/bookmarks.xml";
      
      public static const USERDATA_CUSTOMIZER:String = "userdata/customizer.xml";
      
      public static const USERDATA_BATTLE_REPLAY:String = "userdata/battleReplay.xml";
      
      public static const USERDATA_ALLIANCES_LIST:String = "userdata/alliancesList.json";
      
      public static const USERDATA_ALLIANCES_LIST_2:String = "userdata/alliancesList2.json";
      
      public static const USERDATA_ALLIANCES_WARS_HISTORY_LIST:String = "userdata/alliancesWarsHistory.json";
      
      public static const USERDATA_ALLIANCES_WARS_HISTORY_LIST_2:String = "userdata/alliancesWarsHistory2.json";
      
      public static const USERDATA_ALLIANCES_SUGGESTED_WARS:String = "userdata/alliancesSuggestedWar.json";
      
      public static const USERDATA_ALLIANCES_NEWS:String = "userdata/alliancesNews.json";
      
      public static const USERDATA_PENDING_TRANSACTIONS:String = "userdata/pendingTransactions.xml";
      
      public static const USERDATA_INVESTS_LIST:String = "userdata/investsList.xml";
      
      public static const USERDATA_WEEKLY_SCORE_LIST:String = "userdata/weeklyScoreList.xml";
      
      public static const USERDATA_HANGARS_OWNER_LIST:String = "userdata/hangarsOwnerList.xml";
      
      public static const USERDATA_TEMPLATES:String = "userdata/templates.xml";
      
      public static const USERDATA_CONTEST_LIST:String = "userdata/contestList.json";
      
      public static const USERDATA_CONTEST_PROGRESS:String = "userdata/contestProgress.json";
      
      public static const USERDATA_CONTEST_LEADERBOARD:String = "userdata/contestLeaderboard.json";
      
      public static const USERDATA_UPSELLING:String = "userdata/upSelling.xml";
      
      public static const DIR_DATA_ASSETS:String = "assets/flash/";
      
      public static const DIR_DATA_NEWS_FEED:String = "assets/new_feeds/";
      
      public static const DIR_DATA_WORLD_ITEMS:String = "assets/flash/world_items/";
      
      public static const DIR_DATA_WORLD_ITEMS_BUILDINGS:String = "assets/flash/world_items/buildings/";
      
      public static const DIR_DATA_NPCS:String = "assets/npcs/";
      
      public static const DIR_DATA_SPACE:String = "assets/flash/space_maps/";
      
      public static const DIR_DATA_PLANETS:String = "assets/flash/space_maps/planets/";
      
      public static const DIR_DATA_SOLAR_SYSTEM:String = "assets/flash/space_maps/solar_systems/";
      
      public static const DIR_DATA_SPACE_BACKGROUND:String = "assets/flash/space_maps/backgrounds/";
      
      public static const DIR_DATA_GUI_LIBRARY:String = "assets/flash/gui/library/";
      
      private static const DIR_DATA_BASES_FOLDER:String = "assets/flash/world_items/buildings/";
      
      public static const ASSETS_WIO_BASES_STONE_SWF:String = "assets/flash/world_items/buildings/bases/bases.swf";
      
      public static const ASSETS_WIO_BASES_DIRT_SWF:String = "assets/flash/world_items/buildings/bases/bases_dirt.swf";
      
      public static const ASSETS_WIO_OBSERVATORY_HOLOGRAM_SWF:String = "assets/flash/world_items/buildings/observatory/observatory.swf";
      
      public static const ASSETS_WIO_FLATBED_UPGRADE:String = "assets/flash/world_items/buildings/flatBed/upgrade-";
      
      public static const ASSETS_BATTLE_TURRET_SWF:String = "defense_001";
      
      public static const ASSETS_BATTLE_TURRET_SWF4:String = "defense_004";
      
      public static const ASSETS_BATTLE_TURRET_LASER:String = "laser_001";
      
      public static const ASSETS_BATTLE_TURRET_MISSILE_LAUNCHER:String = "missile_launcher_001";
      
      public static const ASSETS_BATTLE_TURRET_MORTAR:String = "mortar_001";
      
      public static const ASSETS_BATTLE_TURRET_FREEZE:String = "freeze_turret";
      
      private static const DIR_DATA_BATTLE:String = "assets/flash/battle_effects/";
      
      public static const ASSETS_NUKE_SWF:String = "nuke";
      
      public static const ASSETS_NUKE_CRATER_PNG:String = "crater_nuke";
      
      public static const ASSETS_CAPSULE_SWF:String = "capsule";
      
      public static const ASSETS_CAPSULE_CRATER_PNG:String = "crater_capsule";
      
      public static const ASSETS_BATTLE_EFFECTS_SWF:String = "battle_effects";
      
      public static const ASSETS_BULLET001_SWF:String = "missile_001";
      
      public static const ASSETS_BOMB_SWF:String = "bomb";
      
      public static const ASSETS_FIREBALL_SWF:String = "fireball";
      
      public static const ASSETS_TORNADO_SWF:String = "tornado";
      
      public static const ASSETS_ROCK_SWF:String = "rock";
      
      public static const ASSETS_PUMPKIN_MINE:String = "trap_pumpkin";
      
      public static const ASSETS_PUMPKIN_MINE_02:String = "trap_pumpkin_02";
      
      public static const ASSETS_CRATER_000:String = "assets/flash/battle_effects/crater.png";
      
      public static const ASSETS_BACKGROUNDS:String = "assets/flash/background/";
      
      public static const ASSETS_DEFAULT_BACKGROUND_NAME_SWF:String = "background_animated.swf";
      
      public static const ASSETS_DEFAULT_BACKGROUND_ALLIANCE_ANIMATION_NAME:String = "alliance_council";
      
      public static const ASSETS_DEFAULT_BACKGROUND_ALLIANCE_ANIMATION_NAME_SWF:String = "alliance_council.swf";
      
      public static const ASSETS_BACKGROUND_GALAXY_SWF:String = "assets/flash/space_maps/backgrounds/background_galaxy.swf";
      
      public static const ASSETS_BACKGROUND_SPACE_STAR_SWF:String = "assets/flash/space_maps/backgrounds/solar_system_2_5.swf";
      
      public static const ASSETS_BG_ALLIANCE_ANIMATIONS:String = "assets/flash/background/animations/alliance_council/";
      
      public static const ASSETS_BG_ALLIANCE_COUNCIL_DEFAULT:String = "assets/flash/background/animations/alliance_council/alliance_council.swf";
      
      public static const ASSETS_COMMON_SWF:String = "assets/flash/world_items/common.swf";
      
      public static const ASSETS_GUI_OPTIMIZED_SWF:String = "assets/flash/_esparragon/gui/layouts/gui_old.swf";
      
      public static const ASSETS_POPUPS_SWF:String = "assets/flash/gui/popups.swf";
      
      public static const ASSETS_POPUPS_EXPORTED_SWF:String = "assets/flash/gui/popups_exported.swf";
      
      public static const ASSETS_POPUPS_CONTAINER_HAPPENINGS_SWF:String = "assets/flash/gui/container_happenings.swf";
      
      public static const ASSETS_POPUPS_HALLOWEEN_SWF:String = "assets/flash/halloween/popups.swf";
      
      public static const ASSETS_POPUPS_DOOMSDAY_SWF:String = "assets/flash/doomsday/popups.swf";
      
      public static const ASSETS_SPY_CAPSULE:String = "assets/flash/gui/spy_capsule.swf";
      
      public static const ASSETS_CUPOLA_OPEN_PNG:String = "assets/flash/world_items/pngs_common/shield.png";
      
      public static const ASSETS_CUPOLA_SPY_OPEN_PNG:String = "assets/flash/world_items/pngs_common/shield_spy.png";
      
      public static const ASSETS_ICON_COINS:String = "assets/flash/world_items/pngs_common/particle_coin.png";
      
      public static const ASSETS_ICON_MINERALS:String = "assets/flash/world_items/pngs_common/particle_resource.png";
      
      public static const ASSETS_ICON_XP:String = "assets/flash/world_items/pngs_common/particle_experience.png";
      
      public static const ASSETS_GRILLE:String = "assets/flash/world_items/pngs_common/grille.png";
      
      public static const ASSETS_KIDNAP_SWF:String = "assets/flash/tutorial/abduction_assets.swf";
      
      public static const ASSETS_DROID_SWF:String = "builder";
      
      public static const ASSETS_MECHA_STARLING_SWF:String = "mecha_starling";
      
      public static const ASSETS_CITIZEN_SWF:String = "citizen_001";
      
      public static const ASSETS_MARINE_SWF:String = "marine_001";
      
      public static const ASSETS_LOOTER_SWF:String = "looter_001";
      
      public static const ASSETS_FLAMETHROWER_SWF:String = "flamethrower_001";
      
      public static const ASSETS_BLAST_SWF:String = "blast_001";
      
      public static const ASSETS_BAZOOKA_SWF:String = "bazooka_001";
      
      public static const ASSETS_SSOLDIER_SWF:String = "super_soldier_001";
      
      public static const ASSETS_MERCENARY_SOLDIER_SWF:String = "mercenary_marine";
      
      public static const ASSETS_MERCENARY_MECHA_SWF:String = "mercenary_mecha";
      
      public static const ASSETS_GENERAL_SWF:String = "general";
      
      public static const ASSETS_TANK_SWF:String = "tank_001";
      
      public static const ASSETS_SUPERTANK_SWF:String = "supertank_001";
      
      public static const ASSETS_HOOVER_TANK_SWF:String = "hoover_tank_001";
      
      public static const ASSETS_DRILLER_SWF:String = "driller_001";
      
      public static const ASSETS_TRIKE_SWF:String = "trike";
      
      public static const ASSETS_OVNI_SWF:String = "ovni";
      
      public static const ASSETS_HELICOPTER_SWF:String = "helicopter";
      
      public static const ASSETS_ZEPPELIN_SWF:String = "zeppelin";
      
      public static const ASSETS_BATTLESHIP_SWF:String = "battleship";
      
      public static const ASSETS_MENDER_SWF:String = "mender_001";
      
      public static const ASSETS_ENTERPRISE_SWF:String = "enterprise";
      
      public static const ASSETS_SKELETON_SWF:String = "skeleton_001";
      
      public static const ASSETS_ZOMBIE_SWF:String = "zombie_001";
      
      public static const ASSETS_DEMON_SWF:String = "demon_001";
      
      public static const ASSETS_JASON_SWF:String = "jason_001";
      
      public static const ASSETS_BEHOLDER_SWF:String = "demon_002";
      
      public static const ASSETS_MAYAN_GOLEM_THUNDER:String = "mayan_golem_thunder";
      
      public static const ASSETS_MAYAN_GOLEM_TORNADO:String = "mayan_golem_tornado";
      
      public static const ASSETS_MAYAN_GOLEM_ROCK:String = "mayan_golem_rocks";
      
      public static const ASSETS_MAYAN_GOLEM_FIRE:String = "mayan_golem_fire";
      
      public static const ASSETS_MAYAN_GOLEM_FOREST:String = "mayan_golem_forest";
      
      public static const ASSETS_DEATH_SWF:String = "deaths";
      
      public static const ASSETS_LOADING_LIB:String = "assets/flash/generic_loading.swf";
      
      public static const ASSETS_JAIL_SWF:String = "assets/flash/world_items/buildings/jail_001/jail_001.swf";
      
      public static const ASSETS_COLLECTOR_RENT_SWF:String = "world_items/units/recolector_money.swf";
      
      public static const ASSETS_COLLECTOR_MINERAL_SWF:String = "world_items/units/recolector_mineral.swf";
      
      public static const SHOP_RESOURCES_PATH:String = "assets/flash/world_items/";
      
      public static const COLLECTABLES_PATH:String = "assets/flash/gifts/";
      
      public static const CHARACTERS_PATH:String = "assets/flash/gui/characters/";
      
      public static const ALLIANCES_CHARACTERS_PATH:String = "assets/flash/gui/library/png/character/";
      
      public static const ILLUSTRATIONS_PATH:String = "assets/flash/gui/library/png/illustrations/";
      
      public static const PASS_FRIENDS_PATH:String = "assets/flash/gui/library/png/pass_friend/";
      
      public static const PROMOTIONS_PATH:String = "assets/flash/gui/library/png/promotions/";
      
      public static const UNITS_RESOURCES_PATH:String = "assets/flash/world_items/units/";
      
      public static const UNITS_BUILDINGS_RESOURCES_PATH:String = "assets/flash/world_items/buildings/";
      
      public static const MISSION_RESOURCES_PATH:String = "assets/flash/gui/missions/";
      
      public static const COMMON_RESOURCES_PATH:String = "assets/flash/gui/library/png/common/";
      
      public static const ASSETS_PLANETS_PATH:String = "assets/flash/gui/library/png/planets/";
      
      public static const ASSETS_CONTEST_PATH:String = "assets/flash/_esparragon/gui/features/contest_tool/";
      
      public static const ASSETS_CONTEST_IMAGES_PATH:String = "assets/flash/_esparragon/gui/features/contest_tool/images/";
      
      public static const ASSETS_HALLOWEEN_PATH:String = "assets/flash/halloween/";
      
      public static const DIR_SND:String = "sounds/";
      
      public static const MUSIC_MAIN:String = "music_main.mp3";
      
      public static const MUSIC_BATTLE:String = "music_battle.mp3";
      
      public static const MUSIC_MAP:String = "music_map.mp3";
      
      public static const MUSIC_MERCENARIES:String = "music_mercenaris.mp3";
      
      public static const MUSIC_ALLIANCE_START:String = "allianceintro.mp3";
      
      public static const MUSIC_ALLIANCE_WAR_START:String = "alliancewarintro.mp3";
      
      public static const MUSIC_COLONIZE:String = "colonize.mp3";
      
      public static const MUSIC_ALLIANCE_WAR_WON:String = "warwon.mp3";
      
      public static const SND_COINS:String = "collect_coin.mp3";
      
      public static const SND_MINERALS:String = "collect_mineral.mp3";
      
      public static const SND_ITEM:String = "collect_item.mp3";
      
      public static const SND_LASER:String = "laser.mp3";
      
      public static const SND_BUILD:String = "build.mp3";
      
      public static const SND_REPAIR:String = "repair.mp3";
      
      public static const SND_EXPLODE:String = "explode.mp3";
      
      public static const SND_EXPLOSION_4:String = "explosion4.mp3";
      
      public static const SND_CLICK:String = "click.mp3";
      
      public static const SND_MOUSEOVER:String = "mouseover.mp3";
      
      public static const SND_WARP:String = "warp.mp3";
      
      public static const SND_FIREWORK:String = "firework.mp3";
      
      public static const SND_HURRAY:String = "hurray.mp3";
      
      public static const SND_LEVELUP:String = "levelup.mp3";
      
      public static const SND_FREEZE:String = "freeze.mp3";
      
      public static const SND_NUKE_FALLING:String = "nuke_falling.mp3";
      
      public static const SND_NUKE_EXPLOSION:String = "nuke_explosion.mp3";
      
      public static const SND_NUKE_MUSHROOM:String = "nuke_mushroom.mp3";
      
      public static const SND_NUKE_POST_EXPLOSION:String = "nuke_beep.mp3";
      
      public static const SND_PHOTON_1:String = "photon_1.mp3";
      
      public static const SND_PHOTON_2:String = "photon_2.mp3";
      
      public static const SND_CAPSULE_FALLING:String = "capsule_falling.mp3";
      
      public static const SND_CAPSULE_EXPLOSION:String = "capsule_explosion.mp3";
      
      public static const SND_CAPSULE_OPENING:String = "capsule_opening.mp3";
      
      public static const SND_THICKING:String = "thicking.mp3";
      
      public static const SND_BONES:String = "bones.mp3";
      
      public static const SND_SAW:String = "saw.mp3";
      
      public static const SND_VOMIT:String = "vomit.mp3";
      
      public static const SND_VOICE_1:String = "Body_1.mp3";
      
      public static const SND_VOICE_2:String = "Body_2.mp3";
      
      public static const SND_VOICE_3:String = "Body_3.mp3";
      
      public static const SND_VOICE_4:String = "Body_4.mp3";
      
      public static const SND_VOICE_5:String = "Body_5a.mp3";
      
      public static const SND_VOICE_6:String = "Body_6.mp3";
      
      public static const SND_VOICE_7:String = "Body_7.mp3";
      
      public static const SND_VOICE_8:String = "Body_8.mp3";
      
      public static const SND_VOICE_9:String = "Body_9a.mp3";
      
      public static const SND_VOICE_10:String = "Body_10.mp3";
      
      public static const SND_VOICE_11:String = "Body_11.mp3";
      
      public static const SND_VOICE_12:String = "Body_12.mp3";
      
      public static const SND_VOICE_13:String = "Body_13.mp3";
      
      public static const SND_UMBRELLA_OPENING:String = "umbrella_deployed.mp3";
      
      public static const SND_UMBRELLAS_DEPLOYED:String = "shield_activated.mp3";
      
      public static const SND_UMBRELLA_SHIP_COMING:String = "enterprise.mp3";
      
      public static const ASSET_SPACE_STAR_01:String = "assets/flash/space_maps/solar_systems/solar_system_01.png";
      
      public static const ASSET_SPACE_STAR_TOOLTIP:String = "assets/flash/space_maps/solar_systems/solar_system_tooltip.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY:String = "assets/flash/space_maps/planets/planet_empty.png";
      
      public static const ASSET_PLANETS_PLANET_ELDERBY:String = "assets/flash/space_maps/planets/planet_05.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY_01:String = "assets/flash/space_maps/planets/planet_empty_01.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY_02:String = "assets/flash/space_maps/planets/planet_empty_02.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY_03:String = "assets/flash/space_maps/planets/planet_empty_03.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY_04:String = "assets/flash/space_maps/planets/planet_empty_04.png";
      
      public static const ASSET_PLANETS_PLANET_EMPTY_05:String = "assets/flash/space_maps/planets/planet_empty_05.png";
      
      public static const ASSET_PLANETS_PLANET_FIRE:String = "assets/flash/space_maps/planets/planet_fire.png";
      
      public static const ASSET_PLANETS_PLANET_MAGMA:String = "assets/flash/space_maps/planets/planet_magma.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_00:String = "assets/flash/space_maps/planets/planet_sun_00.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_01:String = "assets/flash/space_maps/planets/planet_sun_01.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_02:String = "assets/flash/space_maps/planets/planet_sun_02.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_03:String = "assets/flash/space_maps/planets/planet_sun_03.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_04:String = "assets/flash/space_maps/planets/planet_sun_04.png";
      
      public static const ASSET_PLANETS_PLANET_SUN_05:String = "assets/flash/space_maps/planets/planet_sun_05.png";
      
      public static const ASSET_PLANETS_PLANET_ICE:String = "assets/flash/space_maps/planets/planet_ice.png";
      
      public static const ASSET_PLANETS_PLANET_PIRATE:String = "assets/flash/space_maps/planets/planet_pirate.png";
      
      public static const ASSET_PLANETS_PLANET_BLACK_HOLE:String = "assets/flash/space_maps/planets/planet_black_hole.png";
      
      public static const ASSET_PLANET_BLUE:String = "assets/flash/gui/library/png/planets/planet_blue.png";
      
      public static const ASSET_PLANET_GREEN:String = "assets/flash/gui/library/png/planets/planet_green.png";
      
      public static const ASSET_PLANET_MAIN:String = "assets/flash/gui/library/png/planets/planet_main.png";
      
      public static const ASSET_PLANET_MAIN_LVL_1:String = "assets/flash/space_maps/planets/planet_01.png";
      
      public static const ASSET_PLANET_MAIN_LVL_2:String = "assets/flash/space_maps/planets/planet_02.png";
      
      public static const ASSET_PLANET_MAIN_LVL_3:String = "assets/flash/space_maps/planets/planet_03.png";
      
      public static const ASSET_PLANET_MAIN_LVL_4:String = "assets/flash/space_maps/planets/planet_04.png";
      
      public static const ASSET_PLANET_MAIN_LVL_5:String = "assets/flash/space_maps/planets/planet_05.png";
      
      public static const ASSET_PLANET_RED:String = "assets/flash/gui/library/png/planets/planet_red.png";
      
      public static const ASSET_PLANET_VIOLET:String = "assets/flash/gui/library/png/planets/planet_violet.png";
      
      public static const ASSET_PLANET_WHITE:String = "assets/flash/gui/library/png/planets/planet_white.png";
      
      public static const ASSET_PLANET_YELLOW:String = "assets/flash/gui/library/png/planets/planet_yellow.png";
      
      public static const DIR_GUI_ICONS:String = "assets/flash/gui/icons/";
      
      public static const ASSET_GUI_ICON_LIFE:String = "icon_life";
      
      public static const ASSET_GUI_ICON_DAMAGE:String = "icon_attack";
      
      public static const ASSET_GUI_ICON_DAMAGE_SINGLE:String = "icon_attack_unit";
      
      public static const ASSET_GUI_ICON_DAMAGE_AREA:String = "icon_attack_area";
      
      public static const ASSET_GUI_ICON_TARGET:String = "icon_target";
      
      public static const ASSET_GUI_ICON_TARGET_AIR:String = "icon_target_air";
      
      public static const ASSET_GUI_ICON_TARGET_GROUND:String = "icon_target_ground";
      
      public static const ASSET_GUI_ICON_TARGET_FOCUS:String = "icon_target";
      
      public static const ASSET_GUI_ICON_RANGE:String = "icon_shield";
      
      public static const ASSET_GUI_ICON_SPEED:String = "icon_speed";
      
      public static const ASSET_GUI_ICON_SIZE:String = "icon_capacity";
      
      public static const ASSET_GUI_ICON_ATTACK_SPEED:String = "icon_rate";
      
      public static const ASSET_GUI_ICON_TIME:String = "icon_time";
      
      public static const ASSET_GUI_ICON_CANCEL:String = "icon_cancel";
      
      public static const ASSET_GUI_ICON_COIN:String = "icon_coin";
      
      public static const ASSET_GUI_ICON_MINERAL:String = "icon_mineral";
      
      public static const ASSET_GUI_ICON_PRODUCTION_COIN:String = "icon_production_coin";
      
      public static const ASSET_GUI_ICON_PRODUCTION_MINERAL:String = "icon_production_mineral";
      
      public static const ASSET_GUI_ICON_HANGAR:String = "icon_hangar";
      
      public static const ASSET_GUI_ICON_QUEUE_SLOT:String = "icon_slot";
      
      public static const DIR_DATA_LOCALE:String = "locale/";
      
      public static const BITMAP_IMAGE_NAME:String = "bitmapImage";
      
      public static const IMAGES_GROUPS_SPACE:String = "space";
      
      public static const REQUESTS_BATTLE_START:String = "requestsBattleStart";
      
      public static const REQUESTS_GAME_START:String = "requestsGameStart";
      
      public static const FLAG_TYPE_PATTERN:String = "pattern";
      
      public static const FEATURE_SUFFIX_FALLING:String = "_falling";
      
      public static const FEATURE_SUFFIX_POST_FALLING:String = "_post_falling";
      
      public static const FEATURE_SUFFIX_CRATER:String = "_crater";
      
      public static const FEATURE_NUKE_FALLING_SKU:String = "nuke_falling";
      
      public static const FEATURE_NUKE_POST_FALLING_SKU:String = "nuke_post_falling";
      
      public static const FEATURE_NUKE_CRATER_SKU:String = "nuke_crater";
      
      public static const FEATURE_CAPSULE_FALLING_SKU:String = "capsule_falling";
      
      public static const FEATURE_CAPSULE_POST_FALLING_SKU:String = "capsule_post_falling";
      
      public static const FEATURE_CAPSULE_CRATER_SKU:String = "capsule_crater";
      
      public static const FEATURE_NUKE_SKU:String = "nuke";
      
      public static const FEATURE_CAPSULE_SKU:String = "capsule";
       
      
      private var mImages:Vector.<DisplayObjectContainer>;
      
      private var mFullPaths:Vector.<String>;
      
      private var mIdxsToRemove:Vector.<int>;
      
      private var mParams:Dictionary;
      
      private var mImagesGroups:Dictionary;
      
      private var mRequests:Dictionary;
      
      private var mAnimsLoaded:Dictionary;
      
      public function ResourceMng()
      {
         super();
         this.mAnimsLoaded = new Dictionary(false);
      }
      
      public static function createDefaultBitmap() : Bitmap
      {
         var bitmap:Bitmap = new Bitmap();
         bitmap.name = "bitmapImage";
         return bitmap;
      }
      
      override protected function catalogPopulate() : void
      {
         mCatalog["assets/flash/world_items/buildings/observatory/observatory.swf"] = new DCResourceDefLoaded("assets/flash/world_items/buildings/observatory/observatory.swf",DCResourceMng.getFileName("assets/flash/world_items/buildings/observatory/observatory.swf"),".swf",0);
         mCatalog["assets/flash/world_items/pngs_common/shield.png"] = new DCResourceDefLoaded("assets/flash/world_items/pngs_common/shield.png",DCResourceMng.getFileName("assets/flash/world_items/pngs_common/shield.png"),".png",2);
         mCatalog["assets/flash/world_items/pngs_common/shield_spy.png"] = new DCResourceDefLoaded("assets/flash/world_items/pngs_common/shield_spy.png",DCResourceMng.getFileName("assets/flash/world_items/pngs_common/shield_spy.png"),".png",2);
         mCatalog["nuke"] = new DCResourceDefLoaded("nuke",DCResourceMng.getFileName("assets/flash/battle_effects/nuke.swf"),".swf",0);
         mCatalog["crater_nuke"] = new DCResourceDefLoaded("crater_nuke",DCResourceMng.getFileName("assets/flash/battle_effects/crater_nuke.png"),".png",2);
         mCatalog["capsule"] = new DCResourceDefLoaded("capsule",DCResourceMng.getFileName("assets/flash/battle_effects/capsule.swf"),".swf",0);
         mCatalog["crater_capsule"] = new DCResourceDefLoaded("crater_capsule",DCResourceMng.getFileName("assets/flash/battle_effects/crater_capsule.png"),".png",2);
         mCatalog["assets/flash/space_maps/backgrounds/background_galaxy.swf"] = new DCResourceDefLoaded("assets/flash/space_maps/backgrounds/background_galaxy.swf",DCResourceMng.getFileName("assets/flash/space_maps/backgrounds/background_galaxy.swf"),".swf",3);
         mCatalog["assets/flash/space_maps/backgrounds/solar_system_2_5.swf"] = new DCResourceDefLoaded("assets/flash/space_maps/backgrounds/solar_system_2_5.swf",DCResourceMng.getFileName("assets/flash/space_maps/backgrounds/solar_system_2_5.swf"),".swf",3);
         mCatalog["assets/flash/background/animations/alliance_council/alliance_council.swf"] = new DCResourceDefLoaded("assets/flash/background/animations/alliance_council/alliance_council.swf",DCResourceMng.getFileName("assets/flash/background/animations/alliance_council/alliance_council.swf"),".swf",3,false);
         mCatalog["deaths"] = new EResourceDefLoaded("deaths","units_deaths","legacy",".swf",3);
         mCatalog["citizen_001"] = new EResourceDefLoaded("citizen_001","units_citizen","legacy",".swf",3);
         mCatalog["battle_effects"] = new EResourceDefLoaded("battle_effects","units_effects","legacy",".swf",3);
         mCatalog["missile_001"] = new EResourceDefLoaded("missile_001","units_bullet","legacy",".swf",3);
         mCatalog["bomb"] = new EResourceDefLoaded("bomb","units_bomb","legacy",".swf",3);
         mCatalog["fireball"] = new EResourceDefLoaded("fireball","units_fireball","legacy",".swf",3);
         mCatalog["assets/flash/battle_effects/crater.png"] = new EResourceDefLoaded("assets/flash/battle_effects/crater.png","wio_crater","legacy",".png",2);
         mCatalog["assets/flash/_esparragon/gui/layouts/gui_old.swf"] = new EResourceDefLoaded("assets/flash/_esparragon/gui/layouts/gui_old.swf","gui_main_optimized","legacy",".swf");
         mCatalog["assets/flash/gui/spy_capsule.swf"] = new EResourceDefLoaded("assets/flash/gui/spy_capsule.swf","gui_spy_capsule","legacy",".swf");
         mCatalog["assets/flash/gui/popups.swf"] = new EResourceDefLoaded("assets/flash/gui/popups.swf","gui_popups","legacy",".swf");
         mCatalog["assets/flash/gui/popups_exported.swf"] = new EResourceDefLoaded("assets/flash/gui/popups_exported.swf","gui_popups_exported","legacy",".swf");
         mCatalog["assets/flash/gui/container_happenings.swf"] = new EResourceDefLoaded("assets/flash/gui/container_happenings.swf","gui_popups_containers_happenings","legacy",".swf");
         mCatalog["assets/flash/world_items/buildings/bases/bases.swf"] = new EResourceDefLoaded("assets/flash/world_items/buildings/bases/bases.swf","wio_bases","legacy",".swf",3);
         mCatalog["assets/flash/world_items/buildings/bases/bases_dirt.swf"] = new EResourceDefLoaded("assets/flash/world_items/buildings/bases/bases_dirt.swf","wio_old_bases","legacy",".swf",3);
         if(true)
         {
            mCatalog["assets/flash/halloween/popups.swf"] = new EResourceDefLoaded("assets/flash/halloween/popups.swf","gui_popups_halloween","legacy",".swf");
         }
         if(Config.useDoomsdayPopups())
         {
            mCatalog["assets/flash/doomsday/popups.swf"] = new EResourceDefLoaded("assets/flash/doomsday/popups.swf","gui_popups_doomsday","legacy",".swf");
         }
         mCatalog["assets/flash/world_items/common.swf"] = new EResourceDefLoaded("assets/flash/world_items/common.swf","wio_common","legacy",".swf",3);
         mCatalog["assets/flash/world_items/pngs_common/particle_coin.png"] = new EResourceDefLoaded("assets/flash/world_items/pngs_common/particle_coin.png","gui_icon_coins","legacy",".png");
         mCatalog["assets/flash/world_items/pngs_common/particle_resource.png"] = new EResourceDefLoaded("assets/flash/world_items/pngs_common/particle_resource.png","gui_icon_minerals","legacy",".png");
         mCatalog["assets/flash/world_items/pngs_common/particle_experience.png"] = new EResourceDefLoaded("assets/flash/world_items/pngs_common/particle_experience.png","gui_icon_xp","legacy",".png");
         mCatalog["assets/flash/world_items/pngs_common/grille.png"] = new EResourceDefLoaded("assets/flash/world_items/pngs_common/grille.png","gui_grille","legacy",".png");
         mCatalog["assets/flash/tutorial/abduction_assets.swf"] = new EResourceDefLoaded("assets/flash/tutorial/abduction_assets.swf","cutscenes_kidnap","legacy",".swf",3);
         mCatalog["orange_normal"] = new EResourceDefLoaded("orange_normal","orange_normal","default",".png",-1,2);
         mCatalog["orange_worried"] = new EResourceDefLoaded("orange_worried","orange_worried","default",".png",-1,2);
         mCatalog["orange_happy"] = new EResourceDefLoaded("orange_happy","orange_happy","default",".png",-1,2);
         mCatalog["captain_normal"] = new EResourceDefLoaded("captain_normal","captain_normal","default",".png",-1,2);
         mCatalog["captain_worried"] = new EResourceDefLoaded("captain_worried","captain_worried","default",".png",-1,2);
         mCatalog["captain_happy"] = new EResourceDefLoaded("captain_happy","captain_happy","default",".png",-1,2);
         mCatalog["firebit_normal"] = new EResourceDefLoaded("firebit_normal","firebit_normal","default",".png",-1,2);
         mCatalog["elderby_normal"] = new EResourceDefLoaded("elderby_normal","elderby_normal","default",".png",-1,2);
         mCatalog["builder_worried"] = new EResourceDefLoaded("builder_worried","builder_worried","default",".png",-1,2);
         mCatalog["assets/flash/generic_loading.swf"] = new EResourceDefLoaded("assets/flash/generic_loading.swf","gui_loading","legacy",".swf");
         mCatalog["marine_001"] = new DCResourceDefLoaded("marine_001",DCResourceMng.getFileName("assets/flash/world_items/units/marine_001.swf"),".swf",3);
         mCatalog["looter_001"] = new DCResourceDefLoaded("looter_001",DCResourceMng.getFileName("assets/flash/world_items/units/looter_001.swf"),".swf",3);
         mCatalog["flamethrower_001"] = new DCResourceDefLoaded("flamethrower_001",DCResourceMng.getFileName("assets/flash/world_items/units/flamethrower_001.swf"),".swf",3);
         mCatalog["blast_001"] = new DCResourceDefLoaded("blast_001",DCResourceMng.getFileName("assets/flash/world_items/units/blast_001.swf"),".swf",3);
         mCatalog["bazooka_001"] = new DCResourceDefLoaded("bazooka_001",DCResourceMng.getFileName("assets/flash/world_items/units/bazooka_001.swf"),".swf",3);
         mCatalog["super_soldier_001"] = new DCResourceDefLoaded("super_soldier_001",DCResourceMng.getFileName("assets/flash/world_items/units/super_soldier_001.swf"),".swf",3);
         mCatalog["mercenary_marine"] = new DCResourceDefLoaded("mercenary_marine",DCResourceMng.getFileName("assets/flash/world_items/units/mercenary_marine.swf"),".swf",3);
         mCatalog["mercenary_mecha"] = new DCResourceDefLoaded("mercenary_mecha",DCResourceMng.getFileName("assets/flash/world_items/units/mercenary_mecha.swf"),".swf",3);
         mCatalog["general"] = new DCResourceDefLoaded("general",DCResourceMng.getFileName("assets/flash/world_items/units/general.swf"),".swf",3);
         mCatalog["tank_001"] = new DCResourceDefLoaded("tank_001",DCResourceMng.getFileName("assets/flash/world_items/units/tank_001.swf"),".swf",3);
         mCatalog["supertank_001"] = new DCResourceDefLoaded("supertank_001",DCResourceMng.getFileName("assets/flash/world_items/units/supertank_001.swf"),".swf",3);
         mCatalog["hoover_tank_001"] = new DCResourceDefLoaded("hoover_tank_001",DCResourceMng.getFileName("assets/flash/world_items/units/hoover_tank_001.swf"),".swf",3);
         mCatalog["driller_001"] = new DCResourceDefLoaded("driller_001",DCResourceMng.getFileName("assets/flash/world_items/units/driller_001.swf"),".swf",3);
         mCatalog["trike"] = new DCResourceDefLoaded("trike",DCResourceMng.getFileName("assets/flash/world_items/units/trike.swf"),".swf",3);
         mCatalog["ovni"] = new DCResourceDefLoaded("ovni",DCResourceMng.getFileName("assets/flash/world_items/units/ovni.swf"),".swf",3);
         mCatalog["helicopter"] = new DCResourceDefLoaded("helicopter",DCResourceMng.getFileName("assets/flash/world_items/units/helicopter.swf"),".swf",3);
         mCatalog["zeppelin"] = new DCResourceDefLoaded("zeppelin",DCResourceMng.getFileName("assets/flash/world_items/units/zeppelin.swf"),".swf",3);
         mCatalog["battleship"] = new DCResourceDefLoaded("battleship",DCResourceMng.getFileName("assets/flash/world_items/units/battleship.swf"),".swf",3);
         mCatalog["mender_001"] = new DCResourceDefLoaded("mender_001",DCResourceMng.getFileName("assets/flash/world_items/units/mender_001.swf"),".swf",3);
         mCatalog["skeleton_001"] = new DCResourceDefLoaded("skeleton_001",DCResourceMng.getFileName("assets/flash/world_items/units/skeleton_001.swf"),".swf",3);
         mCatalog["zombie_001"] = new DCResourceDefLoaded("zombie_001",DCResourceMng.getFileName("assets/flash/world_items/units/zombie_001.swf"),".swf",3);
         mCatalog["demon_001"] = new DCResourceDefLoaded("demon_001",DCResourceMng.getFileName("assets/flash/world_items/units/demon_001.swf"),".swf",3);
         mCatalog["jason_001"] = new DCResourceDefLoaded("jason_001",DCResourceMng.getFileName("assets/flash/world_items/units/jason_001.swf"),".swf",3);
         mCatalog["demon_002"] = new DCResourceDefLoaded("demon_002",DCResourceMng.getFileName("assets/flash/world_items/units/demon_002.swf"),".swf",3);
         mCatalog["enterprise"] = new DCResourceDefLoaded("enterprise",DCResourceMng.getFileName("assets/flash/world_items/units/enterprise.swf"),".swf",3);
         mCatalog["mayan_golem_thunder"] = new DCResourceDefLoaded("mayan_golem_thunder",DCResourceMng.getFileName("assets/flash/world_items/units/mayan_golem_thunder.swf"),".swf",3);
         mCatalog["mayan_golem_tornado"] = new DCResourceDefLoaded("mayan_golem_tornado",DCResourceMng.getFileName("assets/flash/world_items/units/mayan_golem_tornado.swf"),".swf",3);
         mCatalog["mayan_golem_rocks"] = new DCResourceDefLoaded("mayan_golem_rocks",DCResourceMng.getFileName("assets/flash/world_items/units/mayan_golem_rocks.swf"),".swf",3);
         mCatalog["mayan_golem_fire"] = new DCResourceDefLoaded("mayan_golem_fire",DCResourceMng.getFileName("assets/flash/world_items/units/mayan_golem_fire.swf"),".swf",3);
         mCatalog["mayan_golem_forest"] = new DCResourceDefLoaded("mayan_golem_forest",DCResourceMng.getFileName("assets/flash/world_items/units/mayan_golem_forest.swf"),".swf",3);
         mCatalog["defense_001"] = new DCResourceDefLoaded("defense_001",DCResourceMng.getFileName("assets/flash/world_items/buildings/defense_001/defense_001.swf"),".swf",3);
         mCatalog["defense_004"] = new DCResourceDefLoaded("defense_004",DCResourceMng.getFileName("assets/flash/world_items/buildings/defense_004/defense_004.swf"),".swf",3);
         mCatalog["laser_001"] = new DCResourceDefLoaded("laser_001",DCResourceMng.getFileName("assets/flash/world_items/buildings/laser_001/laser_001.swf"),".swf",3);
         mCatalog["missile_launcher_001"] = new DCResourceDefLoaded("missile_launcher_001",DCResourceMng.getFileName("assets/flash/world_items/buildings/missile_launcher_001/missile_launcher_001.swf"),".swf",3);
         mCatalog["mortar_001"] = new DCResourceDefLoaded("mortar_001",DCResourceMng.getFileName("assets/flash/world_items/buildings/mortar_001/mortar_001.swf"),".swf",3);
         mCatalog["freeze_turret"] = new DCResourceDefLoaded("freeze_turret",DCResourceMng.getFileName("assets/flash/world_items/buildings/defense_freeze/freeze_turret.swf"),".swf",3);
         mCatalog["trap_pumpkin"] = new DCResourceDefLoaded("trap_pumpkin",DCResourceMng.getFileName("assets/flash/world_items/buildings/pumpkin_trap/trap_pumpkin.swf"),".swf",3);
         mCatalog["trap_pumpkin_02"] = new DCResourceDefLoaded("trap_pumpkin_02",DCResourceMng.getFileName("assets/flash/world_items/buildings/pumpkin_trap/trap_pumpkin_02.swf"),".swf",3);
         mCatalog["tornado"] = new DCResourceDefLoaded("tornado",DCResourceMng.getFileName("assets/flash/world_items/units/tornado.swf"),".swf",3);
         mCatalog["rock"] = new DCResourceDefLoaded("rock",DCResourceMng.getFileName("assets/flash/world_items/units/rock.swf"),".swf",3);
         mCatalog["builder"] = new DCResourceDefLoaded("builder",DCResourceMng.getFileName("assets/flash/world_items/units/builder.swf"),".swf",3);
         mCatalog["world_items/units/recolector_money.swf"] = new DCResourceDefLoaded("world_items/units/recolector_money.swf",DCResourceMng.getFileName("assets/flash/" + "world_items/units/recolector_money.swf"),".swf",3);
         mCatalog["world_items/units/recolector_mineral.swf"] = new DCResourceDefLoaded("world_items/units/recolector_mineral.swf",DCResourceMng.getFileName("assets/flash/" + "world_items/units/recolector_mineral.swf"),".swf",3);
         mCatalog["assets/flash/world_items/buildings/jail_001/jail_001.swf"] = new DCResourceDefLoaded("assets/flash/world_items/buildings/jail_001/jail_001.swf",DCResourceMng.getFileName("assets/flash/world_items/buildings/jail_001/jail_001.swf"),".swf",3);
         mCatalog["mecha_starling"] = new DCResourceDefLoaded("mecha_starling",DCResourceMng.getFileName("assets/flash/world_items/units/mecha_starling.swf"),".swf",3);
      }
      
      public function isGUIResourcesLoaded() : Boolean
      {
         return isResourceLoaded("assets/flash/_esparragon/gui/layouts/gui_old.swf") && isResourceLoaded("assets/flash/gui/popups.swf");
      }
      
      public function requestBackground(sku:String) : void
      {
         mCatalog[sku] = new DCResourceDefLoaded(sku,DCResourceMng.getFileName("assets/flash/background/" + sku),".swf",3);
         requestResource(sku);
      }
      
      public function getNPCPortraitUrl(sku:String) : String
      {
         return getFileName("assets/npcs/" + sku);
      }
      
      public function getNPCResource(sku:String) : BitmapData
      {
         var path:String = getFileName("assets/npcs/" + sku);
         return InstanceMng.getGraphicsCacheMng().getCachedImage(path);
      }
      
      public function getNewsFeedImageFullPath(assetId:String, usePlatformResolution:Boolean) : String
      {
         var resolution:String = null;
         if(usePlatformResolution)
         {
            resolution = InstanceMng.getPlatformSettingsDefMng().getNewsFeedsResolution();
         }
         else
         {
            resolution = "90x90";
         }
         return DCResourceMng.getFileName("assets/new_feeds/" + resolution + "/" + assetId.toLowerCase() + ".png").toLowerCase();
      }
      
      public function getNewsFeedSwfFullPath(assetId:String) : String
      {
         return DCResourceMng.getFileName("assets/new_feeds/swfs/" + assetId.toLowerCase() + ".swf");
      }
      
      public function getAssetsLibraryFullPath(fileName:String) : String
      {
         return DCResourceMng.getFileName("assets/flash/gui/library/" + fileName);
      }
      
      public function getShopResourceFullPath(path:String, sku:String) : String
      {
         return DCResourceMng.getFileName("assets/flash/world_items/" + path + sku + ".png");
      }
      
      public function getCollectablesFullPath(sku:String, path:String = "") : String
      {
         var returnValue:String = InstanceMng.getEResourcesMng().getAssetUrl(sku,InstanceMng.getSkinsMng().getCurrentSkinSku());
         if(returnValue == null)
         {
            if(sku.indexOf("/") > -1)
            {
               returnValue = DCResourceMng.getFileName("assets/flash/" + path + sku + ".png");
            }
            returnValue = DCResourceMng.getFileName("assets/flash/gifts/" + path + sku + ".png");
         }
         return returnValue;
      }
      
      public function getCharactersFullPath(sku:String, path:String = "") : String
      {
         return DCResourceMng.getFileName("assets/flash/gui/characters/" + path + sku + ".png");
      }
      
      public function getIconsFullPath(sku:String, path:String = "") : String
      {
         return DCResourceMng.getFileName("assets/flash/gui/icons/" + path + sku + ".png");
      }
      
      public function getPngResource(path:String, sku:String) : DCDisplayObject
      {
         if(mCatalog[sku] == null)
         {
            mCatalog[sku] = new DCResourceDefLoaded(sku,DCResourceMng.getFileName(path),".png",2);
            requestResource(sku);
         }
         return getDCDisplayObject(sku,sku,false);
      }
      
      public function getCommonResourceFullPath(sku:String) : String
      {
         return getFileName("assets/flash/gui/library/png/common/" + sku + ".png");
      }
      
      public function getAnimation(sku:String, animSku:String) : Object
      {
         var anim:Object = InstanceMng.getResourceMng().getBitmapAnimationFromCatalog(sku,animSku);
         if(anim == null)
         {
            if(animSku == "")
            {
               anim = InstanceMng.getResourceMng().generateBitmapFromPng(sku);
            }
            else
            {
               anim = InstanceMng.getResourceMng().generateBitmapFromMovieclip(sku,animSku);
            }
         }
         return anim;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         this.loadImageResources();
      }
      
      override protected function unloadDo() : void
      {
         this.imageResourcesUnload();
         this.requestsUnload();
         super.unloadDo();
      }
      
      private function imageResourcesUnload() : void
      {
         var k:* = null;
         var group:String = null;
         if(this.mImages != null)
         {
            this.mImages.length = 0;
            this.mImages = null;
         }
         if(this.mFullPaths != null)
         {
            this.mFullPaths.length = 0;
            this.mFullPaths = null;
         }
         if(this.mIdxsToRemove != null)
         {
            this.mIdxsToRemove.length = 0;
            this.mIdxsToRemove = null;
         }
         this.mParams = null;
         if(this.mImagesGroups != null)
         {
            for(k in this.mImagesGroups)
            {
               group = k;
               this.imagesReleaseGroup(group);
            }
            this.mImagesGroups = null;
         }
      }
      
      public function imagesReleaseGroup(group:String) : void
      {
         var v:Vector.<String> = null;
         var fullpath:String = null;
         if(this.mImagesGroups != null && this.mImagesGroups[group] != null)
         {
            v = this.mImagesGroups[group];
            if(v != null)
            {
               while(v.length > 0)
               {
                  fullpath = v.shift();
                  InstanceMng.getResourceMng().unloadResource(fullpath);
                  if(mCatalog != null)
                  {
                     mCatalog[fullpath] = null;
                  }
               }
            }
         }
      }
      
      public function addImageResourceToLoad(parent:DisplayObjectContainer, fullpath:String, scalePercent:Number = 100, fitSizeX:int = 0, fitSizeY:int = 0, filters:Array = null, group:String = null) : void
      {
         if(this.mImages == null)
         {
            this.mImages = new Vector.<DisplayObjectContainer>(0);
         }
         if(this.mFullPaths == null)
         {
            this.mFullPaths = new Vector.<String>(0);
         }
         if(this.mIdxsToRemove == null)
         {
            this.mIdxsToRemove = new Vector.<int>(0);
         }
         if(this.mParams == null)
         {
            this.mParams = new Dictionary(false);
         }
         var bitmap:Bitmap;
         if((bitmap = parent.getChildByName("bitmapImage") as Bitmap) == null)
         {
            bitmap = createDefaultBitmap();
            parent.addChild(bitmap);
         }
         if(fitSizeX > 0)
         {
            this.mParams[bitmap] = {
               "fitSizeX":fitSizeX,
               "fitSizeY":fitSizeY
            };
            scalePercent = 100;
         }
         if(filters != null)
         {
            bitmap.filters = filters;
         }
         bitmap.scaleX = scalePercent / 100;
         bitmap.scaleY = scalePercent / 100;
         var iconTime:DisplayObjectContainer;
         if((iconTime = parent.getChildByName("icon_time") as DisplayObjectContainer) != null)
         {
            iconTime.visible = true;
         }
         var idx:int;
         if((idx = this.mImages.indexOf(parent)) > -1)
         {
            this.mFullPaths[idx] = fullpath;
         }
         else
         {
            this.mFullPaths.push(fullpath);
            this.mImages.push(parent);
            idx = this.mImages.length - 1;
         }
         this.loadImageResource(idx);
         this.removeLoadedImages();
         if(group != null)
         {
            if(this.mImagesGroups == null)
            {
               this.mImagesGroups = new Dictionary();
            }
            if(this.mImagesGroups[group] == null)
            {
               this.mImagesGroups[group] = new Vector.<String>(0);
            }
            if(this.mImagesGroups[group].indexOf(fullpath) == -1)
            {
               this.mImagesGroups[group].push(fullpath);
            }
         }
      }
      
      public function loadImageResources() : void
      {
         var i:int = 0;
         if(this.mImages == null || this.mFullPaths == null)
         {
            return;
         }
         var l:int = int(this.mImages.length);
         if(l == 0)
         {
            return;
         }
         i = 0;
         while(i < l)
         {
            this.loadImageResource(i);
            i++;
         }
         this.removeLoadedImages();
      }
      
      private function loadImageResource(idx:int) : void
      {
         var fullpath:String = null;
         var splitArr:Array = null;
         var sku:String = null;
         var bitmap:Bitmap = null;
         var box:DisplayObjectContainer = null;
         var iconTime:DisplayObjectContainer = null;
         var fitSizeX:int = 0;
         var fitSizeY:int = 0;
         var rect:Rectangle = null;
         if((bitmap = (box = this.mImages[idx]).getChildByName("bitmapImage") as Bitmap) != null)
         {
            splitArr = (fullpath = this.mFullPaths[idx]).split("/");
            sku = String((sku = String(splitArr[splitArr.length - 1])).split(".")[0]);
            if(mCatalog[fullpath] == null)
            {
               mCatalog[fullpath] = new DCResourceDefLoaded(sku,fullpath,".png",0,false);
               requestResource(fullpath);
            }
            bitmap.bitmapData = getResource(fullpath);
            if(bitmap.bitmapData != null)
            {
               bitmap.smoothing = true;
               iconTime = this.mImages[idx].getChildByName("icon_time") as DisplayObjectContainer;
               if(iconTime != null)
               {
                  iconTime.visible = false;
               }
               this.mIdxsToRemove.push(idx);
               EUtils.cropBitmap(bitmap);
               if(this.mParams != null && this.mParams[bitmap] != null)
               {
                  fitSizeX = int(this.mParams[bitmap].fitSizeX);
                  fitSizeY = int(this.mParams[bitmap].fitSizeY);
                  rect = bitmap.bitmapData.getColorBoundsRect(4278190080,0,false);
                  if(rect.width > fitSizeX)
                  {
                     bitmap.scaleX = fitSizeX / rect.width;
                  }
                  if(rect.height > fitSizeY)
                  {
                     bitmap.scaleY = fitSizeY / rect.height;
                  }
                  if(bitmap.scaleX < bitmap.scaleY)
                  {
                     bitmap.scaleY = bitmap.scaleX;
                  }
                  else
                  {
                     bitmap.scaleX = bitmap.scaleY;
                  }
                  bitmap.x = -rect.x * bitmap.scaleX - rect.width * bitmap.scaleX / 2;
                  bitmap.y = -rect.y * bitmap.scaleY - rect.height * bitmap.scaleY / 2;
               }
               else
               {
                  bitmap.x = -(bitmap.width / 2);
                  bitmap.y = -(bitmap.height / 2);
               }
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("LOADING","WARNING in ResourceMng.loadImageResource() not found bitmat for id <" + idx + ">",1);
         }
      }
      
      private function removeLoadedImages() : void
      {
         var i:int = 0;
         var c:DisplayObjectContainer = null;
         var idx:int = 0;
         this.mIdxsToRemove = this.mIdxsToRemove.reverse();
         var length:int = int(this.mIdxsToRemove.length);
         for(i = 0; i < length; )
         {
            idx = this.mIdxsToRemove[i];
            if(this.mParams != null)
            {
               c = this.mImages[idx] as DisplayObjectContainer;
               this.mParams[c] = null;
            }
            this.mImages.splice(idx,1);
            this.mFullPaths.splice(idx,1);
            i++;
         }
         this.mIdxsToRemove.length = 0;
      }
      
      public function getWorldItemObjectFileName(def:WorldItemDef, state:String, assetId:String = null, format:int = 2, createResourceDef:Boolean = false, createNameAsPNG:Boolean = false, useFlatAsset:Boolean = false) : String
      {
         var prefix:String = null;
         var fileName:* = "assets/flash/world_items/";
         if(def.isHeadQuarters() && !InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isCurrentPlanetCapital() && !useFlatAsset)
         {
            fileName += def.getFlaFolderByKey("colony");
            assetId = def.getAssetIdByKey("colony");
         }
         else
         {
            if((def.isAnObstacle() || def.isADecoration()) && useFlatAsset)
            {
               fileName += "buildings/flatBed/";
            }
            else
            {
               fileName += def.getFlaFolder();
            }
            if(assetId != null && useFlatAsset)
            {
               fileName = "assets/flash/world_items/buildings/flatBed/upgrade-";
            }
            if(assetId == null)
            {
               if(useFlatAsset)
               {
                  assetId = def.getFlatAssetId();
               }
               else
               {
                  assetId = def.getAssetId();
               }
            }
         }
         if((def.isAnObstacle() || def.isADecoration()) && useFlatAsset)
         {
            prefix = def.isAnObstacle() ? "obstacle-" : "deco-";
            fileName += prefix + def.getBaseCols() + "x" + def.getBaseRows();
         }
         else
         {
            fileName += assetId;
         }
         if(format == 2)
         {
            if(state == "flatUpgrade")
            {
               state = "";
            }
            else if(useFlatAsset)
            {
               state = "ready";
            }
            if(state != "" && !((def.isAnObstacle() || def.isADecoration()) && useFlatAsset))
            {
               fileName += "_" + state;
            }
            fileName += DCResourceMng.formatToExtension(format);
         }
         else if(createNameAsPNG)
         {
            fileName += DCResourceMng.formatToExtension(format);
         }
         else
         {
            fileName = def.getAssetFile();
         }
         if(createResourceDef)
         {
            if(mCatalog[fileName] == null)
            {
               mCatalog[fileName] = new DCResourceDefLoaded(fileName,DCResourceMng.getFileName(fileName),formatToExtension(format),format,false);
            }
         }
         return fileName;
      }
      
      public function generateCombinedBitmapData(anims:Array) : BitmapData
      {
         var i:int = 0;
         var bmp:BitmapData = null;
         var w:Number = NaN;
         var x:int = 0;
         var y:int = 0;
         var maxWidth:int = 1;
         var maxHeight:* = 1;
         var bmpsCount:int = int(anims.length);
         var matrix:Matrix = new Matrix();
         for(i = 0; i < bmpsCount; )
         {
            if(anims[i] != null)
            {
               bmp = anims[i].bmps[0];
               if(maxWidth < anims[i].bounds[0].width)
               {
                  maxWidth = int(anims[i].bounds[0].width);
               }
               y = Math.abs(anims[i].bounds[0].y);
               if(maxHeight < y)
               {
                  maxHeight = y;
               }
            }
            i++;
         }
         var newBmp:BitmapData = new BitmapData(maxWidth,maxHeight,true,0);
         for(i = 0; i < bmpsCount; )
         {
            if(anims[i] != null)
            {
               bmp = anims[i].bmps[0];
               if(anims[i].bounds[0].y == 0)
               {
                  y = maxHeight - anims[i].bounds[0].height;
               }
               else
               {
                  y = maxHeight + anims[i].bounds[0].y;
               }
               if(anims[i].bounds[0].x == 0)
               {
                  x = (maxWidth - anims[i].bounds[0].width) / 2;
               }
               else
               {
                  x = maxWidth / 2 + anims[i].bounds[0].x;
               }
               matrix.identity();
               matrix.translate(x,y);
               newBmp.draw(bmp,matrix);
            }
            i++;
         }
         return newBmp;
      }
      
      public function setSpaceResourceIcon(container:DisplayObjectContainer, type:int, hqLevel:int = -1, starType:int = 0, fitW:Number = 0, fitH:Number = 0) : void
      {
         var indexForEmptyPlanet:int = 0;
         var starAsset:String = null;
         var fileName:String = null;
         var pos:int = 0;
         var bitmap:Bitmap;
         (bitmap = new Bitmap()).name = "bitmapImage";
         container.addChild(bitmap);
         switch(type)
         {
            case 0:
               fileName = getFileName(this.getAssetByParameter(starType,hqLevel,false,false,true));
               this.addImageResourceToLoad(container,fileName,100,fitW,fitH,null,"space");
               break;
            case 1:
               indexForEmptyPlanet = (pos = hqLevel) % 6;
               this.addImageResourceToLoad(container,getFileName(this.getAssetByParameter(indexForEmptyPlanet,-1,false,true)),100,0,0,null,"space");
               break;
            case 2:
            case 3:
               starAsset = InstanceMng.getSolarSystemDefMng().getAssetIdBySku(String(starType));
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/solar_systems/" + starAsset),100,0,0,null,"space");
               break;
            case 4:
               this.addImageResourceToLoad(container,getFileName(this.getAssetByParameter(starType,-1,true)),100,0,0,null,"space");
               break;
            case 5:
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/planets/planet_05.png"),100,0,0,null,"space");
               break;
            case 6:
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/planets/planet_fire.png"),100,0,0,null,"space");
               break;
            case 7:
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/planets/planet_pirate.png"),100,0,0,null,"space");
               break;
            case 8:
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/planets/planet_black_hole.png"),100,0,0,null,"space");
               break;
            case 9:
               this.addImageResourceToLoad(container,getFileName("assets/flash/space_maps/planets/planet_magma.png"),100,0,0,null,"space");
         }
      }
      
      public function getAssetByParameter(param:int, hqLvl:int, getSun:Boolean = false, getEmptyPlanet:Boolean = false, getPlanet:Boolean = false) : String
      {
         var sunAsset:String = null;
         var emptyPlanetAsset:String = null;
         var planetAsset:String = null;
         var returnValue:* = null;
         var key:String;
         switch(key = String(param))
         {
            case "0":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_00.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_red.png";
               break;
            case "1":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_01.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty_01.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_blue.png";
               break;
            case "2":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_02.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty_02.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_green.png";
               break;
            case "3":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_03.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty_03.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_white.png";
               break;
            case "4":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_04.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty_04.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_violet.png";
               break;
            case "5":
               sunAsset = "assets/flash/space_maps/planets/planet_sun_05.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty_05.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_yellow.png";
               break;
            default:
               sunAsset = "assets/flash/space_maps/planets/planet_sun_01.png";
               emptyPlanetAsset = "assets/flash/space_maps/planets/planet_empty.png";
               planetAsset = "assets/flash/gui/library/png/planets/planet_main.png";
               if(hqLvl > -1)
               {
                  if(hqLvl == 1)
                  {
                     planetAsset = "assets/flash/space_maps/planets/planet_01.png";
                  }
                  else if(hqLvl >= 2 && hqLvl <= 3)
                  {
                     planetAsset = "assets/flash/space_maps/planets/planet_02.png";
                  }
                  else if(hqLvl >= 4 && hqLvl <= 5)
                  {
                     planetAsset = "assets/flash/space_maps/planets/planet_03.png";
                  }
                  else if(hqLvl >= 6 && hqLvl <= 7)
                  {
                     planetAsset = "assets/flash/space_maps/planets/planet_04.png";
                  }
                  else if(hqLvl >= 8)
                  {
                     planetAsset = "assets/flash/space_maps/planets/planet_05.png";
                  }
               }
         }
         if(getSun == true)
         {
            returnValue = sunAsset;
         }
         else if(getEmptyPlanet == true)
         {
            returnValue = emptyPlanetAsset;
         }
         else if(getPlanet)
         {
            returnValue = planetAsset;
         }
         return returnValue;
      }
      
      private function requestsUnload() : void
      {
         this.mRequests = null;
      }
      
      public function requestsUnbuild() : void
      {
         this.mRequests = null;
      }
      
      public function requestsAddRequest(resourceSku:String, eventSku:String) : void
      {
         var list:Vector.<String> = null;
         var returnValue:Boolean = isResourceLoaded(resourceSku);
         if(!returnValue)
         {
            if(this.mRequests == null)
            {
               this.mRequests = new Dictionary(true);
            }
            if((list = this.mRequests[eventSku]) == null)
            {
               this.mRequests[eventSku] = new Vector.<String>(0);
               list = this.mRequests[eventSku];
            }
            if(list.indexOf(resourceSku) == -1)
            {
               list.push(resourceSku);
            }
         }
      }
      
      public function requestsNotifyEvent(eventSku:String) : void
      {
         var r:String = null;
         var def:DCResourceDef = null;
         var list:Vector.<String> = null;
         if(this.mRequests != null)
         {
            if((list = this.mRequests[eventSku]) != null)
            {
               while(list.length > 0)
               {
                  r = list.shift();
                  def = getResourceDef(r);
                  if(def != null)
                  {
                     def.request();
                  }
               }
            }
         }
      }
      
      public function applyFlagFilter(clip:DisplayObject, logo:Array = null) : void
      {
         var flagsDef:Vector.<FlagImagesDef> = null;
         var flagImgDef:FlagImagesDef = null;
         if(clip != null)
         {
            if(logo == null)
            {
               clip.transform.colorTransform = DCUtils.smColorTransformInit;
            }
            else if(logo.length == 3)
            {
               flagsDef = InstanceMng.getFlagImagesDefMng().getDefsByType("pattern");
               if(flagsDef != null && logo[1] is int && flagsDef.length > logo[1])
               {
                  flagImgDef = flagsDef[logo[1]];
                  clip.transform.colorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,flagImgDef.getColor(),1);
               }
            }
         }
      }
      
      public function getUnitAnimation(animDef:AnimationsDef, sku:String, animSku:String) : Object
      {
         var key:String = null;
         var sum:int = 0;
         var obj:* = undefined;
         var object:Object;
         if((object = this.getAnimation(sku,animSku)) != null && false)
         {
            key = sku + animSku;
            if(!this.mAnimsLoaded.hasOwnProperty(sku + animSku))
            {
               this.mAnimsLoaded[key] = 1;
            }
            sum = 0;
            for(obj in this.mAnimsLoaded)
            {
               if(obj.indexOf(sku) > -1)
               {
                  sum++;
                  if(sum >= animDef.getAnimationsCount())
                  {
                     unloadResource(sku,false);
                  }
               }
            }
         }
         return object;
      }
      
      public function featureGetResourceSkuSuffix(sku:String, suffix:String) : String
      {
         return this.featureGetResourceSku(sku + suffix);
      }
      
      public function featureGetResourceSku(sku:String) : String
      {
         var returnValue:String = null;
         switch(sku)
         {
            case "nuke_falling":
            case "nuke_post_falling":
               returnValue = "nuke";
               break;
            case "nuke_crater":
               returnValue = String(GameConstants.EXPENDABLES_ASSET_SKU["nuke"]);
               break;
            case "capsule_falling":
            case "capsule_post_falling":
               returnValue = "capsule";
               break;
            case "capsule_crater":
               returnValue = String(GameConstants.EXPENDABLES_ASSET_SKU["capsule"]);
         }
         return returnValue;
      }
      
      public function featureGetClipSkuSuffix(sku:String, suffix:String) : String
      {
         return this.featureGetClipSku(sku + suffix);
      }
      
      public function featureGetClipSku(sku:String) : String
      {
         var returnValue:String = null;
         switch(sku)
         {
            case "nuke_falling":
               returnValue = "nuke_1";
               break;
            case "nuke_post_falling":
               returnValue = "nuke_2";
               break;
            case "capsule_falling":
               returnValue = "arrive";
               break;
            case "capsule_post_falling":
               returnValue = "open";
         }
         return returnValue;
      }
      
      public function featureLoadResources(sku:String) : void
      {
         var skuResource:String = null;
         switch(sku)
         {
            case "capsule":
            case "nuke":
               skuResource = this.featureGetResourceSkuSuffix(sku,"_falling");
               if(skuResource != null)
               {
                  requestResource(skuResource);
               }
               skuResource = this.featureGetResourceSkuSuffix(sku,"_post_falling");
               if(skuResource != null)
               {
                  requestResource(skuResource);
               }
               skuResource = this.featureGetResourceSkuSuffix(sku,"_crater");
               if(skuResource != null)
               {
                  requestResource(skuResource);
               }
               break;
            default:
               requestResource(sku);
         }
      }
   }
}
