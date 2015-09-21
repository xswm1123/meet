//
//  DiscoveryTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/7/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *arrow;
@property (nonatomic,strong) NSArray * imageUrls;
@end
