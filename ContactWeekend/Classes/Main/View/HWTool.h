//
//  HWTool.h
//  ContactWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface HWTool : NSObject
#pragma mark ------时间转化相关的方法
+ (NSString *)getDateFromString:(NSString *)timestamp;
#pragma mark ------根据文字最大显示宽度和文字内容的返回文字高度
+ (CGFloat)getTextHeightWithBigest:(NSString *)text bigerSize:(CGSize)bigSize textFont:(CGFloat)font;


@end
