//
//  KTMImageCaching.m
//
//  Created by Kishore Thejasvi on 05/10/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#define kPathToTemporaryDirectory NSTemporaryDirectory()
#import "KTMImageCaching.h"

@implementation KTMImageCaching

+ (instancetype)sharedInstance {
    static dispatch_once_t onceTokenImageCaching;
    static KTMImageCaching *instance;
    dispatch_once(&onceTokenImageCaching, ^{
        instance = [[KTMImageCaching alloc] init];
    });
    
    return instance;
}

- (void)downloadAndCacheImageWithURL: (NSString *)url {
    NSString *filename = [self makeUniqueFileNameForURLString:url];
    NSString *uniquePath = [kPathToTemporaryDirectory stringByAppendingPathComponent:filename];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:uniquePath]) {
        /* If image is available in cache which is NSTemporaryDirectory().
         * Load the image from temporary directory on to memory and inform calling function using delegate method
         * - (void) cachedImageData: (NSData *)imageData
         */
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __block NSData *imageData;
        dispatch_sync(queue, ^{
            imageData = [NSData dataWithContentsOfFile:uniquePath];
        });
        [self.delegate cachedImageData:imageData];
    } else {
        /* If image is not available in cache which is NSTemporaryDirectory().
         * Download the image asynchronously, once the download is complete, inform the calling object using delegate method
         * - (void) downloadedImageData: (NSData *)imageData and also store image data to NSTemporaryDirectory.
         */
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        __weak __block __typeof__(self) _self = self;
        
        __block NSData *imageData;
        dispatch_group_async(group, queue, ^{
            NSLog(@"Current thread first time %@", [NSThread currentThread]);
            NSURL *ImageURL = [NSURL URLWithString:url];
            imageData = [[NSData alloc] initWithContentsOfURL:ImageURL];
        });
        
        dispatch_group_notify(group, queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Current thread second time %@", [NSThread currentThread]);
                [_self.delegate downloadedImageData:imageData];
            });
            
            dispatch_async(queue, ^{
                [imageData writeToFile:uniquePath atomically:YES];
            });
        });        
    }
}

/**
 *  Creates a unique file name to each image URL, file name corresponding to a particular image url will be always unique
 *
 *  @param url Image URL
 *
 *  @return Unique file name for storing image data in NSTemporaryDirectory().
 */
- (NSString *)makeUniqueFileNameForURLString: (NSString *)url {
    NSString *string1 = [url substringFromIndex:6];
    NSArray *words1 = [string1 componentsSeparatedByString:@"/"];
    NSString *string2 = [self combineStrings:words1];
    NSArray *words2 = [string2 componentsSeparatedByString:@"."];
    NSString *string3 = [self combineStrings:words2];
    return string3;
}

- (NSString *)combineStrings: (NSArray *)words {
    NSString *finalString = @"";
    for (NSString *string in words) {
        finalString = [finalString stringByAppendingString:string];
    }
    return finalString;
}

@end
