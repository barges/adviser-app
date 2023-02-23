class ChatScreenTestResponses {
  static const String ritualImageUrl = 'test/assets/test_placeholder.png';

  static const Map<String, dynamic>
      publicQuestionClientWithoutQuestionProperties = {
    "_id": "63bbab1b793423001e28722e",
    "firstName": "Anabel",
    "lastName": "Rau",
    "zodiac": "capricorn",
    "birthdate": "1989-01-09T00:00:00.000Z",
    "gender": "female",
    "country": "IE",
    "isProfileCompleted": false,
    "questionsSubscription": {"active": false},
    "safeToSendEmail": false,
    "id": "63bbab1b793423001e28722e",
    "countryFullName": "Ireland",
    "totalMessages": 0,
    "advisorMatch": {}
  };

  static const Map<String, dynamic> publicQuestionClientWithQuestionProperties =
      {
    "_id": "63bbab1b793423001e28722e",
    "firstName": "Anabel",
    "lastName": "Rau",
    "zodiac": "capricorn",
    "birthdate": "1989-01-09T00:00:00.000Z",
    "gender": "female",
    "country": "IE",
    "isProfileCompleted": false,
    "questionsSubscription": {"active": false},
    "safeToSendEmail": false,
    "id": "63bbab1b793423001e28722e",
    "countryFullName": "Ireland",
    "totalMessages": 0,
    "advisorMatch": {
      "offer": "Purpose and Destiny",
      "advisorType": "Keep it real"
    }
  };

  static const Map<String, dynamic> emptyClientNote = {"content": ""};

  static const Map<String, dynamic> publicQuestion = {
    "clientInformation": {
      "birthdate": "1989-01-09T00:00:00.000Z",
      "zodiac": "capricorn",
      "gender": "female",
      "country": "IE",
      "firstName": "Anabel",
      "lastName": "Rau"
    },
    "takenDate": null,
    "startAnswerDate": null,
    "readByAdvisor": true,
    "_id": "63bbab87ea0df2001dce8630",
    "clientID": "63bbab1b793423001e28722e",
    "language": "en",
    "type": "PUBLIC",
    "content": "We need to override the auxiliary PCI monitor!",
    "attachments": [],
    "clientName": "Anabel Rau",
    "status": "OPEN",
    "likes": [],
    "createdAt": "2023-01-09T05:52:07.143Z",
    "updatedAt": "2023-01-09T07:47:03.220Z",
    "expertID": null
  };

  static const Map<String, dynamic> successTakenQuestion = {
    "clientInformation": {
      "birthdate": "1989-01-09T00:00:00.000Z",
      "zodiac": "capricorn",
      "gender": "female",
      "country": "IE"
    },
    "deleted": false,
    "takenDate": "2023-01-10T11:21:31.519Z",
    "startAnswerDate": null,
    "readByAdvisor": true,
    "_id": "63bbab87ea0df2001dce8630",
    "clientID": "63bbab1b793423001e28722e",
    "language": "en",
    "type": "PUBLIC",
    "content": "We need to override the auxiliary PCI monitor!",
    "attachments": [],
    "clientName": "Anabel Rau",
    "storyID": "63bbab83793423001e28724b",
    "deviceOS": "ios",
    "status": "TAKEN",
    "purchaseID": "63bbab87ea0df2001dce8623",
    "likes": [],
    "createdAt": "2023-01-09T05:52:07.143Z",
    "updatedAt": "2023-01-10T11:21:31.520Z",
    "__v": 0,
    "expertID":
        "39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b"
  };

  static const Map<String, dynamic> questionWasAlreadyTaken = {
    "status": "The question was already taken",
    "payload": {
      "questionID": "63bbab87ea0df2001dce8630",
      "questionToTake": {
        "clientInformation": {
          "birthdate": "1989-01-09T00:00:00.000Z",
          "zodiac": "capricorn",
          "gender": "female",
          "country": "IE"
        },
        "deleted": false,
        "takenDate": "2023-01-10T11:37:11.248Z",
        "startAnswerDate": null,
        "readByAdvisor": true,
        "_id": "63bbab87ea0df2001dce8630",
        "clientID": "63bbab1b793423001e28722e",
        "language": "en",
        "type": "PUBLIC",
        "content": "We need to override the auxiliary PCI monitor!",
        "attachments": [],
        "clientName": "Anabel Rau",
        "storyID": "63bbab83793423001e28724b",
        "deviceOS": "ios",
        "status": "TAKEN",
        "purchaseID": "63bbab87ea0df2001dce8623",
        "likes": [],
        "createdAt": "2023-01-09T05:52:07.143Z",
        "updatedAt": "2023-01-10T11:37:11.249Z",
        "__v": 0,
        "expertID":
            "0ba684917ad77d2b7578d7f8b54797ca92c329e80898ff0fb7ea480d32bcb090"
      },
      "advisorId":
          "39726a57734b49a530639cc8115eb863e3f064fc16c2955384770462efb5e44b"
    }
  };

  static const Map<String, dynamic> ritualQuestionClient = {
    "questionsSubscription": {"status": 3, "active": true},
    "_id": "5f5224f45a1f7c001c99763c",
    "zodiac": "aquarius",
    "country": "BR",
    "birthdate": "1989-02-07T00:00:00.000Z",
    "firstName": "Hope",
    "gender": "non_gender",
    "lastName": "Fortunikovna",
    "isProfileCompleted": false,
    "safeToSendEmail": false,
    "id": "5f5224f45a1f7c001c99763c",
    "countryFullName": "Brazil",
    "totalMessages": 551,
    "advisorMatch": {
      "offer": "Purpose and Destiny",
      "advisorType": "Keep it real"
    }
  };

  static const Map<String, dynamic> ritualLoveCrushReadingQuestion = {
    "totalQuestions": 1,
    "leftQuestions": 0,
    "_id": "62de59dd510689001ddb8090",
    "status": "FAILED",
    "identifier": "lovecrushreading",
    "clientName": "Hope Fortunikovna",
    "language": "en",
    "inputFieldsData": [
      {
        "_id": "62de59dd510689001ddb8098",
        "inputField": {
          "version": 1,
          "_id": "5a37df8618b38e2069ee8657",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
          "placeholderText": "First Name",
          "subType": "firstName",
          "type": "text",
          "id": "5a37df8618b38e2069ee8657"
        },
        "value": "Test",
        "__v": 0,
        "id": "62de59dd510689001ddb8098"
      },
      {
        "_id": "62de59dd510689001ddb8099",
        "inputField": {
          "version": 1,
          "_id": "5a37dfa018b38e2069ee8658",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
          "placeholderText": "Last Name",
          "subType": "lastName",
          "type": "text",
          "id": "5a37dfa018b38e2069ee8658"
        },
        "value": "Test",
        "__v": 0,
        "id": "62de59dd510689001ddb8099"
      },
      {
        "_id": "62de59dd510689001ddb809a",
        "inputField": {
          "version": 1,
          "_id": "5a37e00918b38e2069ee8659",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/cake.png",
          "placeholderText": "Date of Birth",
          "subType": "birthdate",
          "type": "date",
          "id": "5a37e00918b38e2069ee8659"
        },
        "value": "2004-07-01",
        "__v": 0,
        "id": "62de59dd510689001ddb809a"
      },
      {
        "_id": "62de59dd510689001ddb809b",
        "inputField": {
          "version": 1,
          "_id": "5a37e03018b38e2069ee865a",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+5.png",
          "placeholderText": "Gender",
          "subType": "gender",
          "type": "dropdown",
          "id": "5a37e03018b38e2069ee865a"
        },
        "value": "female",
        "__v": 0,
        "id": "62de59dd510689001ddb809b"
      }
    ],
    "createdAt": "2022-07-25T08:52:45.642Z",
    "sortDate": "2022-07-25T08:52:45.695Z",
    "isDeleted": false,
    "isOpen": false,
    "isCancelled": false,
    "isInitialized": false,
    "canBeDeleted": false,
    "id": "62de59dd510689001ddb8090",
    "story": {
      "questions": [
        {
          "clientInformation": {
            "birthdate": "1989-01-07T00:00:00.000Z",
            "zodiac": "capricorn",
            "gender": "female",
            "country": "DE"
          },
          "startAnswerDate": "2023-01-03T15:53:46.129Z",
          "_id": "62de59dd510689001ddb8094",
          "type": "RITUAL",
          "content": "Test",
          "attachments": [],
          "status": "OPEN",
          "createdAt": "2022-07-25T08:52:45.695Z",
          "updatedAt": "2023-01-03T15:53:46.134Z"
        }
      ],
      "answers": []
    },
    "updatedAt": "2022-07-25T08:52:45.705Z",
    "clientInformation": {
      "birthdate": "1989-02-07T00:00:00.000Z",
      "zodiac": "aquarius",
      "gender": "non_gender",
      "country": "BR",
      "firstName": "Hope",
      "lastName": "Fortunikovna"
    },
    "clientID": "5f5224f45a1f7c001c99763c"
  };

  static const Map<String, dynamic> ritualAuraReadingQuestion = {
    "totalQuestions": 1,
    "leftQuestions": 0,
    "_id": "62de35bcb584e9001e590d7d",
    "status": "ADVISOR",
    "identifier": "aurareading",
    "clientName": "Maryna Test",
    "language": "en",
    "inputFieldsData": [
      {
        "_id": "62de35bcb584e9001e590d7e",
        "inputField": {
          "version": 1,
          "_id": "5a37df8618b38e2069ee8657",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
          "placeholderText": "First Name",
          "subType": "firstName",
          "type": "text",
          "id": "5a37df8618b38e2069ee8657"
        },
        "value": "Maryna",
        "__v": 0,
        "id": "62de35bcb584e9001e590d7e"
      },
      {
        "_id": "62de35bcb584e9001e590d7f",
        "inputField": {
          "version": 1,
          "_id": "5a37dfa018b38e2069ee8658",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+6.png",
          "placeholderText": "Last Name",
          "subType": "lastName",
          "type": "text",
          "id": "5a37dfa018b38e2069ee8658"
        },
        "value": "Test",
        "__v": 0,
        "id": "62de35bcb584e9001e590d7f"
      },
      {
        "_id": "62de35bcb584e9001e590d80",
        "inputField": {
          "version": 1,
          "_id": "5a37e00918b38e2069ee8659",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/cake.png",
          "placeholderText": "Date of Birth",
          "subType": "birthdate",
          "type": "date",
          "id": "5a37e00918b38e2069ee8659"
        },
        "value": "1989-01-07T00:00:00.000Z",
        "__v": 0,
        "id": "62de35bcb584e9001e590d80"
      },
      {
        "_id": "62de35bcb584e9001e590d81",
        "inputField": {
          "version": 1,
          "_id": "5a37e03018b38e2069ee865a",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/Asset+5.png",
          "placeholderText": "Gender",
          "subType": "gender",
          "type": "dropdown",
          "id": "5a37e03018b38e2069ee865a"
        },
        "value": "female",
        "__v": 0,
        "id": "62de35bcb584e9001e590d81"
      },
      {
        "_id": "62de35bcb584e9001e590d8b",
        "inputField": {
          "version": 1,
          "_id": "619f8a415d584a0097ea7fa9",
          "optional": false,
          "placeholderImage":
              "https://s3.eu-central-1.amazonaws.com/fortunica-data/input-fields/camera.png",
          "placeholderText": "Full body",
          "subType": "aura",
          "type": "image",
          "__v": 0,
          "id": "619f8a415d584a0097ea7fa9"
        },
        "value": ritualImageUrl,
        "__v": 0,
        "id": "62de35bcb584e9001e590d8b"
      },
      {
        "_id": "62de35bcb584e9001e590d89",
        "inputField": {
          "version": 1,
          "_id": "619f8a415d584a0097ea7fca",
          "optional": false,
          "placeholderImage": " ",
          "placeholderText": "Your face",
          "subType": "aura",
          "type": "image",
          "__v": 0,
          "id": "619f8a415d584a0097ea7fca"
        },
        "value": ritualImageUrl,
        "__v": 0,
        "id": "62de35bcb584e9001e590d89"
      }
    ],
    "createdAt": "2022-07-25T06:18:36.522Z",
    "sortDate": "2022-07-25T06:18:42.278Z",
    "isDeleted": false,
    "isOpen": false,
    "isInitialized": false,
    "canBeDeleted": false,
    "id": "62de35bcb584e9001e590d7d",
    "story": {
      "questions": [
        {
          "clientInformation": {
            "birthdate": "1989-01-07T00:00:00.000Z",
            "zodiac": "capricorn",
            "gender": "female",
            "country": "DE"
          },
          "startAnswerDate": null,
          "_id": "62de35c2b584e9001e590daf",
          "type": "RITUAL",
          "content":
              "Aut et voluptatem consequatur ad officiis sint voluptatibus inventore. Aut facilis totam est. Cum et ipsa odio officia id quia velit voluptates iure. Et est qui blanditiis quasi error in aut occaecati. Laboriosam earum ipsam voluptatum amet deserunt.",
          "attachments": [],
          "status": "OPEN",
          "createdAt": "2022-07-25T06:18:42.278Z",
          "updatedAt": "2022-10-12T12:42:44.793Z"
        }
      ],
      "answers": []
    },
    "updatedAt": "2022-07-25T06:18:42.289Z",
    "clientInformation": {
      "birthdate": "1989-02-07T00:00:00.000Z",
      "zodiac": "aquarius",
      "gender": "non_gender",
      "country": "BR",
      "firstName": "Hope",
      "lastName": "Fortunikovna"
    },
    "clientID": "5f5224f45a1f7c001c99763c"
  };

  static const Map<String, dynamic> historyResponse = {
    "data": [
      {
        "_id": "62e228a4b584e9001e593860",
        "answer": {
          "_id": "63975da8e0e83f001d48dff1",
          "content": "dsfsdfdsf aefeaf",
          "attachments": [],
          "type": "TEXT_ANSWER",
          "createdAt": "2022-12-12T16:58:16.574Z"
        },
        "question": {
          "_id": "62e228a4b584e9001e593860",
          "clientID": "5f5224f45a1f7c001c99763c",
          "clientName": "Hope Fortunikovna",
          "createdAt": "2022-07-28T06:11:48.862Z",
          "clientInformation": {
            "birthdate": "1989-02-07T00:00:00.000Z",
            "zodiac": "aquarius",
            "gender": "non_gender",
            "country": "BR"
          },
          "content":
              "Dolor debitis est inventore ex sint molestiae aliquam. Accusantium id quisquam. Consectetur enim animi voluptas velit praesentium. Consectetur adipisci omnis similique voluptatem. Ea et quidem totam quia sunt aut. Temporibus ipsam nam.",
          "attachments": [],
          "type": "PUBLIC",
          "storyID": "62e228a4b584e9001e59385e"
        }
      },
      {
        "_id": "62e228a4b584e9001e593860",
        "answer": {
          "_id": "63975da8e0e83f001d48dff1",
          "content": "dsfsdfdsf aefeaf",
          "attachments": [],
          "type": "TEXT_ANSWER",
          "createdAt": "2022-12-12T16:58:16.574Z"
        },
        "question": {
          "_id": "62e228a4b584e9001e593860",
          "clientID": "5f5224f45a1f7c001c99763c",
          "clientName": "Hope Fortunikovna",
          "createdAt": "2022-07-28T06:11:48.862Z",
          "clientInformation": {
            "birthdate": "1989-02-07T00:00:00.000Z",
            "zodiac": "aquarius",
            "gender": "non_gender",
            "country": "BR"
          },
          "content":
              "Dolor debitis est inventore ex sint molestiae aliquam. Accusantium id quisquam. Consectetur enim animi voluptas velit praesentium. Consectetur adipisci omnis similique voluptatem. Ea et quidem totam quia sunt aut. Temporibus ipsam nam.",
          "attachments": [],
          "type": "PUBLIC",
          "storyID": "62e228a4b584e9001e59385e"
        }
      },
      {
        "_id": "62e228a4b584e9001e593860",
        "answer": {
          "_id": "63975da8e0e83f001d48dff1",
          "content": "dsfsdfdsf aefeaf",
          "attachments": [],
          "type": "TEXT_ANSWER",
          "createdAt": "2022-12-12T16:58:16.574Z"
        },
        "question": {
          "_id": "62e228a4b584e9001e593860",
          "clientID": "5f5224f45a1f7c001c99763c",
          "clientName": "Hope Fortunikovna",
          "createdAt": "2022-07-28T06:11:48.862Z",
          "clientInformation": {
            "birthdate": "1989-02-07T00:00:00.000Z",
            "zodiac": "aquarius",
            "gender": "non_gender",
            "country": "BR"
          },
          "content":
              "Dolor debitis est inventore ex sint molestiae aliquam. Accusantium id quisquam. Consectetur enim animi voluptas velit praesentium. Consectetur adipisci omnis similique voluptatem. Ea et quidem totam quia sunt aut. Temporibus ipsam nam.",
          "attachments": [],
          "type": "PUBLIC",
          "storyID": "62e228a4b584e9001e59385e"
        }
      },
      {
        "_id": "62e228a4b584e9001e593860",
        "answer": {
          "_id": "63975da8e0e83f001d48dff1",
          "content": "dsfsdfdsf aefeaf",
          "attachments": [],
          "type": "TEXT_ANSWER",
          "createdAt": "2022-12-12T16:58:16.574Z"
        },
        "question": {
          "_id": "62e228a4b584e9001e593860",
          "clientID": "5f5224f45a1f7c001c99763c",
          "clientName": "Hope Fortunikovna",
          "createdAt": "2022-07-28T06:11:48.862Z",
          "clientInformation": {
            "birthdate": "1989-02-07T00:00:00.000Z",
            "zodiac": "aquarius",
            "gender": "non_gender",
            "country": "BR"
          },
          "content":
              "Dolor debitis est inventore ex sint molestiae aliquam. Accusantium id quisquam. Consectetur enim animi voluptas velit praesentium. Consectetur adipisci omnis similique voluptatem. Ea et quidem totam quia sunt aut. Temporibus ipsam nam.",
          "attachments": [],
          "type": "PUBLIC",
          "storyID": "62e228a4b584e9001e59385e"
        }
      },
    ],
    "hasMore": false,
    "lastItem": "62d105728e240d001ff91e11"
  };

  static const Map<String, dynamic> emptyHistoryResponse = {
    "data": [],
    "hasMore": false
  };
}
