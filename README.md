# breed_identifier_app
An app that detects cat and dog breeds, created using Flutter.  
Author: Mohammed Ibrahim

App Demo Video: https://youtu.be/Pi-YZFMgXQo

***
NOTE: If you clone this repository and attempt to run it, you may run into issues regarding the plugins.  
This app uses the plugin "Tflite" which is deprecated with the later versions of Flutter and Android Studio.

To fix the issue with the Tflite plugin follow the steps below:
1. Run "flutter pub get" and get the dependencies required for the app.
2. From the project root, go to: "External Libraries" → "Flutter Plugins" → "tflite-1.1.2" → "android" → build.gradle (image below).
3. Once you have opened build.gradle, find the android {...} block.
4. Within the android {...} block, there is a dependencies {...} block.
5. Replace the dependencies {...} block with the following code:

    dependencies {  
        implementation 'org.tensorflow:tensorflow-lite:+'  
        implementation 'org.tensorflow:tensorflow-lite-gpu:+'  
    }

For more infor about tflite plugin, visit https://pub.dev/packages/tflite.
***

![tflite build gradle location](https://user-images.githubusercontent.com/44937151/213306152-6d997c51-f49a-429b-87f5-c8c152c6800f.jpg)
