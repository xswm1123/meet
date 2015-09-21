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
    }
    if (indexPath.section==1) {
        cell.lb_name.text=@"MOMO表情";
        cell.photoIV.image=[UIImage imageNamed:@"momo.png"];
        cell.downLoadUrl=@"http://xy.immet.cm/emoti_png/mo.zip";
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
    NSString * url=cell.downLoadUrl;
    [X_BaseAPI downLoadFilesWithURL:url Success:^(X_BaseHttpResponse *response) {
        
    } fail:^(BOOL NotReachable, NSString *description) {
        
    }];
}

@end
