//
//  RCDPrivateViewController.m
//  RCloudMessage
//
//  Created by Liv on 15/4/21.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDPrivateSettingViewController.h"
#import "PersonalHomePageViewController.h"
#import "ReportViewController.h"

@interface RCDPrivateSettingViewController ()

@end

@implementation RCDPrivateSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[UIView new];
    [self disableInviteMemberEvent:YES];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed=YES;
    self.view.frame=CGRectMake(0, 0, DEVCE_WITH, DEVICE_HEIGHT);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.headerHidden=YES;
    self.tabBarController.tabBar.hidden=YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.defaultCells.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.defaultCells[indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //个人主页
    if (indexPath.row==0) {
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
        vc.memberId=[NSString stringWithFormat:@"%@",self.targetId];
        [self.navigationController pushViewController:vc animated:YES];
    }
    //拉黑
    if (indexPath.row==3) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AddBlackListRequest * request =[[AddBlackListRequest alloc]init];
        request.blackId=self.targetId;
        [SystemAPI AddBlackListRequest:request success:^(AddBlackListResponse *response) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showSuccess:response.message toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(BOOL notReachable, NSString *desciption) {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showError:desciption toView:self.view];
        }];
    }
    //举报
    if (indexPath.row==4) {
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ReportViewController * vc=[sb instantiateViewControllerWithIdentifier:@"ReportViewController"];
        vc.targetId=self.targetId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
