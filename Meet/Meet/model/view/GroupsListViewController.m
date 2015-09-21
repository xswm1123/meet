//
//  GroupsListViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "GroupsListViewController.h"
#import "ConatctTableViewCell.h"
#import "RCDChatViewController.h"

#define Contact @"Contact"

@interface GroupsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * contactList;
@property (nonatomic,strong) NSMutableArray * firstLetters;
@property (nonatomic,strong) NSMutableDictionary * contactDic;
@property (nonatomic,strong) NSMutableArray * myGroups;
@end

@implementation GroupsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"ConatctTableViewCell" bundle:nil] forCellReuseIdentifier:Contact];
    [self loadAreaData];
    self.tableView.separatorColor=NAVI_COLOR;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
-(void)loadAreaData{
    self.contactDic=[NSMutableDictionary dictionary];
    self.firstLetters=nil;
    self.firstLetters=[NSMutableArray array];
    self.contactList=nil;
    self.contactList=[NSMutableArray array];
    self.myGroups = nil;
    self.myGroups=[NSMutableArray array];
    GetMyJoinedGroupsRequest * request =[[ GetMyJoinedGroupsRequest alloc]init];
    [SystemAPI GetMyJoinedGroupsRequest:request success:^(GetMyJoinedGroupsResponse *response) {
        NSArray * allDics=(NSArray*)response.data;
        for (NSDictionary * dic in allDics) {
            [self.firstLetters addObject:[dic objectForKey:@"letter"]];
            NSDictionary* areaDic=[NSDictionary dictionaryWithObject:[dic objectForKey:@"groupList"] forKey:[dic objectForKey:@"letter"]];
            [self.contactDic setObject:[dic objectForKey:@"groupList"] forKey:[dic objectForKey:@"letter"]];
            [self.contactList addObject:areaDic];
        }
        [self handleListData];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    GetMyCreatedGroupsRequest * requested =[[GetMyCreatedGroupsRequest alloc]init];
    [SystemAPI GetMyCreatedGroupsRequest:requested success:^(GetMyCreatedGroupsResponse *response) {
        NSArray * allGroups=(NSArray *)response.data;
        for (NSDictionary * dic in allGroups) {
//            NSArray * arr =[dic objectForKey:@"groupList"];
                [self.myGroups addObject:dic];
            
        }
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    
}
-(void)handleListData{
    //准备排序sort
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    self.firstLetters=(NSMutableArray*)[self.firstLetters sortedArrayUsingComparator:sort];
}

#pragma tableView delegate and dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.firstLetters.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.myGroups.count ;
    }
    NSArray * arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:section-1]];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        ConatctTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Contact];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {
        NSDictionary * dic=[self.myGroups objectAtIndex:indexPath.row];
        cell.lb_name.text=[dic objectForKey:@"name"];
        cell.photoUrl=[dic objectForKey:@"picUrl"];
        return cell;
    }
        NSArray* arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section-1]];
        NSDictionary * dic=[arr objectAtIndex:indexPath.row];
        cell.lb_name.text=[dic objectForKey:@"name"];
        cell.photoUrl=[dic objectForKey:@"picUrl"];
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVCE_WITH, 20)];
    view.backgroundColor=NAVI_COLOR;
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, DEVCE_WITH-15, 20)];
    if (section!=0) {
        lb.text= [self.firstLetters objectAtIndex:section-1];
    }
    lb.textColor=TempleColor;
    [view addSubview:lb];
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        NSDictionary * dic=[self.myGroups objectAtIndex:indexPath.row];
        RCConversationModel * model=[[RCConversationModel alloc]init:
                                     RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
        model.conversationType=ConversationType_GROUP;
        model.targetId= [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupId"]];
        model.conversationTitle=[dic objectForKey:@"name"];
        model.senderUserId=[ShareValue shareInstance].userInfo.id;
        model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupId"]];
        _conversationVC.userName = [dic objectForKey:@"nname"];
        _conversationVC.title = [dic objectForKey:@"name"];
        _conversationVC.conversation = model;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    if (indexPath.section!=0) {
        NSArray* arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section-1]];
        NSDictionary * dic=[arr objectAtIndex:indexPath.row];
        RCConversationModel * model=[[RCConversationModel alloc]init:
                                     RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
        model.conversationType=ConversationType_GROUP;
        model.targetId= [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupId"]];
        model.conversationTitle=[dic objectForKey:@"name"];
        model.senderUserId=[ShareValue shareInstance].userInfo.id;
        model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"groupId"]];
        _conversationVC.userName = [dic objectForKey:@"nname"];
        _conversationVC.title = [dic objectForKey:@"name"];
        _conversationVC.conversation = model;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
    
}

@end
