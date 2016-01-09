
//
//  hotModel.m
//  ContactWeekend
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "hotModel.h"

@implementation hotModel
- (instancetype)initWitnDictionary:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.img = dict[@"img"];
        self.title = dict[@"title"];
        self.hotId = dict[@"id"];
        self.hotDescription = dict[@"description"];
        self.counts = dict[@"counts"];
        
        
    }
    return self;
    
}


@end
