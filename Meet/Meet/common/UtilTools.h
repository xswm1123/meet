//
//  UtilTools.h
//  MyFramework
//
//  Created by Anita Lee on 15/6/30.
//  Copyright (c) 2015年 Anita Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  通用工具类
 */
@interface UtilTools : NSObject
/**
 *  通过十六进制返回颜色
 *
 *  @param hexString
 *
 *  @return UIColor
 */
+(UIColor *)colorWithHexString: (NSString *) hexString;
/**
 * 判断字符字面量是否是整数
 **/
+(BOOL)isInteger:(NSString *)string;

/**
 * 判断字符字面量是否是FLOAT
 **/
+(BOOL)isFloat:(NSString *)string;

/**
 *将日期格式化成对应的字符串
 */
+(NSString *)getStringByDate:(NSDate *)date formatString:(NSString *)fs;

/**
 * 返回手机屏幕大小
 */
+(CGRect)returnWindowSize;

/**
 * 截屏代码
 */
+(UIImage*)screenshot;

/**
 * 压缩图片
 */
+(UIImage*)changeImg:(UIImage *)image max:(float)maxSize;
/**
 * 获取当前网络下的IP地址
 */
+(NSString *)getIPAddress:(BOOL)preferIPv4;
/**
 *  判断是否是URL
 */
+(BOOL)isUrl;
/**
 *  获取当前的VC
 */
+(UIViewController*)getCurrentVC;
@end
@interface ImageInfo : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSString *mimeType;
@property(nonatomic,assign) long long filesize;
@property(nonatomic,strong) NSData *fileData;
@property(nonatomic,strong) UIImage *image;

-(id)initWithImage:(UIImage *)image;
+(UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale;
@end