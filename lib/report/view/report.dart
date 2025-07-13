import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:team_project_front/common/const/base_url.dart';
import 'package:team_project_front/common/const/colors.dart';
import 'package:team_project_front/report/component/report_card.dart';
import 'package:team_project_front/report/model/report_info.dart';
import 'package:team_project_front/report/view/change_report.dart';
import 'package:team_project_front/report/view/create_report.dart';
import 'package:team_project_front/report/view/result_report.dart';
import 'package:team_project_front/settings/component/custom_appbar.dart';

class Report extends StatefulWidget {
  // final int childId;

  const Report({
    // required this.childId,
    super.key,
  });

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  List<ReportInfo> reportData = [];

  final List<String> allSymptoms = [
    '발열', '구토', '경련', '코피', '설사',
    '피부 발진', '실신', '호흡 곤란', '기침', '콧물', '황달'
  ];

  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasNext = true;
  int cursor = 0;
  final int pageSize = 10;

  // 임시 Access Token (추후 FlutterSecureStorage 등으로 교체 예정)
  final String accessToken = 'Bearer ACCESS_TOKEN';

  // 홈화면에서 아이 선택 후 리포트 생성할 것이므로
  // childId는 현재 임의로 설정
  late final int childId = 28;

  @override
  void initState() {
    super.initState();
    loadReports();

    // childId = widget.childId; => 홈화면과 연결 시 주석 없앨 예정

    _scrollController.addListener(() {
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if(!isLoading && hasNext) {
          loadReports();
        }
      }
    });
  }

  void loadReports() async {
    if (isLoading || !hasNext) return;

    setState(() => isLoading = true);

    final response = await fetchReportList(
      childId: childId,
      cursor: cursor,
      size: pageSize,
      accessToken: accessToken,
    );
    setState(() {
      reportData.addAll(response.reports);
      isLoading = false;
      cursor = response.cursor;
      hasNext = response.hasNext;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> deleteReport({
    required int reportId,
    required String accessToken,
  }) async {
    final dio = Dio();

    try {
      final resp = await dio.delete(
        '$base_URL/reports/$reportId',
        options: Options(
          headers: {
            'Authorization': accessToken
          },
        ),
      );

      if (resp.statusCode == 204 || resp.data['isSuccess'] == true) {
        print('삭제 완료: ${resp.data['result']}');
        return true;
      } else {
        print('삭제 실패: ${resp.data['message']}');
        return false;
      }
    } catch(e) {
      print('리포트 삭제 실패: $e');
      return false;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy년 M월 d일').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CreateReport())
          );
        },
        elevation: 0,
        backgroundColor: Colors.white,
        highlightElevation: 0,
        child: Icon(
          size: 60,
          Icons.add_circle,
          color: MAIN_COLOR,
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: CustomAppbar(
          title: '발열 리포트',
        ),
      ),
        body: reportData.isEmpty
            ? Center(
          child: Text(
            '생성된 발열 리포트가 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          itemCount: reportData.length + (hasNext ? 1 : 0),
          itemBuilder: (context, index) {
            if(index == reportData.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final report = reportData[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: HIGH_FEVER_COLOR,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) async {
                final success = await deleteReport(
                  reportId: report.reportId,
                  accessToken: accessToken,
                );

                if (success) {
                  setState(() {
                    reportData.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("삭제되었습니다.")),
                  );
                } else {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("삭제에 실패했습니다.")),
                  );
                }
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ResultReport(
                        reportId: report.reportId,
                        report: report,
                        allSymptoms: allSymptoms,
                      ),
                    ),
                  );
                },
                child: ReportCard(
                  createdAt: formatDate(report.createdAt),
                  content: report.symptoms.join(', '),
                  onEditPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChangeReport(report: report),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
    );
  }
}

class PaginatedReportResponse {
  final List<ReportInfo> reports;
  final bool hasNext;
  final int cursor;

  PaginatedReportResponse({
    required this.reports,
    required this.hasNext,
    required this.cursor,
  });
}

Future<PaginatedReportResponse> fetchReportList({
  required int childId,
  required int cursor,
  required int size,
  required String accessToken,
}) async {
  final dio = Dio();

  try {
    final resp = await dio.get(
      'https://momfy.kr/api/reports/list/$childId',
      queryParameters: {
        'cursor': cursor,
        'size': size,
      },
      options: Options(
        headers: {
          'Authorization': accessToken,
        },
      ),
    );

    final result = resp.data['result'];
    final List reportList = result['feverReports'];

    final reports = reportList.map((e) {
      return ReportInfo(
        reportId: e['reportId'],
        childId: childId,
        createdAt: DateTime.parse(e['createdAt']),
        symptoms: List<String>.from(
          (e['symptoms'] as List).map((s) => s.replaceAll('_', ' ')),
        ),
        etcSymptom: e['etc_symptom'] ?? '',
        outingRecord: e['outing'] ?? '',
        illnessTypes: [],
      );
    }).toList();

    return PaginatedReportResponse(
      reports: reports,
      hasNext: result['hasNext'] ?? false,
      cursor: result['cursor'] ?? cursor,
    );
  } catch (e) {
    print('리포트 목록 불러오기 실패: $e');
    return PaginatedReportResponse(reports: [], hasNext: false, cursor: cursor);
  }
}
