//
//  BlackListViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlackListCellTableViewCell.h"

#define black @"BlackListCellTableViewCell"

@interface BlackListViewController ()<UITableViewDelegate,UITableViewDataSource,BlackListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * list;
@end

@implementation BlackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:black bundle:nil] forCellReuseIdentifier:black];
    [self getList];
}
-(void)getList{
    self.list=nil;
    GetBlackListRequest * request =[[GetBlackListRequest alloc]init];
    [SystemAPI GetBlackListRequest:request success:^(GetBlackListResponse *response) {
        self.list=[NSArray arrayWithArray:(NSArray*)response.data];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
    }];
}
#pragma tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.list.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlackListCellTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:black];
    NSDictionary * dic =[self.list objectAtIndex:indexPath.section];
    cell.photoUrl=[dic objectForKey:@"avatar"];
    cell.lb_name.text=[dic objectForKey:@"nickname"];
    cell.memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
    cell.delegate=self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    return view;
}
-(void)cancelBlackList:(BlackListCellTableViewCell *)cell{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CancelBlackListRequest * reqeust =[[CancelBlackListRequest alloc]init];
    reqeust.blackId=cell.memberId;
    [SystemAPI CancelBlackListRequest:reqeust success:^(CancelBlackListResponse *response) {
        [self getList];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
