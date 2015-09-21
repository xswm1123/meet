//
//  MyVideosViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MyVideosViewController.h"
#import "MyVideosTableViewCell.h"

#define Video @"videoCell"

@interface MyVideosViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * listData;
@end

@implementation MyVideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyVideosTableViewCell" bundle:nil] forCellReuseIdentifier:Video];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self loadData];
  
}
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    GetMyVideosRequest * request =[[GetMyVideosRequest alloc]init];
    request.memberId=self.memberId;
    request.pageSize=@"50";
    [SystemAPI GetMyVideosRequest:request success:^(GetMyVideosResponse *response) {
        self.listData=[NSMutableArray arrayWithArray:(NSArray*)response.data];
        [self.tableView reloadData];
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:ShareAppDelegate.window animated:YES];
        [MBProgressHUD showError:desciption toView:ShareAppDelegate.window];
    }];
}

#pragma mark tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyVideosTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Video];
    if (!cell) {
        cell=[[MyVideosTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Video];
    }
    NSDictionary * dic =[self.listData objectAtIndex:indexPath.section];
    cell.infoDic=dic;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic =[self.listData objectAtIndex:indexPath.section];
    NSString *urlStr=[dic objectForKey:@"video"];
    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
        MPMoviePlayerViewController *movieViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        movieViewController.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self presentMoviePlayerViewControllerAnimated:movieViewController];
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    int srcId=self.memberId.intValue;
    int tarId =[ShareValue shareInstance].userInfo.id.intValue;
    if (srcId==tarId) {
        return YES;
    }else{
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"commitEditingStyle");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary * dic =[self.listData objectAtIndex:indexPath.section];
    DeleteMyVideoRequest * request =[[DeleteMyVideoRequest alloc]init];
    request.videoId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
    [SystemAPI DeleteMyVideoRequest:request success:^(DeleteMyVideoResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.listData removeObject:dic];
        [self.tableView reloadData];
        [MBProgressHUD showSuccess:response.message toView:self.view];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
@end
