//
//  NearByViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "NearByViewController.h"
#import "NearByListTableViewCell.h"
#import "PersonalHomePageViewController.h"
#import "HomeGroupsTableViewCell.h"

#define NearByCell @"NearByListTableViewCell"
#define group @"group"

@interface NearByViewController ()<UITableViewDataSource,UITableViewDelegate,JoinGroupDelegate>{
    NSString * baseSex;
    NSString * baseMinAge;
    NSString * baseMaxAge;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *ageBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray * peopleArr;
@property (nonatomic,strong) NSArray * groupArr;
@property (nonatomic,strong) UILabel * markLabel;
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize=10;
    self.tableView.backgroundColor=NAVI_COLOR;
    [self.tableView registerNib:[UINib nibWithNibName:@"NearByListTableViewCell" bundle:nil] forCellReuseIdentifier:NearByCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeGroupsTableViewCell" bundle:nil] forCellReuseIdentifier:group];
    self.tableView.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
    }];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.pageSize<1000) {
            self.pageSize+=10;
            [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
        }else{
            [self.tableView.footer endRefreshing];
            [self.tableView.footer noticeNoMoreData];
        }
        
    }];
    [self initView];
}
-(void)initView{
    self.sexBtn.backgroundColor=cellColor;
    [self.sexBtn setTitle:@"性别不限▼" forState:UIControlStateNormal];
    self.ageBtn.backgroundColor=cellColor;
    [self.ageBtn setTitle:@"18岁以上▼" forState:UIControlStateNormal];
    //load data 默认加载性别不限，年龄不限
    [self loadNearByUsersWith:nil AndMinAge:nil MaxAge:nil];
    self.markLabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 100, DEVCE_WITH-16, 40)];
    self.markLabel.text=@"开发中，敬请期待";
    self.markLabel.hidden=YES;
    self.markLabel.textColor=[UIColor whiteColor];
    self.markLabel.textAlignment=NSTextAlignmentCenter;
    self.markLabel.font=[UIFont systemFontOfSize:30];
    [self.view addSubview:self.markLabel];

}
-(void)loadNearByUsersWith:(NSString*)sex AndMinAge:(NSString*)minAge MaxAge:(NSString*)maxAge{
    self.peopleArr=nil;
    GetNearByUserRequest * request =[[ GetNearByUserRequest alloc]init];
    request.sex=sex;
    request.minAge=minAge;
    request.maxAge=maxAge;
    request.pageSize=self.pageSize;
    [SystemAPI GetNearByUserRequest:request success:^(GetNearByUserResponse *response) {
        self.peopleArr = (NSArray*)response.data;
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
}
-(void)loadNearGroups{
    GetNearByGroupRequest * request =[[GetNearByGroupRequest alloc]init];
    request.lng=104.6539460000;
    request.lat=30.1413030000;
    [SystemAPI GetNearByGroupRequest:request success:^(GetNearByGroupResponse *response) {
        self.groupArr=(NSArray*)response.data;
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
}
- (IBAction)segmentValueChanged:(id)sender {
    if (self.segmentControl.selectedSegmentIndex==0) {
        self.ageBtn.hidden=NO;
        self.sexBtn.hidden=NO;
        self.tableView.hidden=NO;
        self.markLabel.hidden=YES;
        [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        self.ageBtn.hidden=YES;
        self.sexBtn.hidden=YES;
//        [self loadNearGroups];
        self.tableView.hidden=YES;
        self.markLabel.hidden=NO;
    }
}
- (IBAction)selectWithSex:(id)sender {
    UIButton * btn=sender;
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"性别不限"
                     image:nil
                    target:self
                    action:@selector(allSexs)],
      [KxMenuItem menuItem:@"仅限女性"
                     image:nil
                    target:self
                    action:@selector(selectedByFamale)],
      
      [KxMenuItem menuItem:@"仅限男性"
                     image:nil
                    target:self
                    action:@selector(selectedByMale)]
      ];
   
    CGRect targetFrame = btn.frame;
    [KxMenu showMenuInView:self.view
                  fromRect:targetFrame
                 menuItems:menuItems];
}
- (IBAction)selectWithAge:(id)sender {
    UIButton * btn=sender;
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"18岁"
                     image:nil
                    target:self
                    action:@selector(allAges)],
      
      [KxMenuItem menuItem:@"18以上"
                     image:nil
                    target:self
                    action:@selector(under18Years)],
      
      [KxMenuItem menuItem:@"18-25岁"
                     image:nil
                    target:self
                    action:@selector(between18To25Years)],
      
      [KxMenuItem menuItem:@"25-30岁"
                     image:nil
                    target:self
                    action:@selector(between25To30Years)],
      
      [KxMenuItem menuItem:@"30-45岁"
                     image:nil
                    target:self
                    action:@selector(between30To45Years)],
      
      [KxMenuItem menuItem:@"45岁以上"
                     image:nil
                    target:self
                    action:@selector(above45Years)]
      ];
   
    CGRect targetFrame = btn.frame;
    
    [KxMenu showMenuInView:self.view
                  fromRect:targetFrame
                 menuItems:menuItems];
}
/**
 *  KxMenu 的方法
 *
 */
/**
 *  性别不限
 */
-(void)allSexs{
    [self.sexBtn setTitle:@"性别不限▼" forState:UIControlStateNormal];
    baseSex=nil;
     [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  仅限男性
 */
-(void)selectedByMale{
    [self.sexBtn setTitle:@"仅限男性▼" forState:UIControlStateNormal];
    baseSex=@"1";
     [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  仅限女性
 */
-(void)selectedByFamale{
    [self.sexBtn setTitle:@"仅限女性▼" forState:UIControlStateNormal];
    baseSex=@"2";
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  年龄不限
 */
-(void)allAges{
    [self.ageBtn setTitle:@"18岁▼" forState:UIControlStateNormal];
    baseMinAge=nil;
    baseMaxAge=nil;
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  18岁以下
 */
-(void)under18Years{
     [self.ageBtn setTitle:@"18以上▼" forState:UIControlStateNormal];
    baseMinAge=nil;
    baseMaxAge=@"18";
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  18-25岁
 */
-(void)between18To25Years{
     [self.ageBtn setTitle:@"18-25岁▼" forState:UIControlStateNormal];
    baseMinAge=@"18";
    baseMaxAge=@"25";
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  25-30岁
 */
-(void)between25To30Years{
     [self.ageBtn setTitle:@"25-30岁▼" forState:UIControlStateNormal];
    baseMinAge=@"25";
    baseMaxAge=@"30";
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  30-45岁
 */
-(void)between30To45Years{
     [self.ageBtn setTitle:@"30-45岁▼" forState:UIControlStateNormal];
    baseMinAge=@"30";
    baseMaxAge=@"45";
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
/**
 *  45岁以上
 */
-(void)above45Years{
     [self.ageBtn setTitle:@"45岁以上▼" forState:UIControlStateNormal];
    baseMinAge=@"45";
    baseMaxAge=nil;
    [self loadNearByUsersWith:baseSex AndMinAge:baseMinAge MaxAge:baseMaxAge];
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.segmentControl.selectedSegmentIndex==0) {
         return self.peopleArr.count;
    }
    if (self.segmentControl.selectedSegmentIndex==1) {
        return self.groupArr.count;
    }
    return 0;
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
    if (self.segmentControl.selectedSegmentIndex==0) {
    NearByListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:NearByCell];
    if (!cell) {
        cell=[[NearByListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NearByCell];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dic =[self.peopleArr objectAtIndex:indexPath.section];
    NSString * sex=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sex"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"avatar"]];
    cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
        cell.lb_sign.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"sign"]];
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
    if (self.segmentControl.selectedSegmentIndex==1) {
        HomeGroupsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:group];
        NSDictionary * dic=[self.groupArr objectAtIndex:indexPath.section];
        cell.delegate=self;
        cell.lb_name.text=[dic objectForKey:@"name"];
        cell.lb_count.text=[NSString stringWithFormat:@"群成员:%@",[dic objectForKey:@"currentNum"]];
        cell.lb_desc.text=[dic objectForKey:@"description"];
        NSString * urls=[dic objectForKey:@"picUrl"];
        NSArray * arr=[urls componentsSeparatedByString:@","];
        cell.photoUrl=[arr objectAtIndex:0];
        cell.groupId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
        
        return cell;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.segmentControl.selectedSegmentIndex==0) {
        NSDictionary * dic =[self.peopleArr objectAtIndex:indexPath.section];
        NSString * memberId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"memberId"]];
        [self performSegueWithIdentifier:@"homePage" sender:memberId];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"homePage"]) {
        PersonalHomePageViewController * vc= segue.destinationViewController;
        vc.memberId=sender;
    }
}
-(void)joinGroup:(HomeGroupsTableViewCell *)cell{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ApplyGroupRequest  *request =[[ApplyGroupRequest alloc]init];
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

