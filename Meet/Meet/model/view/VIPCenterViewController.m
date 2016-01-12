//
//  VIPCenterViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VIPCenterViewController.h"
#import "VIPListTableViewCell.h"
#import "RCDChatViewController.h"

#define VIPList @"VIPListTableViewCell"

@interface VIPCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *vipBtn;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * myGroups;
@end

@implementation VIPCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    self.type=[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.type];
    if ([self.type isEqualToString:@"2"]) {
        self.vipBtn.hidden=YES;
    }
    if ([self.type isEqualToString:@"1"]) {
        self.vipBtn.hidden=NO;
        self.tableViewHeight.constant=100;
        [self updateViewConstraints];
    }
    
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"VIPListTableViewCell" bundle:nil] forCellReuseIdentifier:VIPList];
    NSArray * names =@[@"\U0000e627",@"\U0000e60b",@"\U0000e60e",@"\U0000e61c",@"\U0000e60a",@"\U0000e61f",@"\U0000e632",@"\U0000e60d"];
    NSArray * colors=@[iconYellow,iconGreen,iconBlue,iconOrange,iconYellow,iconGreen,iconRed,iconGreen];
    for (int i=0 ; i<self.labels.count; i++) {
        UILabel * label=[self.labels objectAtIndex:i];
        label.layer.cornerRadius=5;
        label.clipsToBounds=YES;
        label.font=[UIFont fontWithName:iconFont size:36];
        label.backgroundColor=[colors objectAtIndex:i];
        label.text=[names objectAtIndex:i];
        
    }
    GetMyCreatedGroupsRequest * requested =[[GetMyCreatedGroupsRequest alloc]init];
    [SystemAPI GetMyCreatedGroupsRequest:requested success:^(GetMyCreatedGroupsResponse *response) {
        NSArray * arr=(NSArray *)response.data;
        self.myGroups=[[NSString alloc]init];
        for (int i =0 ; i<arr.count; i++) {
            NSDictionary * dic =arr[i];
            if (i==0) {
                self.myGroups=[self.myGroups stringByAppendingString:[dic objectForKey:@"name"]];
            }else{
                 self.myGroups=[ self.myGroups stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"name"]]];
            }
        }
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];

    
}
- (IBAction)beTheVIP:(id)sender {
    [self performSegueWithIdentifier:@"recharge" sender:nil];
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"2"]) {
        return 4;
    }
    if ([self.type isEqualToString:@"1"]) {
        return 2;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VIPListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:VIPList];
    if (!cell) {
        cell=[[VIPListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VIPList];
    }
    UIImageView * im=[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 36, 18)];
    int level=[[ShareValue shareInstance].userInfo.level intValue];
    int queen =level/64;
    int sun =(level%64)/16;
    int moon =(level%16)/4;
    int star =level%4;
    NSString * le=[[NSString alloc]init];
    /**
     *  会员
     */
    if ([self.type isEqualToString:@"2"]) {
         im.image=[UIImage imageNamed:@"vip1.png"];
        switch (indexPath.row) {
            case 0:
                cell.lb_title.text=@"您的身份";
                cell.lb_content.text=@"";
                [cell.lb_content addSubview:im];
                cell.lb_value.text=@"VIP会员";
                break;
            case 1:
                for (int i =0; i<queen; i++) {
                    le=[le stringByAppendingString:@"\U0000e622"];
                }
                for (int i =0; i<sun; i++) {
                    le=[le stringByAppendingString:@"\U0000e620"];
                }
                for (int i =0; i<moon; i++) {
                    le=[le stringByAppendingString:@"\U0000e621"];
                }
                for (int i =0; i<star; i++) {
                    le=[le stringByAppendingString:@"\U0000e623"];
                }
                cell.lb_title.text=@"您的等级";
                cell.lb_content.font=[UIFont fontWithName:iconFont size:16];
                cell.lb_content.text=le;
                cell.lb_content.textColor=iconYellow;
                cell.lb_value.text=[NSString stringWithFormat:@"%@级",[ShareValue shareInstance].userInfo.level];
                break;
            case 2:
                cell.lb_title.text=@"到期时间";
                cell.lb_content.text=[[[ShareValue shareInstance].userInfo.expired componentsSeparatedByString:@" "] firstObject];
                cell.lb_value.text=@"去续费";
                cell.lb_value.textColor=TempleColor;
                break;
//            case 3:
//                cell.lb_title.text=@"我的群组";
//                cell.lb_content.text=self.myGroups;
//                cell.lb_value.text=@"高级";
//                break;
            case 3:
                cell.lb_title.text=@"我的商家";
                cell.lb_content.text=@"暂无商家";
                if ([ShareValue shareInstance].userInfo.isStore) {
                    cell.lb_value.text=@"管理商家";
                }else{
                    cell.lb_value.text=@"申请成为商家";
                }
                cell.lb_value.textColor=TempleColor;
                break;
            default:
                break;
        }

    }
    /**
     *  非会员
     */
    if ([self.type isEqualToString:@"1"]) {
         im.image=[UIImage imageNamed:@"vip2.png"];
        for (int i =0; i<queen; i++) {
            le=[le stringByAppendingString:@"\U0000e622"];
        }
        for (int i =0; i<sun; i++) {
            le=[le stringByAppendingString:@"\U0000e620"];
        }
        for (int i =0; i<moon; i++) {
            le=[le stringByAppendingString:@"\U0000e621"];
        }
        for (int i =0; i<star; i++) {
            le=[le stringByAppendingString:@"\U0000e623"];
        }
        switch (indexPath.row) {
            case 0:
                cell.lb_title.text=@"您的身份";
                cell.lb_content.text=@"";
                [cell.lb_content addSubview:im];
                cell.lb_value.text=@"普通用户";
                break;
            case 1:
                cell.lb_title.text=@"您的等级";
                cell.lb_content.font=[UIFont fontWithName:iconFont size:16];
                cell.lb_content.text=le;
                cell.lb_content.textColor=iconYellow;
                cell.lb_value.text=[NSString stringWithFormat:@"%@级",[ShareValue shareInstance].userInfo.level];
                break;
                
//            case 2:
//                cell.lb_title.text=@"我的群组";
//                cell.lb_content.text=self.myGroups;
//                cell.lb_value.text=@"初级";
//                break;
            default:
                break;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[ShareValue shareInstance].userInfo.type integerValue]==2) {
        if (indexPath.row==2) {
            [self performSegueWithIdentifier:@"recharge" sender:nil];
        }
        if (indexPath.row==3) {
//            [self performSegueWithIdentifier:@"recharge" sender:nil];
            if ([ShareValue shareInstance].userInfo.isStore) {
                UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"StoreManagerViewController"] animated:YES];
            }else{
            RCConversationModel * model=[[RCConversationModel alloc]init:
                                         RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
            model.conversationType=ConversationType_PRIVATE;
            model.targetId=@"1";
            model.conversationTitle=@"相遇小秘书";
            model.senderUserId=[ShareValue shareInstance].userInfo.id;
            model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
            RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
            _conversationVC.conversationType = ConversationType_PRIVATE;
            _conversationVC.targetId = @"1";
            _conversationVC.userName = @"相遇小秘书";
            _conversationVC.title = @"相遇小秘书";
            _conversationVC.conversation = model;
            _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
            _conversationVC.enableUnreadMessageIcon=YES;
            [self.navigationController pushViewController:_conversationVC animated:YES];
            }
        }
    }
}

@end
