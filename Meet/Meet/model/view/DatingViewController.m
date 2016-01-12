//
//  DatingViewController.m
//  Meet
//
//  Created by Anita Lee on 15/11/25.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import "DatingViewController.h"
#import "PersonalHomePageViewController.h"
#import "DatingTableViewCell.h"
#import "RCDChatViewController.h"
#define DateCell @"DatingTableViewCell"

@interface DatingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * peopleArr;
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation DatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.pageSize=10;
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:DateCell bundle:nil] forCellReuseIdentifier:DateCell];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWithPageSize:self.pageSize];
    }];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.pageSize<10000) {
            self.pageSize+=10;
             [self loadDataWithPageSize:self.pageSize];
        }else{
            [self.tableView.footer endRefreshing];
            [self.tableView.footer noticeNoMoreData];
        }
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadDataWithPageSize:self.pageSize];
}
-(void)loadDataWithPageSize:(NSInteger)size{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GetDatingDataRequest * request =[[GetDatingDataRequest alloc]init];
    request.pageSize=self.pageSize;
    [SystemAPI GetDatingDataRequest:request success:^(GetDatingDataResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.peopleArr=(NSArray*)response.data;
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.peopleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DatingTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:DateCell];
    if (!cell) {
        cell=[[DatingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DateCell];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dic =[self.peopleArr objectAtIndex:indexPath.section];
    NSString * sex=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    cell.lb_desc.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"address"]];
    cell.lb_name.font=[UIFont fontWithName:iconFont size:16];
    cell.lb_time.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"time"]];
    NSString * names;
    if ([sex isEqualToString:@"1"]) {
        names=[NSString stringWithFormat:@"%@%@",cell.name,@"\U0000e617"];
        NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, cell.name.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, cell.name.length)];
        [str addAttribute:NSForegroundColorAttributeName value:iconBlue range:NSMakeRange(cell.name.length, str.length-cell.name.length)];
        cell.lb_name.attributedText=str;
    }else{
        names=[NSString stringWithFormat:@"%@%@",cell.name,@"\U0000e616"];
        NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, cell.name.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, cell.name.length)];
        [str addAttribute:NSForegroundColorAttributeName value:iconRed range:NSMakeRange(cell.name.length, str.length-cell.name.length)];
        cell.lb_name.attributedText=str;
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary  * dic =[self.peopleArr objectAtIndex:indexPath.section];
//    RCConversationModel * model=[[RCConversationModel alloc]init:
//                                 RC_CONVERSATION_MODEL_TYPE_NORMAL exntend:nil];
//    model.conversationType=ConversationType_PRIVATE;
//    model.targetId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
//    model.conversationTitle=[dic objectForKey:@"nickname"];
//    model.senderUserId=[ShareValue shareInstance].userInfo.id;
//    model.senderUserName=[ShareValue shareInstance].userInfo.nickname;
//    RCDChatViewController *_conversationVC = [[RCDChatViewController alloc]init];
//    _conversationVC.conversationType = ConversationType_PRIVATE;
//    _conversationVC.targetId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
//    _conversationVC.userName = [dic objectForKey:@"nickname"];
//    _conversationVC.title =[dic objectForKey:@"nickname"];
//    _conversationVC.conversation = model;
//    _conversationVC.enableNewComingMessageIcon=YES;//开启消息提醒
//    _conversationVC.enableUnreadMessageIcon=YES;
//    [self.navigationController pushViewController:_conversationVC animated:YES];
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)publishAction:(id)sender {
    PublishDatingRequest  * request =[[PublishDatingRequest alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SystemAPI PublishDatingRequest:request success:^(PublishDatingResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
