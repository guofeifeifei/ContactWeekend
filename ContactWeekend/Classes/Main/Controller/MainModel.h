//
//  MainModel.h
//  ContactWeekend
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    RecommendTypeActivity = 1, //推荐活动
    RecommendTypeTheme   //推荐专题
    
    
}RecommendType;


@interface MainModel : NSObject
@property(nonatomic, copy) NSString *image_big;//首页大图
@property(nonatomic, copy) NSString *title;//标题
@property(nonatomic, copy) NSString *price;//价格
@property(nonatomic, assign) CGFloat lat;//经度
@property(nonatomic, assign) CGFloat lng;//纬度
@property(nonatomic, copy) NSString *address;//地点

@property(nonatomic, copy) NSString *counts; //
@property(nonatomic, copy) NSString *startTime;//开始时间
@property(nonatomic, copy) NSString *endTime;//结束时间
@property(nonatomic, copy) NSString *activityId;//活动ID
@property(nonatomic, copy) NSString *type;

@property(nonatomic, copy) NSString *activityDescription;
- (instancetype)initWithDiction:(NSDictionary *)dict;

@end
