//
//  JingXuanTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "JingXuanTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JingXuanTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@end


@implementation JingXuanTableViewCell

- (void)awakeFromNib {
    // Initialization code
     self.frame = CGRectMake(0, 0, kWidth, 120);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setJingModel:(jingModel *)jingModel{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:jingModel.image ] placeholderImage:nil];
    self.title.text = jingModel.title;
    self.ageLable.text = jingModel.age;
    self.priceLable.text = jingModel.price;
    [self.loveButton setTitle:[NSString stringWithFormat:@"%@", jingModel.counts] forState:UIControlStateNormal];
    self.addressLable.text = jingModel.address;
    
    
}
@end
