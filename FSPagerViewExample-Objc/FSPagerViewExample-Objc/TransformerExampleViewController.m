//
//  TransformerExampleViewController.m
//  FSPagerViewExample-Objc
//
//  Created by Wenchao Ding on 19/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

#import "TransformerExampleViewController.h"
#import "FSPagerViewExample_Objc-Swift.h"

@interface TransformerExampleViewController () <UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (strong, nonatomic) NSArray<NSString *> *transformerNames;
@property (assign, nonatomic) NSInteger typeIndex;

@property (weak  , nonatomic) IBOutlet UITableView *tableView;
@property (weak  , nonatomic) IBOutlet FSPagerView *pagerView;

@end

@implementation TransformerExampleViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageNames = @[@"1_1.jpg",@"1_2.jpg",@"1_3.jpg",@"1_4.jpg",@"1_5.jpg",@"1_6.jpg",@"1_7.jpg"];
    self.transformerNames = @[@"cross fading", @"zoom out", @"depth", @"linear", @"overlap", @"ferris wheel", @"inverted ferris wheel", @"coverflow", @"cubic"];
    [self.pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.typeIndex = 0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.typeIndex = self.typeIndex;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transformerNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.transformerNames[indexPath.row];
    cell.accessoryType = indexPath.row == self.typeIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.typeIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:tableView.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Transformers";
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInpagerView:(FSPagerView *)pagerView
{
    return self.imageNames.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell * cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index
{
    [pagerView deselectItemAtIndex:index animated:YES];
    [pagerView scrollToItemAtIndex:index animated:YES];
}

#pragma mark - Private properties

- (void)setTypeIndex:(NSInteger)typeIndex
{
    _typeIndex = typeIndex;
    FSPagerViewTransformerType type;
    switch (typeIndex) {
        case 0: {
            type = FSPagerViewTransformerTypeCrossFading;
            break;
        }
        case 1: {
            type = FSPagerViewTransformerTypeZoomOut;
            break;
        }
        case 2: {
            type = FSPagerViewTransformerTypeDepth;
            break;
        }
        case 3: {
            type = FSPagerViewTransformerTypeLinear;
            break;
        }
        case 4: {
            type = FSPagerViewTransformerTypeOverlap;
            break;
        }
        case 5: {
            type = FSPagerViewTransformerTypeFerrisWheel;
            break;
        }
        case 6: {
            type = FSPagerViewTransformerTypeInvertedFerrisWheel;
            break;
        }
        case 7: {
            type = FSPagerViewTransformerTypeCoverFlow;
            break;
        }
        case 8: {
            type = FSPagerViewTransformerTypeCubic;
            break;
        }
        default:
            break;
    }
    self.pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:type];
    switch (type) {
        case FSPagerViewTransformerTypeCrossFading:
        case FSPagerViewTransformerTypeZoomOut:
        case FSPagerViewTransformerTypeDepth: {
            self.pagerView.itemSize = CGSizeZero; // 'Zero' means fill the size of parent
            break;
        }
        case FSPagerViewTransformerTypeLinear:
        case FSPagerViewTransformerTypeOverlap: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.6, 0.75);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            break;
        }
        case FSPagerViewTransformerTypeFerrisWheel:
        case FSPagerViewTransformerTypeInvertedFerrisWheel: {
            self.pagerView.itemSize = CGSizeMake(180, 140);
            break;
        }
        case FSPagerViewTransformerTypeCoverFlow: {
            self.pagerView.itemSize = CGSizeMake(220, 170);
            break;
        }
        case FSPagerViewTransformerTypeCubic: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.9, 0.9);
            self.pagerView.itemSize = CGSizeApplyAffineTransform(self.pagerView.frame.size, transform);
            break;
        }
        default:
            break;
    }
}

@end


