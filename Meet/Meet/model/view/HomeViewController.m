//
//  HomeViewController.m
//  Meet
//
//  Created by Anita Lee on 15/7/24.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "HomeViewController.h"
#import "VideoCollectionViewCell.h"
#import "VideoDetailsViewController.h"
#import "RechargeVipViewController.h"

#define VideoCollectionViewCellID @"VideoCollectionViewCell"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
{
    NSString * sortField;
    NSString * categoryId;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataList;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) NSArray * categoryList;
@property (weak, nonatomic) IBOutlet UIButton *viewCountBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (nonatomic,assign) BOOL isHasMemberId;

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHasMemberId=NO;
    [self initView];
    self.pageSize=10;
    [self loadNewListDataWithPageSize:10];
   }
-(void)initView{
    sortField=@"created";
    categoryId=@"1";
    self.createBtn.selected=YES;
    self.viewCountBtn.backgroundColor=cellColor;
    self.createBtn.backgroundColor=cellColor;
    self.segmentControl.clipsToBounds=YES;
    self.segmentControl.layer.cornerRadius=8;
    self.segmentControl.layer.borderColor=TempleColor.CGColor;
    self.segmentControl.layer.borderWidth=1;
    self.segmentControl.tintColor=TempleColor;
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateNormal];
    [self.segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0 weight:12]} forState:UIControlStateSelected];
    self.segmentControl.selectedSegmentIndex=0;
    self.collectionView.backgroundColor=NAVI_COLOR;
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:VideoCollectionViewCellID];
    /**
     *  加载类目
     */
    GetIndexCategoryRequest * request =[[GetIndexCategoryRequest alloc]init];
    [SystemAPI GetIndexCategoryRequest:request success:^(GetIndexCategoryResponse *response) {
        self.categoryList=[NSArray arrayWithArray:(NSArray*)response.data];
        for (int i =0; i<self.categoryList.count; i++) {
            NSDictionary * dic =self.categoryList[i];
            [self.segmentControl setTitle:[dic objectForKey:@"name"] forSegmentAtIndex:i];
        }
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    /**
     *  加头部刷新和脚部加载
     */
    self.collectionView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.collectionView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageSize+=10;
        [self loadData];

    }];
    
}
- (IBAction)selectedViewCountAction:(id)sender {
    sortField=@"viewCount";
    self.viewCountBtn.selected=YES;
    self.createBtn.selected=NO;
    NSDictionary * dic =[self.categoryList objectAtIndex:self.segmentControl.selectedSegmentIndex];
    categoryId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self loadMostViewedDataWithPageSize:self.pageSize];
}
- (IBAction)selectedCreateCount:(id)sender {
    sortField=@"created";
    self.viewCountBtn.selected=NO;
    self.createBtn.selected=YES;
    NSDictionary * dic =[self.categoryList objectAtIndex:self.segmentControl.selectedSegmentIndex];
    categoryId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [self loadNewListDataWithPageSize:self.pageSize];
}
/**
 *  加载热门的列表
 *
 */
-(void)loadMostViewedDataWithPageSize:(NSInteger) pageSize{
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=sortField;
    request.categoryId=categoryId;
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%ld",(long)pageSize];
    }
    if (self.isHasMemberId) {
        request.memberId=[ShareValue shareInstance].userInfo.id;
    }
//    self.dataList=[NSMutableArray array];
//    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [SystemAPI GetUserUploadedVideosListRequest:request success:^(GetUserUploadedVideosListResponse *response) {
        self.dataList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        self.dataList=[NSMutableArray array];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
         [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
    
}
/**
 *  加载最新的列表
 *
 */
-(void)loadNewListDataWithPageSize:(NSInteger) pageSize{
//    self.dataList=[NSMutableArray array];
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=sortField;
    request.categoryId=categoryId;
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%ld",(long)pageSize];
    }
    if (self.isHasMemberId) {
        request.memberId=[ShareValue shareInstance].userInfo.id;
    }
//     [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [SystemAPI GetUserUploadedVideosListRequest:request success:^(GetUserUploadedVideosListResponse *response) {
        self.dataList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
         [self.collectionView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        self.dataList=[NSMutableArray array];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
         [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
}
//加载女神视频
-(void)loadMeiliListDataWithPageSize:(NSInteger) pageSize{
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=@"meili";
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%ld",(long)pageSize];
    }
    request.categoryId=@"1";
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [SystemAPI GetUserUploadedVideosListRequest:request success:^(GetUserUploadedVideosListResponse *response) {
        self.dataList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.collectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
}
-(void)loadData{
    if ([self.viewCountBtn isSelected]) {
        [self loadMostViewedDataWithPageSize:self.pageSize];
    }
    if ([self.createBtn isSelected]) {
        [self loadNewListDataWithPageSize:self.pageSize];
    }
}
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSDictionary * dic =[self.categoryList objectAtIndex:sender.selectedSegmentIndex];
    categoryId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    NSInteger isVip =[[dic objectForKey:@"isVip"] integerValue];
    NSInteger type=[[ShareValue shareInstance].userInfo.type integerValue];
    //0
    if (sender.selectedSegmentIndex==0) {
        if (isVip==0) {
            self.isHasMemberId=NO;
            [self loadData];
            return;
        }
        if (isVip==1&&type==2) {
            self.isHasMemberId=YES;
            [self loadData];
        }else{
            [self showVIPChargeWarning];
        }
    }
    //1
    if (sender.selectedSegmentIndex==1) {
        if (isVip==0) {
            self.isHasMemberId=NO;
            [self loadData];
            return;
        }
        if (isVip==1&&type==2) {
            self.isHasMemberId=YES;
            [self loadData];
        }else{
            [self showVIPChargeWarning];
        }
    }
    //2
    if (sender.selectedSegmentIndex==2) {
        if (isVip==0) {
            self.isHasMemberId=NO;
            [self loadData];
            return;
        }
        if (isVip==1&&type==2) {
            self.isHasMemberId=YES;
            [self loadData];
        }else{
            [self showVIPChargeWarning];
        }
    }
    //3
    if (sender.selectedSegmentIndex==3) {
        if (isVip==0) {
            self.isHasMemberId=NO;
            [self loadData];
            return;
        }
        if (isVip==1&&type==2) {
            self.isHasMemberId=YES;
            [self loadData];
        }else{
            [self showVIPChargeWarning];
        }
    }
    
}
-(void)showVIPChargeWarning{
    self.segmentControl.selectedSegmentIndex=0;
    categoryId=@"1";
    [self loadData];
    UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还不是会员，无法查看该类的视频，请前往会员中心充值成为会员，即可查看！" delegate:self
cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=500;
    [al show];
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
#pragma collectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCollectionViewCellID forIndexPath:indexPath];
    NSDictionary * dic=[self.dataList objectAtIndex:indexPath.row];
    cell.lb_giftCount.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"itemValue"]];
    cell.lb_watchCount.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"viewCount"]];
    cell.lb_commentCount.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"commentCount"]];
    cell.name.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    cell.photoUrl=[dic objectForKey:@"avatar"];
    cell.videoUrl=[dic objectForKey:@"picUrl"];
    NSLog(@"videoId:%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"videoId"]]);
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary * dic=[self.dataList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"videoDetails" sender:dic];

}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"videoDetails"]) {
        VideoDetailsViewController * vc=segue.destinationViewController;
        vc.infoDic=sender;
    }
}
@end
