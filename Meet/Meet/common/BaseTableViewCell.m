//
//  BaseTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/2.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ServerConfig.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
