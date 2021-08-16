extension RemoveSalah on String {
  String remover() {
    return this.replaceAll('صلى الله عليه وسلم', '').replaceAll('ﷺ', '');
  }
}
