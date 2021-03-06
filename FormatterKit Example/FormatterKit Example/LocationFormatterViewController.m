// LocationFormatterViewController.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <CoreLocation/CoreLocation.h>
#import "LocationFormatterViewController.h"

#import "TTTLocationFormatter.h"

enum {
    DistanceInMetricWithCardinalDirectionsSectionIndex,
    DistanceInImperialWithcardinalDirectionAbbreviationsSectionIndex,
    SpeedInImperialWithBearingsInDegreesSectionIndex,
    CoordinatesSectionIndex,
} LocationFormatterViewControllerSectionIndexes;

@interface LocationFormatterViewController ()
@property (readwrite, nonatomic, retain) CLLocation *austin;
@property (readwrite, nonatomic, retain) CLLocation *pittsburgh;
@end

@implementation LocationFormatterViewController
@synthesize austin = _austin;
@synthesize pittsburgh = _pittsburgh;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) {
        return nil;
    }
    
    self.title = NSLocalizedString(@"Hours of Operation Formatter", nil);
    
    self.austin = [[[CLLocation alloc] initWithLatitude:30.2669444 longitude:-97.7427778] autorelease];
    self.pittsburgh = [[[CLLocation alloc] initWithLatitude:40.4405556 longitude:-79.9961111] autorelease];
    
    return self;
}

- (void)dealloc {
    [_austin release];
    [_pittsburgh release];
    [super dealloc];
}

+ (NSString *)formatterDescription {
    return NSLocalizedString(@"TTTLocationFormatter gives you a lot of flexibility in the display of coordinates, distances, direction, speed, and velocity. Choose Metric or Imperial, cardinal directions, abbreviations, or degrees, and configure everything else (number of significant digits, etc.), with the associated NSNumberFormatter.", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case DistanceInMetricWithCardinalDirectionsSectionIndex:
            return NSLocalizedString(@"Distance in Metric Units, with Cardinal Directions", nil);
        case DistanceInImperialWithcardinalDirectionAbbreviationsSectionIndex:
            return NSLocalizedString(@"Distance in Imperial Units, with Cardinal Direction Abbreviations", nil);
        case SpeedInImperialWithBearingsInDegreesSectionIndex:
            return NSLocalizedString(@"Speed in Imperial Units, with Bearing in Degrees", nil);
        case CoordinatesSectionIndex:
            return NSLocalizedString(@"Coordinates", nil);
        default:
            return nil;
    }
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    static TTTLocationFormatter *_locationFormatter = nil;
    if (!_locationFormatter) {
        _locationFormatter = [[TTTLocationFormatter alloc] init];
        [_locationFormatter.numberFormatter setMaximumSignificantDigits:4];
    }
    
    [_locationFormatter.numberFormatter setUsesSignificantDigits:YES];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    switch (indexPath.section) {
        case DistanceInMetricWithCardinalDirectionsSectionIndex:
            [_locationFormatter setUnitSystem:TTTMetricSystem];
            [_locationFormatter setBearingStyle:TTTBearingWordStyle];
            
            cell.textLabel.text = [_locationFormatter stringFromDistanceAndBearingFromLocation:self.pittsburgh toLocation:self.austin];
            break;
        case DistanceInImperialWithcardinalDirectionAbbreviationsSectionIndex:
            [_locationFormatter setUnitSystem:TTTImperialSystem];
            [_locationFormatter setBearingStyle:TTTBearingAbbreviationWordStyle];
            
            cell.textLabel.text = [_locationFormatter stringFromDistanceAndBearingFromLocation:self.pittsburgh toLocation:self.austin];
            break;
        case SpeedInImperialWithBearingsInDegreesSectionIndex:
            [_locationFormatter setUnitSystem:TTTImperialSystem];
            [_locationFormatter setBearingStyle:TTTBearingNumericStyle];
            
            cell.textLabel.text = [_locationFormatter stringFromVelocityFromLocation:self.pittsburgh toLocation:self.austin atSpeed:25];
            break;
        case CoordinatesSectionIndex:
            [_locationFormatter.numberFormatter setUsesSignificantDigits:NO];
            
            cell.textLabel.text = [_locationFormatter stringFromLocation:self.austin];
            break;
    }
}

@end
