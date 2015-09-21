//
//  VideoCommnetsListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VideoCommnetsListTableViewCell.h"
#import "ServerConfig.h"
#import "UIImageView+WebCache.h"

@implementation VideoCommnetsListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.photoIV.layer.cornerRadius=5;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showHomePage:)];
    [self.photoIV addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
}
- (void)showHomePage:(id)sender {
    [self.delegate showHomePageWithCell:self];
}
@end
