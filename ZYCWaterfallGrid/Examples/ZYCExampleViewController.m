//
//  ZYCExampleViewController.m
//  ZYCWaterfallGrid
//
//  Created by zhangyuchen on 14-1-20.
//  Copyright (c) 2014年 zhangyuchen. All rights reserved.
//

#import "ZYCExampleViewController.h"

@interface ZYCExampleViewController ()

@end

@implementation ZYCExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"DEMOs";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MENUCELL"];
    
    int row = [indexPath row];
    
    switch (row) {
        case 0:
        {
            cell.textLabel.text = @"BREADTH DEMO";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"DEPTH DEMO";
            break;
        }
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];

    ZYCWaterFallGridController *waterFall ;
    switch (row) {
        case 0:
        {
            waterFall = [[ZYCWaterFallGridController alloc] initWithArrangeDirection:ZYCArrangeDirectionBreadth];
            break;
        }
        case 1:
        {
           waterFall = [[ZYCWaterFallGridController alloc] initWithArrangeDirection:ZYCArrangeDirectionDepth];
        }
        default:
            break;
    }
    waterFall.itemVerticalPadding = 2;
    waterFall.itemVerticalPadding = 5;
    waterFall.delegate = self;
    
    [self.navigationController pushViewController:waterFall animated:YES];
}


-(CGSize)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView sizeForItemAtIndexPath:(NSIndexPath *)path
{
    static dispatch_once_t onceToken;
    __block int randomHeight = arc4random() % 300 ;
    randomHeight = randomHeight > 150 ? randomHeight: randomHeight + 150;
    dispatch_once(&onceToken, ^{
        // for boundary value cases
        randomHeight = 5000;
    });
    CGSize itemSize = CGSizeMake(102,randomHeight);
    return itemSize;
}

- (UIView *)waterfallGridView:(ZYCWaterfallGridView *)waterfallGridView ViewForItemAtIndexPath:(NSIndexPath *)path
{
    UILabel *simpleItem = [[UILabel alloc] init];
    //simpleItem.text = @"test";
    simpleItem.backgroundColor = [UIColor blueColor];
    simpleItem.textAlignment = NSTextAlignmentCenter;
    simpleItem.text = [NSString stringWithFormat:@"number:%d",[path row]];
    return simpleItem;
}



@end
