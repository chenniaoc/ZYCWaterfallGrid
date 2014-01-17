//
//  ZYCWaterFallGridController.h
//  ZYCWaterfallGrid
//
//  Created by zhangyuchen on 14-1-17.
//  Copyright (c) 2014年 zhangyuchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYCWaterfallGridView;


@protocol ZYCWaterfallGridViewDelegate <NSObject>

- (CGSize)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView sizeForItemAtIndexPath:(NSIndexPath *)path;

@end

@protocol ZYCWaterfallGridViewDataSource <NSObject>

- (NSInteger)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView numberOfItemsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInWaterfallGridView:(ZYCWaterfallGridView *)waterfallGridView;


@end



@interface ZYCWaterFallGridController : UIViewController <UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat itemPadding;


@property (nonatomic, strong) ZYCWaterfallGridView *waterfallGridView;

@property (nonatomic, weak) id<ZYCWaterfallGridViewDelegate> delegate;

@property (nonatomic, weak) id<ZYCWaterfallGridViewDataSource> dataSource;

@end
