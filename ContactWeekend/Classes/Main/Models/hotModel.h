//
//  hotModel.h
//  ContactWeekend
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hotModel : NSObject
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *img;
@property(nonatomic, copy) NSString *counts;
@property(nonatomic, copy) NSString *hotId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *hotDescription;

- (instancetype)initWitnDictionary:(NSDictionary *)dict;
@end
