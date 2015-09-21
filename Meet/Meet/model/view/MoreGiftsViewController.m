//
//  MoreGiftsViewController.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "MoreGiftsViewController.h"
#import "GiftListTableViewCell.h"

#define GiftList @"GiftListTableViewCell"

@interface MoreGiftsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreGiftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"GiftListTableViewCell" bundle:nil] forCellReuseIdentifier:GiftList];
    self.tableView.backgroundColor=NAVI_COLOR;
}
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GiftListTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:GiftList];
    if (!cell) {
        cell=[[GiftListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GiftList];
    }
    NSDictionary * dic=[self.giftDats objectAtIndex:indexPath.row];
    cell.lb_date.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"created"]];
    cell.lb_desc.text=[NSString stringWithFormat:@"赠送“%@”%@个",[dic objectForKey:@"title"],[dic objectForKey:@"num"]];
    cell.lb_goldCount.text=[NSString stringWithFormat:@"%@金币",[dic objectForKey:@"gold"]];
    cell.photoUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"picUrl"]];
     cell.name=[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickname"]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.giftDats.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



@end
