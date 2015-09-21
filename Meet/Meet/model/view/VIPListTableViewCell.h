//
//  VIPListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/5.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;

@end
