//
//  MeetViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MeetViewController.h"
#import "MeetChatListTableViewCell.h"
//rongyun
#import "RCDAddressBookViewController.h"
#import "RCDSearchFriendViewController.h"
#import "RCDSelectPersonViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDChatViewController.h"
#import "UIColor+RCColor.h"
#import "RCDChatListCell.h"
#import "RCDAddFriendTableViewController.h"
#import "RCDHttpTool.h"
#import "UIImageView+WebCache.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDUserInfo.h"
#import "RCDFriendInvitationTableViewController.h"
#import "MeetGroupMiddleViewController.h"
#import "ContactGroupTableViewCell.h"
#import "RootViewController.h"

#define MeetChatList @"MeetChatListTableViewCell"

@interface MeetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) RCConversationModel *tempModel;

@end

@implementation MeetViewController
- (IBAction)showSystemMessage:(id)sender {
    NSLog(@"showSystemMessage");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MeetChatListTableViewCell" bundle:nil] forCellReuseIdentifier:MeetChatList];
    self.view.backgroundColor=NAVI_COLOR;
    self.lb_icon.font=[UIFont fontWithName:iconFont size:45.0];
    self.lb_icon.textColor=iconGreen;
    self.lb_icon.text=@"\U0000e601";
//    [self.conversationListTableView registerNib:[UINib nibWithNibName:@"ContactGroupTableViewCell" bundle:nil] forCellReuseIdentifier:MeetChatList];
    self.conversationListTableView.backgroundColor=NAVI_COLOR;
//    self.conversationListTableView.frame=CGRectMake(0, 80, DEVCE_WITH, DEVICE_HEIGHT-50);
    [self initView];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        //设置要显示的会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        
        //聚合会话类型
//        [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
        self.cellBackgroundColor=cellColor;
        self.conversationListTableView.separatorInset=UIEdgeInsetsZero;
}
    return self;
}

-(void)initView{
    if ([self.conversationListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.conversationListTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.conversationListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.conversationListTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }

    /**
     添加左边按钮
     */
    UIView * leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    leftView.backgroundColor=[UIColor clearColor];
    UILabel * leftLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    leftLb.font=[UIFont fontWithName:iconFont size:28];
    leftLb.text=@"\U0000e604";
    leftLb.textColor=TempleColor;
    [leftView addSubview:leftLb];
    UIBarButtonItem * leftItem =[[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem=leftItem;
    leftLb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapLeft=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showContacts)];
    [leftLb addGestureRecognizer:tapLeft];
    /**
     *  添加右边按钮
     *
     */
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    UILabel * rightLb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightLb.font=[UIFont fontWithName:iconFont size:28];
    rightLb.text=@"\U0000e611";
    rightLb.textColor=TempleColor;
    rightLb.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:rightLb];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
    rightLb.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showFriends)];
    [rightLb addGestureRecognizer:tapRight];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    self.conversationListTableView.separatorColor = NAVI_COLOR;
    self.conversationListTableView.tableFooterView = [UIView new];
}
-(void)showContacts{
    NSLog(@"showContacts");
    [self performSegueWithIdentifier:@"contact" sender:nil];
}
-(void)showFriends{
    NSLog(@"showFriends");
    [self performSegueWithIdentifier:@"homePage" sender:nil];
}
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    RCConversationCell *conversationCell = (RCConversationCell *)cell;
    
    if (indexPath.row!=0) {
        conversationCell.conversationTitle.textColor = [UIColor whiteColor];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self performSegueWithIdentifier:@"systemMessage" sender:nil];
        return;
    }
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
        _conversationVC.conversation = model;
        _conversationVC.unReadMessage = model.unreadMessageCount;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
        self.tabBarController.tabBar.hidden=YES;
//        [self performSegueWithIdentifier:@"chat" sender:model];
    }
    //聚合会话类型，此处自定设置。
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        
        MeetGroupMiddleViewController *temp = [[MeetGroupMiddleViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [temp setDisplayConversationTypes:array];
        [temp setCollectionConversationType:nil];
        temp.isEnteredToCollectionViewController = YES;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
    //自定义会话类型
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        RCDFriendInvitationTableViewController *temp = [mainStoryboard instantiateViewControllerWithIdentifier:@"RCDFriendInvitationTableViewController"];
        temp.conversationType = model.conversationType;
        temp.targetId = model.targetId;
        temp.userName = model.conversationTitle;
        temp.title = model.conversationTitle;
        temp.conversation = model;
        [self.navigationController pushViewController:temp animated:YES];
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
    //showConnectingStatusOnNavigatorBar设置为YES时，需要重写setNavigationItemTitleView函数来显示已连接时的标题。
    self.showConnectingStatusOnNavigatorBar = YES;
    [super updateConnectionStatusOnNavigatorBar];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;
     [(RootViewController*)self.tabBarController notifyUpdateUnreadMessageCount];
}
//由于demo使用了tabbarcontroller，当切换到其它tab时，不能更改tabbarcontroller的标题。
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.showConnectingStatusOnNavigatorBar = NO;
}
//*********************插入自定义Cell*********************//

//插入自定义会话model
-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
{
    
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
        {
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    RCConversationModel *model =[[RCConversationModel alloc]init];
    model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
    [dataSource insertObject:model atIndex:0];
    return dataSource;
}

//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}

//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0f;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section==0) {
//        return 1;
//    }
//    return self.conversationListDataSource.count;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.1;
    }
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
//自定义cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorColor=NAVI_COLOR;
    RCConversationModel *model =[self.conversationListDataSource objectAtIndex:indexPath.row];
    model.isTop=YES;
    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list"];
    cell.lblName.text=@"系统消息";
    cell.ivAva.backgroundColor=NAVI_COLOR;
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    UILabel * la=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, [RCIM sharedRCIM].globalConversationPortraitSize.width, [RCIM sharedRCIM].globalConversationPortraitSize.width)];
    la.font=[UIFont fontWithName:iconFont size:36.0];
    la.textColor=iconGreen;
    la.text=@"\U0000e601";
    [cell.ivAva addSubview:la];
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 67, DEVCE_WITH, 20)];
    view.backgroundColor=NAVI_COLOR;
    [cell.contentView addSubview:view];
    return cell;
}

//*********************插入自定义Cell*********************//
@end
