//
//  EmojDownloadViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "EmojDownloadViewController.h"
#import "EmojDownloadTableViewCell.h"


#define EmojID @"EmojDownloadTableViewCell"

@interface EmojDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,EmojDownloadDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EmojDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmojDownloadTableViewCell" bundle:nil] forCellReuseIdentifier:EmojID];
    self.tableView.backgroundColor=NAVI_COLOR;
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EmojDownloadTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:EmojID];
    if (!cell) {
        cell=[[EmojDownloadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmojID];
    }
    cell.delegate=self;
    if (indexPath.section==0) {
        cell.lb_name.text=@"QQ表情";
        cell.photoIV.image=[UIImage imageNamed:@"qq.jpg"];
        cell.downLoadUrl=@"http://xy.immet.cm/emoti_png/qq.zip";
        if ([ShareValue shareInstance].isDownloadQQ) {
            cell.downBtn.enabled=NO;
            [cell.downBtn setTitle:@"已下载" forState:UIControlStateDisabled];
        }else{
            cell.downBtn.enabled=YES;
        }
    }
    if (indexPath.section==1) {
        cell.lb_name.text=@"MOMO表情";
        cell.photoIV.image=[UIImage imageNamed:@"momo.png"];
        cell.downLoadUrl=@"http://xy.immet.cm/emoti_png/mo.zip";
        if ([ShareValue shareInstance].isDownloadMOMO) {
            cell.downBtn.enabled=NO;
            [cell.downBtn setTitle:@"已下载" forState:UIControlStateDisabled];
        }else{
            cell.downBtn.enabled=YES;
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
-(void)DownloadFilesWithCell:(EmojDownloadTableViewCell *)cell{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * url=cell.downLoadUrl;
    [X_BaseAPI downLoadFilesWithURL:url Success:^(X_BaseHttpResponse *response,NSURL *filePath) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showSuccess:@"下载成功！" toView:self.view];
        if ([cell.lb_name.text isEqualToString:@"QQ表情"]) {
            [ShareValue shareInstance].isDownloadQQ=YES;
        }
        if ([cell.lb_name.text isEqualToString:@"MOMO表情"]) {
            [ShareValue shareInstance].isDownloadMOMO=YES;
        }
        NSLog(@"filePath:%@",filePath.relativePath);
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString * destination =[cachPath stringByAppendingString:@"/Emoj"];
        [Main unzipFileAtPath:filePath.relativePath toDestination:destination];
        [self.tableView reloadData];
    } fail:^(BOOL NotReachable, NSString *description) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:@"下载失败！" toView:self.view];
        if ([cell.lb_name.text isEqualToString:@"QQ表情"]) {
            [ShareValue shareInstance].isDownloadQQ=NO;
        }
        if ([cell.lb_name.text isEqualToString:@"MOMO表情"]) {
            [ShareValue shareInstance].isDownloadMOMO=NO;
        }
        [self.tableView reloadData];
    }];
}

@end
