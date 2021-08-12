class FormattedAudioName {
  static String? cloudAudioName(String? audioName) => audioName == null
      ? ''
      : audioName.contains('/')
          ? audioName.contains(RegExp("^[a-zA-Z0-9]*\$"))
              ? audioName.toString().split('/')[8]
              : Uri.decodeComponent(audioName.toString().split('/')[8])
          : audioName;
}
