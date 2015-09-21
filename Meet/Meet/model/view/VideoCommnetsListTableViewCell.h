//
//  VideoCommnetsListTableViewCell.h
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoCommnetsListTableViewCell;
@protocol VideoCommentsDelegate <NSObject>

-(void)showHomePageWithCell:(VideoCommnetsListTableViewCell*)cell;

@end

@interface VideoCommnetsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (nonatomic,strong) NSString * photoUrl;
@property (nonatomic,strong) NSString * memberId;
@property (nonatomic,weak) id<VideoCommentsDelegate> delegate;
@end
