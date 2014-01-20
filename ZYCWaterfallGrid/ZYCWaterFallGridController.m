//
//  ZYCWaterFallGridController.m
//  ZYCWaterfallGrid
//
//  Created by zhangyuchen on 14-1-17.
//  Copyright (c) 2014年 zhangyuchen. All rights reserved.
//

#import "ZYCWaterFallGridController.h"
#import "ZYCWaterfallGridView.h"

@interface ZYCWaterFallGridController ()

@property (nonatomic, assign, readwrite) ZYCArrangeDirection arrangeDirection;

@end

@implementation ZYCWaterFallGridController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithArrangeDirection:(ZYCArrangeDirection) arrangeDirection
{
    self = [self init];
    if (self) {
        _arrangeDirection = arrangeDirection;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _itemPadding = 3;
    }
    return self;
}

- (void)loadView
{
    self.waterfallGridView = [[ZYCWaterfallGridView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = self.waterfallGridView;
    
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view.
    [self reloadItems];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}



- (void)reloadItems
{
    NSInteger numberOfSections = [self.dataSource numberOfSectionsInWaterfallGridView:self.waterfallGridView];
    if (!numberOfSections) {
        numberOfSections = 1;
    }
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat screenWidth = CGRectGetWidth(applicationFrame);
    float yH = 0 + _itemPadding;
    
    float totalContentHeght = 0;
    float minHeight = 0;
    BOOL isFirstLine = YES;
    int degbugCounter = 0;
    
    
    while (numberOfSections > 0) {
        
        NSInteger numberOfItems = [self.dataSource waterfallGridView:self.waterfallGridView numberOfItemsInSection:numberOfSections];
        
        if (!numberOfItems) {
            numberOfItems = 200;
        }
        
        float xH = 0 + _itemPadding;
        int previousColumnCount = 0;
        NSMutableArray *columnCountArray = [NSMutableArray array];
        NSMutableArray *columnCountTempArray = nil;
        NSMutableArray *columnCountTempArrayDepth = [NSMutableArray array];
        while (numberOfItems > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfItems inSection:numberOfSections];
            
            int randomHeight = arc4random() % 180 ;
            randomHeight = randomHeight > 150 ? randomHeight: randomHeight + 150;
            //randomHeight = 180;
            CGSize itemSize = [self.delegate waterfallGridView:self.waterfallGridView sizeForItemAtIndexPath:indexPath];
            //default value if itemSize was not set,yet.
            itemSize = itemSize.height == 0 && itemSize.width == 0?CGSizeMake(100,randomHeight):itemSize;
            
            //recaculate from zero if xH will out of screen
            if (xH + _itemPadding + itemSize.width >= screenWidth) {
                xH = 0 + _itemPadding;
                [columnCountTempArray removeAllObjects];
                columnCountTempArray = nil;
                columnCountTempArray = [NSMutableArray arrayWithArray:columnCountArray];//[columnCountArray copy];
                [columnCountArray removeAllObjects];
                previousColumnCount = 0;
                isFirstLine = NO;
            }
            
            
            float axisXOfItem = 0;
            float axisYOfItem = 0;
            
            
            if (self.arrangeDirection == ZYCArrangeDirectionBreadth) {
                axisXOfItem = xH;
                axisYOfItem = columnCountTempArray == nil ? _itemPadding:[[columnCountTempArray objectAtIndex:previousColumnCount] floatValue];
                
                yH = axisYOfItem + _itemPadding + itemSize.height;
                xH += _itemPadding + itemSize.width;
                
                [columnCountArray addObject:[NSNumber numberWithFloat:yH]];
                previousColumnCount++;
                
            } else if (self.arrangeDirection == ZYCArrangeDirectionDepth){
                
                if (isFirstLine) {
                    axisXOfItem = xH;
                    axisYOfItem = _itemPadding;

                    yH = axisYOfItem + _itemPadding + itemSize.height;
                    xH += _itemPadding + itemSize.width;
                    [columnCountTempArrayDepth addObject:[NSNumber numberWithFloat:yH]];
                } else {
                    int minHeightIndex = 0;
                    for (NSInteger i = 0; i < columnCountTempArrayDepth.count; i++) {
                        float tempHeight= [[columnCountTempArrayDepth objectAtIndex:i] floatValue];
                        if (minHeight == 0 || minHeight > tempHeight) {
                            minHeight = tempHeight;
                            minHeightIndex = i;
                        }
                    }
                    [columnCountTempArrayDepth replaceObjectAtIndex:minHeightIndex withObject:[NSNumber numberWithFloat:minHeight + _itemPadding + itemSize.height ]];
                    
                    axisXOfItem =  _itemPadding + minHeightIndex * (itemSize.width + _itemPadding);
                    axisYOfItem = minHeight;
                    
                    yH = minHeight + _itemPadding + itemSize.height;
                    minHeight = 0;
                }
                
            } else {
                NSException *expcetion = [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
                [expcetion raise];
            }
            //caculate coordinate for each item
            
            // for test useage
            UILabel *simpleItem = [[UILabel alloc] initWithFrame:CGRectMake(axisXOfItem, axisYOfItem, itemSize.width, itemSize.height)];
            
            simpleItem.backgroundColor = [UIColor blueColor];
            simpleItem.textAlignment = NSTextAlignmentCenter;
            simpleItem.text = [NSString stringWithFormat:@"%d %.0f",++degbugCounter,minHeight];
            [self.waterfallGridView addSubview:simpleItem];
            
            
            // caculate contentsize of scrollview
            if (totalContentHeght < yH) {
                totalContentHeght = yH;
            }

            numberOfItems--;
        }
        
        numberOfSections--;
    }
    
    self.waterfallGridView.contentSize = CGSizeMake(320,totalContentHeght);
    
    
}



@end
