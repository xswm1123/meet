//
//  ConatctTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/31.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "ConatctTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation ConatctTableViewCell

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
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
@end
