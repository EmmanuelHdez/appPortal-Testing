class EnvironmentConfig {
  static String get baseUrl =>
      '$serverUrl/api/v2.0/medQareApp';
  static String get baseUrlV3 =>
      '$serverUrl/api/v3.0/medQareApp';
  static String get serverUrl =>
      'https://puk-companionapp-backend-dev-820a0b1f98e6.herokuapp.com';
  static String get portalUrl => 'https://devportal.psychiatry-uk.com';
  static String get xServiceCompanioApp => 'companionApp';
  static String get xServerCompanionAppToken => '4H8sL2aK9pR6qY3w';
  static String get aadb2cTenantName => 'psychiatryukb2corg.onmicrosoft.com';
  static String get aadb2cClientId => 'c21cb253-f9dc-44ab-822c-174b90b5de6a';
  static String get aadb2cRedirectUri =>
      '$serverUrl/log-in';
  static String get aadb2cLogoutRedirectUri =>
      '$serverUrl/log-out';
  static String get aadb2cDiscoveryUri =>
      'https://psychiatryukb2corg.b2clogin.com/psychiatryukb2corg.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1A_SIGNINPOLICY';
  static String get aadb2cLogoutUri =>
      'https://psychiatryukb2corg.b2clogin.com/psychiatryukb2corg.onmicrosoft.com/oauth2/v2.0/logout?p=b2c_1a_signinpolicy';
  static String get baseUrlSocket => 'https://devportal.psychiatry-uk.com/';
  static String get authenticatorAppUrl => 'https://pukauth-dev.herokuapp.com';
}
