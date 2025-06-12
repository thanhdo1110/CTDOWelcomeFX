// CTDOWelcomeFX.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a feature item displayed in the ctdowelcomefx screen's feature list.
 */
@interface CTDOWelcomeFXFeature : NSObject

@property (nonatomic, strong, readonly) UIImage *icon;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle;

@end

/**
 * Configuration object containing all customizable data for the ctdowelcomefx screen.
 */
@interface CTDOWelcomeFXConfiguration : NSObject

// Header Configuration
@property (nonatomic, strong) UIImage *appIcon;
@property (nonatomic, copy) NSString *welcomeTitle;
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, strong) UIColor *appNameColor;

// Content Configuration
@property (nonatomic, strong) NSArray<CTDOWelcomeFXFeature *> *features;

// Bottom Bar Configuration
@property (nonatomic, copy) NSString *descriptionText;
@property (nonatomic, copy) NSString *linkText;
@property (nonatomic, strong) NSURL *linkURL;
@property (nonatomic, copy) NSString *continueButtonText;

// Display Settings
@property (nonatomic, copy) NSString *userDefaultsKey;
@property (nonatomic, assign) BOOL showEveryLaunch;

+ (instancetype)defaultConfiguration;

@end

/**
 * Main view controller for the ctdowelcomefx screen.
 * Use the class method `showctdowelcomefxIfNeeded...` to display the ctdowelcomefx screen.
 */
@interface CTDOWelcomeFXViewController : UIViewController

/**
 * Displays the ctdowelcomefx screen if it hasn't been shown before.
 * Checks NSUserDefaults using the configuration's userDefaultsKey.
 * If ctdowelcomefx was never shown, it presents the screen on presentingViewController.
 * If already shown, it immediately calls the completion block.
 *
 * @param configuration Configuration object containing display data
 * @param presentingVC View controller to present ctdowelcomefx from. If nil, uses top-most view controller
 * @param completion Block called after user taps continue and ctdowelcomefx is dismissed
 */
+ (void)showctdowelcomefxIfNeededWithConfiguration:(CTDOWelcomeFXConfiguration *)configuration
                           inViewController:(nullable UIViewController *)presentingVC
                                 completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END