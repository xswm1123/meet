//
//  VideoCollectionViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/7/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoScreen;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * videoUrl;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lb_giftIcon;

@property (weak, nonatomic) IBOutlet UILabel *lb_giftCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_commentIcon;
@property (weak, nonatomic) IBOutlet UILabel *lb_commentCount;
@property (weak, nonatomic) IBOutlet UILabel *lb_watchIcon;
@property (weak, nonatomic) IBOutlet UILabel *lb_watchCount;
@end
