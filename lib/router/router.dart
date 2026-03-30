enum NavigationRoute{
  pickerPage("/picker_page"),
  resultPage("/result_page");

  final String path;
  const NavigationRoute(this.path);
}