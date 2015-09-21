//
//  VideoCollectionViewLayout.m
//  Meet
//
//  Created by Anita Lee on 15/7/27.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import "VideoCollectionViewLayout.h"
#import "ServerConfig.h"

@implementation VideoCollectionViewLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initiate];
    }
    return self;
}
//storyboard创建对象时调用的方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initiate];
    }
    return self;
}

- (void)initiate
{
    self.itemSize = CGSizeMake(DEVCE_WITH/2-9, (DEVCE_WITH/2-9)*5/3);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(10.0, 6.0, 10.0, 6.0);
    self.minimumLineSpacing = 8;
    self.minimumInteritemSpacing=2;
}

@end
