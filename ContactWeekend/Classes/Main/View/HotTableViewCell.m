//
//  HotTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/9.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end
@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 200);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotModel:(hotModel *)hotModel{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.img] placeholderImage:nil];
    
    
    
}
@end
