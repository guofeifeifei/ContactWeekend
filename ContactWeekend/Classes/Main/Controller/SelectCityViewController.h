//
//  SelectCityViewController.h
//  ContactWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeCityDelegate <NSObject>

- (void)getChangeCityName:(NSString *)cityName cityId:(NSString *)cityId;

@end
@interface SelectCityViewController : UIViewController
@property(nonatomic, assign) id<changeCityDelegate> delegate;
@end
