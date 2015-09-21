//
//  NearByListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/4.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_distance;
@property (weak, nonatomic) IBOutlet UILabel *lb_sign;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * photoUrl;
@end
