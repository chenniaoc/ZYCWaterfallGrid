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

@end

@implementation ZYCWaterFallGridController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)init
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
        while (numberOfItems > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberOfItems inSection:numberOfSections];
            
            int randomHeight = arc4random() % 180 ;
            randomHeight = randomHeight > 150 ? randomHeight: randomHeight + 150;
            //randomHeight = 180;
            CGSize itemSize = CGSizeMake(100,randomHeight);//[self.delegate waterfallGridView:self.waterfallGridView sizeForItemAtIndexPath:indexPath];
            
            //NSMutableArray *columnCountTempArray = nil;
            //recaculate from zero if xH will out of screen
            BOOL newlineDid = NO;
            if (xH + _itemPadding + itemSize.width >= screenWidth) {
                xH = 0 + _itemPadding;
                [columnCountTempArray removeAllObjects];
                columnCountTempArray = nil;
                columnCountTempArray = [NSMutableArray arrayWithArray:columnCountArray];//[columnCountArray copy];
                [columnCountArray removeAllObjects];
                previousColumnCount = 0;
                newlineDid = YES;
            }
            
            //yH = [[columnCountTempArray objectAtIndex:previousColumnCount] floatValue];
            
            int minHeight = 0;
            if (columnCountTempArray) {
                minHeight = [[columnCountTempArray firstObject] intValue];
                for (NSNumber *heightTemp in columnCountTempArray) {
                    int heightTempInt = [heightTemp intValue];
                    minHeight = minHeight > heightTempInt? heightTempInt:minHeight;
                }
            }
            
            //caculate coordinate for each item
            float axisXOfItem = xH;
            float axisYOfItem = columnCountTempArray == nil ? _itemPadding:[[columnCountTempArray objectAtIndex:previousColumnCount] floatValue];
            
            UILabel *simpleItem = [[UILabel alloc] initWithFrame:CGRectMake(axisXOfItem, axisYOfItem, itemSize.width, itemSize.height)];
            
            simpleItem.backgroundColor = [UIColor blueColor];
            simpleItem.textAlignment = NSTextAlignmentCenter;
            simpleItem.text = [NSString stringWithFormat:@"%d %d",++degbugCounter,minHeight];
            
            
            [self.waterfallGridView addSubview:simpleItem];
            
            yH = axisYOfItem + _itemPadding + itemSize.height;
            xH += _itemPadding + itemSize.width;
            if (totalContentHeght < yH) {
                totalContentHeght = yH;
            }
            [columnCountArray addObject:[NSNumber numberWithFloat:yH]];
            numberOfItems--;
            previousColumnCount++;
        }
        
        numberOfSections--;
    }
    
    self.waterfallGridView.contentSize = CGSizeMake(320,totalContentHeght);
    
    
}



@end
