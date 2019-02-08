#import "FlutterCardIoPlugin.h"
#import "CardIO.h"

@interface FlutterCardIoPlugin ()<CardIOPaymentViewControllerDelegate>
@end

@implementation FlutterCardIoPlugin {
    FlutterResult _result;
    NSDictionary *_arguments;
    CardIOPaymentViewController *_scanViewController;
    UIViewController *_viewController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_card_io"
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterCardIoPlugin *instance = [[FlutterCardIoPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        _scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    }
    return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }

    if ([@"scanCard" isEqualToString:call.method]) {
        _scanViewController.delegate = self;

        _result = result;
        _arguments = call.arguments;

        _scanViewController.scanExpiry = [_arguments objectForKey:@"scanExpiry"] ? [[_arguments objectForKey:@"scanExpiry"] boolValue] : false;
        _scanViewController.collectExpiry = [_arguments objectForKey:@"requireExpiry"] ? [[_arguments objectForKey:@"requireExpiry"] boolValue] : false;
        _scanViewController.collectCVV = [_arguments objectForKey:@"requireCVV"] ? [[_arguments objectForKey:@"requireCVV"] boolValue] : false;
        _scanViewController.collectPostalCode = [_arguments objectForKey:@"requirePostalCode"] ? [[_arguments objectForKey:@"requirePostalCode"] boolValue] : false;
        _scanViewController.collectCardholderName = [_arguments objectForKey:@"requireCardHolderName"] ? [[_arguments objectForKey:@"requireCardHolderName"] boolValue] : false;
        _scanViewController.restrictPostalCodeToNumericOnly = [_arguments objectForKey:@"restrictPostalCodeToNumericOnly"] ? [[_arguments objectForKey:@"restrictPostalCodeToNumericOnly"] boolValue] : false;
        _scanViewController.scanInstructions = [_arguments valueForKey:@"scanInstructions"];
        _scanViewController.keepStatusBarStyle = [_arguments objectForKey:@"keepApplicationTheme"] ? [[_arguments objectForKey:@"keepApplicationTheme"] boolValue] : false;
        _scanViewController.hideCardIOLogo = [_arguments objectForKey:@"hideCardIOLogo"] ? [[_arguments objectForKey:@"hideCardIOLogo"] boolValue] : false;
        _scanViewController.useCardIOLogo = [_arguments objectForKey:@"useCardIOLogo"] ? [[_arguments objectForKey:@"useCardIOLogo"] boolValue] : false;
        _scanViewController.suppressScanConfirmation = [_arguments objectForKey:@"suppressConfirmation"] ? [[_arguments objectForKey:@"suppressConfirmation"] boolValue] : false;
        _scanViewController.disableManualEntryButtons = [_arguments objectForKey:@"suppressManualEntry"] ? [[_arguments objectForKey:@"suppressManualEntry"] boolValue] : false;

        [_viewController presentViewController:_scanViewController animated:YES completion:nil];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _result([NSNull null]);
    _result = nil;
    _arguments = nil;
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSString *cardType = nil;
    if(info.cardType != CardIOCreditCardTypeUnrecognized && info.cardType != CardIOCreditCardTypeAmbiguous) {
        switch (info.cardType) {
            case CardIOCreditCardTypeAmex:
                cardType = @"Amex";
                break;
            case CardIOCreditCardTypeJCB:
                cardType = @"JCB";
                break;
            case CardIOCreditCardTypeVisa:
                cardType = @"Visa";
                break;
            case CardIOCreditCardTypeMastercard:
                cardType = @"MasterCard";
                break;
            case CardIOCreditCardTypeDiscover:
                cardType = @"Discover";
                break;
            default:
                break;
        }
    }
    _result(@{
        @"cardholderName": ObjectOrNull(info.cardholderName),
        @"cardNumber": ObjectOrNull(info.cardNumber),
        @"cardType": ObjectOrNull(cardType),
        @"redactedCardNumber": ObjectOrNull(info.redactedCardNumber),
        @"expiryMonth": ObjectOrNull(@(info.expiryMonth)),
        @"expiryYear": ObjectOrNull(@(info.expiryYear)),
        @"cvv": ObjectOrNull(info.cvv),
        @"postalCode": ObjectOrNull(info.postalCode)
    });
    [_scanViewController dismissViewControllerAnimated:YES completion:nil];
    _result = nil;
    _arguments = nil;
}

static id ObjectOrNull(id object) {
    return object ?: [NSNull null];
}

@end
