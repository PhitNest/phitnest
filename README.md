# Firebase Personal Instance Setup

1. Create a firebase project https://console.firebase.google.com

2. Create an Android app on the firebase console, download the google-services.json and place it in the android/app directory.

3. Create an iOS app on the firebase console, no need to download the GoogleService-Info.plist file.

4. Open a terminal. In the phitnest-app directory:
    1. ```dart pub global activate flutterfire_cli```
    2. ```flutterfire configure```
    3. Select (with space) android and iOS, then submit (with enter)

5. Open android/app/build.gradle and ensure the following is present: ```apply plugin: ‘com.google.gms.google-services’```
    (If it is present more than once in the file, delete the additional instances.)

6. Back in firebase console, click authentication and enable authentication for email/password. Then, click on firestore database and enable firestore database.

7. On firestore database, go to rules and replace the current script with the script below:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    allow read, write: if request.auth != null;

    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
      allow read: if resource.data.showMe;
    }
    
    match /swipes/{swipeId=**} {
    	allow read: if request.auth.uid == resource.data.user1 || 
      	  request.auth.uid == resource.data.user2;
    }
    
    match /channel_participation/{docId} {
    	allow read: if request.auth.uid == resource.data.user;
    }
    
    match /reports/{reportId} {
    	allow read: if request.auth.uid == resource.data.source ||
          request.auth.uid == resource.data.dest;
    }
    
    match /subscriptions/{userId} {
    	allow delete: if request.auth.uid == userId;
    }
    
    match /swipe_counts/{userId} {
    	allow delete: if request.auth.uid == userId;
    }
  }
}
```
