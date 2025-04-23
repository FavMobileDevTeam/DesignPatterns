abstract class VerificationFlow {
  void run() {
    init();
    sendCode();
    waitForResponse();
    validate();
  }

  void init() {
    print("Initialize verification");
  }

  void waitForResponse() {
    print("Waiting for user input...");
  }

  void validate();

  void sendCode();
}

class SmsVerification extends VerificationFlow {
  @override
  void sendCode() {
    print("Send SMS code");
  }

  @override
  void validate() {
    print("Validate SMS code");
  }
}

class EmailVerification extends VerificationFlow {
  @override
  void sendCode() {
    print("Send Email");
  }

  @override
  void validate() {
    print("Validate Email");
  }
}
