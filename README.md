# Kon Moaref
 
![top](https://user-images.githubusercontent.com/50237142/103490561-64648d80-4e25-11eb-9938-f8a84beec7a5.jpg)

This is a repository of [Kon Moaref (كن معرفا برسول الله )](https://play.google.com/store/apps/details?id=konMoarfan.rasoulallah.net&hl=ar&gl=US) Flutter version.

## Description 

A global project that begins preachers and rehabilitates young people to call to Islam and introduce the master of people, may God bless him and grant him peace, with various modern technologies.

The spirit of welcoming the deal on the same night is not confined to the call for modernization.

Introducing the prophet of mercy - may God bless him and grant him peace - in all different places and environments, whether virtual environments on the Internet or on the ground in any country and in any language.

Among the most important of these ideas, to arrive faster on social media platforms and communication programs, are the video promotional clips.

Front of the start from the beginning
You can get genera through the process of producing raw materials with great productivity, with great productivity and high quality, with which you can get different bodies

Allows you to design and extract social media advocacy videos
And you can also record propaganda audio clips and you can record them

## IOS
The application is published as Android app on Google's play store , I'll be working on the IOS version using Flutter.

## Project's main feature
- Rendering videos with audios using FFMPEG.

## Features :
The app is composed in 4 main parts :

**Category : **

- [x] Fetch data from backend server
- [x] Display data of each category - lang  
- [x] allow user to check the audio
- [x] Play sounds from url 
- [x] Display Duration of audio
- [x] Add on screen the audio selected
- [x] Search module of Categories 

**Recording :**

- [x] Allow user to record audio
- [x] Permissions for recording.
- [ ] Put duration of recording
- [x] When recording ends , list it below to choose.
- [ ] Add on screen the audio selected

**Upload Audio :**


Bugs & issues :
- [x] Playing one audio animates all play icon 
- [x] Listview kills the audio playing when scrolling

Switched to single child scroll view with column

- [x] Should stop the current playing if clicked on
- [x] If clicked on another item , it should stop the current and play the new one.
- [x] When switching languages , The url gives null at first (fetching categories) then gets the list.
- [ ] Loading of splash video gives null at beginning
- [ ] Loading of background video gives null at beginning
- [x] Categories section reloads every setState()
- [x]  Can't control single play button individually
- [x] Categories section reloads when moving the bottom menu.
- [x] App is so so so so slow (laggy) in release and debug due to future builders + consumer builders ( Use isolates)

Performance Tips : 
To use Future builder effeciently , pass it a function that return value only & not processing data.
For example :
Using this is not efficent.
```
Future<List<String>>> getData(){
 http request
 get Data
 return data as list
 }

 
FutureBuilder(
future:getData
builder : ...
)
```

Future builder rebuilds up to 60 times per second ( I don't know why , even in docs it's said that futurebuilder rebuilds only when data changes)

Also , Using Consumer (Provider package) to the whole DataProvider class isnt efficent. 
The consumer detects any change in the whole class then rebuilds the widgets.
