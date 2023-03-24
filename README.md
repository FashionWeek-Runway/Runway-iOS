# Runway-iOS
- 온라인과 오프라인을 연결해주는 O4O 서비스
- 오프라인 쇼핑 지도를 통해, 오프라인 쇼핑을 원하는 사용자에게 편리한 서비스를 제공합니다.

<a href="https://apps.apple.com/us/app/%EB%9F%B0%EC%9B%A8%EC%9D%B4-runway-%EB%82%B4-%EC%86%90-%EC%95%88%EC%9D%98-%EA%B0%84%ED%8E%B8%ED%95%9C-%ED%8C%A8%EC%85%98-%EC%87%BC%ED%95%91-%EC%A7%80%EB%8F%84/id1671808515">
 <img src = "https://user-images.githubusercontent.com/69136340/165884844-de14d6f9-5e3a-4796-b880-f79d88186b27.png">
</a>

---
<img width="526" alt="대지 1@4x 1" src="https://user-images.githubusercontent.com/46420281/227476808-80d481f2-a55f-4522-ba0e-efc7b8b7d8b4.png">

## ⚒ 아키텍처

| ReactorKit, RxFlow 기반의 MVVM-C 아키텍처
> **MVVM(ReactorKit)**
 ![image](https://user-images.githubusercontent.com/46420281/227477622-78ab297d-f315-4048-ae9b-e40e7d925272.png)
 - MVVM을 도입하여 View는 화면을 그리는데에 집중하고, ViewModel을 통해 Side Effect와 State를 처리하도록 했습니다.
 - UIKit 요소가 없어도 뷰에 보여질 값들을 ViewModel을 통해 단독으로 단위 테스트하여 확인하고 검증할 수 있게 했습니다.
> **Coordinator**
 - RxFlow를 사용하여 화면전환을 정의하고, ViewModel에서 Step을 통해 화면전환을 처리하도록 했습니다. 
 - 각 Flow에서 각 클래스의 생성과 의존성 주입을 구현하여, 클래스간 결합도를 낮추고 변경 가능성을 줄였습니다.
 
 
