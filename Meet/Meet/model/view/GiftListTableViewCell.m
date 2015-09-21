//
//  GiftListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/3.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "GiftListTableViewCell.h"
#import "ServerConfig.h"
#import "UIImageView+WebCache.h"

@implementation GiftListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    self.photoIV.layer.cornerRadius=5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
     [self.photoIV sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
}
-(void)setName:(NSString *)name{
    _name=name;
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
}
@end
