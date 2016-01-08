//
//  HWTool.m
//  ContactWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "HWTool.h"

@implementation HWTool
+ (NSString *)getDateFromString:(NSString *)timestamp{
    
    NSTimeInterval timeInterval = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *timeStr = [dateFormatter stringFromDate:date];
    return timeStr;
    
}

+ (CGFloat)getTextHeightWithBigest:(NSString *)text bigerSize:(CGSize)bigSize textFont:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
    
}

+ (NSDate *)getSystemNowDate{
    //刷新完成时间
         //创建一个NSDataFormatter显示刷新时间
        NSDateFormatter *df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [df stringFromDate:[NSDate date]];
        NSDate *date = [df dateFromString:dateStr];
        return date;
   
}

@end
