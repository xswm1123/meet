//
//  ConatctTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConatctTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_sign;
@property (strong,nonatomic) NSString * photoUrl;
@end
