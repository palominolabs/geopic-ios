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
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture)] autorelease];
    }
    return self;
}

- (void)takePicture {
    UIImagePickerController *imagePicker = [[UIImagePickerController new] autorelease];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _venue.checkinsCount];
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"Phone", @"Phone");
            cell.detailTextLabel.text = _venue.formattedPhone;
            break;
    }
    
    return cell;
}


@end
