//
//  SelectCityCollectionViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "SelectCityCollectionViewCell.h"

@implementation SelectCityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        self.lable.backgroundColor = [UIColor whiteColor];
        self.lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.lable];

        
    }
    return self;
}
@end
