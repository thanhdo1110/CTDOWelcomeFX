//
//  CTDOWelcomeFX.m
//  CTDOWelcomeFX
//
//  Created by Đỗ Trung Thành on 9/6/25.
//

#import "CTDOWelcomeFX.h"

#pragma mark - CTDOWelcomeFXFeature Implementation

@implementation CTDOWelcomeFXFeature

- (instancetype)initWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    self = [super init];
    if (self) {
        _icon = icon;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end


#pragma mark - CTDOWelcomeFXConfiguration Implementation

@implementation CTDOWelcomeFXConfiguration

+ (instancetype)defaultConfiguration {
    CTDOWelcomeFXConfiguration *config = [[CTDOWelcomeFXConfiguration alloc] init];
    
    UIImage *appIcon = [UIImage imageNamed:@"app_icon_ctdo"];
    if (!appIcon) {
        appIcon = [UIImage systemImageNamed:@"app.gift.fill"];
    }
    
    config.appIcon = appIcon;
    config.welcomeTitle = @"Welcome to";
    config.appName = @"CTDOTECH";
    config.appNameColor = [UIColor colorWithRed:0.72 green:0.66 blue:0.51 alpha:1.0];
    config.welcomeTitleFontSize = 40.0;
    config.appNameFontSize = 35.0;
    
    NSMutableArray<CTDOWelcomeFXFeature *> *defaultFeatures = [NSMutableArray array];
    NSArray *iconNames = @[@"feature_icon_1", @"feature_icon_2", @"feature_icon_3"];
    NSArray *sfSymbolNames = @[@"star.fill", @"lock.shield.fill", @"paintbrush.pointed.fill"];
    NSArray *titles = @[@"Feature 1", @"Feature 2", @"Feature 3"];
    NSArray *subtitles = @[@"Description for feature 1\nand more text\nand more text", @"Description for feature 2", @"Description for feature 3"];

    for (int i = 0; i < titles.count; i++) {
        UIImage *icon = [UIImage imageNamed:iconNames[i]];
        if (!icon) {
            icon = [UIImage systemImageNamed:sfSymbolNames[i]];
        }
        [defaultFeatures addObject:[[CTDOWelcomeFXFeature alloc] initWithIcon:icon title:titles[i] subtitle:subtitles[i]]];
    }
    config.features = [defaultFeatures copy];

    config.descriptionText = @"Your app description here. Learn more...";
    config.linkText = @"Learn more...";
    config.linkURL = [NSURL URLWithString:@"https://ctdo.net"];
    config.continueButtonText = @"Continue";
    config.userDefaultsKey = @"hasShownctdowelcomefx";
    
    return config;
}

@end


#pragma mark - CTDOWelcomeFXViewController Interface

@interface CTDOWelcomeFXViewController () <UITextViewDelegate, UIScrollViewDelegate>

// Configuration
@property (nonatomic, strong) CTDOWelcomeFXConfiguration *configuration;
@property (nonatomic, copy) void (^ctdowelcomefxCompletionHandler)(void);

// UI Components
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILayoutGuide *contentLayoutGuide;
@property (nonatomic, strong) UIView *bottomBarContainer;
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;
@property (nonatomic, strong) NSLayoutConstraint *bottomBarBottomConstraint;
@property (nonatomic, assign) BOOL isBottomBarVisible;
@property (nonatomic, assign) CGFloat lastScrollViewOffset;

// Responsive Metrics
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat iconSize;
@property (nonatomic, assign) CGFloat featureTitleSize;
@property (nonatomic, assign) CGFloat featureSubtitleSize;
@property (nonatomic, assign) CGFloat maxContentWidth;

// UI Elements
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *welcomeTitleLabel;
@property (nonatomic, strong) UIStackView *featuresStackView;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UIButton *continueButton;

// Animation Constraints
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *welcomeGroupCenteredConstraints;
@property (nonatomic, strong) NSArray<NSLayoutConstraint *> *welcomeGroupTopConstraints;

@end

#pragma mark - CTDOWelcomeFXViewController Implementation

@implementation CTDOWelcomeFXViewController

#pragma mark - Initialization and Lifecycle

- (instancetype)initWithConfiguration:(CTDOWelcomeFXConfiguration *)configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self configureMetricsForCurrentDevice];
    [self setupctdowelcomefxUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.logoImageView.alpha == 0.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startctdowelcomefxAnimationSequence];
        });
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateBlurEffectVisibility];
}

#pragma mark - Public Class Method for Presentation

+ (void)showctdowelcomefxIfNeededWithConfiguration:(CTDOWelcomeFXConfiguration *)configuration
                           inViewController:(UIViewController *)presentingVC
                                 completion:(void (^)(void))completion {
    if (!configuration.showEveryLaunch) {
        BOOL hasShownctdowelcomefx = [[NSUserDefaults standardUserDefaults] boolForKey:configuration.userDefaultsKey];
        if (hasShownctdowelcomefx) {
            if (completion) {
                completion();
            }
            return;
        }
    }

    CTDOWelcomeFXViewController *ctdowelcomefxVC = [[CTDOWelcomeFXViewController alloc] initWithConfiguration:configuration];
    ctdowelcomefxVC.ctdowelcomefxCompletionHandler = completion;
    ctdowelcomefxVC.modalPresentationStyle = UIModalPresentationFullScreen;
    ctdowelcomefxVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    UIViewController *vcToPresentOn = presentingVC;
    if (!vcToPresentOn) {
        vcToPresentOn = [self topMostViewController];
    }
    
    if (vcToPresentOn.presentedViewController) {
        [vcToPresentOn.presentedViewController dismissViewControllerAnimated:NO completion:^{
            [vcToPresentOn presentViewController:ctdowelcomefxVC animated:YES completion:nil];
        }];
    } else {
        [vcToPresentOn presentViewController:ctdowelcomefxVC animated:YES completion:nil];
    }
}

+ (UIViewController *)topMostViewController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

#pragma mark - UI Setup

- (void)configureMetricsForCurrentDevice {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.titleFontSize = 70.0; self.horizontalPadding = 60.0; self.iconSize = 50.0;
        self.featureTitleSize = 22.0; self.featureSubtitleSize = 19.0; self.maxContentWidth = 700.0;
    } else {
        self.titleFontSize = 50.0; self.horizontalPadding = 35.0; self.iconSize = 40.0;
        self.featureTitleSize = 17.0; self.featureSubtitleSize = 15.0; self.maxContentWidth = 580.0;
    }
}

- (void)setupctdowelcomefxUI {
    // Setup ScrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:contentView];
    
    self.contentLayoutGuide = [[UILayoutGuide alloc] init];
    [self.view addLayoutGuide:self.contentLayoutGuide];
    [self setupContentLayoutGuideConstraints:self.contentLayoutGuide];
    
    // Setup Bottom Bar
    self.bottomBarContainer = [[UIView alloc] init];
    self.bottomBarContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bottomBarContainer];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial];
    self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    self.blurEffectView.alpha = 0.0;
    [self.bottomBarContainer addSubview:self.blurEffectView];
    [self.bottomBarContainer sendSubviewToBack:self.blurEffectView];

    // Create UI Components
    self.logoImageView = [[UIImageView alloc] initWithImage:self.configuration.appIcon];
    
    self.welcomeTitleLabel = [[UILabel alloc] init];
    NSString *fullTitle = [NSString stringWithFormat:@"%@\n%@", self.configuration.welcomeTitle, self.configuration.appName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullTitle];
    NSRange welcomeRange = [fullTitle rangeOfString:self.configuration.welcomeTitle];
    NSRange appNameRange = [fullTitle rangeOfString:self.configuration.appName];
    [attrStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.configuration.welcomeTitleFontSize weight:UIFontWeightBold], NSForegroundColorAttributeName: [UIColor labelColor]} range:welcomeRange];
    if (appNameRange.location != NSNotFound) {
        [attrStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.configuration.appNameFontSize weight:UIFontWeightBold], NSForegroundColorAttributeName: self.configuration.appNameColor} range:appNameRange];
    }
    self.welcomeTitleLabel.attributedText = attrStr;
    self.welcomeTitleLabel.numberOfLines = 0;
    self.welcomeTitleLabel.textAlignment = NSTextAlignmentLeft;

    // Create Features StackView
    NSMutableArray *featureViews = [NSMutableArray array];
    for (CTDOWelcomeFXFeature *feature in self.configuration.features) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:feature.icon];
        [featureViews addObject:[self createFeatureViewWithIconView:iconView title:feature.title subtitle:feature.subtitle]];
    }
    self.featuresStackView = [[UIStackView alloc] initWithArrangedSubviews:featureViews];
    self.featuresStackView.axis = UILayoutConstraintAxisVertical;
    self.featuresStackView.spacing = 25.0;
    self.featuresStackView.alignment = UIStackViewAlignmentLeading;
    
    self.descriptionTextView = [[UITextView alloc] init];
    self.descriptionTextView.delegate = self;
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.scrollEnabled = NO;
    self.descriptionTextView.textContainerInset = UIEdgeInsetsZero;
    self.descriptionTextView.textContainer.lineFragmentPadding = 0;
    self.descriptionTextView.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *descriptionAttrStr = [[NSMutableAttributedString alloc] initWithString:self.configuration.descriptionText];
    CGFloat descriptionFontSize = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 16 : 13;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [descriptionAttrStr addAttributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:descriptionFontSize],
        NSForegroundColorAttributeName: [UIColor systemGrayColor],
        NSParagraphStyleAttributeName: paragraphStyle
    } range:NSMakeRange(0, self.configuration.descriptionText.length)];
    NSRange linkRange = [self.configuration.descriptionText rangeOfString:self.configuration.linkText];
    if (linkRange.location != NSNotFound) {
        [descriptionAttrStr addAttributes:@{ NSLinkAttributeName: self.configuration.linkURL, NSForegroundColorAttributeName: self.configuration.appNameColor } range:linkRange];
    }
    self.descriptionTextView.attributedText = descriptionAttrStr;
    
    self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.continueButton setTitle:self.configuration.continueButtonText forState:UIControlStateNormal];
    [self.continueButton setBackgroundColor:self.configuration.appNameColor];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.continueButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    self.continueButton.layer.cornerRadius = 14;
    [self.continueButton addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Set initial alpha for animation
    self.logoImageView.alpha = 0.0;
    self.welcomeTitleLabel.alpha = 0.0;
    for (UIView *view in self.featuresStackView.arrangedSubviews) { view.alpha = 0.0; }
    self.descriptionTextView.alpha = 0.0;
    self.continueButton.alpha = 0.0;

    // Add views and setup constraints
    for (UIView *view in @[self.logoImageView, self.welcomeTitleLabel, self.featuresStackView]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:view];
    }
    for (UIView *view in @[self.descriptionTextView, self.continueButton]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.bottomBarContainer addSubview:view];
    }

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    self.welcomeGroupCenteredConstraints = @[
        [self.logoImageView.bottomAnchor constraintEqualToAnchor:self.welcomeTitleLabel.topAnchor constant:-20],
        [self.logoImageView.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.welcomeTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.welcomeTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentLayoutGuide.trailingAnchor],
        [self.welcomeTitleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ];
    self.welcomeGroupTopConstraints = @[
        [self.logoImageView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:-10],
        [self.logoImageView.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.welcomeTitleLabel.topAnchor constraintEqualToAnchor:self.logoImageView.bottomAnchor constant:15],
        [self.welcomeTitleLabel.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.welcomeTitleLabel.trailingAnchor constraintEqualToAnchor:self.contentLayoutGuide.trailingAnchor],
    ];
    
    CGFloat logoSize = self.iconSize + 20;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.frameLayoutGuide.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.frameLayoutGuide.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.frameLayoutGuide.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.scrollView.frameLayoutGuide.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [contentView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.logoImageView.widthAnchor constraintEqualToConstant:logoSize],
        [self.logoImageView.heightAnchor constraintEqualToConstant:logoSize],
        [self.featuresStackView.topAnchor constraintEqualToAnchor:self.welcomeTitleLabel.bottomAnchor constant:40],
        [self.featuresStackView.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.featuresStackView.trailingAnchor constraintEqualToAnchor:self.contentLayoutGuide.trailingAnchor],
        [self.featuresStackView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-150],
    ]];
    
    self.bottomBarBottomConstraint = [self.bottomBarContainer.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[
        [self.bottomBarContainer.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.bottomBarContainer.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        self.bottomBarBottomConstraint,
        [self.blurEffectView.topAnchor constraintEqualToAnchor:self.bottomBarContainer.topAnchor],
        [self.blurEffectView.bottomAnchor constraintEqualToAnchor:self.bottomBarContainer.bottomAnchor],
        [self.blurEffectView.leadingAnchor constraintEqualToAnchor:self.bottomBarContainer.leadingAnchor],
        [self.blurEffectView.trailingAnchor constraintEqualToAnchor:self.bottomBarContainer.trailingAnchor],
        [self.descriptionTextView.topAnchor constraintEqualToAnchor:self.bottomBarContainer.topAnchor constant:20],
        [self.descriptionTextView.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.descriptionTextView.trailingAnchor constraintEqualToAnchor:self.contentLayoutGuide.trailingAnchor],
        [self.continueButton.topAnchor constraintEqualToAnchor:self.descriptionTextView.bottomAnchor constant:15],
        [self.continueButton.heightAnchor constraintEqualToConstant:(UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 60 : 50],
        [self.continueButton.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor],
        [self.continueButton.trailingAnchor constraintEqualToAnchor:self.contentLayoutGuide.trailingAnchor],
        [self.continueButton.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-20]
    ]];

    [NSLayoutConstraint activateConstraints:self.welcomeGroupCenteredConstraints];
    self.isBottomBarVisible = YES;
}

#pragma mark - Actions & Delegate

- (void)continueButtonTapped {
    [self animateOutWithCompletion:^{
        if (!self.configuration.showEveryLaunch) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.configuration.userDefaultsKey];
        }
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.ctdowelcomefxCompletionHandler) {
                self.ctdowelcomefxCompletionHandler();
            }
        }];
    }];
}

- (void)animateOutWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.scrollView.alpha = 0.0;
        self.bottomBarContainer.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    return NO;
}

#pragma mark - Animations and UI Updates

- (void)updateBlurEffectVisibility {
    if (!self.featuresStackView.window) return;
    CGRect featuresFrameInView = [self.featuresStackView.superview convertRect:self.featuresStackView.frame toView:self.view];
    CGFloat featuresBottomY = CGRectGetMaxY(featuresFrameInView);
    CGFloat barTopY = self.bottomBarContainer.frame.origin.y;
    BOOL shouldBeVisible = featuresBottomY > barTopY;
    if ((shouldBeVisible && self.blurEffectView.alpha == 0) || (!shouldBeVisible && self.blurEffectView.alpha == 1)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.blurEffectView.alpha = shouldBeVisible ? 1.0 : 0.0;
        }];
    }
}

- (void)hideBottomBar {
    if (!self.isBottomBarVisible) return;
    self.isBottomBarVisible = NO;
    CGFloat barHeight = self.bottomBarContainer.frame.size.height;
    self.bottomBarBottomConstraint.constant = barHeight;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)showBottomBar {
    if (self.isBottomBarVisible) return;
    self.isBottomBarVisible = YES;
    self.bottomBarBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat scrollViewHeight = scrollView.frame.size.height;
    if (contentHeight <= scrollViewHeight) { [self showBottomBar]; return; }
    if (currentOffset > self.lastScrollViewOffset && currentOffset > 0) { [self hideBottomBar]; }
    else if (currentOffset < self.lastScrollViewOffset || currentOffset <= 0) { [self showBottomBar]; }
    self.lastScrollViewOffset = currentOffset;
    [self updateBlurEffectVisibility];
}

- (void)startctdowelcomefxAnimationSequence {
    [UIView animateWithDuration:1.2 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.logoImageView.alpha = 1.0;
        self.welcomeTitleLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (!finished) return;
        [self animateToTopPositionAndRevealFeatures];
    }];
}

- (void)animateToTopPositionAndRevealFeatures {
    [NSLayoutConstraint deactivateConstraints:self.welcomeGroupCenteredConstraints];
    [NSLayoutConstraint activateConstraints:self.welcomeGroupTopConstraints];
    [UIView animateWithDuration:0.8 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.logoImageView.alpha = 0.0;
        self.descriptionTextView.alpha = 1.0;
        self.continueButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (!finished) return;
        [self animateFeaturesStaggered];
        [self updateBlurEffectVisibility];
    }];
}

- (void)animateFeaturesStaggered {
    NSTimeInterval delay = 0.0;
    NSTimeInterval increment = 0.15;
    for (UIView *featureView in self.featuresStackView.arrangedSubviews) {
        featureView.transform = CGAffineTransformMakeTranslation(0, 20);
        [UIView animateWithDuration:0.4 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            featureView.alpha = 1.0;
            featureView.transform = CGAffineTransformIdentity;
        } completion:nil];
        delay += increment;
    }
}

- (void)setupContentLayoutGuideConstraints:(UILayoutGuide *)guide {
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    NSLayoutConstraint *widthConstraint = [guide.widthAnchor constraintEqualToAnchor:safeArea.widthAnchor constant: -2 * self.horizontalPadding];
    NSLayoutConstraint *maxWidthConstraint = [guide.widthAnchor constraintLessThanOrEqualToConstant:self.maxContentWidth];
    widthConstraint.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[
        [guide.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [guide.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [guide.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        widthConstraint,
        maxWidthConstraint
    ]];
}

- (UIView *)createFeatureViewWithIconView:(UIView *)iconView title:(NSString *)title subtitle:(NSString *)subtitle {
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor labelColor];
    titleLabel.font = [UIFont systemFontOfSize:self.featureTitleSize weight:UIFontWeightBold];
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor systemGrayColor];
    subtitleLabel.font = [UIFont systemFontOfSize:self.featureSubtitleSize];
    subtitleLabel.numberOfLines = 0;
    UIStackView *textStackView = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, subtitleLabel]];
    textStackView.axis = UILayoutConstraintAxisVertical;
    textStackView.spacing = 4;
    UIStackView *mainStackView = [[UIStackView alloc] initWithArrangedSubviews:@[iconView, textStackView]];
    mainStackView.axis = UILayoutConstraintAxisHorizontal;
    mainStackView.spacing = 15;
    mainStackView.alignment = UIStackViewAlignmentTop;
    [iconView.widthAnchor constraintEqualToConstant:self.iconSize].active = YES;
    [iconView.heightAnchor constraintEqualToConstant:self.iconSize].active = YES;
    return mainStackView;
}

@end