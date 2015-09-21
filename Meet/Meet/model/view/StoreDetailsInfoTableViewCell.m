//
//  StoreDetailsInfoTableViewCell.m
//  Meet
//
//  Created by Anita Lee on 15/8/9.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "StoreDetailsInfoTableViewCell.h"
#import "ServerConfig.h"

@implementation StoreDetailsInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor=cellColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
