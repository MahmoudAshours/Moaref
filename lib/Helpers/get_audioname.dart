class FormattedAudioName {
  static String? cloudAudioName(String? audioName) => audioName == null
      ? ''
      : audioName.contains('/')
          ? audioName.contains(RegExp("^[a-zA-Z0-9]*\$"))
              ? audioName.toString().split('/')[8]
              : Uri.decodeComponent(audioName.toString().split('/')[8])
          : audioName;

  static String? cloudAudioCategory(String? audioName) => audioName == null
      ? ''
      : audioName.contains('/')
          ? audioName.contains(RegExp("^[a-zA-Z0-9]*\$"))
              ? audioName.toString().split('/')[7]
              : Uri.decodeComponent(audioName.toString().split('/')[7])
          : audioName;
 
}
