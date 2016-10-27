//
//  SLChannelView.h
//  网易新闻
//
//  Created by shengli on 2016/10/26.
//  Copyright © 2016年 shenglishengli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLChannelView;

@protocol SLChannelViewDelegate <NSObject>

- (void)channelView:(SLChannelView *)view clickWithIndex:(NSInteger)index;

@end

@interface SLChannelView : UIView

@property (nonatomic) NSArray *dataArray;

@property (nonatomic, weak) id <SLChannelViewDelegate> delegate;

- (void)setScale:(CGFloat)scale forIndex:(NSInteger)index;

@end
