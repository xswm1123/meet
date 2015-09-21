//
//  ExchangeCityViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ExchangeCityViewController.h"

@interface ExchangeCityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * areaList;
@property (nonatomic,strong) NSMutableArray * firstLetters;
@property (weak, nonatomic) IBOutlet UIButton *currentCityBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary * areaDic;
@end

@implementation ExchangeCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=NAVI_COLOR;
     self.tableView.separatorColor = NAVI_COLOR;
    [self.currentCityBtn setBackgroundColor:cellColor];
    [self.currentCityBtn setTitle:[ShareValue shareInstance].city forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadAreaData];
}
-(void)loadAreaData{
    self.areaDic=[NSMutableDictionary dictionary];
    self.firstLetters=nil;
    self.firstLetters=[NSMutableArray array];
    self.areaList=nil;
    self.areaList=[NSMutableArray array];
   
        NSArray * areaBean=[ShareValue shareInstance].allCitys;
        for (NSDictionary * dic in areaBean) {
            [self.firstLetters addObject:[dic objectForKey:@"letter"]];
            NSDictionary* areaDic=[NSDictionary dictionaryWithObject:[dic objectForKey:@"list"] forKey:[dic objectForKey:@"letter"]];
            [self.areaDic setObject:[dic objectForKey:@"list"] forKey:[dic objectForKey:@"letter"]];
            
            [self.areaList addObject:areaDic];
        }
        [self handleListData];
        [self.tableView reloadData];
}
-(void)handleListData{
    //准备排序sort
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    self.firstLetters=(NSMutableArray*)[self.firstLetters sortedArrayUsingComparator:sort];
}
#pragma tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.firstLetters.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* arr=[self.areaDic objectForKey:[self.firstLetters objectAtIndex:section]];
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor=cellColor;
    cell.textLabel.textColor=[UIColor whiteColor];
    NSArray* arr=[self.areaDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section]];
    NSDictionary * dic=[arr objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"name"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [self.firstLetters objectAtIndex:section];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVCE_WITH, 20)];
    view.backgroundColor=NAVI_COLOR;
    UILabel * lb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, DEVCE_WITH-15, 20)];
    lb.text= [self.firstLetters objectAtIndex:section];
    lb.textColor=[UIColor whiteColor];
    [view addSubview:lb];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* arr=[self.areaDic objectForKey:[self.firstLetters objectAtIndex:indexPath.section]];
    NSDictionary * dic=[arr objectAtIndex:indexPath.row];
    [self.delegate getCityName: dic];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectCity:(id)sender {
    NSDictionary * dic=@{@"name":[ShareValue shareInstance].city};
    [self.delegate getCityName: dic];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
