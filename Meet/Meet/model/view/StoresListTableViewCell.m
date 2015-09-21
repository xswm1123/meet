//
//  StoresListTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/7/28.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoresListTableViewCell.h"
#import "ServerConfig.h"
#import "UIImageView+WebCache.h"

@implementation StoresListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setStar:(NSString *)star{
    _star=star;
    int index=[star intValue];
    for (int i=0; i<index; i++) {
        UIImageView * im=self.stars[i];
        im.image=[UIImage imageNamed:@"yellowStar"];
    }
    for (int i=index; i<self.stars.count; i++) {
        UIImageView * im=self.stars[i];
        im.image=[UIImage imageNamed:@"grayStar"];
    }
    
}
-(void)setPhotoUrl:(NSString *)photoUrl{
    _photoUrl=photoUrl;
    [self.storeImage sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"placehloder.png"]];
}
@end
