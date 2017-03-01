//
//  PageControlExampleViewController.m
//  FSPagerViewExample-Objc
//
//  Created by Wenchao Ding on 20/01/2017.
//  Copyright © 2017 Wenchao Ding. All rights reserved.
//

#import "PageControlExampleViewController.h"
#import "FSPagerViewExample_Objc-Swift.h"

@interface PageControlExampleViewController () <UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate>

@property (strong, nonatomic) NSArray<NSString *> *imageNames;
@property (strong, nonatomic) NSArray<NSString *> *pageControlStyles;
@property (strong, nonatomic) NSArray<NSString *> *pageControlAlignments;
@property (strong, nonatomic) NSArray<NSString *> *sectionTitles;

@property (weak  , nonatomic) IBOutlet UITableView *tableView;
@property (weak  , nonatomic) IBOutlet FSPagerView *pagerView;
@property (weak  , nonatomic) IBOutlet FSPageControl *pageControl;

@property (assign, nonatomic) NSInteger styleIndex;
@property (assign, nonatomic) NSInteger alignmentIndex;

// ⭐️
@property (readonly, nonatomic) UIBezierPath *starPath;
// ❤️
@property (readonly, nonatomic) UIBezierPath *heartPath;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end

@implementation PageControlExampleViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageNames = @[@"1_1.jpg", @"1_2.jpg", @"1_3.jpg", @"1_4.jpg", @"1_5.jpg", @"1_6.jpg", @"1_7.jpg"];
    self.pageControlStyles = @[@"Default", @"Ring", @"UIImage", @"UIBezierPath - Star", @"UIBezierPath - Heart"];
    self.pageControlAlignments = @[@"Right", @"Center", @"Left"];
    self.sectionTitles = @[@"Style", @"Item Spacing", @"Interitem Spacing", @"Horizontal Alignment"];
    
    self.pageControl.numberOfPages = self.imageNames.count;
    self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.pageControl.contentInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    
    self.pagerView.itemSize = CGSizeZero; // Fill parent
    [self.pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.pageControlStyles.count;
        case 1:
        case 2:
            return 1;
        case 3:
            return self.pageControlAlignments.count;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.text = self.pageControlStyles[indexPath.row];
            cell.accessoryType = self.styleIndex==indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            UISlider *slider = cell.contentView.subviews.firstObject;
            slider.tag = indexPath.section;
            slider.value = (self.pageControl.itemSpacing-6.0)/10.0;
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider_cell"];
            UISlider *slider = cell.contentView.subviews.firstObject;
            slider.tag = indexPath.section;
            slider.value = (self.pageControl.interitemSpacing-6.0)/10.0;
            return cell;
        }
        case 3: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.text = self.pageControlAlignments[indexPath.row];
            cell.accessoryType = self.alignmentIndex==indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            return cell;
        }
        default:
            break;
    }
    return [tableView dequeueReusableCellWithIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == 0 || indexPath.section == 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            self.styleIndex = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case 3: {
            self.alignmentIndex = indexPath.row;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - FSPagerViewDataSource

- (NSInteger)numberOfItemsInpagerView:(FSPagerView *)pagerView
{
    return self.imageNames.count;
}

- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
    return cell;
}

#pragma mark - FSPagerViewDelegate

- (void)pagerViewDidScroll:(FSPagerView *)pagerView
{
    if (self.pageControl.currentPage != pagerView.currentIndex) {
        self.pageControl.currentPage = pagerView.currentIndex;
    }
}

#pragma mark - Target actions

- (void)sliderValueChanged:(UISlider *)sender
{
    switch (sender.tag) {
        case 1: {
            self.pageControl.itemSpacing = 6.0 + sender.value*10.0; // [6 - 16]
            // Redraw UIBezierPath
            if (self.styleIndex == 3 || self.styleIndex == 4) {
                self.styleIndex = self.styleIndex;
            }
            break;
        }
        case 3: {
            self.pageControl.interitemSpacing = 6.0 + sender.value*10.0; // [6 - 16]
            break;
        }
        default:
            break;
    }
}

#pragma mark - Private properties

- (void)setStyleIndex:(NSInteger)styleIndex
{
    _styleIndex = styleIndex;
    // Clean up
    [self.pageControl setStrokeColor:nil forState:UIControlStateNormal];
    [self.pageControl setStrokeColor:nil forState:UIControlStateSelected];
    [self.pageControl setFillColor:nil forState:UIControlStateNormal];
    [self.pageControl setFillColor:nil forState:UIControlStateSelected];
    [self.pageControl setImage:nil forState:UIControlStateNormal];
    [self.pageControl setImage:nil forState:UIControlStateSelected];
    [self.pageControl setPath:nil forState:UIControlStateNormal];
    [self.pageControl setPath:nil forState:UIControlStateSelected];
    switch (styleIndex) {
        case 0: {
            // Default
            break;
        }
        case 1: {
            // Ring
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor greenColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor greenColor] forState:UIControlStateSelected];
            break;
        }
        case 2: {
            // UIImage
            [self.pageControl setImage:[UIImage imageNamed:@"icon_footprint"] forState:UIControlStateNormal];
            [self.pageControl setImage:[UIImage imageNamed:@"icon_cat"] forState:UIControlStateSelected];
            break;
        }
        case 3: {
            // UIBezierPath - Star
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setFillColor:[UIColor yellowColor] forState:UIControlStateSelected];
            [self.pageControl setPath:self.starPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.starPath forState:UIControlStateSelected];
            break;
        }
        case 4: {
            // UIBezierPath - Heart
            UIColor *color = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:255/255.0 alpha:1.0];
            [self.pageControl setStrokeColor:color forState:UIControlStateNormal];
            [self.pageControl setStrokeColor:color forState:UIControlStateSelected];
            [self.pageControl setFillColor:color forState:UIControlStateSelected];
            [self.pageControl setPath:self.heartPath forState:UIControlStateNormal];
            [self.pageControl setPath:self.heartPath forState:UIControlStateSelected];
            break;
        }
        default:
            break;
    }
    
}

- (void)setAlignmentIndex:(NSInteger)alignmentIndex
{
    _alignmentIndex = alignmentIndex;
    switch (alignmentIndex) {
        case 0: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            break;
        }
        case 1: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            break;
        }
        case 2: {
            self.pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            break;
        }
        default:
            break;
    }
}

// ⭐️
- (UIBezierPath *)starPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *starPath = [[UIBezierPath alloc] init];
    [starPath moveToPoint:CGPointMake(width*0.5, 0)];
    [starPath addLineToPoint:CGPointMake(width*0.677, height*0.257)];
    [starPath addLineToPoint:CGPointMake(width*0.975, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.785, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.794, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.5, height*0.8)];
    [starPath addLineToPoint:CGPointMake(width*0.206, height*0.905)];
    [starPath addLineToPoint:CGPointMake(width*0.215, height*0.593)];
    [starPath addLineToPoint:CGPointMake(width*0.025, height*0.345)];
    [starPath addLineToPoint:CGPointMake(width*0.323, height*0.257)];
    [starPath closePath];
    return starPath;
}

// ❤️
- (UIBezierPath *)heartPath
{
    CGFloat width = self.pageControl.itemSpacing;
    CGFloat height = self.pageControl.itemSpacing;
    UIBezierPath *heartPath = [[UIBezierPath alloc] init];
    [heartPath moveToPoint:CGPointMake(width*0.5, height)];
    [heartPath addCurveToPoint:CGPointMake(0, height*0.25)
                 controlPoint1:CGPointMake(width*0.5, height*0.75)
                 controlPoint2:CGPointMake(0, height*0.5)];
    [heartPath addArcWithCenter:CGPointMake(width*0.25, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addArcWithCenter:CGPointMake(width*0.75, height*0.25)
                         radius:width*0.25
                     startAngle:M_PI
                       endAngle:0
                      clockwise:YES];
    [heartPath addCurveToPoint:CGPointMake(width*0.5, height)
                 controlPoint1:CGPointMake(width, height*0.5)
                 controlPoint2:CGPointMake(width*0.5, height*0.75)];
    [heartPath closePath];
    return heartPath;
}


@end
