//
//  NearByListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/4.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "NearByListTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation NearByListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.lb_icon.font=[UIFont fontWithName:iconFont size:18];
    self.lb_icon.text=@"\U0000e60f";
    self.lb_icon.textColor=iconBlue;
    self.lb_sign.adjustsFontSizeToFitWidth=YES;
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
