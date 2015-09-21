//
//  LanuchAdsManager.h
//  Meet
//
//  Created by Anita Lee on 15/9/20.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LanuchAdsManager : NSObject
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic, assign) BOOL imgLoaded;

@property (nonatomic, strong) NSMutableData *imgData;
@property (nonatomic, strong) NSURLConnection *conn;

@property (nonatomic, strong) NSMutableDictionary *detailParam;
@property (nonatomic,assign) NSInteger  count;
@property (nonatomic,strong) UILabel *label;

-(void)showAdAtPath:(NSString *)path onView:(UIView *)container timeInterval:(NSTimeInterval)interval detailParameters:(NSDictionary *)param;
+(instancetype)defaultMonitor;
@end
