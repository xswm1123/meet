//
//  GiftListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UIImageView *VIPImv;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (weak, nonatomic) IBOutlet UILabel *lb_goldCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalDistance;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * name;
@end
