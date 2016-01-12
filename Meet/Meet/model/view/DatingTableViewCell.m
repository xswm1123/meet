//
//  DatingTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/11/25.
//  Copyright © 2015年 Anita Lee. All rights reserved.
//

#import "DatingTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation DatingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
