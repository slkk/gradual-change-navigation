//
//  ViewController.m
//  网易新闻
//
//  Created by shengli on 2016/10/25.
//  Copyright © 2016年 shenglishengli. All rights reserved.
//

#import "ViewController.h"
#import "SLChannelView.h"
#import "SLChannel.h"
#import <YYModel.h>
#import "CZAdditions.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SLChannelViewDelegate>

@property (weak, nonatomic) IBOutlet SLChannelView *channelView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray <SLChannel *> *dataArray;

@end

@implementation ViewController

- (NSArray<SLChannel *> *)dataArray {
    if (!_dataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _dataArray = [NSArray yy_modelArrayWithClass:[SLChannel class] json:data];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.channelView.dataArray = self.dataArray;
    self.channelView.delegate = self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.collectionView.frame.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cz_randomColor];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    SLChannel *channel = self.dataArray[indexPath.item];
    label.text = channel.tname;
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"滚动的距离>>>>>>>>%f",scrollView.contentOffset.x);
    CGFloat ratio = scrollView.contentOffset.x / scrollView.frame.size.width;
    NSInteger index = ratio / 1;
    CGFloat scale = ratio - index;
    
    NSLog(@"页数>%ld,比例>%f",index,scale);
    
    if (index + 1 < self.dataArray.count) {
        [self.channelView setScale:scale forIndex:index + 1];
    }
    [self.channelView setScale:1 - scale forIndex:index];
}

#pragma mark SLChannelViewDelegate
- (void)channelView:(SLChannelView *)view clickWithIndex:(NSInteger)index {
    self.collectionView.delegate = nil;
    // 注意：此处的动画不能要，如果有动画，会走很多次scrollViewDidScroll，导致有BUG
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:0 animated:NO];
    self.collectionView.delegate = self;
}



@end
