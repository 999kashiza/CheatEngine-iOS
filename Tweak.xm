#import <UIKit/UIKit.h>
#import <mach/mach.h>
#import <mach/vm_map.h>
#import <substrate.h>

// Interface simple
@interface CheatMenu : UIView
@property (nonatomic, strong) UIButton *toggleBtn;
@property (nonatomic, strong) UIView *menuView;
@end

@implementation CheatMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        
        // Bouton flottant
        self.toggleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.toggleBtn.frame = CGRectMake(20, 100, 60, 60);
        self.toggleBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.2 alpha:0.9];
        self.toggleBtn.layer.cornerRadius = 30;
        [self.toggleBtn setTitle:@"CE" forState:UIControlStateNormal];
        [self.toggleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.toggleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        
        [self.toggleBtn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        // Pan gesture pour déplacer
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.toggleBtn addGestureRecognizer:pan];
        
        [self addSubview:self.toggleBtn];
        
        // Menu (caché par défaut)
        self.menuView = [[UIView alloc] initWithFrame:CGRectMake(20, 170, 250, 300)];
        self.menuView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.95];
        self.menuView.layer.cornerRadius = 10;
        self.menuView.layer.borderWidth = 2;
        self.menuView.layer.borderColor = [UIColor cyanColor].CGColor;
        self.menuView.hidden = YES;
        
        // Label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 30)];
        label.text = @"Memory Scanner";
        label.textColor = [UIColor cyanColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        [self.menuView addSubview:label];
        
        // Bouton scan
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        scanBtn.frame = CGRectMake(10, 50, 230, 40);
        scanBtn.backgroundColor = [UIColor darkGrayColor];
        [scanBtn setTitle:@"Scan Value" forState:UIControlStateNormal];
        [scanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanMemory) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:scanBtn];
        
        [self addSubview:self.menuView];
    }
    return self;
}

- (void)toggleMenu {
    self.menuView.hidden = !self.menuView.hidden;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    self.toggleBtn.center = CGPointMake(self.toggleBtn.center.x + translation.x, 
                                        self.toggleBtn.center.y + translation.y);
    [gesture setTranslation:CGPointZero inView:self];
}

- (void)scanMemory {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Scan" 
                                                                   message:@"Feature active" 
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:alert animated:YES completion:nil];
}

@end

// Hook principal
%hook UIWindow

- (void)layoutSubviews {
    %orig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CheatMenu *menu = [[CheatMenu alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self addSubview:menu];
        });
    });
}

%end

%ctor {
    NSLog(@"[CheatEngine] Loaded");
}
