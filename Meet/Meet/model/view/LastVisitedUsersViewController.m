//
//  LastVisitedUsersViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/12.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "LastVisitedUsersViewController.h"
#import "NearByListTableViewCell.h"
#import "PersonalHomePageViewController.h"

#define NearByCell @"NearByListTableViewCell"
@interface LastVisitedUsersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * peopleArr;
@end

@implementation LastVisitedUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearByListTableViewCell" bundle:nil] forCellReuseIdentifier:NearByCell];
    [self loadData];
    [ShareValue shareInstance].lastVisitCount=[NSNumber new];
    [ShareValue shareInstance].lastVisitMessage=[NSNumber new];
}
-(void)loadData{
    GetLastVisitUsersRequest * request=[[GetLastVisitUsersRequest alloc]init];
    [SystemAPI GetLastVisitUsersRequest:request
                          success:^(GetLastVisitUsersResponse *response) {
                              self.peopleArr =[NSArray arrayWithArray:(NSArray*)response.data];
                              [self.tableView reloadData];
//                              NSDateFormatter * frm=[[NSDateFormatter alloc]init];
//                              [frm setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//                              NSDate * date =[NSDate new];
//                              NSString * dateNew=[frm stringFromDate:date];
                              NSDictionary * dic =[self.peopleArr firstObject];
                              [ShareValue shareInstance].lastVisitDate=dic[@"time"];
                                } fail:^(BOOL notReachable, NSString *desciption) {
                                    [self.tableView reloadData];
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
        NearByListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NearByCell];
        if (!cell) {
            cell=[[NearByListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NearByCell];
        }
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary * dic =[self.peopleArr objectAtIndex:indexPath.section];
        NSString * sex=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
        cell.photoUrl=[dic objectForKey:@"avatar"];
        cell.name=[dic objectForKey:@"nickname"];
        cell.lb_name.font=[UIFont fontWithName:iconFont size:18];
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
        cell.lb_distance.text=[dic objectForKey:@"distance"];
        return cell;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSDictionary * dic =[self.peopleArr objectAtIndex:indexPath.section];
        NSString * memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"srcId"]];
        UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=memberId;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}
@end
