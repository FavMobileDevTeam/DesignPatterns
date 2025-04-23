abstract class AnalyticsService {
  void logEvent(String name, Map<String, dynamic> parameters);
}

class CustomAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, Map<String, dynamic> parameters) {
    print('Logging event: $name with parameters: $parameters');
  }
}

class ThirdPartyAnalytics {
  void send(String eventName, Map<String, dynamic> data) {
    print('Third-party analytics: $eventName - $data');
  }
}

class SomeFeature {
  final ThirdPartyAnalytics analytics = ThirdPartyAnalytics();

  void performAction() {
    // ... some logic
    analytics.send('action_performed', {'key': 'value'});
  }
}

class ThirdPartyAnalyticsAdapter implements AnalyticsService {
  final ThirdPartyAnalytics _thirdPartyAnalytics;

  ThirdPartyAnalyticsAdapter(this._thirdPartyAnalytics);

  @override
  void logEvent(String name, Map<String, dynamic> parameters) {
    _thirdPartyAnalytics.send(name, parameters);
  }
}

class SomeFeature2 {
  final AnalyticsService analytics;

  SomeFeature2(this.analytics);

  void performAction() {
    // ... some logic
    analytics.logEvent('action_performed', {'key': 'value'});
  }
}
