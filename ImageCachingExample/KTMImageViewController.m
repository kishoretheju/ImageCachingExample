//
//  KTMImageViewController.m
//  ImageCachingExample
//
//  Created by Kishore Thejasvi on 24/10/14.
//  Copyright (c) 2014 Kishore Thejasvi. All rights reserved.
//

#define kFirstRamdomImageURL @"http://upload.wikimedia.org/wikipedia/commons/d/db/Malaysia_airlines_b747-400_specialcolours_arp.jpg"
#define kSecondRamdomImageURL @"http://upload.wikimedia.org/wikipedia/commons/8/89/Hawaiian_Airlines_Boeing_767_(N597HA)_taking_off.jpg"
#define kThirdRamdomImageURL @"http://upload.wikimedia.org/wikipedia/commons/0/03/Australian_Airlines_VH-OGI_Sydney_Airport_2005.jpg"
#define kFourthRamdomImageURL @"http://upload.wikimedia.org/wikipedia/commons/f/fa/Chengdu_Airlines_Airbus_A319_Jordan.jpg"
#define kFifthRamdomImageURL @"http://i.investopedia.com/inv/articles/slideshow/coolest-airlines/airline-coolest.jpg"

#import "KTMImageViewController.h"
#import "KTMImageCaching.h"

@interface KTMImageViewController () <KTMImageCachingDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation KTMImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect indicatorViewFrame = CGRectMake(screenBounds.size.width/2 - 25, screenBounds.size.height/2 - 25, 50, 50);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:indicatorViewFrame];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
    [self.view bringSubviewToFront:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    /*
     * A collection of five image url, random image url will be selected.
     */
    NSArray *kURLsArray = @[kFirstRamdomImageURL, kSecondRamdomImageURL, kThirdRamdomImageURL, kFourthRamdomImageURL, kFifthRamdomImageURL];
    NSString *imageURLString = [kURLsArray objectAtIndex:[self generateRandomIndex]];
    
    /*
     * Create a singleton instance of image caching class and start downlading the image, if image is available in cache
     * - (void) cachedImageData: (NSData *)imageData function gets called with data of image otherwise image will be
     * downloaded first and then - (void) downloadedImageData:(NSData *)imageData gets called.
     */
    [KTMImageCaching sharedInstance].delegate = self;
    [[KTMImageCaching sharedInstance] downloadAndCacheImageWithURL:imageURLString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)generateRandomIndex {
    int lowerBound = 0;
    int upperBound = 4;
    int randomValue = lowerBound + arc4random() % (upperBound - lowerBound);
    return randomValue;
}

/**
 *  Delegate methods of KTMImageCaching class
 *
 */
#pragma mark - ImageCachingDelegate
- (void)cachedImageData:(NSData *)imageData {
    self.imageView.image = [UIImage imageWithData:imageData];
    [self.activityIndicatorView stopAnimating];
}

- (void)downloadedImageData:(NSData *)imageData {
    self.imageView.image = [UIImage imageWithData:imageData];
    [self.activityIndicatorView stopAnimating];
}

@end
