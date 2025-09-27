import 'package:flutter/material.dart';
import 'package:team_project_front/common/const/colors.dart';

class SubscribeScreen extends StatelessWidget {
  const SubscribeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '맘편해 멤버십',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff64CCC5).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '맘편해 케어멤버십으로',
                    style: TextStyle(
                      color: HIGH_FEVER_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const Text(
                    '우리 아이 건강, 한층 더 안심되게',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '맘편해 케어멤버십은',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _Tag('실시간 체온 모니터링'),
                      _Tag('발열 리포트 생성'),
                      _Tag('방 온습도 체크'),
                      _Tag('디바이스 대여'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '다양한 기능과 혜택을 담은\n멤버십 서비스입니다.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // ------------------- 2. 멤버십 혜택 -------------------
            Container(
              color: const Color(0xffF0F1F5),
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '한눈에 보는 ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '멤버십 혜택',
                            style: TextStyle(
                              color: HIGH_FEVER_COLOR,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _BenefitItem(
                    number: '01',
                    title: '디바이스 대여',
                    description: '영유아의 체온 · 온습도 자동 측정',
                  ),
                  _BenefitItem(
                    number: '02',
                    title: '실시간 체온 모니터링',
                    description: '영유아 고열 발생 시 알림 제공',
                  ),
                  _BenefitItem(
                    number: '03',
                    title: '방 온습도 체크',
                    description: '맞춤 온습도 추천 및 조절 알림 제공',
                  ),
                  _BenefitItem(
                    number: '04',
                    title: '홈캠 기능 제공',
                    description: '움직임 감지 · 화면 녹화 및 체온 측정',
                  ),
                  _BenefitItem(
                    number: '05',
                    title: '발열 리포트 생성(P)',
                    description: '진료 시 의료진에게 전달할 리포트 제공',
                  ),
                ],
              ),
            ),

            // ------------------- 3. 주의 사항 -------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '주의 사항',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 12),
                  _CheckItem('멤버십을 구독하지 않으면 기존 기능/서비스를 사용할 수 없습니다.'),
                  SizedBox(height: 12),
                  _CheckItem('프리미엄 멤버십은 추가적인 혜택을 제공하는 서비스입니다.'),
                  SizedBox(height: 12),
                  _CheckItem('프리미엄 멤버십은 선택사항이며, 구독 시 맘편해 운영에 큰 도움이 됩니다.'),
                ],
              ),
            ),

            // ------------------- 4. 요금제 -------------------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff64CCC5).withValues(alpha: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 100,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MAIN_COLOR,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      '맘편해 멤버십',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: _PlanCard(
                          title: 'Basic',
                          price: '월 24,900원',
                          features: [
                            '디바이스 대여',
                            '실시간 체온 모니터링',
                            '방 온습도 체크',
                            '홈캠 제공',
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _PlanCard(
                          title: 'Premium',
                          price: '월 29,900원',
                          features: [
                            '디바이스 대여',
                            '실시간 체온 모니터링',
                            '방 온습도 체크',
                            '홈캠 제공',
                            '발열 리포트',
                          ],
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'FAQ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _FAQItem(
                    question: 'Q: 디바이스는 어떤 기능이 있나요?',
                    answer:
                        'A: 맘편해 전용 디바이스는 아이의 체온뿐 아니라, 방의 온습도까지 실시간으로 측정해주는 스마트 모니터링 기기예요.',
                  ),
                  const _FAQItem(
                    question: 'Q: 프리미엄 멤버십에 포함된 발열 리포트는 어떤 기능인가요?',
                    answer:
                        'A: 발열리포트는 아이의 체온 변화를 자동으로 기록하고, 리포트 형태로 정리해주는 서비스예요.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ------------------- 6. 결제 유의사항 -------------------
            Container(
              color: Colors.grey.shade400, // 원하는 배경색
              child: Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      '결제 유의사항',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '1. 상기 구독료 베이직 24,900원, 프리미엄 29,900원은 VAT 포함 기준입니다.\n'
                      '2. 월 구독 상품으로 첫 결제일과 동일한 날짜에\n 매월 자동 결제됩니다.\n'
                      '3. 회원님은 언제든지 해지할 수 있습니다.\n 해지 시 다음 결제일부터는 청구되지 않습니다.\n'
                      '4. 환불은 구글플레이/앱스토어 정책을 따릅니다.\n'
                      '5. 취소/환불 문의는 담당자 이메일로 연락해 주세요.',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ------------------- 7. 결제 버튼 -------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 민트색 큰 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff64CCC5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        '맘편해 멤버십 시작하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // 약관 안내 문구
                SizedBox(
                  width: 380,
                  child: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '매월 정기 결제됨을 확인하고 ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '이용약관',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: '에 동의하는 것으로 간주합니다.',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// 컴포넌트

class _Tag extends StatelessWidget {
  final String label;
  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MAIN_COLOR,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  const _BenefitItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Text(number, style: const TextStyle(color: Colors.black)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_box, color: Colors.redAccent, size: 24),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool highlight;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? MAIN_COLOR : Colors.white,
          border: Border.all(
            color: highlight ? MAIN_COLOR : Colors.grey.shade300,
            width: highlight ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 17),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  features
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            f,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  f.contains('발열 리포트')
                                      ? Colors.red
                                      : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(answer),
        ],
      ),
    );
  }
}
