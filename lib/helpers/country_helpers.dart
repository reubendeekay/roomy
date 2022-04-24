
String countryAbbrevation(String country) {
  if (country.toLowerCase() == 'kenya') {
    return 'KE';
  }
  if (country.toLowerCase() == 'tanzania') {
    return 'TZ';
  }
  if (country.toLowerCase() == 'uganda') {
    return 'UG';
  }
  if (country.toLowerCase() == 'ethiopia') {
    return 'ETH';
  }
  return country.substring(0, 2);
}

String dayFormat(String day) {
  if (day.endsWith('1') && !day.endsWith('11')) {
    return '1st';
  } else if (day.endsWith('2') && !day.endsWith('12')) {
    return '2nd';
  } else if (day.endsWith('3') && !day.endsWith('13')) {
    return '3rd';
  } else
    return 'th';
}
