//
//  GlobalRankingDetailsViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/15.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "GlobalRankingDetailsViewController.h"
#import "RankingTableViewCell.h"
#import "PersonalHomePageViewController.h"

#define RankCellId @"RankingTableViewCell"

@interface GlobalRankingDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (nonatomic,strong) NSMutableArray * rankList;
@property (nonatomic,strong) NSDictionary * myRank;
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation GlobalRankingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize=10;
    self.firstImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.firstImageView.layer.borderWidth=1;
    self.secondImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.secondImageView.layer.borderWidth=1;
    self.thirdImageView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.thirdImageView.layer.borderWidth=1;
    [self.tableView registerNib:[UINib nibWithNibName:RankCellId bundle:nil] forCellReuseIdentifier:RankCellId];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self loadDatas];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDatas];
    }];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.pageSize<10000) {
            self.pageSize+=10;
            [self loadDatas];
        }else{
            [self.tableView.footer endRefreshing];
            [self.tableView.footer noticeNoMoreData];
        }
        
    }];

}
/**
 *  加载详情数据
 */
-(void)loadDatas{
    //onlineTime:总排行meili:魅力totalPay:总消费gold总财富
    NSString * sortId=@"onlineTime";
    GetRankingDetailsRequest * request=[[GetRankingDetailsRequest alloc]init];
    request.sortField=sortId;
    request.pageSize=self.pageSize;
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [SystemAPI GetRankingDetailsRequest:request success:^(GetRankingDetailsResponse *response) {
        self.rankList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        if (self.rankList.count>=3) {
            NSDictionary * fDic=[self.rankList objectAtIndex:0];
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[fDic objectForKey:@"avatar"]]];
            NSDictionary *sDic=[self.rankList objectAtIndex:1];
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:[sDic objectForKey:@"avatar"]]];
            
            NSDictionary * tDic=[self.rankList objectAtIndex:2];
            [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:[tDic objectForKey:@"avatar"]]];
        }else if (self.rankList.count==2){
            NSDictionary * fDic=[self.rankList objectAtIndex:0];
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[fDic objectForKey:@"avatar"]]];
            NSDictionary *sDic=[self.rankList objectAtIndex:1];
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:[sDic objectForKey:@"avatar"]]];
        }else if (self.rankList.count==1){
            NSDictionary * fDic=[self.rankList objectAtIndex:0];
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:[fDic objectForKey:@"avatar"]]];
        }
               [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
    GetMyRankRequest  * reqs=[[GetMyRankRequest alloc]init];
    reqs.sortField=@"online_time";
    [SystemAPI GetMyRankRequest:reqs success:^(GetMyRankResponse *response) {
        self.myRank=response.data;
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}
#pragma tableView delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.rankList.count>=3) {
        return self.rankList.count-2;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 15;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankingTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:RankCellId];
    if (indexPath.section==0) {
        cell.photoUrl=[NSString stringWithFormat:@"%@",[self.myRank objectForKey:@"avatar"]];
        cell.lb_name.text=[NSString stringWithFormat:@"%@",[self.myRank objectForKey:@"nickname"]];
        
        cell.lb_desc.text=[NSString stringWithFormat:@"在线时长:%@",[self.myRank objectForKey:@"onlineTime"]];
        cell.lb_no.text=[NSString stringWithFormat:@"%@",[self.myRank objectForKey:@"ranking"]];
        return cell;
    }

    NSDictionary * dic=[self.rankList objectAtIndex:indexPath.section+2];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    cell.lb_name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    cell.lb_desc.text=[NSString stringWithFormat:@"在线时长:%@",[dic objectForKey:@"onlineTime"]];
    cell.lb_no.text=[NSString stringWithFormat:@"%d",indexPath.section+3];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self showHomePageWithUserId:[NSString stringWithFormat:@"%@",[ShareValue shareInstance].userInfo.id]];
    }
    if (indexPath.section!=0) {
        NSDictionary * dic=[self.rankList objectAtIndex:indexPath.section+2];
        [self showHomePageWithUserId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]]];
    }
}
-(void)showHomePageWithUserId:(NSString*)userId{
    UIStoryboard * sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PersonalHomePageViewController * vc=[sb instantiateViewControllerWithIdentifier:@"homePage"];
    vc.memberId=userId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)showFirstHomePage:(id)sender {
    NSDictionary * dic=[self.rankList objectAtIndex:0];
    [self showHomePageWithUserId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]]];
}
- (IBAction)showSecondHomePage:(id)sender {
    NSDictionary * dic=[self.rankList objectAtIndex:1];
    [self showHomePageWithUserId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]]];
}
- (IBAction)showThirdHomePage:(id)sender {
    NSDictionary * dic=[self.rankList objectAtIndex:2];
    [self showHomePageWithUserId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]]];
}
@end
