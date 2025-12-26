___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "DD Iubenda CMP Consent State (Unofficial)",
  "categories": [
    "TAG_MANAGEMENT"
  ],
  "description": "Use with the Iubenda CMP to identify the individual website user\u0027s consent state and configure when tags should execute.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "iubendaConsentCategoryCheckDrop",
    "displayName": "Select Iubenda Consent Category",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "iubendaNecessary",
        "displayValue": "Necessary"
      },
      {
        "value": "iubendaFunctionality",
        "displayValue": "Functionality"
      },
      {
        "value": "iubendaExperience",
        "displayValue": "Experience"
      },
      {
        "value": "iubendaMeasurement",
        "displayValue": "Measurement"
      },
      {
        "value": "iubendaMarketing",
        "displayValue": "Marketing"
      },
      {
        "value": "iubendacustom_consent_category",
        "displayValue": "Custom Consent Category"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "iubendaCustomConsentCat",
    "displayName": "Enter Consent Category",
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "iubendaConsentCategoryCheckDrop",
        "paramValue": "iubendacustom_consent_category",
        "type": "EQUALS"
      }
    ],
    "help": "Enter the consent category value",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "e.g., persads"
  },
  {
    "type": "TEXT",
    "name": "iubendaPurposeId",
    "displayName": "Enter Purpose ID Number",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "PERCENTAGE"
      }
    ],
    "valueHint": "e.g., 4",
    "help": "Here is where you enter the purpose ID number that relates to the consent category"
  },
  {
    "type": "CHECKBOX",
    "name": "iubendaMissingConsentConfig",
    "checkboxText": "Transform \"missing consent config\"",
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "iubendaMissingConsentConfigOption",
    "displayName": "How Do Want To Category \"missing consent config\" output",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "iubendaMCCTrue",
        "displayValue": "true"
      },
      {
        "value": "iubendaMCCFalse",
        "displayValue": "false"
      },
      {
        "value": "iubendaMCCUndefined",
        "displayValue": "Undefined"
      }
    ],
    "simpleValueType": true,
    "enablingConditions": [
      {
        "paramName": "iubendaMissingConsentConfig",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "iubendaEnableOptionalConfig",
    "checkboxText": "Enable Optional Output Transformation",
    "simpleValueType": true
  },
  {
    "type": "GROUP",
    "name": "iubendaOptionalConfig",
    "displayName": "Iubenda Consent State Value Transformation",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "iubendaTrue",
        "displayName": "Transform \"True\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "iubendaTrueGranted",
            "displayValue": "granted"
          },
          {
            "value": "iubendaTrueAccept",
            "displayValue": "accept"
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "SELECT",
        "name": "iubendaFalse",
        "displayName": "Transform \"False\"",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "iubendaFalseDenied",
            "displayValue": "denied"
          },
          {
            "value": "iubendaFalseDeny",
            "displayValue": "deny"
          }
        ],
        "simpleValueType": true
      }
    ],
    "enablingConditions": [
      {
        "paramName": "iubendaEnableOptionalConfig",
        "paramValue": true,
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');
const makeString = require('makeString');
const makeNumber = require('makeNumber');
const getType = require('getType');

const categoryKey = data.iubendaConsentCategoryCheckDrop;
const customCategory = data.iubendaCustomConsentCat;
const purposeIdRaw = data.iubendaPurposeId;

const enableTransform = data.iubendaEnableOptionalConfig;
const transformTrue = data.iubendaTrue;
const transformFalse = data.iubendaFalse;

const enableMissingConsentTransform = data.iubendaMissingConsentConfig;
const missingConsentOption = data.iubendaMissingConsentConfigOption;

function transformValue(val) {
  if (!enableTransform) return val;
  if (val === true) {
    return transformTrue === 'iubendaTrueGranted' ? 'granted' : 'accept';
  }
  if (val === false) {
    return transformFalse === 'iubendaFalseDenied' ? 'denied' : 'deny';
  }
  return val;
}

function getConsentPurposes() {
  return copyFromWindow('_iub.cs.api.cs.consent.purposes');
}

function getConsentFallback() {
  const gdpr = callInWindow('_iub.cs.api.gdprApplies');
  if (gdpr === true) return false;

  const lgpd = callInWindow('_iub.cs.api.lgpdApplies');
  if (lgpd === true) return false;

  const ccpa = callInWindow('_iub.cs.api.ccpaApplies');
  if (ccpa === true) {
    const ccpaConsent = copyFromWindow('_iub.cs.api.cs.consent.consent');
    return (getType(ccpaConsent) === 'undefined' || ccpaConsent === true) ? true : false;
  }

  const siteId = copyFromWindow('_iub.csConfiguration.siteId');
  if (getType(siteId) === 'undefined') {
    return undefined;
  }

  // Custom handling for "missing consent config"
  if (enableMissingConsentTransform === true) {
    switch (missingConsentOption) {
      case 'iubendaMCCTrue':
        return true;
      case 'iubendaMCCFalse':
        return false;
      case 'iubendaMCCUndefined':
        return undefined;
    }
  }

  return 'missing consent config';
}

// Step 1: resolve consent category (even if it's custom, it's only used for UI)
let rawKey = makeString(categoryKey).replace('iubenda', '');
if (rawKey === 'custom_consent_category') {
  rawKey = makeString(customCategory);
}

// Step 2: process purpose ID
const purposeId = makeNumber(purposeIdRaw);
if (getType(purposeId) !== 'number') return undefined;

// Step 3: try direct consent lookup
const purposes = getConsentPurposes();
if (getType(purposes) === 'object' && getType(purposes[purposeId]) !== 'undefined') {
  return transformValue(purposes[purposeId]);
}

// Step 4: fallback logic
const fallback = getConsentFallback();
return transformValue(fallback);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.cs.api.cs.consent.purposes"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.cs.api.gdprApplies"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.cs.api.lgpdApplies"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.cs.api.ccpaApplies"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.csConfiguration.siteId"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_iub.cs.api.cs.consent.consent"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 5/20/2025, 9:39:08 AM


