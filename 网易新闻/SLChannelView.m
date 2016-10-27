//
//  SLChannelView.m
//  网易新闻
//
//  Created by shengli on 2016/10/26.
//  Copyright © 2016年 shenglishengli. All rights reserved.
//

#import "SLChannelView.h"
#import "SLChannel.h"
#import "CZAdditions.h"

@interface SLChannelView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end

@implementation SLChannelView

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    CGFloat offsetX = 20;
    
    for (SLChannel *channel in dataArray) {
        
        UILabel *label = [UILabel cz_labelWithText:channel.tname fontSize:18 color:[UIColor blackColor]];
        [label sizeToFit];
        label.font = [UIFont systemFontOfSize:14];
        CGRect frame = label.frame;
        frame.origin.x = offsetX;
        frame.size.height = 35;
        label.frame = frame;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)];
        [label addGestureRecognizer:tap];
        [self.scrollView addSubview:label];
        
        offsetX = offsetX + label.frame.size.width + 10;
    }
    
    self.scrollView.contentSize = CGSizeMake(offsetX, 35);
    [self setScale:1 forIndex:0];
}

- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    NSLog(@"哈哈");
    
    NSInteger index = [self.scrollView.subviews indexOfObject:recognizer.view];
    
    if ([self.delegate respondsToSelector:@selector(channelView:clickWithIndex:)]) {
        [self.delegate channelView:self clickWithIndex:index];
    }
    
//    for (int i=0; i<self.scrollView.subviews.count; i++) {
//        UILabel *label = self.scrollView.subviews[i];
//        if (label == recognizer.view) {
//            [self setScale:1 forIndex:i];
//        } else {
//            [self setScale:0 forIndex:i];
//        }
//    }
    

        for (UILabel *label in self.scrollView.subviews) {
            if (label == recognizer.view) {
                [self setScale:1 forIndex:[self.scrollView.subviews indexOfObject:recognizer.view]];
            } else {
                [self setScale:0 forIndex:[self.scrollView.subviews indexOfObject:label]];
            }
        }


    [self scrollToCenter:recognizer.view];
}

- (void)setScale:(CGFloat)scale forIndex:(NSInteger)index {
    
    UILabel *label = self.scrollView.subviews[index];
    
    label.textColor = [UIColor colorWithRed:scale green:0 blue:0 alpha:1];
    
    CGFloat fontSize = 14 + (18 - 14) * scale;
//    [UIView animateWithDuration:0.25 animations:^{
        label.transform = CGAffineTransformMakeScale(fontSize / 14, fontSize / 14);
//    }];

    [self scrollToCenter:label];
}

- (void)scrollToCenter:(UIView *)view {
    CGFloat offsetX = view.center.x - self.scrollView.frame.size.width * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
//    if (offsetX > 0) {
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
//    }
}


@end
