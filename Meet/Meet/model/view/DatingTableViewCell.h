//
//  DatingTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/11/25.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_desc;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * name;
@end
