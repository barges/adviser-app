enum RecaptchaErrorCode {
  // reCAPTCHA Enterprise has faced an internal error, please try again in a bit.
  internalError,

  // The user action is invalid.
  invalidAction,

  // Cannot create a reCAPTCHA Enterprise client with a non-Android site key.
  invalidKeytype,

  // Cannot create a reCAPTCHA Enterprise client because the site key used doesn't support the calling package.
  invalidPackageName,

  // The site key used to call reCAPTCHA Enterprise is invalid.
  invalidSiteKey,

  // The timeout provided for init/execute is invalid as we expect a minimum of 5000 milliseconds.
  invalidTimeout,

  // reCAPTCHA Enterprise cannot connect to Google servers, please make sure the app has network access.
  networkError,

  // Unknown error occurred during the workflow.
  unknowError,
}
