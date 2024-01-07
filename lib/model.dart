class Modelgenerated {
  List<String>? domains;
  String? name;
  String? alphaTwoCode;
  List<String>? webPages;
  Null? stateProvince;
  String? country;

  Modelgenerated(
      {this.domains,
        this.name,
        this.alphaTwoCode,
        this.webPages,
        this.stateProvince,
        this.country});

  Modelgenerated.fromJson(Map<String, dynamic> json) {
    domains = json['domains'].cast<String>();
    name = json['name'];
    alphaTwoCode = json['alpha_two_code'];
    webPages = json['web_pages'].cast<String>();
    stateProvince = json['state-province'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domains'] = this.domains;
    data['name'] = this.name;
    data['alpha_two_code'] = this.alphaTwoCode;
    data['web_pages'] = this.webPages;
    data['state-province'] = this.stateProvince;
    data['country'] = this.country;
    return data;
  }
}