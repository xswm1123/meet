//
//  HomeStoresTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeStoresTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIView *imagesBg;
@property (nonatomic,strong) NSArray * list;
@end
