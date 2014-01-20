//
//  ZYCWaterFallGridController.h
//  ZYCWaterfallGrid
//
//  Created by zhangyuchen on 14-1-17.
//  Copyright (c) 2014年 zhangyuchen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ZYCArrangeDirection)
{
    ZYCArrangeDirectionDepth = 1,
    ZYCArrangeDirectionBreadth = 2,
};

@class ZYCWaterfallGridView;


@protocol ZYCWaterfallGridViewDelegate <NSObject>

- (CGSize)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView sizeForItemAtIndexPath:(NSIndexPath *)path;

- (UIView *)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView ViewForItemAtIndexPath:(NSIndexPath *)path;

@end

@protocol ZYCWaterfallGridViewDataSource <NSObject>

- (NSInteger)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView numberOfItemsInSection:(NSInteger)section;

- (NSInteger)numberOfSectionsInWaterfallGridView:(ZYCWaterfallGridView *)waterfallGridView;


@end



@interface ZYCWaterFallGridController : UIViewController <UIScrollViewDelegate>

- (instancetype)initWithArrangeDirection:(ZYCArrangeDirection) arrangeDirection;

@property (nonatomic, assign) CGFloat itemPadding;
@property (nonatomic, assign, readonly) ZYCArrangeDirection arrangeDirection;


@property (nonatomic, strong) ZYCWaterfallGridView *waterfallGridView;

@property (nonatomic, weak) id<ZYCWaterfallGridViewDelegate> delegate;

@property (nonatomic, weak) id<ZYCWaterfallGridViewDataSource> dataSource;

@end
