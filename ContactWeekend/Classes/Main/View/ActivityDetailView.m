//
//  ActivityDetailView.m
//  ContactWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityDetailView()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *favouriteLable;

@property (weak, nonatomic) IBOutlet UILabel *priceLable;


@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *activityAddress;
@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLable;


@end

@implementation ActivityDetailView

- (void)awakeFromNib{
    
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 1000);

}


- (void)setDataDic:(NSDictionary *)dataDic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    NSLog(@"%@", self.headImageView);
    self.activityTitle.text = dataDic[@"title"];
    self.favouriteLable.text = [NSString stringWithFormat:@"%@喜欢的人数", dataDic[@"fav"]];
    self.priceLable.text = dataDic[@"pricedesc"];
    self.activityAddress.text = dataDic[@"address"];
    self.activityPhoneLable.text = dataDic[@"tel"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
