package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.items.AlliancesRewardDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EAllianceRewards extends ESpriteContainer
   {
       
      
      private const NUM_VISIBLE_BOXES:int = 4;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mUserAlliance:Alliance;
      
      private var mUser:AlliancesUser;
      
      private var mAreaToScroll:ELayoutArea;
      
      public function EAllianceRewards()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mUserAlliance = this.mAllianceController.getMyAlliance();
         this.mUser = this.mAllianceController.getMyUser();
      }
      
      public function build() : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceRewards");
         var img:EImage = viewFactory.getEImage("generic_box",null,false,layoutFactory.getArea("container_info"));
         setContent("background",img);
         eAddChild(img);
         var flag:ESprite = this.mAllianceController.getAllianceFlag(this.mUserAlliance.getLogo()[0],this.mUserAlliance.getLogo()[1],this.mUserAlliance.getLogo()[2],layoutFactory.getArea("icon_alliance"));
         setContent("allianceFlag",flag);
         eAddChild(flag);
         var field:ETextField;
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_victories"),"text_subheader")).setText(DCTextMng.getText(2800));
         setContent("victories",field);
         eAddChild(field);
         (field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_victories_value"),"text_body_2")).setText(DCTextMng.convertNumberToString(this.mUserAlliance.getWarsWon(),1,8));
         setContent("victoriesValue",field);
         eAddChild(field);
         img = viewFactory.getEImageProfileFromURL(this.mUser.getPictureUrl(),null,null);
         setContent("userPicture",img);
         eAddChild(img);
         img.setLayoutArea(layoutFactory.getArea("profile"),true);
         var text:String = DCTextMng.convertNumberToString(this.mUser.getScore(),1,8);
         var container:ESpriteContainer = viewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_user_warpoints",text,null,"text_body_2");
         container.layoutApplyTransformations(layoutFactory.getArea("container_text_xs"));
         setContent("warScore",container);
         eAddChild(container);
         this.mAreaToScroll = layoutFactory.getArea("container_prizes");
         var rewards:Vector.<DCDef>;
         var rewardsCount:int = int((rewards = InstanceMng.getAlliancesRewardDefMng().getDefs()).length);
         var scrollArea:EScrollArea = new EScrollArea();
         scrollArea.build(this.mAreaToScroll,Math.ceil(rewardsCount / 4),ESpriteContainer,this.locateRewardBoxes);
         viewFactory.getEScrollBar(scrollArea);
         setContent("scrollArea",scrollArea);
         eAddChild(scrollArea);
      }
      
      private function locateRewardBoxes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:EAllianceRewardBox = null;
         var i:int = 0;
         var xOffset:int = 0;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as EAllianceRewardBox).destroy();
            }
            for(i = 0; i < 4; )
            {
               itemContainer = new EAllianceRewardBox();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               i++;
            }
         }
         var rewards:Vector.<DCDef> = InstanceMng.getAlliancesRewardDefMng().getDefs();
         i = rowOffset * 4;
         while(i < (rowOffset + 1) * 4 && i < rewards.length)
         {
            (itemContainer = spriteReference.getChildAt(i % 4) as EAllianceRewardBox).visible = true;
            itemContainer.setInfo(rewards[i] as AlliancesRewardDef);
            xOffset = (this.mAreaToScroll.width - 4 * itemContainer.width) / (4 + 1);
            itemContainer.logicLeft = i % 4 * (itemContainer.width + xOffset) + xOffset;
            itemContainer.logicTop = (this.mAreaToScroll.height - itemContainer.height) / 2;
            i++;
         }
         while(i < (rowOffset + 1) * 4)
         {
            (itemContainer = spriteReference.getChildAt(i % 4) as EAllianceRewardBox).visible = false;
            i++;
         }
      }
   }
}
