/// Encodes params into a string \<key>=\<value>
String encodeParams(Map<String, String> params) {
  return params.entries
    .map((entry) => "${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}")
    .join("&")
  ;
}
