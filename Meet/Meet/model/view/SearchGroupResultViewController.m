//
//  SearchGroupResultViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/1.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "SearchGroupResultViewController.h"
#import "HomeGroupsTableViewCell.h"

#define Group @"HomeGroupsTableViewCell"

@interface SearchGroupResultViewController ()<UITableViewDataSource,UITableViewDelegate,JoinGroupDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchGroupResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:Group bundle:nil] forCellReuseIdentifier:Group];
}
#pragma tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeGroupsTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:Group];
    NSDictionary * dic =[self.groupList objectAtIndex:indexPath.section];
    cell.photoUrl=[dic objectForKey:@"picUrl"];
    cell.lb_name.text=[dic objectForKey:@"name"];
    cell.lb_desc.text=[dic objectForKey:@"description"];
    cell.lb_count.text=[NSString stringWithFormat:@"群成员:%@",[dic objectForKey:@"memberCount"]];
    cell.groupId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"groupId"]];
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
-(void)joinGroup:(HomeGroupsTableViewCell *)cell{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ApplyGroupRequest * request=[[ApplyGroupRequest alloc]init];
    request.groupId=cell.groupId;
    [SystemAPI ApplyGroupRequest:request success:^(ApplyGroupResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
