//
//  ViewController.m
//  Hangman
//
//  Created by Blake Oistad on 9/24/15.
//  Copyright © 2015 Blake Oistad. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

#pragma mark - Misc Properties

@property (nonatomic, strong)        NSArray    *dictionaryArray;
@property (nonatomic, strong)        NSNumber   *randomizedNumber;

@property (nonatomic, weak) IBOutlet UILabel    *wrongAnswerLabel;
@property (nonatomic, weak) IBOutlet UILabel    *youLoseLabel;
@property (nonatomic, weak) IBOutlet UILabel    *youWinLabel;
@property (nonatomic, strong)        NSString   *currentWord;
@property (nonatomic, weak) IBOutlet UIView     *wordView;

#pragma mark - Control Buttons

@property (nonatomic, weak) IBOutlet UIButton   *resetButton;
@property (nonatomic, weak) IBOutlet UIButton   *startButton;

#pragma mark - Letter Buttons

@property (nonatomic, weak) IBOutlet UIButton   *aButton;
@property (nonatomic, weak) IBOutlet UIButton   *bButton;
@property (nonatomic, weak) IBOutlet UIButton   *cButton;
@property (nonatomic, weak) IBOutlet UIButton   *dButton;
@property (nonatomic, weak) IBOutlet UIButton   *eButton;
@property (nonatomic, weak) IBOutlet UIButton   *fButton;
@property (nonatomic, weak) IBOutlet UIButton   *gButton;
@property (nonatomic, weak) IBOutlet UIButton   *hButton;
@property (nonatomic, weak) IBOutlet UIButton   *iButton;
@property (nonatomic, weak) IBOutlet UIButton   *jButton;
@property (nonatomic, weak) IBOutlet UIButton   *kButton;
@property (nonatomic, weak) IBOutlet UIButton   *lButton;
@property (nonatomic, weak) IBOutlet UIButton   *mButton;
@property (nonatomic, weak) IBOutlet UIButton   *nButton;
@property (nonatomic, weak) IBOutlet UIButton   *oButton;
@property (nonatomic, weak) IBOutlet UIButton   *pButton;
@property (nonatomic, weak) IBOutlet UIButton   *qButton;
@property (nonatomic, weak) IBOutlet UIButton   *rButton;
@property (nonatomic, weak) IBOutlet UIButton   *sButton;
@property (nonatomic, weak) IBOutlet UIButton   *tButton;
@property (nonatomic, weak) IBOutlet UIButton   *uButton;
@property (nonatomic, weak) IBOutlet UIButton   *vButton;
@property (nonatomic, weak) IBOutlet UIButton   *wButton;
@property (nonatomic, weak) IBOutlet UIButton   *xButton;
@property (nonatomic, weak) IBOutlet UIButton   *yButton;
@property (nonatomic, weak) IBOutlet UIButton   *zButton;

@end

@implementation ViewController

int letterLocation = 0;
int wrongAnswers = 0;
bool blankFound = false;


#pragma mark - CSV Methods

- (NSString *)readBundleFileToString:(NSString *)filename ofType:
(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:type];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
}

- (NSArray *)convertCSVStringToArray:(NSString *)csvString {
    NSString *cleanString = [[csvString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@","];
    return [cleanString componentsSeparatedByCharactersInSet:set];
    
}

#pragma mark - Interactivity Methods

- (IBAction)startButtonPressed:(UIButton *)button {
    int totalOptions = 1581;
    int randomIndex = arc4random_uniform((uint32_t)totalOptions);
    NSString *randomWordString = _dictionaryArray[randomIndex];
    
    NSLog(@"Start Button Pressed %@", randomWordString);
    _currentWord = randomWordString;
    [self addLabels];
    NSLog(@"Current Word: %@", _currentWord);
    button.enabled = true;
    _aButton.enabled = true;
    _bButton.enabled = true;
    _cButton.enabled = true;
    _dButton.enabled = true;
    _eButton.enabled = true;
    _fButton.enabled = true;
    _gButton.enabled = true;
    _hButton.enabled = true;
    _iButton.enabled = true;
    _jButton.enabled = true;
    _kButton.enabled = true;
    _lButton.enabled = true;
    _mButton.enabled = true;
    _nButton.enabled = true;
    _oButton.enabled = true;
    _pButton.enabled = true;
    _qButton.enabled = true;
    _rButton.enabled = true;
    _sButton.enabled = true;
    _tButton.enabled = true;
    _uButton.enabled = true;
    _vButton.enabled = true;
    _wButton.enabled = true;
    _xButton.enabled = true;
    _yButton.enabled = true;
    _zButton.enabled = true;
    
    wrongAnswers = 0;
    _wrongAnswerLabel.hidden = true;
    _resetButton.hidden = true;
    _youLoseLabel.hidden = true;
    _youWinLabel.hidden = true;
//    [self letterLabel];
}


- (IBAction)letterPressed:(UIButton *)button {
    NSString *buttonLetter = [button currentTitle];
    NSLog(@"Letter Button Pressed %@", buttonLetter);
    if ([[_currentWord uppercaseString] containsString:buttonLetter]) {
        for (int i = 0; i < [_currentWord length]; i++) {
            NSString *letter = [_currentWord substringWithRange:NSMakeRange(i, 1)];
            if ([[letter uppercaseString] isEqualToString:buttonLetter]) {
                NSLog(@"Found %@", buttonLetter);
                for (UILabel *currentLabel in [_wordView subviews]) {
                    if (currentLabel.tag == i) {
                        currentLabel.text = [letter uppercaseString];
                    }
                }
                button.enabled = false;
            } else {
                NSLog(@"Not Found -> %@",buttonLetter);
            }
            [self winLoseCheck];
        }
    } else {
        NSLog(@"Letter not found");
        wrongAnswers += 1;
        [self wrongAnswerResult];
        NSLog(@"Wrong Answers %d", wrongAnswers);
        button.enabled = false;
        [self winLoseCheck];
    }
// Self call for Win check
    
    
}

// Check for blank labels; if no labels are blank, user wins
- (void)winLoseCheck {
    blankFound = false;
    for (UILabel *currentWordLabels in [_wordView subviews]) {
        if ([currentWordLabels.text isEqualToString:@""]) {
            blankFound = true;
            NSLog(@"BLANK FOUND");
        }
        
    }
    if (!blankFound) {
        NSLog(@"WIN");
        _youWinLabel.hidden = false;
        _resetButton.hidden = false;
    }
    else {
        NSLog(@"NO WIN");
    }
}


- (void)addLabels {
    for (id object in [_wordView subviews]) {
        [object removeFromSuperview];
    }
    
    for (NSInteger i = 0; i < [_currentWord length]; i++) {
        float xPos = (i * 28.0) + 20.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 5.0, 25.0, 35.0)];
        label.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1.0];
        label.tag = i;
        label.text = @"";
        [_wordView addSubview:label];
    }
}



- (void)wrongAnswerResult {
    if (wrongAnswers == 10) {
        NSLog(@"You Lose Man!");
        _youLoseLabel.hidden = false;
        _resetButton.hidden = false;
        _aButton.enabled = false;
        _bButton.enabled = false;
        _cButton.enabled = false;
        _dButton.enabled = false;
        _eButton.enabled = false;
        _fButton.enabled = false;
        _gButton.enabled = false;
        _hButton.enabled = false;
        _iButton.enabled = false;
        _jButton.enabled = false;
        _kButton.enabled = false;
        _lButton.enabled = false;
        _mButton.enabled = false;
        _nButton.enabled = false;
        _oButton.enabled = false;
        _pButton.enabled = false;
        _qButton.enabled = false;
        _rButton.enabled = false;
        _sButton.enabled = false;
        _tButton.enabled = false;
        _uButton.enabled = false;
        _vButton.enabled = false;
        _wButton.enabled = false;
        _xButton.enabled = false;
        _yButton.enabled = false;
        _zButton.enabled = false;
    }
    _wrongAnswerLabel.hidden = false;
}



#pragma mark - Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentWord = @"";
    
    _dictionaryArray=[self convertCSVStringToArray: [self readBundleFileToString:@"WordSetApple" ofType: @"csv"]];
    for (NSString *test in _dictionaryArray) {
        NSLog(@"word: %@",test);
    }

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
