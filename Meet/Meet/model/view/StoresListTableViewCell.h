//
//  StoresListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/7/28.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoresListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImage;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *iconName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *stars;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *collectNumber;
@property (nonatomic,strong) NSString * star;
@property (nonatomic,strong) NSString * photoUrl;
@end
