class GenerationRequest {
  final String templateType;
  final Map<String, Object> data;

  GenerationRequest({required this.templateType, required this.data});

  Map<String, dynamic> toJson() => {'templateType': templateType, 'data': data};
}
