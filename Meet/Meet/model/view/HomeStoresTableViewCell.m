//
//  HomeStoresTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/25.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "HomeStoresTableViewCell.h"
#import "ServerConfig.h"
#import "BaseViewController.h"

@implementation HomeStoresTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setList:(NSArray *)list{
    _list=list;
    CGFloat imageWidth=(self.imagesBg.frame.size.width-25)/4;
    for (int i=0; i<list.count; i++) {
        UIImageView * imv=[[UIImageView alloc]initWithFrame:CGRectMake(5+(imageWidth+5)*i, 40-imageWidth/2, imageWidth, imageWidth)];
        imv.layer.cornerRadius=5;
        imv.clipsToBounds=YES;
        [imv sd_setImageWithURL:[NSURL URLWithString:[list objectAtIndex:i]] placeholderImage:placeHolder];
        [self.imagesBg addSubview:imv];
    }
}
@end
