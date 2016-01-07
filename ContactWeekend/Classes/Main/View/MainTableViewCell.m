//
//  MainTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "MainTableViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface MainTableViewCell()

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
    [self.activityDistanceBtn setTitle:mainModel.address forState:UIControlStateNormal];
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
