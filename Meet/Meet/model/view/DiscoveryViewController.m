//
//  DiscoveryViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryTableViewCell.h"
#import "RechargeVipViewController.h"
#import "EditProfileViewController.h"
#import "PersonalCenterViewController.h"
#define DiscoveryTableViewCellID @"DiscoveryTableViewCell"

@interface DiscoveryViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * rankList;
@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:DiscoveryTableViewCellID];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self loadRankDatas];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)loadRankDatas{
    GetRankingListRequest * request=[[GetRankingListRequest alloc]init];
    [SystemAPI GetRankingListRequest:request success:^(GetRankingListResponse *response) {
        NSArray * meiliList=[response.data objectForKey:@"meiliList"];
        self.rankList=[meiliList copy];
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }
    if (section==1) {
        return 2;
    }
    if (section==2) {
        return 5;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:DiscoveryTableViewCellID];
    if (!cell) {
        cell=[[DiscoveryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DiscoveryTableViewCellID];
    }
    cell.arrow.textColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    cell.arrow.text=@"\U0000e639";
    cell.arrow.font=[UIFont fontWithName:iconFont size:20];
    UIView * countView =[cell.contentView viewWithTag:8989];
    [countView removeFromSuperview];
    
    UILabel * labelCircle=[[UILabel alloc]initWithFrame:CGRectMake(130, 14, 20, 20)];
    labelCircle.layer.cornerRadius=10;
    labelCircle.backgroundColor=[UIColor redColor];
    labelCircle.textColor=[UIColor whiteColor];
    labelCircle.clipsToBounds=YES;
    labelCircle.textAlignment=NSTextAlignmentCenter;
    labelCircle.font=[UIFont systemFontOfSize:15];
    labelCircle.adjustsFontSizeToFitWidth=YES;
    labelCircle.tag=8989;
    NSInteger lastVisitCount =[[ShareValue shareInstance].lastVisitCount integerValue];
    if (lastVisitCount>0) {
        labelCircle.text=[NSString stringWithFormat:@"%@",[ShareValue shareInstance].lastVisitCount];
         [cell.contentView addSubview:labelCircle];
    }else{
        [labelCircle removeFromSuperview];
    }
    labelCircle.hidden=YES;
    
    if (indexPath.section==0) {
        labelCircle.hidden=YES;
        if (indexPath.row==0) {
            cell.lb_icon.text=@"\U0000e60d";
            cell.lb_title.text=@"好友圈";
            cell.lb_icon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];
        }
        if (indexPath.row==1) {
            labelCircle.hidden=NO;
            cell.lb_icon.text=@"\U0000e600";
            cell.lb_title.text=@"最近访客";
            cell.lb_icon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];
        }
    }
    if (indexPath.section==1) {
        labelCircle.hidden=YES;
        switch (indexPath.row) {
            case 0:
                cell.lb_icon.text=@"\U0000e628";
                cell.lb_title.text=@"附近商家";
                cell.lb_icon.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
                break;
            case 1:
                cell.lb_icon.text=@"\U0000e619";
                cell.lb_title.text=@"排行榜";
                cell.lb_icon.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
                cell.imageUrls=self.rankList;
                break;
                
            default:
                break;
        }
        
    }
    if (indexPath.section==2) {
        labelCircle.hidden=YES;
        switch (indexPath.row) {
            case 0:
                cell.lb_icon.text=@"\U0000e60b";
                cell.lb_title.text=@"会员中心";
                cell.lb_icon.textColor=[UIColor colorWithRed:219/255.0 green:40/255.0 blue:163/255.0 alpha:1.0];
                break;
            case 1:
                cell.lb_icon.text=@"\U0000e603";
                cell.lb_title.text=@"商城中心";
                cell.lb_icon.textColor=[UIColor colorWithRed:232/255.0 green:80/255.0 blue:63/255.0 alpha:1.0];
                break;
            case 2:
                cell.lb_icon.text=@"\U0000e60a";
                cell.lb_title.text=@"金币领取";
                cell.lb_icon.textColor=[UIColor colorWithRed:243/255.0 green:197/255.0 blue:45/255.0 alpha:1.0];
                break;
            case 3:
                cell.lb_icon.text=@"\U0000e608";
                cell.lb_title.text=@"表情下载";
                cell.lb_icon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];
                break;
            case 4:
                cell.lb_icon.text=@"\U0000e600";
                cell.lb_title.text=@"个人设置";
                cell.lb_icon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];
                break;
            default:
                break;
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.frame=CGRectMake(0, 0, tableView.frame.size.width, 15);
    view.backgroundColor=NAVI_COLOR;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"friendCircle" sender:nil];
                    break;
                case 1:
                    [self showLastVisit];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"store" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"rank" sender:nil];
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"VIPCenter" sender:nil];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"storesCenter" sender:nil];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"receiveGold" sender:nil];
                    break;
                case 3:
                    [self performSegueWithIdentifier:@"emojDownload" sender:nil];
                    break;
                case 4:
                    [self showEdit];
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)showEdit{
    UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalCenterViewController *  vc =[sb instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)showLastVisit{
    BOOL isVip=YES;
    NSString * type=[ShareValue shareInstance].userInfo.type;
    if ([type integerValue]==1) {
        isVip =NO;
    }
    if (isVip) {
        [self performSegueWithIdentifier:@"lastVisit" sender:nil];
    }else{
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还不是会员，因此无法查看您的最近访客，请前往会员充值中心充值！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tag=500;
        [al show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==500) {
        if (buttonIndex==1) {
            UIStoryboard * sb =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            RechargeVipViewController * vc=[sb instantiateViewControllerWithIdentifier:@"RechargeVipViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
