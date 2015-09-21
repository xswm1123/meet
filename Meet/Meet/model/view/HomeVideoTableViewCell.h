//
//  HomeVideoTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIImageView *screenShot;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (nonatomic,strong) NSString * photoUrl;
@end
