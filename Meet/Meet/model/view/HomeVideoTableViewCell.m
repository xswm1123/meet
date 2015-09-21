//
//  HomeVideoTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "HomeVideoTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation HomeVideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.screenShot sd_setImageWithURL:[NSURL URLWithString:photoUrl]];
}
@end
