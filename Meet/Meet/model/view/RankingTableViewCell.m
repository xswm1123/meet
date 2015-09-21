//
//  RankingTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/15.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "RankingTableViewCell.h"
#import "BaseViewController.h"

@implementation RankingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.lb_no.textColor=iconYellow;
    self.backgroundColor=cellColor;
    self.photoIV.layer.cornerRadius=5;
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    if (photoUrl) {
        [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:placeHolder];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
