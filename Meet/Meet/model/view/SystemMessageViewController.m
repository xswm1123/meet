//
//  SystemMessageViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "GiftListTableViewCell.h"

#define MessageCell @"SystemMessageTableViewCell"
#define GiftCell @"GiftListTableViewCell"
@interface SystemMessageViewController ()<UITableViewDataSource,UITableViewDelegate,SystemMessageCellDelegate>
@property (weak, nonatomic) IBOutlet BaseSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * applyArr;
@property (nonatomic,strong) NSArray * giftsArr;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ShareValue shareInstance].systemMessage=[NSNumber numberWithInt:0];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:MessageCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"GiftListTableViewCell" bundle:nil] forCellReuseIdentifier:GiftCell];
    [self loadCheckMessage];
}
- (IBAction)segmentValueChanged:(BaseSegmentControl *)sender {
    if (self.segmentControl.selectedSegmentIndex==0) {
        [self loadCheckMessage];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        [self loadGifts];
    }
    
}
-(void)loadCheckMessage{
    self.applyArr=[NSArray array];
    self.giftsArr=[NSArray array];
    GetFriendApplyMessageRequest * request=[[GetFriendApplyMessageRequest alloc]init];
    [SystemAPI GetFriendApplyMessageRequest:request success:^(GetFriendApplyMessageResponse *response) {
        self.applyArr=(NSArray * )response.data;
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
}
-(void)loadGifts{
    self.applyArr=[NSArray array];
    self.giftsArr=[NSArray array];
    GetGiftMessageRequest * request =[[GetGiftMessageRequest alloc]init];
    [SystemAPI GetGiftMessageRequest:request success:^(GetGiftMessageResponse *response) {
        self.giftsArr=(NSArray *)response.data;
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
}
#pragma tableView  delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.segmentControl.selectedSegmentIndex==0) {
        return self.applyArr.count;
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        return self.giftsArr.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentControl.selectedSegmentIndex==0) {
        SystemMessageTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:MessageCell];
        cell.delegate=self;
        NSDictionary * dic=[self.applyArr objectAtIndex:indexPath.section];
        cell.infoDic=dic;
        cell.photoUrl=[dic objectForKey:@"avatar"];
        cell.lb_name.text=[dic objectForKey:@"nickname"];
        cell.lb_date.text=[dic objectForKey:@"created"];
        if ([[dic objectForKey:@"content"] isKindOfClass:[NSNull class]]) {
            cell.lb_desc.text=@"";
        }else{
            cell.lb_desc.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        }
        return cell;
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        GiftListTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:GiftCell];
        NSDictionary * dic=[self.giftsArr objectAtIndex:indexPath.section];
        cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
        cell.lb_desc.text=[dic objectForKey:@"content"];
        cell.lb_goldCount.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
        cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
        cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[UIView new];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentControl.selectedSegmentIndex==0) {
         return 114;
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        return 70;
    }
    return 114;
}
/**
 *  systemMessageDelegate
 */
//同意
-(void)agreeWithCell:(SystemMessageTableViewCell *)cell{
    NSString * type=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"type"]];
    //好友
    if ([type isEqualToString:@"1"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AgreeFriendApplyRequest * request=[[AgreeFriendApplyRequest alloc]init];
        request.sysId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"id"]];
        request.applyId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"appyId"]];
        [SystemAPI AgreeFriendApplyRequest:request success:^(AgreeFriendApplyResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            [self loadCheckMessage];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
    //群组
    if ([type isEqualToString:@"2"]) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AgreeGroupApplyRequest * request=[[AgreeGroupApplyRequest alloc]init];
        request.sysId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"id"]];
        request.applyId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"appyId"]];
        request.groupId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"groupId"]];
        [SystemAPI AgreeGroupApplyRequest:request success:^(AgreeGroupApplyResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            [self loadCheckMessage];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
}
//拒绝
-(void)refuseWithCell:(SystemMessageTableViewCell *)cell{
    NSString * type=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"type"]];
    //好友
    if ([type isEqualToString:@"1"]) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        RefuseFriendApplyRequest * request =[[RefuseFriendApplyRequest alloc]init];
        request.sysId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"id"]];
        request.applyId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"appyId"]];
        [SystemAPI RefuseFriendApplyRequest:request success:^(RefuseFriendApplyResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            [self loadCheckMessage];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
    //群组
    if ([type isEqualToString:@"2"]) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        RefuseGroupApplyRequest * request =[[RefuseGroupApplyRequest alloc]init];
        request.sysId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"id"]];
        [SystemAPI RefuseGroupApplyRequest:request success:^(RefuseGroupApplyResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            [self loadCheckMessage];
        } fail:^(BOOL notReachable, NSString *desciption) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
}
//加入黑名单
-(void)addBlackListWithCell:(SystemMessageTableViewCell *)cell{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AddBlackListRequest * request =[[AddBlackListRequest alloc]init];
    request.sysId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"id"]];
    request.blackId=[NSString stringWithFormat:@"%@",[cell.infoDic objectForKey:@"appyId"]];
    [SystemAPI AddBlackListRequest:request success:^(AddBlackListResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
        [self loadCheckMessage];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
