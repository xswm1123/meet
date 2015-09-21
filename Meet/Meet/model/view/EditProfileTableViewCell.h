//
//  EditProfileTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_option;
@property (weak, nonatomic) IBOutlet UITextField *tf_desc;
@property (weak, nonatomic) IBOutlet UILabel *lb_value;

@end
