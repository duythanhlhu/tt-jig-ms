// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get starting => '시작 중';

  @override
  String get checkingVersion => '버전 확인 중..';

  @override
  String get newVersionAvailable => '새 버전이 제공됩니다 (버전 %s). 새 버전으로 업데이트하십시오.';

  @override
  String get update => '업데이트';

  @override
  String get cancel => '취소';

  @override
  String get uptodate => '좋습니다! 앱이 최신 상태입니다!';

  @override
  String get somethingWrong => '문제가 발생했습니다';

  @override
  String get downloading => '다운로드 중';

  @override
  String get downloaded => '다운로드 완료';

  @override
  String get confirm => '확인';

  @override
  String get init => '초기화';

  @override
  String get cameraGranted => '카메라 권한 허용됨';

  @override
  String get cameraDenied => '카메라 권한 거부됨';

  @override
  String get cameraDeniedPermanent => '카메라 권한이 영구적으로 거부됨';

  @override
  String get cameraNotGrant => '사용자가 카메라 권한을 승인하지 않았습니다!';

  @override
  String get micGranted => '마이크 권한 허용됨';

  @override
  String get micDenied => '마이크 권한 거부됨';

  @override
  String get micDeniedPermanent => '마이크 권한이 영구적으로 거부됨';

  @override
  String get errorPemission => '권한 요청 오류: %s';

  @override
  String get connectionGone => '연결이 끊겼습니다. 인터넷 연결을 확인해 주세요!';

  @override
  String get cantReach => '웹사이트에 연결할 수 없습니다.';

  @override
  String get retry => '재시도';

  @override
  String get welcome => '환영합니다';

  @override
  String get loginState => '세션을 시작하려면 로그인하세요';

  @override
  String get employeeId => '사원 번호';

  @override
  String get password => '비밀번호';

  @override
  String get rememberMe => '사용자 기억하기';

  @override
  String get login => '로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get noAccount => '계정이 없으신가요?\nIT 팀에 문의하십시오.';

  @override
  String get todayReport => '오늘의 보고서';

  @override
  String get mainMenu => '메인 메뉴';

  @override
  String get building => '건물';

  @override
  String get incomingItem => '입고 항목';

  @override
  String get outgoingItem => '출고 항목';

  @override
  String get rack => '랙';

  @override
  String get move => '이동';

  @override
  String get inventory => '재고';

  @override
  String get stockOnHand => '현재 재고';

  @override
  String get rackMonitoring => '랙 모니터링';

  @override
  String get items => '항목';

  @override
  String get returnItem => '반품 항목';

  @override
  String get barcodeInfo => '바코드 정보';

  @override
  String get destroyItem => '폐기 항목';

  @override
  String get stockOpname => '재고 조사';

  @override
  String get allData => '모든 데이터';

  @override
  String get inProcess => '입고';

  @override
  String get outProcess => '출고';

  @override
  String get returnProcess => '반품';

  @override
  String get outgoingTransc => '출고 거래';

  @override
  String get handOver => '인계';

  @override
  String get outDate => '출고일';

  @override
  String get senderId => '발신자 ID';

  @override
  String get receiverId => '수신자 ID';

  @override
  String get scan => '스캔';

  @override
  String get scanBox => '박스 스캔';

  @override
  String get scanItem => '항목 스캔';

  @override
  String get scanRack => '랙 스캔';

  @override
  String get save => '저장';

  @override
  String get moveTransc => '이동 거래';

  @override
  String get box => '박스';

  @override
  String get item => '항목';

  @override
  String get labelId => '라벨 ID';

  @override
  String get desc => '상세 설명';

  @override
  String get boxName => '박스 이름';

  @override
  String get type => '유형';

  @override
  String get location => '위치';

  @override
  String get rackName => '랙 이름';

  @override
  String get group => '그룹';

  @override
  String get area => '구역';

  @override
  String get cell => '셀';

  @override
  String get number => '번호';

  @override
  String get oldLocationBoxId => '기존 위치 박스 ID';

  @override
  String get newLocationBoxId => '새 위치 박스 ID';

  @override
  String get returnTransc => '반품 거래';

  @override
  String get department => '부서';

  @override
  String get reason => '사유';

  @override
  String get returnType => '반품 유형';

  @override
  String get broken => '파손';

  @override
  String get model => '모델';

  @override
  String get part => '부품';

  @override
  String get tooling => '툴링';

  @override
  String get size => '규격';

  @override
  String get create => '생성';

  @override
  String get lastUpdate => '최종 업데이트';

  @override
  String get history => '이력';

  @override
  String get total => '합계';

  @override
  String get totalItems => '총 항목 수';

  @override
  String get destroy => '폐기';

  @override
  String get destroyTransc => '폐기 거래';

  @override
  String get search => '검색';

  @override
  String get dateTransc => '거래 날짜';

  @override
  String get fieldRequired => '이 필드는 필수입니다.';

  @override
  String get invalidLength => '잘못된 길이';

  @override
  String get loginFail => '사용자를 찾을 수 없거나 비밀번호가 잘못되었습니다!';

  @override
  String get monitoring => '모니터링';

  @override
  String get sewing => '봉제';

  @override
  String get report => '보고서';

  @override
  String get transactions => '거래 내역';

  @override
  String get transactionType => '거래 유형';

  @override
  String get transactionId => '거래 ID';

  @override
  String get newLocation => '새 위치';

  @override
  String get tools => '도구';

  @override
  String get createdBy => '작성자';

  @override
  String get createdAt => '작성일';

  @override
  String get filter => '필터';

  @override
  String get failed => '실패';

  @override
  String get select => '선택';

  @override
  String get deviceDiscovery => '장치 검색';

  @override
  String get scanning => '스캔 중';

  @override
  String get stop => '정지';

  @override
  String get scanDevices => '장치 스캔';

  @override
  String get foundDevice => '검색된 장치';

  @override
  String get pairedDevice => '연결된 장치 표시';

  @override
  String get unknownDevice => '알 수 없는 장치';

  @override
  String get transactionDate => '거래 날짜';

  @override
  String get sender => '발신자';

  @override
  String get receiver => '수신자';

  @override
  String get scanBarcode => '바코드 스캔';

  @override
  String get cancelScan => '스캔 취소';

  @override
  String get lineRemark => '라인 / 비고';

  @override
  String get woNumber => '작업 지시 번호';

  @override
  String get brokenDate => '파손일';

  @override
  String get returnDate => '사용 중지 날짜';

  @override
  String get fixedDate => '수리 완료일';

  @override
  String get info => '정보';

  @override
  String get ofItem => '/';

  @override
  String get maxItems => '최대 항목 수';

  @override
  String get maxBoxes => '최대 박스 수';

  @override
  String get updatedBy => '수정자';

  @override
  String get updatedAt => '수정일';

  @override
  String get rackLocation => '랙 위치';

  @override
  String get cellNo => '셀 번호';

  @override
  String get submit => '제출';

  @override
  String get change => '변경';

  @override
  String get onHand => '현재 보유 데이터';

  @override
  String get moveIn => '이동 입고';

  @override
  String get moveOut => '이동 출고';

  @override
  String get kukdong => '국동';

  @override
  String get scanMode => '스캔 모드';

  @override
  String get camera => '카메라';

  @override
  String get bluetooth => '블루투스';

  @override
  String get scanSenderId => '발신자 ID 스캔';

  @override
  String get cancelScanSenderId => '발신자 ID 스캔 취소';

  @override
  String get scanReceiverId => '수신자 ID 스캔';

  @override
  String get cancelscanReceiverId => '수신자 ID 스캔 취소';

  @override
  String get scanItemId => '항목 ID 스캔';

  @override
  String get scanBoxId => '박스 ID 스캔';

  @override
  String get scanRackId => '랙 ID 스캔';

  @override
  String get flashOn => '플래시 켜기';

  @override
  String get flashOff => '플래시 끄기';

  @override
  String get confirmation => '확인';

  @override
  String get clearList => '변경하시겠습니까?\n항목 목록이 초기화됩니다.';

  @override
  String get labelItemNotFound => '항목 라벨을 찾을 수 없습니다!';

  @override
  String get itemOutgoing => '이미 출고된 항목입니다!';

  @override
  String get itemNotGood => '항목 상태가 불량합니다!\n수리할 수 없습니다!';

  @override
  String get itemGood => '항목의 상태가 양호합니다!\n수리할 수 없습니다!';

  @override
  String get itemInhouse => '사내 보유 항목입니다!';

  @override
  String get itemDestroy => '이미 폐기된 항목입니다!';

  @override
  String get rackFull => '랙이 가득 찼습니다!';

  @override
  String get boxFull => '박스가 가득 찼습니다!';

  @override
  String get boxOverload => '대상 박스 용량 초과!';

  @override
  String get barcodeAlreadyIn => '목록에 이미 추가된 바코드입니다!';

  @override
  String get barcodeAlreadyScan => '이미 스캔된 바코드입니다!';

  @override
  String get labelBoxNotFound => '박스 라벨을 찾을 수 없습니다!';

  @override
  String get labelRackNotFound => '랙 라벨을 찾을 수 없습니다!';

  @override
  String get allItemSaved => '모든 항목이 성공적으로 저장되었습니다.';

  @override
  String get remove => '삭제';

  @override
  String get confirmRemove => '%s 데이터를 삭제하시겠습니까?';

  @override
  String get confirmSubmit => '이 거래를 저장하시겠습니까?';

  @override
  String get cancelSubmit => '이 거래를 취소하시겠습니까?';

  @override
  String get confirmLogout => '로그아웃하시겠습니까?';

  @override
  String get boxes => '박스';

  @override
  String get sameID => 'ID가 동일합니다. 다른 사원 번호를 사용하십시오!';

  @override
  String get employeeNotFound => '사원을 찾을 수 없습니다!';

  @override
  String get success => '성공';

  @override
  String get warning => '경고';

  @override
  String get error => '오류';

  @override
  String get style => '스타일';

  @override
  String get itemCode => '항목 코드';

  @override
  String get container => '컨테이너';

  @override
  String get from => '원천';

  @override
  String get requestId => '요청 ID';

  @override
  String get content => '내용';

  @override
  String get detail => '상세 정보';

  @override
  String get list => '목록';

  @override
  String get apply => '적용';

  @override
  String get reset => '초기화';

  @override
  String get filterOptions => '필터 옵션';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get date => '날짜';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get item2Box => '항목을 박스로';

  @override
  String get box2Rack => '박스를 랙으로';

  @override
  String get box2Box => '박스를 박스로';

  @override
  String get connected => '서버에 연결되었습니다.';

  @override
  String get notConnected => '서버에 연결되지 않았습니다.';

  @override
  String get notAvailable => '사용 불가';

  @override
  String get clear => '목록 비우기';

  @override
  String get cancelBoxId => '박스 ID 스캔 취소';

  @override
  String get cancelRackId => '랙 ID 스캔 취소';

  @override
  String get scanSenderID => '발신자 ID 스캔 중';

  @override
  String get scanReceiverID => '수신자 ID 스캔 중';

  @override
  String get scanItemID => '품목 ID 스캔 중';

  @override
  String get scanBoxID => '박스 ID 스캔 중';

  @override
  String get scanRackID => '랙 ID 스캔 중';

  @override
  String get waitScan => '스캐너 대기 중';

  @override
  String get connectionError => '인터넷 연결이 끊어졌습니다. 네트워크 상태를 확인하고 다시 시도해 주세요.';

  @override
  String get receiveTimeout => '서버가 응답하지 않습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get sendTimeout => '데이터 전송에 실패했습니다. 네트워크 연결을 확인해 주세요.';

  @override
  String get connectionTimeout => '연결 시간이 초과되었습니다. 네트워크가 느리거나 서버가 바쁩니다.';
}
