//
//  MyCollectedStoresViewController.m
//  Meet
//
//  Created by Anita Lee on 15/9/8.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MyCollectedStoresViewController.h"
#import "StoresListTableViewCell.h"
#import "StoreDetailsViewController.h"
#define StoresListTableViewCellId @"StoresListTableViewCell"
@interface MyCollectedStoresViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * listData;
@end

@implementation MyCollectedStoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoresListTableViewCell" bundle:nil] forCellReuseIdentifier:StoresListTableViewCellId];
    self.tableView.backgroundColor=NAVI_COLOR;
    [self loadData];
}
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:ShareAppDelegate.window animated:YES];
    GetMyCollectedStoresRequest * request =[[GetMyCollectedStoresRequest alloc]init];
    request.pageSize=@"50";
    request.memberId=self.memberId;
    [SystemAPI GetMyCollectedStoresRequest:request success:^(GetMyCollectedStoresResponse *response) {
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
    StoresListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:StoresListTableViewCellId];
    if (!cell) {
        cell=[[StoresListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoresListTableViewCellId];
    }
    NSDictionary * dic =[self.listData objectAtIndex:indexPath.section];
    cell.distance.font=[UIFont fontWithName:iconFont size:18];
    cell.distance.text=@"\U0000e60f";
    cell.distance.textColor=[UIColor colorWithRed:90/255.0 green:172/255.0 blue:225/255.0 alpha:1.0];
    NSString * names=[NSString stringWithFormat:@"%@%@",@"\U0000e60f",[dic objectForKey:@"distance"]];
    NSMutableAttributedString* str=[[NSMutableAttributedString alloc]initWithString:names];
    [str addAttribute:NSForegroundColorAttributeName value:iconBlue range:NSMakeRange(0, cell.distance.text.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(cell.distance.text.length, str.length-cell.distance.text.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(cell.distance.text.length, str.length-cell.distance.text.length)];
    cell.distance.attributedText=str;
    
    cell.storeName.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    cell.cost.text=[NSString stringWithFormat:@"人均:￥%@",[dic objectForKey:@"price"]];
    cell.collectNumber.text=[NSString stringWithFormat:@"收藏：%@",[dic objectForKey:@"collectNum"]];
    cell.star=[NSString stringWithFormat:@"%@",[dic objectForKey:@"star"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
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
    NSDictionary * dic=[self.listData objectAtIndex:indexPath.section];
    
    [self performSegueWithIdentifier:@"storeDetails" sender:dic];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"storeDetails"]) {
        StoreDetailsViewController * vc=segue.destinationViewController;
        vc.infoDic=sender;
    }
}

@end
