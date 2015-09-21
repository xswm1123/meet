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

#define VideoCollectionViewCellID @"VideoCollectionViewCell"

@interface HomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray * dataList;
@property (nonatomic,assign) NSInteger pageSize;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.pageSize=10;
    [self loadMostViewedDataWithPageSize:10];
   }
-(void)initView{
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
     *  加头部刷新和脚部加载
     */
    self.collectionView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.segmentControl.selectedSegmentIndex==0) {
            [self loadMostViewedDataWithPageSize:self.pageSize];
        }
        if (self.segmentControl.selectedSegmentIndex==1) {
            [self loadNewListDataWithPageSize:self.pageSize];
        }
        if (self.segmentControl.selectedSegmentIndex==2) {
            [self loadMeiliListDataWithPageSize:self.pageSize];
        }
    }];
    self.collectionView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageSize+=10;
        if (self.segmentControl.selectedSegmentIndex==0) {
            [self loadMostViewedDataWithPageSize:self.pageSize];
        }
        if (self.segmentControl.selectedSegmentIndex==1) {
            [self loadNewListDataWithPageSize:self.pageSize];
        }
        if (self.segmentControl.selectedSegmentIndex==2) {
            [self loadMeiliListDataWithPageSize:self.pageSize];
        }

    }];
    
}
/**
 *  加载热门的列表
 *
 */
-(void)loadMostViewedDataWithPageSize:(NSInteger) pageSize{
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=@"viewCount";
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%d",pageSize];
    }
    
//    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
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
/**
 *  加载最新的列表
 *
 */
-(void)loadNewListDataWithPageSize:(NSInteger) pageSize{
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=@"created";
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%d",pageSize];
    }
     [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    [SystemAPI GetUserUploadedVideosListRequest:request success:^(GetUserUploadedVideosListResponse *response) {
        self.dataList=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.collectionView reloadData];
//        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
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
//加载女神视频
-(void)loadMeiliListDataWithPageSize:(NSInteger) pageSize{
    GetUserUploadedVideosListRequest * request=[[GetUserUploadedVideosListRequest alloc]init];
    request.sortField=@"meili";
    if (self.pageSize!=0) {
        request.pageSize=[NSString stringWithFormat:@"%d",pageSize];
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

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        [self loadMostViewedDataWithPageSize:self.pageSize];
    }
    if (sender.selectedSegmentIndex==1) {
        [self loadNewListDataWithPageSize:self.pageSize];
    }
    if (sender.selectedSegmentIndex==2) {
        [self loadMeiliListDataWithPageSize:self.pageSize];
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
