//
//  ZYCWaterFallGridController.m
//  ZYCWaterfallGrid
//
//  Created by zhangyuchen on 14-1-17.
//  Copyright (c) 2014年 zhangyuchen. All rights reserved.
//

#import <objc/runtime.h>

#import "ZYCWaterFallGridController.h"
#import "ZYCWaterfallGridView.h"


//static char * const kPositionCachesKey;
//CGRect *positionCaches = NULL;

typedef struct ZYCRectArray {
    CGRect *rects;
    int used;
    int size;
}ZYCRectArray;
static const int kDefaultArrayInitSize = 50;
static const int kDefaultArrayGrowthFactor = 2;
void initArray(ZYCRectArray *array)
{
    array->rects = malloc(sizeof(CGRect) * kDefaultArrayInitSize);
    array->used = 0;
    array->size = kDefaultArrayInitSize;
}

void insertArray(ZYCRectArray *array,CGRect aRect)
{
    if (array->used >= array->size) {
        array->size = array->size * kDefaultArrayGrowthFactor;
        array->rects = (CGRect *)realloc(array->rects ,sizeof(CGRect) * array->size);
        NSLog(@"reallocated memory");
    }
    array->rects[array->used++] = aRect;
}

void freeArray(ZYCRectArray *array)
{
    free(array->rects);
    free(array);
}



@interface ZYCWaterFallGridController ()

@property (nonatomic, assign, readwrite) ZYCArrangeDirection arrangeDirection;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) ZYCRectArray *positionCaches;


- (BOOL)isOnScreenWithRect:(CGRect) rect;

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
        _itemVerticalPadding = 3;
        _itemHorizontalPadding = 3;
        _positionCaches = (ZYCRectArray *)malloc(sizeof(ZYCRectArray));
        initArray(_positionCaches);
    }
    return self;
}

- (void)loadView
{
    self.waterfallGridView = [[ZYCWaterfallGridView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = self.waterfallGridView;
    _waterfallGridView.delegate = self;
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _screenWidth = CGRectGetWidth(applicationFrame);
    _screenHeight = CGRectGetHeight(applicationFrame);
    
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
	// Do any additional setup after loading the view.
    [self reloadItems];

}


- (void)viewDidDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    freeArray(_positionCaches);
    // Dispose of any resources that can be recreated.
}


#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
    //[self reloadItems];
}



- (void)reloadItems
{
    NSInteger numberOfSections = [self.dataSource numberOfSectionsInWaterfallGridView:self.waterfallGridView];
    if (!numberOfSections) {
        numberOfSections = 1;
    }
    
    float yH = 0 + _itemVerticalPadding;
    float totalContentHeght = 0;
    float minHeight = 0;
    BOOL isFirstLine = YES;
    
    while (numberOfSections > 0) {
        
        NSInteger numberOfItems = [self.dataSource waterfallGridView:self.waterfallGridView numberOfItemsInSection:numberOfSections];
        
        if (!numberOfItems) {
            numberOfItems = 200;
        }
        
        NSInteger rowCounter = 0;
        
        float xH = 0 + _itemHorizontalPadding;
        int previousColumnCount = 0;
        NSMutableArray *columnCountArray = [NSMutableArray array];
        NSMutableArray *columnCountTempArray = nil;
        NSMutableArray *columnCountTempArrayDepth = [NSMutableArray array];
        while (numberOfItems > 0) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCounter++ inSection:numberOfSections];
            CGSize itemSize = [self.delegate waterfallGridView:self.waterfallGridView sizeForItemAtIndexPath:indexPath];
            
            //recaculate from zero if xH will be placed out of screen
            if (xH + _itemHorizontalPadding + itemSize.width >= _screenWidth) {
                xH = 0 + _itemHorizontalPadding;
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
                axisYOfItem = columnCountTempArray == nil ? _itemVerticalPadding:[[columnCountTempArray objectAtIndex:previousColumnCount] floatValue];
                
                yH = axisYOfItem + _itemVerticalPadding + itemSize.height;
                xH += _itemHorizontalPadding + itemSize.width;
                
                [columnCountArray addObject:[NSNumber numberWithFloat:yH]];
                previousColumnCount++;
                
            } else if (self.arrangeDirection == ZYCArrangeDirectionDepth){
                
                if (isFirstLine) {
                    axisXOfItem = xH;
                    axisYOfItem = _itemVerticalPadding;

                    yH = axisYOfItem + _itemVerticalPadding + itemSize.height;
                    xH += _itemHorizontalPadding + itemSize.width;
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
                    [columnCountTempArrayDepth replaceObjectAtIndex:minHeightIndex withObject:[NSNumber numberWithFloat:minHeight + _itemVerticalPadding + itemSize.height ]];
                    
                    axisXOfItem =  _itemHorizontalPadding + minHeightIndex * (itemSize.width + _itemHorizontalPadding);
                    axisYOfItem = minHeight;
                    
                    yH = minHeight + _itemVerticalPadding + itemSize.height;
                    minHeight = 0;
                }
                
            } else {
                NSException *expcetion = [NSException exceptionWithName:NSInvalidArgumentException reason:@"" userInfo:nil];
                [expcetion raise];
            }
            //caculate coordinate for each item
            
            // for test useage
            UIView *itemView = [self.delegate waterfallGridView:self.waterfallGridView ViewForItemAtIndexPath:indexPath];
            itemView.frame = CGRectMake(axisXOfItem, axisYOfItem, itemSize.width, itemSize.height);
            //*tempPositionPtr++ = itemView.frame;
            insertArray(_positionCaches, itemView.frame);
            

            NSLog(@"%d",[self isOnScreenWithRect:itemView.frame]);
            if ([self isOnScreenWithRect:itemView.frame]) {
                //[self.waterfallGridView addSubview:itemView];
            }
            [self.waterfallGridView addSubview:itemView];
            
            
            // caculate contentsize of scrollview
            if (totalContentHeght < yH) {
                totalContentHeght = yH;
            }

            numberOfItems--;
        }
        
        numberOfSections--;
    }
    
    self.waterfallGridView.contentSize = CGSizeMake(self.waterfallGridView.bounds.size.width,totalContentHeght);
}


- (BOOL)isOnScreenWithRect:(CGRect) rect
{
    CGPoint contentOffset = self.waterfallGridView.contentOffset;
    CGPoint targetPosition = rect.origin;
    
    //horizontal test
    if (contentOffset.x > targetPosition.x) return NO;
    if (contentOffset.x + _screenWidth < targetPosition.x) return NO;
    
    //vertical test
    if (contentOffset.y > targetPosition.y) return NO;
    if (contentOffset.y + _screenHeight < targetPosition.y) return NO;
    
    return YES;
}


- (void)dealloc
{
    freeArray(_positionCaches);
}


@end
