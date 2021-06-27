function myFunction() {
    OpenPay.setId('mroipipydkwe3txxqfht');
    OpenPay.setApiKey('pk_0450626f5da34f87b4a0279a4c34fa1c');
    var deviceSessionId = OpenPay.deviceData.setup("payment-form", "deviceIdHiddenFieldName");
    return deviceSessionId;   // The function returns the product of p1 and p2
}