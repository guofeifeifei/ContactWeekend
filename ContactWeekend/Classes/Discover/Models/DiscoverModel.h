//
//  DiscoverModel.h
//  ContactWeekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
@property(nonatomic, copy) NSString *activityId;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *title;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
