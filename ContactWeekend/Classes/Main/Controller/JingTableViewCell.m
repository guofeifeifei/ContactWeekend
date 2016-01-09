//
//  JingTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "JingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface JingTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *avtivityTitle;



@property (weak, nonatomic) IBOutlet UILabel *activityPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistenceLable;

@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;


@end
@implementation JingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.frame = CGRectMake(0, 0, kWidth, 90);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark----Model
- (void)setJingModel:(jingModel *)jingModel{
  [self.headImageView sd_setImageWithURL:[NSURL URLWithString:jingModel.image] placeholderImage:nil];
    self.avtivityTitle.text = jingModel.title;
    self.ageLable.text = jingModel.age;
    self.activityPricesLabel.text = jingModel.price;
   self.activityDistenceLable.text = jingModel.address;
 [self.loveButton setTitle:[NSString stringWithFormat:@"%@", jingModel.counts]forState:UIControlStateNormal];
   
  
    
    
}


@end
