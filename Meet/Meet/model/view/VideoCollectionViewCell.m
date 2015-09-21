//
//  VideoCollectionViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/7/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VideoCollectionViewCell.h"
#import "ServerConfig.h"
#import "UIImageView+WebCache.h"

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius=5;
    self.backgroundColor=[UIColor colorWithRed:51/225.0 green:56/255.0 blue:77/255.0 alpha:1.0];
    self.photo.layer.cornerRadius=20;
    self.photo.layer.borderColor=[UIColor whiteColor].CGColor;
    self.photo.layer.borderWidth=1;
    self.lb_giftIcon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_giftIcon.text=@"\U0000e618";
    self.lb_giftIcon.textColor=[UIColor colorWithRed:219/255.0 green:40/255.0 blue:163/255.0 alpha:1.0];
    
    self.lb_commentIcon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_commentIcon.text=@"\U0000e61a";
    self.lb_commentIcon.textColor=[UIColor colorWithRed:38/255.0 green:203/255.0 blue:114/255.0 alpha:1.0];

    
    self.lb_watchIcon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_watchIcon.text=@"\U0000e609";
    self.lb_watchIcon.textColor=[UIColor colorWithRed:243/255.0 green:197/255.0 blue:45/255.0 alpha:1.0];
    self.videoScreen.image=[UIImage imageNamed:@"1.png"];
    self.photo.image=[UIImage imageNamed:@"1.png"];
    //适配字体大小
    self.lb_commentCount.adjustsFontSizeToFitWidth=YES;
    self.lb_giftCount.adjustsFontSizeToFitWidth=YES;
    self.lb_watchCount.adjustsFontSizeToFitWidth=YES;
    self.name.adjustsFontSizeToFitWidth=YES;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.photo sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
}
-(void)setVideoUrl:(NSString *)videoUrl{
    _videoUrl=videoUrl;
    [self.videoScreen sd_setImageWithURL:[NSURL URLWithString:videoUrl] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
}
@end
