//
//  MainTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "MainTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainTableViewCell()<CLLocationManagerDelegate>

//活动图片
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (weak, nonatomic) IBOutlet UILabel *activityNameLable;
//活动价格
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
//活动距离
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceBtn;

@end
@implementation MainTableViewCell

- (void)setMainModel:(MainModel *)mainModel{
    
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:mainModel.image_big] placeholderImage:nil];//网上获取图片
    self.activityNameLable.text = mainModel.title;
    self.activityPriceLable.text = mainModel.price;
    
    //计算两个地点的距离
    double origLat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lat"] doubleValue];
    double orgLng = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lng"] doubleValue];
    CLLocation *origLoc = [[CLLocation alloc] initWithLatitude:origLat longitude:orgLng];
    CLLocation *disLoc = [[CLLocation alloc] initWithLatitude:mainModel.lat longitude:mainModel.lng];
    //计算两个地点的距离
    double distance = [origLoc distanceFromLocation:disLoc] / 1000;
    [self.activityDistanceBtn setTitle:[NSString stringWithFormat:@"%.2f",distance] forState:UIControlStateNormal];
    
    
    
    if ([mainModel.type intValue] == RecommendTypeActivity) {
        self.activityDistanceBtn.hidden = NO;
    }else{
        self.activityDistanceBtn.hidden = YES;
    }
}
- (void)awakeFromNib {
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
