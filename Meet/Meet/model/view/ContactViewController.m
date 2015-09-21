//
//  ContactViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactGroupTableViewCell.h"
#import "ConatctTableViewCell.h"
#import "RCDChatViewController.h"

#define Group @"gruop"
#define Contact @"Contact"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * contactList;
@property (nonatomic,strong) NSMutableArray * firstLetters;
@property (nonatomic,strong) NSMutableDictionary * contactDic;
@property (nonatomic,strong) UILabel * rightLabel;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactGroupTableViewCell" bundle:nil] forCellReuseIdentifier:Group];
     [self.tableView registerNib:[UINib nibWithNibName:@"ConatctTableViewCell" bundle:nil] forCellReuseIdentifier:Contact];
    
    self.tableView.separatorColor=NAVI_COLOR;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    //right item
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    rightView.backgroundColor=[UIColor clearColor];
    self.rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    self.rightLabel.font=[UIFont fontWithName:iconFont size:25];
    self.rightLabel.text=@"\U0000e61c";
    self.rightLabel.textColor=TempleColor;
    self.rightLabel.textAlignment=NSTextAlignmentRight;
    [rightView addSubview:self.rightLabel];
    UIBarButtonItem * rightItem =[[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem=rightItem;
    self.rightLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer * tapRight=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPersonCenter)];
    [self.rightLabel addGestureRecognizer:tapRight];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAreaData];
}
-(void)showPersonCenter{
    [self performSegueWithIdentifier:@"personalCenter" sender:nil];
}
-(void)loadAreaData{
    self.contactDic=[NSMutableDictionary dictionary];
    self.firstLetters=nil;
    self.firstLetters=[NSMutableArray array];
    self.contactList=nil;
    self.contactList=[NSMutableArray array];
    GetFriendsListRequest * request =[[ GetFriendsListRequest alloc]init];
    [SystemAPI GetFriendsListRequest:request success:^(GetFriendsListResponse *response) {
        NSArray * allDics=(NSArray*)response.data;
        for (NSDictionary * dic in allDics) {
            [self.firstLetters addObject:[dic objectForKey:@"letter"]];
            NSDictionary* areaDic=[NSDictionary dictionaryWithObject:[dic objectForKey:@"memberList"] forKey:[dic objectForKey:@"letter"]];
            [self.contactDic setObject:[dic objectForKey:@"memberList"] forKey:[dic objectForKey:@"letter"]];
            [self.contactList addObject:areaDic];
        }
        [self handleListData];
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
        return 1;
    }
    NSArray * arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:section-1]];
//    NSArray * arr=[dic objectForKey:@"memberList"];
    return arr.count;
//    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ContactGroupTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:Group];
        if (!cell) {
            cell=[[ContactGroupTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Group];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            cell.lb_name.text=@"添加好友";
            cell.lb_icon.textColor=iconBlue;
            cell.lb_icon.text=@"\U0000e601";
        }
//        if (indexPath.row==1) {
//            cell.lb_name.text=@"群组";
//            cell.lb_icon.textColor=iconGreen;
//            cell.lb_icon.text=@"\U0000e601";
//        }
        return cell;
    }
    if (indexPath.section!=0) {
        ConatctTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Contact];
        if (!cell) {
            cell=[[ConatctTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Contact];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSArray* arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section-1]];
        NSDictionary * dic=[arr objectAtIndex:indexPath.row];
        cell.lb_name.text=[dic objectForKey:@"nickname"];
        cell.photoUrl=[dic objectForKey:@"avatar"];
        return cell;
    }
    return nil;
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
        if (indexPath.row==0) {
            [self performSegueWithIdentifier:@"addFriend" sender:nil];
        }
//        if (indexPath.row==1) {
//            [self performSegueWithIdentifier:@"groupsList" sender:nil];
//        }
    }
    if (indexPath.section!=0) {
        NSArray* arr=[self.contactDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section-1]];
        NSDictionary * dic=[arr objectAtIndex:indexPath.row];
        RCConversationModel * model=[[RCConversationModel alloc]init:
                                    RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
        model.conversationType=ConversationType_PRIVATE;
        model.targetId= [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        model.conversationTitle=[dic objectForKey:@"nickname"];
        model.senderUserId=[ShareValue shareInstance].userInfo.id;
        model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
        RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
        _conversationVC.conversationType = ConversationType_PRIVATE;
        _conversationVC.targetId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        _conversationVC.userName = [dic objectForKey:@"nickname"];
        _conversationVC.title = [dic objectForKey:@"nickname"];
        _conversationVC.conversation = model;
        _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
        _conversationVC.enableUnreadMessageIcon=YES;
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }
}

@end
