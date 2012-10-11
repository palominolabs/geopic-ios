//
//  GPVenueDetailsViewController.m
//  GeoPic
//
//  Created by Manuel Wudka-Robles on 10/10/12.
//  Copyright (c) 2012 Palomino Labs, Inc. All rights reserved.
//

#import "GPVenueDetailsViewController.h"
#import "GPAuthHelpers.h"


@interface GPVenueDetailsViewController ()

@end



@implementation GPVenueDetailsViewController {
    GPVenue *_venue;
}

- (id)initWithVenue:(GPVenue *)venue {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        _venue = venue;
        
        self.navigationItem.title = _venue.title;
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[KISSMetricsAPI sharedAPI] recordEvent:@"view_venue" withProperties:@{@"foursquare_id": _venue.foursquareId}];
}

- (void)loadView {
    [super loadView];
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray-place-background"]] autorelease];
    
    [self.view layoutSubviews];
    
    self.contentSizeForViewInPopover = [self.tableView sizeThatFits:CGSizeMake(320, 300)];
}

- (void)takePicture:(UIButton *)button {
    [[KISSMetricsAPI sharedAPI] recordEvent:@"start_taking_picture" withProperties:@{@"foursquare_id": _venue.foursquareId}];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController new] autorelease];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        popoverController.delegate = self;
        
        [popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [popoverController release];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[KISSMetricsAPI sharedAPI] recordEvent:@"took_picture" withProperties:@{@"foursquare_id": _venue.foursquareId}];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    const int kDesiredWidth = 600;
    
    if (image.size.width > kDesiredWidth) {
        CGSize newSize = CGSizeMake(kDesiredWidth, kDesiredWidth * image.size.height / image.size.width);
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =  NSLocalizedString(@"Saving Picture", @"Saving Picture");
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [hud show:YES];
    
    NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
    GPWithLoggedInUser(^(NSString *userId) {
        NSString *picture = [SMBinaryDataConversion stringForBinaryData:pictureData name:@"picture" contentType:@"image/jpeg"];
        NSDictionary *object = @{
        @"picture":picture,
        @"foursquare_id":_venue.foursquareId,
        @"venue_name":_venue.title
        };
        
        [[[SMClient defaultClient] dataStore] createObject:object inSchema:@"venuepicture" onSuccess:^(NSDictionary *theObject, NSString *schema) {
            [hud hide:YES];
        } onFailure:^(NSError *theError, NSDictionary *theObject, NSString *schema) {
            [hud hide:YES];
        }];
    });
}


#pragma mark UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellReuseIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kCellReuseIdentifier] autorelease];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Category", @"Category");
            cell.detailTextLabel.text = _venue.category;
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Checkins", @"Checkins");
            NSNumberFormatter *formatter = [[NSNumberFormatter new] autorelease];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            
            cell.detailTextLabel.text = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:_venue.checkinsCount] numberStyle:NSNumberFormatterDecimalStyle];
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Phone", @"Phone");
            cell.detailTextLabel.text = _venue.formattedPhone;
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView new] autorelease];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setImage:[UIImage imageNamed:@"camera-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *buttonBackground = [UIImage imageNamed:@"green-nav-button"];
    UIImage *resizableButtonBackground = [buttonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(15, 21, 15, 21)];
    [button setBackgroundImage:resizableButtonBackground forState:UIControlStateNormal];
    
    [footer addSubview:button];
    
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    
    [footer addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    
    [footer addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70;
}

@end
