//
//  DiscoveryTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/7/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "DiscoveryTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation DiscoveryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
    for (UIImageView * imv in self.images) {
        imv.layer.cornerRadius=3;
    }
    self.line.backgroundColor=NAVI_COLOR;
    self.lb_icon.font=[UIFont fontWithName:iconFont size:26];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls=imageUrls;
    for (int i=0; i<self.images.count; i++) {
        UIImageView * imageView= self.images[2-i];
        NSString *imageUrl=imageUrls[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolder];
    }
}
@end
