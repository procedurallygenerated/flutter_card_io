package com.varunvairavan.fluttercardio;

import android.app.Activity;
import android.content.Intent;

import java.util.HashMap;
import java.util.Map;

import io.card.payment.CardIOActivity;
import io.card.payment.CreditCard;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterCardIoPlugin
 */
public class FlutterCardIoPlugin implements MethodCallHandler, ActivityResultListener {
    private static final int MY_SCAN_REQUEST_CODE = 100;

    private final PluginRegistry.Registrar registrar;
    private Result pendingResult;
    private MethodCall methodCall;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_card_io");
        FlutterCardIoPlugin instance = new FlutterCardIoPlugin(registrar);
        registrar.addActivityResultListener(instance);
        channel.setMethodCallHandler(instance);
    }

    private FlutterCardIoPlugin(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (pendingResult != null) {
            result.error("ALREADY_ACTIVE", "Scan card is already active", null);
            return;
        }

        Activity activity = registrar.activity();
        if (activity == null) {
            result.error("no_activity", "flutter_card_io plugin requires a foreground activity.", null);
            return;
        }

        pendingResult = result;
        methodCall = call;

        if (call.method.equals("scanCard")) {
            Intent scanIntent = new Intent(activity, CardIOActivity.class);

            boolean requireExpiry = false;
            if (methodCall.hasArgument("requireExpiry")) {
                requireExpiry = methodCall.argument("requireExpiry");
            }

            boolean requireCVV = false;
            if (methodCall.hasArgument("requireCVV")) {
                requireCVV = methodCall.argument("requireCVV");
            }

            boolean requirePostalCode = false;
            if (methodCall.hasArgument("requirePostalCode")) {
                requirePostalCode = methodCall.argument("requirePostalCode");
            }

            boolean requireCardHolderName = false;
            if (methodCall.hasArgument("requireCardHolderName")) {
                requireCardHolderName = methodCall.argument("requireCardHolderName");
            }

            boolean restrictPostalCodeToNumericOnly = false;
            if (methodCall.hasArgument("restrictPostalCodeToNumericOnly")) {
                restrictPostalCodeToNumericOnly = methodCall.argument("restrictPostalCodeToNumericOnly");
            }

            boolean scanExpiry = false;
            if (methodCall.hasArgument("scanExpiry")) {
                scanExpiry = methodCall.argument("scanExpiry");
            }

            boolean scanInstructions = false;
            if (methodCall.hasArgument("scanInstructions")) {
                scanInstructions = methodCall.argument("scanInstructions");
            }

            // customize these values to suit your needs.
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_EXPIRY, requireExpiry); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_EXPIRY, scanExpiry);
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CVV, requireCVV); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_POSTAL_CODE, requirePostalCode); // default: false
            scanIntent.putExtra(CardIOActivity.EXTRA_REQUIRE_CARDHOLDER_NAME, requireCardHolderName);
            scanIntent.putExtra(CardIOActivity.EXTRA_RESTRICT_POSTAL_CODE_TO_NUMERIC_ONLY, restrictPostalCodeToNumericOnly);
            scanIntent.putExtra(CardIOActivity.EXTRA_SCAN_INSTRUCTIONS, scanInstructions);

            scanIntent.putExtra(CardIOActivity.EXTRA_USE_CARDIO_LOGO, true);
            scanIntent.putExtra(CardIOActivity.EXTRA_HIDE_CARDIO_LOGO, true);
            scanIntent.putExtra(CardIOActivity.EXTRA_USE_PAYPAL_ACTIONBAR_ICON, false);
            scanIntent.putExtra(CardIOActivity.EXTRA_KEEP_APPLICATION_THEME, true);

            // MY_SCAN_REQUEST_CODE is arbitrary and is only used within this activity.
            activity.startActivityForResult(scanIntent, MY_SCAN_REQUEST_CODE);
        } else {
            result.notImplemented();
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == MY_SCAN_REQUEST_CODE) {
            if (data != null && data.hasExtra(CardIOActivity.EXTRA_SCAN_RESULT)) {
                CreditCard scanResult = data.getParcelableExtra(CardIOActivity.EXTRA_SCAN_RESULT);

                Map<String, Object> response = new HashMap<>();
                response.put("cardholderName", scanResult.cardholderName);
                response.put("cardNumber", scanResult.cardNumber);
                response.put("expiryMonth", scanResult.expiryMonth);
                response.put("expiryYear", scanResult.expiryYear);
                response.put("cvv", scanResult.cvv);
                response.put("postalCode", scanResult.postalCode);
                pendingResult.success(response);
            } else {
                pendingResult.success(null);
            }
            pendingResult = null;
            methodCall = null;
            return true;
        }
        return false;
    }
}
