//
//  jingModel.m
//  ContactWeekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "jingModel.h"

@implementation jingModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.age = dic[@"age"];
        self.counts = dic[@"counts"];
        self.price = dic[@"price"];
        self.activityId =dic[@"id"];
        self.type = dic[@"type"];
        self.address = dic[@"address"];
    }
    return self;
    
    
    
}
@end
