//
//  RankingTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/15.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_no;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property(nonatomic,strong) NSString * photoUrl;
@end
