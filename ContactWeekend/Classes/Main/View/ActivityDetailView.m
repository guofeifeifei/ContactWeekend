//
//  ActivityDetailView.m
//  ContactWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 郭飞飞. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PrefixHeader.pch"
@interface ActivityDetailView(){
    //保存上一个图片底部的高度
    CGFloat _previousImageBottom;
    CGFloat _lastLabelBottom;
}

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
    //_previousImageBottom = 500;
}


- (void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityTitle.text = dataDic[@"title"];
    //活动时间
    NSString *startTime = [HWTool getDateFromString:dataDic[@"new_start_date"]];
    NSString *endTime = [HWTool getDateFromString:dataDic[@"new_end_date"]];
    
    self.activityTimeLable.text = [NSString stringWithFormat:@"正在进行:%@-%@", startTime, endTime];
    
    //喜欢人数
    self.favouriteLable.text = [NSString stringWithFormat:@"%@喜欢的人数", dataDic[@"fav"]];
    //活动价格
    self.priceLable.text = dataDic[@"pricedesc"];
    //活动地点
    self.activityAddress.text = dataDic[@"address"];
    //活动手机号
    self.activityPhoneLable.text = dataDic[@"tel"];
    
    
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    
}
- (void)drawContentWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        //获取每一段活动信息的文本高度
        CGFloat height = [HWTool getTextHeightWithBigest:dic[@"description"] bigerSize:CGSizeMake(kWidth, 1000) textFont:15.0];
        //CGFloat height = [HWTool getTextHeightWithText:dic[@"description"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:15.0];
        CGFloat y;
        if (_previousImageBottom > 500) {
            //当第一个活动详情显示，label先从保留的图片底部的坐标开始
            y = 500 + _previousImageBottom - 500;
        }else{
            //当第二个开始时，要加上上面控件的高度
            y = 500 + _previousImageBottom;
        }
        NSString *title = dic[@"title"];
        //如果标题存在,标题高度应该是上次图片的高度的底部高度
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, y, kWidth- 10, height)];
        label.text = dic[@"description"];
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 0;
        [self.mainScrollView addSubview:label];
        //保留最后一个label的高度，+64是下边tableBar的高度
        _lastLabelBottom = label.bottom + 10 + 64;
        NSArray *urlArray = dic[@"urls"];
        //当某一段落没有图片的时候，上次图片的高度用上次label的高度+10
        if (urlArray == nil) {
            _previousImageBottom = label.bottom + 10;
        }else{
            CGFloat lastImgbottom = 0.0;
            for (NSDictionary *urlDic in urlArray) {
                CGFloat imagY;
                if (urlArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) {  //有title的算上title的30像素
                            imagY = _previousImageBottom + label.height + 30 + 5;
                        } else{
                            imagY = _previousImageBottom + label.height + 5;
                        }
                    } else {
                        imagY = lastImgbottom + 10;
                        
                    }
                } else{
                    //单张图片
                    imagY = label.bottom;
                }
                CGFloat width = [urlDic[@"width"] integerValue];
                CGFloat imageHeight = [urlDic[@"height"] integerValue];
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, imagY, kWidth - 10, (kWidth - 10) / width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每一次都保留图片底部的高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
                
            }
        }
    }
     self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLabelBottom );
}






/*
- (void)drawContentWithArray:(NSArray *)contentArray{
    for (NSDictionary *dic in contentArray) {
        //如果高度没有超过500，也就是说时家在第一个Lable，那么y就减去500
        
        CGFloat y;
        if (_previousImageBottom > 500) {
            y = 500 + _previousImageBottom - 500;
        }else{
            y = 500 + _previousImageBottom;
        }
        
        
        
        
        //如果标题存在
        
        
        NSString *title = dic[@"title"];
        if (title !=nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候，高度的坐标应该再加30，也就是标题的高度。
            y += 30;
        }        //每一段活动信息
        CGFloat height = [HWTool getTextHeightWithBigest:dic[@"description"] bigerSize:CGSizeMake(kWidth, 1000) textFont:15.0];
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10,  y, kWidth - 20, height)];
        lable.text = dic[@"description"];
        lable.font = [UIFont systemFontOfSize:15.0];
        lable.numberOfLines = 0;
        [self.mainScrollView addSubview:lable];
        
        NSArray *urlsArray = dic[@"urls"];
        if (urlsArray == nil) {//如果某一段落没有图片时，上次图片的高度用上次Lable的地步高度
            _previousImageBottom = lable.bottom + 10;
        }else{
            
     CGFloat lastImgbottom = 0.0;
            
            for (NSDictionary *urlDic in urlsArray) {
                      CGFloat imagY;
                if (urlsArray.count > 1) {
                    //图片不止一张的情况
                    if (lastImgbottom == 0.0) {
                        if (title != nil) {  //有title的算上title的30像素
                            imagY = _previousImageBottom + lable.height + 30 + 5;
                        } else{
                            imagY = _previousImageBottom + lable.height + 5;
                        }
                    } else {
                        imagY = lastImgbottom + 10;
                        
                    }
                } else{
                    //单张图片
                    imagY = lable.bottom;
                }                CGFloat width = [urlDic[@"width"]integerValue];
                CGFloat imageHeight = [urlDic[@"height"]integerValue];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, lable.bottom, kWidth - 20, (kWidth - 20)/width * imageHeight)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlDic[@"url"]] placeholderImage:nil];
                [self.mainScrollView addSubview:imageView];
                //每次都保留最新的图片底部高度
                //每一次都保留图片底部的高度
                _previousImageBottom = imageView.bottom + 5;
                if (urlsArray.count > 1) {
                    lastImgbottom = imageView.bottom;
                }
            }
            
        }
        
    }
    
    self.mainScrollView.contentSize = CGSizeMake(kWidth, _previousImageBottom + 50);

}

*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
