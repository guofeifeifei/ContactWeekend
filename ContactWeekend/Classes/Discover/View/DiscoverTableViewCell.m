//
//  DiscoverTableViewCell.m
//  ContactWeekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoverTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *LikeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *LikeImageView;


@end
@implementation DiscoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 80);
}
- (void)setModel:(DiscoverModel *)model{
    [self.LikeImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.LikeTitle.text = model.title;
    
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
