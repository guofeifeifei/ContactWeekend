//
//  ActivityDetailView.h
//  ContactWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView

@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property(nonatomic, weak) NSDictionary *dataDic;
@end
